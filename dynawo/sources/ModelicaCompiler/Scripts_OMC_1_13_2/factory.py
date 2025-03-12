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

ADEPT_SUFFIX= "_adept "
ADEPT_DOUBLE= "adept::adouble"


def cmp_to_key_dynawo(mycmp):
    """Convert a cmp= function into a key= function"""
    class K(object):
        __slots__ = ['obj']
        def __init__(self, obj, *args):
            self.obj = obj
        def __lt__(self, other):
            return mycmp(self.obj, other.obj) < 0
        def __gt__(self, other):
            return mycmp(self.obj, other.obj) > 0
        def __eq__(self, other):
            return mycmp(self.obj, other.obj) == 0
        def __le__(self, other):
            return mycmp(self.obj, other.obj) <= 0
        def __ge__(self, other):
            return mycmp(self.obj, other.obj) >= 0
        def __ne__(self, other):
            return mycmp(self.obj, other.obj) != 0
        def __hash__(self):
            raise TypeError('hash not implemented')
    return K
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
        filtered_iter = filter( filter_desc_data, self.reader.function_zero_crossing_description_raw_func.get_body() )
        filtered_func = list(filtered_iter)


        indexes_to_filter = []
        self.number_of_zero_crossings = -2 #to ignore opening and closing {
        nb_zero_crossing_tot = -1; #to ignore opening {
        for line in filtered_func :
            if "time > 999999.0" not in line and "delayZeroCrossing" not in line:
                self.function_zero_crossing_description_raw_func.append(line)
                self.number_of_zero_crossings +=1
            else:
                indexes_to_filter.append(nb_zero_crossing_tot)
                if "static const char *res[] =" in line and "}" not in line: #this is the first g equation and there is more than 1 equation
                    new_line = line.replace("\"time > 999999.0\",","")
                    new_line = new_line.rstrip()
                    self.function_zero_crossing_description_raw_func.append(new_line)
                elif "static const char *res[] =" not in line and "}" in line: #this is the last g equation
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
        filtered_iter = filter( filter_eq_data, self.reader.function_zero_crossings_raw_func.get_body() )
        filtered_func = list(filtered_iter)

        nb_zero_crossing_tot = 0;
        variable_to_filter = []
        for line in filtered_func :
            if "gout" in line:
                if nb_zero_crossing_tot in indexes_to_filter:
                    variable_to_filter.extend(find_all_temporary_variable_in_line(line))
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
        ## List of discrete variables
        self.list_vars_discr = []
        ## List of ALL discrete variables (including booleans)
        self.list_all_vars_discr = []
        ## Number of discrete variables
        self.nb_z = 0
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

        ## List of all boolean items
        self.list_all_bool_items = []

        ## Dictionary complex calculated variable name=>indexes of calculated variables required to compute it
        self.dic_calc_var_recursive_deps = {}
        ## Dictionary complex calculated variable name=>index
        self.dic_calc_var_index = {}

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
        # List of adept types
        self.list_adept_structs = []

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
        ## List of equations to add in setY0 function
        self.list_for_callcustomparametersconstructors = []
        ## List of equations to add in setFOmc function
        self.list_for_setf = []
        ## List of equations to add in evalMode function
        self.list_for_evalmode = []
        ## List of equations to add in setZ function
        self.list_for_setz = []
        ## List of equations to add in collectSilentZ function
        self.list_for_collectsilentz = []
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
        ## List of equations to add in evalStaticYType_omc function
        self.list_for_evalstaticytype = []
        ## List of equations to add in evalDynamicYType_omc function
        self.list_for_evaldynamicytype = []
        ## List of equations to add in evalStaticFType function
        self.list_for_evalstaticftype = []
        ## List of equations to add in evalDynamicFType function
        self.list_for_evaldynamicftype = []
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
        ## List of equations to define warnings
        self.list_for_parameters_warnings = []
        ## List of formula of equations to define setFequations function
        self.listfor_setfequations = []
        ## List of formula of root equations to define setGequations function
        self.list_for_setgequations = []
        ## List of equations identified in _16dae file
        self.list_eq_maker_16dae = []
        ## List of equations to add in evalCalculatedVars
        self.list_for_evalcalculatedvars = []
        ## List of equations to add in evalCalculatedVarI
        self.list_for_evalcalculatedvari = []
        ## List of equations to add in evalCalculatedVarIAdept
        self.list_for_evalcalculatedvariadept = []
        ## List of equations to add in getIndexesOfVariablesUsedForCalculatedVarI
        self.list_for_getindexofvarusedforcalcvari = []

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

        ## modes structure objects
        self.modes = Modes()
        ## number of existing relations (in the code generated by OM)
        self.nb_existing_relations = 0
        ## relationx index used by omc to the equivalent relation index in dynawo
        self.omc_relation_index_2_dynawo_relations_index = {}
        ## number of relations created by the Python scripts
        self.nb_created_relations = 0

        ## constant used to dump a line with an assignment
        self.assignment_format = "  %s = %s;\n"
        ## constant used to dump a comment with a omc function name
        self.ptrn_f_name ="  // ----- %s -----\n"

    ##
    # Getter to obtain the number of dynamic equations
    # @param self : object pointer
    # @return number of dynamic equations
    def get_nb_eq_dyn(self):
        return self.nb_eq_dyn

    ##
    # Getter to obtain the number of calculated variables
    # @param self : object pointer
    # @return number of calculated variables
    def get_nb_calculated_variables(self):
        return len(self.reader.list_calculated_vars)

    ##
    # Getter to obtain the number of constant variables
    # @param self : object pointer
    # @return number of constant variables
    def get_nb_const_variables(self):
        return len(self.reader.list_complex_const_vars)

    ##
    # Getter to obtain all the equations defining the model
    # @param self : object pointer
    # @return list of equations
    def get_list_eq_syst(self):
        return self.list_eq_syst

    ##
    # Getter to obtain the number of modes
    # @param self : object pointer
    # @return number of modes
    def get_nb_modes(self):
        nb = len(self.modes.relations) + len(self.modes.modes_discretes)
        if self.create_additional_relations():
            nb += len(self.modes.created_relations)
        return nb

    def get_nb_delays(self):
        return len(self.reader.list_delay_defs)

    def keep_continous_modelica_reinit(self):
        return False

    ##
    # Indicates if additional relations should be created by the Python scripts
    # @param self : object pointer
    # @return boolean - true if additional relations should be created
    def create_additional_relations(self):
        return True

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
        self.list_vars_der = list(filter (is_der_real_var, list_vars_read)) # Derived from state vars
        self.list_vars_discr =  list(filter(is_discrete_real_var, list_vars_read)) # Vars discrete real
        self.list_vars_int =  list(filter(is_integer_var, list_vars_read)) # Vars integer
        self.list_vars_bool =  list(filter(is_bool_var, list_vars_read)) # Vars boolean
        self.list_vars_when =  list(filter(is_when_var, list_vars_read)) # Vars when (bool & "$whenCondition")
        self.list_vars_dummy =  list(filter(is_dummy_var, list_vars_read))

        self.list_params_real =  list(filter(is_param_real, list_vars_read)) # Real Params (all)

        self.list_params_bool =  list(filter(is_param_bool, list_vars_read)) # Params booleans (all)

        self.list_params_integer =  list(filter(is_param_integer, list_vars_read)) # Full Params (all)
        self.list_params_string =  list(filter(is_param_string, list_vars_read)) # Params string (all)

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

        self.list_vars_syst = list(filter(is_syst_var, list_vars_read))
        tmp_list = []
        for var in self.list_vars_syst:
            if var not in self.reader.list_calculated_vars and not is_ignored_var(var.get_name()):
                tmp_list.append(var)
        self.list_vars_syst = tmp_list
        self.list_all_vars = filter(is_var, list_vars_read)
        tmp_list = []
        for var in self.list_all_vars:
            if var not in self.list_vars_when and not is_ignored_var(var.get_name()):
                tmp_list.append(var)
        self.list_all_vars = tmp_list
        self.list_all_vars_discr = self.list_vars_discr + self.list_vars_bool
        self.nb_z = self.reader.nb_discrete_vars

        ## type of each variables
        self.var_by_type = {}
        for var in list_vars_read:
            type_var = var.get_type()
            self.var_by_type[var.get_name()] = type_var

        self.list_all_bool_items = self.list_vars_bool + self.list_params_bool

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
        for v in self.list_all_vars :
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            var_name = v.get_name()
            if var_name in list_flow_vars :
                v.set_flow_dyn_type()

        # List of names of discrete vars
        for v in self.list_all_vars_discr:
            self.list_name_discrete_vars.append( v.get_name() )

        # List of names of integer vars
        for v in self.list_vars_int:
            self.list_name_integer_vars.append( v.get_name() )

        index = 0
        ptrn_calc_var = re.compile(r'SHOULD NOT BE USED - CALCULATED VAR \/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
        for var in self.reader.list_calculated_vars:
            self.dic_calc_var_index[var.get_name()] = index
            index += 1
        for var in self.reader.list_calculated_vars:
            expr = self.reader.dic_calculated_vars_values[var.get_name()]
            if type(expr)==list:
                for line in expr:
                    line_tmp = transform_line(line)
                    match = ptrn_calc_var.findall(line_tmp)
                    for name in match:
                        if var.get_name() not in self.dic_calc_var_recursive_deps:
                            self.dic_calc_var_recursive_deps[var.get_name()] = []
                        self.dic_calc_var_recursive_deps [var.get_name()].append(name)

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
        name_func_to_search = {}
        for func in list_omc_functions:
            name_func_to_search[func.get_name()] = func

        # Analysis of MainC functions => if external call => will be added to setFOMC
        list_body_to_analyse = []
        list_body_to_append = []
        list_body_to_append_to_z = []

        for eq_mak in self.list_eq_maker_16dae:
            tag = find_value_in_map( map_tags_num_eq, eq_mak.get_num_omc() )
            if eq_mak.get_evaluated_var() == "" and tag == 'algorithm' and eq_mak.with_throw(): continue
            if (eq_mak.get_evaluated_var() == "" and tag != 'when') or (eq_mak.get_evaluated_var() != "" and tag == 'algorithm'):
                # call to a function and not evaluation of a variable
                body = eq_mak.get_body()
                body_tmp=[]
                for line in body:
                    if THREAD_DATA_OMC_PARAM in line:
                        line=line.replace(THREAD_DATA_OMC_PARAM, "")
                        body_tmp.append(line)
                    #removing of clean ifdef
                    elif HASHTAG_IFDEF not in line and HASHTAG_ENDIF not in line \
                            and "SIM_PROF_" not in line and "NORETCALL" not in line:
                        body_tmp.append(line)

                list_body_to_analyse.append(body_tmp)

        global_pattern_index = 0
        dic_var_name_to_temporary_name = {}
        tmp_var_to_declare = []

        ptrn_evaluated_var = re.compile(r'[ \(]*data->localData(?P<var>\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ \)]* = [ ]*(?P<rhs>[^;]+);')
        ptrn_tmp_decl = re.compile(r'(?P<type>[\w\_]+)\s*tmp[0-9]+\s*;')
        # functions calling an external function ???
        for body in list_body_to_analyse:
            new_body = []
            is_discrete = False
            found = False
            use_temporary_var = False
            function_name = ""
            for line in body:
                for name in name_func_to_search:
                    ptrn_function = re.compile(r'[ \(]*data->localData(?P<var>\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ \)]* = [ ]*'+name+'[ ]*\((?P<rhs>[^;]+);')
                    ptrn_function_tmp = re.compile(r'[ ]*tmp[0-9]+[ ]* = [ ]*'+name+'[ ]*\((?P<rhs>[^;]+);')
                    match = re.match(ptrn_function, line)
                    if match is not None:
                        variables_set_by_omc_function = self.find_variables_set_by_omc_function(line, name_func_to_search[name], None)
                        discrete_variables_set_by_omc_function = self.find_discrete_variables_set_by_omc_function(line, name_func_to_search[name])
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
                    else:
                        match_tmp = re.match(ptrn_function_tmp, line)
                        if match_tmp is not None:
                            found = True
                            use_temporary_var = True
                if "omc_assert" in line or "omc_terminate" in line:
                    found = True
                match_eval = re.search(ptrn_tmp_decl, line)
                if match_eval is not None:
                    tmp_var_to_declare.append(line)
                else:
                    match_eval = re.search(ptrn_evaluated_var, line)
                    if use_temporary_var and match_eval is not None:
                        eq = EquationBasedOnExternalCall(
                                      function_name,
                                      [line], \
                                      name, \
                                      to_param_address(name), \
                                      [], \
                                      "external_call_"+str(self.nb_eq_dyn), \
                                      -1 )
                        eq.set_num_dyn(self.nb_eq_dyn)
                        self.nb_eq_dyn += 1
                        self.list_additional_equations_from_call_for_setf.append(eq)
                    else:
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

            for tmp_var in tmp_var_to_declare:
                self.list_call_for_setf.append(tmp_var)
            # Add the functions concerned
            for body in list_body_to_append:
                self.list_call_for_setf.extend(body)

            for name in dic_var_name_to_temporary_name.keys():
                test_param_address(name)
                eq = EquationBasedOnExternalCall(
                              function_name,
                              [to_param_address(name) + " /* " + name + " */ = " + dic_var_name_to_temporary_name[name]+";"], \
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
            if (tag == 'when' and not eq_mak.get_is_modelica_reinit() and len(list(filter(lambda x,eq_mak=eq_mak: (x.get_name() == eq_mak.get_evaluated_var()),self.list_all_vars_discr+self.list_vars_int))) == 0):
                body = eq_mak.get_body()
                body_tmp = self.handle_body_for_discrete(body, name_func_to_search, global_pattern_index)

                if any(ext in " ".join(body_tmp) for ext in self.list_when_eq_to_filter):
                    continue
                if "infoStreamPrint" in " ".join(body_tmp):
                    # filter assert
                    continue
                self.list_call_for_setz.extend(body_tmp)

        for body in list_body_to_append_to_z:
            body_tmp = self.handle_body_for_discrete(body, name_func_to_search, global_pattern_index)
            self.list_call_for_setz.extend(body_tmp)


    def handle_body_for_discrete(self, body, name_func_to_search, global_pattern_index):
        list_bool_var_names = [item.get_name() for item in self.list_all_bool_items]
        body_tmp = []
        for line in body:
            ## When an integer is set by passing a reference to into a function parameter,
            ## need to use an intermediate modelica_integer var to set the double value on Dynawo side
            found = False
            for name in name_func_to_search:
                if name+"(" in line or name +" (" in line:
                    variables_to_replace = self.find_discrete_variables_set_by_omc_function(line, name_func_to_search[name])
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

                    line = line.replace(THREAD_DATA_OMC_PARAM, "")
                    body_tmp.append(line)

                    for key in dic_var_name_to_temporary_name.keys():
                        body_tmp.append("  "+to_param_address(key) + " /* " + key + " DISCRETE */ = " + dic_var_name_to_temporary_name[key]+";\n")
                    found = True
            if not found:
                if THREAD_DATA_OMC_PARAM in line:
                    line = line.replace(THREAD_DATA_OMC_PARAM, "")
                    body_tmp.append(line)
                #removing of clean ifdef
                elif HASHTAG_IFDEF not in line and HASHTAG_ENDIF not in line \
                        and "SIM_PROF_" not in line and "NORETCALL" not in line:
                    body_tmp.append(line)
        return body_tmp

    def find_discrete_variables_set_by_omc_function(self, line_with_call, func):

        def filter_discrete_var(var_name):
            return "integerDoubleVars" in to_param_address(var_name) or "discreteVars" in to_param_address(var_name)

        return self.find_variables_set_by_omc_function(line_with_call, func, \
                lambda var_name: filter_discrete_var(var_name))

    def find_variables_set_by_omc_function(self, line_with_call, func, filter):
        outputs = func.find_outputs_from_call(line_with_call)
        variables_to_replace = []
        for var_name in outputs:
            if filter is None or filter(var_name):
                variables_to_replace.append(var_name)
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
            if name not in variables_to_replace: continue
            replacement_string = "@@@" + str(global_pattern_index) + "@@@"
            line = line.replace("data->localData["+str(idx)+"]->"+add, replacement_string)
            map_to_replace[replacement_string] = prefix_temporary_var+str(global_pattern_index)
            dic_var_name_to_temporary_name[name] = map_to_replace[replacement_string]
            global_pattern_index +=1
        match = ptrn_var_no_desc.findall(line)
        for idx, add, name in match:
            if name not in variables_to_replace: continue
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

        # Build the eqMaker for functions of the dae *.c file
        for f in self.reader.list_func_16dae_c:
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

            if name_var_eval is not None and self.reader.is_fictitious_residual_vars(name_var_eval):
                continue

            list_depend = [] # list of vars on which depends the function
            if name_var_eval is not None:
                if len(list(filter(lambda x, name = name_var_eval : x.get_name() == name, self.list_vars_syst))) == 0 and \
                  len(list(filter(lambda x, name = name_var_eval+".re" : x.get_name() == name, self.list_vars_syst))) > 0 and \
                  len(list(filter(lambda x, name = name_var_eval+".im" : x.get_name() == name, self.list_vars_syst))) > 0:
                    eq_mak.set_complex_eq(True)
                eq_mak.set_evaluated_var(name_var_eval)
                list_depend.append(name_var_eval) # The / equation function depends on the var it evaluates
                if name_var_eval in map_dep.keys():
                    list_depend.extend( map_dep[name_var_eval] ) # We get the other vars (from *._info.xml)

                eq_mak.set_depend_vars(list_depend)
                eq_type = ALGEBRAIC
                if len(list(filter(lambda x, name = name_var_eval : x.get_name() == name, self.list_vars_der))) > 0:
                    eq_type = DIFFERENTIAL
                elif name_var_eval in self.reader.var_name_to_eq_type:
                    eq_type = self.reader.var_name_to_eq_type[name_var_eval]
                eq_mak.set_type( eq_type )

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

        list_residual_vars_for_sys_build = sorted(self.reader.residual_vars_to_address_map.keys())
        for var_name in list_residual_vars_for_sys_build:
            for eq in filter(lambda x: (not x.get_is_modelica_reinit()) and (x.get_evaluated_var() == var_name), self.list_all_equations):
                self.list_eq_syst.append(eq)

        list_vars_for_sys_build = itertools.chain(self.list_vars_syst, self.list_vars_der)
        for var in list_vars_for_sys_build:
            for eq in filter(lambda x: (not x.get_is_modelica_reinit()) and (x.get_evaluated_var() == var.get_name()), self.list_all_equations):
                self.list_eq_syst.append(eq)

        list_vars_for_sys_build = itertools.chain(self.list_vars_syst, self.list_vars_der)
        for var in list_vars_for_sys_build:
            for eq in filter(lambda x: (not x.get_is_modelica_reinit()) and (x.complex_eq) and \
                             (x.get_evaluated_var()+".re" == var.get_name()), self.list_all_equations):
                self.list_eq_syst.append(eq)

        for var_name in self.reader.dummy_der_variables:
            name = "der("+var_name.replace("_dummy_der","")+")"
            for eq in filter(lambda x: (not x.get_is_modelica_reinit()) and (x.get_evaluated_var() == name), self.list_all_equations):
                self.list_eq_syst.append(eq)


        #... Sort the previous functions with their index in the main *.c file (and other *.c)
        self.list_eq_syst.sort(key = cmp_to_key_dynawo(cmp_equations))

        # ... we give them a number for DYNAWO
        i = 0 # num dyn of the equation
        for eq in self.list_eq_syst:
            var_name = eq.get_evaluated_var()
            if var_name not in self.reader.fictive_continuous_vars_der and not self.reader.is_auxiliary_vars(var_name):
                eq.set_num_dyn(i)
                i += 1
                if eq.complex_eq:
                    i+=1 # save an index for the imaginary part of the evaluated complex
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
                eq_type = ALGEBRAIC
                if var in self.list_vars_der > 0:
                    eq_type = DIFFERENTIAL
                elif var.get_name() in self.reader.var_name_to_eq_type:
                    eq_type = self.reader.var_name_to_eq_type[var.get_name()]
                equation = Equation(eq.get_body(), eq.get_evaluated_var(), eq.get_depend_vars(), "", eq.get_num_omc(), eq_type)
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
        keys = list(list_func_bodies_int_names.keys())
        keys.sort()
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

            if re.search(r'relationhysteresis\(tmp[0-9]+, data->localData\[0\]->timeValue, 999999.0, [0-9]+, Greater\);',transform_rawbody_to_string(r_obj.get_body_for_num_relation())):
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
        keys = list(list_func_bodies_discr_names.keys())
        keys.sort()
        for key in keys:
            z_equation = ZEquation(key)
            z_equation.set_body(list_func_bodies_discr_names[key])
            z_equation.prepare_body()
            if any(ext in " ".join(z_equation.get_body()) for ext in self.list_when_eq_to_filter):
                continue
            self.list_z_equations.append(z_equation)

        # add Modelica reinit equations
        keys = list(self.get_map_eq_reinit_discrete().keys())
        keys.sort()
        for var_name in keys:
            eq_list = self.get_map_eq_reinit_discrete()[var_name]
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
        # of relationhysteresis (...)).
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

    ## Build the modes connected objects
    # @param self : object pointer
    def build_modes(self):
        self.build_relations()
        self.build_modes_discretes()

    ##
    # Build the relations objects by parsing the existing equations
    # @param self : object pointer
    def build_relations(self):
        map_relations = {}
        # finding existing relations in system equations
        for eq in self.list_eq_syst:
            relations_found = re.findall(r'relationhysteresis\(data, &tmp[0-9]+, .*?, .*?, [0-9]+, .*?\);', transform_rawbody_to_string(eq.get_raw_body()))
            for relation in relations_found:
                index_relation = relation.split(", ")[4]
                eq_type = ALGEBRAIC
                if eq.get_type() == DIFFERENTIAL:
                    eq_type = DIFFERENTIAL
                elif eq.get_type() == MIXED:
                    eq_type = ALGEBRAIC
                assert(eq_type == ALGEBRAIC or eq_type == DIFFERENTIAL)
                map_relations[index_relation] = [eq_type, eq.get_src_fct_name()]

        # bulding relations objects
        content_to_analyze = transform_rawbody_to_string(self.reader.function_update_relations_raw_func.get_body()).split("else")[0];
        relations_found = re.findall(r'  data->simulationInfo->relations.*?= tmp[0-9]+;', content_to_analyze)
        self.nb_existing_relations = len(relations_found)
        content_to_analyze = list(self.zc_filter.get_function_zero_crossings_raw_func())
        gout_assignements = []
        gout_relations = []
        tmps_definition = []
        tmps_to_add = []
        tmps_assignment = []
        ptrn_gout_assignement = re.compile(r'[\s]*gout\[[0-9]+\] = [a-zA-Z]*.*?\;')
        ptrn_tmps_definition = re.compile(r'modelica_[a-z]+ tmp[0-9]+?;')
        ptrn_tmps_used = re.compile(r'tmp(?P<index>[0-9]+)')
        ptrn_relation = re.compile(r'data->simulationInfo->storedRelations\[(?P<index>[0-9]+)\].*;')
        accumulate = []
        accumulate_relation = []
        for line in content_to_analyze:
            if line.strip() == "{" or len(line.strip()) == 0:
                continue
            if ptrn_tmps_definition.search(line) is not None:
                tmps_definition.append(line)
                continue
            if ptrn_gout_assignement.search(line) is not None:
                accumulate.append(line)
                gout_assignements.append(accumulate)
                gout_relations.append(accumulate_relation)
                accumulate = []
                accumulate_relation = []
                continue
            for match in re.findall(ptrn_relation, line):
                accumulate_relation.append(match)
            accumulate.append(line)
        index = 0
        relations_already_handled = []
        for relations_table in gout_relations:
            relations = []
            for relation in relations_table:
                if relation in map_relations and relation  not in relations_already_handled:
                    relations.append(relation)
                    relations_already_handled.append(relation)
            if len(relations) > 0:
                index_relation = relations[0]
                for relation in relations:
                    self.omc_relation_index_2_dynawo_relations_index[relation] = index_relation
                eq = ""
                for line in gout_assignements[index]:
                    if ptrn_gout_assignement.search(line) is not None:
                        eq = "  data->simulationInfo->relations[TO_REPLACE] = " + "=".join(line.split("=")[1:]).split("?")[0] +";\n"
                    elif re.search(r'tmp[0-9]+ = [a-zA-Z]*.*?\;', line) is not None:
                        for relation in relations:
                            line = line.replace("data->simulationInfo->storedRelations["+relation+"]","data->simulationInfo->storedRelations["+index_relation+"]")
                        tmps_assignment.append(line)
                        for match in re.findall(ptrn_tmps_used, line):
                            if "tmp"+match not in tmps_to_add:
                                tmps_to_add.append("tmp"+match)
                    else :
                        continue
                relation_to_add = Relation(index_relation, map_relations[index_relation][0])
                for index2 in range(1,len(map_relations[index_relation])):
                    relation_to_add.add_eq(map_relations[index_relation][index2])
                relation_to_add.set_body_definition(replace_var_names(eq.replace("TO_REPLACE", str(index_relation))))
                self.modes.add_relation(relation_to_add)

            index+=1
        self.add_tmps_for_modes(tmps_to_add, tmps_assignment, tmps_definition, False)

        if self.create_additional_relations():
            # finding hidden relations in system equations and create them
            tmps_assignment = []
            tmps_definition = []
            tmps_to_add = []
            index_additional_relation = 0
            for eq in self.list_eq_syst:

                no_event_nodes = []
                if eq.get_evaluated_var() in self.reader.var_name_to_mixed_residual_vars_types:
                    no_event_nodes = self.reader.var_name_to_mixed_residual_vars_types[eq.get_evaluated_var()].get_no_event()

                index_if = 0
                for line in eq.get_body():
                    if (re.search(r'modelica_[a-z]+ tmp[0-9]+?;', line)):
                        tmps_definition.append(str(line).replace("  ", ""))
                    if (re.search(r'tmp[0-9]+ = [a-zA-Z]*.*?\;', line)):
                        tmps_assignment.append(str(line).replace("  ", ""))
                    if (("Greater" in line or "Less" in line) and "relationhysteresis" not in line  and not no_event_nodes[index_if]):
                        tmps_relation = find_all_temporary_variable_in_line(line)
                        for tmp in tmps_relation:
                            tmps_to_add.extend(add_tmp_update_relations(tmp, tmps_assignment, tmps_to_add))
                        index_relation_to_create = index_additional_relation + self.nb_existing_relations
                        index_additional_relation += 1
                        eq_type = eq.get_type()
                        relation_to_create = Relation(index_relation_to_create, eq_type)
                        relation_to_create.set_condition(line)
                        relation_to_create.add_eq(eq.get_src_fct_name())
                        relation_to_create.set_body_definition("  data->simulationInfo->relations[" + str(index_relation_to_create) + "] = " + line.split(" = ")[0].replace("tmp", "tmp_cr").replace("  ", "") + ";\n")
                        self.modes.add_created_relation(relation_to_create)
                        self.nb_created_relations = index_additional_relation
                    if "else" in line:
                        index_if +=1
            self.add_tmps_for_modes(tmps_to_add, tmps_assignment, tmps_definition, True)

    ##
    # Add tmps definitions and assignments
    # @param self : object pointer
    # @param tmps_to_add : list of tmps to consider
    # @param tmps_assignment : list of tmps assignment to consider
    # @param tmps_definition : list of tmps definitions to consider
    # @param created_relation_tmp : indicates if the tmp is a tmp related to created_relation
    def add_tmps_for_modes(self, tmps_to_add, tmps_assignment, tmps_definition, created_relation_tmp):
        tmps_to_add.sort()
        for tmp_to_add in tmps_to_add:
            for tmp_definition in tmps_definition:
                if find_all_temporary_variable_in_line(tmp_definition)[0] == tmp_to_add:
                    if created_relation_tmp:
                        tmp_definition = tmp_definition.replace("tmp", "tmp_cr")
                        self.modes.add_to_body_for_tmps_created_relations("  " + tmp_definition)
                    else:
                        tmp_definition = tmp_definition + "\n"
                        self.modes.add_to_body_for_tmps("  " + tmp_definition)
            for tmp_assignment in tmps_assignment:
                if find_all_temporary_variable_in_line(tmp_assignment)[0] == tmp_to_add:
                    if created_relation_tmp:
                        tmp_assignment = replace_var_names(tmp_assignment).replace("tmp", "tmp_cr")
                        self.modes.add_to_body_for_tmps_created_relations("  " + tmp_assignment)
                    else:
                        tmp_assignment = replace_var_names(tmp_assignment) + "\n"
                        self.modes.add_to_body_for_tmps("  " + tmp_assignment)

    ##
    # Build the modes_z and modes_bool map by using the dependencies between variables
    # @param self : object pointer
    def build_modes_discretes(self):
        for eq in self.list_eq_syst:
            for var in eq.get_depend_vars():
                if (var in self.list_name_discrete_vars or var in self.list_name_integer_vars):
                    boolean = False
                    for var_bool in self.list_vars_bool:
                        if var_bool.name == var:
                            boolean = True
                    evaluated_var = eq.get_evaluated_var()
                    if (eq.get_type() == DIFFERENTIAL or eq.get_type() == MIXED):
                        if (var not in self.modes.modes_discretes):
                            self.modes.modes_discretes[var] = ModeDiscrete(eq.get_type(), boolean)
                    elif (evaluated_var not in self.list_name_discrete_vars and evaluated_var not in self.list_name_integer_vars):
                        if (var not in self.modes.modes_discretes):
                            self.modes.modes_discretes[var] = ModeDiscrete(eq.get_type(), boolean)
                        else:
                            self.modes.modes_discretes[var].set_type(eq.get_type())
                    else:
                        continue
                    self.modes.modes_discretes[var].add_eq(eq.get_src_fct_name())

        for eq in self.list_int_equations:
            relations_found = re.findall(r'relationhysteresis\(tmp[0-9]+, .*?, .*?, [0-9]+, .*?\);', transform_rawbody_to_string(eq.get_body()))
            for _ in relations_found:
                self.modes.modes_discretes[eq.get_name()] = ModeDiscrete(ALGEBRAIC, False)

        for var in self.reader.list_calculated_vars :
            if var.get_alias_name() != "":
                if (var.get_name() not in self.modes.modes_discretes):
                    self.modes.modes_discretes[var.get_alias_name()] = ModeDiscrete(ALGEBRAIC, False)
                else:
                    self.modes.modes_discretes[var.get_alias_name()].set_type(ALGEBRAIC)


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
            do_it = True
            for line in warning.get_body_for_setf():
                if "SHOULD NOT BE USED" in line:
                    do_it = False
                    break
            if do_it:
                self.list_warnings.append(warning)
        map_tags_num_eq = self.reader.get_map_tag_num_eq()
        for eq in self.list_all_equations:
            tag = find_value_in_map( map_tags_num_eq, eq.get_num_omc() )
            if eq.get_evaluated_var() == "" and tag == 'algorithm' and eq.with_throw():
                warning = Warn(eq.get_body())
                warning.prepare_body()
                do_it = True
                for line in warning.get_body_for_setf():
                    if "SHOULD NOT BE USED" in line:
                        do_it = False
                        break
                if do_it:
                    self.list_warnings.append(warning)


    ##
    # prepare the equations/variables for setY0 methods
    # @param self : object pointer
    # @return
    def prepare_for_sety0(self):
        # In addition to system vars, discrete vars (bool or not) must be initialized as well
        # We concatenate system vars and discrete vars
        list_vars = itertools.chain(self.list_vars_syst, self.list_all_vars_discr, self.list_vars_int, self.reader.list_complex_const_vars)
        found_init_by_param_and_at_least2lines = False # for reading comfort when printing

        # sort by taking init function number read in *06inz.c
        list_vars = sorted(list_vars,key = cmp_to_key_dynawo(cmp_num_init_vars))
        calc_var_2_index = {}
        index=0
        for var in self.reader.list_calculated_vars:
            calc_var_2_index[var.get_name()] = index
            index += 1
        ptrn_calc_var = re.compile(r'SHOULD NOT BE USED - CALCULATED VAR[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
        # We prepare the results to print in setY0omc
        for var in list_vars :
            if var.is_alias() and  (to_param_address(var.get_name()).startswith("SHOULD NOT BE USED")): continue
            if var in self.reader.list_complex_calculated_vars: continue
            if var.get_use_start() and not (is_const_var(var) and var.get_init_by_param_in_06inz()):
                init_val = var.get_start_text()[0]
                if init_val == "":
                    init_val = "0.0"
                test_param_address(var.get_name())
                line = self.assignment_format % ( to_param_address(var.get_name()) + " /* " + var.get_name() + " */" , init_val )
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
                        for const_string in self.reader.list_of_stringconstants:
                            if const_string+"," in L:
                                L = L.replace(const_string+",", const_string+".c_str(),")
                            elif const_string+";" in L:
                                L = L.replace(const_string+";", const_string+".c_str();")
                            elif const_string+" " in L:
                                L = L.replace(const_string+" ", const_string+".c_str() ")
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
                        match = ptrn_calc_var.findall(L)
                        for name in match:
                            L = L.replace("SHOULD NOT BE USED - CALCULATED VAR /* " + name, \
                                                    "evalCalculatedVarI(" + str(calc_var_2_index[name]) + ") /* " + name)
                        self.list_for_sety0.append("  " + L)
                self.list_for_sety0.append("  }\n")

                if len(var.get_start_text_06inz()) > 1 : self.list_for_sety0.append("\n") # reading comfort
            elif is_const_var(var) and var.is_alias():
                test_param_address(var.get_name())
                alias_name = var.get_alias_name()
                test_param_address(alias_name)
                negated = "-" if var.get_alias_negated() else ""
                line = self.assignment_format % ( to_param_address(var.get_name()) + " /* " + var.get_name() + " */" , negated + to_param_address(alias_name) + " /* " + alias_name + " */" )
                line = replace_var_names(line)
                self.list_for_sety0.append(line)
            else:
                init_val = var.get_start_text()[0]
                if init_val == "":
                    init_val = "0.0"
                test_param_address(var.get_name())
                line = self.assignment_format % ( to_param_address(var.get_name()) + " /* " + var.get_name() + " */" , init_val )
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


    ##
    # prepare the equations/variables for setY0 methods
    # @param self : object pointer
    # @return
    def prepare_for_callcustomparametersconstructors(self):
        found_init_by_param_and_at_least2lines = False # for reading comfort when printing
        # Initialization of external objects
        for var in self.reader.external_objects :
            var.clean_start_text () # Clean up initialization text before printing

            # Lines for reading comfort at the impression
            if len(var.get_start_text()) > 1 :
                if not found_init_by_param_and_at_least2lines:
                    self.list_for_callcustomparametersconstructors.append("\n")
                found_init_by_param_and_at_least2lines = True
            else : found_init_by_param_and_at_least2lines = False

            for L in var.get_start_text() :
                if "FILE_INFO" not in L and "omc_assert_warning" not in L:
                    L = replace_var_names(L)
                    for const_string in self.reader.list_of_stringconstants:
                        if const_string+"," in L:
                            L = L.replace(const_string+",", const_string+".c_str(),")
                        elif const_string+";" in L:
                            L = L.replace(const_string+";", const_string+".c_str();")
                        elif const_string+" " in L:
                            L = L.replace(const_string+" ", const_string+".c_str() ")
                    self.list_for_callcustomparametersconstructors.append("  " + L)

            if len(var.get_start_text()) > 1 : self.list_for_callcustomparametersconstructors.append("\n") # reading comfort

    ##
    # return the list of lines that constitutes the body of callCustomParametersConstructors
    # @param self : object pointer
    # @return list of lines
    def get_list_for_callcustomparametersconstructors(self):
        if (len(self.reader.list_delay_defs) > 0):
            self.list_for_callcustomparametersconstructors.append("  // Delays\n")

        for item in self.reader.list_delay_defs:
            test_param_address(item["name"])
            if "delayMaxName" in item:
                item["delayMax"] = to_param_address(item["delayMaxName"])
            line_tmp = "  createDelay(" + item["exprId"] + \
            ", &(data->localData[" + item["timeId"] + "]->timeValue)" + \
            ", &(" + to_param_address(item["name"]) + ")" + \
            ", " + item["delayMax"] + ");\n"
            self.list_for_callcustomparametersconstructors.append(line_tmp)

        return self.list_for_callcustomparametersconstructors

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
                elif OMC_METATYPE_TMPMETA in line:
                    body.append(replace_modelica_strings(line))
                elif ("TRACE_PUSH" not in line) and ("TRACE_POP" not in line) and ("const int equationIndexes[2]" not in line):
                    body.append(line)
            body.append("\n\n")
        return body

    ##
    # dump an equation into Fomc body
    # @param self : object pointer
    # @return
    def dump_eq(self, eq):
        map_eq_reinit_continuous = self.get_map_eq_reinit_continuous()
        var_name = eq.get_evaluated_var()
        var_name_without_der = var_name [4 : -1] if 'der(' == var_name [ : 4] else var_name
        if var_name not in self.reader.fictive_continuous_vars_der:
            standard_eq_body = []
            standard_eq_body.append (self.ptrn_f_name %(eq.get_src_fct_name()))
            eq_body = (eq.get_body_for_setf())

            no_event_nodes = []
            if var_name in self.reader.var_name_to_mixed_residual_vars_types:
                no_event_nodes = self.reader.var_name_to_mixed_residual_vars_types[var_name].get_no_event()

            index_if = 0
            if self.create_additional_relations():
                index = 0
                index_relation = 0
                for line in eq_body:
                    if (("Greater" in line or "Less" in line) and "relationhysteresis" not in line and not no_event_nodes[index_if]):
                        index_relations = self.modes.find_index_relation(eq.get_src_fct_name())
                        assert(len(index_relations) > 0 and index_relation < len(index_relations))
                        eq_body[index] = self.transform_in_relation(line, index_relations[index_relation])
                        index_relation += 1
                    if "else" in line:
                        index_if +=1
                    index += 1
            standard_eq_body.extend(eq_body)

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
    # dump the lines of the system equation in the body of setF
    # @param self : object pointer
    # @return
    def dump_eq_syst_in_setf(self):
        algebraic_eq = []
        differential_eq = []
        mixed_eq = []
        for eq in self.get_list_eq_syst():
            if eq.get_type() == DIFFERENTIAL:
                differential_eq.append(eq)
            elif eq.get_type() == ALGEBRAIC:
                algebraic_eq.append(eq)
            else:
                mixed_eq.append(eq)
        if len(algebraic_eq) > 0:
            self.list_for_setf.append("  if (type != DIFFERENTIAL_EQ) {\n")
            for eq in algebraic_eq:
                self.dump_eq(eq)
            self.list_for_setf.append("  }\n")
        if len(differential_eq) > 0:
            self.list_for_setf.append("  if (type != ALGEBRAIC_EQ) {\n")
            for eq in differential_eq:
                self.dump_eq(eq)
            self.list_for_setf.append("  }\n")
        if len(mixed_eq) > 0:
            for eq in mixed_eq:
                self.dump_eq(eq)

    ##
    # dump the lines of the warning in the body of checkDataCoherence
    # @param self : object pointer
    # @return
    def dump_warnings_in_checkdatacoherence(self):
        for warn in self.list_warnings:
            if warn.get_is_parameter_warning():
                self.list_for_parameters_warnings.append("{\n")
                self.list_for_parameters_warnings.extend(warn.get_body_for_setf())
                self.list_for_parameters_warnings.append("\n\n")
                self.list_for_parameters_warnings.append("}\n")
            else:
                self.list_for_warnings.append("{\n")
                self.list_for_warnings.extend(warn.get_body_for_setf())
                self.list_for_warnings.append("\n\n")
                self.list_for_warnings.append("}\n")

    ##
    # dump the lines of the warning in the body of setF
    # @param self : object pointer
    # @return
    def dump_external_calls_in_setf(self):
        if len(self.list_call_for_setf) > 0:
            self.list_for_setf.append("  // -------------- call functions ----------\n")
            self.list_for_setf.extend(self.filter_external_function_call())


            algebraic_eq = []
            differential_eq = []
            mixed_eq = []
            for eq in self.list_additional_equations_from_call_for_setf:
                if eq.get_type() == DIFFERENTIAL:
                    differential_eq.append(eq)
                elif eq.get_type() == ALGEBRAIC:
                    algebraic_eq.append(eq)
                else:
                    mixed_eq.append(eq)
            if len(algebraic_eq) > 0:
                self.list_for_setf.append("  if (type != DIFFERENTIAL_EQ) {\n")
                for eq in algebraic_eq:
                    standard_eq_body = []
                    standard_eq_body.append (self.ptrn_f_name %(eq.get_src_fct_name()))
                    standard_eq_body.append ("  ")
                    standard_eq_body.extend(eq.get_body_for_setf())
                    standard_eq_body.append ("\n"  )
                    self.list_for_setf.extend(standard_eq_body)
                self.list_for_setf.append("  }\n")
            if len(differential_eq) > 0:
                self.list_for_setf.append("  if (type != ALGEBRAIC_EQ) {\n")
                for eq in differential_eq:
                    standard_eq_body = []
                    standard_eq_body.append (self.ptrn_f_name %(eq.get_src_fct_name()))
                    standard_eq_body.append ("  ")
                    standard_eq_body.extend(eq.get_body_for_setf())
                    standard_eq_body.append ("\n"  )
                    self.list_for_setf.extend(standard_eq_body)
                self.list_for_setf.append("  }\n")
            if len(mixed_eq) > 0:
                for eq in mixed_eq:
                    standard_eq_body = []
                    standard_eq_body.append (self.ptrn_f_name %(eq.get_src_fct_name()))
                    standard_eq_body.append ("  ")
                    standard_eq_body.extend(eq.get_body_for_setf())
                    standard_eq_body.append ("\n"  )
                    self.list_for_setf.extend(standard_eq_body)

            self.list_for_setf.append("\n\n")

    ##
    # prepare the lines that constitutes the body of setF
    # @param self : object pointer
    # @return
    def prepare_for_setf(self):
        self.dump_eq_syst_in_setf()
        self.dump_warnings_in_checkdatacoherence()
        self.dump_external_calls_in_setf()

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_setf)

        # remove atan3, replace pow by pow_dynawo
        for index, line in enumerate(self.list_for_setf):
            if "omc_Modelica_Math_atan3" in line:
                line = transform_atan3_operator(line)
            if "pow(" in line:
                line = replace_pow(line)
            line = replace_relation_indexes(line, self.omc_relation_index_2_dynawo_relations_index)
            self.list_for_setf [index] = line

    def transform_in_relation(self, line, index_relation):
        tmp_to_define = find_all_temporary_variable_in_line(line)[0]
        parenthesis_split = re.findall(r'Greater\(.*,|Less\(.*,|GreaterEq\(.*,|LessEq\(.*,|Greater<adept::adouble>\(.*,|Less<adept::adouble>\(.*,|GreaterEq<adept::adouble>\(.*,|LessEq<adept::adouble>\(.*,', line)[0].split("(")
        comparator = parenthesis_split[0]
        variable_1 = '('.join(parenthesis_split[1:]).split(",")[0]
        variable_2 = re.findall(r',.*?;', line)[0].rsplit(")", 1)[0]
        line = line.split("tmp")[0] + "relationhysteresis(" + tmp_to_define + ", " + variable_1 + variable_2 + ", 0., 0., " + str(index_relation) + "," + comparator + ");\n"
        return line

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
            if "  static const char *res[] = {" != line and "  };" != line.rstrip():
                nb_zero_crossing +=1
        for i in range(nb_zero_crossing):
            value = "res[" + str(i) + "]"
            self.list_for_setgequations.append( line_ptrn_res %(i, value))
        self.list_for_setgequations.append("// -----------------------------\n")

        nb_root = nb_zero_crossing
        line_when_ptrn = "  // ------------- %s ------------\n"
        for r_obj in self.list_root_objects:
            if r_obj.get_num_dyn() == -1 or r_obj.get_duplicated_in_zero_crossing():
                continue
            self.list_for_setgequations.append(line_when_ptrn %(r_obj.get_when_var_name()))
            when_string = r_obj.get_when_var_name() + ":" + transform_rawbody_to_string(r_obj.get_body_for_num_relation())
            self.list_for_setgequations.append( line_ptrn % (nb_root, when_string ) )
            self.list_for_setgequations.append(" \n")
            nb_root += 1

        if self.create_additional_relations():
            self.list_for_setgequations.extend(self.modes.get_body_for_setgequations(nb_root))

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
        self.list_for_evalmode.extend("  modeChangeType_t modeChangeType = NO_MODE;\n \n")

        ## adding first the modes related to relations
        self.list_for_evalmode.extend(self.modes.get_body_for_evalmode())

        if (self.keep_continous_modelica_reinit()):
            for var_name, eq_list in self.get_map_eq_reinit_continuous().iteritems():
                for eq in eq_list:
                    self.list_for_evalmode.append("\n  // mode linked with " + var_name + "\n")
                    self.list_for_evalmode.extend (eq.get_body_for_evalmode())
                    self.list_for_evalmode.append("\n")

        self.list_for_evalmode.append("  return modeChangeType;\n")

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_evalmode)

    ##
    # returns the lines that constitues the body of evalMode
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalmode(self):
        return self.list_for_evalmode

    ##
    # prepare the lines that constitues the body of collectSilentZ
    # @param self : object pointer
    # @return
    def prepare_for_collectsilentz(self):
        opening_bracket = "  silentZTable["
        end_of_line = " */;\n"
        already_handled = []
        for var in itertools.chain(self.reader.silent_discrete_vars_not_used_in_discr_eq, self.reader.silent_discrete_vars_not_used_in_continuous_eq):
            if var in already_handled: continue
            already_handled.append(var)
            test_param_address(var)
            address = to_param_address(var)
            index = address.split("[")[2].replace("]","")
            not_used_in_discr=var in self.reader.silent_discrete_vars_not_used_in_discr_eq
            not_used_in_cont = var in self.reader.silent_discrete_vars_not_used_in_continuous_eq
            if not_used_in_discr and not_used_in_cont:
                flag = "NotUsedInDiscreteEquations | NotUsedInContinuousEquations"
            elif not_used_in_discr:
                flag = "NotUsedInDiscreteEquations"
            else:
                flag = "NotUsedInContinuousEquations"
            if "integerDoubleVars" in address:
                self.list_for_collectsilentz.append(opening_bracket + str(int(self.nb_z) + int(index)) +"].setFlags("+flag+") /*" + var +end_of_line)
            else:
                self.list_for_collectsilentz.append(opening_bracket + index +"].setFlags("+flag+") /*" + var +end_of_line)

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
                elif OMC_METATYPE_TMPMETA in line:
                    line_tmp = replace_modelica_strings(line)
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
        index = 0
        for line in self.list_for_setz:
            self.list_for_setz[index] = replace_relation_indexes(line, self.omc_relation_index_2_dynawo_relations_index)
            index+=1

    ##
    # returns the lines that constitues the body of setF
    # @param self : object pointer
    # @return list of lines
    def get_list_for_setz(self):
        return self.list_for_setz

    ##
    # returns the lines that constitues the body of collectSilentZ
    # @param self : object pointer
    # @return list of lines
    def get_list_for_collectsilentz(self):
        return self.list_for_collectsilentz

    ##
    # prepare the lines that constitues the body of setG
    # @param self : object pointer
    # @return
    def prepare_for_setg(self):
        line_ptrn = "  gout[%s] = ( %s ) ? ROOT_UP : ROOT_DOWN;\n"
        line_when_ptrn = "  // ------------- %s ------------\n"
        calc_var_2_index = {}
        index=0
        for var in self.reader.list_calculated_vars:
            calc_var_2_index[var.get_name()] = index
            index += 1
        ptrn_calc_var = re.compile(r'SHOULD NOT BE USED - CALCULATED VAR[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
        for r_obj in self.list_root_objects:
            if r_obj.get_num_dyn() == -1 or r_obj.get_duplicated_in_zero_crossing():
                continue
            self.list_for_setg.append(line_when_ptrn %(r_obj.get_when_var_name()))
            self.list_for_setg.extend(r_obj.get_body_for_num_relation())
            self.list_for_setg.append(" \n")

        filtered_func = list(self.zc_filter.get_function_zero_crossings_raw_func())
        filtered_func = filtered_func[1:-1] # remove last and first elements which are "}" and "{"

        # sort by taking init function number read in *06inz.c
        index = 0
        ptrn_calc_var = re.compile(r'SHOULD NOT BE USED - CALCULATED VAR \/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
        calc_var_2_index = {}
        for var in self.reader.list_calculated_vars:
            calc_var_2_index[var.get_name()] = index
            index += 1

        for line in filtered_func :
            if "gout" not in line:
                if "tmp" in line:
                    line = line.replace("tmp", "tmp_zc")
                if THREAD_DATA_OMC_PARAM in line:
                    line=line.replace(THREAD_DATA_OMC_PARAM, "")
                elif "OMC_MINIMAL_RUNTIME" in line or "measure_time_flag" in line or "#endif" in line or "const int *equationIndexes" in line:
                    continue
                line = sub_division_sim(line)
                line = throw_stream_indexes(line)
                self.list_for_setg.append(line)

        if self.create_additional_relations():
            self.list_for_setg.extend(self.modes.get_body_for_evalg_tmps())

        # print all gout at the end of the function
        nb_zero_crossing = 0;
        for line in filtered_func:
            if "gout" in line:
                if "tmp" in line:
                    line = line.replace("tmp", "tmp_zc")
                line = line.replace("1 : -1;", "ROOT_UP : ROOT_DOWN;")
                match = ptrn_calc_var.findall(line)
                for name in match:
                    line = line.replace("SHOULD NOT BE USED - CALCULATED VAR /* " + name, \
                                            "evalCalculatedVarI(" + str(calc_var_2_index[name]) + ") /* " + name)
                self.list_for_setg.append(line)
                nb_zero_crossing +=1

        nb_root = nb_zero_crossing
        for r_obj in self.list_root_objects:
            if r_obj.get_num_dyn() == -1 or r_obj.get_duplicated_in_zero_crossing():
                continue
            test_param_address(r_obj.get_when_var_name())
            self.list_for_setg.append( line_ptrn % (nb_root, to_param_address(r_obj.get_when_var_name())) )
            nb_root += 1

        # additional root associated to created relations
        if self.create_additional_relations():
            self.list_for_setg.extend(self.modes.get_body_for_evalg_assignments(nb_root))

        # convert native boolean variables
        convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], self.list_for_setg)
        index = 0
        for line in self.list_for_setg:
            self.list_for_setg[index] = replace_relation_indexes(line, self.omc_relation_index_2_dynawo_relations_index)
            match = ptrn_calc_var.findall(self.list_for_setg[index])
            for name in match:
                 self.list_for_setg[index] = self.list_for_setg[index].replace("SHOULD NOT BE USED - CALCULATED VAR /* " + name, \
                                            "evalCalculatedVarI(" + str(calc_var_2_index[name]) + ") /* " + name)
            index+=1

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
        motif = self.assignment_format
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
        sorted_keys = sorted(keys)
        for key in sorted_keys:
            self.list_for_initrpar +=  "{\n"
            self.list_for_initrpar +=  dict_line_par_by_param[key]
            self.list_for_initrpar +=  "}\n"

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
        filtered_iter = filter( filter_setup_data, self.reader.setup_data_struc_raw_func.get_body() )
        filtered_iter_dae = filter( filter_dae_setup_data, self.reader.setup_dae_data_struc_raw_func.get_body() )
        filtered_func = list(filtered_iter)
        filtered_func += list(filtered_iter_dae)

        remove_const_alias_comment = " /* Remove const aliases */"
        # Change the number of zeroCrossings, real/discrete/bool vars
        for n, line in enumerate(filtered_func):
            if "data->modelData->nZeroCrossings" in line:
                line = line [ :line.find("=") ] + "= " + str(self.zc_filter.get_number_of_zero_crossings())+";\n"
                new_line = line [ :line.find(";") ] + " + " + str(self.nb_root_objects) + line[ line.find(";") : ]
                if self.create_additional_relations():
                    new_line = new_line [ :new_line.find(";") ] + " + " + str(self.nb_created_relations) + new_line[ new_line.find(";") : ]
                filtered_func[n] = new_line
            if "data->modelData->nVariablesReal" in line:
                line = line [ :line.find("=") ] + "= " + str(self.reader.nb_real_vars)+";\n"
                filtered_func[n] = line
            if "data->modelData->nDiscreteReal" in line:
                line = line [ :line.find("=") ] + "= " + str(self.reader.nb_discrete_vars)+";\n"
                filtered_func[n] = line
            if "data->modelData->nVariablesInteger" in line:
                line = line [ :line.find("=") ] + "= " + str(self.reader.nb_integer_vars)+";\n"
                filtered_func[n] = line
            if "data->modelData->nVariablesBoolean" in line:
                line = line [ :line.find("=") ] + "= " + str(self.reader.nb_bool_vars)+";\n"
                filtered_func[n] = line
            if "daeModeData->nResidualVars" in line:
                line = line [ :line.find("=") ] + "= " + str(len(self.reader.residual_vars_to_address_map))+";\n"
                filtered_func[n] = line
            if "daeModeData->nAuxiliaryVars" in line:
                line = line [ :line.find("=") ] + "= " + str(len(self.reader.auxiliary_var_to_keep) + len(self.reader.auxiliary_vars_counted_as_variables))+";\n"
                filtered_func[n] = line
            if "data->modelData->nAliasReal" in line:
                line = line [ :line.find(";") ] + " - " + str(len(list(filter(lambda x: (x.is_alias() and (is_real_const_var(x) or is_discrete_real_const_var(x))), self.list_all_vars)))) + remove_const_alias_comment + line[ line.find(";") : ]
                filtered_func[n] = line
            if "data->modelData->nAliasInteger" in line:
                line = line [ :line.find(";") ] + " - " + str(len(list(filter(lambda x: (x.is_alias() and is_integer_const_var(x)), self.list_vars_int)))) + remove_const_alias_comment + line[ line.find(";") : ]
                filtered_func[n] = line
            if "data->modelData->nAliasBoolean" in line:
                line = line [ :line.find(";") ] + " - " + str(len(list(filter(lambda x: (x.is_alias() and is_boolean_const_var(x)), self.list_vars_bool)))) + remove_const_alias_comment + line[ line.find(";") : ]
                filtered_func[n] = line
            if "daeModeData->" in line:
                line = line.replace("daeModeData", "data->simulationInfo->daeModeData")
                filtered_func[n] = line
            if "data->modelData->nRelations" in line:
                if self.create_additional_relations():
                    line = line [ :line.find(";") ] + " + " + str(self.nb_created_relations) + line[ line.find(";") : ]
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
        defines = self.reader.list_functions_define
        list_functions_body = []
        ptrn_modelica_integer_cast_adouble = re.compile(r'.*\(modelica_real\)[(]*\(modelica_integer\).*')

        ptrn_define = re.compile(r'[ ]*#define (?P<symbolic>.*)\(.*\)[ ]+(?P<method>.*)\(.*\)')
        ptrn_define_with_cast = re.compile(r'[ ]*#define (?P<symbolic>.*)\(.*\)[ ]+\(\*\(.*\*\)\((?P<method>.*)\(.*\)\)\)')
        define_methods = {}
        for define in defines:
            match = re.search(ptrn_define, define.replace("sizeof(",""))
            match_cast = re.search(ptrn_define_with_cast, define.replace("sizeof(",""))
            if match is not None and match_cast is None:
                define = define.replace(match.group("method"), "@@@@@METHOD@@@@")
                define = define.replace(match.group("symbolic"), "@@@@@SYMBOLIC@@@@")
                define_methods[match.group("symbolic")] = match.group("method")
                #corresponding_func = [func for func in self.reader.list_omc_functions if func.get_name() == match.group("method")]
                #if len(corresponding_func) == 1:
                #    functions_to_dump.append(corresponding_func[0])
        while len(functions_to_dump) > 0:
            func = functions_to_dump[0]
            functions_to_dump.remove(func)
            if not is_adept_func(func, self.list_adept_structs) or func.get_name() == "derDelayImpl": continue
            if func in functions_dumped: continue
            functions_dumped.append(func)
            func_body = []
            func_body.append("// " + func.get_name()+"\n")
            if func.get_return_type() == "modelica_real":
                func_header = "adept::adouble " + get_adept_function_name(func) + "("
                func_header_cpp = func_header
            elif func.get_return_type().startswith('modelica_'):
                func_header = func.get_return_type() + " " + get_adept_function_name(func) + "("
                func_header_cpp = func_header
            elif func.get_return_type()== "void":
                func_header = func.get_return_type() + " "  + get_adept_function_name(func) + "("
                func_header_cpp = func.get_return_type() + " "  + get_adept_function_name(func) + "("
            else:
                func_header = func.get_return_type() + ADEPT_SUFFIX + get_adept_function_name(func) + "("
                func_header_cpp = MODEL_NAME_NAMESPACE+func.get_return_type() + ADEPT_SUFFIX + get_adept_function_name(func) + "("
            for param in func.get_params():
                param_type = param.get_type()
                if param_type == "modelica_real":
                    param_type = ADEPT_DOUBLE
                elif param_type in self.list_adept_structs:
                    param_type += "_adept"
                last_char = ", "
                if param.get_index() == len(func.get_params()) - 1 :
                    last_char=") "
                func_header+=param_type + " " + param.get_name()+ last_char
                func_header_cpp+=param_type + " " + param.get_name()+ last_char
            func_body.append(func_header_cpp.replace(get_adept_function_name(func), MODEL_NAME_NAMESPACE +get_adept_function_name(func)))
            corrected_body = func.get_corrected_body()
            if len(corrected_body) > 0 and corrected_body[0] != '{\n':
                func_body.append(' {\n')
            func_header+= ";\n"
            if not ("ModelicaStandardTables_" in func_header and "getDerValue" in func_header):
                self.list_for_evalfadept_external_call_headers.append(func_header)
            for line in func.get_corrected_body():
                if "OMC_LABEL_UNUSED" in line: continue
                if "omc_assert" in line or "omc_terminate" in line: continue
                if ptrn_modelica_integer_cast_adouble.search(line) is not None:
                    line = line.replace("(modelica_integer)","")
                line = line.replace("modelica_real",ADEPT_DOUBLE).replace(THREAD_DATA_OMC_PARAM,"")
                for base_type in self.list_adept_structs:
                    line = line.replace(base_type + " ",base_type+ADEPT_SUFFIX)
                    line = line.replace(base_type + "* ",base_type+"_adept* ")
                    line = line.replace(base_type + "*)",base_type+"_adept*)")
                for func in list_omc_functions:
                    if func.get_name() + "(" in line or func.get_name() + " (" in line:
                        line = line.replace(func.get_name() + "(", get_adept_function_name(func) + "(")
                        line = line.replace(func.get_name() + " (", get_adept_function_name(func) + "(")
                        if func not in functions_dumped:
                            functions_to_dump.append(func)
                for symbolic_func in define_methods:
                    if symbolic_func + "(" in line or symbolic_func + " (" in line:
                        line = line.replace(symbolic_func + "(", symbolic_func + "_adept(")
                        line = line.replace(symbolic_func + " (", symbolic_func + "_adept(")
                        func = [f for f in list_omc_functions if define_methods[symbolic_func] in f.get_name()]
                        assert(len(func) <= 1)
                        if len(func) > 0 and func[0] not in functions_dumped:
                            functions_to_dump.append(func[0])
                func_body.append(line)
            func_body.append("\n\n")
            if not ("ModelicaStandardTables_" in func_header and "getDerValue" in func_header):
                list_functions_body.append(func_body)

        # Need to dump in reversed order to put the functions called by other functions in first
        for func_body in reversed(list_functions_body):
            self.list_for_evalfadept_external_call.extend(func_body)

    ##
    # replace function names and double variables by their adept equivalent when required
    # @param self : object pointer
    # @param line : line to analyze
    # are you ready??
    def replace_adept_functions_in_line(self, line):
        # Map of functions called in this line (function name -> RawOmcFunctions object)
        called_func = {}
        # result line
        line_tmp = line
        # regular expressions to find real and der variables in the parameters
        ptrn_vars = re.compile(r'data->localData\[[0-9]+\]->derivativesVars\[[0-9]+\][ ]*\/\*[ \w\$\.()\[\],]*\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]*\/\*[ \w\$\.()\[\],]*[ ]variable[ ]\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]*\/\*[ \w\$\.()\[\],]*[ ]*\*\/')
        ptrn_real_der_var = re.compile(r'data->localData\[[0-9]+\]->derivativesVars\[(?P<varId>[0-9]+)\][ ]*\/\*[ \w\$\.()\[\],]*\*\/')
        ptrn_real_var = re.compile(r'data->localData\[[0-9]+\]->realVars\[(?P<varId>[0-9]+)\][ ]*\/\*[ \w\$\.()\[\],]*\*\/')

        defines = self.reader.list_functions_define
        ptrn_define = re.compile(r'[ ]*#define (?P<symbolic>.*)\(.*\)[ ]+(?P<method>.*)\(.*\)')
        ptrn_define_with_cast = re.compile(r'[ ]*#define (?P<symbolic>.*)\(.*\)[ ]+\(\*\(.*\*\)\((?P<method>.*)\(.*\)\)\)')
        define_methods = {}
        for define in defines:
            match = re.search(ptrn_define, define.replace("sizeof(",""))
            match_cast = re.search(ptrn_define_with_cast, define.replace("sizeof(",""))
            if match is not None and match_cast is None:
                define = define.replace(match.group("method"), "@@@@@METHOD@@@@")
                define = define.replace(match.group("symbolic"), "@@@@@SYMBOLIC@@@@")
                corresponding_func = [func for func in self.reader.list_omc_functions if func.get_name() == match.group("method")]
                if len(corresponding_func) == 1:
                    symbolic = RawOmcFunctions()
                    symbolic.body = corresponding_func[0].body
                    symbolic.signature = corresponding_func[0].signature
                    symbolic.name = match.group("symbolic")
                    symbolic.return_type = corresponding_func[0].return_type
                    symbolic.params = corresponding_func[0].params
                    symbolic.corrected_body = corresponding_func[0].corrected_body
                    define_methods[match.group("symbolic")] = symbolic


        # step 1: collect all functions called in this line
        for func in self.reader.list_omc_functions:
            if (func.get_name() + "(" in line_tmp or func.get_name() + " (" in line_tmp):
                called_func[func.get_name()] = func
        for symbolic_func in define_methods:
            func = define_methods[symbolic_func]
            if (symbolic_func + "(" in line or symbolic_func + " (" in line):
                if not is_adept_func(func, self.list_adept_structs) : continue
                called_func[symbolic_func] = func

        # step 2: replace whatever needs to be replaced
        if len(called_func) > 0:
            # filter whatever is assigned in this line
            line_split_by_equal = line.split('=')
            if(len(line_split_by_equal) >= 2):
                call_line = line_split_by_equal[0] + " = "
                func_call_line = line_split_by_equal[1]
            else:
                call_line = ""
                func_call_line = line_split_by_equal[0]
            # Split this line at each function call ('(') and parameter (',')
            line_split_by_parenthesis = re.split('(\()', func_call_line)
            line_split_by_comma = []
            for l in line_split_by_parenthesis:
                line_split_by_comma.extend(l.split(','))
            line_split = []
            for l in line_split_by_comma:
                line_split.extend(re.split('(\))', l))
            line_split = [i for i in line_split if i and len(i.strip()) > 0]

            # stack (FILO) containing the function called sorted by call stack
            stack_func_called = []
            # same size as stack_func_called
            # each index contains the first id of line_split at which the first parameter of the corresponding function is found
            stack_param_idx_func_called = []
            idx = 0

            # True if the first function of the stack requires adept inputs, False otherwise
            main_func_is_adept = False

            while idx < len(line_split):
                l = line_split[idx]

                # handle (data->... /* .. */)
                if l =='(' and idx < len(line_split) - 1 and line_split[idx + 1].startswith("data"):
                    idx+=1
                    l+=line_split[idx].strip()
                    idx+=1
                    l+=line_split[idx].strip()

                #hack to handle the case data->localData[0]->derivativesVars[...] /* der(a) STATE_DER /
                if l.endswith("/* der("):
                    idx+=1
                    l+=line_split[idx]
                    idx+=1
                    l+=line_split[idx]
                #hack to handle cast

                if l.endswith("STATE("):
                    idx+=1
                    l+=line_split[idx]
                    idx+=1
                    l+=line_split[idx]
                    if l[-1].isdigit():
                        # case data->localData[0]->realVars[...] /* .. STATE(1,...) */
                        idx+=1
                        l+=", " +line_split[idx]
                    # final )
                    idx+=1
                    l+=line_split[idx]
                    if l[-1] == ')':
                        # final */
                        idx+=1
                        l+=line_split[idx]

                if l.endswith("modelica_integer") or l.endswith("modelica_real") or l.endswith("modelica_boolean"):
                    idx+=1
                    l+=line_split[idx]
                    call_line+= l
                    idx+=1
                    continue

                # handle &(output)
                if l.startswith("&"):
                    idx+=1
                    l+=line_split[idx].strip()
                    idx+=1
                    l+=line_split[idx].strip()
                    idx+=1
                    l+=line_split[idx].strip()

                #Filter empty indexes
                if len(l) == 0:
                    idx+=1
                    continue

                #Put back any opening parenthesis into the final line
                if l =='(':
                    call_line+= l
                    idx+=1
                    continue
                if l ==')':
                    call_line+= l
                    idx+=1
                    continue
                if l ==';':
                    call_line+= l
                    idx+=1
                    continue

                #Is there a function call in this index?
                function_found = None
                for func_name in called_func:
                    if func_name in l:
                        function_found = func_name
                        break

                if function_found is not None:
                    #First case: there is a function call here.
                    # Push it on the stack
                    stack_func_called.append(function_found)
                    stack_param_idx_func_called.append(0)
                    idx+=1
                    # Replace this function by its adept equivalent only if
                    # - this function has an adept equivalent
                    # - the main function has an adept equivalent if this function is called as a parameter
                    # if this is the first function is the stack, set the flag main_func_is_adept
                    if (len(stack_func_called) == 1 or main_func_is_adept) and is_adept_func(called_func[function_found], self.list_adept_structs):
                        if function_found != "derDelayImpl":
                            call_line += l.replace(function_found, get_adept_function_name(called_func[function_found]))
                        else:
                            call_line += l
                        if len(stack_func_called) == 1:
                            main_func_is_adept = True
                    else:
                        call_line += l
                    l = line_split[idx]
                    assert(l == '(')
                    call_line += l
                    idx+=1

                elif len(stack_func_called) == 0:
                    #Second case: no function being currently called, lets go to the next index
                    # e.g. a + f(...)
                    call_line+= l
                    if call_line[-1] == ';':
                        call_line += "\n"
                    idx+=1
                else :
                    #Third case: parameter of the latest function in the stack

                    # Get the name of the function currently called (latest index of the stack)
                    func = called_func[stack_func_called[len(stack_func_called) - 1]]
                    # Get the id of the param currently analyzed
                    curr_param_idx = stack_param_idx_func_called[len(stack_param_idx_func_called) - 1]

                    param = func.get_params()[curr_param_idx]
                    if len(stack_param_idx_func_called) > 0:
                        stack_param_idx_func_called[len(stack_param_idx_func_called) - 1]+=1

                    # if this function is either:
                    # - has no equivalent adept function
                    # - called as a parameter of a non adept function
                    # and this parameter is a real input, transform the input so that it calls the double value of the adept double
                    if (not is_adept_func(func, self.list_adept_structs) or not main_func_is_adept) \
                    and param.get_is_input() and param.get_type() == "modelica_real":
                        match_global = ptrn_vars.findall(l) # Is this a word that matches the regex?
                        for name in match_global:
                            match = ptrn_real_der_var.search(l)
                            if match is not None:
                                l = l.replace(name, "xd[" + match.group('varId')+"].value()")
                            match = ptrn_real_var.search(l)
                            if match is not None:
                                l = l.replace(name, "x[" + match.group('varId')+"].value()")
                    call_line += l
                    add_comma = True
                    if curr_param_idx == len(func.get_params()) - 1 \
                        or (curr_param_idx > 1 and func.get_name() == "array_alloc_scalar_real_array" \
                            and curr_param_idx == int(re.search(r'array_alloc_scalar_real_array\(&tmp[0-9]+, (?P<nbparams>[0-9]+)', call_line).group('nbparams')) + 1):
                        # This is the last parameter, we need to pop the function
                        stack_func_called.pop()
                        stack_param_idx_func_called.pop()
                        if len(stack_param_idx_func_called) > 0:
                            stack_param_idx_func_called[len(stack_param_idx_func_called) - 1]+=1
                            func = called_func[stack_func_called[len(stack_func_called) - 1]]
                            while len(stack_param_idx_func_called) > 0 and \
                              stack_param_idx_func_called[len(stack_param_idx_func_called) - 1] >= len(func.get_params()):
                                stack_func_called.pop()
                                stack_param_idx_func_called.pop()
                                if (len(stack_param_idx_func_called) > 0):
                                    func = called_func[stack_func_called[len(stack_func_called) - 1]]

                        if len(stack_param_idx_func_called) == 0:
                            # end of main function
                            main_func_is_adept = False
                        if len(stack_func_called) == 0:
                            add_comma = False
                        if len(stack_func_called) == 1 and \
                            stack_param_idx_func_called[len(stack_param_idx_func_called) - 1] > len(called_func[stack_func_called[len(stack_func_called) - 1]].get_params()) - 1:
                            add_comma = False
                    if add_comma:
                        while idx + 1 < len(line_split) and line_split[idx + 1] == ')':
                            call_line+= ')'
                            idx+=1
                        call_line += ','
                    idx+=1
            line_tmp = call_line + "\n"
        return line_tmp

    ##
    # prepare the lines that constitues the body of evalFAdept
    # @param self : object pointer
    # @return
    def prepare_for_evalfadept(self):
        # In comment, we give the correspondence name var -> expression in vectors x, xd or rpar
        list_omc_functions = self.reader.list_omc_functions
        defines = self.reader.list_functions_define
        ptrn_define = re.compile(r'[ ]*#define (?P<symbolic>.*)\(.*\)[ ]+(?P<method>.*)\(.*\)')
        ptrn_define_with_cast = re.compile(r'[ ]*#define (?P<symbolic>.*)\(.*\)[ ]+\(\*\(.*\*\)\((?P<method>.*)\(.*\)\)\)')
        define_methods = {}
        for define in defines:
            match = re.search(ptrn_define, define.replace("sizeof(",""))
            match_cast = re.search(ptrn_define_with_cast, define.replace("sizeof(",""))
            if match is not None and match_cast is None:
                define = define.replace(match.group("method"), "@@@@@METHOD@@@@")
                define = define.replace(match.group("symbolic"), "@@@@@SYMBOLIC@@@@")
                corresponding_func = [func for func in list_omc_functions if func.get_name() == match.group("method")]
                if len(corresponding_func) == 1:
                    define_methods[match.group("symbolic")] = corresponding_func[0]
        self.list_for_evalfadept.append("  /*\n")
        for v in self.list_vars_syst + self.list_vars_der:
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            self.list_for_evalfadept.append( "    %s : %s\n" % (to_compile_name(v.get_name()), v.get_dynawo_name()) )
        self.list_for_evalfadept.append("\n")

        self.list_for_evalfadept.append("  */\n")

        auxiliary_var_to_keep_sorted = sorted(self.reader.auxiliary_var_to_keep)
        for name in auxiliary_var_to_keep_sorted:
            self.list_for_evalfadept.append("  adept::adouble " + name +";\n")
        list_residual_vars_for_sys_build = sorted(self.reader.residual_vars_to_address_map.keys())
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
        #     vars [ var or der(var) ] --> [ x[i]  xd[i] or rpar[i] ]
        trans = Transpose(self.reader.auxiliary_vars_to_address_map, self.reader.residual_vars_to_address_map)

        map_eq_reinit_continuous = self.get_map_eq_reinit_continuous()

        num_ternary = 0
        used_functions = []
        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            var_name_without_der = var_name [4 : -1] if 'der(' == var_name [ : 4] else var_name
            if var_name not in self.reader.fictive_continuous_vars_der:
                line = self.ptrn_f_name % eq.get_src_fct_name()
                self.list_for_evalfadept.append(line)

                # We recover the text of the equations
                standard_body_with_standard_external_call = eq.get_body_for_evalf_adept()
                standard_body = []
                index_relation = 0

                no_event_nodes = []
                if var_name in self.reader.var_name_to_mixed_residual_vars_types:
                    no_event_nodes = self.reader.var_name_to_mixed_residual_vars_types[var_name].get_no_event()
                index_if = 0
                for line in standard_body_with_standard_external_call:
                    for func in list_omc_functions:
                        if (func.get_name() + "(" in line or func.get_name() + " (" in line):
                            if not is_adept_func(func, self.list_adept_structs) : continue
                            used_functions.append(func)
                    for symbolic_func in define_methods:
                        func = define_methods[symbolic_func]
                        if (func.get_name() + "(" in line or func.get_name() + " (" in line):
                            if not is_adept_func(func, self.list_adept_structs) : continue
                            used_functions.append(func)
                    line = self.replace_adept_functions_in_line(line)

                    if eq.complex_eq:
                        ptrn_complex_tmp = re.compile(r'\s*(?P<type>.*)\s* tmp[0-9]+;')
                        match = ptrn_complex_tmp.search(line)
                        if match is not None:
                            if match.group('type') in self.list_adept_structs:
                                line = line.replace(match.group('type'), match.group('type')+"_adept")

                    if self.create_additional_relations() and (("Greater" in line or "Less" in line) and "relationhysteresis" not in line and not no_event_nodes[index_if]):
                        index_relations = self.modes.find_index_relation(eq.get_src_fct_name())
                        assert(len(index_relations) > 0 and index_relation < len(index_relations))
                        line = self.transform_in_relation(line, index_relations[index_relation])
                        index_relation+=1
                    if "else" in line:
                        index_if +=1
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

                # Transformed equation is incorporated in the function to be printed
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
                        if not is_adept_func(func, self.list_adept_structs) : continue
                        used_functions.append(func)
                for symbolic_func in define_methods:
                    func = define_methods[symbolic_func]
                    if (symbolic_func + "(" in line or symbolic_func + " (" in line):
                        if not is_adept_func(func, self.list_adept_structs) : continue
                        used_functions.append(func)
                line = self.replace_adept_functions_in_line(line)
                if "double external_call_" in line:
                    line = line.replace("double external_call_","adept::adouble external_call_")
                for type in self.list_adept_structs:
                    line = line.replace(type + " ",type+ADEPT_SUFFIX)
                line = line.replace("f[","res[")
                line = transform_line_adept(line)
                transposed_function_call_body.append(line)

            self.list_for_evalfadept.extend(transposed_function_call_body)

            for eq in self.list_additional_equations_from_call_for_setf:
                line = self.ptrn_f_name % eq.get_src_fct_name()
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

        for index, line in enumerate(self.list_for_evalfadept):
            self.list_for_evalfadept[index] = replace_relation_indexes(line, self.omc_relation_index_2_dynawo_relations_index)


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
            if name[0:4] != 'omc_' and not name.startswith("Complex_")and not name.startswith("Dynawo_Types_"):
                self.erase_func.append(name)
                continue

            self.list_for_externalcalls.append("\n")
            signature = func.get_signature()
            name_to_fill = MODEL_NAME_NAMESPACE+name
            signature = signature.replace(name, name_to_fill)

            return_type = func.get_return_type()
            # type is not a predefined type
            if (return_type !="void" and return_type[0:9] != 'modelica_' and return_type[0:10] != 'real_array'):
                new_return_type =MODEL_NAME_NAMESPACE+return_type
                signature = signature.replace(return_type, new_return_type, 1)

            signature = signature.replace('threadData_t *threadData,','').replace('threadData_t *threadData ,','')
            if "combiTable1Ds1" in signature:
                signature = signature.replace('modelica_real _tableAvailable','modelica_real /*_tableAvailable*/')

            self.list_for_externalcalls.append(signature)
            new_body = []
            for line in func.get_body():
                if OMC_METATYPE_TMPMETA in line:
                    new_body.append(replace_modelica_strings(line))
                elif "FILE_INFO info" not in line:
                    line = line.replace(THREAD_DATA_OMC_PARAM ,"")
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
        ptrn_define = re.compile(r'[ ]*#define (?P<symbolic>.*)\(.*\)[ ]+(?P<method>.*)\(.*\)')
        ptrn_define_with_cast = re.compile(r'[ ]*#define (?P<symbolic>.*)\(.*\)[ ]+\(\*\(.*\*\)\((?P<method>.*)\(.*\)\)\)')
        for define in self.reader.list_functions_define:
            self.list_for_externalcalls_header.append(define.replace("td,",""))
            match = re.search(ptrn_define, define.replace("sizeof(",""))
            match_cast = re.search(ptrn_define_with_cast, define.replace("sizeof(",""))
            if match is not None and match_cast is None:
                define = define.replace(match.group("method"), "@@@@@METHOD@@@@")
                define = define.replace(match.group("symbolic"), "@@@@@SYMBOLIC@@@@")
                self.list_for_evalfadept_external_call_headers.append(define.replace("@@@@@METHOD@@@@", match.group("method")+"_adept").replace("@@@@@SYMBOLIC@@@@", match.group("symbolic")+"_adept").replace("td,",""))

        ptrn_struct = re.compile(r'.*typedef struct .*{.*')
        ptrn_struct_end = re.compile(r'\s*}\s*(?P<name>.*)\s*;')
        ptrn_typedef = re.compile(r'\s*typedef (?P<name1>.*) (?P<name2>.*);')
        adept_reading_struct = False
        for line in tmp_list:
            if 'threadData_t *threadData,' in line:
                line = line.replace("threadData_t *threadData,","")
            if 'threadData_t *threadData ,' in line:
                line = line.replace("threadData_t *threadData ,","")
            self.list_for_externalcalls_header.append(line)
            match = ptrn_struct.search(line)
            if match is not None:
                self.list_for_evalfadept_external_call_headers.append(line)
                adept_reading_struct = True
            elif adept_reading_struct:
                match_end = ptrn_struct_end.search(line)
                if match_end is not None:
                    adept_reading_struct = False
                    self.list_adept_structs.append(match_end.group('name'))
                    self.list_for_evalfadept_external_call_headers.append(line.replace(match_end.group('name'), match_end.group('name')+"_adept"))
                elif "modelica_real" in line:
                    self.list_for_evalfadept_external_call_headers.append(line.replace("modelica_real", ADEPT_DOUBLE))
                else:
                    line_tmp = line
                    for struct in self.list_adept_structs:
                        if struct in line_tmp:
                            line_tmp = line_tmp.replace(struct, struct+"_adept")
                    self.list_for_evalfadept_external_call_headers.append(line_tmp)
            elif "typedef" in line:
                match_typedef = ptrn_typedef.search(line)
                if match_typedef is not None:
                    base_name =  match_typedef.group('name1')
                    new_name = match_typedef.group('name2')
                    if base_name in self.list_adept_structs:
                        self.list_for_evalfadept_external_call_headers.append("typedef " + base_name +ADEPT_SUFFIX + new_name + ADEPT_SUFFIX +";\n")
                        self.list_adept_structs.append(new_name)




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
        self.list_for_setsharedparamsdefault.append('  std::shared_ptr<parameters::ParametersSet> ' + parameters_set_name + ' = parameters::ParametersSetFactory::newParametersSet("SharedModelicaParameters");\n')

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
                line_modelica_params = create_parameter_pattern % (to_compile_name(self.replace_table_name(par.get_name())), local_par_name)
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

            line = motif % ( to_compile_name(par.get_name())+"_", to_compile_name(self.replace_table_name(par.get_name())) )
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
        return list(filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_real))

    ##
    # returns the lines that declares non-internal boolean parameters
    # @param self : object pointer
    # @return list of lines
    def get_list_params_bool_not_internal_for_h(self):
        return list(filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_bool))

    ##
    # returns the lines that declares non-internal string parameters
    # @param self : object pointer
    # @return list of lines
    def get_list_params_string_not_internal_for_h(self):
        return list(filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_string))

    ##
    # returns the lines that declares non-internal integer parameters
    # @param self : object pointer
    # @return list of lines
    def get_list_params_integer_not_internal_for_h(self):
        return list(filter(lambda x: (param_scope(x) !=  INTERNAL_PARAMETER), self.list_params_integer))

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
        auxiliary_var_to_keep_sorted = sorted(self.reader.auxiliary_var_to_keep)
        for dae_var in auxiliary_var_to_keep_sorted:
            variable_definitions.append("#define $P"+ dae_var + " data->simulationInfo->daeModeData->auxiliaryVars["+str(index_residual_var)+"]\n")
            index_residual_var +=1

        lines_to_write = variable_definitions

        self.list_for_definition_header.extend (lines_to_write)



    ##
    # prepare the lines that constitues the body of evalStaticYType_omc
    # @param self : object pointer
    # @return
    def prepare_for_evalstaticytype(self):
        ind = 0
        mixed_var = []
        external_diff_var = []
        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            if var_name in self.reader.var_name_to_differential_dependency_variables:
                diff_vars = self.reader.var_name_to_differential_dependency_variables[var_name]
                for tables in diff_vars:
                    for diff_var in tables:
                        if diff_var not in mixed_var:
                            if self.reader.var_name_to_eq_type[var_name] == MIXED:
                                mixed_var.append(diff_var)
                            elif diff_var in self.reader.fictive_continuous_vars or diff_var in self.reader.fictive_optional_continuous_vars:
                                external_diff_var.append(diff_var)
        for v in self.list_vars_syst:
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            if v in self.reader.list_calculated_vars : continue
            if v.get_name() not in mixed_var:
                spin = "DIFFERENTIAL"
                var_ext = ""
                if is_alg_var(v) :
                    spin = "ALGEBRAIC"
                if v.get_name() in self.reader.dummy_der_variables:
                    spin = "DIFFERENTIAL"
                if v.get_name() in self.reader.fictive_continuous_vars and v.get_name() not in external_diff_var:
                  spin = "EXTERNAL"
                  var_ext = "- external variables"
                elif v.get_name() in self.reader.fictive_optional_continuous_vars and v.get_name() not in external_diff_var:
                  spin = "OPTIONAL_EXTERNAL"
                  var_ext = "- optional external variables"
                line = "   yType[ %s ] = %s;   /* %s (%s) %s */\n" % (str(ind), spin, to_compile_name(v.get_name()), v.get_type(), var_ext)
                self.list_for_evalstaticytype.append(line)
            ind += 1

    ##
    # prepare the lines that constitues the body of evalDynamicYType_omc
    # @param self : object pointer
    # @return
    def prepare_for_evaldynamictype(self):
        ind = 0
        diff_var_to_eq = {}
        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            if self.reader.var_name_to_eq_type[var_name] == MIXED and var_name in self.reader.var_name_to_differential_dependency_variables:
                diff_vars = self.reader.var_name_to_differential_dependency_variables[var_name]
                for tables in diff_vars:
                    for diff_var in tables:
                        if diff_var not in diff_var_to_eq:
                            diff_var_to_eq[diff_var] = []
                        if eq not in  diff_var_to_eq[diff_var]:
                            diff_var_to_eq[diff_var].append(eq)

        if len(diff_var_to_eq) == 0: return

        alg_vars = []
        for v in self.list_vars_syst:
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            if v in self.reader.list_calculated_vars : continue
            if v.get_name() in diff_var_to_eq:
                print_info("Variable " + v.get_name() + " has a dynamic type.")
                self.list_for_evaldynamicytype.append("  yType[ %s ] = ALGEBRAIC /* %s */; \n" % (str(ind), v.get_name()))
            alg_vars.append(v)
            ind += 1

        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            if (self.reader.var_name_to_eq_type[var_name] == MIXED or self.reader.var_name_to_eq_type[var_name] == DIFFERENTIAL) \
                and var_name in self.reader.var_name_to_differential_dependency_variables:
                if eq.get_evaluated_var() in self.reader.var_name_to_mixed_residual_vars_types:
                    body = replace_equations_in_a_if_statement_y(eq.get_body_for_setf(), \
                                                                self.reader.var_name_to_mixed_residual_vars_types[eq.get_evaluated_var()], \
                                                                alg_vars, diff_var_to_eq, 4)
                    convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], body)
                    if len(body) > 0:
                        self.list_for_evaldynamicytype.append("  {\n")
                        self.list_for_evaldynamicytype.extend(body)
                        self.list_for_evaldynamicytype.append("  }\n")


    ##
    # returns the lines that constitues the body of evalStaticYType_omc
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalstaticytype(self):
        return self.list_for_evalstaticytype

    ##
    # returns the lines that constitues the body of evalDynamicYType_omc
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evaldynamicytype(self):
        return self.list_for_evaldynamicytype

    ##
    # prepare the lines that constitues the body of evalDynamicFType
    # @param self : object pointer
    # @return
    def prepare_for_evaldynamicftype(self):
        ind = 0
        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            if var_name not in self.reader.fictive_continuous_vars_der and not self.reader.is_auxiliary_vars(var_name):
                if eq.get_type() == MIXED:
                    self.list_for_evaldynamicftype.append("  {\n")
                    self.list_for_evaldynamicftype.append("    propertyF_t type = ALGEBRAIC_EQ;\n")
                    body = replace_equations_in_a_if_statement(eq.get_body_for_setf(), self.reader.var_name_to_mixed_residual_vars_types[var_name], \
                                                               "type = ALGEBRAIC_EQ;\n", "type = DIFFERENTIAL_EQ;\n", 4)
                    convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], body)
                    self.list_for_evaldynamicftype.extend(body)
                    line = "     fType[ %s ] = type;\n" % (str(ind))
                    self.list_for_evaldynamicftype.append(line)
                    self.list_for_evaldynamicftype.append("  }\n")
                ind += 1

        for eq in self.list_additional_equations_from_call_for_setf:
            var_name = eq.get_evaluated_var()
            if var_name not in self.reader.fictive_continuous_vars_der and not self.reader.is_auxiliary_vars(var_name):
                if eq.get_type() == MIXED:
                    self.list_for_evaldynamicftype.append("  {\n")
                    self.list_for_evaldynamicftype.append("    propertyF_t type = ALGEBRAIC_EQ;\n")
                    body = replace_equations_in_a_if_statement(eq.get_body_for_setf(), self.reader.var_name_to_mixed_residual_vars_types[var_name], \
                                                               "type = ALGEBRAIC_EQ;\n", "type = DIFFERENTIAL_EQ;\n", 4)
                    convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], body)
                    self.list_for_evaldynamicftype.extend(body)
                    line = "     fType[ %s ] = type;\n" % (str(ind))
                    self.list_for_evaldynamicftype.append(line)
                    self.list_for_evaldynamicftype.append("  }\n")
                ind += 1
    ##
    # prepare the lines that constitues the body of evalStaticFType
    # @param self : object pointer
    # @return
    def prepare_for_evalstaticftype(self):
        ind = 0
        assign_ftype_line = "   fType[ %s ] = %s;\n"
        for eq in self.get_list_eq_syst():
            var_name = eq.get_evaluated_var()
            if var_name not in self.reader.fictive_continuous_vars_der and not self.reader.is_auxiliary_vars(var_name):
                if eq.get_type() == DIFFERENTIAL:
                    spin = "DIFFERENTIAL_EQ"
                    line = assign_ftype_line % (str(ind), spin)
                    self.list_for_evalstaticftype.append(line)
                elif eq.get_type() == ALGEBRAIC:
                    spin = "ALGEBRAIC_EQ" # no derivatives in the equation
                    line = assign_ftype_line % (str(ind), spin)
                    self.list_for_evalstaticftype.append(line)
                ind += 1

        for eq in self.list_additional_equations_from_call_for_setf:
            var_name = eq.get_evaluated_var()
            if var_name not in self.reader.fictive_continuous_vars_der and not self.reader.is_auxiliary_vars(var_name):
                if eq.get_type() == DIFFERENTIAL:
                    spin = "DIFFERENTIAL_EQ"
                    line = assign_ftype_line % (str(ind), spin)
                    self.list_for_evalstaticftype.append(line)
                elif eq.get_type() == ALGEBRAIC:
                    spin = "ALGEBRAIC_EQ" # no derivatives in the equation
                    line = assign_ftype_line % (str(ind), spin)
                    self.list_for_evalstaticftype.append(line)
                ind += 1
    ##
    # returns the lines that constitues the body of evalStaticFType
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalstaticftype(self):
        return self.list_for_evalstaticftype
    ##
    # returns the lines that constitues the body of evalDynamicFType
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evaldynamicftype(self):
        return self.list_for_evaldynamicftype


    ##
    # decrease by 1 the index in a variable belonging to a Modelica table so that indexes are between 0->SIZE-1 (C++ style)
    # @param match : current match
    def replace_table_index(self, match):
        return "["+str(int(match.group('varIndex')) - 1)+"]"

    ##
    # Test if the variable is from a table indexed from 1->N. If it is the case, decrease by 1 the indexes to match c++ style
    # @param match : current match
    def replace_table_name(self, var_name):
        ptrn_table = re.compile(r'\[(?P<varIndex>[0-9]+)\]')
        first_table_index = re.sub(ptrn_table,"[0]" , var_name)
        if to_param_address(first_table_index) is None:
            return re.sub(ptrn_table, self.replace_table_index, var_name)
        return var_name
    ##
    # prepare the lines that constitues the body of setVariables
    # @param self : object pointer
    # @return
    def prepare_for_setvariables(self):
        line_ptrn_native_state = '  variables.push_back (VariableNativeFactory::createState ("%s", %s, %s));\n'
        line_ptrn_native_calculated = '  variables.push_back (VariableNativeFactory::createCalculated ("%s", %s, %s));\n'
        line_ptrn_alias =  '  variables.push_back (VariableAliasFactory::create ("%s", "%s", %s, %s));\n'

        # System vars
        for v in self.list_all_vars:
            if v.get_name() in self.reader.auxiliary_vars_counted_as_variables : continue
            if v in self.reader.list_calculated_vars: continue # will be done in a second time to make sure we first declare the const variables and then the others
            if is_when_var(v): continue
            name = to_compile_name(self.replace_table_name(v.get_name()))

            negated = "true" if v.get_alias_negated() else "false"
            line = ""
            if is_real_const_var(v):
                line = line_ptrn_native_calculated % ( name, v.get_dyn_type(), "false") # never negated as the value given in Y0 is already the good one
            elif v.is_alias() and not is_const_var(v):
                alias_name = to_compile_name(self.replace_table_name(v.get_alias_name()))
                line = line_ptrn_alias % ( name, alias_name, v.get_dyn_type(), negated)
            elif is_const_var(v):
                line = line_ptrn_native_state % ( name, v.get_dyn_type(), "false")
            else:
                line = line_ptrn_native_state % ( name, v.get_dyn_type(), negated)
            self.list_for_setvariables.append(line)
        for v in self.reader.list_calculated_vars:
            name = to_compile_name(self.replace_table_name(v.get_name()))
            line = line_ptrn_native_calculated % ( name, v.get_dyn_type(), "false")
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

        all_parameters = self.list_params_real + self.list_params_bool + self.list_params_integer + self.list_params_string

        push_back_threshold = 8
        if len(all_parameters) >= push_back_threshold:
            self.list_for_defineparameters.append("  using ParameterModelerTuple = std::tuple<std::string, DYN::typeVarC_t, DYN::parameterScope_t>;\n")
            self.list_for_defineparameters.append("  std::array<ParameterModelerTuple, " + str(len(all_parameters)) + "> parameterModelerArray = {\n")
            line_ptrn = "    std::make_tuple(\"%s\", %s, %s),\n"
        else:
            line_ptrn = "  parameters.push_back(ParameterModeler(\"%s\", %s, %s));\n"

        # Les parametres
        for par in all_parameters:
            par_type = param_scope_str (param_scope (par))
            name = to_compile_name(self.replace_table_name(par.get_name()))
            value_type = par.get_value_type_c().upper()
            line = line_ptrn %( name, "VAR_TYPE_"+value_type, par_type)
            self.list_for_defineparameters.append(line)

        if len(all_parameters) >= push_back_threshold:
            self.list_for_defineparameters.append("  };\n")

            self.list_for_defineparameters.append("  for (size_t parameterModelerIndex = 0; parameterModelerIndex < parameterModelerArray.size(); ++parameterModelerIndex)\n")
            self.list_for_defineparameters.append("  {\n")
            self.list_for_defineparameters.append("    parameters.push_back(ParameterModeler(std::get<0>(parameterModelerArray[parameterModelerIndex]), std::get<1>(parameterModelerArray[parameterModelerIndex]), std::get<2>(parameterModelerArray[parameterModelerIndex])));\n")
            self.list_for_defineparameters.append("  }\n")

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

        push_back_threshold = 8
        if len(self.list_elements) >= push_back_threshold:
            self.list_for_defelem.append("  using ElementTuple = std::tuple<std::string, std::string, DYN::Element::typeElement>;\n")
            self.list_for_defelem.append("  std::array<ElementTuple, " + str(len(self.list_elements)) + "> elementArray1 = {\n")
            motif1 = "    std::make_tuple(\"%s\", \"%s\", Element::%s),\n"
        else:
            motif1 = "  elements.push_back(Element(\"%s\",\"%s\",Element::%s));\n"

        # # First part of defineElements (...)
        for elt in self.list_elements :
            elt_name = self.replace_table_name(elt.get_element_name())
            elt_short_name = self.replace_table_name(elt.get_element_short_name())
            line =""
            if not elt.is_structure() :
                line = motif1 % ( to_compile_name(elt_short_name), to_compile_name(elt_name), "TERMINAL" )
            else :
                line = motif1 % ( to_compile_name(elt_short_name), to_compile_name(elt_name), "STRUCTURE" )
            self.list_for_defelem.append(line)

        if len(self.list_elements) >= push_back_threshold:
            self.list_for_defelem.append("  };\n")

            self.list_for_defelem.append("  for (size_t elementsIndex1 = 0; elementsIndex1 < elementArray1.size(); ++elementsIndex1)\n")
            self.list_for_defelem.append("  {\n")
            self.list_for_defelem.append("    elements.push_back(Element(std::get<0>(elementArray1[elementsIndex1]), std::get<1>(elementArray1[elementsIndex1]), std::get<2>(elementArray1[elementsIndex1])));\n")
            self.list_for_defelem.append("  }\n")

        self.list_for_defelem.append("\n") # Empty line

        # Second part of defineElements (...)
        for elt in self.list_elements :
            elt.print_link(self.list_for_defelem)

        self.list_for_defelem.append("\n") # Empty line

        if len(self.list_elements) >= push_back_threshold:
            self.list_for_defelem.append("  std::array<std::pair<std::string, int>, " + str(len(self.list_elements)) + "> mapElementArray = {\n")
            motif2 = "    std::make_pair(\"%s\", %s),\n"
        else:
            motif2 = "  mapElement[\"%s\"] = %d;\n"

        # Third part of defineElements (...)
        for elt in self.list_elements :
            elt_name = self.replace_table_name(elt.get_element_name())
            elt_index = elt.get_element_num()
            # The structure itself
            line = motif2 % (to_compile_name(elt_name), elt_index)
            self.list_for_defelem.append(line)

        if len(self.list_elements) >= push_back_threshold:
            self.list_for_defelem.append("  };\n")

            self.list_for_defelem.append("  for (size_t mapElementIndex = 0; mapElementIndex < mapElementArray.size(); ++mapElementIndex)\n")
            self.list_for_defelem.append("  {\n")
            self.list_for_defelem.append("    mapElement[mapElementArray[mapElementIndex].first] = mapElementArray[mapElementIndex].second;\n")
            self.list_for_defelem.append("  }\n")


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
            name = None
            if len(words) > 1:
                name = words[1]
            if '#define' in var and "_data" in var and "modelica_real" not in var:
                name = name.replace("_data","")
                # deletion of the define
                var = var.replace("#define", "const std::string")
                var = var.replace("_data", "")
                # add the = between name and variable
                var = var.replace(name, str(name) + " = ")
                var = var.replace("\n", " ")
                define = str(var) + ";\n"
                self.list_for_literalconstants.append(define)

            elif 'static const modelica_integer' in var:
                #var = var.replace("_data", "")
                var = var.replace ("static const", "const")

                self.list_for_literalconstants.append(var)

            elif 'static _index_t' in var and 'dims' in var:
                self.list_for_literalconstants.append(var)

            elif 'static _index_t' in var and 'dims' in var:
                self.list_for_literalconstants.append(var)

            elif 'static base_array_t const' in var:
                var = var.replace ("static ", "")
                self.list_for_literalconstants.append(var)

            elif 'static integer_array' in var:
                var = var.replace ("static ", "")
                self.list_for_literalconstants.append(var)

            elif 'static real_array' in var:
                var = var.replace ("static ", "")
                self.list_for_literalconstants.append(var)

    ##
    # prepare the lines that constitues the body for evalCalculatedVars
    # @param self : object pointer
    # @return
    def prepare_for_evalcalculatedvars(self):
        closing_bracket = "] /* "
        index = 0
        ptrn_calc_var = re.compile(r'SHOULD NOT BE USED - CALCULATED VAR \/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
        calc_var_2_index = {}
        for var in self.reader.list_calculated_vars:
            calc_var_2_index[var.get_name()] = index
            index += 1
        for var in self.reader.list_calculated_vars:
            expr = self.reader.dic_calculated_vars_values[var.get_name()]
            if type(expr)==list:
                body = []
                for line in expr:
                    if "throwStreamPrint" in line:
                        with_throw = True
                        break
                for line in expr:
                    if "omc_assert_warning" in line and with_throw:
                        continue
                    if "infoStreamPrintWithEquationIndexes" in line:
                        continue
                    if "return " in line:
                        line = line.replace("return ",  "calculatedVars[" + str(calc_var_2_index[var.get_name()])+closing_bracket + var.get_name() + "*/ = ")
                    line_tmp = transform_line(line)
                    line_tmp = throw_stream_indexes(line)
                    match = ptrn_calc_var.findall(line_tmp)
                    for name in match:
                        line_tmp = line_tmp.replace("SHOULD NOT BE USED - CALCULATED VAR /* " + name, \
                                                    "evalCalculatedVarI(" + str(calc_var_2_index[name]) + ") /* " + name)
                    body.append(line_tmp)
                convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], body)
                self.list_for_evalcalculatedvars.extend(body)
            else:
                self.list_for_evalcalculatedvars.append("  calculatedVars[" + str(calc_var_2_index[var.get_name()])+closing_bracket + var.get_name() + "*/ = " + expr+";\n")


    ##
    # return the list of lines that constitues the body of evalCalculatedVars
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalcalculatedvars(self):
        return self.list_for_evalcalculatedvars

    ##
    # prepare the lines that constitues the body for evalCalculatedVars
    # @param self : object pointer
    # @return
    def prepare_for_evalcalculatedvari(self):
        for var in self.reader.list_calculated_vars:
            var_name = var.get_name()
            expr = self.reader.dic_calculated_vars_values[var_name]
            index = self.dic_calc_var_index[var_name]
            self.list_for_evalcalculatedvari.append("  if (iCalculatedVar == " + str(index)+")  /* "+ var_name + " */\n")
            if type(expr)==list:
                body_translated = []
                for line in self.reader.dic_calculated_vars_values[var_name]:
                    if "throwStreamPrint" in line:
                        with_throw = True
                        break
                for line in self.reader.dic_calculated_vars_values[var_name]:
                    if "omc_assert_warning" in line and with_throw:
                        continue
                    if "infoStreamPrintWithEquationIndexes" in line:
                        continue
                    line_tmp = throw_stream_indexes(line)
                    line_tmp = transform_line(line_tmp)
                    if var_name in self.dic_calc_var_recursive_deps:
                        for name in self.dic_calc_var_recursive_deps[var_name]:
                            line_tmp = line_tmp.replace("SHOULD NOT BE USED - CALCULATED VAR /* " + name, \
                                                        "evalCalculatedVarI(" + str(self.dic_calc_var_index[name]) + ") /* " + name)
                    body_translated.append(line_tmp)
                # convert native boolean variables
                convert_booleans_body ([item.get_name() for item in self.list_all_bool_items], body_translated)
                self.list_for_evalcalculatedvari.extend(body_translated)
            else:
                self.list_for_evalcalculatedvari.append("    return "+ expr+";\n")
        self.list_for_evalcalculatedvari.append("  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);\n")


    ##
    # return the list of lines that constitues the body of evalCalculatedVars
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalcalculatedvari(self):
        return self.list_for_evalcalculatedvari

    def compute_recursive_calc_vars_num_deps(self):
        recursive_calc_vars_num_deps = {}
        map_dep = self.reader.get_map_dep_vars_for_func()
        for var in self.reader.list_calculated_vars:
            if var in self.reader.list_complex_calculated_vars:
                var_name = var.get_name()
                list_depend = map_dep[var_name]
                list_of_indexes = []
                for dependency in list_depend:
                    for syst_var in self.list_vars_syst:
                        if syst_var.get_dynawo_name() is None or  syst_var.get_dynawo_name() == "": continue
                        if syst_var.get_name() == dependency:
                            dependency_index = int(syst_var.get_dynawo_name().replace("]","").replace("x[",""))
                            if dependency_index not in list_of_indexes:
                                list_of_indexes.append(dependency_index)
                recursive_calc_vars_num_deps[var_name] = len(list_of_indexes)
        return recursive_calc_vars_num_deps

    ##
    # prepare the lines that constitues the body for evalCalculatedVarIAdept
    # @param self : object pointer
    # @return
    def prepare_for_evalcalculatedvariadept(self):
        trans = Transpose(self.reader.auxiliary_vars_to_address_map, self.reader.residual_vars_to_address_map)
        ptrn_vars = re.compile(r'x\[(?P<varId>[0-9]+)\]')

        num_ternary = 0
        index = 0
        recursive_calc_vars_num_deps = self.compute_recursive_calc_vars_num_deps()
        for var in self.reader.list_calculated_vars:
            body = []
            if var in self.reader.list_complex_calculated_vars:
                for line in self.reader.dic_calculated_vars_values[var.get_name()]:
                    if "throwStreamPrint" in line:
                        with_throw = True
                        break
                for line in self.reader.dic_calculated_vars_values[var.get_name()]:
                    if "omc_assert_warning" in line and with_throw:
                        continue
                    if "infoStreamPrintWithEquationIndexes" in line:
                        continue
                    line = throw_stream_indexes(line)
                    body.append(transform_line_adept(line))
            else:
                body.append("     return " + self.reader.dic_calculated_vars_values[var.get_name()]+";")
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
            calc_var_to_offset = {}
            if var.get_name() in self.dic_calc_var_recursive_deps:
                offset = 0
                prev_name = var.get_name()
                for name in self.dic_calc_var_recursive_deps[var.get_name()]:
                    if prev_name in recursive_calc_vars_num_deps:
                        offset += recursive_calc_vars_num_deps[prev_name]
                    calc_var_to_offset[name] = offset
                    prev_name = name
            body = []
            sorted_indexes = []
            for line in body_translated:
                match_global = ptrn_vars.findall(line)
                for val in match_global:
                    if int(val) not in sorted_indexes:
                        sorted_indexes.append(int(val))
                assert("xd[" not in line)
            sorted_indexes.sort()
            for line in body_translated:
                index_var = 0
                for val in sorted_indexes:
                    line = line.replace("x["+str(val)+"]", "x[indexOffset +" +str(index_var)+"]")
                    index_var += 1
                if var.get_name() in self.dic_calc_var_recursive_deps:
                    for name in self.dic_calc_var_recursive_deps[var.get_name()]:
                        offset = 0
                        if name in calc_var_to_offset:
                            offset = calc_var_to_offset[name]
                        name_to_use = name
                        index_var = 0
                        for val in sorted_indexes:
                            if "x["+str(val)+"]" in name_to_use:
                                # there is an x[..] in the name of the variable itself!
                                name_to_use = name_to_use.replace("x["+str(val)+"]", "x[indexOffset +" +str(index_var)+"]")
                                index_var += 1
                        line = line.replace("SHOULD NOT BE USED - CALCULATED VAR /* " + name_to_use, \
                            "evalCalculatedVarIAdept(" + str(self.dic_calc_var_index[name]) + ", indexOffset + " + str(offset) +", x, xd) /* " + name)
                body.append(line)


            self.list_for_evalcalculatedvariadept.append("  if (iCalculatedVar == " + str(index)+")  /* "+ var.get_name() + " */\n")
            self.list_for_evalcalculatedvariadept.extend(body)
            index += 1

            self.list_for_evalcalculatedvariadept.append("\n\n")
        self.list_for_evalcalculatedvariadept.append("  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);\n")


    ##
    # return the list of lines that constitues the body of evalCalculatedVarIAdept
    # @param self : object pointer
    # @return list of lines
    def get_list_for_evalcalculatedvariadept(self):
        return self.list_for_evalcalculatedvariadept

    ##
    # prepare the lines that constitues the body for getIndexesOfVariablesUsedForCalculatedVarI
    # @param self : object pointer
    # @return
    def prepare_for_getindexofvarusedforcalcvari(self):
        map_dep = self.reader.get_map_dep_vars_for_func()
        index = 0
        for var in self.reader.list_calculated_vars:
            var_name = var.get_name()
            if var_name in map_dep:
                list_depend = map_dep[var_name]
                list_of_indexes = []
                for dependency in list_depend:
                    for syst_var in self.list_vars_syst:
                        if syst_var.get_dynawo_name() is None or  syst_var.get_dynawo_name() == "": continue
                        if syst_var.get_name() == dependency:
                            dependency_index = int(syst_var.get_dynawo_name().replace("]","").replace("x[",""))
                            if dependency_index not in list_of_indexes:
                                list_of_indexes.append(dependency_index)
                if len(list_of_indexes) > 0 or var_name in self.dic_calc_var_recursive_deps:
                    self.list_for_getindexofvarusedforcalcvari.append("  if (iCalculatedVar == " + str(index)+")  /* "+ var.get_name() + " */ {\n")
                    list_of_indexes.sort()
                    for dependency_index in list_of_indexes:
                        self.list_for_getindexofvarusedforcalcvari.append("    indexes.push_back(" + str(dependency_index) + ");\n")
                    if var_name in self.dic_calc_var_recursive_deps:
                        for name in self.dic_calc_var_recursive_deps[var_name]:
                            self.list_for_getindexofvarusedforcalcvari.append("    getIndexesOfVariablesUsedForCalculatedVarI(" + str(self.dic_calc_var_index[name])+ ", indexes);\n")
                    self.list_for_getindexofvarusedforcalcvari.append("  }\n")
            index+=1


    ##
    # return the list of lines that constitues the body of getIndexesOfVariablesUsedForCalculatedVarI
    # @param self : object pointer
    # @return list of lines
    def get_list_for_getindexofvarusedforcalcvari(self):
        return self.list_for_getindexofvarusedforcalcvari

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
  dataStructInitialized_ = true;
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

  nb = (data->modelData->nExtObjs > 0) ? data->modelData->nExtObjs : 0;
  data->simulationInfo->extObjs = (void**) calloc(nb, sizeof(void*));


  // buffer for all parameters values
  nb = (data->modelData->nParametersReal > 0) ? data->modelData->nParametersReal : 0;
  data->simulationInfo->realParameter = (modelica_real*) calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nParametersBoolean > 0) ? data->modelData->nParametersBoolean : 0;
  data->simulationInfo->booleanParameter = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));

  nb = (data->modelData->nParametersInteger > 0) ? data->modelData->nParametersInteger : 0;
  data->simulationInfo->integerParameter = (modelica_integer*) calloc(nb, sizeof(modelica_integer));

  nb = (data->modelData->nParametersString > 0) ? data->modelData->nParametersString : 0;
  data->simulationInfo->stringParameter = (modelica_string*) calloc(nb, sizeof(modelica_string));

  // buffer for DAE mode data structures
  nb = (data->simulationInfo->daeModeData->nResidualVars > 0) ? data->simulationInfo->daeModeData->nResidualVars : 0;
  data->simulationInfo->daeModeData->residualVars = (modelica_real*) calloc(nb, sizeof(modelica_real));

  nb = (data->simulationInfo->daeModeData->nAuxiliaryVars > 0) ? data->simulationInfo->daeModeData->nAuxiliaryVars : 0;
  data->simulationInfo->daeModeData->auxiliaryVars = (modelica_real*) calloc(nb, sizeof(modelica_real));

  for (unsigned i = 0; i < data->simulationInfo->daeModeData->nAuxiliaryVars; ++i)
    data->simulationInfo->daeModeData->auxiliaryVars[i] = 0;
  for (unsigned i = 0; i < data->simulationInfo->daeModeData->nResidualVars; ++i)
    data->simulationInfo->daeModeData->residualVars[i] = 0;

  // buffer for all relation values
  nb = (data->modelData->nRelations > 0) ? data->modelData->nRelations : 0;
  data->simulationInfo->relations = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));
  data->simulationInfo->relationsPre = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));

  // buffer for mathematical events
  data->simulationInfo->mathEventsValuePre = (modelica_real*) calloc(data->modelData->nMathEvents, sizeof(modelica_real));

  data->simulationInfo->discreteCall = 0;
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
  if(! dataStructInitialized_)
    return;

  dataStructInitialized_ = false;
  free(data->localData[0]->booleanVars);
  free(data->localData[0]);
  free(data->localData);
  // buffer for all variable pre values
  free(data->simulationInfo->derivativesVarsPre);
  free(data->simulationInfo->realVarsPre);
  free(data->simulationInfo->booleanVarsPre);
  free(data->simulationInfo->integerDoubleVarsPre);
  free(data->simulationInfo->discreteVarsPre);
"""
        index = 0
        for ext_obj in self.reader.external_objects:
            if "ExternalCombiTable1D" in str(ext_obj.get_start_text()):
                body += """
  omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(data->simulationInfo->extObjs["""+str(index)+"""]);
"""
            if "ExternalCombiTable2D" in str(ext_obj.get_start_text()):
                body += """
  omc_Modelica_Blocks_Types_ExternalCombiTable2D_destructor(data->simulationInfo->extObjs["""+str(index)+"""]);
"""
            if "ExternalCombiTimeTable" in str(ext_obj.get_start_text()):
                body += """
  omc_Modelica_Blocks_Types_ExternalCombiTimeTable_destructor(data->simulationInfo->extObjs["""+str(index)+"""]);
"""
            index+=1
        if (len(self.reader.external_objects) > 0):
            body += """
  free(data->simulationInfo->extObjs);
"""
        body += """
  // buffer for all parameters values
  free(data->simulationInfo->realParameter);
  free(data->simulationInfo->booleanParameter);
  free(data->simulationInfo->integerParameter);
  free(data->simulationInfo->stringParameter);
  // buffer for DAE mode data structures
  free(data->simulationInfo->daeModeData->residualVars);
  free(data->simulationInfo->daeModeData->auxiliaryVars);
  free(data->simulationInfo->daeModeData);
  // buffer for all relation values
  free(data->simulationInfo->relations);
  free(data->simulationInfo->relationsPre);
  free(data->simulationInfo->mathEventsValuePre);
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
    # returns the lines that defines warnings/assert
    # @param self : object pointer
    # @return list of lines
    def get_list_for_parameters_warnings (self):
        return self.list_for_parameters_warnings

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
        self.prepare_for_collectsilentz()
        self.prepare_for_setg()
        self.prepare_for_setg_equations()
        self.prepare_for_sety0()
        self.prepare_for_callcustomparametersconstructors()
        self.prepare_for_initrpar()
        self.prepare_for_setupdatastruc()
        self.prepare_for_evalstaticytype()
        self.prepare_for_evaldynamictype()
        self.prepare_for_evalstaticftype()
        self.prepare_for_evaldynamicftype()
        self.prepare_for_defelem()
        self.prepare_for_setsharedparamsdefaultvalue()
        self.prepare_for_setparams()
        self.prepare_for_evalfadept()
        self.prepare_for_setvariables()
        self.prepare_for_defineparameters()
        self.prepare_for_literalconstants()
        self.prepare_for_evalcalculatedvars()
        self.prepare_for_evalcalculatedvari()
        self.prepare_for_evalcalculatedvariadept()
        self.prepare_for_getindexofvarusedforcalcvari()
