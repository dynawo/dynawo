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

import os
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
    def __init__(self, mod_name, input_dir, is_init_pb, disable_calc_var_gen):
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
        ## List of constant strings literal names
        self.list_of_stringconstants = []
        ## Full name of the _literals.h file
        self._variables_file = os.path.join (input_dir, self.mod_name + "_variables.txt")

        ## Regular expression to identify functions
        self.regular_expr_function_name = r'%s[ ]+%s\(.*\)[^;]$'
        ## Regular expression to identify equation index given in comments above omc functions
        self.regular_expr_equation_index = r'equation index:[ ]*(?P<index>.*)[ ]*\n'

        # ---------------------------------------
        # Attribute for reading *_info.json file
        # ---------------------------------------
        ## Association between var evaluated and var used to evaluate
        self.map_vars_depend_vars = {}

        ## Association between var evaluated and index of the  function /equation in xml file
        self.map_num_eq_vars_defined = {}

        ## Association between the tag of the equation (when,assign,...) and the index of the function/equation
        self.map_tag_num_eq ={}

        ## List of variables defined by initial equation
        self.initial_defined = []

        ## List of silent discrete variables
        self.silent_discrete_vars = []

        ## List of residual variables which computes a derivative values
        self.derivative_residual_vars = []
        ## List of residual variables which computes a derivative values
        self.assign_residual_vars = []
        ## List of auxiliary variables which are used in a variable equation
        self.auxiliary_var_to_keep = []
        self.auxiliary_vars_counted_as_variables = []

        ## activation of calculated variables automatic generation
        self.disable_generate_calc_vars = disable_calc_var_gen
        ## List of calculated variables
        self.list_calculated_vars = []
        self.dic_calculated_vars_values = {}
        ## List of const real variables with a complex initialization
        self.list_complex_const_vars = []
        ## Dictionary of calculated variables depending on others variables to the associated function
        self.list_complex_calculated_vars = {}


        # ---------------------------------------
        # Attribute for reading *_init.xml
        # ---------------------------------------
        ## List containing all variables found in *_init.xml file : differential/alegbraic/discrete variables and parameters
        self.list_vars = []
        ## Dictionnary containing all variables names from self.list_vars and their index
        self.dic_vars = {}


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

        # ---------------------------------------------
        # reading updateRelations func in *_05evt.c file
        # ----------------------------------------------
        self.function_update_relations_raw_func = None

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
        self.nb_integer_vars = 0
        self.external_objects = []

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

                self.map_tag_num_eq[index]=str(tag_eq)

                # Get map [calculated var] --> [Func num / Eq in .xml]
                list_defined_vars=[]
                if "defines" in keys:
                    list_defined_vars = equation["defines"]
                    for name in list_defined_vars :
                        if (index not in self.map_num_eq_vars_defined.keys()):
                            self.map_num_eq_vars_defined [index] = []
                        self.map_num_eq_vars_defined [index].append(name)

                # Get map [calculated var] --> [vars on which the equation depends]
                list_depend_vars=[]
                if "uses" in keys:
                    list_depend_vars = equation["uses"]
                    for name in list_defined_vars :
                        self.map_vars_depend_vars[name] = list_depend_vars

                for name in list_defined_vars :
                    if self.is_residual_vars(name):
                        if "equation" in keys:
                            eq = equation["equation"]
                            if "der(" in str(eq) or "der (" in str(eq):
                                self.derivative_residual_vars.append(name)
                                continue
                        self.assign_residual_vars.append(name)
            elif type_eq == "initial":
                list_defined_vars=[]
                if "defines" in keys:
                    list_defined_vars = equation["defines"]
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
        for (index, tag) in self.map_tag_num_eq.items():
            if tag == "algorithm" and index in self.map_equation_formula:
                #self.auxiliary_vars_to_address_map
                for aux_var_name in self.auxiliary_vars_to_address_map:
                    if aux_var_name in self.map_equation_formula[index] and deps not in self.auxiliary_var_to_keep:
                        self.auxiliary_var_to_keep.append(aux_var_name)



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
    # Retrieve the variable from its name
    # @param self : object pointer
    # @param name : name of the variable to find
    # @return the variable with this name or None if not found
    def find_variable_from_name(self, name):
        if name in self.dic_vars:
            return self.list_vars[self.dic_vars[name]]
        return None

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
                fixed = list_real[0].getAttribute('fixed')
                var.set_fixed(fixed == "true" or var.get_variability() == "parameter")
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
                fixed = list_integer[0].getAttribute('fixed')
                var.set_fixed(fixed == "true" or var.get_variability() == "parameter")
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
                fixed = list_boolean[0].getAttribute('fixed')
                var.set_fixed(fixed == "true" or var.get_variability() == "parameter")
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
                fixed = list_string[0].getAttribute('fixed')
                var.set_fixed(fixed == "true" or var.get_variability() == "parameter")
                if start != '':
                    var.set_start_text( [start] )
                    var.set_use_start(list_string[0].getAttribute('useStart'))
                else:
                    var.set_use_start("false")

            # Vars after the read of *_init.xml
            self.list_vars.append(var)
            self.dic_vars[var.get_name()] = len(self.list_vars) - 1

        ## Need to go over again to propagate fixed property: an alias on a fixed variable should be set as fixed
        modified = True
        while modified:
            modified = False
            for var in self.list_vars:
                if var.get_alias_name() != "":
                    alias_var = self.find_variable_from_name(var.get_alias_name())
                    assert(alias_var != None)
                    if alias_var.is_fixed() and not var.is_fixed():
                        var.set_fixed(True)
                        print_info("variable " + var.get_name() + " is considered as fixed (alias of fixed variable " + var.get_alias_name()+").")
                        modified = True
                    if is_discrete_real_var(var) and ((is_real_var(alias_var)  and not alias_var.is_fixed()) or is_der_real_var(alias_var)):
                        error_msg = "    Error: Found an alias that assigns the continuous variable " + alias_var.get_name()+\
                            " to the discrete real variable " + var.get_name() +\
                            " outside of the scope of a when or a if. Please rewrite the equation or check that you didn't connect a zPin to a ImPin.\n"
                        error_exit(error_msg)

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
    # Read the main c file
    # @param self: object pointer
    # @return
    def read_main_c(self):
        # Reading the function ..._setupDataStruc(...)
        file_to_read = self.main_c_file
        function_name = self.mod_name + "_setupDataStruc"
        ptrn_func_to_read = re.compile(self.regular_expr_function_name % ("void", function_name))
        self.setup_data_struc_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)

        # Reading function ..._functionDAE(...)
        file_to_read = self.main_c_file
        function_name = self.mod_name + "_functionDAE"
        ptrn_func_to_read = re.compile(self.regular_expr_function_name % ("int", function_name))
        self.function_dae_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)

    ##
    # Read the 16dae c file
    # @param self: object pointer
    # @return
    def read_16dae_c_file(self):
        # Reading of functions "..._eqFunction_${num}(...)"
        self.list_func_16dae_c = self.read_functions(self._16dae_c_file, self.ptrn_func_decl_main_c, self.functions_root_name)

        ptrn_comments = re.compile(self.regular_expr_equation_index)
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
        ptrn_func_to_read = re.compile(self.regular_expr_function_name % ("int", function_name))
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
        ptrn_param = re.compile(r'^[ ]*data->simulationInfo->(?P<var>\S*)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) PARAM \*\/[ ]*=[ ]*(?P<rhs>[^;]+);')
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
                    if ptrn_param.search(line) is not None:
                        match = re.search(ptrn_param, line)
                        var = str(match.group('varName'))
                        rhs = match.group('rhs')
                        # rejection of inits of type var = ..atribute and integerVarsPre vars
                        if 'attribute' not in rhs and 'VarsPre' not in rhs and 'aux_x' not in rhs and "linearSystemData" not in rhs:
                            self.var_init_val_06inz[ var ] = list_body
                            self.var_num_init_val_06inz[var] = num_function

                for line in list_body:
                    if 'omc_assert_warning' in line:
                        self.warnings.append(list_body)

        ptrn_comments = re.compile(self.regular_expr_equation_index)
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

        ptrn_comments = re.compile(self.regular_expr_equation_index)
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
        for key, value in self.var_init_val_06inz.items():
            for var in self.list_vars:
                if var.get_name() == key:
                    var.set_start_text_06inz(value)
                    var.set_init_by_param_in_06inz(True)
                    var.set_num_func_06inz(self.var_num_init_val_06inz[var.get_name()])

        for var_name, var_assignment in self.var_init_val_06_extend.items():
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
        ptrn_assign_extobjs = re.compile(r'^[ ]*data->simulationInfo->extObjs\[(?P<var>[0-9]+)\][ ]*=[^;]*;$')

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
                    if ptrn_assign_extobjs.search(line) is not None:
                        match = re.search(ptrn_assign_extobjs, line)
                        var_add = "data->simulationInfo->extObjs["+match.group('var')+"]"
                        for var_name, address in map_var_name_2_addresses.items():
                            if address == var_add:
                                self.var_init_val[ var_name ] = list_body
                                break

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
        for key, value in self.var_init_val.items():
            for var in self.list_vars + self.external_objects:
                if var.get_name() == key:
                    var.set_start_text(value)
                    var.set_init_by_param(True) # Indicates that the var is initialized with a param

    ##
    # Read *_05evt.c file, and try to find declarations of zeroCrossing and updateRelation functions :
    # @param self : object pointer
    # @return
    def read_05evt_c_file(self):
        # Reading body of *_function_ZeroCrossings(...) function
        file_to_read = self._05evt_c_file
        function_name = self.mod_name + "_function_ZeroCrossings"

        ptrn_func_to_read = re.compile(self.regular_expr_function_name % ("int", function_name))
        self.function_zero_crossings_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)

        function_name = self.mod_name + "_zeroCrossingDescription"
        ptrn_func_to_read = re.compile(r'%s[ ]+[*]+%s\(.*\)[^;]$' % ("const char", function_name))
        self.function_zero_crossing_description_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)

        function_name = self.mod_name + "_function_updateRelations"
        ptrn_func_to_read = re.compile(self.regular_expr_function_name % ("int", function_name))
        self.function_update_relations_raw_func = self.read_function(file_to_read, ptrn_func_to_read, function_name)

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
        ptrn_table_size= re.compile(r'static _index_t _OMC_LIT[0-9]+_dims*')
        ptrn_table= re.compile(r'static base_array_t const _OMC_LIT*')

        with open(file_to_read,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: (ptrn_var.search(line) is None) and (ptrn_var1.search(line) is None)\
                                         and (ptrn_var2.search(line) is None) and (ptrn_table_size.search(line) is None), f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop

                self.list_vars_literal.append(next_iter)
                if '#define' in next_iter and "_data" in next_iter:
                    self.list_of_stringconstants.append(next_iter.split()[1].replace("_data",""))

        with open(file_to_read,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: (ptrn_table.search(line) is None), f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop

                table_declaration = ""
                while not "};" in next_iter:
                    table_declaration+=next_iter
                    next_iter = next(it, None)
                table_declaration+=next_iter
                self.list_vars_literal.append(table_declaration)
                next(it, None)

    ##
    # Read *_literals.h file and store all string declaration with type '_OMC_LIT'
    # Requires self.list_vars to be ready
    # @param self : object pointer
    # @return
    def read_variables_txt_file(self):
        file_to_read = self._variables_file
        if not os.path.isfile(file_to_read):
            return

        index_extobjs = 0
        ptrn_var = re.compile(r'type: (?P<type>.*) index: (?P<index>.*): (?P<name>.*) \(.* valueType: (?P<valueType>.*) initial:.*')
        alternative_way_to_declare_der = "$DER."
        with open(file_to_read,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: (ptrn_var.search(line) is None), f)
                next_iter = next(it, None) # Line on which "dropwhile" stopped
                if next_iter is None: break # If we reach the end of the file, exit loop
                match = re.search(ptrn_var, next_iter)
                type = match.group("type")
                name = match.group("name")
                var = self.find_variable_from_name(name)
                if "$cse" in name:
                    map_var_name_2_addresses[name]= "auxiliaryVars"
                elif  is_ignored_var(name):
                    map_var_name_2_addresses[name]= "SHOULD NOT BE USED - IGNORED VAR"
                elif type == "derivativeVars" or "$DER" in name:
                    map_var_name_2_addresses[name]= "derivativesVars"
                    map_var_name_2_addresses[name.replace(alternative_way_to_declare_der,"der(")+")"]= map_var_name_2_addresses[name]
                elif re.search(r'stateVars \([0-9]+\)',type) or re.search(r'algVars \([0-9]+\)',type):
                    if not var.is_fixed():
                        map_var_name_2_addresses[name]= "realVars"
                    else:
                        map_var_name_2_addresses[name]= "constVars"
                elif type == "discreteAlgVars":
                    map_var_name_2_addresses[name]= "discreteVars"
                elif type == "constVars":
                    map_var_name_2_addresses[name]= "SHOULD NOT BE USED - CONST VAR"
                elif type == "intAlgVars":
                    map_var_name_2_addresses[name]= "integerDoubleVars"
                elif type == "boolAlgVars":
                    if is_when_condition(name):
                        map_var_name_2_addresses[name]= "booleanVars"
                    else:
                        map_var_name_2_addresses[name]= "discreteVars"
                elif type == "aliasVars":
                    # fixed discrete real vars are not aliased and are initialized in Y0
                    if is_discrete_real_var(var) and var.is_fixed():
                        map_var_name_2_addresses[name]= "discreteVars"
                    # Aliased non-fixed vars should never be used in equations independently from their type
                    elif not var.is_fixed():
                        map_var_name_2_addresses[name]= "SHOULD NOT BE USED - CONTINUOUS ALIAS VAR"
                    # fixed real vars goes into the const var mechanism (either replaced by their alias if they are in the form a = b, or initialized in Y0 if more complex)
                    else:
                        map_var_name_2_addresses[name]= "constVars"
                elif type == "intAliasVars":
                    if var.is_fixed():
                        map_var_name_2_addresses[name]= "integerDoubleVars"
                    else:
                        map_var_name_2_addresses[name]= "SHOULD NOT BE USED - INT ALIAS VAR"
                elif type == "boolAliasVars":
                    if var.is_fixed():
                        map_var_name_2_addresses[name]= "discreteVars"
                    else:
                        map_var_name_2_addresses[name]= "SHOULD NOT BE USED - BOOL ALIAS VAR"
                elif type == "intConstVars":
                    map_var_name_2_addresses[name]= "constVars"
                elif type == "paramVars" or type == "boolParamVars":
                    map_var_name_2_addresses[name]= "realParameter"
                elif type == "intParamVars":
                    map_var_name_2_addresses[name]= "integerParameter"
                elif type == "stringParamVars":
                    map_var_name_2_addresses[name]= "stringParameter"
                elif type == "extObjVars":
                    map_var_name_2_addresses[name]= "data->simulationInfo->extObjs["+str(index_extobjs)+"]"
                    index_extobjs+=1
                    ext = Variable();
                    ext.set_name(name)
                    self.external_objects.append(ext)
                test_param_address(name)


    ##
    # Assign the final type and index to the variables
    # @param self : object pointer
    # @return
    def assign_variables_indexes(self):
        # We initialize vars of self.list_vars with initial values found in *_06inz.c
        self.set_start_value_for_syst_vars_06inz()

        # We initialize vars of self.list_vars with initial values found in *_08bnd.c
        self.set_start_value_for_syst_vars()
        self.detect_non_const_real_calculated_variables()
        self.detect_z_only_used_internally()
        # Attribution of indexes done independently to make sure the order is the same as in defineVariables and defineParameters methods
        index_real_var = 0
        index_derivative_var = 0
        index_discrete_var = 0
        index_boolean_vars = 0
        index_real_param= 0
        index_integer_param= 0
        index_string_param= 0
        index_aux_var= 0
        index_integer_double = 0
        alternative_way_to_declare_der = "$DER."
        for var in self.list_vars:
            name = var.get_name()
            test_param_address(name)
            address = map_var_name_2_addresses[name]
            if "auxiliaryVars" in address:
                map_var_name_2_addresses[name]= "data->simulationInfo->daeModeData->auxiliaryVars["+str(index_aux_var)+"]"
                index_aux_var+=1
                self.auxiliary_vars_to_address_map[name.replace("$cse","cse")] = map_var_name_2_addresses[name]
                self.auxiliary_vars_counted_as_variables.append(name)
            elif "realVars" in address:
                map_var_name_2_addresses[name]= "data->localData[0]->realVars["+str(index_real_var)+"]"
                index_real_var+=1
            elif "discreteVars" in address:
                map_var_name_2_addresses[name]= "data->localData[0]->discreteVars["+str(index_discrete_var)+"]"
                index_discrete_var+=1
            elif "derivativesVars" in address:
                map_var_name_2_addresses[name]= "data->localData[0]->derivativesVars["+str(index_derivative_var)+"]"
                map_var_name_2_addresses[name.replace(alternative_way_to_declare_der,"der(")+")"]= map_var_name_2_addresses[name]
                map_var_name_2_addresses[name.replace("der(",alternative_way_to_declare_der)[:-1]]= map_var_name_2_addresses[name]
                index_derivative_var+=1
            elif "integerDoubleVars" in address:
                map_var_name_2_addresses[name]= "data->localData[0]->integerDoubleVars["+str(index_integer_double)+"]"
                index_integer_double+=1
            elif "booleanVars" in address:
                map_var_name_2_addresses[name]= "data->localData[0]->booleanVars["+str(index_boolean_vars)+"]"
                index_boolean_vars+=1
            elif "realParameter" in address:
                map_var_name_2_addresses[name]= "data->simulationInfo->realParameter["+str(index_real_param)+"]"
                index_real_param+=1
            elif "integerParameter" in address:
                map_var_name_2_addresses[name]= "data->simulationInfo->integerParameter["+str(index_integer_param)+"]"
                index_integer_param+=1
            elif "stringParameter" in address:
                map_var_name_2_addresses[name]= "data->simulationInfo->stringParameter["+str(index_string_param)+"]"
                index_string_param+=1

        self.nb_real_vars = index_real_var
        self.nb_discrete_vars = index_discrete_var
        self.nb_bool_vars = index_boolean_vars
        self.nb_integer_vars = index_integer_double
        self.find_calculated_variables()



    ##
    # Collect all discrete variables names
    # @param self : object pointer
    # Requires map_var_name_2_addresses to be ready
    # @return all discrete variables names
    def collect_discrete_variables_names(self):
        discr_vars = []
        for var in self.list_vars:
            name = var.get_name()
            if name not in map_var_name_2_addresses : continue
            address = map_var_name_2_addresses[name]
            if "discreteVars" in address or "integerDoubleVars" in address or "booleanVars" in address:
                discr_vars.append(name)
        return discr_vars

    ##
    # Mark as silent Z all discrete variables that are used only in continuous equations
    # @param self : object pointer
    # Requires map_var_name_2_addresses to be ready
    # @return
    def detect_z_only_used_internally(self):
        map_num_eq_vars_defined = self.get_map_num_eq_vars_defined()
        discr_variable_to_discs_equation_dependencies = {}
        # Collect all discrete variables
        discr_vars = self.collect_discrete_variables_names()

        # Build a dictionary that associate each discrete variable name to the list of discrete equations that use it
        # If a discrete variable is not present in this list then it means that it is not used in discrete equations
        for f in self.list_func_16dae_c:
            f_num_omc = f.get_num_omc()
            name_var_eval = None
            if f_num_omc in map_num_eq_vars_defined.keys():
                if len(map_num_eq_vars_defined[f_num_omc]) > 1:
                    error_exit("   Error: Found an equation (id: " + f_num_omc+") defining multiple variables. This is not supported in Dynawo.")
                name_var_eval = map_num_eq_vars_defined[f_num_omc] [0]

            if name_var_eval is not None and name_var_eval in discr_vars:
                for discr_var in discr_vars:
                    if discr_var == name_var_eval: continue
                    if "/* " + discr_var + " " in str(f.get_body()):
                        if not discr_var in discr_variable_to_discs_equation_dependencies:
                            discr_variable_to_discs_equation_dependencies[discr_var] = []
                        discr_variable_to_discs_equation_dependencies[discr_var].append(f_num_omc)

        # Mark as silent all discrete variables that are not in the dictionary defined above
        # boolean whenCondition variable are filtered as they are not in the Z table
        for discr_var in discr_vars:
            if discr_var not in discr_variable_to_discs_equation_dependencies and not is_when_condition(discr_var):
                print_info("Discrete variable " + discr_var + " is defined as silent.")
                self.silent_discrete_vars.append(discr_var)


    ##
    # Find all continuous variables that are used in a single equation and mark them as calculated variables
    # @param self : object pointer
    # Requires map_var_name_2_addresses to be ready
    # @return
    def detect_non_const_real_calculated_variables(self):
        if self.disable_generate_calc_vars:
            print_info("Automatic generation of calculated variables is disabled")
            return
        map_dep = self.get_map_dep_vars_for_func()
        map_num_eq_vars_defined = self.get_map_num_eq_vars_defined()
        name_func_to_search = {}
        for func in self.list_omc_functions:
            if "omc_Modelica_" in func.get_name() and not "omc_Modelica_Blocks_Tables_Internal_getTable" in func.get_name(): continue
            name_func_to_search[func.get_name()] = func

        # dictionary that stores the number of equations that depends on a specific variable
        variable_to_equation_dependencies = {}
        function_to_eval_variable = {}
        for f in self.list_func_16dae_c:
            f_num_omc = f.get_num_omc()
            name_var_eval = None
            if f_num_omc in map_num_eq_vars_defined.keys():
                if len(map_num_eq_vars_defined[f_num_omc]) > 1:
                    error_exit("   Error: Found an equation (id: " + f_num_omc+") defining multiple variables. This is not supported in Dynawo.")
                name_var_eval = map_num_eq_vars_defined[f_num_omc] [0]

            if name_var_eval is not None and self.is_residual_vars(name_var_eval) and \
                not self.is_der_residual_vars(name_var_eval) and not self.is_assign_residual_vars(name_var_eval):
                continue

            list_depend = [] # list of vars on which depends the function
            is_eligible = True
            for line in f.get_body():
                if "STATE_DER" in line:
                    # equations with derivatives should be kept in F
                    is_eligible = False
                if "RELATIONHYSTERESIS" in line:
                    # equations with potential mode change should be kept in F
                    is_eligible = False
                for func_name in name_func_to_search:
                    if func_name +"("  in line or func_name +" (" in line:
                        is_eligible = False
                        # equations with call to an external function  should be kept in F
                        func = name_func_to_search[func_name]
                        outputs = func.find_outputs_from_call(line)
                        if(len(outputs) >= 1):
                            name_var_eval = outputs[0]
                        inputs = func.find_inputs_from_call(line)
                        list_depend.extend(inputs)
            if name_var_eval is not None:
                list_depend.append(name_var_eval) # The / equation function depends on the var it evaluates
                if name_var_eval in map_dep:
                    list_depend.extend( map_dep[name_var_eval] ) # We get the other vars (from *._info.xml)
                if is_eligible:
                    function_to_eval_variable[f] = name_var_eval
                for var_name in list_depend:
                    if var_name == "time": continue
                    if self.is_residual_vars(var_name) : continue
                    if var_name in self.list_flow_vars: continue
                    var = self.find_variable_from_name(var_name)
                    if (var is None): continue
                    if is_discrete_real_var(var): continue
                    if is_integer_var(var): continue
                    if is_bool_var(var): continue
                    if is_when_condition(var_name) : continue
                    if not var_name in variable_to_equation_dependencies:
                        variable_to_equation_dependencies[var_name] = []
                    variable_to_equation_dependencies[var_name].append(f_num_omc)

        function_to_remove = []
        for f in function_to_eval_variable:
            var_name = function_to_eval_variable[f]
            if var_name in variable_to_equation_dependencies and len( variable_to_equation_dependencies[var_name]) == 1:
                var = self.find_variable_from_name(var_name)
                assert(var != None)
                self.list_complex_calculated_vars[var] = f
                function_to_remove.append(f)
                print_info("Variable " + var_name + " is set as a calculated variable of level 1.")
                map_var_name_2_addresses[var_name]= "SHOULD NOT BE USED - CALCULATED VAR"
        for f in function_to_remove:
            self.list_func_16dae_c.remove(f)
        was_modif = True
        idx = 2
        while was_modif:
            was_modif = False
            for f in function_to_remove:
                for var in variable_to_equation_dependencies:
                    if f.get_num_omc() in variable_to_equation_dependencies[var]:
                        variable_to_equation_dependencies[var].remove(f.get_num_omc())
            function_to_remove = []
            for f in function_to_eval_variable:
                var_name = function_to_eval_variable[f]
                if var_name in variable_to_equation_dependencies and len( variable_to_equation_dependencies[var_name]) == 1:
                    var = self.find_variable_from_name(var_name)
                    assert(var != None)
                    self.list_complex_calculated_vars[var] = f
                    function_to_remove.append(f)
                    print_info("Variable " + var_name + " is set as a calculated variable of level " + str(idx) +".")
                    map_var_name_2_addresses[var_name]= "SHOULD NOT BE USED - CALCULATED VAR"
                    was_modif = True
            idx+=1

    ##
    # Find all calculated variables, collect their initial value and their associated equation
    # @param self : object pointer
    # Requires map_var_name_2_addresses to be ready
    # @return
    def find_calculated_variables(self):
        for var in self.list_vars:
            test_param_address(var.get_name())
            if "constVars" in to_param_address(var.get_name()):
                map_var_name_2_addresses[var.get_name()] = self.find_constant_value_of(var)
                # We keep a specific structure for const real variables that have a complex initialization to avoid always recalculating it
                if to_param_address(var.get_name()) == None:
                    map_var_name_2_addresses[var.get_name()] = "data->constCalcVars["+str(len(self.list_complex_const_vars))+"]"
                    self.list_complex_const_vars.append(var)

        ptrn_evaluated_var = re.compile(r'data->localData(?P<var>\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ ]* = [ ]*(?P<rhs>[^;]+);')
        for var in self.list_vars:
            if var in self.list_complex_calculated_vars:
                self.list_calculated_vars.append(var)
                body = []
                for line in self.list_complex_calculated_vars[var].get_body():
                    if has_omc_trace (line) or has_omc_equation_indexes (line) :
                        continue
                    if re.search(ptrn_evaluated_var, line) is not None:
                        line = ptrn_evaluated_var.sub(r'  return \g<3>;', line)
                    line=line.replace("threadData,", "")
                    line = sub_division_sim(line)
                    body.append("  "+line)
                self.dic_calculated_vars_values[var.get_name()] = body
            elif var in self.list_complex_const_vars or (not var.is_alias() and is_real_const_var(var)):
                test_param_address(var.get_name())
                self.list_calculated_vars.append(var)
                self.dic_calculated_vars_values[var.get_name()] = to_param_address(var.get_name())
            elif var.is_alias():
                alias_var = self.find_variable_from_name(var.get_alias_name())
                assert(alias_var != None)
                if var.get_variability() == "continuous" and (is_integer_var(alias_var) or is_discrete_real_var(alias_var)):
                    test_param_address(var.get_alias_name())
                    negated = "-" if var.get_alias_negated() else ""
                    self.list_calculated_vars.append(var)
                    self.dic_calculated_vars_values[var.get_name()] = negated + to_param_address(var.get_alias_name()) + " /* " + var.get_alias_name() + "*/"
                if is_real_const_var(var):
                    test_param_address(var.get_alias_name())
                    negated = "-" if var.get_alias_negated() else ""
                    self.list_calculated_vars.append(var)
                    self.dic_calculated_vars_values[var.get_name()] = negated+to_param_address(var.get_alias_name()) + " /* " + var.get_alias_name() + "*/"


    ##
    # Find the effective value of a constant real variable
    # @param self : object pointer
    # @return
    def find_constant_value_of(self, var):
        if var.is_alias() :
            if to_param_address(var.get_alias_name()) == "constVars":
                alias_var = self.find_variable_from_name(var.get_alias_name())
                assert(alias_var != None)
                return self.find_constant_value_of(alias_var)
            else:
                if var.get_alias_negated():
                    return "-("+to_param_address(var.get_alias_name())+")"
                else:
                    return to_param_address(var.get_alias_name())
        elif var.get_use_start() and not (is_const_var(var) and var.get_init_by_param_in_06inz()):
            init_val = var.get_start_text()[0]
            if init_val == "":
                init_val = "0.0"
            return init_val
        return None



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
        ptrn_func = re.compile(r'^(?![\/]).* (?P<var>.*)\((?P<params>.*)\)')
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
                    index = 0
                    for params in match.group('params').split(','):
                        if(params.startswith("threadData_t")): continue
                        type = params.split()[0]
                        name = params.split()[1]
                        is_input = not name.startswith("*out_")
                        func.add_params(OmcFunctionParameter(name, type, index, is_input))
                        index +=1

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
