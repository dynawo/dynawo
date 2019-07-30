#!/usr/bin/env python

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

import sys
import itertools
import re
from dataContainer import *
from utils import *

##
# ZeroCrossingFilter class : take G data, read and prepare them to be used in factory
#
class ZeroCrossingFilter:
    ##
    # default constructor
    # @param self : object pointer
    # @param reader : object that reads input files
    def __init__(self, reader):
        ## object that read input files
        self.reader = reader
        ## List of lines that constitutes the G equation descriptions
        self.function_zero_crossing_description_raw_func = []
        ## List of lines that constitutes the G equations
        self.function_zero_crossings_raw_func = []
        ## number of zero crossing/G equations
        self.number_of_zero_crossings = 0

    ##
    # returns the lines that constitues the body of G equations descriptions
    # @param self : object pointer
    # @return list of lines
    def get_function_zero_crossing_description_raw_func(self):
        return self.function_zero_crossing_description_raw_func

    ##
    # returns the lines that constitues the body of G equations
    # @param self : object pointer
    # @return list of lines
    def get_function_zero_crossings_raw_func(self):
        return self.function_zero_crossings_raw_func

    ##
    # returns the number of zero crossing
    # @param self : object pointer
    # @return number of zero crossing
    def get_number_of_zero_crossings(self):
        return self.number_of_zero_crossings

    ##
    # remove fictitious when equations
    # @param self : object pointer
    def create_function_zero_crossing_description_raw_func_and_detect_fictitious_root(self):
        # Filtering the body lines of the function
        def filter_desc_data(line):
            if "return res[i];" not in line \
               and 'return "empty";' not in line\
               and "static const int" not in line \
               and "*out_EquationIndexes" not in line : return True
            return False

        filtered_func = []
        filtered_iter = itertools.ifilter( filter_desc_data, self.reader.function_zero_crossing_description_raw_func.get_body() )
        filtered_func = list(filtered_iter)


        indexes_to_filter = []
        self.number_of_zero_crossings = -2 #to ignore opening and closing {
        nb_zero_crossing_tot = -1; #to ignore opening {
        for line in filtered_func :
            if "time > 999999.0" not in line:
                self.function_zero_crossing_description_raw_func.append(line)
                self.number_of_zero_crossings +=1
            else:
                indexes_to_filter.append(nb_zero_crossing_tot)
                if "static const char *res[] =" in line and not "}" in line: #this is the first g equation and there is more than 1 equation
                    new_line = line.replace("\"time > 999999.0\",","")
                    new_line = new_line.rstrip()
                    self.function_zero_crossing_description_raw_func.append(new_line)
                elif not "static const char *res[] =" in line and "}" in line: #this is the last g equation
                    new_line = line.replace("\"time > 999999.0\"","")
                    self.function_zero_crossing_description_raw_func.append(new_line)
            nb_zero_crossing_tot +=1
        return indexes_to_filter

    ##
    # remove fictitious when equations
    # @param self : object pointer
    def remove_fictitious_gequation(self):
        indexes_to_filter = self.create_function_zero_crossing_description_raw_func_and_detect_fictitious_root()

        # Filtering the body lines of the function
        def filter_eq_data(line):
            if "TRACE_PUSH" not in line \
                and "TRACE_POP" not in line \
                and "return 0;" not in line \
                and "data->simulationInfo->callStatistics.functionZeroCrossings++" not in line : return True
            return False
        filtered_func = []
        filtered_iter = itertools.ifilter( filter_eq_data, self.reader.function_zero_crossings_raw_func.get_body() )
        filtered_func = list(filtered_iter)

        nb_zero_crossing_tot = 0;
        variable_to_filter = []
        for line in filtered_func :
            if "gout" in line:
                if nb_zero_crossing_tot in indexes_to_filter:
                    variable_to_filter.extend(re.findall(r'tmp[0-9]+', line))
                nb_zero_crossing_tot +=1
        nb_zero_crossing_tot = 0;
        current_index = 0;
        for line in filtered_func :
            if "gout" in line:
                if nb_zero_crossing_tot in indexes_to_filter:
                    nb_zero_crossing_tot +=1
                    continue
                line = line.replace("gout[%s" % nb_zero_crossing_tot, "gout[%s" % current_index)
                nb_zero_crossing_tot +=1
                current_index+=1
            if any(ext in line for ext in variable_to_filter):
                continue
            line = replace_var_names(line)
            self.function_zero_crossings_raw_func.append(line)


##
# Factory class: take datas, read and prepare them to print them in new file
#
class Factory:
    ##
    # default constructor
    # @param self : object pointer
    # @param reader : object that reads input files
    def __init__(self, reader):
        ## object that read input files
        self.reader = reader

        ## All variables of the system : algebraic/state/alias
        self.list_all_vars =[]
        ## variables of the system (same as list_all_vars without alias)
        self.list_vars_syst = []

        ## List of derivatives variables
        self.list_vars_der = []
        ## List of discretes variables
        self.list_vars_discr = []
        ## List of ALL discrete variables (including booleans)
        self.list_all_vars_discr = []
        ## List of internal variables
        self.list_vars_int = []
        ## List of real parameters (external and internal)
        self.list_params_real = []

        ## List of boolean parameters (external and internal)
        self.list_params_bool = []

        ## List of integer parameters (external and internal)
        self.list_params_integer = []

        ## List of string parameters (external and internal)
        self.list_params_string = []

        ## List of boolean variables
        self.list_vars_bool = []
        ## List of boolean variables defining when conditions
        self.list_vars_when = []
        ## List of dummy variables
        self.list_vars_dummy = []

        ## List of name of discrete variables
        self.list_name_discrete_vars = []
        ## List of name of integer variables
        self.list_name_integer_vars = []

        ## LIste of all boolean items
        self.list_all_bool_items = []

        ## List of functions which should not be written in output files
        self.erase_func = []

        ## List of elements
        self.list_elements = []

        ## List of all equations
        self.list_all_equations = []
        ## List of equations evaluating variables
        self.list_eq_syst = []
        # Map of reinit equations for continuous variables
        self.map_eq_reinit_continuous = {}
        # Map of reinit equations for discrete variables
        self.map_eq_reinit_discrete = {}

        ## List of warnings
        self.list_warnings = []
        ## Number of equations of the system
        self.nb_eq_dyn = 0

        ## List of root function identified in the model
        self.list_root_objects = []
        ## Number of root function identified in the model
        self.nb_root_objects = []
        ## List of when root function  to filter
        self.list_when_eq_to_filter = []
        ## List of discrete equations identified in the model
        self.list_z_equations = []
        ## List of integer equations identified in the model
        self.list_int_equations = []

        ## List of equations to add in setY0 function
        self.list_for_sety0 = []
        ## List of equations to add in setFOmc function
        self.list_for_setf = []
        ## List of equations to add in evalMode function
        self.list_for_evalmode = []
        ## List of equations to add in setZ function
        self.list_for_setz = []
        ## List of equations to add in setG function
        self.list_for_setg = []
        ## List of equations to add in initRpar function
        self.list_for_initrpar = []
        ## List of equations to add in setupDataStruc function
        self.list_for_setupdatastruc = []
        ## List of equations to add in evalFAdept function
        self.list_for_evalfadept = []
        ## List of external functions that should be redefined for adept
        self.list_for_evalfadept_external_call = []
        ## List of external functions that should be redefined for adept
        self.list_for_evalfadept_external_call_headers = []
        ## List of equations to add in setSharedParamsDefault function
        self.list_for_setsharedparamsdefault = []
        ## List of equations to add in setParams function
        self.list_for_setparams = []
        ## List of equations to add in externalCalls function
        self.list_for_externalcalls = []
        ## List of equations to add in externalCallsHeader function
        self.list_for_externalcalls_header =[]
        ## List of equations to add in setYType function
        self.list_for_setytype = []
        ## List of equations to add in setFType function
        self.list_for_setftype = []
        ## List of equations to add in setVariables function
        self.list_for_setvariables = []
        ## List of equations to add in defineParameters function
        self.list_for_defineparameters = []
        ## List of equations to add in defineElements function
        self.list_for_defelem = []
        ## List of equations to define literal constants
        self.list_for_literalconstants = []
        ## List of equations to define warnings
        self.list_for_warnings = []
        ## List of formula of equations to define setFequations function
        self.listfor_setfequations = []
        ## List of formula of root equations to define setGequations function
        self.list_for_setgequations = []
        ## List of equations identified in _16dae file
        self.list_eq_maker_16dae = []

        ## List of variables definitions for generic header
        self.list_for_definition_header = []

        ## List of external call, called since setFomc
        self.list_call_for_setf =[]
        ## List of external call, called since setFomc
        self.list_additional_equations_from_call_for_setf =[]
        ## List of external call, called since setZomc
        self.list_call_for_setz =[]

        ## fictitious G equation filter
        self.zc_filter = ZeroCrossingFilter(self.reader)

    ##
    # Getter to obtain the number of dynamic equations
    # @param self : object pointer
    # @return number of dynamic equations
    def get_nb_eq_dyn(self):
        return self.nb_eq_dyn

    ##
    # Getter to obtain all the equations defining the model
    # @param self : object pointer
    # @return list of equations
    def get_list_eq_syst(self):
        return self.list_eq_syst

    def keep_continous_modelica_reinit(self):
        return False

    ##
    # Getter to obtain all the equations linked with Modelica reinit for continuous variables
    # @param self : object pointer
    # @return list of equations
    def get_map_eq_reinit_continuous(self):
        return self.map_eq_reinit_continuous

    ##
    # Getter to obtain all the equations linked with Modelica reinit for discrete variables
    # @param self : object pointer
    # @return list of equations
    def get_map_eq_reinit_discrete(self):
        return self.map_eq_reinit_discrete

    ##
    # For each variables, give an index useful for omc array, initial value
    # Sort variables by type
    # @param self : object pointer
    # @return
    def build_variables(self):
        # ---------------------------------------------------------
        # Improvement of information on variables
        # ---------------------------------------------------------
        # Warning: the treatments done by these 3 functions (of the reader) could be put back here, they do not belong
        # in the reader.

        # We assign an omc index to each var (thanks to *_model.h)
        self.reader.give_num_omc_to_vars()

        # We initialize vars of self.list_vars with initial values found in *_06inz.c
        self.reader.set_start_value_for_syst_vars_06inz()

        # We initialize vars of self.list_vars with initial values found in *_08bnd.c
        self.reader.set_start_value_for_syst_vars()

        # Set if the variables is internal or not
        initial_defined = self.reader.initial_defined

        list_vars_read = self.reader.list_vars
        for var in list_vars_read:
            if var.get_name() in initial_defined:
                var.set_internal(True)
            else:
                var.set_internal(False)


        # ----------------------------------------------
        # Merging
        # ----------------------------------------------
        # ... We group some vars into categories.
        # For filters, see dataContainer.py
        self.list_vars_der = filter (is_der_real_var, list_vars_read) # Derived from state vars
        self.list_vars_discr = filter(is_discrete_real_var, list_vars_read) # Vars discretes reelles
        self.list_vars_int = filter(is_integer_var, list_vars_read) # vars entieres
        self.list_vars_bool = filter(is_bool_var, list_vars_read) # Vars booleennes
        self.list_vars_when = filter(is_when_var, list_vars_read) # Vars when (bool & "$whenCondition")
        self.list_vars_dummy = filter(is_dummy_var, list_vars_read)

        self.list_params_real = filter(is_param_real, list_vars_read) # Real Params (all)

        self.list_params_bool = filter(is_param_bool, list_vars_read) # Params booleans (all)

        self.list_params_integer = filter(is_param_integer, list_vars_read) # Full Params (all)
        self.list_params_string = filter(is_param_string, list_vars_read) # Params string (all)

        ## Removing of WhenVar bool variables, we only keep "real" boolean variables
        tmp_var = []
        for var in self.list_vars_bool:
            if var not in self.list_vars_when:
                tmp_var.append(var)
        self.list_vars_bool = tmp_var

        # -----------------------------------
        # Grouping of the vars of the system
        # -----------------------------------
        # ... groups the vars of the system of equations to be solved, that is to say
        # ... the vars diff + vars alg continuous (but not the derivatives of the vars diff).

        # - If an output var  represents another var (via an alias) which is supposed to
        # appear in the system, the output var enters the system,
        # but not the var it represents.
        # - If an output var is equal to a var of the equation system (without alias):
        #       In the "equation" part of *.mo, we have "output_var = var" but
        #       no alias is created by omc. The equation "output_var = var" is then in
        #       the main *.c file.
        # This output var must be in the output vars, but not in the vars
        #       of the equation system: we will find this var in the methode "setOomc()",
        #       but noy in "names()"
        #
        #     To sum up :
        # For output vars, only those that are aliases enter
        # in the system, the others come out.
        #

        self.list_vars_syst = filter(is_syst_var, list_vars_read)
        self.list_all_vars = filter(is_var, list_vars_read)
        tmp_list = []
        for var in self.list_all_vars:
            if var not in self.list_vars_when:
                tmp_list.append(var)
        self.list_all_vars = tmp_list
        self.list_all_vars_discr = self.list_vars_discr + self.list_vars_bool

        ## type of each variables
        self.var_by_type = {}
        for var in list_vars_read:
            type_var = var.get_type()
            self.var_by_type[var.get_name()] = type_var

        # ----------------------------------------------
        # Order: according to the their number in *_model.h
        # ----------------------------------------------
        self.list_params_real.sort(cmp = cmp_num_omc_vars)
        self.list_params_bool.sort(cmp = cmp_num_omc_vars)
        self.list_params_integer.sort(cmp = cmp_num_omc_vars)
        self.list_params_string.sort(cmp = cmp_num_omc_vars)
        self.list_vars_bool.sort(cmp = cmp_num_omc_vars)
        self.list_vars_der.sort(cmp = cmp_num_omc_vars)
        self.list_all_vars_discr.sort(cmp = cmp_num_omc_vars)
        self.list_vars_int.sort(cmp = cmp_num_omc_vars)
        self.list_vars_syst.sort(cmp = cmp_num_omc_vars)

        self.list_all_bool_items = sorted (self.list_vars_bool + self.list_params_bool, cmp = cmp_num_omc_vars)

        # ------------------------------------------------------------------
        # We gather the var --> x[i], xd[i]
        # ------------------------------------------------------------------
        # ... The state vars, state var derivatives, discrete vars and parametres can,
        # in some functions of DYNAWO (evalFAdept (...)), be
        # designated by another expression:
        #    - state vars : var --> x[i]
        #    - state var derivatives: der(var) --> xd[i]
        # The following gives this expression for each type of vars
        # ------------------------------------------------------------------------
        for v in self.list_all_vars:
            v.set_dyn_type()

        i = 0
        for v in self.list_vars_der:
            v.set_dynawo_name( "xd[%s]" % str(i) )
            i += 1

        i = 0
        for v in self.list_all_vars_discr:
            v.set_dynawo_name( "z[%s]" % str(i) )
            if (v not in self.list_vars_bool):
                v.set_discrete_dyn_type()
            i += 1

        i = 0
        for v in self.list_vars_int:
            v.set_dynawo_name( "i[%s]" %str(i) )
            i += 1

        i = 0
        for v in self.list_vars_syst:
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            v.set_dynawo_name( "x[%s]" % str(i) )
            i += 1

        i = 0
        # only for real parameters!
        for v in self.list_params_real:
            v.set_dynawo_name( "rpar[%s]" % str(i) )
            i += 1

        # Assignement of the type "FLOW" to certain vars thanks to information from the reader
        list_flow_vars = self.reader.list_flow_vars
        for v in self.list_vars_discr + self.list_vars_syst :
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            var_name = v.get_name()
            if var_name in list_flow_vars : v.set_flow_dyn_type()

        # List of names of discrete vars
        for v in self.list_all_vars_discr:
            self.list_name_discrete_vars.append( v.get_name() )


        # List of names of integer vars
        for v in self.list_vars_int:
            self.list_name_integer_vars.append( v.get_name() )

    ##
    # build the list of all elements
    # @param self : object pointer
    # @return
    def build_elements(self):
        # ----------------------------------------------------------------------------------
        # Building info for the generation of C ++ methods defineElements(...)
        # ----------------------------------------------------------------------------------
        ## everything is done on reading
        self.list_elements = self.reader.list_elements

    ##
    # Sort external function depending on where they are called:
    # If they are called in functionDAE => original call in a when equation => insert in setZOMC
    # If they are called in eqFunction => insert in setFOMC
    # Native functions such as omc_assert and omc_terminate are also concerned
    # @param self : object pointer
    # @return
    def build_call_functions(self):
        map_tags_num_eq = self.reader.get_map_tag_num_eq()
        list_omc_functions = self.reader.list_omc_functions
        name_func_to_search = []
        for func in list_omc_functions:
            name_func_to_search.append(func.get_name())

        # Analysis of MainC functions => if external call => will be added to setFOMC
        list_body_to_analyse = []
        list_body_to_append = []
        list_body_to_append_to_z = []

        for eq_mak in self.list_eq_maker_16dae:
            tag = find_value_in_map( map_tags_num_eq, eq_mak.get_num_omc() )
            if eq_mak.get_evaluated_var() == "" and tag != 'when':
                # call to a function and not evaluation of a variable
                body = eq_mak.get_body()
                body_tmp=[]
                for line in body:
                    if "threadData" in line:
                        line=line.replace("threadData,", "")
                        body_tmp.append(line)
                    #removing of clean ifdef
                    elif "#ifdef" not in line and "#endif" not in line \
                            and "SIM_PROF_" not in line and "NORETCALL" not in line:
                        body_tmp.append(line)

                list_body_to_analyse.append(body_tmp)

        global_pattern_index = 0
        dic_var_name_to_temporary_name = {}

        # functions calling an external function ???
        for body in list_body_to_analyse:
            new_body = []
            is_discrete = False
            found = False
            function_name = ""
            for line in body:
                for name in name_func_to_search:
                    if name+"(" in line or name +" (" in line:
                        for func in filter(lambda x: (x.get_name() == name), list_omc_functions):
                            variables_set_by_omc_function = self.find_variables_set_by_omc_function(line, func, None)
                            discrete_variables_set_by_omc_function = self.find_discrete_variables_set_by_omc_function(line, func)
                            function_name = name
                            ## Sanity check: cannot assign a value to both a continuous and a discrete variable
                            if len(discrete_variables_set_by_omc_function) > 0 and len(discrete_variables_set_by_omc_function) < len(variables_set_by_omc_function):
                                error_exit("    Error: Function " + name + " is used to assign a value to both continuous and discrete variables, which is forbidden.")

                            if len(discrete_variables_set_by_omc_function) > 0:
                                is_discrete = True
                            else:
                                (line, dic_var_name_to_temporary_name_tmp, global_pattern_index) = self.replace_var_names_by_temporary_and_build_dictionary(line, variables_set_by_omc_function, global_pattern_index)
                                dic_var_name_to_temporary_name.update(dic_var_name_to_temporary_name_tmp)
                        found = True
                if "omc_assert" in line or "omc_terminate" in line:
                    found = True
                new_body.append(line)
            if found and is_discrete:
                list_body_to_append_to_z.append("{\n")
                list_body_to_append_to_z.append(body)
                list_body_to_append_to_z.append("}\n\n")
            elif found:
                list_body_to_append.append("{\n")
                list_body_to_append.append(new_body)
                list_body_to_append.append("}\n\n")

        if len(list_body_to_append) > 0:
            for name in dic_var_name_to_temporary_name.keys():
                test_param_address(name)
                self.list_call_for_setf.append("  double " + dic_var_name_to_temporary_name[name]+ " = " + to_param_address(name) + " /* " + name + "*/;\n")

            # Add the functions concerned
            for body in list_body_to_append:
                self.list_call_for_setf.extend(body)

            for name in dic_var_name_to_temporary_name.keys():
                test_param_address(name)
                eq = EquationBasedOnExternalCall(
                              function_name,
                              [to_param_address(name) + " /* " + name + "*/ = " + dic_var_name_to_temporary_name[name]+";"], \
                              name, \
                              to_param_address(name), \
                              [], \
                              "external_call_"+str(self.nb_eq_dyn), \
                              -1 )
                eq.set_num_dyn(self.nb_eq_dyn)
                self.nb_eq_dyn += 1
                self.list_additional_equations_from_call_for_setf.append(eq)


        global_pattern_index = 0
        # Function analysis, if tag when: external call
        for eq_mak in self.list_eq_maker_16dae:
            tag = find_value_in_map( map_tags_num_eq, eq_mak.get_num_omc() )
            # Do not dump again when equations, reinit equations and equations that assigns a discrete variable
            if (tag == 'when' and not eq_mak.get_is_modelica_reinit() and len(filter(lambda x: (x.get_name() == eq_mak.get_evaluated_var()),self.list_all_vars_discr+self.list_vars_int)) == 0):
                body = eq_mak.get_body()
                body_tmp = self.handle_body_for_discrete(body, name_func_to_search, global_pattern_index)

                if any(ext in " ".join(body_tmp) for ext in self.list_when_eq_to_filter):
                    continue
                self.list_call_for_setz.extend(body_tmp)

        for body in list_body_to_append_to_z:
            body_tmp = self.handle_body_for_discrete(body, name_func_to_search, global_pattern_index)
            self.list_call_for_setz.extend(body_tmp)


    def handle_body_for_discrete(self, body, name_func_to_search, global_pattern_index):
        list_omc_functions = self.reader.list_omc_functions
        list_bool_var_names = [item.get_name() for item in self.list_all_bool_items]
        body_tmp = []
        for line in body:
            ## When an integer is set by passing a reference to into a function parameter,
            ## need to use an intermediate modelica_integer var to set the double value on Dynawo side
            found = False
            for name in name_func_to_search:
                if name+"(" in line or name +" (" in line:
                    for func in filter(lambda x: (x.get_name() == name), list_omc_functions):
                        variables_to_replace = self.find_discrete_variables_set_by_omc_function(line, func)
                        dic_var_name_to_temporary_name = {}
                        (line, dic_var_name_to_temporary_name, global_pattern_index) = self.replace_var_names_by_temporary_and_build_dictionary(line, variables_to_replace, global_pattern_index)

                        for name in dic_var_name_to_temporary_name.keys():
                            test_param_address(name)
                            if "integerDoubleVars" in to_param_address(name):
                                body_tmp.append("  modelica_integer " + dic_var_name_to_temporary_name[name]+ " = (modelica_integer)" + to_param_address(name) + " /* " + name + "*/;\n")
                            elif name in list_bool_var_names:
                                body_tmp.append("  modelica_boolean " + dic_var_name_to_temporary_name[name]+ " = fromNativeBool(" + to_param_address(name) + " /* " + name + "*/);\n")
                            else:
                                body_tmp.append("  modelica_real " + dic_var_name_to_temporary_name[name]+ " = " + to_param_address(name) + " /* " + name + "*/;\n")

                        line = line.replace("threadData,", "")
                        body_tmp.append(line)

                        for key in dic_var_name_to_temporary_name.keys():
                                    body_tmp.append("  "+to_param_address(key) + " /* " + key + " DISCRETE */ = " + dic_var_name_to_temporary_name[key]+";\n")
                        found = True
            if not found:
                if "threadData" in line:
                    line = line.replace("threadData,", "")
                    body_tmp.append(line)
                #removing of clean ifdef
                elif "#ifdef" not in line and "#endif" not in line \
                        and "SIM_PROF_" not in line and "NORETCALL" not in line:
                    body_tmp.append(line)
        return body_tmp

    def find_discrete_variables_set_by_omc_function(self, line_with_call, func):

        def filter_discrete_var(var_name):
            return "integerDoubleVars" in to_param_address(var_name) or "discreteVars" in to_param_address(var_name)

        return self.find_variables_set_by_omc_function(line_with_call, func, \
                lambda var_name: filter_discrete_var(var_name))

    def find_variables_set_by_omc_function(self, line_with_call, omc_raw_function, filter):
        ptrn_var_assigned = re.compile(r'[ ]*data->localData(?P<var>\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ ]* = [ ]*(?P<rhs>[^;]+);')
        match = re.match(ptrn_var_assigned, line_with_call)
        variables_to_replace = {}
        if match is not None:
            variable_name = match.group("varName").replace(" variable ","").replace(" DISCRETE ","").replace(" ","")
            if filter is None or filter(variable_name):
                variables_to_replace[variable_name] = -1
            rhs = match.group("rhs").replace(omc_raw_function.get_name()+"(","").replace(omc_raw_function.get_name()+" (","")
            rhs = rhs.replace(")","").replace(";","")
            ptrn_var= re.compile(r'[ ]*[&]?data->localData(?P<var>\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ ]*')

            index = 0
            for params in rhs.split(','):
                param = omc_raw_function.get_params()[index]
                if param.get_is_input():
                    index+=1
                    continue
                match = re.match(ptrn_var, params)
                if match is not None:
                    param_variable_name = match.group("varName").replace(" variable ","").replace(" DISCRETE ","").replace(" ","")
                    if filter is None or filter(param_variable_name):
                        variables_to_replace[param_variable_name] = index
                index+=1
        return variables_to_replace

    ##
    # Replace all variables by a temporary name
    # @param self: object pointer
    # @param line: line to analyse
    # @return line to use
    def replace_var_names_by_temporary_and_build_dictionary(self, line, variables_to_replace, global_pattern_index):
        ptrn_var = re.compile(r'data->localData\[(?P<localDataIdx>[0-9]+)\]->(?P<var>[\w\[\]]+)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
        ptrn_var_no_desc = re.compile(r'data->localData\[(?P<localDataIdx>[0-9]+)\]->(?P<var>[\w\[\]]+)[ ]*\/\* (?P<varName>[\w\$\.()\[\],]*) \*\/')
        match = ptrn_var.findall(line)
        map_to_replace = {}

        prefix_temporary_var = "external_call_tmp_"
        dic_var_name_to_temporary_name = {}
        for idx, add, name in match:
            if name not in variables_to_replace.keys(): continue
            replacement_string = "@@@" + str(global_pattern_index) + "@@@"
            line = line.replace("data->localData["+str(idx)+"]->"+add, replacement_string)
            map_to_replace[replacement_string] = prefix_temporary_var+str(global_pattern_index)
            dic_var_name_to_temporary_name[name] = map_to_replace[replacement_string]
            global_pattern_index +=1
        match = ptrn_var_no_desc.findall(line)
        for idx, add, name in match:
            if name not in variables_to_replace.keys(): continue
            replacement_string = "@@@" + str(global_pattern_index) + "@@@"
            line = line.replace("data->localData["+str(idx)+"]->"+add, replacement_string)
            map_to_replace[replacement_string] = prefix_temporary_var+str(global_pattern_index)
            dic_var_name_to_temporary_name[name] = map_to_replace[replacement_string]
            global_pattern_index +=1

        for pattern_to_replace in map_to_replace:
            line = line.replace(pattern_to_replace, map_to_replace[pattern_to_replace])
        return (line, dic_var_name_to_temporary_name, global_pattern_index)

##
    # Take the equations from *_16dae.c file found by the read and create eq maker object from them
    # @param self : object pointer
    # @return
    def collect_eq_makers_from_16_dae(self):
        # Recovery of the map [var name evaluated] --> [ Func / Eq number in *_info.xml]
        # In the "equations" section of *_info.xml, each equation defines the value
        # of a var with respect to other vars. The name of the evaluated var is in the attribut "defines".
        # We can thus associate the name of the evaluated var with the number of the equation which evaluates it.
        # This map is then used to determine, for each function of a C file, the name of the var it evaluates.
        # Warning:
        # The case of linear and nonlinear systems is particular concerning the determination
        # of the evaluated var considering that several equations must leave a function (see + far).
        map_num_eq_vars_defined = self.reader.get_map_num_eq_vars_defined()


        ##########################################################
        # Equations from main *.c file
        ##########################################################
        # List of equations from main *.c file
        list_eq_maker_16dae_c = []

        # index of functions calling the resolution of LS or NLS in main *.c file
        list_num_func_to_remove = []

        # Removing functions involving linear or non-linear
        # systems in the list of functions read in the main *.c file
        # These functions are covered later.
        list_num_func_to_remove = self.reader.linear_eq_nums + self.reader.non_linear_eq_nums

        # Build the eqMaker for functions of the dae *.c file
        for f in self.reader.list_func_16dae_c:
            if f.get_num_omc() not in list_num_func_to_remove:
                eq_maker = EqMaker(f)
                list_eq_maker_16dae_c.append( eq_maker )

        # Find, for each function of the main *.c file :
        # - the variable it evaluates
        # - the vars on which it depends to evaluate this variable
        map_dep = self.reader.get_map_dep_vars_for_func()
        for eq_mak in list_eq_maker_16dae_c:
            eq_mak_num_omc = eq_mak.get_num_omc()
            name_var_eval = None

            # for Modelica reinit equations, the evaluated var scan does not always work
            # a fallback is to look at the variable defined in this case
            if eq_mak_num_omc in map_num_eq_vars_defined.keys():
                if len(map_num_eq_vars_defined[eq_mak_num_omc]) > 1:
                    error_exit("   Error: Found an equation (id: " + eq_mak_num_omc+") defining multiple variables. This is not supported in Dynawo.")
                name_var_eval = map_num_eq_vars_defined[eq_mak_num_omc] [0]

            if name_var_eval is not None and self.reader.is_residual_vars(name_var_eval) and \
                not self.reader.is_der_residual_vars(name_var_eval) and not self.reader.is_assign_residual_vars(name_var_eval):
                continue

            list_depend = [] # list of vars on which depends the function
            if name_var_eval is not None:
                eq_mak.set_evaluated_var(name_var_eval)
                list_depend.append(name_var_eval) # The / equation function depends on the var it evaluates
                if name_var_eval in map_dep.keys():
                    list_depend.extend( map_dep[name_var_eval] ) # We get the other vars (from *._info.xml)

                eq_mak.set_depend_vars(list_depend)

        # Build an equation for each function in the dae *.c file
        for eq_mak in list_eq_maker_16dae_c:
            eq_mak.prepare_body_for_equation()
            self.list_all_equations.append( eq_mak.create_equation() )
            self.list_eq_maker_16dae.append(eq_mak)
    ##
    # collect the equations defining the model and assigns them an unique id
    # @param self : object pointer
    # @return
    def collect_eq_syst(self):
        ##########################################################

        # ---------------------------------------------------------------------
        # The equations of the system to solve (in DYNAWO)
        # ---------------------------------------------------------------------
        # We recover the equations which will be used to constitute the system to be solved
         # ... We concatene the vars syst (state + alg) and the vars der (state),
        # and we recover the equations associated with these vars, that is to say
        # the equations that evaluate these vars.
        for var_name in self.reader.auxiliary_var_to_keep:
            for eq in filter(lambda x: (not x.get_is_modelica_reinit()) and (x.get_evaluated_var() == var_name), self.list_all_equations):
                self.list_eq_syst.append(eq)

        list_residual_vars_for_sys_build = itertools.chain(self.reader.derivative_residual_vars, self.reader.assign_residual_vars)
        for var_name in list_residual_vars_for_sys_build:
            for eq in filter(lambda x: (not x.get_is_modelica_reinit()) and (x.get_evaluated_var() == var_name), self.list_all_equations):
                self.list_eq_syst.append(eq)

        list_vars_for_sys_build = itertools.chain(self.list_vars_syst, self.list_vars_der)
        for var in list_vars_for_sys_build:
            for eq in filter(lambda x: (not x.get_is_modelica_reinit()) and (x.get_evaluated_var() == var.get_name()), self.list_all_equations):
                self.list_eq_syst.append(eq)

        for eq in self.list_all_equations:
            if eq.get_evaluated_var() =="" and eq.with_throw():
                warning = Warn(warning)
                warning.prepare_body()
                self.list_warnings.append(warning)

        #... Sort the previous functions with their index in the main *.c file (and other *.c)
        self.list_eq_syst.sort(cmp = cmp_equations)

        # ... we give them a number for DYNAWO
        i = 0 # num dyn of the equation
        for eq in self.list_eq_syst:
            var_name = eq.get_evaluated_var()
            if var_name not in self.reader.fictive_continuous_vars_der and not self.reader.is_auxiliary_vars(var_name):
                eq.set_num_dyn(i)
                i += 1
            else:
                eq.set_num_dyn (-1) # can detect bugs
        self.nb_eq_dyn = i

    ##
    # collect the equations due to Modelica reinit command and assigns them an unique id
    # @param self : object pointer
    # @return
    def collect_reinit_eq(self):
         # ---------------------------------------------------------------------
        # Equations due to Modelica reinit commands
        # ---------------------------------------------------------------------
        # We retrieve all equations due to Modelica reinit commands
        for var in self.list_vars_syst + self.list_all_vars_discr + self.list_vars_int:
            #retrieve the num_dyn attribute : retrieve the equation linked with the current variable
            num_dyn = None
            for eq_standard in filter(lambda x: (not x.get_is_modelica_reinit()) \
                                      and ((x.get_evaluated_var() == var.get_name()) or (x.get_evaluated_var() == 'der(' + var.get_name() + ')')), self.list_all_equations):
                num_dyn = eq_standard.get_num_dyn()
                break

            # retrieve all Modelica reinit equations linked with the current variable
            for eq in filter(lambda x: x.get_is_modelica_reinit() \
                             and ((x.get_evaluated_var() == var.get_name()) or (x.get_evaluated_var() == 'der(' + var.get_name() + ')')), self.list_eq_maker_16dae):
                equation = Equation (eq.get_body(), eq.get_evaluated_var(), eq.get_depend_vars(), eq.get_num_omc())
                if (num_dyn is not None):
                    equation.set_num_dyn(num_dyn)

                if (var in self.list_vars_syst):
                    if var.get_name() not in self.map_eq_reinit_continuous:
                        self.map_eq_reinit_continuous [var.get_name()] = []
                    self.map_eq_reinit_continuous[var.get_name()].append(equation)
                elif (var in self.list_all_vars_discr + self.list_vars_int):
                    if (var.get_name()) not in self.map_eq_reinit_discrete:
                        self.map_eq_reinit_discrete [var.get_name()] = []
                    self.map_eq_reinit_discrete [var.get_name()].append(equation)
                else:
                    error_exit('bad Modelica reinit equation : ' + eq.get_body())

    ##
    # collect the integer equations
    # @param self : object pointer
    # @return
    def collect_int_eq(self):
        # List of function bodies evaluating integer vars
        list_func_bodies_int_names = {}

        for v in self.list_vars_int:
            for eq_mak in self.list_eq_maker_16dae:
                if (v.get_name() == eq_mak.get_evaluated_var()) and (not eq_mak.get_is_modelica_reinit()):
                    list_func_bodies_int_names[v.get_name()]= eq_mak.get_body()
                    break

        # add integer equations to setZ
        keys = list_func_bodies_int_names.keys()
        for key in keys:
            int_equation = INTEquation(key)
            int_equation.set_body(list_func_bodies_int_names[key])
            int_equation.prepare_body()
            self.list_int_equations.append(int_equation)

    ##
    # create root objects for all discrete variables
    # @param self : object pointer
    # @return
    def create_root_objects(self):
        # Creation of the rootObject list

        for v in self.list_vars_when :
            self.list_root_objects.append( RootObject(v.get_name()) )

        list_continuous_vars_and_params = []
        list_continuous_vars_and_params.extend(self.list_vars_syst)
        list_continuous_vars_and_params.extend(self.list_vars_der)
        list_continuous_vars_and_params.extend(self.list_params_real)

        # Get zero crossing function description
        filtered_func = list(self.zc_filter.get_function_zero_crossing_description_raw_func())
        filtered_func = filtered_func[1:-1] # remove last and first elements which are "}" and "{"
        index  = 0
        for line in filtered_func:
            result = re.search('\"(.*)\"', line)
            if result is not None:
                filtered_func[index] = result.group(1)
            index +=1

        map_equation = self.reader.get_map_equation_formula()
        for r_obj in self.list_root_objects:
            # For the current when variable, search for the body of the function
            # which evaluates the variable whenCondition (for, later, retrieve the number of relationship associated with the
            # var whenCondition)
            for eq_mak in self.list_eq_maker_16dae:
                if r_obj.get_when_var_name() == eq_mak.get_evaluated_var():
                    r_obj.set_body_for_num_relation( eq_mak.get_raw_body() )
                    if len(filtered_func) > 0:
                        eq = map_equation[eq_mak.get_num_omc()]
                        eq = eq.replace(r_obj.get_when_var_name() + " = ","").replace("(*","/*").replace("*)","*/")
                        r_obj.set_duplicated_in_zero_crossing(eq in filtered_func)
                    break
            r_obj.prepare_body()
    ##
    # collect the root equations
    # @param self : object pointer
    # @return
    def collect_root_eq(self):
        # List of function fields evaluating discrete vars
        list_func_bodies_discr = []
        list_func_bodies_discr_names = {}

        list_vars_for_sys_build = itertools.chain(self.list_vars_syst, self.list_vars_der)
        map_tags_num_eq = self.reader.get_map_tag_num_eq()
        for v in self.list_all_vars_discr:
            for eq_mak in self.list_eq_maker_16dae:
                if v.get_name() == eq_mak.get_evaluated_var():

                    ## SANITY CHECK: cannot assign a continuous value to a discrete real outside of a when or a if
                    if is_discrete_real_var(v):
                        for real_var in list_vars_for_sys_build:
                            for depend_var in filter(lambda x: x == real_var.get_name(), eq_mak.get_depend_vars()):
                                if map_tags_num_eq[eq_mak.get_num_omc()] != "when" and "if" not in str(eq_mak.get_body()):
                                    error_msg = "    Error: Found an equation (id:"+str(eq_mak.get_num_omc())+") that assigns the continuous variable " + depend_var+\
                                        " to the discrete real variable " + v.get_name() +\
                                        " outside of the scope of a when or a if. Please rewrite the equation or check that you didn't connect a zPin to a ImPin.\n"
                                    error_exit(error_msg)

                    list_func_bodies_discr.append( eq_mak.get_body() )
                    list_func_bodies_discr_names[v.get_name()]=eq_mak.get_body()
                    break

        i = 0
        self.nb_root_objects = 0
        self.list_when_eq_to_filter = []
        # we first assign a DYNAWO number to whenConditions not duplicated in the zero crossings functions (and thus that will be evaluated in G)
        for r_obj in self.list_root_objects:
            # we assign a DYNAWO number (from 0 -> nb vars whenCondition) to each variable whenCondition
            if not r_obj.get_duplicated_in_zero_crossing():
                r_obj.set_num_dyn(i)


            # For each RootObject (or each var whenCondition), we review the bodies
            # of function evaluating the discrete vars and we extract the pieces executed
            # when the whenCondition is checked.
            r_obj.filter_when_cond_blocks( list_func_bodies_discr )

            if re.search(r'RELATIONHYSTERESIS\(tmp[0-9]+, data->localData\[0\]->timeValue, 999999.0, [0-9]+, Greater\);',transform_rawbody_to_string(r_obj.get_body_for_num_relation())):
                r_obj.set_num_dyn(-1)
                self.list_when_eq_to_filter.append(str(r_obj.get_when_var_name())+" ")
                continue

            #r_obj.printWhenEquation()
            if not r_obj.get_duplicated_in_zero_crossing():
                self.nb_root_objects += 1
                i += 1

        # we then assign a DYNAWO number to the remaining whenConditions
        for r_obj in self.list_root_objects:
            if r_obj.get_duplicated_in_zero_crossing() and (str(r_obj.get_when_var_name())+" ") not in self.list_when_eq_to_filter:
                r_obj.set_num_dyn(i)
                i += 1

        # preparation of blocks for setZ
        keys = list_func_bodies_discr_names.keys()
        for key in keys:
            z_equation = ZEquation(key)
            z_equation.set_body(list_func_bodies_discr_names[key])
            z_equation.prepare_body()
            if any(ext in " ".join(z_equation.get_body()) for ext in self.list_when_eq_to_filter):
                continue
            self.list_z_equations.append(z_equation)

        # add Modelica reinit equations
        for var_name, eq_list in self.get_map_eq_reinit_discrete().iteritems():
            for eq in eq_list:
                z_equation = ZEquation("reinit for " + var_name)
                z_equation.set_body(eq.get_body_for_modelica_reinit_affectation())
                z_equation.prepare_body()
                if any(ext in " ".join(z_equation.get_body()) for ext in self.list_when_eq_to_filter):
                    continue
                self.list_z_equations.append(z_equation)

    ##
    # Take the equations found by the read and sort them
    # Change their expression and transforms them in residual function
    # @param self : object pointer
    # @return
    def build_equations(self):
        self.zc_filter.remove_fictitious_gequation()
        # ---------------------------------------------------------------------
        # The equations of the system to solve (in DYNAWO)
        # ---------------------------------------------------------------------
        self.collect_eq_makers_from_16_dae()
        self.collect_eq_syst()
         # ---------------------------------------------------------------------
        # Equations due to Modelica reinit commands
        # ---------------------------------------------------------------------
        self.collect_reinit_eq()

        # ---------------------------------------------------------------------
        # The equations that evaluate Boolean vars of type whenCondition
        # ---------------------------------------------------------------------
        #... These variables (boolean) are in the main *.c file when when
        #    are used in the *.mo.
        #    They are "true" if the associated condition is true, "false" otherwise.
        # To be able to build evalZ (setZomc) and evalG (setGomc),
        # you need to link a relationship number, a condition and the value of
        #    discret variables when this condition is met.
        # To do this, you must:
        # - Build a class containing these 3 elements and others:
        # + numRelation,
        # + expression of the condition
        # + concatenation of body parts (in the evaluating functions
        # the discrete vars) executes when the condition is checked
        # + a relationship number for DYNAWO. This num starts at 0 -> nb relations
        #    - Read in *_05evt every relation (not all are really useful)
        # and put the result in a dico: {numRelation: expr condition}
        # - Recover the eqMaker (not the equations, they do not include the
        # good info) functions evaluating whencondition
        # and, in the body of these functions, retrieve the relation number (4th arg
        # of RELATIONHYSTERESIS (...)).
        #      The list of whenCondition vars is already built above (in "build_variables()").
        # At this point, we know which relations concern whenCondition (we can forget the others)
        # and therefore knows the number of relationships to keep
        #    - With this, we can create objects of type "Relations"
        # - Then we recover the eqMaker (or eq?) Functions evaluating the discrete vars
        #      and we send their body in the good "Relations" objects
        #

        # Creation of the rootObject list
        self.create_root_objects()
        self.collect_root_eq()

        # List of function bodies evaluating integer vars
        self.collect_int_eq()


    ##
    # Change the expression of warnings and assert in order to add them to evalF
    # @param self : object pointer
    # @return
    def build_warnings(self):
        # omc_assert
        warnings = self.reader.warnings
        for warning in warnings:
            warning = Warn(warning)
            warning.prepare_body()
            self.list_warnings.append(warning)


    ##
    # prepare the equations/variables for setY0 methods
    # @param self : object pointer
    # @return
    def prepare_for_sety0(self):
        # In addition to system vars, discrete vars (bool or not) must be initialized as well
        # We concatenate system vars and discrete vars
        list_vars = itertools.chain(self.list_vars_syst, self.list_all_vars_discr, self.list_vars_int)
        found_init_by_param_and_at_least2lines = False # for reading comfort when printing

        # sort by taking init function number read in *06inz.c
        list_vars = sorted(list_vars,cmp = cmp_num_init_vars)
        # We prepare the results to print in setY0omc
        for var in list_vars:
            if var.get_use_start():
                init_val = var.get_start_text()[0]
                if init_val == "":
                    init_val = "0.0"
                test_param_address(var.get_name())
                line = "  %s = %s;\n" % ( to_param_address(var.get_name()) + " /* " + var.get_name() + " */" , init_val )
                line = replace_var_names(line)
                self.list_for_sety0.append(line)

            elif var.get_init_by_param (): # If the var was initialized with a param (not with an actual value)
                var.clean_start_text () # Clean up initialization text before printing

                # Lines for reading comfort at the impression
                if len(var.get_start_text()) > 1 :
                    if not found_init_by_param_and_at_least2lines:
                        self.list_for_sety0.append("\n")
                    found_init_by_param_and_at_least2lines = True
                else : found_init_by_param_and_at_least2lines = False

                for L in var.get_start_text() :
                    if "FILE_INFO" not in L and "omc_assert_warning" not in L:
                        L = replace_var_names(L)
                        self.list_for_sety0.append("  " + L)

                if len(var.get_start_text()) > 1 : self.list_for_sety0.append("\n") # reading comfort

            elif var.get_init_by_param_in_06inz():
                var.clean_start_text_06inz()

                # Lines for reading comfort at the impression
                if len(var.get_start_text_06inz()) > 1 :
                    if not found_init_by_param_and_at_least2lines:
                        self.list_for_sety0.append("\n")
                    found_init_by_param_and_at_least2lines = True
                else : found_init_by_param_and_at_least2lines = False

                self.list_for_sety0.append("  {\n")
                for L in var.get_start_text_06inz() :
                    if "FILE_INFO" not in L and "omc_assert_warning" not in L:
                        L = replace_var_names(L)
                        self.list_for_sety0.append("  " + L)
                self.list_for_sety0.append("  }\n")

                if len(var.get_start_text_06inz()) > 1 : self.list_for_sety0.append("\n") # reading comfort

            else:
                init_val = var.get_start_text()[0]
                if init_val == "":
                    init_val = "0.0"
                test_param_address(var.get_name())
                line = "  %s = %s;\n" % ( to_param_address(var.get_name()) + " /* " + var.get_name() + " */" , init_val )
                line = replace_var_names(line)
                self.list_for_sety0.append(line)

                # for reading comfort when printing
                found_init_by_param_and_at_least2lines = False

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_sety0)

    ##
    # return the list of lines that constitues the body of setY0
    # @param self : object pointer
    # @return list of lines
    def get_list_for_sety0(self):
        for line in self.list_for_sety0:
            if "omc_Modelica_Math_atan3" in line:
                index = self.list_for_sety0.index(line)
                line_tmp = transform_atan3_operator(line)
                self.list_for_sety0.pop(index)
                self.list_for_sety0.insert(index,line_tmp)
        return self.list_for_sety0


    def filter_external_function_call(self):
        body = []
        if len(self.list_call_for_setf) > 0:
            for line in self.list_call_for_setf:
                if line.startswith("  {") or line.startswith("  }") : continue
                line = mmc_strings_len1(line)
                line = throw_stream_indexes(line)
                line = replace_var_names(line)
                if "MMC_DEFSTRINGLIT" in line:
                    line = line.replace("static const MMC_DEFSTRINGLIT(","")
                    line = line.replace(");","")
                    words = line.split(",")
                    name_var = words[0]
                    nb_words = len(words)
                    value =""
                    for i in range(2,nb_words):
                        value = value + words[i]
                    value = value.replace("\n","")
                    line_tmp = "  const modelica_string "+str(name_var)+" = "+str(value)+";\n"
                    body.append(line_tmp)
                elif "MMC_REFSTRINGLIT" in line:
                    line = line.replace("MMC_REFSTRINGLIT","")
                    body.append(line)
                elif "modelica_metatype tmpMeta" in line:
                    words = line.split()
                    line_tmp = " modelica_string "+str(words[1])+";\n"
                    body.append(line_tmp)
                elif ("TRACE_PUSH" not in line) and ("TRACE_POP" not in line) and ("const int equationIndexes[2]" not in line):
                    body.append(line)
            body.append("\n\n")
        return body

    ##
    # dump the lines of the system equation in the body of setF
    # @param self : object pointer
    # @return
    def dump_eq_syst_in_setf(self):
        ptrn_f_name ="  // ----- %s -----\n"
        map_eq_reinit_continuous = self.get_map_eq_reinit_continuous()
        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            var_name_without_der = var_name [4 : -1] if 'der(' == var_name [ : 4] else var_name
            if var_name not in self.reader.fictive_continuous_vars_der:
                standard_eq_body = []
                standard_eq_body.append (ptrn_f_name %(eq.get_src_fct_name()))
                standard_eq_body.extend(eq.get_body_for_setf())

                if self.keep_continous_modelica_reinit() and ((var_name in map_eq_reinit_continuous) or (var_name_without_der in map_eq_reinit_continuous)):
                    var_name_modelica_reinit = var_name if var_name in map_eq_reinit_continuous else var_name_without_der
                    eq_list = map_eq_reinit_continuous [var_name_modelica_reinit]
                    first_eq = True
                    self.list_for_setf.append("  //reinit equations for " + var_name_modelica_reinit + "\n")
                    for eq in eq_list:
                        if (not first_eq):
                            self.list_for_setf.append("  else ")
                        self.list_for_setf.extend(eq.get_body_for_setf())
                        self.list_for_setf.extend("\n")
                        first_eq = False
                    self.list_for_setf.append("  else \n")
                    self.list_for_setf.append("  {\n")
                    self.list_for_setf.extend(standard_eq_body)
                    self.list_for_setf.append("  }")
                else:
                    self.list_for_setf.append("  {\n")
                    self.list_for_setf.extend(standard_eq_body)
                    self.list_for_setf.append("\n  }\n")
                self.list_for_setf.append("\n\n")

    ##
    # dump the lines of the warning in the body of setF
    # @param self : object pointer
    # @return
    def dump_warnings_in_setf(self):
        for warn in self.list_warnings:
            self.list_for_warnings.append("{\n")
            self.list_for_warnings.extend(warn.get_body_for_setf())
            self.list_for_warnings.append("\n\n")
            self.list_for_warnings.append("}\n")

    ##
    # dump the lines of the warning in the body of setF
    # @param self : object pointer
    # @return
    def dump_external_calls_in_setf(self):
        ptrn_f_name ="  // ----- %s -----\n"
        if len(self.list_call_for_setf) > 0:
            self.list_for_setf.append("  // -------------- call functions ----------\n")
            self.list_for_setf.extend(self.filter_external_function_call())

            for eq in self.list_additional_equations_from_call_for_setf:
                standard_eq_body = []
                standard_eq_body.append (ptrn_f_name %(eq.get_src_fct_name()))
                standard_eq_body.append ("  ")
                standard_eq_body.extend(eq.get_body_for_setf())
                standard_eq_body.append ("\n"  )
                self.list_for_setf.extend(standard_eq_body)

            self.list_for_setf.append("\n\n")

    ##
    # prepare the lines that constitues the body of setF
    # @param self : object pointer
    # @return
    def prepare_for_setf(self):
        self.dump_eq_syst_in_setf()
        self.dump_warnings_in_setf()
        self.dump_external_calls_in_setf()

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_setf)

        # remove atan3, replace pow by pow_dynawo
        for index, line in enumerate(self.list_for_setf):
            if "omc_Modelica_Math_atan3" in line:
                self.list_for_setf [index] = transform_atan3_operator(line)
            if "pow(" in line:
                self.list_for_setf [index] = replace_pow(line)

    ##
    # returns the lines that constitues the body of setF
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setf(self):
        return self.list_for_setf

    ##
    # returns the lines that constitues the body of setFquations
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setf_equations(self):
        map_fequation = self.reader.get_map_equation_formula()
        for eq in self.get_list_eq_syst():
            index = str(eq.get_num_omc())
            fequation_index = str(eq.get_num_dyn())
            if fequation_index != '-1' and index in map_fequation.keys():
                linetoadd = "  fEquationIndex["+ fequation_index +"] = \"" + map_fequation[index] + "\";//equation_index_omc:"+index+"\n"
                self.listfor_setfequations.append(linetoadd)

        for eq in self.list_additional_equations_from_call_for_setf:
            fequation_index = str(eq.get_num_dyn())
            linetoadd = "  fEquationIndex["+ fequation_index +"] = \"call to external function " + eq.get_function_name() + " \";\n";
            self.listfor_setfequations.append(linetoadd)
        return self.listfor_setfequations

    ##
    # prepare the lines that constitues the body of setGequations
    # @param self : object pointer
    # @return list of lines
    def prepare_for_setg_equations(self):
        line_ptrn = '  gEquationIndex[%s] = " %s " ;\n'
        line_ptrn_res = '  gEquationIndex[%s] =  %s  ;\n'

        filtered_func = list(self.zc_filter.get_function_zero_crossing_description_raw_func())
        filtered_func = filtered_func[1:-1] # remove last and first elements which are "}" and "{"


        self.list_for_setgequations.append("// ---------------- boolean conditions -------------\n")
        nb_zero_crossing = 0;
        for line in filtered_func :
            self.list_for_setgequations.append(line)
            if not("  static const char *res[] = {" == line) and not("  };" == line.rstrip()):
                nb_zero_crossing +=1
        for i in range(nb_zero_crossing):
            value = "res[" + str(i) + "]"
            self.list_for_setgequations.append( line_ptrn_res %(i, value))
        self.list_for_setgequations.append("// -----------------------------\n")

        line_when_ptrn = "  // ------------- %s ------------\n"
        for r_obj in self.list_root_objects:
            if r_obj.get_num_dyn() == -1 or r_obj.get_duplicated_in_zero_crossing():
                continue
            index = str(r_obj.get_num_dyn()) + " + " + str(nb_zero_crossing)
            self.list_for_setgequations.append(line_when_ptrn %(r_obj.get_when_var_name()))
            when_string = r_obj.get_when_var_name() + ":" + transform_rawbody_to_string(r_obj.get_body_for_num_relation())
            self.list_for_setgequations.append( line_ptrn % (index, when_string ) )
            self.list_for_setgequations.append(" \n")

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_setgequations)

    ##
    # returns the lines that constitues the body of setGquations
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setg_equations(self):
        return self.list_for_setgequations


    ##
    # prepare the lines for the evalMode body
    # @param self : object pointer
    def prepare_for_evalmode(self):
        self.list_for_evalmode.append  ("  // modes may either be due to")
        self.list_for_evalmode.append("\n  // - a change in network topology (currently forbidden for Modelica models)")
        self.list_for_evalmode.append("\n  // - a Modelica reinit command")
        self.list_for_evalmode.append("\n")

        if (self.keep_continous_modelica_reinit()):
            for var_name, eq_list in self.get_map_eq_reinit_continuous().iteritems():
                for eq in eq_list:
                    self.list_for_evalmode.append("\n  // mode linked with " + var_name + "\n")
                    self.list_for_evalmode.extend (eq.get_body_for_evalmode())
                    self.list_for_evalmode.append("\n")

        self.list_for_evalmode.append("  // no mode triggered => return NO_MODE")
        self.list_for_evalmode.append("\n  return NO_MODE;")

        self.list_for_evalmode.append("\n")

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_evalmode)

    ##
    # returns the lines that constitues the body of evalMode
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalmode(self):
        return self.list_for_evalmode

    ##
    # prepare the lines that constitues the body of setZ
    # @param self : object pointer
    # @return
    def prepare_for_setz(self):
        ptrn_name="\n  // -------------------- %s ---------------------\n"
        for r_obj in self.list_root_objects:
            if r_obj.get_num_dyn() == -1 or not r_obj.get_duplicated_in_zero_crossing():
                continue
            self.list_for_setz.append(ptrn_name %(r_obj.get_when_var_name()))
            self.list_for_setz.extend(r_obj.get_body_for_num_relation())
            self.list_for_setz.append(" \n")

        for z_equation in self.list_z_equations:
            self.list_for_setz.append(ptrn_name %(z_equation.get_name()))
            self.list_for_setz.extend(z_equation.get_body())

        for int_equation in self.list_int_equations:
            self.list_for_setz.append(ptrn_name %(int_equation.get_name()))
            self.list_for_setz.extend(int_equation.get_body())

        if len(self.list_call_for_setz) > 0:
            self.list_for_setz.append("\n\n  // -------------- call functions ----------\n")
            for line in self.list_call_for_setz:
                line = throw_stream_indexes(line)
                line = mmc_strings_len1(line)
                line = replace_var_names(line)
                if "MMC_DEFSTRINGLIT" in line:
                    line = line.replace("static const MMC_DEFSTRINGLIT(","")
                    line = line.replace(");","")
                    words = line.split(",")
                    name_var = words[0]
                    value = words[2].replace("\n","")
                    line_tmp = "  const modelica_string "+str(name_var)+" = "+str(value)+";\n"
                    line_tmp = replace_var_names(line_tmp)
                    self.list_for_setz.append(line_tmp)
                elif "MMC_REFSTRINGLIT" in line:
                    line = line.replace("MMC_REFSTRINGLIT","")
                    line = replace_var_names(line)
                    self.list_for_setz.append(line)
                elif "modelica_metatype tmpMeta" in line:
                    words = line.split()
                    line_tmp = " modelica_string "+str(words[1])+";\n"
                    line_tmp = replace_var_names(line_tmp)
                    self.list_for_setz.append(line_tmp)
                elif ("TRACE_PUSH" not in line)  and ("TRACE_POP" not in line) \
                     and ("const int equationIndexes[2]" not in line) and ("infoStreamPrint" not in line) \
                     and ("data->simulationInfo->needToIterate = 1") not in line:
                    line = replace_var_names(line)
                    self.list_for_setz.append(line)
                elif "TRACE_PUSH" in line:
                  self.list_for_setz.append("{\n")
                elif "TRACE_POP" in line:
                  self.list_for_setz.append("}\n")

            self.list_for_setz.append("\n\n")

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_setz)

    ##
    # returns the lines that constitues the body of setF
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setz(self):
        return self.list_for_setz

    ##
    # prepare the lines that constitues the body of setG
    # @param self : object pointer
    # @return
    def prepare_for_setg(self):
        line_ptrn = "  gout[%s] = ( %s ) ? ROOT_UP : ROOT_DOWN;\n"
        line_when_ptrn = "  // ------------- %s ------------\n"
        for r_obj in self.list_root_objects:
            if r_obj.get_num_dyn() == -1 or r_obj.get_duplicated_in_zero_crossing():
                continue
            self.list_for_setg.append(line_when_ptrn %(r_obj.get_when_var_name()))
            self.list_for_setg.extend(r_obj.get_body_for_num_relation())
            self.list_for_setg.append(" \n")

        filtered_func = list(self.zc_filter.get_function_zero_crossings_raw_func())
        filtered_func = filtered_func[1:-1] # remove last and first elements which are "}" and "{"

        for line in filtered_func :
            if "gout" not in line:
                if "tmp" in line:
                    line = line.replace("tmp", "tmp_zc")
                self.list_for_setg.append(line)

        # print all gout at the end of the function
        nb_zero_crossing = 0;
        for line in filtered_func:
            if "gout" in line:
                if "tmp" in line:
                    line = line.replace("tmp", "tmp_zc")
                line = line.replace("1 : -1;", "ROOT_UP : ROOT_DOWN;")
                self.list_for_setg.append(line)
                nb_zero_crossing +=1

        for r_obj in self.list_root_objects:
            if r_obj.get_num_dyn() == -1 or r_obj.get_duplicated_in_zero_crossing():
                continue
            index = str(r_obj.get_num_dyn()) + " + " + str(nb_zero_crossing)
            if to_param_address(r_obj.get_when_var_name()) == None:
                    error_exit('Could not find the address of the variable : ' + r_obj.get_when_var_name())
            self.list_for_setg.append( line_ptrn % (index, to_param_address(r_obj.get_when_var_name())) )

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_setg)

    ##
    # returns the lines that constitues the body of setG
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setg(self):
        return self.list_for_setg


    ##
    # Dump the lines of the shared and external parameters in the body of initRpar
    # @param self : object pointer
    # @return
    def dump_shared_and_external_param_in_initrpar(self):
        self.list_for_initrpar.append("  /* Setting shared and external parameters */\n")

        # Pattern of the lines of the body of initRpar
        motif = "  %s = %s;\n"
        motif_string = "%s = %s.c_str();\n"

        for par in filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_real + self.list_params_bool + self.list_params_integer + self.list_params_string):
            name_underscore = par.get_name() + "_"
            affectation_line = ""
            test_param_address(par.get_name())
            if (par in self.list_params_string):
                affectation_line = motif_string % ( to_param_address(par.get_name()) + " /* " + par.get_name() + " */", to_compile_name(name_underscore) )
            else:
                affectation_line = motif % ( to_param_address(par.get_name()) + " /* " + par.get_name() + " */", to_compile_name(name_underscore) )

            self.list_for_initrpar.append(affectation_line)

    ##
    # Dump the lines of the shared and external parameters in the body of initRpar
    # @param self : object pointer
    # @return
    def dump_internal_param_in_initrpar(self):
        self.list_for_initrpar.append("\n  // Setting internal parameters \n")

        found_init_by_param_and_at_least2lines = False # to enhance readability

        dict_line_par_by_param = {}
        pattern_num = re.compile(r',(?P<num>\d+)}')
        # Prepare initRpar lines
        for par in filter(lambda x: (param_scope(x) ==  INTERNAL_PARAMETER), self.list_params_real + self.list_params_bool + self.list_params_integer + self.list_params_string):
            # the variable is initialised through an equation (rather than a hard-coded value)
            if (not par.get_init_by_param()) and (not par.get_init_by_param_in_06inz()):
                print('failed to generate parameter setting for ' + par.get_name() + ' : no initialisation formula')
                sys.exit(1)

            start_text_getter = None
            start_text_cleaner = None
            if par.get_init_by_param():
                start_text_getter = "get_start_text"
                start_text_cleaner = "clean_start_text"
            elif par.get_init_by_param_in_06inz() :
                start_text_getter = "get_start_text_06inz"
                start_text_cleaner = "clean_start_text_06inz"

            line_par_by_param = []
            # parameters setting is order based on equation index
            lines = getattr(par, start_text_getter) ()
            num = 0
            for line in lines:
                if 'equationIndexes' in line:
                    match = re.search(pattern_num, line)
                    if match is not None:
                        num = match.group('num')
                        break

            getattr (par, start_text_cleaner)() # Cleaning part of the start text

            # Add lines for enhanced reability
            if len(getattr(par, start_text_getter) ()) > 1 :
                if not found_init_by_param_and_at_least2lines:
                    line_par_by_param.append("\n")
                found_init_by_param_and_at_least2lines = True
            else:
                found_init_by_param_and_at_least2lines = False

            for L in getattr(par, start_text_getter)() :
                L = replace_var_names(L)
                line_par_by_param.append(L)

            if len(getattr(par, start_text_getter)()) > 1 : line_par_by_param.append("\n") # for enhanced readability

            dict_line_par_by_param[num]=line_par_by_param

        keys = dict_line_par_by_param.keys()
        keys.sort()
        for key in keys:
            self.list_for_initrpar +=  dict_line_par_by_param[key]

    ##
    # prepare the lines that constitues the body of initRpar
    # @param self : object pointer
    # @return
    def prepare_for_initrpar(self):

        # -----------------------------------------------------------
        # Shared and external parameters
        # (possibly set through *.mo, and updated by *.par/.iidm)
        # -----------------------------------------------------------
        self.dump_shared_and_external_param_in_initrpar()
        # -----------------------------------------------------------
        # Parameters set in *.mo through a mathematical formula
        # -----------------------------------------------------------
        self.dump_internal_param_in_initrpar()

        # convert native Modelica booleans
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_initrpar)


    ##
    # returns the lines that constitues the body of initRpar
    # @param self : object pointer
    # @return list of lines
    def get_list_for_initrpar(self):
        for line in self.list_for_initrpar:
            if "omc_Modelica_Math_atan3" in line:
                index = self.list_for_initrpar.index(line)
                line_tmp = transform_atan3_operator(line)
                self.list_for_initrpar.pop(index)
                self.list_for_initrpar.insert(index,line_tmp)
        return self.list_for_initrpar


    ##
    # prepare the lines that constitues the body of setupDataStruc
    # @param self : object pointer
    # @return
    def prepare_for_setupdatastruc(self):

        # If there are dummy vars in the main.c generated by omc, you need to
        # substract them to the following lines (in the body of "setupDataStruc(...)") :
        #   data->modelData.nStates = n1;
        #   data->modelData.nVariablesReal = n2;
        # And do (see below in this method):
        #   data->modelData.nStates = n1 - nbDummy;
        #   data->modelData.nVariablesReal = n2 - 2*nbDummy;

        self.list_for_setupdatastruc.append("  data->modelData = (MODEL_DATA *)calloc(1,sizeof(MODEL_DATA));\n");
        self.list_for_setupdatastruc.append("  data->simulationInfo = (SIMULATION_INFO *)calloc(1,sizeof(SIMULATION_INFO));\n");
        self.list_for_setupdatastruc.append("  data->simulationInfo->daeModeData = (DAEMODE_DATA *)calloc(1,sizeof(DAEMODE_DATA));\n");
        self.list_for_setupdatastruc.append("  data->nbDummy = %s;\n" % len(self.list_vars_dummy) )

        # Filtering the body lines of the function
        def filter_setup_data(line):
            if "data->modelData->n" in line : return True
            return False

        # Filtering the body lines of the function
        def filter_dae_setup_data(line):
            if "daeModeData" in line :
                return "nAuxiliaryVars" in line or "nResidualVars" in line
            return False

        filtered_func = []
        filtered_iter = itertools.ifilter( filter_setup_data, self.reader.setup_data_struc_raw_func.get_body() )
        filtered_iter_dae = itertools.ifilter( filter_dae_setup_data, self.reader.setup_dae_data_struc_raw_func.get_body() )
        filtered_func = list(filtered_iter)
        filtered_func += list(filtered_iter_dae)

        # Change the number of zeroCrossings, real/discrete/bool vars
        for n, line in enumerate(filtered_func):
            if "data->modelData->nZeroCrossings" in line:
                line = line [ :line.find("=") ] + "= " + str(self.zc_filter.get_number_of_zero_crossings())+";\n"
                new_line = line [ :line.find(";") ] + " + " + str(self.nb_root_objects) + line[ line.find(";") : ]
                filtered_func[n] = new_line
            if "data->modelData->nVariablesReal" in line:
                line = line [ :line.find("=") ] + "= " + str(self.reader.nb_real_vars)+";\n"
                filtered_func[n] = line
            if "data->modelData->nDiscreteReal" in line:
                line = line [ :line.find("=") ] + "= " + str(self.reader.nb_discrete_vars)+";\n"
                filtered_func[n] = line
            if "data->modelData->nVariablesBoolean" in line:
                line = line [ :line.find("=") ] + "= " + str(self.reader.nb_bool_vars)+";\n"
                filtered_func[n] = line
            if "daeModeData->nResidualVars" in line:
                line = line [ :line.find("=") ] + "= " + str(len(self.reader.derivative_residual_vars) + len(self.reader.assign_residual_vars))+";\n"
                filtered_func[n] = line
            if "daeModeData->nAuxiliaryVars" in line:
                line = line [ :line.find("=") ] + "= " + str(len(self.reader.auxiliary_var_to_keep) + len(self.reader.auxiliary_vars_counted_as_variables))+";\n"
                filtered_func[n] = line
            if "daeModeData->" in line:
                line = line.replace("daeModeData", "data->simulationInfo->daeModeData")
                filtered_func[n] = line

        # Modification of the number of discrete variables to take into account Booleans
        # We do not change the size of the array of Boolean variables
        nb_vars_bool = len(self.list_vars_bool)
        nb_params_bool = len(self.list_params_bool)
        bool_params_plural_addon = 's' if nb_params_bool > 1 else ''
        if (nb_vars_bool > 0) or (nb_params_bool > 0):
            for n, line in enumerate(filtered_func):
                if "data->modelData->nParametersReal" in line:
                    new_line = line [ : line.find(";")] + " + " + str(nb_params_bool) \
                                    + "; // "  + str(nb_params_bool) + " boolean" + bool_params_plural_addon + " emulated as real parameter" + bool_params_plural_addon + line [line.find(";") + 1 : ]
                    filtered_func [n] = new_line
                elif "data->modelData->nParametersBoolean" in line:
                    new_line = line [ : line.find ("data->modelData->nParametersBoolean")] + "data->modelData->nParametersBoolean = 0; // all boolean parameters emulated as real parameters" + line [line.find(";") + 1 : ]
                    filtered_func [n] = new_line

        # Filling the body of setupDataStruc in the generated file
        self.list_for_setupdatastruc = self.list_for_setupdatastruc + filtered_func + ["\n"]

    ##
    # returns the lines that constitues the body of setupDataStruc
    # @param self : object pointer
    # @return list of lines
    def get_setupdatastruc(self):
        return self.list_for_setupdatastruc

    ##
    # prepare the lines that constitues the external function bodies for adept
    # @param self : object pointer
    # @param used_functions : functions used in the body of evalf adept
    # @return
    def prepare_for_evalfadept_external_call(self, used_functions):
        functions_to_dump = []
        functions_dumped = []
        functions_to_dump.extend(used_functions)
        list_omc_functions = self.reader.list_omc_functions
        list_functions_body = []
        while len(functions_to_dump) > 0:
            func = functions_to_dump[0]
            functions_to_dump.remove(func)
            if func.get_return_type() != "modelica_real" or "omc_Modelica_" in func.get_name(): continue
            if func in functions_dumped: continue
            functions_dumped.append(func)
            func_body = []
            func_body.append("// " + func.get_name()+"\n")
            func_header = "adept::adouble " + func.get_name()+"_adept("
            for param in func.get_params():
                type = param.get_type()
                if type == "modelica_real":
                    type = "adept::adouble"
                last_char = ", "
                if param.get_index() == len(func.get_params()) - 1 :
                    last_char=") "
                func_header+=type + " " + param.get_name()+ last_char
            func_body.append(func_header.replace(func.get_name()+"_adept(", "__fill_model_name__::"+func.get_name()+"_adept("))
            func_header+= ";\n"
            self.list_for_evalfadept_external_call_headers.append(func_header)
            for line in func.get_corrected_body():
                if "OMC_LABEL_UNUSED" in line: continue
                if "omc_assert" in line or "omc_terminate" in line: continue
                line = line.replace("modelica_real","adept::adouble").replace("threadData,","")
                for func in list_omc_functions:
                    if func.get_name() + "(" in line or func.get_name() + " (" in line:
                        line = line.replace(func.get_name() + "(", func.get_name() + "_adept(")
                        line = line.replace(func.get_name() + " (", func.get_name() + "_adept (")
                        if func not in functions_dumped:
                            functions_to_dump.append(func)
                func_body.append(line)
            func_body.append("\n\n")
            list_functions_body.append(func_body)

        # Need to dump in reversed order to put the functions called by other functions in first
        for func_body in reversed(list_functions_body):
            self.list_for_evalfadept_external_call.extend(func_body)
    ##
    # prepare the lines that constitues the body of evalFAdept
    # @param self : object pointer
    # @return
    def prepare_for_evalfadept(self):
        # In comment, we give the correspondence name var -> expression in vectors x, xd or rpar
        list_omc_functions = self.reader.list_omc_functions
        self.list_for_evalfadept.append("  /*\n")
        for v in self.list_vars_syst + self.list_vars_der:
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            self.list_for_evalfadept.append( "    %s : %s\n" % (to_compile_name(v.get_name()), v.get_dynawo_name()) )
        self.list_for_evalfadept.append("\n")

        self.list_for_evalfadept.append("  */\n")


        for name in self.reader.auxiliary_var_to_keep:
            self.list_for_evalfadept.append("  adept::adouble " + name +";\n")
        list_residual_vars_for_sys_build = itertools.chain(self.reader.derivative_residual_vars, self.reader.assign_residual_vars)
        for name in list_residual_vars_for_sys_build:
            self.list_for_evalfadept.append("  adept::adouble " + name +";\n")
        # Recovery of the text content of the equations that evaluate the system's vars
        # and 2-step treatment:
        #   Replacement of "modelica_real" by "adept::adouble"
        #   Replacement of "Greater" and "Less" by "Greater<adept::adouble>" and "Less<adept::adouble>"
        #   Replacement of "GreaterEq" and "LessEq" by "GreaterEq<adept::adouble>" and "LessEq<adept::adouble>"
        # - vars (of the system) used to evaluate it are replaced by x[i], xd[i] or rpar[i]
        # thanks to the translator (the discreet vars are not replaced)

        # ... Transpose to translate
        #     vars [ var or der(var) ] --> [ x[i]  xd[i] ou rpar[i] ]
        trans = Transpose(self.reader.auxiliary_vars_to_address_map, self.reader.derivative_residual_vars + self.reader.assign_residual_vars)

        map_eq_reinit_continuous = self.get_map_eq_reinit_continuous()

        num_ternary = 0
        used_functions = []
        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            var_name_without_der = var_name [4 : -1] if 'der(' == var_name [ : 4] else var_name
            if var_name not in self.reader.fictive_continuous_vars_der:
                line = "  // ----- %s -----\n" % eq.get_src_fct_name()
                self.list_for_evalfadept.append(line)

                # We recover the text of the equations
                standard_body_with_standard_external_call = eq.get_body_for_evalf_adept()
                standard_body = []
                for line in standard_body_with_standard_external_call:
                    for func in list_omc_functions:
                        if func.get_return_type() != "modelica_real" or "omc_Modelica_" in func.get_name(): continue
                        if (func.get_name() + "(" in line or func.get_name() + " (" in line):
                            line = line.replace(func.get_name() + "(", func.get_name() + "_adept(")
                            line = line.replace(func.get_name() + " (", func.get_name() + "_adept (")
                            used_functions.append(func)
                    standard_body.append(line)

                # Build the whole equation body as if clauses linked with reinit
                # the standard equation body is written in the last else section
                body = []
                if self.keep_continous_modelica_reinit() \
                   and ((var_name in map_eq_reinit_continuous) or (var_name_without_der in map_eq_reinit_continuous)):
                    var_name_modelica_reinit = var_name if var_name in map_eq_reinit_continuous else var_name_without_der
                    eq_list = map_eq_reinit_continuous [var_name_modelica_reinit]
                    first_eq = True
                    for eq in eq_list:
                        if (not first_eq):
                            body.append("  else ")
                        body.extend (eq.get_body_for_evalf_adept())
                        body.append("\n")

                    body.append("  else \n")
                    body.append("  { \n")
                    body.extend(standard_body)
                    body.append("  } \n")
                else:
                    body.append("  {\n")
                    body.extend(standard_body)
                    body.append("\n  }\n")

                trans.set_txt_list(body)
                body_translated = trans.translate()

                # transformation of ternary operators:
                body_to_transform = False
                for line in body_translated:
                    if "?" in line:
                        body_to_transform = True
                        break

                if body_to_transform:
                    body_translated = transform_ternary_operator(body_translated,num_ternary)
                    num_ternary += 1

                # convert native boolean variables
                convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], body_translated)

                # L'equation transformee est incorporee dans la fonction a imprimer
                self.list_for_evalfadept.extend(body_translated)

                self.list_for_evalfadept.append("\n\n")



        if len(self.list_call_for_setf) > 0:
            self.list_for_evalfadept.append("  // -------------- call functions ----------\n")
            external_function_call_body = self.filter_external_function_call()
            trans.set_txt_list(external_function_call_body)
            external_function_call_body = trans.translate()
            transposed_function_call_body = []
            for line in external_function_call_body:
                for func in list_omc_functions:
                    if func.get_name() + "(" in line or func.get_name() + " (" in line:
                        line = line.replace(func.get_name() + "(", func.get_name() + "_adept(")
                        line = line.replace(func.get_name() + " (", func.get_name() + "_adept (")
                        used_functions.append(func)
                if "double external_call_" in line:
                    line = line.replace("double external_call_","adept::adouble external_call_")
                transposed_function_call_body.append(line)

            self.list_for_evalfadept.extend(transposed_function_call_body)

            for eq in self.list_additional_equations_from_call_for_setf:
                line = "  // ----- %s -----\n" % eq.get_src_fct_name()
                self.list_for_evalfadept.append(line)

                # We recover the text of the equations
                standard_body = []
                standard_body.append("  ")
                standard_body.extend(eq.get_body_for_evalf_adept())
                trans.set_txt_list(standard_body)
                standard_body = trans.translate()
                standard_body.append ("\n"  )
                self.list_for_evalfadept.extend(standard_body)

        self.prepare_for_evalfadept_external_call(used_functions)


    ##
    # returns the lines that constitues the body of evalFAdept
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalfadept(self):
        for line in self.list_for_evalfadept:
            if "omc_Modelica_Math_atan3" in line:
                index = self.list_for_evalfadept.index(line)
                line_tmp = transform_atan3_operator_evalf(line)
                self.list_for_evalfadept [index] = line_tmp
        return self.list_for_evalfadept
    ##
    # returns the lines that contains a copy of the external functions for adept
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalfadept_external_call(self):
        return self.list_for_evalfadept_external_call
    ##
    # returns the lines that contains a copy of the external functions headers for adept
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalfadept_external_call_headers(self):
        return self.list_for_evalfadept_external_call_headers

    ##
    # prepare the lines that constitues the body of externalCalls
    # @param self : object pointer
    # @return
    def prepare_for_externalcalls(self):
        for func in self.reader.list_omc_functions:
            # if function does not start with omc_ we do not add it
            name = func.get_name()
            if name[0:4] != 'omc_' :
                self.erase_func.append(name)
                continue

            self.list_for_externalcalls.append("\n")
            signature = func.get_signature()
            name_to_fill = "__fill_model_name__::"+name
            signature = signature.replace(name, name_to_fill)

            return_type = func.get_return_type()
            # type is not a predefined type
            if (return_type !="void" and return_type[0:9] != 'modelica_' and return_type[0:10] != 'real_array'):
                new_return_type ="__fill_model_name__::"+return_type
                signature = signature.replace(return_type, new_return_type, 1)

            signature = signature.replace('threadData_t *threadData,','')

            self.list_for_externalcalls.append(signature)
            new_body = []
            for line in func.get_body():
                if "modelica_metatype tmpMeta" in line:
                    words = line.split()
                    line_tmp = "  modelica_string " + str(words[1]) + ";\n"
                    new_body.append(line_tmp)
                elif "FILE_INFO info" not in line:
                    line = line.replace("threadData," ,"")
                    line = line.replace("MMC_STRINGDATA","")
                    new_body.append(line)
            self.list_for_externalcalls.extend(new_body)
            func.set_corrected_body(new_body)


    ##
    # prepare the lines that constitues the header of externalCalls
    # @param self : object pointer
    # @return
    def prepare_for_externalcalls_header(self):
        tmp_list = self.reader.list_internal_functions
        for func in self.erase_func:
            for line in self.reader.list_internal_functions:
                if func in line:
                    tmp_list.remove(line)

        for line in tmp_list:
            if 'threadData_t *threadData,' in line:
                line = line.replace("threadData_t *threadData,","")
            self.list_for_externalcalls_header.append(line)

    ##
    # returns the lines that constitues the body of externalCalls
    # @param self : object pointer
    # @return list of lines
    def get_list_for_externalcalls(self):
        return self.list_for_externalcalls

    ##
    # returns the lines that constitues the header of externalCalls
    # @param self : object pointer
    # @return list of lines
    def get_list_for_externalcalls_header(self):
        return self.list_for_externalcalls_header

    ##
    # prepare the lines for the shared parameters default value setting
    # @param self : object pointer
    # @return
    def prepare_for_setsharedparamsdefaultvalue(self):
        # -----------------------------------------------------------
        # Parameters default value set in *.mo
        # -----------------------------------------------------------
        self.list_for_setsharedparamsdefault.append("\n   // Propagating shared parameters default value \n")
        self.list_for_setsharedparamsdefault.append("\n   // This value may be updated later on through *.par/*.iidm data \n")
        parameters_set_name = 'parametersSet'
        create_parameter_pattern = '  ' + parameters_set_name + '->createParameter("%s", %s);\n'
        local_name_prefix = "_internal"
        all_parameters_names = {}

        # define local parameters
        lines_local_par_definition = []
        for par in filter(lambda x: (param_scope(x) ==  SHARED_PARAMETER), self.list_params_real + self.list_params_bool + self.list_params_integer + self.list_params_string):
            local_par_name = to_compile_name(par.get_name()) + local_name_prefix
            all_parameters_names [par.get_name()] = local_par_name
            par_value_type = par.get_value_type_c()
            if (par_value_type == "string"):
                par_value_type = "std::string"
            line_local_par_definition = '  %s %s;\n' % (par_value_type, local_par_name)
            lines_local_par_definition.append (line_local_par_definition)
        lines_local_par_definition.append('\n')

        # create and fill parameters' set
        self.list_for_setsharedparamsdefault.append('  boost::shared_ptr<parameters::ParametersSet> ' + parameters_set_name + ' = parameters::ParametersSetFactory::newInstance("SharedModelicaParameters");\n')

        line_par_other = []
        for par in filter(lambda x: (param_scope(x) ==  SHARED_PARAMETER), self.list_params_real + self.list_params_bool + self.list_params_integer + self.list_params_string):
                init_val = par.get_start_text()[0]
                local_par_name = all_parameters_names [par.get_name()]

                # add quotes
                if is_param_string (par):
                    if init_val != "" :
                        init_val = '"' + str(init_val) + '"'
                    else:
                        init_val = '""'
                else:
                    if init_val == "":
                        init_val = "0.0"

                line_value_setting = "  %s = %s; \n" % (local_par_name, init_val)
                line_par_other.append (line_value_setting)
                line_modelica_params = create_parameter_pattern % (to_compile_name(par.get_name()), local_par_name)
                line_par_other.append (line_modelica_params)

        # concatenation of lists
        self.list_for_setsharedparamsdefault += lines_local_par_definition
        self.list_for_setsharedparamsdefault += line_par_other

        self.list_for_setsharedparamsdefault.append('  return parametersSet;\n')

        # convert native Modelica booleans
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items] + [all_parameters_names[par.get_name()] for par in filter(lambda x: (param_scope(x) ==  SHARED_PARAMETER), self.list_params_bool)], self.list_for_setsharedparamsdefault)

    ##
    # returns the lines describing shared parameters initial value setting
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setsharedparamsdefaultvalue(self):
        return self.list_for_setsharedparamsdefault

    ##
    # prepare the lines that constitues the body of setParameters
    # @param self : object pointer
    # @return
    def prepare_for_setparams(self):
        # Pattern of the body lines of setParameters
        motif_double = "  %s = params->getParameter(\"%s\")->getDouble();\n"
        motif_bool =  "  %s = params->getParameter(\"%s\")->getBool();\n"
        motif_string =  "  %s = params->getParameter(\"%s\")->getString();\n"
        motif_integer = "  %s = params->getParameter(\"%s\")->getInt();\n"

        for par in filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_real + self.list_params_bool + self.list_params_integer + self.list_params_string):
            motif = None
            if (par in self.list_params_real):
                motif = motif_double
            elif (par in self.list_params_bool):
                motif = motif_bool
            elif (par in self.list_params_integer):
                motif = motif_integer
            elif (par in self.list_params_string):
                motif = motif_string

            name = to_compile_name(par.get_name())
            name_underscore = name + "_"
            line = motif % ( name_underscore, name )
            self.list_for_setparams.append(line)

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_setparams)

    ##
    # returns the lines that constitues the body of setParameters
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setparams(self):
        return self.list_for_setparams

    ##
    # returns the lines that declares non-internal real parameters
    # @param self : object pointer
    # @return list of lines
    def get_list_params_real_not_internal_for_h(self):
        return filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_real)

    ##
    # returns the lines that declares non-internal boolean parameters
    # @param self : object pointer
    # @return list of lines
    def get_list_params_bool_not_internal_for_h(self):
        return filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_bool)

    ##
    # returns the lines that declares non-internal string parameters
    # @param self : object pointer
    # @return list of lines
    def get_list_params_string_not_internal_for_h(self):
        return filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_string)

    ##
    # returns the lines that declares non-internal integer parameters
    # @param self : object pointer
    # @return list of lines
    def get_list_params_integer_not_internal_for_h(self):
        return filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_integer)

    ##
    # returns the lines that should be included in header to define variables
    # @param self : object pointer
    # @return
    def get_list_definitions_for_h (self):
        return self.list_for_definition_header

    ##
    # Prepare the lines that should be included in header to define variables
    # @param self : object pointer
    # @return
    def prepare_for_definitions_for_h (self):
        variable_definitions = []
        index_residual_var = 0
        for dae_var in self.reader.auxiliary_var_to_keep:
            variable_definitions.append("#define $P"+ dae_var + " data->simulationInfo->daeModeData->auxiliaryVars["+str(index_residual_var)+"]\n")
            index_residual_var +=1
        index_aux_var = 0
        for dae_var in self.reader.derivative_residual_vars:
            variable_definitions.append("#define "+ "$P"+dae_var + " data->simulationInfo->daeModeData->residualVars["+str(index_aux_var)+"]\n")
            index_aux_var+=1
        for dae_var in self.reader.assign_residual_vars:
            variable_definitions.append("#define "+ "$P"+dae_var + " data->simulationInfo->daeModeData->residualVars["+str(index_aux_var)+"]\n")
            index_aux_var+=1

        lines_to_write = variable_definitions
#
        self.list_for_definition_header.extend (lines_to_write)


    ##
    # prepare the lines that constitues the body of setYType
    # @param self : object pointer
    # @return
    def prepare_for_setytype(self):
        ind = 0
        for v in self.list_vars_syst:
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            spin = "DIFFERENTIAL"
            var_ext = ""
            if is_alg_var(v) : spin = "ALGEBRIC"
            if v.get_name() in self.reader.fictive_continuous_vars:
              spin = "EXTERNAL"
              var_ext = "- external variables"
            elif v.get_name() in self.reader.fictive_optional_continuous_vars:
              spin = "OPTIONAL_EXTERNAL"
              var_ext = "- optional external variables"
            line = "   yType[ %s ] = %s;   /* %s (%s) %s */\n" % (str(ind), spin, to_compile_name(v.get_name()), v.get_type(), var_ext)
            self.list_for_setytype.append(line)
            ind += 1

    ##
    # returns the lines that constitues the body of setYType
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setytype(self):
        return self.list_for_setytype


    ##
    # prepare the lines that constitues the body of setFType
    # @param self : object pointer
    # @return
    def prepare_for_setftype(self):
        ind = 0
        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            if var_name not in self.reader.fictive_continuous_vars_der and not self.reader.is_auxiliary_vars(var_name):
                spin = "ALGEBRIC_EQ" # no derivatives in the equation
                if eq.is_diff_eq() or var_name in self.reader.derivative_residual_vars: spin = "DIFFERENTIAL_EQ"
                line = "   fType[ %s ] = %s;\n" % (str(ind), spin)
                self.list_for_setftype.append(line)
                ind += 1

        for eq in self.list_additional_equations_from_call_for_setf:
            var_name = eq.get_evaluated_var()
            if var_name not in self.reader.fictive_continuous_vars_der and not self.reader.is_auxiliary_vars(var_name):
                spin = "ALGEBRIC_EQ" # no derivatives in the equation
                if eq.is_diff_eq() or var_name in self.reader.derivative_residual_vars: spin = "DIFFERENTIAL_EQ"
                line = "   fType[ %s ] = %s;\n" % (str(ind), spin)
                self.list_for_setftype.append(line)
                ind += 1
    ##
    # returns the lines that constitues the body of setFType
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setftype(self):
        return self.list_for_setftype

    ##
    # prepare the lines that constitues the body of setVariables
    # @param self : object pointer
    # @return
    def prepare_for_setvariables(self):
        line_ptrn_native_state = '  variables.push_back (VariableNativeFactory::createState ("%s", %s, %s));\n'
        line_ptrn_native_calculated = '  variables.push_back (VariableNativeFactory::createCalculated ("%s", %s, %s));\n'
        line_ptrn_alias =  '  variables.push_back (VariableAliasFactory::create ("%s", "%s", %s));\n'

        # System vars
        for v in self.list_all_vars:
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            name = to_compile_name(v.get_name())
            is_state = True
            negated = "true" if v.get_alias_negated() else "false"
            line = ""
            if v.get_alias_name() != '':
                alias_name = to_compile_name(v.get_alias_name())
                line = line_ptrn_alias % ( name, alias_name, negated)

            elif is_state:
                line = line_ptrn_native_state % ( name, v.get_dyn_type(), negated)
            else:
                line = line_ptrn_native_calculated % ( name, v.get_dyn_type(), negated)


            self.list_for_setvariables.append(line)

    ##
    # returns the lines that constitues the body of setVariables
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setvariables(self):
        return self.list_for_setvariables

    ##
    # prepare the lines that constitues the body of defineParameters
    # @param self : object pointer
    # @return
    def prepare_for_defineparameters(self):
        line_ptrn = "  parameters.push_back(ParameterModeler(\"%s\", %s, %s));\n"

        # Les parametres
        for par in self.list_params_real + self.list_params_bool + self.list_params_integer + self.list_params_string:
            par_type = param_scope_str (param_scope (par))
            name = to_compile_name(par.get_name())
            value_type = par.get_value_type_c().upper()
            line = line_ptrn %( name, "VAR_TYPE_"+value_type, par_type)
            self.list_for_defineparameters.append(line)

    ##
    # returns the lines that constitues the body of defineParameters
    # @param self : object pointer
    # @return list of lines
    def get_list_for_defineparameters(self):
        return self.list_for_defineparameters

    ##
    # prepare the lines that constitues the body of defineElements
    # @param self : object pointer
    # @return
    def prepare_for_defelem(self):

        motif1 = "  elements.push_back(Element(\"%s\",\"%s\",Element::%s));\n"
        motif2 = "  mapElement[\"%s\"] = %d;\n"


        # # First part of defineElements (...)
        for elt in self.list_elements :
            elt_name = elt.get_element_name()
            elt_short_name = elt.get_element_short_name()
            line =""
            if not elt.is_structure() :
                line = motif1 % ( to_compile_name(elt_short_name), to_compile_name(elt_name), "TERMINAL" )
            else :
                line = motif1 % ( to_compile_name(elt_short_name), to_compile_name(elt_name), "STRUCTURE" )
            self.list_for_defelem.append(line)


        self.list_for_defelem.append("\n") # Empty line

        # Second part of defineElements (...)
        for elt in self.list_elements :
            elt.print_link(self.list_for_defelem)

        self.list_for_defelem.append("\n") # Empty line

        # Third part of defineElements (...)
        for elt in self.list_elements :
            elt_name = elt.get_element_name()
            elt_index = elt.get_element_num()
            # The structure itself
            line = motif2 % (to_compile_name(elt_name), elt_index)
            self.list_for_defelem.append(line)


    ##
    # returns the lines that constitues the body of defineElements
    # @param self : object pointer
    # @return list of lines
    def get_list_for_defelem(self):
       return self.list_for_defelem

    ##
    # prepare the lines that constitues the defines for literal constants
    # @param self : object pointer
    # @return
    def prepare_for_literalconstants(self):
        list_literal = self.reader.list_vars_literal
        for var in list_literal:
            words = var.split()
            name = words[1]
            name = name.replace("_data","")
            if '#define' in var and "_data" in var:
                # deletion of the define
                var = var.replace("#define", "const std::string")
                var = var.replace("_data", "")
                # add the = between name and variable
                var = var.replace(name, str(name) + " = ")
                var = var.replace("\n", " ")
                define = str(var) + ";\n"
                self.list_for_literalconstants.append(define)

            elif 'static const modelica_integer' in var:
                var = var.replace("_data", "")
                var = var.replace ("static const", "const")

                self.list_for_literalconstants.append(var)


    ##
    # returns the lines that constitues the defines for literal constants
    # @param self : object pointer
    # @return list of lines
    def get_list_for_literalconstants(self):
        return self.list_for_literalconstants


   ##
   # returns the lines that constitues the body of initializeDataStruc
   # @param self : object pointer
   # @return list of lines
    def get_list_for_initializedatastruc(self):
        body="""
  dataStructIsInitialized_ = true;
  data->localData = (SIMULATION_DATA**) calloc(1, sizeof(SIMULATION_DATA*));
  data->localData[0] = (SIMULATION_DATA*) calloc(1, sizeof(SIMULATION_DATA));

  // buffer for all variables
  int nb;
  nb = (data->modelData->nVariablesReal > 0) ? data->modelData->nVariablesReal : 0;
  data->simulationInfo->realVarsPre = (modelica_real*)calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nStates > 0) ? data->modelData->nStates  : 0;
  data->simulationInfo->derivativesVarsPre = (modelica_real*)calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nDiscreteReal >0) ? data->modelData->nDiscreteReal : 0;
  data->simulationInfo->discreteVarsPre = (modelica_real*)calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nVariablesBoolean > 0) ? data->modelData->nVariablesBoolean : 0;
  data->localData[0]->booleanVars = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));
  data->simulationInfo->booleanVarsPre = (modelica_boolean*)calloc(nb, sizeof(modelica_boolean));

  nb = (data->modelData->nVariablesInteger > 0) ? data->modelData->nVariablesInteger : 0;
  data->simulationInfo->integerDoubleVarsPre = (modelica_real*) calloc(nb, sizeof(modelica_real));


  // buffer for all parameters values
  nb = (data->modelData->nParametersReal > 0) ? data->modelData->nParametersReal : 0;
  data->simulationInfo->realParameter = (modelica_real*) calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nParametersBoolean > 0) ? data->modelData->nParametersBoolean : 0;
  data->simulationInfo->booleanParameter = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));

  nb = (data->modelData->nParametersInteger > 0) ? data->modelData->nParametersInteger : 0;
  data->simulationInfo->integerParameter = (modelica_integer*) calloc(nb, sizeof(modelica_integer));

  nb = (data->modelData->nParametersString > 0) ? data->modelData->nParametersString : 0;
  data->simulationInfo->stringParameter = (modelica_string*) calloc(nb, sizeof(modelica_string));

  nb = (data->simulationInfo->daeModeData->nResidualVars > 0) ? data->simulationInfo->daeModeData->nResidualVars : 0;
  data->simulationInfo->daeModeData->residualVars = (modelica_real*) calloc(nb, sizeof(modelica_real));

  nb = (data->simulationInfo->daeModeData->nAuxiliaryVars > 0) ? data->simulationInfo->daeModeData->nAuxiliaryVars : 0;
  data->simulationInfo->daeModeData->auxiliaryVars = (modelica_real*) calloc(nb, sizeof(modelica_real));

  for (unsigned i = 0; i < data->simulationInfo->daeModeData->nAuxiliaryVars; ++i)
    data->simulationInfo->daeModeData->auxiliaryVars[i] = 0;
  for (unsigned i = 0; i < data->simulationInfo->daeModeData->nResidualVars; ++i)
    data->simulationInfo->daeModeData->residualVars[i] = 0;
"""
        lines = body.split('\n')
        content = []
        for line in lines:
            content.append(line+'\n')
        return content

    ##
    # returns the lines that constitues the body of deInitializeDataStruc
    # @param self : object pointer
    # @return list of lines
    def get_list_for_deinitializedatastruc(self):
        body="""
  if(! dataStructIsInitialized_)
    return;

  dataStructIsInitialized_ = false;
  free(data->localData[0]->booleanVars);
  free(data->localData[0]);
  free(data->localData);
  // buffer for all variable pre values
  free(data->simulationInfo->derivativesVarsPre);
  free(data->simulationInfo->realVarsPre);
  free(data->simulationInfo->booleanVarsPre);
  free(data->simulationInfo->integerDoubleVarsPre);
  free(data->simulationInfo->discreteVarsPre);
  // buffer for all parameters values
  free(data->simulationInfo->realParameter);
  free(data->simulationInfo->booleanParameter);
  free(data->simulationInfo->integerParameter);
  free(data->simulationInfo->stringParameter);
  free(data->simulationInfo->daeModeData->residualVars);
  free(data->simulationInfo->daeModeData->auxiliaryVars);
  free(data->simulationInfo->daeModeData);
  free(data->simulationInfo);
  free(data->modelData);
"""
        lines = body.split('\n')
        content = []
        for line in lines:
            content.append(line+'\n')
        return content

    ##
    # returns the lines that defines warnings/assert
    # @param self : object pointer
    # @return list of lines
    def get_list_for_warnings (self):
        return self.list_for_warnings

    ##
    # Prepare all the data stored in dataContainer in list of lines to be printed
    # @param self : object pointer
    # @return
    def prepare_for_print(self):
        # Concern the filling of the _definition.h file
        # To do first, because modifies some variables (Boolean -> real discrete)
        self.prepare_for_definitions_for_h()

        # Concern the filling of the C file
        self.prepare_for_externalcalls()
        self.prepare_for_externalcalls_header()
        self.prepare_for_setf()
        self.prepare_for_evalmode()
        self.prepare_for_setz()
        self.prepare_for_setg()
        self.prepare_for_setg_equations()
        self.prepare_for_sety0()
        self.prepare_for_initrpar()
        self.prepare_for_setupdatastruc()
        self.prepare_for_setytype()
        self.prepare_for_setftype()
        self.prepare_for_defelem()
        self.prepare_for_setsharedparamsdefaultvalue()
        self.prepare_for_setparams()
        self.prepare_for_evalfadept()
        self.prepare_for_setvariables()
        self.prepare_for_defineparameters()
        self.prepare_for_literalconstants()
