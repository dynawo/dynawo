#!/usr/bin/python

# -*- coding: utf-8 -*-

# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

##
# Reader OMC : read the files created by omc and store needed informations
#

import sys
import itertools
import re
import json
import pprint
from xml.dom import minidom

import scriptVarExt
from dataContainer import *
from utils import *


# ##################################
# ##### Reading functions #####
# ##################################

nb_braces_opened = 0
stop_at_next_call = False
crossed_opening_braces = False

##
# Predicate for the reading of the body in functions in main c file
# @param element : current line reading
# @return @b False if we read the body, @b True else
def stop_reading_function(element):
    global nb_braces_opened
    global stop_at_next_call
    global crossed_opening_braces
    if stop_at_next_call and crossed_opening_braces : return False
    nb_braces_opened += count_opening_braces(element)
    nb_braces_opened -= count_closing_braces(element)
    if nb_braces_opened != 0 : crossed_opening_braces = True
    elif crossed_opening_braces : stop_at_next_call = True
    return True

##################################

##
# class ReaderOMC
#
class ReaderOMC:
    ##
    # Default contstructor
    # @param mod_name : model read
    # @param input_dir : directory where the files should be read
    # @param is_init_pb : @b True is we should read the init model
    def __init__(self, mod_name, input_dir, is_init_pb):
        ## model read
        self.mod_name = mod_name

        # -------------------
        # File to read
        # -------------------
        ## Full name of the _info.xml file
        # self.infoXmlFile = os.path.join (input_dir, self.mod_name + "_info.xml")
        # exist_file(self.infoXmlFile)

        ## Full name of the _info.json file
        self.info_json_file = os.path.join (input_dir, self.mod_name + "_info.json")
        exist_file(self.info_json_file)

        ## Full name of the _init.xml file
        self.init_xml_file = os.path.join (input_dir, self.mod_name + "_init.xml")
        exist_file(self.init_xml_file)

        ## Full name of the _model.h file
        self.model_header = os.path.join (input_dir, self.mod_name + "_model.h")
        exist_file(self.model_header)

        ## Full name of the .c file
        self.main_c_file = os.path.join (input_dir, self.mod_name + ".c")
        exist_file(self.main_c_file)

        ## Full name of the _08bnd.c file
        self._08bnd_c_file = os.path.join (input_dir, self.mod_name + "_08bnd.c")
        exist_file(self._08bnd_c_file)

        ## Full name of the _06inz.c file
        self._06inz_c_file = os.path.join (input_dir, self.mod_name + "_06inz.c")
        exist_file(self._06inz_c_file)

        ## Full name of the _05evt.c file
        self._05evt_c_file = os.path.join (input_dir, self.mod_name + "_05evt.c")
        exist_file(self._05evt_c_file)

        ## Full name of the _16dae.c file
        self._16dae_c_file = os.path.join (input_dir, self.mod_name + "_16dae.c")
        exist_file(self._16dae_c_file)
        ## Full name of the _16dae.h file
        self._16dae_h_file = os.path.join (input_dir, self.mod_name + "_16dae.h")
        exist_file(self._16dae_h_file)

        ## Full name of xml containing fictitious equations description
        self.eq_fictive_xml_file = os.path.join (input_dir, self.mod_name + ".extvar")

        ## Full name of the _structure.xml file
        self.struct_xml_file = os.path.join (input_dir, self.mod_name + "_structure.xml")
        if not is_init_pb : exist_file(self.struct_xml_file)

        ## Full name of the _functions.h file
        self._functions_header = os.path.join (input_dir, self.mod_name + "_functions.h")
        ## Full name of the _functions.c file
        self._functions_c_file  = os.path.join (input_dir, self.mod_name + "_functions.c")
        ## Full name of the _literals.h file
        self._literals_file = os.path.join (input_dir, self.mod_name + "_literals.h")
        ## Full name of the _literals.h file
        self._variables_file = os.path.join (input_dir, self.mod_name + "_variables.txt")

        # ---------------------------------------
        # Attribute for reading *_info.json file
        # ---------------------------------------
        ## Association between var evaluated and var used to evaluate
        self.map_vars_depend_vars = {}

        ## Association between var evaluated and index of the  function /equation in xml file
        self.map_num_eq_vars_defined = {}

        ## Association between the tag of the equation (when,assign,...) and the index of the function/equation
        self.map_tag_num_eq ={}

        ## List of number associated to linear equation
        self.linear_eq_nums = []

        ## List of number associated to non linear equation
        self.non_linear_eq_nums = []

        ## List of variables defined by initial equation
        self.initial_defined = []

        ## List of residual variables which computes a derivative values
        self.derivative_residual_vars = []
        ## List of residual variables which computes a derivative values
        self.assign_residual_vars = []
        ## List of auxiliary variables which are used in a variable equation
        self.auxiliary_var_to_keep = []
        self.auxiliary_vars_counted_as_variables = []


        # ---------------------------------------
        # Attribute for reading *_init.xml
        # ---------------------------------------
        ## List containing all variables found in *_init.xml file : differential/alegbraic/discrete variables and parameters
        self.list_vars = []


        # ---------------------------------------------
        # Attribute for reading xml file of fictitious equations
        # ---------------------------------------------
        ## list of fictitious continuous variables
        self.fictive_continuous_vars = []
        ## list of optional fictitious continuous variables
        self.fictive_optional_continuous_vars = []
        ## list of fictitious differential variables
        self.fictive_continuous_vars_der = []
        ## list of fictitious discrete variables
        self.fictive_discrete_vars = []


        # ---------------------------------------
        # Attribute for reading *_model.h file
        # ---------------------------------------
        ## Map associating var name and index in omc
        self.map_vars_num_omc = {}


        # ---------------------------------------
        # Attribute for reading main c file
        # ---------------------------------------
        ## Root name for functions to extract
        self.functions_root_name = mod_name + "_eqFunction_"

        ## Pattern to find function definition and retrieve num of the function
        self.ptrn_func_decl_main_c = re.compile(r'%s[ ]+%s(?P<num>\d+)\(.*\)[^;]$' % ("void", self.functions_root_name))

        ## Raw body of function  ..._setupDataStruc(...)
        self.setup_data_struc_raw_func = None

        ## Raw body of function ..._functionDAE(...)
        self.function_dae_raw_func = None


        # ---------------------------------------
        # Attribute for reading *_06inz.c file
        # ---------------------------------------
        ## Association between var name and initial value
        self.var_init_val_06inz = {}
        ## Association between var and external assignment
        self.var_init_val_06_extend = {}
        ## Association between var and function which initialise this variable
        self.var_num_init_val_06inz = {}
        ## Association between formula of an equation and index of the equation
        self.map_equation_formula = {}

        # ---------------------------------------
        # Attribute for reading *_16dae.c file
        # ---------------------------------------
        ## List of functions read in file
        self.list_func_16dae_c = []
        self.list_def_16dae_h  = []
        self.setup_dae_data_struc_raw_func = None
        self.auxiliary_vars_to_address_map = {}
        self.residual_vars_to_address_map = {}
        self.list_der_residual_vars_dae = {}

        # ---------------------------------------
        # Attribute for reading *_08bnd.c file
        # ---------------------------------------
        ## Association between variable and initial value
        self.var_init_val = {}
        ## List of warnings defined in this file
        self.warnings = []

        # ---------------------------------------------
        # reading zeroCrossings func in *_05evt.c file
        # ---------------------------------------------
        self.function_zero_crossings_raw_func = None
        self.function_zero_crossing_description_raw_func = None


        # ----------------------------------------------------------------------
        # Attribute for reading *_structure.xml file (containing elements and structures)
        # ----------------------------------------------------------------------
        ## List of elements found in file
        self.list_elements = []
        ## Association between struct name and struct definition
        self.map_struct_name_struct_obj = {}

        ## List of components contained in all structure
        self.list_compos_of_any_struct = []

        ## List of flow variables
        self.list_flow_vars = []


        # --------------------------------------------------------------------
        # Attribute for reading *_functions.h/.c file
        # --------------------------------------------------------------------
        ## List of external functions
        self.list_external_functions = []
        ## List of internal functions
        self.list_internal_functions = []
        ## List of omc functions
        self.list_omc_functions = []

        # --------------------------------------------------------------------
        # Attribute for reading *_literals.h file
        #---------------------------------------------------------------------
        ## List of literal definitions
        self.list_vars_literal = []

        # --------------------------------------------------------------------
        # Attribute for reading *_variables.txt file
        #---------------------------------------------------------------------
        self.nb_real_vars = 0
        self.nb_discrete_vars = 0
        self.nb_bool_vars = 0

    ##
    # Read a function in a file and try to identify a function thanks to a pattern
    # @param self : object pointer
    # @param file_to_read : file to read
    # @param ptrn_func_to_read : pattern to use to identify a function
    # @param func_name : name to use when creating the raw function
    #
    # @return the new raw function
    def read_function(self, file_to_read, ptrn_func_to_read, func_name):
        global nb_braces_opened
        global crossed_opening_braces
        global stop_at_next_call

        with open(file_to_read, 'r') as f:
            nb_braces_opened = 0
            crossed_opening_braces = False
            stop_at_next_call = False

            it = itertools.dropwhile(lambda line: ptrn_func_to_read.search(line) is None, f)
            next_iter = next(it, None) # Line on which "dropwhile" stopped
            if next_iter is None: return None # If we reach the end of the file, exit

            func = RawFunc()
            func.set_name(func_name)

            # "takewhile" only stops when the whole body of the function is read
            func.set_body( list(itertools.takewhile(stop_reading_function, it)) )

            return func

    ##
    # Read several functions in a file and try to identify them thanks to a pattern
    # @param self: object pointer
    # @param file_to_read : file to read
    # @param ptrn_func_to_read : pattern to use to identify a function
    # @param func_root_name : root name function to use when creating the raw function
    #
    # @return: a list of raw functions identified in the file
    def read_functions(self, file_to_read, ptrn_func_to_read, func_root_name):
        global nb_braces_opened
        global crossed_opening_braces
        global stop_at_next_call

        list_raw_func = []

        with open(file_to_read, 'r') as f:
            while True:
                nb_braces_opened = 0
                crossed_opening_braces = False
                stop_at_next_call = False

                it = itertools.dropwhile(lambda line: ptrn_func_to_read.search(line) is None, f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop

                func = RawFunc()

                match = re.search(ptrn_func_to_read, next_iter)
                num_omc = match.group('num')
                func.set_num_omc(num_omc)
                func.set_name(func_root_name + num_omc)

                # "takewhile" only stops when the whole body of the function is read
                func.set_body( list(itertools.takewhile(stop_reading_function, it)) )
                list_raw_func.append(func)
        return list_raw_func

    ##
    # Read the *_info.json file
    #
    # @param self : object pointer
    # @return
    def read_info_json(self):
        json_data=open(self.info_json_file).read()
        data = json.loads(json_data)
        nb_equations = len(data["equations"])
        for i in range(nb_equations):
            equation = data["equations"][i]
            keys =  equation.keys()
            type_eq = ""
            if "section" in keys:
                type_eq = equation["section"]

            tag_eq = ""
            if "tag" in keys:
                tag_eq = equation["tag"]

            if type_eq == "residuals" or  type_eq == "container" or type_eq == "start" or  type_eq == "parameter" or  (type_eq == "initial" and "system" in tag_eq):
                index = str(int(equation["eqIndex"]))
                display =""
                if "display" in keys:
                    display = equation["display"]

                # Retrieving numbers from linear equations
                if display == "linear":
                    self.linear_eq_nums.append(index)

                self.map_tag_num_eq[index]=str(tag_eq)

                # Retrieving numbers from nonlinear equations
                if display == "non-linear":
                    self.non_linear_eq_nums.append(index)

                # Get map [calculated var] --> [Func num / Eq in .xml]
                list_defined_vars=[]
                if "defines" in keys:
                    list_defined_vars = equation["defines"]
                    list_defined_vars = [s.encode('utf-8') for s in list_defined_vars]
                    for name in list_defined_vars :
                        if (index not in self.map_num_eq_vars_defined.keys()):
                            self.map_num_eq_vars_defined [index] = []
                        self.map_num_eq_vars_defined [index].append(name)

                # Get map [calculated var] --> [vars on which the equation depends]
                list_depend_vars=[]
                if "uses" in keys:
                    list_depend_vars = equation["uses"]
                    list_depend_vars = [s.encode('utf-8') for s in list_depend_vars]
                    for name in list_defined_vars :
                        self.map_vars_depend_vars[name] = list_depend_vars

                for name in list_defined_vars :
                    if self.is_residual_vars(name):
                        if "source" in keys:
                            source = equation["source"]
                            if "operations" in source.keys():
                                operations = source["operations"]
                                if "differentiate d/dtime" in str(operations):
                                    self.derivative_residual_vars.append(name)
                                    continue
                        self.assign_residual_vars.append(name)
            elif type_eq == "initial":
                list_defined_vars=[]
                if "defines" in keys:
                    list_defined_vars = equation["defines"]
                    list_defined_vars = [s.encode('utf-8') for s in list_defined_vars]
                    for name in list_defined_vars :
                        if name not in self.initial_defined: # if/else split in two in the json file
                            self.initial_defined.append(name)


    ##
    # Detect and add the auxiliary variables related to fictive equations to a dictionary
    # @param self : object pointer
    # @return
    def remove_fictitious_fequation(self):
        key_to_remove = []
        for dae_var in self.derivative_residual_vars:
            list_depend_vars = self.map_vars_depend_vars[dae_var]
            if len(list_depend_vars) == 1 and "der("+list_depend_vars[0]+")" in self.fictive_continuous_vars_der:
                key_to_remove.append(dae_var)
        for dae_var in key_to_remove:
            self.derivative_residual_vars.remove(dae_var)
        map_dep = self.get_map_dep_vars_for_func()
        for var in map_dep:
            if self.is_auxiliary_vars(var) :
                continue
            if self.is_residual_vars(var) and not self.is_der_residual_vars(var) and not self.is_assign_residual_vars(var):
                continue
            for deps in map_dep[var]:
                if self.is_auxiliary_vars(deps) and deps not in self.auxiliary_var_to_keep:
                    self.auxiliary_var_to_keep.append(deps)


    ##
    # getter for the map associating variables to variables used to evaluate them
    # @param self: object pointer
    # @return the map associating variavles and variables used to evaluate them
    def get_map_dep_vars_for_func(self):
        return self.map_vars_depend_vars

    def get_map_num_eq_vars_defined(self):
        return self.map_num_eq_vars_defined

    ##
    # getter for the map associating formuala of an equation and index of the equation
    # @param self : object pointer
    # @return the map associating formuala of an equation and index of the equation
    def get_map_equation_formula(self):
        return self.map_equation_formula

    ##
    # getter for the map associating tag of the function and the index of it
    # @param self : object pointer
    # @return the map associating tag of the function and the index of it
    def get_map_tag_num_eq(self):
        return self.map_tag_num_eq

    ##
    # Read the _init.xml file
    # @param self : object pointer
    # @return
    def read_init_xml(self):
        doc = minidom.parse(self.init_xml_file)
        root = doc.documentElement
        list_vars_xml = root.getElementsByTagName('ScalarVariable')
        for node in list_vars_xml:
            var = Variable()
            var.set_name(node.getAttribute('name'))
            var.set_variability(node.getAttribute('variability')) # "continuous", "discrete"
            var.set_causality(node.getAttribute('causality')) # "output" or "internal"

            class_type = node.getAttribute('classType')
            var.set_type(class_type)

            # Vars represented by an output var have an attribute
            # 'aliasVariable', which is the name of the output var
            if node.getAttribute('alias') == "alias":
                var.set_alias_name( node.getAttribute('aliasVariable'), False)
            if node.getAttribute('alias') == "negatedAlias":
                var.set_alias_name( node.getAttribute('aliasVariable'), True)


            # 'Start' attribute: this attribute is only assigned for real vars
            if var.get_type()[0] == "r":
                list_real = node.getElementsByTagName('Real')
                if len(list_real) != 1:
                    list_real = node.getElementsByTagName('Boolean')
                    if len(list_real) != 1:
                        print ("pb : read_init_xml real on variable " + var.get_name())
                        sys.exit()
                start = list_real[0].getAttribute('start')
                if start != '':
                    var.set_start_text( [start] )
                    var.set_use_start(list_real[0].getAttribute('useStart'))
                else:
                    var.set_use_start("false")
            # 'Start' attribute for integer vars
            elif var.get_type()[0] == "i":
                list_integer = node.getElementsByTagName('Integer')
                if len(list_integer) != 1:
                    print ("pb: read_init_xml int on variable " + var.get_name())
                    sys.exit()
                start = list_integer[0].getAttribute('start')
                if start != '':
                    var.set_start_text( [start] )
                    var.set_use_start(list_integer[0].getAttribute('useStart'))
                else:
                    var.set_use_start("false")
            # 'Start' attribute for boolean vars
            elif var.get_type()[0] =="b":
                list_boolean = node.getElementsByTagName('Boolean')
                if len(list_boolean) != 1:
                    print ("pb : read_init_xml bool on variable " + var.get_name())
                    sys.exit()
                start = list_boolean[0].getAttribute('start')
                if start != '':
                    var.set_start_text( [start] )
                    var.set_use_start(list_boolean[0].getAttribute('useStart'))
                else:
                    var.set_use_start("false")
            # 'Start' attribute for string vars
            elif var.get_type()[0] =="s":
                list_string = node.getElementsByTagName('String')
                if len(list_string) != 1:
                    print ("pb : read_init_xml string on variable " + var.get_name())
                    sys.exit()
                start = list_string[0].getAttribute('start')
                if start != '':
                    var.set_start_text( [start] )
                    var.set_use_start(list_string[0].getAttribute('useStart'))
                else:
                    var.set_use_start("false")

            # Vars after the read of *_init.xml
            self.list_vars.append(var)


    ##
    # Read the *.extvar defining the fictitious equations
    # @param self : object pointer
    # @return
    def read_eq_fictive_xml(self):
        # If this file does not exist, we exit
        if not os.path.isfile(self.eq_fictive_xml_file) :
            print ("Warning: extvar file of fictitious (external) variables does not exist...")
            return

        list_var_ext_continuous, list_var_ext_optional_continuous, list_var_ext_discrete, liste_var_ext_boolean = scriptVarExt.list_external_variables (self.eq_fictive_xml_file)

        for variable_id, default_value in list_var_ext_continuous:
            self.fictive_continuous_vars.append (variable_id)

        for variable_id, default_value in list_var_ext_discrete:
            self.fictive_discrete_vars.append (variable_id)

        for variable_id, default_value in liste_var_ext_boolean:
            self.fictive_discrete_vars.append (variable_id)

        for variable_id, default_value in list_var_ext_optional_continuous:
            self.fictive_optional_continuous_vars.append(variable_id)

        for name in self.fictive_continuous_vars:
          self.fictive_continuous_vars_der.append("der(%s)" % name)

        for name in self.fictive_optional_continuous_vars:
          self.fictive_continuous_vars_der.append("der(%s)" % name)

    ##
    # Give an omx index to variables stored in list_vars
    # @param self : object pointer
    # @return
    def give_num_omc_to_vars(self):
       for var in self.list_vars:
            name = var.get_name()
            val = find_value_in_map(self.map_vars_num_omc, name)
            if val is not None : var.set_num_omc(val)

    ##
    # Read the main c file
    # @param self: object pointer
    # @return
    def read_main_c(self):
        # Reading the function ..._setupDataStruc(...)
        file_to_read = self.main_c_file
        function_name = self.mod_name + "_setupDataStruc"
        ptrn_func_to_read = re.compile(r'%s[ ]+%s\(.*\)[^;]$' % ("void", function_name))
        self.setup_data_struc_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)

        # Reading function ..._functionDAE(...)
        file_to_read = self.main_c_file
        function_name = self.mod_name + "_functionDAE"
        ptrn_func_to_read = re.compile(r'%s[ ]+%s\(.*\)[^;]$' % ("int", function_name))
        self.function_dae_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)

    ##
    # Read the 16dae c file
    # @param self: object pointer
    # @return
    def read_16dae_c_file(self):
        # Reading of functions "..._eqFunction_${num}(...)"
        self.list_func_16dae_c = self.read_functions(self._16dae_c_file, self.ptrn_func_decl_main_c, self.functions_root_name)

        ptrn_comments = re.compile(r'equation index:[ ]*(?P<index>.*)[ ]*\n')
        comment_opening = "/*"
        comments_end = "*/"
        with open(self._16dae_c_file, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: comment_opening not in line, f)
                next_iter = next(it, None)
                if next_iter is None: break
                list_body = list(itertools.takewhile(lambda line: comments_end not in line, f))
                for line in list_body:
                    if ptrn_comments.search(line) is not None:
                        match = re.search(ptrn_comments, line)
                        index = match.group('index')
                        self.map_equation_formula[index] = list_body[-1].lstrip().strip('\n')
                        break


        # Reading the function ..._setupDataStruc(...)
        file_to_read = self._16dae_c_file
        function_name = self.mod_name + "_initializeDAEmodeData"
        ptrn_func_to_read = re.compile(r'%s[ ]+%s\(.*\)[^;]$' % ("int", function_name))
        self.setup_dae_data_struc_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)


    ##
    # Read the 16dae h file
    # @param self: object pointer
    # @return
    def read_16dae_h_file(self):
        # look for variables definitions
        auxiliary_var = r'#define \$P(?P<var>.*) data->simulationInfo->daeModeData->auxiliaryVars\[(?P<num>\d+)\]$'
        residuals_var = r'#define \$P(?P<var>.*) data->simulationInfo->daeModeData->residualVars\[(?P<num>\d+)\]$'
        with open(self._16dae_h_file, 'r') as f:
            for line in f:
                match = re.search(auxiliary_var, line)
                if match is not None:
                    self.auxiliary_vars_to_address_map[match.group("var")] = "data->simulationInfo->daeModeData->auxiliaryVars["+match.group("num")+"]"
                match = re.search(residuals_var, line)
                if match is not None:
                    self.residual_vars_to_address_map[match.group("var")] = "data->simulationInfo->daeModeData->residualVars["+match.group("num")+"]"

    ##
    # Read the *_06inz.c to find initial value of variables
    # @param self : object pointer
    # @return
    def read_06inz_c_file(self):
        global nb_braces_opened
        global crossed_opening_braces
        global stop_at_next_call

        # Find functions of type MODEL_NAME_eqFunction_N and variable assignment expressions
        # Regular expression to recognize a line of type var = rhs
        ptrn_assign_var = re.compile(r'^[ ]*data->localData(?P<var>\S*)[ ]*\/\* (?P<varName>[\w\$\.()\[\],]*) [\w(),\.]+ \*\/[ ]*=[ ]*(?P<rhs>[^;]+);')
        with open(self._06inz_c_file, 'r') as f:
            while True:
                nb_braces_opened = 0
                crossed_opening_braces = False
                stop_at_next_call = False

                it = itertools.dropwhile(lambda line: self.ptrn_func_decl_main_c.search(line) is None, f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop
                match = re.search(self.ptrn_func_decl_main_c, next_iter)
                num_function = match.group('num')

                # "takewhile" only stops when the whole body of the function is read
                list_body = list(itertools.takewhile(stop_reading_function, it))

                for line in list_body:
                    if ptrn_assign_var.search(line) is not None:
                        match = re.search(ptrn_assign_var, line)
                        var = str(match.group('varName'))
                        rhs = match.group('rhs')
                        # rejection of inits of type var = ..atribute and integerVarsPre vars
                        if 'attribute' not in rhs and 'VarsPre' not in rhs and 'aux_x' not in rhs and "linearSystemData" not in rhs:
                            self.var_init_val_06inz[ var ] = list_body
                            self.var_num_init_val_06inz[var] = num_function
                            break

        ptrn_comments = re.compile(r'equation index:[ ]*(?P<index>.*)[ ]*\n')
        comments_opening = "/*"
        comments_end = "*/"
        with open(self._06inz_c_file, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: comments_opening not in line, f)
                next_iter = next(it, None)
                if next_iter is None: break
                list_body = list(itertools.takewhile(lambda line: comments_end not in line, f))
                for line in list_body:
                    if ptrn_comments.search(line) is not None:
                        match = re.search(ptrn_comments, line)
                        index = match.group('index')
                        self.map_equation_formula[index] = list_body[-1].lstrip().strip('\n')
                        break


        # Look for MODEL_initial_residual type functions due to extend commands
        extend_function_name = "_initial_residual(DATA *data, double *initialResiduals)"
        extend_assign_var = "initialResiduals[i++]"
        with open(self._06inz_c_file, 'r') as f:
            while True:
                nb_braces_opened = 0
                crossed_opening_braces = False
                stop_at_next_call = False

                it = itertools.dropwhile(lambda line: extend_function_name not in line, f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop

                # "takewhile" only stops when the whole body of the function is read
                list_body = list(itertools.takewhile(stop_reading_function, it))

                for line in list_body:
                    if extend_assign_var in line:
                        # extract the part of the line related to the assignment
                        sub_line = line[line.index(extend_assign_var) + len(extend_assign_var) + 3:]
                        index_plus = 99999
                        index_minus = 99999
                        if ("+" in sub_line and "-" in sub_line):
                            index_plus = sub_line.index("+")
                            index_minus = sub_line.index("-")
                        elif ("+" in sub_line and "-" not in sub_line):
                            index_plus = sub_line.index("+")
                        elif ("+" not in sub_line and "-" in sub_line):
                            index_minus = sub_line.index("-")

                        var = "" # variable to assign
                        assignment = "" # assignment
                        if "(" in sub_line:
                            var = sub_line [sub_line.index("(") + 1 : min(index_plus, index_minus)]

                            if (index_plus < index_minus):
                                assignment += "(-1) * ("

                            assignment += sub_line [min(index_plus, index_minus) + 1 : sub_line.index(";") - 1]

                            if (index_plus < index_minus):
                                assignment += ")"

                        elif ("+" not in sub_line and "-" not in sub_line):
                            if ("*" in sub_line or "/" in sub_line):
                                print("error during equations export due to extends")
                                sys.exit(1)

                            # where we use extends (x = 0)
                            var = sub_line [:sub_line.index(";")]
                            assignment = "0"

                        # the assignment line is composed of:
                        # spaces for indentation
                        # the name of the variable to assign
                        # the assignment formula
                        # the end of line
                        new_line = line [:line.index(extend_assign_var)] + var + " = " + assignment + ";"
                        self.var_init_val_06_extend [var] = new_line

        ptrn_comments = re.compile(r'equation index:[ ]*(?P<index>.*)[ ]*\n')
        with open(self._06inz_c_file, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: comments_opening not in line, f)
                next_iter = next(it, None)
                if next_iter is None: break
                list_body = list(itertools.takewhile(lambda line: comments_end not in line, f))
                for line in list_body:
                    if ptrn_comments.search(line) is not None:
                        if "matrix" in list_body[-1]:
                            match = re.search(ptrn_comments, line)
                            index = match.group('index')
                            it_var = itertools.dropwhile(lambda line: "var" not in line, list_body)
                            xmlstring = '<equations>' + ''.join(list(it_var)) + '</equations>'
                            self.map_equation_formula[index] = ' '.join(xmlstring.split()).replace('"', "'")
                        break

    ##
    # Initialise variables in list_vars by values found in 06inz file
    # @param self : object pointer
    # @return
    def set_start_value_for_syst_vars_06inz(self):
        for key, value in self.var_init_val_06inz.iteritems():
            for var in self.list_vars:
                if var.get_name() == key:
                    var.set_start_text_06inz(value)
                    var.set_init_by_param_in_06inz(True)
                    var.set_num_func_06inz(self.var_num_init_val_06inz[var.get_name()])

        for var_name, var_assignment in self.var_init_val_06_extend.iteritems():
            for var in self.list_vars:
                if var.get_name() == var_name:
                    var.set_start_text_06inz(['{/n', var_assignment, '}'])
                    var.set_init_by_extend_in_06inz(True)


    ##
    # Read the *_08nbd.c to find initial value of variables
    # @param self : object pointer
    # @return
    def read_08bnd_c_file(self):
        global nb_braces_opened
        global crossed_opening_braces
        global stop_at_next_call
        # Regular expression to recognize a line of type $Pvar = $Prhs
        ptrn_assign_var = re.compile(r'^[ ]*data->modelData->(?P<var>\S*)\.attribute[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w(),\.]+ \*\/.start[ ]*=[^;]*;$')
        ptrn_param = re.compile(r'data->simulationInfo->(?P<var>\S*)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) PARAM \*\/[ ]*=[^;]*;')
        ptrn_param_boolean_test = re.compile(r'data->simulationInfo->(?P<var>\S*)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) PARAM \*\/[ ]*==[^;]*;')
        ptrn_assign_auxiliary_var = re.compile(r'^[ ]*data->localData(?P<var>\S*)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w(),\.]+ \*\/[ ]*=[^;]*;')

        with open(self._08bnd_c_file, 'r') as f:
            while True:
                nb_braces_opened = 0
                crossed_opening_braces = False
                stop_at_next_call = False

                it = itertools.dropwhile(lambda line: self.ptrn_func_decl_main_c.search(line) is None, f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop

                # "takewhile" only stops when the whole body of the function is read
                list_body = list(itertools.takewhile(stop_reading_function, it))

                for line in list_body:
                    if ptrn_assign_var.search(line) is not None:
                        match = re.search(ptrn_assign_var, line)
                        var = match.group('varName')
                        self.var_init_val[ var ] = list_body
                    if ptrn_param.search(line) is not None and ptrn_param_boolean_test.search(line) is None:
                        match = re.search(ptrn_param, line)
                        var = match.group('varName')
                        self.var_init_val[ var ] = list_body
                    if ptrn_assign_auxiliary_var.search(line) is not None:
                        match = re.search(ptrn_assign_auxiliary_var, line)
                        var = match.group('varName')
                        self.var_init_val[ var ] = list_body

                for line in list_body:
                    if 'omc_assert_warning_withEquationIndexes(' in line:
                        self.warnings.append(list_body)

        ptrn_comments = re.compile(r'\sequation index:[ ]*(?P<index>.*)[ ]*\n')
        comments_opening = "/*"
        comments_end = "*/"
        with open(self._08bnd_c_file, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: comments_opening not in line, f)
                next_iter = next(it, None)
                if next_iter is None: break
                list_body = list(itertools.takewhile(lambda line: comments_end not in line, f))
                for line in list_body:
                    if ptrn_comments.search(line) is not None:
                        match = re.search(ptrn_comments, line)
                        index = match.group('index')
                        self.map_equation_formula[index] = list_body[-1].lstrip().strip('\n')
                        break

    ##
    #  Initialise variables in list_vars by values found in 08bnd file
    # @param self : object pointer
    # @return
    def set_start_value_for_syst_vars(self):
        for key, value in self.var_init_val.iteritems():
            for var in self.list_vars:
                if var.get_name() == key:
                    var.set_start_text(value)
                    var.set_init_by_param(True) # Indicates that the var is initialized with a param

    ##
    # Read *_05evt.c file, and try to find declarations of zeroCrossing functions :
    # @param self : object pointer
    # @return
    def read_05evt_c_file(self):
        # Reading body of *_function_ZeroCrossings(...) function
        file_to_read = self._05evt_c_file
        function_name = self.mod_name + "_function_ZeroCrossings"

        ptrn_func_to_read = re.compile(r'%s[ ]+%s\(.*\)[^;]$' % ("int", function_name))
        self.function_zero_crossings_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)

        function_name = self.mod_name + "_zeroCrossingDescription"
        ptrn_func_to_read = re.compile(r'%s[ ]+[*]+%s\(.*\)[^;]$' % ("const char", function_name))
        self.function_zero_crossing_description_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)


    ##
    # read _structure.xml file
    # @param self : object pointer
    # @return
    def read_struct_xml_file(self):
        doc = minidom.parse(self.struct_xml_file)
        root = doc.documentElement
        # read file structures
        elements = root.getElementsByTagName('elements')

        # list of structures/terminals encountered during reading
        list_struct = []
        self.list_elements=[]
        if(len(elements) > 0 ):
            for node_element in elements:
                # reading structures
                nodes_struct = node_element.getElementsByTagName('struct')
                for node in nodes_struct:
                    struct_name = node.getElementsByTagName('name')[0].firstChild.nodeValue
                    node_terminal = node.getElementsByTagName('terminal')[0]
                    name_terminal = node_terminal.getElementsByTagName('name')[0].firstChild.nodeValue
                    connector_node =  node_terminal.getElementsByTagName('connector')[0]
                    type_connector = str(connector_node.getAttribute('type'))
                    compo_name=struct_name + "."+name_terminal

                    # we store all this in an object
                    structure = Element(True,struct_name,len(self.list_elements))
                    if struct_name not in list_struct:
                        list_struct.append(struct_name)
                        self.list_elements.append(structure)
                        self.map_struct_name_struct_obj[struct_name] = structure
                    else:
                        structure =  self.map_struct_name_struct_obj[struct_name]

                    # terminal name can be composed of a sub-structure (or several) and the actual name of the terminal
                    split_name = name_terminal.split('.')
                    struct_name1 = struct_name
                    structure1 = structure
                    if(len(split_name)>1): #terminal is composed of substructure:
                        list_of_structure=split_name[0:len(split_name)-1]
                        for struct in list_of_structure:
                            struct_name1=struct_name1+"."+struct
                            if struct_name1 not in list_struct:
                                s =  Element(True, struct_name1, len(self.list_elements));
                                list_struct.append(struct_name1)
                                self.list_elements.append(s)
                                self.map_struct_name_struct_obj[struct_name1] = s
                                structure1.list_elements.append(s)
                                structure1=s
                            else:
                                structure1 = self.map_struct_name_struct_obj[struct_name1]

                    terminal = Element(False, compo_name, len(self.list_elements))
                    self.list_elements.append(terminal)
                    structure1.list_elements.append(terminal)

                    #Find vars that are "flow"
                    if type_connector == "Flow" :  self.list_flow_vars.append(compo_name)

                # reading terminals
                for child in node_element.childNodes:
                    if child.nodeType== child.ELEMENT_NODE and child.localName=='terminal':
                        name = child.getElementsByTagName('name')[0].firstChild.nodeValue
                        connector_node =  child.getElementsByTagName('connector')[0]
                        type_connector = str(connector_node.getAttribute('type'))

                        split_name = name.split('.')
                        name_terminal=name
                        struct_name1 =""
                        structure1 = Element(True,"")
                        if (len(split_name)> 1): #component name: terminal name: last in the list, the rest is a composite of structures
                            list_of_structure=split_name[0:len(split_name)-1]
                            for struct in list_of_structure:
                                if struct_name1 != "":
                                    struct_name1=struct_name1+"."+struct
                                else:
                                    struct_name1 = struct
                                if struct_name1 not in list_struct:
                                    s =  Element(True,struct_name1,len(self.list_elements));
                                    list_struct.append(struct_name1)
                                    self.list_elements.append(s)
                                    self.map_struct_name_struct_obj[struct_name1] = s
                                    structure1.list_elements.append(s)
                                    structure1=s
                                else:
                                    structure1 = self.map_struct_name_struct_obj[struct_name1]

                        terminal = Element(False,name_terminal,len(self.list_elements))
                        self.list_elements.append(terminal)
                        structure1.list_elements.append(terminal)

                        #Find vars that are "flow"
                        if type_connector == "Flow" :  self.list_flow_vars.append(name)


    ##
    # Read _functions.h file and store internal/external functions declaration
    # @param self : object pointer
    # @return
    def read_functions_header(self):
        ptrn_func_extern = re.compile(r'extern .*;')
        ptrn_func = re.compile(r'.*;')
        ptrn_not_func = re.compile(r'static const MMC_.*;')
        ptrn_struct = re.compile(r'.*typedef struct .* {.*')

        file_to_read = self._functions_header
        if not os.path.isfile(file_to_read) :
            return

        with open(file_to_read,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: ptrn_func_extern.search(line) is None, f)
                next_iter = next(it,None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop
                self.list_external_functions.append(next_iter)

        with open(file_to_read,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: (ptrn_func.search(line) is None) and (ptrn_struct.search(line) is None), f)
                next_iter = next(it,None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop
                if next_iter not in self.list_external_functions and ptrn_not_func.search(next_iter) is None:
                        self.list_internal_functions.append(next_iter)


    ##
    # Read *_literals.h file and store all string declaration with type '_OMC_LIT'
    # @param self : object pointer
    # @return
    def read_literals_h_file(self):
        file_to_read = self._literals_file
        if not os.path.isfile(file_to_read):
            return

        ptrn_var = re.compile(r'#define _OMC_LIT.*')
        ptrn_var1 = re.compile(r'static const MMC_DEFSTRINGLIT*')
        ptrn_var2 = re.compile(r'static const modelica_integer _OMC_LIT.*')

        with open(file_to_read,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: (ptrn_var.search(line) is None) and (ptrn_var1.search(line) is None)\
                                         and (ptrn_var2.search(line) is None), f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop

                self.list_vars_literal.append(next_iter)

    ##
    # Read *_literals.h file and store all string declaration with type '_OMC_LIT'
    # @param self : object pointer
    # @return
    def read_variables_txt_file(self):
        file_to_read = self._variables_file
        if not os.path.isfile(file_to_read):
            return

        ptrn_var = re.compile(r'type: (?P<type>.*) index: (?P<index>.*): (?P<name>.*) \(.* valueType: (?P<valueType>.*) initial:.*')
        index_real_var = 0
        index_derivative_var = 0
        index_discrete_var = 0
        index_boolean_vars = 0
        index_real_param= 0
        index_aux_var= 0
        with open(file_to_read,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: (ptrn_var.search(line) is None), f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop
                match = re.search(ptrn_var, next_iter)
                type = match.group("type")
                index = match.group("index")
                name = match.group("name")
                if "$cse" in name:
                    map_var_name_2_addresses[name]= "data->simulationInfo->daeModeData->auxiliaryVars["+str(index_aux_var)+"]"
                    index_aux_var+=1
                    self.auxiliary_vars_to_address_map[name.replace("$cse","cse")] = map_var_name_2_addresses[name]
                    self.auxiliary_vars_counted_as_variables.append(name)
                elif re.search(r'stateVars \([0-9]+\)',type) or re.search(r'algVars \([0-9]+\)',type):
                    map_var_name_2_addresses[name]= "data->localData[0]->realVars["+str(index_real_var)+"]"
                    index_real_var+=1
                elif type == "discreteAlgVars":
                    map_var_name_2_addresses[name]= "data->localData[0]->discreteVars["+str(index_discrete_var)+"]"
                    index_discrete_var+=1
                elif type == "derivativeVars":
                    map_var_name_2_addresses[name]= "data->localData[0]->derivativesVars["+str(index_derivative_var)+"]"
                    map_var_name_2_addresses[name.replace("$DER.","der(")+")"]= map_var_name_2_addresses[name]
                    index_derivative_var+=1
                elif type == "constVars":
                    map_var_name_2_addresses[name]= "SHOULD NOT BE USED"
                elif type == "intAlgVars":
                    map_var_name_2_addresses[name]= "data->localData[0]->integerDoubleVars["+index+"]"
                elif type == "boolAlgVars":
                    if "$whenCondition" in name:
                        map_var_name_2_addresses[name]= "data->localData[0]->booleanVars["+str(index_boolean_vars)+"]"
                        index_boolean_vars+=1
                    else:
                        map_var_name_2_addresses[name]= "data->localData[0]->discreteVars["+str(index_discrete_var)+"]"
                        index_discrete_var+=1
                elif type == "paramVars" or type == "boolParamVars":
                    map_var_name_2_addresses[name]= "data->simulationInfo->realParameter["+str(index_real_param)+"]"
                    index_real_param+=1
                elif type == "intParamVars":
                    map_var_name_2_addresses[name]= "data->simulationInfo->integerParameter["+index+"]"
                elif type == "stringParamVars":
                    map_var_name_2_addresses[name]= "data->simulationInfo->stringParameter["+index+"]"
                test_param_address(name)
        self.nb_real_vars = index_real_var
        self.nb_discrete_vars = index_discrete_var
        self.nb_bool_vars = index_boolean_vars

    ##
    # Read *_functions.c file and store all functions' body declared
    # @param self : object pointer
    # @return
    def read_functions_c_file(self):
        file_to_read = self._functions_c_file
        if not os.path.isfile(file_to_read) :
            return

        global nb_braces_opened
        global crossed_opening_braces
        global stop_at_next_call
        ptrn_func = re.compile(r'^(?![\/]).* (?P<var>.*)\(.*\)')
        with open(file_to_read, 'r') as f:
            while True:
                nb_braces_opened = 0
                crossed_opening_braces = False
                stop_at_next_call = False

                it = itertools.dropwhile(lambda line: ptrn_func.search(line) is None, f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop

                match = re.search(ptrn_func, next_iter)

                if ";" not in next_iter: # it is a function declaration
                    func = RawOmcFunctions()
                    func.set_name(match.group('var'))
                    func.set_signature(next_iter)
                    func.set_return_type(next_iter.split()[0])

                    # "takewhile" only stops when the whole body of the function is read
                    func.set_body( list(itertools.takewhile(stop_reading_function, it)) )
                    self.list_omc_functions.append(func)
    ##
    # return True if the variable is an auxiliary var
    # @param self : object pointer
    # @param var_name : variable name to test
    # @return True if the variable is an auxiliary var
    def is_auxiliary_vars(self, var_name):
        return var_name in self.auxiliary_vars_to_address_map.keys()
    ##
    # return True if the variable is a residual var
    # @param self : object pointer
    # @param var_name : variable name to test
    # @return True if the variable is a residual var
    def is_residual_vars(self, var_name):
        return var_name in self.residual_vars_to_address_map.keys()
    ##
    # return True if the variable is a residual derivative (not fictive) var
    # @param self : object pointer
    # @param var_name : variable name to test
    # @return True if the variable is a residual derivative (not fictive) var
    def is_der_residual_vars(self, var_name):
        return var_name in self.derivative_residual_vars
    ##
    # return True if the variable is a residual (not fictive) assignment var
    # @param self : object pointer
    # @param var_name : variable name to test
    # @return True if the variable is a residual (not fictive) assignment var
    def is_assign_residual_vars(self, var_name):
        return var_name in self.assign_residual_vars


