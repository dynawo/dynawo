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

import re
import sys
import copy

from utils import *


################################
### Variables ##################
################################

DUMMY_VARIABLE_NAME = "$dummy"
INFO_OMC_PARAM = "info, "
"""
Filter variables. To use in argument of the primitive "filter" for example .
"""
##
# Check whether the variable is a variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a variable of the system
def is_syst_var(var):
    # if it's a var $dummy for omc, it does not count
    name_var = var.get_name()
    if DUMMY_VARIABLE_NAME in name_var : return False

    type_var = var.get_type()
    variability = var.get_variability()

    right_var_type = (type_var in ["rSta", "rAlg"])
    is_continuous = (variability == "continuous")
    is_fixed = (var.is_fixed())

    return is_continuous and right_var_type and not is_fixed and "der(" not in name_var

##
# Check whether the variable is a variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a variable of the system
def is_var(var):
    # if it's a var $dummy for omc, it does not count
    name_var = var.get_name()
    if DUMMY_VARIABLE_NAME in name_var : return False

    type_var = var.get_type()
    variability = var.get_variability()
    # iAlg is for Integer variable
    right_var_type = (type_var in ["rSta", "rAlg", "rAli", "iAlg", "iAli", "bAlg","bAli"])
    is_continuous = (variability in ["continuous","discrete"])

    if type_var == "rAlg" and "der(" in name_var: return False

    return is_continuous and right_var_type

##
# Check whether the variable is an algebraic variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a algebraic variable of the system
def is_alg_var(var):
    name_var = var.get_name()
    type_var = var.get_type()
    variability = var.get_variability()

    right_var_type = (type_var in ["rAlg"])
    is_continuous = (variability == "continuous")

    return is_continuous and right_var_type and "der(" not in name_var

##
# Check whether the variable is a continuous variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a continuous variable of the system
def is_real_var(var):
    type_var = var.get_type()
    variability = var.get_variability()
    return variability == "continuous" and (type_var == "rAlg" or type_var == "rAli")
##
# Check whether the variable is a discrete variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a discrete variable of the system
def is_discrete_real_var(var):
    type_var = var.get_type()
    variability = var.get_variability()
    return variability == "discrete" and (type_var == "rAlg" or type_var == "rAli")

##
# Check whether the variable is an integer variable of the system or not
# @param var : variable to test
# @return @b True if the variable is an integer variable of the system
def is_integer_var(var):
    type_var = var.get_type()
    variability = var.get_variability()
    return variability == "discrete" and (type_var == "iAlg" or type_var =="iAli")
##
# Check whether the variable is a discrete variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a discrete variable of the system
def is_discrete_var(var):
    return is_integer_var(var) or is_discrete_real_var(var) or is_bool_var(var)

##
# Check whether the variable is a continuous const variable of the system or not
# @param var : variable to test
# @return @b True if the variable is const variable of the system
def is_real_const_var(var):
    type_var = var.get_type()
    variability = var.get_variability()

    right_var_type = (type_var in ["rAlg", "rAli"])
    is_continuous = (variability in ["continuous"])
    return right_var_type and is_continuous and var.is_fixed()

##
# Check whether the variable is a discrete real const variable of the system or not
# @param var : variable to test
# @return @b True if the variable is const variable of the system
def is_discrete_real_const_var(var):
    type_var = var.get_type()
    variability = var.get_variability()

    right_var_type = (type_var in ["rAlg", "rAli"])
    is_discrete = (variability in ["discrete"])
    return right_var_type and is_discrete and var.is_fixed()

##
# Check whether the variable is an integer const variable of the system or not
# @param var : variable to test
# @return @b True if the variable is const variable of the system
def is_integer_const_var(var):
    type_var = var.get_type()
    variability = var.get_variability()

    right_var_type = (type_var in ["iAlg", "iAli"])
    is_discrete = (variability in ["discrete"])
    return right_var_type and is_discrete and var.is_fixed()

##
# Check whether the variable is a boolean const variable of the system or not
# @param var : variable to test
# @return @b True if the variable is const variable of the system
def is_boolean_const_var(var):
    type_var = var.get_type()
    variability = var.get_variability()

    right_var_type = (type_var in ["bAlg", "bAli"])
    is_discrete = (variability in ["discrete"])
    return right_var_type and is_discrete and var.is_fixed() and not is_when_var(var)
##
# Check whether the variable is a discrete const variable of the system or not
# @param var : variable to test
# @return @b True if the variable is discrete const variable of the system
def is_discrete_const_var(var):
    return is_integer_const_var(var) or is_boolean_const_var(var) or is_discrete_real_const_var(var)
##
# Check whether the variable is a const variable of the system or not
# @param var : variable to test
# @return @b True if the variable is const variable of the system
def is_const_var(var):
    return is_discrete_const_var(var) or is_real_const_var(var)

EXTERNAL_PARAMETER, SHARED_PARAMETER, INTERNAL_PARAMETER = range(3)

##
# describe the scope of a given parameter
# @param par : parameter to test
# @return the parameter scope
def param_scope(par):
    if is_param_with_private_equation (par):
        return INTERNAL_PARAMETER
    elif is_param_internal(par):
        return SHARED_PARAMETER
    else:
        return EXTERNAL_PARAMETER

def param_scope_str (par_scope):
    if par_scope == INTERNAL_PARAMETER:
        return "INTERNAL_PARAMETER"
    elif par_scope == SHARED_PARAMETER:
        return "SHARED_PARAMETER"
    elif par_scope == EXTERNAL_PARAMETER:
        return "EXTERNAL_PARAMETER"

##
# Check whether the parameter is a boolean parameter
# @param par : parameter to test
# @return @b True if the parameter is a boolean parameter
def is_param_bool(par):
    type_var = par.get_type()
    return type_var == "bPar"

##
# Check whether the parameter is an external boolean parameter
# @param par : parameter to test
# @return @b True if the parameter is an external boolean parameter
def is_param_ext_bool(par):
    internal = par.get_internal()
    use_start = par.get_use_start()
    return is_param_bool(par) and not internal and not use_start

##
# Check whether the parameter is an internal boolean parameter
# @param par : parameter to test
# @return @b True if the parameter is an internal boolean parameter
def is_param_internal_bool(par):
    return is_param_bool(par) and not is_param_ext_bool(par)

##
# Check whether the parameter is an integer parameter
# @param par : parameter to test
# @return @b True if the parameter is an integer parameter
def is_param_integer(par):
    type_var = par.get_type()
    return type_var == "iPar"

##
# Check whether the parameter is an external integer parameter
# @param par : parameter to test
# @return @b True if the parameter is an external integer parameter
def is_param_ext_integer(par):
    internal = par.get_internal()
    use_start = par.get_use_start()
    return is_param_integer(par) and not internal and not use_start

##
# Check whether the parameter is an internal integer parameter
# @param par : parameter to test
# @return @b True if the parameter is an internal integer parameter
def is_param_internal_integer(par):
    return is_param_integer(par) and not is_param_ext_integer(par)


##
# Check whether the parameter is a string parameter
# @param par : parameter to test
# @return @b True if the parameter is a string parameter
def is_param_string(par):
    type_var = par.get_type()
    return type_var == "sPar"

##
# Check whether the parameter is an external string parameter
# @param par : parameter to test
# @return @b True if the parameter is an external string parameter
def is_param_ext_string(par):
    start_text = par.get_start_text()[0]
    return is_param_string(par) and start_text == ""

##
# Check whether the parameter is an internal string parameter
# @param par : parameter to test
# @return @b True if the parameter is an internal string parameter
def is_param_internal_string(par):
    return is_param_string(par) and not is_param_ext_string(par)

##
# Check whether the parameter is a real parameter
# @param par : parameter to test
# @return @b True if the parameter is a real parameter
def is_param_real(par):
    type_var = par.get_type()
    return type_var == "rPar"

##
# Check whether the parameter is an external real parameter
# @param par : parameter to test
# @return @b True if the parameter is an external real parameter
def is_param_ext_real(par):
    internal = par.get_internal()
    init_by_init_extend = par.get_init_by_extend_in_06inz()
    use_start = par.get_use_start()
    return is_param_real(par) and not internal and not init_by_init_extend and not use_start


##
# Check whether the parameter is an internal real parameter
# @param par : parameter to test
# @return @b True if the parameter is an internal real parameter
def is_param_internal_real(par):
    return is_param_real(par) and not is_param_ext_real(par)

##
# a parameter is considered internal if and only if it is set by a (system of) equation
def is_param_internal(par):
    return is_param_internal_integer(par) or is_param_internal_bool(par) or is_param_internal_string(par) or is_param_internal_real(par)

def is_param_with_private_equation(par):
    return par.get_init_by_param() or par.get_init_by_param_in_06inz()

##
# Check whether the variable is a parameter
# @param par : parameter to test
# @return @b True if the variable is a  parameter
def is_param_var(par):
    return is_param_bool(par) or is_param_integer(par) or is_param_real(par) or is_param_string(par)

##
# Check whether the variable is a boolean variable
# @param var : variable to test
# @return @b True if the variable is a boolean variable
def is_bool_var(var):
    type_var = var.get_type()
    return (type_var == "bAlg" or type_var == "bAli")

##
# Check whether the variable is derivative variable
# @param var : variable to test
# @return @b True if the variable is a derivative variable
def is_der_real_var(var):
    # if it's a var $dummy for omc, it does not count
    name_var = var.get_name()
    if DUMMY_VARIABLE_NAME in name_var : return False

    type_var = var.get_type()
    return type_var == "rDer"

##
# Check if the variable is a variable used to define a when equation
# @param var : variable to test
# @return @b True if the variable is used to define a when equation
def is_when_var(var):
    type_var = var.get_type()
    return (type_var == "bAlg" or type_var == "bAli") and ("$whenCondition" in var.get_name())

##
# Check if the variable is a dummy variable
# @param var : variable to test
# @return @b True if the variable is a dummy variable
def is_dummy_var(var):
    return DUMMY_VARIABLE_NAME in var.get_name() and "der(" not in var.get_name()

##
# Compare two variables thanks to the way they are initialised
# @param var1 : first variable to compare
# @param var2 : second variable to compare
# @return 1 if var1 should be before var2, 0 if they should have the same index, -1 otherwise
def cmp_num_init_vars(var1, var2):
    """
    Compare 2 vars with crietria
       1. fixed by extends or parameter
       2. init function number read in *_06inz.c
    """

    extend1, extend2 = var1.get_init_by_extend_in_06inz(), var2.get_init_by_extend_in_06inz()
    if extend1 and (not extend2) : return 1
    elif (not extend1) and extend2 : return -1

    num1, num2 = int(var1.get_num_func_06inz()), int(var2.get_num_func_06inz())
    if num1 > num2 : return 1
    elif num1 < num2 : return -1

    # both elements have the same index
    return 0

##
# Variable class : store data to each variable read
#
class Variable:
    ##
    # default constructor
    def __init__(self):

        ## name of the variable
        self.name = ""

        ## Name of the alias of this variable
        self.alias_name = ""
        ## @b true if the alias value is the opposite of the variable value
        self.alias_negated = False
        ## causality of the variable : output/internal
        self.causality = ""
        ## variability of the variable : "parameter", "continuous", "discrete"
        self.variability = ""
        ## is the variable initialize thanks to a parameter
        self.init_by_param = False
        ## is the variable initialize thanks to a parameter in the 06Inz file
        self.init_by_param_in_06inz = False
        ## is the variable initialize thanks to an extend in the 06Inz file
        self.init_by_extend_in_06inz = False
        ## Should we use the start value to initialize the variable
        self.use_start = False

        # "bAlg" (var alg bool), "rAlg" (var alg reelle), "rSta" (real state variable),
        # "rDer" (var diff reelle), "rPar" (param reel), "rAli" (real state variable with an alias)
        ## OpenModelica type of the variable
        self.type = ""

        # table containing the different possible types of this variable
        # a type can be ALGEBRAIC if the variable is always algebraic, DIFFERENTIAL if the variable is always differential or MIXED if it depends on some conditions
        self.ordered_types = []

        ## Dynamic type of the variable : CONTINUOUS, DISCRETE, FLOW
        self.dyn_type = ""

        ## Start text declared in 06inz file to initialize the variable
        self.start_text_06inz = []
        ## Start text declared in 08bnd file to initialize the variable
        self.start_text = [""]
        ## Is a fixed variable
        self.fixed = False
        ## Is the initial value of the variable declared in the mo file
        self.internal = False

        ## Name of the variable used in dynawo sources (x[i],xd[i],z[i],rpar[i])
        self.dynawo_name = ""
        ## Index of the variable in omc arrays
        self.index = -1
        ## Index of the init function in 06Inz file
        self.num_func_06inz = -1


    ##
    # Set the name of the variable
    # @param self : object pointer
    # @param name : name of the variable
    # @return
    def set_name(self, name):
       self.name = name

    ##
    # Set the alias name of the variable and if this alias is the opposite of the true variable
    # @param self : object pointer
    # @param name : name of the alias
    # @param negated : @b True is this alias is the opposite of the true variable
    # @return
    def set_alias_name(self, name, negated):
       self.alias_name = name
       self.alias_negated = negated

    ##
    # Set the variability (parameter/continuous/discrete) of the variable
    # @param self : object pointer
    # @param variability : variability of the variable
    # @return
    def set_variability(self, variability):
       self.variability = variability
    ##
    # Set if the variable is initialized by a parameter
    # @param self : object pointer
    # @param bool : @b True is the variable is initialized by a parameter
    # @return
    def set_init_by_param(self, bool):
        self.init_by_param = bool

    ##
    # Set if the variable is initialized by a parameter in the file 06inz
    # @param self : object pointer
    # @param bool : @b True is the variable is initialized by a parameter in th file 06inz
    # @return
    def set_init_by_param_in_06inz(self, bool):
        self.init_by_param_in_06inz = bool

    ##
    # Set if the variable is initialized by an extend in the file 06inz
    # @param self : object pointer
    # @param bool : @b True is the variable is initialized by an extend in th file 06inz
    # @return
    def set_init_by_extend_in_06inz(self, bool):
        self.init_by_extend_in_06inz = bool

    ##
    # Set the causality of the variable (output/internal)
    # @param self : object pointer
    # @param causality: causality of the variable
    # @return
    def set_causality(self, causality):
        self.causality = causality

    ##
    # Set the OpenModelica type of the variable (bAlg,rAlg,...)
    # @param self : object pointer
    # @param type : type of the variable
    # @return
    def set_type(self, type):
        self.type = type

    ##
    # add a type to the variable (ALGEBRAIC, DIFFERENTIAL, or MIXED)
    # @param self : object pointer
    # @param type : new additional type of the variable
    def add_ordered_types(self, type):
        self.ordered_types.append(type)

    ##
    # Set the dynamic type of the variable (continuous/discrete/flow)
    # @param self : object pointer
    # @return
    def set_dyn_type(self):
        if self.get_type()[0] == "r":
            self.dyn_type = "CONTINUOUS"
        elif self.get_type()[0] == "i":
            self.dyn_type = "INTEGER"
        elif self.get_type()[0] == "b":
            self.dyn_type = "BOOLEAN"
        elif self.get_type()[0] == "s":
            self.dyn_type = "STRING"
    ##
    # Set the dynamic type of the variable to be discrete
    # @param self: object pointer
    # @return
    def set_discrete_dyn_type(self):
        self.dyn_type = "DISCRETE"

    ##
    # Set the dynamic type of the variable to be flow
    # @param self: object pointer
    # @return
    def set_flow_dyn_type(self):
        self.dyn_type = "FLOW"
    ##
    # Set the list of lines used to initialize the variable in 06inz file
    # @param self : object pointer
    # @param start_text : list of lines
    # @return
    def set_start_text_06inz(self, start_text):
        self.start_text_06inz = start_text

    ##
    # Set the list of lines used to initialize the variable in 08bnd file
    # @param self : object pointer
    # @param start_text : list of lines
    # @return
    def set_start_text(self, start_text):
        self.start_text = start_text

    ##
    # Set the fixed attribute
    # @param self : object pointer
    # @param fixed : fixed attribute
    # @return
    def set_fixed(self, fixed):
        self.fixed = fixed

    ##
    # Set if the initial value is set in the mo file
    # @param self : object pointer
    # @param internal : @b true if the initial value is set in the mo file
    # @return
    def set_internal(self, internal):
        self.internal = internal

    ##
    # Set the name of the variable to use in Dynawo (x[i], xd[i], z[i], rpar[i])
    # @param self : object pointer
    # @param name : dynawo name of the variable
    # @return
    def set_dynawo_name(self, name):
        self.dynawo_name = name

    ##
    # Set the index of the variable in omc arrays
    # @param self : object pointer
    # @param index : variable's index
    # @return
    def set_index(self, index):
        self.index = index

    ##
    # Set the index of the function used to initialize the variable in the 06inz file
    # @param self : object pointer
    # @param num_func06_inz : index of the function
    # @return
    def set_num_func_06inz(self, num_func06_inz):
        self.num_func_06inz = num_func06_inz

    ##
    # Set if the initial value should be used
    # @param self : object pointer
    # @param use_start : @b true if the initial value should be used
    # @return
    def set_use_start(self, use_start):
        self.use_start = use_start != "false"

    ##
    # Get the name of the variable
    # @param self : object pointer
    # @return : name of the variable
    def get_name(self):
       return self.name

    ##
    # return true if this variable is an alias
    # @param self : object pointer
    # @return true if this variable is an alias
    def is_alias(self):
       return self.get_alias_name() != ""

    ##
    # Get the alias name of the variable
    # @param self : object pointer
    # @return the alias name of the variable
    def get_alias_name(self):
       return self.alias_name

    ##
    # Get if this alias is the opposite of the true variable
    # @param self : object pointer
    # @return @b true is the alias is the opposite of the true variable
    def get_alias_negated(self):
       return self.alias_negated

    ##
    # Get the name used in dynawo to identify the variable
    # @param self : object pointer
    # @return the dynawo's name of the variable
    def get_dynawo_name(self):
        return self.dynawo_name

    ##
    # get the variability of the variable
    # @param self : object pointer
    # @return the variability of the variable
    def get_variability(self):
       return self.variability

    ##
    # Get if the variable is initialized thanks to a parameter
    # @param self : object pointer
    # @return @b true if the variable is initialized thanks to a parameter
    def get_init_by_param(self):
        return self.init_by_param

    ##
    # Get if the variable is initialized thanks to a parameter in 06inz file
    # @param self : object pointer
    # @return @b true if the variable is initialized thanks to a parameter in 06inz file
    def get_init_by_param_in_06inz(self):
        return self.init_by_param_in_06inz

    ##
    # Get if the variable is initialized thanks to an extend in 06inz file
    # @param self : object pointer
    # @return @b true if the variable is initialized thanks to an extend in 06inz file
    def get_init_by_extend_in_06inz(self):
        return self.init_by_extend_in_06inz

    ##
    # Get the causality of a variable
    # @param self : object pointer
    # @return the causality of the variable
    def get_causality(self):
       return self.causality

    ##
    # Get the type of a variable
    # @param self : object pointer
    # @return the type of the variable
    def get_type(self):
       return self.type

    ##
    # get the ordered types of this variable
    # @param self : object pointer
    # @return ordered types of this variable
    def get_ordered_types(self):
        return self.ordered_types

    ##
    # Get the C type of a variable
    # @param self : object pointer
    # @return the C type of the variable value
    def get_value_type_c(self):
        if (is_param_real(self)):
            return "double"
        elif (is_param_integer(self)):
            return "int"
        elif (is_param_string(self)):
            return "string"
        elif (is_param_bool(self)):
            return "bool"

    ##
    # Get the Modelica C type of a variable
    # @param self : object pointer
    # @return the C type of the variable value used in the transcripted Modelica -> C code
    def get_value_type_modelica_c_code (self):
        if (is_param_real(self)):
            return "double"
        elif (is_param_integer(self)):
            return "int"
        elif (is_param_string(self)):
            return "string"
        elif (is_param_bool(self)):
            return "modelica_real"

    ##
    # Get the dynamic type of a variable
    # @param self : object pointer
    # @return the dynamic type of the variable
    def get_dyn_type(self):
       return self.dyn_type

    ##
    # Get the start text used to initialized a variable
    # @param self : object pointer
    # @return the start text used to initialized the variable
    def get_start_text(self):
        return self.start_text

    ##
    # Get the fixed attribute
    # @param self : object pointer
    # @return the fixed attribute
    def is_fixed(self):
        return self.fixed


    ##
    # Get the start text used to initialized the variable in 06inz file
    # @param self : object pointer
    # @return the start text used to initialized the variable in 06inz file
    def get_start_text_06inz(self):
        return self.start_text_06inz

    ##
    # Get if the initial value of the variable is defined in the mo file
    # @param self : object pointer
    # @return the initial value of the variable
    def get_internal(self):
       return self.internal

    ##
    # Get the index of the variable in array
    # @param self : object pointer
    # @return the index in array
    def get_index(self):
       return self.index

    ##
    # Get the index of the function used in 06inz file to initialize the variable
    # @param self : object pointer
    # @return the index of the function
    def get_num_func_06inz(self):
        return self.num_func_06inz

    ##
    # Get if the start text should be used to  initialize the variable
    # @param self : object pointer
    # @return @b true if the start text should be used
    def get_use_start(self):
        return self.use_start

    ##
    # Erase some part of the start text : {/} at the begin/end of the body
    # Replace some macro created by omc (DIVISION(a1,a2,a3) => a1/a2 ...
    # @param self : object pointer
    # @return
    def clean_start_text(self):
        # Removing the opening and closing braces of the body
        self.start_text.pop(0)
        self.start_text.pop()

        # Replace DIVISION_SIM(a1,a2,a3,a4) ==> a1 / a2
        # Difficult to do this with a regex and a sub, so we use
        # the function "sub_division_sim()" (see utils.py)
        txt_tmp = []
        ptrn_assign_var = re.compile(r'^[ ]*\(data->modelData->[\w\[\]]*[ ]*\/\*.*\*\/\)\.attribute[ ]*\.start[ ]*=[ ]*(?P<initVal>[^;]*);$')
        ptrn_local_var = re.compile(r'^[ ]*[^;]*=[ ]*\(data->modelData->[\w\[\]]*[ ]*\/\*.*\*\/\)\.attribute[ ]*\.start[ ]*;$')
        for line in self.start_text:
            if has_omc_trace (line) or has_omc_equation_indexes (line) or ptrn_local_var.match(line) or "infoStreamPrint" in line:
                continue

            if "tmp" in line:
                line = line.replace("tmp","tmp_"+to_compile_name(self.get_name()))
            line_tmp = sub_division_sim(line) # hard to process using a regex
            if THREAD_DATA_OMC_PARAM in line_tmp:
                line_tmp=line_tmp.replace(THREAD_DATA_OMC_PARAM, "")
            if "throwStream" in line_tmp:
                line_tmp = throw_stream_indexes(line_tmp)
            if "omc_assert_warning" in line_tmp:
                line_tmp = line_tmp.replace(INFO_OMC_PARAM,"")

            match = ptrn_assign_var.search(line_tmp)
            if match is not None:
                test_param_address(self.get_name())
                txt_tmp.append(to_param_address(self.get_name()) + " /* " + self.get_name() + " */ = " + match.group('initVal')+";\n")
            else :
                txt_tmp.append(line_tmp)

        self.start_text = txt_tmp

    def should_use_default_start(self, list_omc_functions):
        tmp_abs_var_prtn = re.compile(r'[\(]+data->localData\[0\]->realVars\[[0-9+]\][ ]*\/\*\s*\$TMP\$VAR\$[0-9]+\$0X\$ABS\s*variable\s*\*\/[\)]+\s*\>\= 0.0 \? 1.0\:-1.0\)\)\s*\*')
        for line in self.start_text_06inz:
            if re.search(tmp_abs_var_prtn, line) is not None:
                return True
            for func in list_omc_functions:
                if func.get_name() == "omc_Modelica_Blocks_Tables_Internal_getNextTimeEvent": continue
                if func.get_name().startswith("omc_") and func.get_name() in line:
                    return True
        return False
    ##
    # Erase some part of the start text used in 06inz file : {/} at the begin/end of the body
    # Replace some macro created by omc (DIVISION(a1,a2,a3) => a1/a2 ...
    # @param self : object pointer
    # @return
    def clean_start_text_06inz(self):
            """
            Cleaning the initialization text:
            - Remove "{" and "}" at the beginning and end of the function body
            - Replace DIVISION(a1,a2,a3) by a1 / a2
            """

            # Removing the opening and closing braces of the body
            self.start_text_06inz.pop(0)
            self.start_text_06inz.pop()

            tmp_abs_var_prtn = re.compile(r'[\(]+data->localData\[0\]->realVars\[[0-9+]\][ ]*\/\*\s*\$TMP\$VAR\$[0-9]+\$0X\$ABS\s*variable\s*\*\/[\)]+\s*\>\= 0.0 \? 1.0\:-1.0\)\)\s*\*')

            txt_tmp = []
            for line in self.start_text_06inz:
                if has_omc_trace (line) or has_omc_equation_indexes (line)or "infoStreamPrint" in line:
                    continue

                # Replace DIVISION(a1,a2,a3,a4) by a1 / a2
                # Difficult to do this with a regex and a sub, so we use
                # the function "sub_division_sim()" (see utils.py)
                line_tmp = sub_division_sim(line)
                line_tmp = throw_stream_indexes(line_tmp)
                if "omc_assert_warning" in line_tmp:
                    line_tmp = line_tmp.replace(INFO_OMC_PARAM,"")
                if re.search(tmp_abs_var_prtn, line_tmp) is not None:
                    error_exit("Variable " + self.get_name() + " is defined in a equation with multiple solutions. In this case a start value should be defined to provide the initial sign of this variable.")

                if THREAD_DATA_OMC_PARAM in line_tmp:
                    line_tmp=line_tmp.replace(THREAD_DATA_OMC_PARAM, "")
                    txt_tmp.append(line_tmp)
                elif HASHTAG_IFDEF not in line_tmp and HASHTAG_ENDIF not in line_tmp \
                        and "SIM_PROF_" not in line_tmp and "NORETCALL" not in line_tmp:
                    txt_tmp.append(line_tmp)

            self.start_text_06inz = txt_tmp

    ##
    # define the __str__ method for variable class
    # @param self : object pointer
    # @return the pretty string to use for this class when calling __str__
    def __str__(self):
        return str(self.__dict__)


##
# Element class : store data to describe an element of the model
#
class Element:
    ##
    # default constructor
    # @param self : object pointer
    # @param is_struct : @b true is the element is a structure
    # @param name : name of the element
    # @param num_elt : index of the element
    def __init__(self, is_struct = None, name = None, num_elt=None):
        ## @b true if the element is a structure
        self.is_struct = False

        ## Index of the element in defineElements function
        self.num_elt = -1

        ## Name of the element
        self.name = ""

        ## short name of the element
        self.short_name=""

        ## in case of a structure, list of elements that constitues the structure
        self.list_elements = []

        if is_struct is not None : self.is_struct = is_struct
        if num_elt is not None : self.num_elt = num_elt
        if name is not None :
            self.name = name
            split_name = name.split('.')
            self.short_name=split_name[len(split_name)-1]

    ##
    # Get the short name of the element name1.name2.name => name
    # @param self : object pointer
    # @return the short name of the element
    def get_element_short_name(self):
        return self.short_name

    ##
    # Get the name of the element
    # @param self : object pointer
    # @return the name of the element
    def get_element_name(self):
        return self.name

    ##
    # Get the index of the element
    # @param self : object pointer
    # @return index of the element
    def get_element_num(self):
        return self.num_elt

    ##
    # Get if the element is a structure
    # @param self : object pointer
    # @return @b true if the element is a structure
    def is_structure(self):
        return self.is_struct

    ##
    # Creates the line to describe a structure
    # @param self : object pointer
    # @param lines_to_return : lines to describe the structure
    # @return
    def print_link(self,lines_to_return):
        motif="  elements[%s].subElementsNum().push_back(%s);\n"
        for elt in self.list_elements :
            line = motif % (str(self.num_elt),str(elt.get_element_num()))
            lines_to_return.append(line)


##
# Compare 2 equations thanks to their omc index
# @param eq1 : first equation to compare
# @param eq2 : second equation to compare
# @return 1 if eq1 > eq2, -1 if eq2 > eq1, 0 otherwise
def cmp_equations(eq1, eq2):
    """
    Compare 2 functions with their number in omc (in main *.c or other *.c)
    """
    num_omc1, num_omc2 = int(eq1.get_num_omc()), int(eq2.get_num_omc())
    if num_omc1 > num_omc2: res = 1
    elif num_omc1 < num_omc2: res = -1
    else: res = 0
    return res


##
# class Raw Function : store information about functions read in file without any treatement
#
class RawFunc:
    ##
    # default constructor
    # @param self : object pointer
    # @param fct : useless ??
    def __init__(self, fct = None):
        ## name of the function in the read file
        self.name = ""
        ## index of the function in the read file
        self.num_omc = ""
        ## List of lines that constitues the body of the function
        self.body = []

    ##
    # Check whether the current function is a reinit one
    # @param self : object pointer
    # @return whether it is a reinit function
    def get_is_modelica_reinit (self):
        return is_modelica_reinit_body(self.body)

    ##
    # Set the name of the function
    # @param self: object pointer
    # @param name : name of the function
    # @return
    def set_name(self, name):
        self.name = name

    ##
    # Set the index of the function
    # @param self : object pointer
    # @param num : index of the function
    # @return
    def set_num_omc(self, num):
        self.num_omc = num
    ##
    # Set the body of the function
    # @param self : object pointer
    # @param body : body of the function
    # @return
    def set_body(self, body):
        self.body.extend(body)

    ##
    # Get the name of the function
    # @param self : object pointer
    # @return :  the name of the function
    def get_name(self):
        return self.name

    ##
    # Get the index of the function in omc file
    # @param self : object pointer
    # @return : the index of the function
    def get_num_omc(self):
        return self.num_omc

    ##
    # Get the body of the funtion
    # @param self: object pointer
    # @return the body of the function
    def get_body(self):
        return self.body

    ##
    # define the __str__ method for rawFunction class
    # @param self : object pointer
    # @return the pretty string to use for this class when calling __str__
    def __str__(self):
        return str(self.__dict__)

##
# class OmcFunctionParameter : store raw informations of parameters of omc function
#
class OmcFunctionParameter:
    ##
    # default constructor
    # @param self : object pointer
    # @param name : parameter name
    # @param type : parameter type
    # @param index : parameter index
    # @param is_input :  if True, the parameter is an input of the function. Otherwise it is an output
    def __init__(self, name, type, index, is_input):
        ## Body of the function
        self.name = name
        ## type of the function in the header file
        self.type = type
        ## name of the function
        self.index = index
        ## if True, the parameter is an input of the function. Otherwise it is an output
        self.is_input = is_input

    ##
    # Set the name of the parameter
    # @param self : object pointer
    # @param name : name of the parameter
    # @return
    def set_name(self, name):
        self.name = name

    ##
    # Get the name of the parameter
    # @param self : object pointer
    # @return : the name of the parameter
    def get_name(self):
        return self.name

    ##
    # Set the type of the parameter
    # @param self : object pointer
    # @param type : type of the parameter
    # @return
    def set_type(self, type):
        self.type = type

    ##
    # Get the type of the parameter
    # @param self : object pointer
    # @return : the type of the parameter
    def get_type(self):
        return self.type

    ##
    # Set the index of the parameter
    # @param self : object pointer
    # @param index : index of the parameter
    # @return
    def set_index(self, index):
        self.index = index

    ##
    # Get the index of the parameter
    # @param self : object pointer
    # @return : the index of the parameter
    def get_index(self):
        return self.index

    ##
    # Set the input property of the parameter
    # @param self : object pointer
    # @param is_input : input property of the parameter
    # @return
    def set_is_input(self, is_input):
        self.is_input = is_input

    ##
    # Get the input property of the parameter
    # @param self : object pointer
    # @return : the input property of the parameter
    def get_is_input(self):
        return self.is_input
##
# class Raw OpenModelicaCompiler Function : store raw informations of functions declares in
# *_functions.h/.c
#
class RawOmcFunctions:
    ##
    # default constructor
    def __init__(self):
        ## Body of the function
        self.body = []
        ## declaration of the function in the header file
        self.signature = ""
        ## name of the function
        self.name = ""
        ## type of the object returned by the function
        self.return_type = ""
        ##type of the parameters
        self.params = []
        ## List of lines that constitues the corrected body of the function
        self.corrected_body = []

    ##
    # Set the name of the function
    # @param self : object pointer
    # @param name : name of the function
    # @return
    def set_name(self, name):
        self.name = name

    ##
    # Get the name of the function
    # @param self : object pointer
    # @return : the name of the function
    def get_name(self):
        return self.name

    ##
    # Set the body of the function
    # @param self : object pointer
    # @param body : body of the function
    # @return
    def set_body(self,body):
        self.body.extend(body)
    ##
    # Set the corrected body of the function
    # @param self : object pointer
    # @param body : corrected body of the function
    # @return
    def set_corrected_body(self, corrected_body):
        self.corrected_body.extend(corrected_body)

    ##
    # Get the body of the function
    # @param self : object pointer
    # @return : the body of the function
    def get_body(self):
        return self.body

    ##
    # Get the corrected body of the funtion
    # @param self: object pointer
    # @return the corrected body of the function
    def get_corrected_body(self):
        return self.corrected_body

    ##
    # Set the definition of the function in header file
    # @param self : object pointer
    # @param signature : definition of the function in header file
    # @return
    def set_signature(self,signature):
        self.signature = signature

    ##
    # Get the definition of the function in header file
    # @param self : object pointer
    # @return : the definition of the function in header file
    def get_signature(self):
        return self.signature

    ##
    # Set the type returned by the function
    # @param self : object pointer
    # @param return_type : type returned by the function
    # @return
    def set_return_type(self,return_type):
        self.return_type = return_type

    ##
    # Get the type returned by the function
    # @param self: object pointer
    # @return type returned by the function
    def get_return_type(self):
        return self.return_type

    ##
    # Add a parameter
    # @param self : object pointer
    # @param param : parameter (of type OmcFunctionParameter)
    # @return
    def add_params(self,param):
        self.params.append(param)

    ##
    # Get the parameters
    # @param self: object pointer
    # @return parameters list
    def get_params(self):
        return self.params

    ##
    # get the variable name by removing variable type
    # @param self: object pointer
    # @param param: variable to filter
    # @return variable name without variable type
    def remove_variable_type_from_param(self, param):
        return param.replace(" variable ","").replace(" DISCRETE ","").replace(" ","")

    ##
    # find the parameters set by a call of this function
    # @param self: object pointer
    # @param line_with_call: line to analyze
    # @return outputs variable list
    def find_outputs_from_call(self, line_with_call):
        ptrn_var_assigned = re.compile(r'[ \(]*data->localData(?P<var>\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ \)]* = [ ]*'+self.name+'[ ]*\((?P<rhs>[^;]+);')
        match = re.match(ptrn_var_assigned, line_with_call)
        outputs = []
        if match is not None:
            variable_name = self.remove_variable_type_from_param(match.group("varName"))
            outputs.append(variable_name)
            ptrn_var= re.compile(r'[ ]*&\(data->localData(\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ \)]*')
            variables = re.findall(ptrn_var, match.group("rhs"))
            for output_param in variables:
                param_variable_name = self.remove_variable_type_from_param(output_param[1])
                outputs.append(param_variable_name)
        return outputs


    ##
    # find the variables used as inputs in a call of this function
    # @param self: object pointer
    # @param line_with_call: line to analyze
    # @return inputs variable list
    def find_inputs_from_call(self, line_with_call):
        ptrn_var_assigned = re.compile(r'[ \(]*data->localData(?P<var>\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ \)]* = [ ]*'+self.name+'[ ]*\((?P<rhs>[^;]+);')
        match = re.match(ptrn_var_assigned, line_with_call)
        inputs = []
        if match is not None:
            ptrn_var= re.compile(r'[ ]*[^&]\(data->localData(\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ \)]*')
            variables = re.findall(ptrn_var, match.group("rhs"))
            for input_param in variables:
                param_variable_name = self.remove_variable_type_from_param(input_param[1])
                inputs.append(param_variable_name)
        return inputs

##
# class Equation maker
#
class EqMaker():
    ##
    # default constructor
    # @param self : object pointer
    # @param raw_fct : raw function where come from the equation
    def __init__(self, raw_fct = None):
        ## Name of the function in *c files
        self.name = ""
        ## Index of the function in *c files
        self.num_omc = ""
        ##  body of the function to analyze to get the equation
        self.body_func = []
        ##  raw body of the function to analyze to get the equation
        self.raw_body = []
        ## variable evaluated by this equation
        self.evaluated_var = ""
        ## List of variables evaluated by the function (in the form data->localData[0]->...)
        self.evaluated_var_address = ""
        ## List of variables needed to build the equation
        self.depend_vars = []
        ## whether this equation is differential or not
        self.type = UNDEFINED_TYPE
        ## whether this equation is complex or not
        self.complex_eq = False

        ## For whenCondition, index of the relation associated to this equation
        self.num_relation = ""

        if raw_fct is not None:
            self.name = raw_fct.get_name()
            self.num_omc = raw_fct.get_num_omc()
            self.raw_body = copy.deepcopy( raw_fct.get_body() )
            self.body_func = raw_fct.get_body()  # Here, deepcopy?

    ##
    # Check whether the current function is a reinit one
    # @param self : object pointer
    # @return whether it is a reinit function
    def get_is_modelica_reinit (self):
        return is_modelica_reinit_body (self.body_func)

    ##
    # Set the name of the equation maker
    # @param self : object pointer
    # @param name : name of the equation maker
    # @return
    def set_name(self, name):
        self.name = name

    ##
    # Set the index of the function in *c files
    # @param self : object pointer
    # @param num : index of the function
    # @return
    def set_num_omc(self, num):
        self.num_omc = num

    ##
    # Set the name of the var evaluated by this equation
    # @param self : object pointer
    # @param name : name of the variable (in the form data->localData[0]->...)
    # @return
    def set_evaluated_var_address(self, name):
        self.evaluated_var_address = name

    ##
    # Set the name of the var evaluated by this equation
    # @param self : object pointer
    # @param name : name of the variable
    # @return
    def set_evaluated_var(self, name):
        self.evaluated_var = name

    ##
    # Set the list of variables needed to evaluate the equation
    # @param self : object pointer
    # @param list_vars : list of variables
    # @return
    def set_depend_vars(self, list_vars):
        self.depend_vars = list_vars

    ##
    # set the type of this equation (one of DIFFERENTIAL, ALGEBRAIC, MIXED)
    # @param self : object pointer
    # @param type new type of the equation
    def set_type(self, type):
        self.type = type

    ##
    # set whether this equation is complex
    # @param self : object pointer
    # @param complex_eq whether this equation is complex
    def set_complex_eq(self, complex_eq):
        self.complex_eq = complex_eq

    ##
    # Get the name of the equation maker
    # @param self : object pointer
    # @return : name of the equation maker
    def get_name(self):
        return self.name

    ##
    # Get the index of the equation in *c file
    # @param self : object pointer
    # @return index of the equation
    def get_num_omc(self):
        return self.num_omc

    ##
    # Get the body of the function defining the equation
    # @param self : object pointer
    # @return : body of the function
    def get_body(self):
        return self.body_func

    ##
    # Get the raw body of the function defining the equation
    # @param self : object pointer
    # @return : raw body of the function
    def get_raw_body(self):
        return self.raw_body

    ##
    # Get the list of variables needed to define the equation
    # @param self : object pointer
    # @return list of variables
    def get_depend_vars(self):
        return self.depend_vars

    ##
    # get the name of the variable defined by the equation
    # @param self : object pointer
    # @return : name of the variable
    def get_evaluated_var(self):
        return self.evaluated_var

    ##
    # get the name of the variable defined by the equation
    # @param self : object pointer
    # @return : name of the variable (in the form data->localData[0]->...)
    def get_evaluated_var_address(self):
        return self.evaluated_var_address
    ##
    # Get if the equation use the 'throw' instruction
    # @param self: object pointer
    # @return @b True if the equation use the 'throw' instruction
    def with_throw(self):
        with_throw = False
        for line in self.body_func:
            if "throwStreamPrint" in line or "omc_assert_withEquationIndexes" in line or "omc_assert_warning_withEquationIndexes" in line:
                with_throw = True
        return with_throw

    ##
    # Prepare the body of the equation to be used when printing model
    # @param self : object pointer
    # @return
    def prepare_body_for_equation(self):
        """
        Cleaning the body of the function:
        - Remove "{" and "}" at the beginning and end of the function body
        """
        # Removing the opening and closing braces of the body
        self.body_func.pop(0)
        self.body_func.pop()

        # Remplacer "throwStreamPrintWithEquationIndexes(threadData, equationIndexes" par "throwStreamPrint(threadData"
        body_tmp = []
        for line in self.body_func:
            line_tmp = mmc_strings_len1(line)
            if "throwStream" in line_tmp:
                line_tmp = throw_stream_indexes(line_tmp)
            elif "threadData" in line_tmp:
                line_tmp=line_tmp.replace(THREAD_DATA_OMC_PARAM, "")
            if "omc_assert_warning" in line_tmp:
                line_tmp = line_tmp.replace(INFO_OMC_PARAM,"")
            body_tmp.append(line_tmp)
        self.body_func = body_tmp

        # see utils.py to see the list of tasks
        # done by make_various_treatments
        self.body_func = make_various_treatments( self.body_func )

    ##
    # create an equation thanks to the information stored
    # @param self : object pointer
    # @return a new equation
    def create_equation(self):
        return Equation(  self.body_func, \
                         self.evaluated_var, \
                         self.evaluated_var_address, \
                         self.get_depend_vars(), \
                         self.name, \
                         self.num_omc, \
                         self.type, \
                         self.complex_eq)


##
# base class for Equation declaration
#
class EquationBase:
    ##
    # default constructor
    # @param self : object pointer
    # @param body : body of the equation
    # @param eval_var : variable evaluated by the equation
    # @param evaluated_var_address : variable evaluated by the equation (in the form data->localData[0]->...)
    # @param depend_vars : variables used in the equation
    # @param comes_from : name of the function using the equation
    # @param num_omc : index of the equation in omc arrays
    def __init__(self, body = None, eval_var = None, evaluated_var_address = None, depend_vars = None, comes_from = None, num_omc = None, type = ALGEBRAIC, complex_eq = False):
        ## pattern to identify the variable evaluated
        self.ptrn_evaluated_var = re.compile(r'[\(]*data->localData(?P<var>\S*)[ ]*\/\*(?P<varName>[ \w\$\.()\[\],]*)\*\/[ \)]*[^=]=[^=][ ]*(?P<rhs>[^;]+);')
        ## pattern to identify the residual variable evaluated
        self.ptrn_residual_var = re.compile(r'[\(]*data->simulationInfo->daeModeData->residualVars\[(?P<residualIdx>[0-9]+)\][ \)]*/\*\s*(?P<varName>[ \w\$\.()\[\],]*) DAE_RESIDUAL_VAR\s*\*\/[\) ]*=[ ]*(?P<rhs>[^;]+);')

        ##  name of the function using the equation
        self.comes_from = ""
        ## variable evaluated by the equation
        self.evaluated_var = ""
        ## variable evaluated by the equation (in the form data->localData[0]->...)
        self.evaluated_var_address = ""
        ## variables used in the equation
        self.depend_vars = []
        ## index of the equation in omc arrays
        self.num_omc = ""
        ## index of the equation in dynawo arrays
        self.num_dyn = -1
        ## body of the equation
        self.body = []
        ## type of the equation (one of DIFFERENTIAL, ALGEBRAIC, MIXED)
        self.type = type
        ## whether this equation is complex or not
        self.complex_eq = complex_eq


        if body is not None:
            self.body = body
        if eval_var is not None:
            self.evaluated_var = eval_var
        if evaluated_var_address is not None:
            self.evaluated_var_address = evaluated_var_address
        if depend_vars is not None:
            self.depend_vars = depend_vars
        if comes_from is not None:
            self.comes_from = comes_from
        if num_omc is not None:
            self.num_omc = num_omc

    ##
    # Set the index of the equation in omc arrays
    # @param self : object pointer
    # @param index : index of the equation
    # @return
    def set_num_dyn(self, index):
        self.num_dyn = index

    ##
    # Get the index of the equation in omc arrays
    # @param self : object pointer
    # @return index of the equation
    def get_num_omc(self):
        return self.num_omc

    ##
    # Get the index of the equation in dynawo arrays
    # @param self : object pointer
    # @return index of the equation
    def get_num_dyn(self):
        return self.num_dyn

    ##
    # Get the name of the variable evaluated by the equation
    # @param self : object pointer
    # @return name of the variable
    def get_evaluated_var(self):
        return self.evaluated_var
    ##
    # Get the name of the variable evaluated by the equation
    # @param self : object pointer
    # @return name of the variable
    def get_evaluated_var_address(self):
        return self.evaluated_var_address
    ##
    # Get if the equation use the 'throw' instruction
    # @param self: object pointer
    # @return @b True if the equation use the 'throw' instruction
    def with_throw(self):
        with_throw = False
        for line in self.body:
            if "throwStreamPrint" in line or "omc_assert_withEquationIndexes" in line:
                with_throw = True

        return with_throw

    ##
    # Get the list of variables used in the equation
    # @param self: object pointer
    # @return list of variables
    def get_depend_vars(self):
        return self.depend_vars

    ##
    # Get the name of the function using the equation
    # @param self : object pointer
    # @return name of the function
    def get_src_fct_name(self):
       return self.comes_from

    ##
    # Check whether the current function is a reinit one
    # @param self : object pointer
    # @return whether it is a reinit function
    def get_is_modelica_reinit (self):
        return is_modelica_reinit_body (self.body)

    ##
    # Get the body of the equation as stored
    # @param self: object pointer
    # @return : body of the equation
    def get_body(self):
        return self.body

    ##
    # Get the raw body of the equation
    # @param self: object pointer
    # @return : raw body (as a text) of the equation
    def get_raw_body(self):
        text_to_return = ""
        for line in self.body : text_to_return += line
        return text_to_return

    ##
    # set the type of this equation (one of DIFFERENTIAL, ALGEBRAIC, MIXED)
    # @param self : object pointer
    # @param type new type of the equation
    def set_type(self, type):
        self.type = type

    ##
    # get the type of this equation
    # @param self : object pointer
    # @return the type of this equation
    def get_type(self):
        return self.type

##
# class Equation
#
class Equation(EquationBase):
    ##
    # default constructor
    # @param self : object pointer
    # @param body : body of the equation
    # @param eval_var : variable evaluated by the equation
    # @param evaluated_var_address : variable evaluated by the equation (in the form data->localData[0]->...)
    # @param depend_vars : variables used in the equation
    # @param comes_from : name of the function using the equation
    # @param num_omc : index of the equation in omc arrays
    def __init__(self, body = None, eval_var = None, evaluated_var_address = None, depend_vars = None, comes_from = None, num_omc = None, type = ALGEBRAIC, complex_eq = False):
        EquationBase.__init__(self, body, eval_var, evaluated_var_address, depend_vars, comes_from, num_omc, type, complex_eq)

    ##
    # retrieve the body formatted for Modelica reinit affectation
    # @param self : object pointer
    # @return the formatted body
    def get_body_for_modelica_reinit_affectation(self):
        return format_for_modelica_reinit_affectation (self.body)

    ##
    # retrieve the body formatted for evalMode
    # @param self : object pointer
    # @return the formatted body
    def get_body_for_evalmode(self):
        return format_for_modelica_reinit_evalmode (self.body)

    ##
    # Prepares the body of the equation to be used in setF function
    # @param self : object pointer
    # @return list of lines to print
    def get_body_for_setf(self):
        text_to_return = []

        with_throw = False
        for line in self.body:
            if "throwStreamPrint" in line:
                with_throw = True
                break
        index = self.get_num_dyn()
        for line in self.body:
            line = mmc_strings_len1(line)

            if has_omc_trace (line) or has_omc_equation_indexes (line) or ("infoStreamPrint" in line)\
                   or ("data->simulationInfo->needToIterate = 1") in line:
                continue
            if "omc_assert_warning" in line and with_throw:
                continue

            line = sub_division_sim(line)
            line = replace_relationhysteresis(line)

            if re.search(self.ptrn_residual_var, line) is not None:
                equality = self.ptrn_residual_var.sub(r'  f[%d] = data->simulationInfo->daeModeData->residualVars[\g<1>] /* \g<2> DAE_RESIDUAL_VAR */;' % self.get_num_dyn(), line)
                line = replace_var_names(line)
                equality = replace_var_names(equality)
                text_to_return.append( line )
                text_to_return.append( equality )
            elif re.search(self.ptrn_evaluated_var, line) is None:
                line = replace_var_names(line)
                text_to_return.append( line )
            else:
                line = replace_var_names(line)
                text_to_return.append( self.ptrn_evaluated_var.sub(r'f[%d] = data->localData\g<1> /* \g<2> */ - ( \g<3> );' % index, line) )
                if self.complex_eq:
                    index += 1
        return text_to_return

    ##
    # Prepares the body of the equation to be used in evalFAdept function
    # @param self : object pointer
    # @return list of lines to print
    def get_body_for_evalf_adept(self):
        text_to_return = []
        with_throw = False
        for line in self.body:
            if "throwStreamPrint" in line:
                with_throw = True
                break
        index = self.get_num_dyn()
        for line in self.body:
            line = mmc_strings_len1(line)
            line_tmp = transform_line_adept(line)

            if has_omc_trace (line_tmp) or has_omc_equation_indexes (line_tmp) or ("infoStreamPrint" in line_tmp)\
                   or ("data->simulationInfo->needToIterate = 1") in line_tmp:
                continue
            if "omc_assert_warning" in line_tmp and with_throw:
                continue

            line_tmp = sub_division_sim(line_tmp)
            if "delayImpl" in line_tmp:
                line_tmp = line_tmp.replace("delayImpl", "derDelayImpl")
            if re.search(self.ptrn_residual_var, line_tmp) is not None:
                text_to_return.append( self.ptrn_residual_var.sub(r'  res[%d] = \g<3>;' % self.get_num_dyn(), line_tmp) )
            elif re.search(self.ptrn_evaluated_var, line_tmp) is None:
                text_to_return.append( line_tmp )
            else:
                text_to_return.append( self.ptrn_evaluated_var.sub(r'res[%d] = data->localData\g<1> /* \g<2> */ - ( \g<3> );' % index, line_tmp) )
                if self.complex_eq:
                    index += 1
        return text_to_return

##
# class EquationBasedOnExternalCall
#
class EquationBasedOnExternalCall(Equation):
    ##
    # default constructor
    # @param self : object pointer
    # @param body : body of the equation
    # @param function_name : name of the function used in this equation
    # @param eval_var : variable evaluated by the equation
    # @param evaluated_var_address : variable evaluated by the equation (in the form data->localData[0]->...)
    # @param depend_vars : variables used in the equation
    # @param comes_from : name of the function using the equation
    # @param num_omc : index of the equation in omc arrays
    def __init__(self, function_name, body = None, eval_var = None, evaluated_var_address = None, depend_vars = None, comes_from = None, num_omc = None):
        Equation.__init__(self, body, eval_var, evaluated_var_address, depend_vars, comes_from, num_omc)
        self.function_name = function_name

    ##
    # get the name of the function used in this equation
    # @param self : object pointer
    # @return the name of the function used in this equation
    def get_function_name(self):
        return self.function_name

##
# class Root Object: defining a when equation
#
class RootObject:
    ##
    # default constructor
    # @param self: object pointer
    # @param when_var_name : name of the when variable
    def __init__(self, when_var_name = None):
        ## name of the when variable
        self.when_var_name = ""

        ## body of the function evaluating the when condition
        self.body_for_num_relation = []
        ## index of the object in dynawo arrays
        self.num_dyn = -1

        ## index of the relation
        self.num_relation = "-1"

        ## Condition to evaluate for the when equation
        self.condition = ""

        ## Equations to evaluate if the condition is true
        self.blocks_when_cond_is_true = []

        ## true only if this root is also present in the zero crossings detected by OpenModelica
        self.duplicated_in_zero_crossing = False

        if when_var_name is not None:
            self.when_var_name = when_var_name

    ##
    # Get the name of the when variable
    # @param self : object pointer
    # @return name of the when variable
    def get_when_var_name(self):
        return self.when_var_name

    ##
    # Get the index of the object in dynawo arrays
    # @param self : object pointer
    # @return index of the object
    def get_num_dyn(self):
        return self.num_dyn

    ##
    # Get the index of the relation
    # @param self: object pointer
    # @return index of the relation
    def get_num_relation(self):
        return self.num_relation

    ##
    # get the condition evaluated in the when equation
    # @param self: object pointer
    # @return condition evaluated
    def get_condition(self):
        return self.condition

    ##
    # Get the body evaluated when the condition is true
    # @param self: object pointer
    # @return list of code to evaluate
    def get_blocks_when_cond_is_true(self):
        return self.blocks_when_cond_is_true

    ##
    # Set the body of the function evaluating the when condition
    # @param self : object pointer
    # @param body : body of the function
    # @return
    def set_body_for_num_relation(self, body):
        self.body_for_num_relation = body

    ##
    # Get the body of the function evaluating the when condition
    # @param self : object pointer
    # @return : body of the function
    def get_body_for_num_relation(self):
        return self.body_for_num_relation

    ##
    # Set the property duplicated_in_zero_crossing
    # @param self : object pointer
    # @param duplicated_in_zero_crossing : true only if if this root is also present in the zero crossings detected by OpenModelica
    # @return
    def set_duplicated_in_zero_crossing(self, duplicated_in_zero_crossing):
        self.duplicated_in_zero_crossing = duplicated_in_zero_crossing

    ##
    # Get the property duplicated_in_zero_crossing
    # @param self : object pointer
    # @return : true only if this root is also present in the zero crossings detected by OpenModelica
    def get_duplicated_in_zero_crossing(self):
        return self.duplicated_in_zero_crossing

    ##
    # Prepare the body of the object to be print
    # @param self : object pointer
    # @return
    def prepare_body(self):
        # cleaning the block, removing the start and end braces
        new_body = []
        i = 0
        double_equality_prtn = re.compile(r'\(data->localData\[0\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*\*\/ == data->localData\[0\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*\*\/\)')
        for line in self.body_for_num_relation:
            line = replace_var_names(line)
            line = replace_relationhysteresis(line)
            line = throw_stream_indexes(line)
            if i == 0 or i == len(self.body_for_num_relation)-1:
                i = i + 1
                continue
            if not has_omc_trace (line) and not has_omc_equation_indexes (line):
                line = sub_division_sim(line)
                line = line.replace('threadData,','')
                found = re.search(double_equality_prtn, line)
                if found is not None:
                    test = "DYN::doubleEquals" + found.group(0).replace (" == ", ",")
                    line = line.replace(found.group(0), test)
                new_body.append(line)
            i = i + 1
        self.body_for_num_relation = new_body


    ##
    # Filter the when condition in the bodies
    # @param self : object pointer
    # @param list_func_bodies : body to filter
    # @return
    def filter_when_cond_blocks(self, list_func_bodies):
        for body in list_func_bodies:
            block_to_extract = extract_block(body, ["if(", self.when_var_name])
            # I nothing is found in the body None is returned.
            if block_to_extract is not None :

                # Clean and replace....
                block_cleaned = []
                for line in block_to_extract:
                    line_cleaned = line.replace("time", "get_manager_time()")
                    block_cleaned.append(line_cleaned)

                self.blocks_when_cond_is_true.append(  block_cleaned  )


    ##
    # Set the index of the object in dynawo arrays
    # @param self : object pointer
    # @param num : index of the object
    # @return
    def set_num_dyn(self, num):
       self.num_dyn = num

    ##
    # Set the condition of the when equation
    # @param self: object pointer
    # @param cond : condition of the when equation
    # @return
    def set_condition(self, cond):
        self.condition = cond

        # We remove "time" by "get_manager_time()"
        self.condition = self.condition.replace("time", "get_manager_time()")

        # We remove ";"
        self.condition = self.condition.replace(";", "")

##
# class INT Equation : definition of an affectation of an integer
#
class INTEquation:
    ##
    # default constructor
    # @param self : object pointer
    # @param name : name of the equation
    def __init__(self,name):
        ## body defining the equation
        self.body=[]
        ## name of the equation
        self.name = name

    ##
    # Set the body of the equation
    # @param self: object pointer
    # @param body : body of the equation
    # @return
    def set_body(self,body):
        self.body = body

    ##
    # Get the body of the equation
    # @param self : object pointer
    # @return body of the equation
    def get_body(self):
        return self.body

    ##
    # Get the name of the equation
    # @param self: object pointer
    # @return name of the equation
    def get_name(self):
        return self.name


    ##
    # Prepare the body of the equation to be print
    # @param self : object pointer
    # @return
    def prepare_body(self):
        tmp_body=[]
        for line in self.body:
            line = transform_line(line)
            line = throw_stream_indexes(line)
            if not has_omc_equation_indexes (line):
                if THREAD_DATA_OMC_PARAM in line:
                    line=line.replace(THREAD_DATA_OMC_PARAM, "")
                    tmp_body.append(line)
                    #removing of clean ifdef
                elif HASHTAG_IFDEF not in line and HASHTAG_ENDIF not in line \
                     and "SIM_PROF_" not in line and "NORETCALL" not in line \
                     and not has_omc_trace (line):
                    tmp_body.append(line)

        self.body = tmp_body


##
# class Z Equation : definition of discrete variables
#
class ZEquation:
    ##
    # default constructor
    # @param self : object pointer
    # @param name : name of the equation
    def __init__(self,name):
        ## body defining the equation
        self.body=[]
        ## name of the equation
        self.name= name

    ##
    # Set the body of the equation
    # @param self: object pointer
    # @param body : body of the equation
    # @return
    def set_body(self,body):
        self.body = body

    ##
    # Get the body of the equation
    # @param self : object pointer
    # @return body of the equation
    def get_body(self):
        return self.body

    ##
    # Get the name of the equation
    # @param self: object pointer
    # @return name of the equation
    def get_name(self):
        return self.name

    ##
    # Prepare the body of the equation to be print
    # @param self : object pointer
    # @return
    def prepare_body(self):
        tmp_body=[]
        for line in self.body:
            line = transform_line(line)
            line = throw_stream_indexes(line)
            if not has_omc_equation_indexes (line):
                if THREAD_DATA_OMC_PARAM in line:
                    line=line.replace(THREAD_DATA_OMC_PARAM, "")
                    tmp_body.append(line)
                    #removing of clean ifdef
                elif HASHTAG_IFDEF not in line and HASHTAG_ENDIF not in line \
                     and "SIM_PROF_" not in line and "NORETCALL" not in line \
                     and not has_omc_trace (line):
                    tmp_body.append(line)

        self.body = tmp_body

##
# class Warn : definition of a warning/assert in equation
#
class Warn:
    ##
    # default constructor
    # @param self : object pointer
    # @param body : body of the warning
    def __init__(self,body):
        ## body of the warning
        self.body=body
        ## body prepared for the setF function
        self.body_for_setf=[]
        ## True if this warning test a parameter value
        self.is_parameter_warning = False

    ##
    # Prepare the body of the equation to be print
    # @param self : object pointer
    # @return
    def prepare_body(self):
        tmp_body = []
        # remove the start and end braces
        with_throw = False
        with_variable= False
        for line in self.body:
            if "throwStreamPrint" in line:
                with_throw = True
            if "data->localData[0]->" in line.replace("data->localData[0]->timeValue", ""):
                with_variable = True

        self.is_parameter_warning = not with_variable

        equality_prtn = re.compile(r'\(data->localData\[0\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*\*\/[\)]* = .*;')

        #################
        for line in self.body:
            line = throw_stream_indexes(line)
            line = mmc_strings_len1(line)
            line = line.replace("MMC_STRINGDATA","")
            line = replace_var_names(line)
            line = line.replace("threadData, ","")
            line = sub_division_sim(line)
            if re.search(equality_prtn, line) is not None:
                continue
            if "omc_assert_warning" in line and not with_throw:
                line = line.replace(INFO_OMC_PARAM,"")
            if has_omc_trace (line) or has_omc_equation_indexes (line) or "infoStreamPrint" in line:
                continue
            elif "MMC_DEFSTRINGLIT" in line:
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
                tmp_body.append(line_tmp)
            elif "MMC_REFSTRINGLIT" in line:
                line = line.replace("MMC_REFSTRINGLIT","")
                tmp_body.append(line)
            elif OMC_METATYPE_TMPMETA in line:
                tmp_body.append(replace_modelica_strings(line))
            elif "FILE_INFO info" in line:
                continue;
            elif "omc_assert_warning" in line:
                if not with_throw:
                    tmp_body.append(line)
            else:
                tmp_body.append(line)

        self.body_for_setf=tmp_body

    ##
    # Get the body to print in setF function
    # @param self : object pointer
    # @return body to print in setF
    def get_body_for_setf(self):
        return self.body_for_setf

    ##
    # Get whether this warning tests a parameter
    # @param self : object pointer
    # @return True if this warning tests a parameter, False otherwise
    def get_is_parameter_warning(self):
        return self.is_parameter_warning


##
# Class Modes: used to store all information related to mode change conditions
##
class Modes:
    def __init__(self):
        self.body_for_tmps = []
        self.body_for_tmps_created_relations = []
        self.relations = []
        self.created_relations = []
        self.equations_2_create_relation_index = {}
        self.modes_discretes = {}

    ##
    # Add a line to the body necessary to define and assign values for auxiliary tmps
    # @param self : object pointer
    # @param line : line to add to the body for tmps
    def add_to_body_for_tmps(self, line):
        self.body_for_tmps.append(line)

    ##
    # Add a line to the body necessary to define and assign values for auxiliary tmps for created relations
    # @param self : object pointer
    # @param line : line to add to the body for tmps associated to created relations
    def add_to_body_for_tmps_created_relations(self, line):
        self.body_for_tmps_created_relations.append(line)

    ##
    # Add a relation to the list of relations
    # @param self : object pointer
    # @param relation  :relation to add
    def add_relation(self, relation):
        self.relations.append(relation)

    ##
    # Add a created relation to the list of the created relations
    # @param self : object pointer
    # @param created_relation : created relation to add
    def add_created_relation(self, created_relation):
        self.created_relations.append(created_relation)

    ##
    # Retrieve the created relation index associated to a equation
    # @param self : object pointer
    # @param eq : equation function name
    def find_index_relation(self, eq):
        result = []
        for rel in self.created_relations:
            if eq in rel.eqs:
                result.append(rel.index)
        return result

    ##
    # Get the body for the evalg for tmps
    # @param self : object pointer
    # @return body to print for evalg for tmps
    def get_body_for_evalg_tmps(self):
        text_to_return = []
        for line in self.body_for_tmps_created_relations:
            text_to_return.append(line)
        for relation in self.created_relations:
            text_to_return.append(relation.body_definition)
        text_to_return.append("\n")
        return text_to_return

    ##
    # Get the body for the evalg assignments for tmps
    # @param self : object pointer
    # @param index : index of the g equation
    # @return body for evalg assignments
    def get_body_for_evalg_assignments(self, index):
        text_to_return = []
        for relation in self.created_relations:
            text_to_return.append("  gout[" + str(index) + "] = (data->simulationInfo->relations[" + str(relation.index) + "] != data->simulationInfo->relationsPre[" + str(relation.index) + "]) ? ROOT_UP : ROOT_DOWN;\n")
            index += 1
        return text_to_return

    ##
    # Get the body for the setgequations
    # @param self : object pointer
    # @param index : index of the g equation
    # @return the body to print for setgequations
    def get_body_for_setgequations(self, index):
        text_to_return = []
        for relation in self.created_relations:
            gequation = "Zero crossing for condition change in relation " + str(relation.index) + ": " + relation.condition
            text_to_return.append('  gEquationIndex[' + str(index) + '] = "' + gequation + '";\n')
            index += 1
        return text_to_return

    ##
    # Get the body for the evalmode
    # @param self : object pointer
    # @return body to print for evalmode
    def get_body_for_evalmode(self):
        text_to_return = []
        body_tmps = self.body_for_tmps + self.body_for_tmps_created_relations
        for line in body_tmps:
            text_to_return.append(line)
        text_to_return.append("\n")
        relations = self.relations + self.created_relations
        for relation in relations:
            for eq in relation.eqs:
                text_to_return.append("  // ----- Mode for " + str(eq) + " --------- \n")
            text_to_return.append(relation.body_definition)
            text_to_return.append("  if (data->simulationInfo->relations[" + str(relation.index) + "] != data->simulationInfo->relationsPre[" + str(relation.index) + "]) \n")
            text_to_return.append("  {\n")
            if relation.type == MIXED:
                text_to_return.append("    modeChangeType = ALGEBRAIC_J_UPDATE_MODE;\n")
            elif relation.type == DIFFERENTIAL:
                text_to_return.append("    if (modeChangeType == NO_MODE)\n")
                text_to_return.append("      modeChangeType = DIFFERENTIAL_MODE;\n")
            elif relation.type == ALGEBRAIC:
                text_to_return.append("    if (modeChangeType == NO_MODE || modeChangeType == DIFFERENTIAL_MODE)\n")
                text_to_return.append("      modeChangeType = ALGEBRAIC_MODE;\n")
            else:
                print("Mode not handled")
            text_to_return.append("  }\n")
            text_to_return.append("\n")
        list_keys = list (self.modes_discretes)
        list_keys.sort()
        for z in list_keys:
            discrete_mode = self.modes_discretes[z]
            for eq in discrete_mode.eqs:
                text_to_return.append("  // ----- Mode for " + str(eq) + " --------- \n")
            test_param_address(z)
            z_aff = to_param_address(z)
            z_pre = z_aff.replace("localData[0]->discreteVars", "simulationInfo->discreteVarsPre")
            z_pre = z_pre.replace("localData[0]->integerDoubleVars", "simulationInfo->integerDoubleVarsPre")
            if z_aff == z_pre: continue
            text_to_return.append("  // " + z + " != pre(" +z+")\n")
            text_to_return.append("  if (doubleNotEquals(" + z_aff + ", " + z_pre +")) {\n")
            if discrete_mode.type == ALGEBRAIC:
                if discrete_mode.boolean == False:
                    text_to_return.append("      modeChangeType = ALGEBRAIC_MODE;\n")
                else:
                    text_to_return.append("    return ALGEBRAIC_J_UPDATE_MODE;\n")
            else:
                text_to_return.append("    if (modeChangeType == NO_MODE)\n")
                text_to_return.append("      modeChangeType = DIFFERENTIAL_MODE;\n")
            text_to_return.append("  }\n\n")
        return text_to_return

##
#  class ModeDiscrete : use to store specific information for mode change related to discrete variable changes
##
class ModeDiscrete:
    def __init__(self, type, boolean):
        self.type = type
        self.boolean = boolean
        self.eqs = []

    ##
    # Set the type of influenced equation
    # @param self : object pointer
    # @param type : discrete mode type
    def set_type(self, type):
        self.type = type

    ##
    # Add an equation to the list of equations influenced by the discrete variable change
    # @param self : object pointer
    # @param eq : equation to add
    def add_eq(self, eq):
        self.eqs.append(eq)

##
#  class Relation : use to store specific information for mode change related to a relation
##
class Relation:
    def __init__(self, index, type):
        self.index = index
        self.type = type
        self.eqs = []
        self.body_definition = []
        self.condition = ""

    ##
    # Add an equation to the list of equations influenced by the relation change
    # @param self : object pointer
    # @param eq_to_add : equation to add
    def add_eq(self, eq_to_add):
        self.eqs.append(eq_to_add)

    ##
    # Set body definition for the relation
    # @param self : object pointer
    # @param body_definition : body_definition to add
    def set_body_definition(self, body_definition):
        self.body_definition = body_definition

    ##
    # Set the type of equation influenced
    # @param self : object pointer
    # @param type : type of equation influenced
    def set_type(self, type):
        self.type = type

    ##
    # Set the condition and replace the end line symbol as well as useless whitespaces
    # @param self : object pointer
    # @param condition : condition to set
    def set_condition(self, condition):
        self.condition = condition.replace("\n","").replace("  ","")
