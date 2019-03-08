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

import re
import sys
import copy

from utils import *


################################
### Variables ##################
################################

"""
Filter variables. To use in argument of the primitive "filter" for example .
"""
##
# Check whether the variable is a variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a variable of the system
def isSystVar(var):
    # if it's a var $dummy for omc, it does not count
    name_var = var.getName()
    if "$dummy" in name_var : return False

    type_var = var.getType()
    variability = var.getVariability()

    right_var_type = (type_var in ["rSta", "rAlg"])
    is_continuous = (variability == "continuous")
    within_system = True

    return is_continuous and right_var_type and within_system

##
# Check whether the variable is a variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a variable of the system
def isVar(var):
    # if it's a var $dummy for omc, it does not count
    name_var = var.getName()
    if "$dummy" in name_var : return False

    type_var = var.getType()
    variability = var.getVariability()
    # iAlg is for Integer variable
    right_var_type = (type_var in ["rSta", "rAlg", "rAli", "iAlg", "bAlg"])
    is_continuous = (variability in ["continuous","discrete"])
    within_system = True

    return is_continuous and right_var_type and within_system

##
# Check whether the variable is an algebraic variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a algebraic variable of the system
def isAlgVar(var):
    type_var = var.getType()
    variability = var.getVariability()

    right_var_type = (type_var in ["rAlg"])
    is_continuous = (variability == "continuous")
    within_system = True

    return is_continuous and right_var_type and within_system

##
# Check whether the variable is a discrete variable of the system or not
# @param var : variable to test
# @return @b True if the variable is a discrete variable of the system
def isDiscreteRealVar(var):
    type_var = var.getType()
    variability = var.getVariability()
    return variability == "discrete" and type_var == "rAlg"

##
# Check whether the variable is an integer variable of the system or not
# @param var : variable to test
# @return @b True if the variable is an integer variable of the system
def isIntegerVar(var):
    type_var = var.getType()
    variability = var.getVariability()
    return variability == "discrete" and type_var == "iAlg"

EXTERNAL_PARAMETER, SHARED_PARAMETER, INTERNAL_PARAMETER = range(3)

##
# describe the scope of a given parameter
# @param par : parameter to test
# @return the parameter scope
def paramScope(par):
    if isParamWithPrivateEquation (par):
        return INTERNAL_PARAMETER
    elif isParamInternal(par):
        return SHARED_PARAMETER
    else:
        return EXTERNAL_PARAMETER

def paramScopeStr (par_scope):
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
def isParamBool(par):
    type_var = par.getType()
    return type_var == "bPar"

##
# Check whether the parameter is an external boolean parameter
# @param par : parameter to test
# @return @b True if the parameter is an external boolean parameter
def isParamExtBool(par):
    internal = par.getInternal()
    use_start = par.getUseStart()
    return isParamBool(par) and not internal and not use_start

##
# Check whether the parameter is an internal boolean parameter
# @param par : parameter to test
# @return @b True if the parameter is an internal boolean parameter
def isParamInternalBool(par):
    return isParamBool(par) and not isParamExtBool(par)

##
# Check whether the parameter is an integer parameter
# @param par : parameter to test
# @return @b True if the parameter is an integer parameter
def isParamInteger(par):
    type_var = par.getType()
    return type_var == "iPar"

##
# Check whether the parameter is an external integer parameter
# @param par : parameter to test
# @return @b True if the parameter is an external integer parameter
def isParamExtInteger(par):
    internal = par.getInternal()
    use_start = par.getUseStart()
    return isParamInteger(par) and not internal and not use_start

##
# Check whether the parameter is an internal integer parameter
# @param par : parameter to test
# @return @b True if the parameter is an internal integer parameter
def isParamInternalInteger(par):
    return isParamInteger(par) and not isParamExtInteger(par)


##
# Check whether the parameter is a string parameter
# @param par : parameter to test
# @return @b True if the parameter is a string parameter
def isParamString(par):
    type_var = par.getType()
    return type_var == "sPar"

##
# Check whether the parameter is an external string parameter
# @param par : parameter to test
# @return @b True if the parameter is an external string parameter
def isParamExtString(par):
    start_text = par.getStartText()[0]
    return isParamString(par) and start_text == ""

##
# Check whether the parameter is an internal string parameter
# @param par : parameter to test
# @return @b True if the parameter is an internal string parameter
def isParamInternalString(par):
    return isParamString(par) and not isParamExtString(par)

##
# Check whether the parameter is a real parameter
# @param par : parameter to test
# @return @b True if the parameter is a real parameter
def isParamReal(par):
    type_var = par.getType()
    return type_var == "rPar"

##
# Check whether the parameter is an external real parameter
# @param par : parameter to test
# @return @b True if the parameter is an external real parameter
def isParamExtReal(par):
    internal = par.getInternal()
    init_by_init_extend = par.getInitByExtendIn06Inz()
    use_start = par.getUseStart()
    return isParamReal(par) and not internal and not init_by_init_extend and not use_start


##
# Check whether the parameter is an internal real parameter
# @param par : parameter to test
# @return @b True if the parameter is an internal real parameter
def isParamInternalReal(par):
    return isParamReal(par) and not isParamExtReal(par)

##
# a parameter is considered internal if and only if it is set by a (system of) equation
def isParamInternal(par):
    return isParamInternalInteger(par) or isParamInternalBool(par) or isParamInternalString(par) or isParamInternalReal(par)

def isParamWithPrivateEquation(par):
    return par.getInitByParam() or par.getInitByParamIn06Inz()

##
# Check whether the variable is a boolean variable
# @param var : variable to test
# @return @b True if the variable is a boolean variable
def isBoolVar(var):
    type_var = var.getType()
    return type_var == "bAlg"

##
# Check whether the variable is derivative variable
# @param var : variable to test
# @return @b True if the variable is a derivative variable
def isDerRealVar(var):
    # if it's a var $dummy for omc, it does not count
    name_var = var.getName()
    if "$dummy" in name_var : return False

    type_var = var.getType()
    return type_var == "rDer"

##
# Check if the variable has an alias
# @param var : variable to test
# @return @b True if the variable has an alias
def hasAlias(var):
    alias = var.getAliasName()
    return alias != ""

##
# Check if the variable has an actual name (real name or alias)
# @param var : variable to test
# @return @b True if the variable has an actual name
def hasActualName(var):
    return var.getActualName() != ""

##
# Check if the variable is an alias
# @param var : variable to test
# @return @b True if the variable is an alias
def isAlias(var):
    return hasActualName(var)

##
# Check if the variable is a variable used to define a when equation
# @param var : variable to test
# @return @b True if the variable is used to define a when equation
def isWhenVar(var):
    return isBoolVar(var) and ("$whenCondition" in var.getName())

##
# Check if the variable is a dummy variable
# @param var : variable to test
# @return @b True if the variable is a dummy variable
def isDummyVar(var):
    return "$dummy" in var.getName() and "der(" not in var.getName()

##
# Compare two variables thanks to their index in omc arrays
# @param var1 : first variable to compare
# @param var2 : second variable to compare
# @return 1 if var1 > var2, 0 if var1 = var2, -1 otherwise
def cmp_numOmc_vars(var1, var2):
    num_omc1, num_omc2 = int(var1.getNumOmc()), int(var2.getNumOmc())
    if num_omc1 > num_omc2: res = 1
    elif num_omc1 < num_omc2: res = -1
    else: res = 0
    return res

##
# Compare two variables thanks to the way they are initialised
# @param var1 : first variable to compare
# @param var2 : second variable to compare
# @return 1 if var1 should be before var2, 0 if they should have the same index, -1 otherwise
def cmp_numInit_vars(var1, var2):
    """
    Compare 2 vars with crietria
       1. fixed by extends or parameter
       2. init function number read in *_06inz.c
    """

    extend1, extend2 = var1.getInitByExtendIn06Inz(), var2.getInitByExtendIn06Inz()
    if extend1 and (not extend2) : return 1
    elif (not extend1) and extend2 : return -1

    num1, num2 = int(var1.getNumFunc06Inz()), int(var2.getNumFunc06Inz())
    if num1 > num2 : return 1
    elif num1 < num2 : return -1

    # both elements have the same index
    return 0

##
# Variable class : store data to each variable read
#
class variable:
    ##
    # default constructor
    def __init__(self):

        ## name of the variable
        self.name = ""

        ## Name of the true variable
        self.actualName = ""

        ## Name of the alias of this variable
        self.aliasName = ""
        ## @b true if the alias value is the opposite of the variable value
        self.aliasNegated = False
        ## causality of the variable : output/internal
        self.causality = ""
        ## variability of the variable : "parameter", "continuous", "discrete"
        self.variability = ""
        ## is the variable initialize thanks to a parameter
        self.initByParam = False
        ## is the variable initialize thanks to a parameter in the 06Inz file
        self.initByParamIn06Inz = False
        ## is the variable initialize thanks to an extend in the 06Inz file
        self.initByExtendIn06Inz = False
        ## Should we use the start value to initialize the variable
        self.useStart = False

        # "bAlg" (var alg bool), "rAlg" (var alg reelle), "rSta" (real state variable),
        # "rDer" (var diff reelle), "rPar" (param reel), "rAli" (real state variable with an alias)
        ## type of the variable
        self.type = ""

        ## Dynamic type of the variable : CONTINUOUS, DISCRETE, FLOW
        self.dynType = ""

        ## Start text declared in 06inz file to initialize the variable
        self.startText06Inz = []
        ## Start text declared in 08bnd file to initialize the variable
        self.startText = [""]
        ## Is the initial value of the variable declared in the mo file
        self.internal = False
        ## index of the output in dynawo
        self.numDynOutput = -1

        ## Name of the variable used in dynawo sources (x[i],xd[i],z[i],rpar[i])
        self.dynawoName = ""
        ## Index of the variable in omc arrays
        self.numOmc = -1
        ## Index of the init function in 06Inz file
        self.numFunc06Inz = -1


    ##
    # Set the name of the variable
    # @param self : object pointer
    # @param name : name of the variable
    # @return
    def setName(self, name):
       self.name = name

    ##
    # Set the actual name of the variable
    # @param self : object pointer
    # @param name : actual name of the variable
    # @return
    def setActualName(self, name):
       self.actualName = name

    ##
    # Set the alias name of the variable and if this alias is the opposite of the true variable
    # @param self : object pointer
    # @param name : name of the alias
    # @param negated : @b True is this alias is the opposite of the true variable
    # @return
    def setAliasName(self, name, negated):
       self.aliasName = name
       self.aliasNegated = negated

    ##
    # Set the variability (parameter/continuous/discrete) of the variable
    # @param self : object pointer
    # @param variability : variability of the variable
    # @return
    def setVariability(self, variability):
       self.variability = variability
    ##
    # Set if the variable is initialized by a parameter
    # @param self : object pointer
    # @param bool : @b True is the variable is initialized by a parameter
    # @return
    def setInitByParam(self, bool):
        self.initByParam = bool

    ##
    # Set if the variable is initialized by a parameter in the file 06inz
    # @param self : object pointer
    # @param bool : @b True is the variable is initialized by a parameter in th file 06inz
    # @return
    def setInitByParamIn06Inz(self, bool):
        self.initByParamIn06Inz = bool

    ##
    # Set if the variable is initialized by an extend in the file 06inz
    # @param self : object pointer
    # @param bool : @b True is the variable is initialized by an extend in th file 06inz
    # @return
    def setInitByExtendIn06Inz(self, bool):
        self.initByExtendIn06Inz = bool

    ##
    # Set the causality of the variable (output/internal)
    # @param self : object pointer
    # @param causality: causality of the variable
    # @return
    def setCausality(self, causality):
        self.causality = causality

    ##
    # Set the type of the variable (bAlg,rAlg,...)
    # @param self : object pointer
    # @param type : type of the variable
    # @return
    def setType(self, type):
        self.type = type

    ##
    # Set the dynamic type of the variable (continuous/discrete/flow)
    # @param self : object pointer
    # @return
    def setDynType(self):
        if self.getType()[0] == "r":
            self.dynType = "CONTINUOUS"
        elif self.getType()[0] == "i":
            self.dynType = "INTEGER"
        elif self.getType()[0] == "b":
            self.dynType = "BOOLEAN"
        elif self.getType()[0] == "s":
            self.dynType = "STRING"
    ##
    # Set the dynamic type of the variable to be discrete
    # @param self: object pointer
    # @return
    def setDiscreteDynType(self):
        self.dynType = "DISCRETE"

    ##
    # Set the dynamic type of the variable to be flow
    # @param self: object pointer
    # @return
    def setFlowDynType(self):
        self.dynType = "FLOW"
    ##
    # Set the list of lines used to initialize the variable in 06inz file
    # @param self : object pointer
    # @param start_text : list of lines
    # @return
    def setStartText06Inz(self, start_text):
        self.startText06Inz = start_text

    ##
    # Set the list of lines used to initialize the variable in 08bnd file
    # @param self : object pointer
    # @param start_text : list of lines
    # @return
    def setStartText(self, start_text):
        self.startText = start_text

    ##
    # Set if the initial value is set in the mo file
    # @param self : object pointer
    # @param internal : @b true if the initial value is set in the mo file
    # @return
    def setInternal(self, internal):
        self.internal = internal

    ##
    # Set the output index of the variable
    # @param self : object pointer
    # @param num_dyn : output index
    # @return
    def setNumDynOutput(self, num_dyn):
        self.numDynOutput = num_dyn

    ##
    # Set the name of the variable to use in Dynawo (x[i], xd[i], z[i], rpar[i])
    # @param self : object pointer
    # @param name : dynawo name of the variable
    # @return
    def setDynawoName(self, name):
        self.dynawoName = name

    ##
    # Set the index of the variable in omc arrays
    # @param self : object pointer
    # @param num_omc : variable's index
    # @return
    def setNumOmc(self, num_omc):
        self.numOmc = num_omc

    ##
    # Set the index of the function used to initialize the variable in the 06inz file
    # @param self : object pointer
    # @param num_func06_inz : index of the function
    # @return
    def setNumFunc06Inz(self, num_func06_inz):
        self.numFunc06Inz = num_func06_inz

    ##
    # Set if the initial value should be used
    # @param self : object pointer
    # @param use_start : @b true if the initial value should be used
    # @return
    def setUseStart(self, use_start):
        self.useStart = use_start != "false"

    ##
    # Get the name of the variable
    # @param self : object pointer
    # @return : name of the variable
    def getName(self):
       return self.name

    ##
    # Get the actual name of the variable
    # @param self : object pointer
    # @return actual name of the variable
    def getActualName(self):
       return self.actualName

    ##
    # Get the alias name of the variable
    # @param self : object pointer
    # @return the alias name of the variable
    def getAliasName(self):
       return self.aliasName

    ##
    # Get if this alias is the opposite of the true variable
    # @param self : object pointer
    # @return @b true is the alias is the opposite of the true variable
    def getAliasNegated(self):
       return self.aliasNegated

    ##
    # Get the name used in dynawo to identify the variable
    # @param self : object pointer
    # @return the dynawo's name of the variable
    def getDynawoName(self):
        return self.dynawoName

    ##
    # get the variability of the variable
    # @param self : object pointer
    # @return the variability of the variable
    def getVariability(self):
       return self.variability

    ##
    # Get if the variable is initialized thanks to a parameter
    # @param self : object pointer
    # @return @b true if the variable is initialized thanks to a parameter
    def getInitByParam(self):
        return self.initByParam

    ##
    # Get if the variable is initialized thanks to a parameter in 06inz file
    # @param self : object pointer
    # @return @b true if the variable is initialized thanks to a parameter in 06inz file
    def getInitByParamIn06Inz(self):
        return self.initByParamIn06Inz

    ##
    # Get if the variable is initialized thanks to an extend in 06inz file
    # @param self : object pointer
    # @return @b true if the variable is initialized thanks to an extend in 06inz file
    def getInitByExtendIn06Inz(self):
        return self.initByExtendIn06Inz

    ##
    # Get the causality of a variable
    # @param self : object pointer
    # @return the causality of the variable
    def getCausality(self):
       return self.causality

    ##
    # Get the type of a variable
    # @param self : object pointer
    # @return the type of the variable
    def getType(self):
       return self.type

    ##
    # Get the C type of a variable
    # @param self : object pointer
    # @return the C type of the variable value
    def getValueTypeC(self):
        if (isParamReal(self)):
            return "double"
        elif (isParamInteger(self)):
            return "int"
        elif (isParamString(self)):
            return "string"
        elif (isParamBool(self)):
            return "bool"

    ##
    # Get the Modelica C type of a variable
    # @param self : object pointer
    # @return the C type of the variable value used in the transcripted Modelica -> C code
    def getValueTypeModelicaCCode (self):
        if (isParamReal(self)):
            return "double"
        elif (isParamInteger(self)):
            return "int"
        elif (isParamString(self)):
            return "string"
        elif (isParamBool(self)):
            return "modelica_real"

    ##
    # Get the dynamic type of a variable
    # @param self : object pointer
    # @return the dynamic type of the variable
    def getDynType(self):
       return self.dynType

    ##
    # Get the start text used to initialized a variable
    # @param self : object pointer
    # @return the start text used to initialized the variable
    def getStartText(self):
        return self.startText

    ##
    # Get the start text used to initialized the variable in 06inz file
    # @param self : object pointer
    # @return the start text used to initialized the variable in 06inz file
    def getStartText06Inz(self):
        return self.startText06Inz

    ##
    # Get if the initial value of the variable is defined in the mo file
    # @param self : object pointer
    # @return the initial value of the variable
    def getInternal(self):
       return self.internal

    ##
    # Get the output index of the variable
    # @param self : object pointer
    # @return the output index
    def getNumDynOutput(self):
       return self.numDynOutput

    ##
    # Get the index of the variable in omc arrays
    # @param self : object pointer
    # @return the index in omc arrays
    def getNumOmc(self):
       return self.numOmc

    ##
    # Get the index of the function used in 06inz file to initialize the variable
    # @param self : object pointer
    # @return the index of the function
    def getNumFunc06Inz(self):
        return self.numFunc06Inz

    ##
    # Get if the start text should be used to  initialize the variable
    # @param self : object pointer
    # @return @b true if the start text should be used
    def getUseStart(self):
        return self.useStart

    ##
    # Erase some part of the start text : {/} at the begin/end of the body
    # Replace some macro created by omc (DIVISION(a1,a2,a3) => a1/a2 ...
    # @param self : object pointer
    # @return
    def cleanStartText(self):
        # Removing the opening and closing braces of the body
        self.startText.pop(0)
        self.startText.pop()

        # Replace DIVISION_SIM(a1,a2,a3,a4) ==> a1 / a2
        # Difficult to do this with a regex and a sub, so we use
        # the function "subDivisionSIM()" (see utils.py)


        txt_tmp = []
        for line in self.startText:
            if has_Omc_trace (line) or has_Omc_equationIndexes (line):
                continue

            line_tmp = subDivisionSIM(line) # hard to process using a regex
            line_tmp = throwStreamIndexes(line_tmp)

            # in case the parameter is initialized by an external function
            # if "threadData" in line_tmp:
            #     line_tmp=line_tmp.replace("threadData", "data->threadData")
            #     txt_tmp.append(line_tmp)
            if "threadData" in line:
                line=line.replace("threadData,", "")
                txt_tmp.append(line)
            elif "#ifdef" not in line_tmp and "#endif" not in line_tmp \
                 and "SIM_PROF_" not in line_tmp and "NORETCALL" not in line_tmp:
                txt_tmp.append(line_tmp)

        self.startText = txt_tmp

    ##
    # Erase some part of the start text used in 06inz file : {/} at the begin/end of the body
    # Replace some macro created by omc (DIVISION(a1,a2,a3) => a1/a2 ...
    # @param self : object pointer
    # @return
    def cleanStartText06Inz(self):
            """
            Cleaning the initialization text:
            - Remove "{" and "}" at the beginning and end of the function body
            - Replace DIVISION(a1,a2,a3) by a1 / a2
            """

            # Removing the opening and closing braces of the body
            self.startText06Inz.pop(0)
            self.startText06Inz.pop()

            # Replace DIVISION_SIM(a1,a2,a3,a4) by a1 / a2
            # Difficult to do this with a regex and a sub, so we use
            # the function "subDivisionSIM()" (see utils.py)

            txt_tmp = []
            for line in self.startText06Inz:
                if has_Omc_trace (line) or has_Omc_equationIndexes (line):
                    continue
                line_tmp = subDivisionSIM(line)
                line_tmp = throwStreamIndexes(line_tmp)

                # in case the parameter is initialized by an external function
                # if "threadData" in line_tmp:
                #     line_tmp=line_tmp.replace("threadData", "data->threadData")
                #     txt_tmp.append(line_tmp)
                if "threadData" in line:
                    line=line.replace("threadData,", "")
                    txt_tmp.append(line)
                elif "#ifdef" not in line_tmp and "#endif" not in line_tmp \
                        and "SIM_PROF_" not in line_tmp and "NORETCALL" not in line_tmp:
                    txt_tmp.append(line_tmp)

            self.startText06Inz = txt_tmp

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
        self.isStruct = False

        ## Index of the element in defineElements function
        self.numElt = -1

        ## Name of the element
        self.name = ""

        ## short name of the element
        self.shortName=""

        ## in case of a structure, list of elements that constitues the structure
        self.listElements = []

        if is_struct is not None : self.isStruct = is_struct
        if num_elt is not None : self.numElt = num_elt
        if name is not None :
            self.name = name
            split_name = name.split('.')
            self.shortName=split_name[len(split_name)-1]

    ##
    # Get the short name of the element name1.name2.name => name
    # @param self : object pointer
    # @return the short name of the element
    def getElementShortName(self):
        return self.shortName

    ##
    # Get the name of the element
    # @param self : object pointer
    # @return the name of the element
    def getElementName(self):
        return self.name

    ##
    # Get the index of the element
    # @param self : object pointer
    # @return index of the element
    def getElementNum(self):
        return self.numElt

    ##
    # Get if the element is a structure
    # @param self : object pointer
    # @return @b true if the element is a structure
    def isStructure(self):
        return self.isStruct

    ##
    # Creates the line to describe a structure
    # @param self : object pointer
    # @param lines_to_return : lines to describe the structure
    # @return
    def printLink(self,lines_to_return):
        motif="  elements[%s].subElementsNum().push_back(%s);\n"
        for elt in self.listElements :
            line = motif % (str(self.numElt),str(elt.getElementNum()))
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
    num_omc1, num_omc2 = int(eq1.getNumOmc()), int(eq2.getNumOmc())
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
        self.numOmc = ""
        ## List of lines that constitues the body of the function
        self.body = []

    ##
    # Check whether the current function is a reinit one
    # @param self : object pointer
    # @return whether it is a reinit function
    def getIsModelicaReinit (self):
        return is_Modelica_reinit_body(self.body)

    ##
    # Set the name of the function
    # @param self: object pointer
    # @param name : name of the function
    # @return
    def setName(self, name):
        self.name = name

    ##
    # Set the index of the function
    # @param self : object pointer
    # @param num : index of the function
    # @return
    def setNumOmc(self, num):
        self.numOmc = num
    ##
    # Set the body of the function
    # @param self : object pointer
    # @param body : body of the function
    # @return
    def setBody(self, body):
        self.body.extend(body)

    ##
    # Get the name of the function
    # @param self : object pointer
    # @return :  the name of the function
    def getName(self):
        return self.name

    ##
    # Get the index of the function in omc file
    # @param self : object pointer
    # @return : the index of the function
    def getNumOmc(self):
        return self.numOmc

    ##
    # Get the body of the funtion
    # @param self: object pointer
    # @return the body of the function
    def getBody(self):
        return self.body

    ##
    # define the __str__ method for rawFunction class
    # @param self : object pointer
    # @return the pretty string to use for this class when calling __str__
    def __str__(self):
        return str(self.__dict__)

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
        self.returnType = ""

    ##
    # Set the name of the function
    # @param self : object pointer
    # @param name : name of the function
    # @return
    def setName(self, name):
        self.name = name

    ##
    # Get the name of the function
    # @param self : object pointer
    # @return : the name of the function
    def getName(self):
        return self.name

    ##
    # Set the body of the function
    # @param self : object pointer
    # @param body : body of the function
    # @return
    def setBody(self,body):
        self.body.extend(body)

    ##
    # Get the body of the function
    # @param self : object pointer
    # @return : the body of the function
    def getBody(self):
        return self.body

    ##
    # Set the definition of the function in header file
    # @param self : object pointer
    # @param signature : definition of the function in header file
    # @return
    def setSignature(self,signature):
        self.signature = signature

    ##
    # Get the definition of the function in header file
    # @param self : object pointer
    # @return : the definition of the function in header file
    def getSignature(self):
        return self.signature

    ##
    # Set the type returned by the function
    # @param self : object pointer
    # @param return_type : type returned by the function
    # @return
    def setReturnType(self,return_type):
        self.returnType = return_type

    ##
    # Get the type returned by the function
    # @param self: object pointer
    # @return type returned by the function
    def getReturnType(self):
        return self.returnType

##
# class Equation maker
#
class EqMaker():
    ##
    # default constructor
    # @param self : object pointer
    # @param raw_fct : raw fonction where come from the equation
    def __init__(self, raw_fct = None):
        ## Name of the function in *c files
        self.name = ""
        ## Index of the function in *c files
        self.numOmc = ""
        ##  body of the function to analyze to get the equation
        self.bodyFunc = []
        ##  raw body  of the function to analyze to get the equation
        self.rawBody = []
        ## variable evaluated by this equation
        self.evaluatedVar = ""
        ## List of variables needed to build the equation
        self.dependVars = []

        ## For whenCondition, index of the relation associated to this equation
        self.numRelation = ""

        if raw_fct is not None:
            self.name = raw_fct.getName()
            self.numOmc = raw_fct.getNumOmc()
            self.rawBody = copy.deepcopy( raw_fct.getBody() )
            self.bodyFunc = raw_fct.getBody()  # Here, deepcopy?

    ##
    # Check whether the current function is a reinit one
    # @param self : object pointer
    # @return whether it is a reinit function
    def getIsModelicaReinit (self):
        return is_Modelica_reinit_body (self.bodyFunc)

    ##
    # Set the name of the equation maker
    # @param self : object pointer
    # @param name : name of the equation maker
    # @return
    def setName(self, name):
        self.name = name

    ##
    # Set the index of the function in *c files
    # @param self : object pointer
    # @param num : index of the function
    # @return
    def setNumOmc(self, num):
        self.numOmc = num

    ##
    # Set the name of the var evaluated by this equation
    # @param self : object pointer
    # @param name : name of the variable
    # @return
    def setEvaluatedVar(self, name):
        self.evaluatedVar = name

    ##
    # Set the list of variables needed to evaluate the equation
    # @param self : object pointer
    # @param list_vars : list of variables
    # @return
    def setDependVars(self, list_vars):
        self.dependVars = list_vars


    ##
    # Get the name of the equation maker
    # @param self : object pointer
    # @return : name of the equation maker
    def getName(self):
        return self.name

    ##
    # Get the index of the equation in *c file
    # @param self : object pointer
    # @return index of the equation
    def getNumOmc(self):
        return self.numOmc

    ##
    # Get the body of the function defining the equation
    # @param self : object pointer
    # @return : body of the function
    def getBody(self):
        return self.bodyFunc

    ##
    # Get the raw body of the function defining the equation
    # @param self : object pointer
    # @return : raw body of the function
    def getRawBody(self):
        return self.rawBody

    ##
    # Get the list of variables needed to define the equation
    # @param self : object pointer
    # @return list of variables
    def getDependVars(self):
        return self.dependVars

    ##
    # get the name of the variable defined by the equation
    # @param self : object pointer
    # @return : name of the variable
    def getEvaluatedVar(self):
        return self.evaluatedVar


    ##
    # Prepare the body of the equation to be used when printing model
    # @param self : object pointer
    # @return
    def prepareBodyForEquation(self):
        """
        Cleaning the body of the function:
        - Remove "{" and "}" at the beginning and end of the function body
        """
        # Removing the opening and closing braces of the body
        self.bodyFunc.pop(0)
        self.bodyFunc.pop()

        # Remplacer "throwStreamPrintWithEquationIndexes(threadData, equationIndexes" par "throwStreamPrint(threadData"
        body_tmp = []
        for line in self.bodyFunc:
            line_tmp = mmc_strings_len1(line)
            if "threadData" in line_tmp:
                line_tmp=line_tmp.replace("threadData,", "")
            elif "throwStream" in line_tmp:
                line_tmp = throwStreamIndexes(line_tmp)
            if "omc_assert_warning" in line_tmp:
                line_tmp = line_tmp.replace("info, ","")
            body_tmp.append(line_tmp)
        self.bodyFunc = body_tmp

        # see utils.py to see the list of tasks
        # done by makeVariousTreatments
        self.bodyFunc = makeVariousTreatments( self.bodyFunc )

    ##
    # create an equation thanks to the information stored
    # @param self : object pointer
    # @return a new equation
    def createEquation(self):
        return Equation(  self.bodyFunc, \
                         self.evaluatedVar, \
                         self.getDependVars(), \
                         self.name, \
                         self.numOmc )

##
# class if Equation : class defining an if equation
#
class ifEquation():
    ##
    # default constructor
    # @param self : object pointer
    # @param num : index of the equation
    # @param condition : condition of the if equation
    def __init__(self, num = 0, condition = ""):
        ## index of the if equation
        self.num = num
        ## condition evaluated in the if equation
        self.condition = condition
        ## body of the if equation
        self.body = []
        ## tmp variables defined by this equation
        self.tmpDefined = []
        ## pattern used to identify tmp variables
        self.ptrn_define_tmp = re.compile(r'^[ ]*(?P<var>tmp\d+)[ ]*=[ ]*(?P<body>.*)$')
        ## @b true if this equation is already print in the output file
        self.alreadyPrint = False

    ##
    # Add a new line in the body of if equation
    # @param self : object pointer
    # @param line : new line to add
    # @return
    def addLineBody(self,line):
        self.body.append(line)
        match=re.search(self.ptrn_define_tmp,line)
        if match is not None:
            tmp_var = match.group('var')
            self.tmpDefined.append(tmp_var)

    ##
    # get the body of the if equation
    # @param self : object pointer
    # @return : the body of the if equation
    def getBody(self):
        return self.body

    ##
    # get the condition evaluated by the if equation$
    # @param self : object pointer
    # @return  : the condition evaluated
    def getCondition(self):
        return self.condition

    ##
    # get the list of tmp variables defined by the if equation
    # @param self : object pointer
    # @return list of tmp variables
    def getTmpDefined(self):
        return self.tmpDefined

    ##
    # test if a tmp variable is defined by the equation
    # @param self : object pointer
    # @param tmp : tmp variable of which we try to have information
    # @return @b true if this variable is defined by the equation
    def defineTmp(self,tmp):
        if tmp in self.tmpDefined:
            return True
        else:
            return False
    ##
    # test if a line is used in the if equation
    # @param self : object pointer
    # @param line : line of which we try to have information
    # @return @b true if this line is used by the equation
    def hasLine(self,line):
        if line in self.body:
            return True
        else:
            return False

    ##
    # Set the print property to True
    # @param self : object pointer
    # @return
    def setPrint(self):
        self.alreadyPrint = True

    ##
    # Get the print property
    # @param self : object pointer
    # @return the print property
    def getPrint(self):
        return self.alreadyPrint

##
# class Equation Maker for Non linear system
# This class build equations from Non linear system
#
class EqMakerNLS():
    ##
    # default constructor
    # @param self : object pointer
    # @param raw_fct : raw function used to build equations
    def __init__(self, raw_fct = None):
        ## name of the function
        self.name = ""
        ## index of the function
        self.numOmc = ""
        ## Raw body of the function
        self.bodyFunc = []
        ## List of variables evaluated by the function
        self.evaluatedVars = []

        ## Number of equation of the non linear system
        self.nbNLSeq = 0

        ## List of variables used in non linear system (one list by residual function)
        self.dependVars = []
        ## List of tmp variables used in non linear system (one list by residual function)
        self.dependTmp = []
        ## Body of residual function (one list by residual function)
        self.NLSbodies = []

        ## index of classical function called in non linear system (_eq_function)
        self.classicFctNum = []

        if raw_fct is not None:
            self.numOmc = raw_fct.getNumOmc()
            self.name = raw_fct.getName()
            self.bodyFunc = raw_fct.getBody()  # Here, deepcopy?

        ## pattern to identify line begun by res[n]
        self.ptrn_res = re.compile(r'^[ ]*res\[\d+\][ ]*=[ ]*(?P<body>.*)$')

        ## pattern to identify variables
        self.ptrnVars = re.compile(r'\$P\$DER\$P[\w\$]+|\$P[\w\$]+')

        ## pattern to identify tmp variables
        self.ptrn_tmp = re.compile(r'tmp\d+')

        ## pattern to identify tmp variables to calculate tmp variable
        self.ptrn_tmp_dep = re.compile(r'^[ ]*(?P<var>tmp\d+)[ ]*=[ ]*(?P<body>.*)$')
        ## pattern to identify if equation using tmp variables
        self.ptrn_tmp_dep_if = re.compile(r'if\((?P<var>tmp\d+)\)')

        ## pattern to identify classical function _eqFunction
        self.ptrnClassicFunc = re.compile(r'_eqFunction_(?P<num>\d+)')

        ## list of ifEquations used in non linear system
        self.ifEquations = []
        ## pattern to identify the beginning of if equations
        self.ptrn_if = re.compile(r'if\((?P<var>.*)\)')
        ## pattern to identify the end of a if equation
        self.ptrn_close= re.compile(r'}')
        ## pattern to identify the else of if equation
        self.ptrn_else= re.compile(r'else')

    ##
    # get the index of the function
    # @param self : object pointer
    # @return index of the function
    def getNumOmc(self):
        return self.numOmc

    ##
    # get the list of variables used in NLS
    # @param self: object pointer
    # @return list of variables
    def getDependVars(self):
        return self.dependVars

    ##
    # Set the variables evaluated by the NLS
    # @param self : object pointer
    # @param lst: list of variables
    # @return
    def setEvaluatedVars(self, lst):
        self.evaluatedVars = lst

    ##
    # Retrieve information to build equations of NLS:
    # -> number of equations to build
    # -> var used in each equations
    # -> tmp var used in each equations
    # @param self : object pointer
    # @return
    def getInfosForNLSeq(self):
        # #analysis of the function to find if/else and variables used
        nb_if_open = 0
        nb_else_open = 0
        num_eq_if = 0
        eq_if=ifEquation()
        #one single eq_if even if multiple nested
        for line in self.bodyFunc:
            match = re.search(self.ptrn_if,line)
            match_else = re.search(self.ptrn_else,line)
            if match_else is not None:
                nb_else_open += 1

            if match is not None:
                var_cond = match.group('var')
                nb_if_open += 1
                if(nb_if_open == 1):
                    eq_if = ifEquation(num_eq_if,var_cond)
                    num_eq_if +=1
                    self.ifEquations.append(eq_if)


            if nb_if_open>0 or nb_else_open>0:
                eq_if.addLineBody(line)

            if nb_else_open >0:
                if ' }\n' in line :
                    nb_else_open -= 1
            else:
                if nb_if_open>0:
                    if ' }\n' in line :
                        nb_if_open -= 1


        map_tmp_dep = {} # For each tmp var, the list of other tmp vars on which it depends

        # if tmp var in an if, we also add condition tmp vars

        for equation in self.ifEquations:
            for line in equation.getBody():
                match = re.search(self.ptrn_tmp_dep, line)
                if match is not None:
                    eval_tmp_var = match.group('var') # Tmp var affected
                    eval_tmp_var_dep = self.ptrn_tmp.findall(equation.getCondition())
                    if map_tmp_dep.has_key(eval_tmp_var):
                        for tmp_var in eval_tmp_var_dep:
                            map_tmp_dep[eval_tmp_var].append(tmp_var)
                    else: map_tmp_dep[eval_tmp_var] = eval_tmp_var_dep

                # for adding the if conditions included in other if
                match = re.search(self.ptrn_tmp_dep_if, line)
                if match is not None:
                    eval_tmp_var = match.group ('var') # the var used in the if
                    eval_tmp_var_dep = self.ptrn_tmp.findall(equation.getCondition())
                    for tmp_var in eval_tmp_var_dep:
                        if map_tmp_dep.has_key(tmp_var):
                            map_tmp_dep[tmp_var].append(eval_tmp_var)
                        else:
                            tmp_list = [eval_tmp_var]
                            map_tmp_dep[tmp_var] = tmp_list

        # For each tmp var, the list of other tmp vars on which it depends
        for line in self.bodyFunc:

            # Here we use the lines of the type: tmp1 = aFunctionOfVars (tmp2, tmp3, ...)
            # to build "map_tmp_dep" (for each tmp var, the list of other tmp vars
            # on which it depends)
            match = re.search(self.ptrn_tmp_dep, line)
            if match is not None:
                # If we have a line of type: tmp1 = aFunctionOfVars (tmp2, tmp3, ...)
                # 1) We add tmp2, tmp3, ... in the tmp vars on which depends tmp1
                # 2) We go through the dependencies of tmp2, tmp3, ..., and we add
                # their dependency vars in those of tmp1

                eval_tmp_var = match.group('var') # The tmp var affected
                eval_tmp_var_dep = self.ptrn_tmp.findall( line ) # The list of vars on which "eval_tmp_var" depends

                # The tmp var assigned here depends on the tmp vars of the second member
                # in the expression : tmp1 = aFunctionOfVars(tmp2, tmp3, ...)
                if map_tmp_dep.has_key(eval_tmp_var) :
                    for tmp_var in eval_tmp_var_dep :
                        map_tmp_dep[eval_tmp_var].append(tmp_var)
                else : map_tmp_dep[eval_tmp_var] = eval_tmp_var_dep

                # The tmp var assigned here also depends on the vars of dependency of tmp vars of the second member
                for tmp_var in eval_tmp_var_dep :
                    if map_tmp_dep.has_key(tmp_var) :
                        list_dep = map_tmp_dep[tmp_var]
                        for vtmp in list_dep :
                            # If it is not already there, we add it
                            if vtmp not in map_tmp_dep[eval_tmp_var] :
                                map_tmp_dep[eval_tmp_var].append(vtmp)


            # We process lines of type: "res[n] = ..."
            # This type of line indicates a residual equation to be created. To
            # become a real equation, you have to transform it a little and
            # add declarations and assignments of tmp vars in it.

            # For each equation we get "normal" variables in "self.dependVars"
            # (for example $Pvar or  $P$DER$Pvar) and "tmp" variables in "self.dependTmp"
            match = re.search(self.ptrn_res, line)
            if match is not None:

                # we increment when we meet a residual eq
                # (starting by par "res[n] = ...")
                self.nbNLSeq += 1

                # Recovery of the body of one of the future NLS equations
                self.NLSbodies.append( [match.group('body')] )

                # Recovery of all variables $Pvar or $P$DER $Pvar
                # in a line starting by "res[n] = ..."
                list_vars_depend = []
                for v in self.ptrnVars.findall( line ) :
                    if v not in list_vars_depend:
                        list_vars_depend.append( to_classic_style(v) )
                self.dependVars.append( list_vars_depend )

                # Recovery of all variables tmp${num}
                # in a line starting by "res[n] = ..."
                list_tmp_depend = []
                for tmp in self.ptrn_tmp.findall( line ) :
                    if tmp not in list_tmp_depend:
                        list_tmp_depend.append( tmp )
                self.dependTmp.append( list_tmp_depend )

        # For each tmp var in a line of type:
        # "res[n] = ..."
        # we add vars on which it depends in "self.dependTmp"
        depend_tmp2 = self.dependTmp
        i = 0
        for l_vars in depend_tmp2 :
            for v in l_vars:
                if map_tmp_dep.has_key(v) :
                    for vtmp in map_tmp_dep[v]:
                        if vtmp not in depend_tmp2[i] :
                            self.dependTmp[i].append(vtmp)
            # addition of declared tmp variables in if whose l_vars does not depend
            for equation in self.ifEquations:
                for v in l_vars:
                    if equation.defineTmp(v):
                        for v1 in equation.getTmpDefined():
                            if v1 not in depend_tmp2[i]:
                                self.dependTmp[i].append(v1)
            i += 1

    ##
    # Retrieve the index of classic functions used in NLS
    # @param self : object pointer
    # @return
    def setNumEqClassic(self):
        # Recovery of the numbers of the classic functions called in
        # the body of the function defining the NLS
        for line in self.bodyFunc:
            match = re.search(self.ptrnClassicFunc, line)
            if match is not None :
                self.classicFctNum.append( match.group('num') )
    ##
    # Get the list of index of classic functions used in NLS
    # @param self : object pointer
    # @return list of index
    def getNumEqClassic(self):
        return self.classicFctNum

    ##
    # Insert in equation created with NLS the equations needed to declare and
    # affect tmp variables
    # @param self : object pointer
    # @return
    def prepareBodiesForEquations(self):
        # Before the following code block, the equation (stored in "self.NLSbodies[i]")
        # contains only the line "res[n] = ...".
        # We add (before this line) the lines declaring and defining the tmp vars
        # in the line "res[n] = ...".
        # To do this, we go through the body of the residual function coming from *_02nls.c.
        for i in range(self.nbNLSeq):
            for line in self.bodyFunc:
                line_in_if_equation = False
                for if_equation in self.ifEquations:
                    if if_equation.hasLine(line):
                        line_in_if_equation = True
                match = re.search(self.ptrn_res, line)
                if match is not None : continue
                # At this stage, "line" is a line of type "res[n] = ..."
                for tmp in self.dependTmp[i]:
                   if tmp in line and line_in_if_equation == False:
                       # If the line "res[n] = ..." contains the current tmp var...
                       self.NLSbodies[i].insert( len(self.NLSbodies[i]) - 1, line )
                       # If the line is already taken into account, we leave the loop:
                       # no need to store it in "self.NLSbodies[i]" multiple times!
                       break

        # adding if equations
        for i in range(self.nbNLSeq):
            for tmp in self.dependTmp[i]:
                for if_equation in self.ifEquations:
                    if if_equation.defineTmp(tmp) and if_equation.getPrint()==False:
                        for line in if_equation.getBody():
                            self.NLSbodies[i].insert( len(self.NLSbodies[i]) - 1, line )
                        if_equation.setPrint()


        # Replace "throwStreamPrintWithEquationIndexes(threadData, equationIndexes" par "throwStreamPrint(threadData"
        for i in range(self.nbNLSeq):
            body_tmp = []
            for line in self.NLSbodies[i]:
                line_tmp = throwStreamIndexes(line)
                body_tmp.append(line_tmp)
            self.NLSbodies[i] = body_tmp


        # see utils.py to see the list of tasks
        # done by makeVariousTreatments
        for i in range(self.nbNLSeq):
            self.NLSbodies[i] = makeVariousTreatments( self.NLSbodies[i] )


    ##
    # Create equations thanks to information store in NLS
    # @param self : object pointer
    # @return : list of new equations
    def createEquations(self):
        list_eq_to_return = []
        for i in range(self.nbNLSeq):
            list_eq_to_return.append(  EquationNLS( self.NLSbodies[i], \
                                                 self.evaluatedVars[i], \
                                                 self.dependVars[i], \
                                                 self.name, \
                                                 self.numOmc)  )

        return list_eq_to_return



##
# class Equation maker for linear system A.X =b
#
class EqMakerLS:
    ##
    # default constructor
    # @param self : object pointer
    # @param raw_matrix_fct : function which declares the matrix A of the linear system
    # @param raw_rhs_fct : function which declares the vector B of the linear system
    def __init__(self, raw_matrix_fct = None, raw_rhs_fct = None):

        ## pattern to identify declaration of element of the matrix A in 03lsy file
        self.matElemFct = 'setAElement'
        ## pattern to identify declaration of element of the vector B in 03lsy file
        self.rhsElemFct = 'setBElement'
        ## pattern to remove brackets around expression
        self.ptrnRmvBrackets = re.compile(r'^\((?P<expr>.*)\)$')
        ## pattern to identify variable
        self.ptrnVars = re.compile(r'\$P\$DER\$P[\w\$]+|\$P[\w\$]+')
        ## patternr to identify tmp variable
        self.ptrn_tmp = re.compile(r'tmp\d+')

        ## pattern to identify tmp variables to calculate tmp variable
        self.ptrn_tmp_dep = re.compile(r'^[ ]*(?P<var>tmp\d+)[ ]*=[ ]*(?P<body>.*)$')
        ## pattern to identify if equation using tmp variables
        self.ptrn_tmp_dep_if = re.compile(r'if\((?P<var>tmp\d+)\)')

        ## index of the function
        self.numOmc = ""
        ## name of the function where the matrix A is defined
        self.matFctName = ""
        ## body of the function where the matrix A is defined
        self.matFctBody = []
        ## name of the function where the vector B is defined
        self.rhsFctName = ""
        ## body of the function where the vector B is defined
        self.rhsFctBody = []
        ## Index of classic functions called in linear system
        self.classicFctNum = []

        ## variables evaluated by the linear system
        self.evaluatedVars = []

        ## List of variables used in linear system (one list by residual function)
        self.dependVars = []
        ## List of tmp variables used in linear system (one list by residual function)
        self.dependTmp = []
        ## Body of equations (one list by equation
        self.LSbodies = []
        ## Size of the linear system
        self.dim = -1
        ## Matrix of the linear system
        self.matrix = []
        ## vector B of the linear system
        self.rhs = []

        if raw_matrix_fct is not None:
            self.numOmc = raw_matrix_fct.getNumOmc()
            self.matFctName = raw_matrix_fct.getName()
            self.matFctBody = raw_matrix_fct.getBody()  # Here, deepcopy?

        if raw_rhs_fct is not None:
            self.rhsFctName = raw_rhs_fct.getName()
            self.rhsFctBody = raw_rhs_fct.getBody()  # Here, deepcopy?

        ## list of ifEquations used in linear system
        self.ifEquations = []
        ## pattern to identify the beginning of if equations
        self.ptrn_if = re.compile(r'if\((?P<var>.*)\)')
        ## pattern to identify the end of a if equation
        self.ptrn_close= re.compile(r'}')
        ## pattern to identify the else of if equation
        self.ptrn_else= re.compile(r'else')

    ##
    # Retrieve information about linear system :
    # -> number of equations to build
    # -> var used in each equations
    # -> tmp var used in each equations
    # @param self : object pointer
    # @return
    def getInfosForLSeq(self):
        self.dim = len(self.evaluatedVars)
        self.setMatrix()
        self.setRhs()

        # Get the necessary equations in the rhs function

        # #analysis to find if/else and variables used
        nb_if_open = 0
        nb_else_open = 0
        num_eq_if = 0
        eq_if=ifEquation()
        #one single eq_if even if multiple nested
        for line in self.rhsFctBody:
            match = re.search(self.ptrn_if,line)
            match_else = re.search(self.ptrn_else,line)
            if match_else is not None:
                nb_else_open += 1

            if match is not None:
                var_cond = match.group('var')
                nb_if_open += 1
                if(nb_if_open == 1):
                    eq_if = ifEquation(num_eq_if,var_cond)
                    num_eq_if +=1
                    self.ifEquations.append(eq_if)


            if nb_if_open>0 or nb_else_open>0:
                eq_if.addLineBody(line)

            if nb_else_open >0:
                if ' }\n' in line :
                    nb_else_open -= 1
            else:
                if nb_if_open>0:
                    if ' }\n' in line :
                        nb_if_open -= 1
        # likewise for self.matFctBody
        nb_if_open = 0
        nb_else_open = 0
        num_eq_if = 0
        eq_if=ifEquation()
        #one single eq_if even if multiple nested
        for line in self.matFctBody:
            match = re.search(self.ptrn_if,line)
            match_else = re.search(self.ptrn_else,line)
            if match_else is not None:
                nb_else_open += 1

            if match is not None:
                var_cond = match.group('var')
                nb_if_open += 1
                if(nb_if_open == 1):
                    eq_if = ifEquation(num_eq_if,var_cond)
                    num_eq_if +=1
                    self.ifEquations.append(eq_if)


            if nb_if_open>0 or nb_else_open>0:
                eq_if.addLineBody(line)

            if nb_else_open >0:
                if ' }\n' in line :
                    nb_else_open -= 1
            else:
                if nb_if_open>0:
                    if ' }\n' in line :
                        nb_if_open -= 1



        map_tmp_dep = {} # For each tmp var, the list of other tmp vars on which it depends


        # if tmp var in an if, we also add condition tmp vars

        for equation in self.ifEquations:
            for line in equation.getBody():
                match = re.search(self.ptrn_tmp_dep, line)
                if match is not None:
                    eval_tmp_var = match.group('var') # tmp var affected
                    eval_tmp_var_dep = self.ptrn_tmp.findall(equation.getCondition())
                    if map_tmp_dep.has_key(eval_tmp_var):
                        for tmp_var in eval_tmp_var_dep:
                            map_tmp_dep[eval_tmp_var].append(tmp_var)
                    else: map_tmp_dep[eval_tmp_var] = eval_tmp_var_dep

                # for adding the if conditions included in other if
                match = re.search(self.ptrn_tmp_dep_if, line)
                if match is not None:
                    eval_tmp_var = match.group ('var') # the var used in the if
                    eval_tmp_var_dep = self.ptrn_tmp.findall(equation.getCondition())
                    for tmp_var in eval_tmp_var_dep:
                        if map_tmp_dep.has_key(tmp_var):
                            map_tmp_dep[tmp_var].append(eval_tmp_var)
                        else:
                            tmp_list = [eval_tmp_var]
                            map_tmp_dep[tmp_var] = tmp_list


        for line in self.rhsFctBody:
            # Here we use the lines of the type: tmp1 = aFunctionOfvars (tmp2, tmp3, ...)
            # to build "map_tmp_dep" (for each tmp var, the list of other tmp vars
            # of which it depends)
            match = re.search(self.ptrn_tmp_dep, line)
            if match is not None:
                # If we have a line of type: tmp1 = aVarsFunction (tmp2, tmp3, ...)
                # 1) We add tmp2, tmp3, ... in the tmp vars on which depends tmp1
                # 2) We go through the dependencies of tmp2, tmp3, ..., and we add
                # their dependency vars in those of tmp1

                eval_tmp_var = match.group('var') # tmp var affected
                eval_tmp_var_dep = self.ptrn_tmp.findall( line ) # List of vars on which "eval_tmp_var" depends

                # The tmp var assigned here depends on the tmp vars of the second member
                # in the expression : tmp1 = aFunctionOfvars(tmp2, tmp3, ...)
                if map_tmp_dep.has_key(eval_tmp_var) :
                    for tmp_var in eval_tmp_var_dep :
                        map_tmp_dep[eval_tmp_var].append(tmp_var)
                else : map_tmp_dep[eval_tmp_var] = eval_tmp_var_dep

                # The tmp var assigned here also depends on the vars of dependency of tmp vars of the second member
                for tmp_var in eval_tmp_var_dep :
                    if map_tmp_dep.has_key(tmp_var) :
                        list_dep = map_tmp_dep[tmp_var]
                        for vtmp in list_dep :
                            # If it is not already in it, we add it
                            if vtmp not in map_tmp_dep[eval_tmp_var] :
                                map_tmp_dep[eval_tmp_var].append(vtmp)


            # Here we use the lines of the type: "linearSystemData->b[n] = ..."
            # This type of line indicates a residual equation to be created. To
            # become a real equation, you have to transform it a little and
            # add the declarations and assignments of the tmp vars that intervene in it.

            # For each future equation, we get, in "self.dependVars", "normal" variables
            # ($Pvar or $P$DER$Pvar) on which it depends and we get,
            # in "self.dependTmp", tmp vars on which it depends.
            if (self.rhsElemFct in line):
                # Recovery of all variables $ Pvar or $ P $ DER $ Pvar
                # in a line starting by "linearSystemData->b[n] = ..."
                list_vars_depend = []
                for v in self.ptrnVars.findall( line ) :
                    if v not in list_vars_depend:
                        list_vars_depend.append( to_classic_style(v) )
                self.dependVars.append( list_vars_depend )

                # Recovery of all variables tmp${num}
                # in a line starting by "linearSystemData->b[n] = ..."
                list_tmp_depend = []
                for tmp in self.ptrn_tmp.findall( line ) :
                    if tmp not in list_tmp_depend:
                        list_tmp_depend.append( tmp )
                self.dependTmp.append( list_tmp_depend )

        # # For each tmp var in a line of type:
        # # "linearSystemData->b[n] = ..."
        # # we add vars on which it depends in "self.dependTmp"
        # depend_tmp2 = self.dependTmp
        # i = 0
        # for l_vars in self.dependTmp :
        #     for v in l_vars:
        #         if map_tmp_dep.has_key(v) :
        #             for vtmp in map_tmp_dep[v]:
        #                 if vtmp not in depend_tmp2[i] : depend_tmp2[i].append(vtmp)
        #     i += 1


        # Get the necessary equations in the matrix function
        for line in self.matFctBody:
            # Here we use the lines of the type: tmp1 = aFunctionOfvars (tmp2, tmp3, ...)
            # to build "map_tmp_dep" (for each tmp var, the list of other tmp vars
            # on which it depends)
            match = re.search(self.ptrn_tmp_dep, line)
            if match is not None:
                # If we have a line of type: tmp1 = aVarsFunction (tmp2, tmp3, ...)
                # 1) We add tmp2, tmp3, ... in the tmp vars on which depends tmp1
                # 2) We go through the dependencies of tmp2, tmp3, ..., and we add
                # their dependency vars in those of tmp1

                eval_tmp_var = match.group('var') # tmp var affected
                eval_tmp_var_dep = self.ptrn_tmp.findall( line ) # List of vars on which "eval_tmp_var" depends

                # The tmp var assigned here depends on the tmp vars of the second member
                # in the expression : tmp1 = aFunctionOfvars(tmp2, tmp3, ...)
                if map_tmp_dep.has_key(eval_tmp_var) :
                    for tmp_var in eval_tmp_var_dep :
                        map_tmp_dep[eval_tmp_var].append(tmp_var)
                else : map_tmp_dep[eval_tmp_var] = eval_tmp_var_dep

                # The tmp var assigned here also depends on the vars of dependency of tmp vars of the second member
                for tmp_var in eval_tmp_var_dep :
                    if map_tmp_dep.has_key(tmp_var) :
                        list_dep = map_tmp_dep[tmp_var]
                        for vtmp in list_dep :
                            # If it is not already there, we add it
                            if vtmp not in map_tmp_dep[eval_tmp_var] :
                                map_tmp_dep[eval_tmp_var].append(vtmp)


            # We process lines of type: "linearSystemData->setAElement(..."
            # This type of line indicates a residual equation to be created. To
            # become a real equation, you have to transform it a little and
            # add the declarations and assignments of the tmp vars that are used in it.

            # For each equation we get "normal" variables in "self.dependVars"
            # (for example $Pvar or  $P$DER$Pvar) and "tmp" variables in "self.dependTmp"
            if self.matElemFct in line:
                mat_elem_args = split_function_arguments (line, self.matElemFct)
                # Recovery of all variables $Pvar or $P$DER $Pvar
                # in a line starting by "linearSystemData->setAElement(..."
                list_vars_depend = []
                for v in self.ptrnVars.findall( line ) :
                    if v not in list_vars_depend:
                        list_vars_depend.append( to_classic_style(v) )
                i = int( mat_elem_args [0] )
                self.dependVars[i].extend(list_vars_depend)

                # Recovery of all variables tmp${num}
                # in a line starting by "linearSystemData->setAElement(..."
                list_tmp_depend = []
                for tmp in self.ptrn_tmp.findall( line ) :
                    if tmp not in list_tmp_depend:
                        list_tmp_depend.append( tmp )
                self.dependTmp[i].extend(list_tmp_depend)

        # For each tmp var in a line of type:
        # we add vars on which it depends in "self.dependTmp"
        depend_tmp2 = self.dependTmp
        i = 0
        for l_vars in depend_tmp2 :
            for v in l_vars:
                if map_tmp_dep.has_key(v) :
                    for vtmp in map_tmp_dep[v]:
                        if vtmp not in depend_tmp2[i] :
                            self.dependTmp[i].append(vtmp)
            # addition of declared tmp variables in if whose l_vars does not depend
            for equation in self.ifEquations:
                for v in l_vars:
                    if equation.defineTmp(v):
                        for v1 in equation.getTmpDefined():
                            if v1 not in depend_tmp2[i]:
                                self.dependTmp[i].append(v1)
            i += 1

    ##
    # get the index of the function
    # @param self : object pointer
    # @return index of the function
    def getNumOmc(self):
        return self.numOmc

    ##
    # get the name of the function where matrix A is defined
    # @param self : object pointer
    # @return name of the function
    def getMatFctName(self):
         return self.matFctName

    ##
    # Get the list of variables evaluated by the linear system
    # @param self : object pointer
    # @return list of variables
    def getEvaluatedVars(self):
        return self.evaluatedVars

    ##
    # Set the list of variables evaluated by the linear system
    # @param self : object pointer
    # @param lst :list of variables
    # @return
    def setEvaluatedVars(self, lst):
        self.evaluatedVars = lst

    ##
    # Define the matrix A of the linear system
    # @param self: object pointer
    # @return
    def setMatrix(self):
        # Initialization of the matrix with 0
        matrix_line = [] #
        for k in range(self.dim) : matrix_line.append( "0.0" )
        for k in range(self.dim) : self.matrix.append( copy.deepcopy(matrix_line) )
        # Filling of the matrix with what we find in "setLinearMatrixA..."
        for line in self.matFctBody:
            # To get rid of enventual DIVISION
            filtered_line = subDivisionSIM(line)
            if (self.matElemFct in filtered_line):
                mat_elem_args = split_function_arguments (filtered_line, self.matElemFct)
                i = int( mat_elem_args [0] )
                j = int( mat_elem_args [1] )
                val = mat_elem_args [2]
                self.matrix[i][j] = val


    ##
    # Define the vector B of the linear system
    # @param self: object pointer
    # @return
    def setRhs(self):
        # Initialization of rhs with 0
        rhs_line = []
        for k in range(self.dim) : rhs_line.append( "0.0" )
        self.rhs = copy.deepcopy(rhs_line)

        # Filling of the rhs with what we find in "setLinearVectorb..."
        for line in self.rhsFctBody:
            if (self.rhsElemFct in line):
                function_args = split_function_arguments (line, self.rhsElemFct)
                if len (function_args) != 4:
                    print ('failed to scan for right-hand side function')
                    sys.exit(1)
                i = int(function_args [0])
                val = function_args [1]
                self.rhs[i] = val

        # Post rhs processing
        self.rhs = [ self.ptrnRmvBrackets.sub(r'\g<expr>', comp) for comp in self.rhs ]


    ##
    # Retrieve the index of classic functions used in the linear system
    # @param self : object pointer
    # @return
    def setNumEqClassic(self):
        # Recovery of the numbers of the classic functions called in
        # the body of the function defining the LSY
        for line in self.bodyFunc:
            match = re.search(self.ptrnClassicFunc, line)
            if match is not None :
                self.classicFctNum.append( match.group('num') )
    ##
    # Get the list of index of classic functions used in the linear system
    # @param self : object pointer
    # @return list of index
    def getNumEqClassic(self):
        return self.classicFctNum

    ##
    # Prepare the body of the equation to be used when printing model
    # @param self : object pointer
    # @return
    def prepareBodiesForEquations(self):
        for i in range(self.dim):
            line = ""
            for j in range(self.dim):
                member = "(" + self.matrix[i][j] + ")*(" + to_omc_style( self.evaluatedVars[j] ) + ")"
                if j < self.dim - 1 : line += member + " + "
                else : line += member + " = "
            line += "(" + self.rhs[i] + ")"
            self.LSbodies.append([line])

        # Before the following code block, the equation (stored in "self.LSbodies[i]")
        # contains only the line related to an equation of the LS.
        # We add (before this line) the lines declaring and defining the tmp vars
        # intervening in the line of the equation.
        for i in range(self.dim):
            for line in self.rhsFctBody:
                line_in_if_equation = False
                for if_equation in self.ifEquations:
                    if if_equation.hasLine(line):
                        line_in_if_equation = True
                if (self.rhsElemFct in line) : continue
                # At this stage, "line" is a line of type "linearSystemData->b[n] = ..."
                for tmp in self.dependTmp[i]:
                   if tmp in line and line_in_if_equation == False:
                       # If the line "linearSystemData->b[n] = ..." contains the current tmp var...
                       self.LSbodies[i].insert( len(self.LSbodies[i]) - 1, line )
                       # If the line is already taken into account, we leave the loop:
                       # no need to store it "self.LSbodies[i]" multiple times!
                       break
            for line in self.matFctBody:
                line_in_if_equation = False
                for if_equation in self.ifEquations:
                    if if_equation.hasLine(line):
                        line_in_if_equation = True
                if self.matElemFct in line : continue
                # At this stage, "line" is a line of type "linearSystemData->setElementA(..."
                for tmp in self.dependTmp[i]:
                   if tmp in line and line_in_if_equation == False:
                       # If the line "linearSystemData->setElementA(..." contains the current tmp var...
                       self.LSbodies[i].insert( len(self.LSbodies[i]) - 1, line )
                       # If the line is already taken into account, we leave the loop:
                       # no need to store it "self.LSbodies[i]" multiple times!
                       break

        for i in range(self.dim):
             for tmp in self.dependTmp[i]:
                for if_equation in self.ifEquations:
                    if if_equation.defineTmp(tmp) and if_equation.getPrint()==False:
                        for line in if_equation.getBody():
                            self.LSbodies[i].insert( len(self.LSbodies[i]) - 1, line )
                        if_equation.setPrint()

        # see utils.py to see the list of tasks
        # done by makeVariousTreatments
        for i in range(self.dim):
            self.LSbodies[i] = makeVariousTreatments( self.LSbodies[i] )
    ##
    # Create equations thanks to information store in LS
    # @param self : object pointer
    # @return : list of new equations
    def createEquations(self):
        list_eq_to_return = []
        for i in range(self.dim):
            list_eq_to_return.append( EquationLS( self.LSbodies[i], \
                                               self.evaluatedVars[i], \
                                               self.dependVars[i], \
                                               self.matFctName, \
                                               self.numOmc) )

        return list_eq_to_return

##
# base class for Equation declaration
#
class EquationBase:
    ##
    # default constructor
    # @param self : object pointer
    # @param body : body of the equation
    # @param eval_var : variable evaluated by the equation
    # @param depend_vars : variables used in the equation
    # @param comes_from : name of the function using the equation
    # @param numOmc : index of the equation in omc arrays
    def __init__(self, body = None, eval_var = None, depend_vars = None, comes_from = None, num_omc = None):
        ## pattern to identify the variable evaluated
        self.ptrnEvaluatedVar = re.compile(r'\$P(?P<var>[\$\w]+) = (?P<rhs>[^;]+)')

        ##  name of the function using the equation
        self.comesFrom = ""
        ## variable evaluated by the equation
        self.evaluatedVar = ""
        ## variables used in the equation
        self.dependVars = []
        ## index of the equation in omc arrays
        self.numOmc = ""
        ## index of the equation in dynawo arrays
        self.numDyn = -1
        ## body of the equation
        self.body = []
        ## body of the equation store as a string
        self.bodyText = ""


        if body is not None:
            self.body = body
        if eval_var is not None:
            self.evaluatedVar = eval_var
        if depend_vars is not None:
            self.dependVars = depend_vars
        if comes_from is not None:
            self.comesFrom = comes_from
        if num_omc is not None:
            self.numOmc = num_omc

    ##
    # Set the index of the equation in omc arrays
    # @param self : object pointer
    # @param index : index of the equation
    # @return
    def setNumDyn(self, index):
        self.numDyn = index

    ##
    # Get the index of the equation in omc arrays
    # @param self : object pointer
    # @return index of the equation
    def getNumOmc(self):
        return self.numOmc

    ##
    # Get the index of the equation in dynawo arrays
    # @param self : object pointer
    # @return index of the equation
    def getNumDyn(self):
        return self.numDyn

    ##
    # Get the name of the variable evaluated by the equation
    # @param self : object pointer
    # @return name of the variable
    def getEvaluatedVar(self):
        return self.evaluatedVar
    ##
    # Get if the equation use the 'throw' instruction
    # @param self: object pointer
    # @return @b True if the equation use the 'throw' instruction
    def withThrow(self):
        with_throw = False
        for line in self.body:
            if "throwStreamPrint" in line:
                with_throw = True

        return with_throw

    ##
    # Get the list of variables used in the equation
    # @param self: object pointer
    # @return list of variables
    def getDependVars(self):
        return self.dependVars

    ##
    # Get the name of the function using the equation
    # @param self : object pointer
    # @return name of the function
    def getSrcFctName(self):
       return self.comesFrom

    ##
    # Check whether the current function is a reinit one
    # @param self : object pointer
    # @return whether it is a reinit function
    def getIsModelicaReinit (self):
        return is_Modelica_reinit_body (self.body)

    ##
    # Get the body of the equation
    # @param self: object pointer
    # @return : body of the equation
    def getRawBody(self):
        text_to_return = ""
        for line in self.body : text_to_return += line
        return text_to_return

    ##
    # get if the equation defined a differential equation
    # @param self : object pointer
    # @return @b true if the equation defined a differential equation
    def isDiffEq(self):
        # Does it takes part in a derivative?
        for name in self.dependVars:
            if isDer(name): return True
        return False

##
# class Equation
#
class Equation(EquationBase):
    ##
    # default constructor
    # @param self : object pointer
    # @param body : body of the equation
    # @param eval_var : variable evaluated by the equation
    # @param depend_vars : variables used in the equation
    # @param comes_from : name of the function using the equation
    # @param num_omc : index of the equation in omc arrays
    def __init__(self, body = None, eval_var = None, depend_vars = None, comes_from = None, num_omc = None):
        EquationBase.__init__(self, body, eval_var, depend_vars, comes_from, num_omc)

    ##
    # retrieve the body formatted for Modelica reinit affectation
    # @param self : object pointer
    # @return the formatted body
    def getBodyFor_ModelicaReinitAffectation(self):
        return formatFor_ModelicaReinitAffectation (self.body)

    ##
    # retrieve the body formatted for evalMode
    # @param self : object pointer
    # @return the formatted body
    def getBodyFor_evalMode(self):
        return formatFor_ModelicaReinitEvalMode (self.body)

    ##
    # Prepares the body of the equation to be used in setF function
    # @param self : object pointer
    # @return list of lines to print
    def getBodyFor_setF(self):
        text_to_return = []
        for line in self.body:
            line = mmc_strings_len1(line)

            if has_Omc_trace (line) or has_Omc_equationIndexes (line) or ("infoStreamPrint" in line)\
                   or ("data->simulationInfo->needToIterate = 1") in line:
                continue

            line = subDivisionSIM(line)

            if re.search(self.ptrnEvaluatedVar, line) is None:
                text_to_return.append( line )
            else:
                text_to_return.append( self.ptrnEvaluatedVar.sub(r'f[%d] = $P\g<1> - ( \g<2> )' % self.getNumDyn(), line) )
        return text_to_return

    ##
    # Prepares the body of the equation to be used in evalFAdept function
    # @param self : object pointer
    # @return list of lines to print
    def getBodyFor_evalFAdept(self):
        text_to_return = []
        for line in self.body:
            line = mmc_strings_len1(line)
            line_tmp = line
            line_tmp = line_tmp.replace("modelica_real", "adept::adouble")
            line_tmp = line_tmp.replace("Greater(", "Greater<adept::adouble>(")
            line_tmp = line_tmp.replace("Less(", "Less<adept::adouble>(")
            line_tmp = line_tmp.replace("GreaterEq(", "GreaterEq<adept::adouble>(")
            line_tmp = line_tmp.replace("LessEq(", "LessEq<adept::adouble>(")
            line_tmp = line_tmp.replace("Greater)", "Greater<adept::adouble>)")
            line_tmp = line_tmp.replace("Less)", "Less<adept::adouble>)")
            line_tmp = line_tmp.replace("GreaterEq)", "GreaterEq<adept::adouble>)")
            line_tmp = line_tmp.replace("LessEq)", "LessEq<adept::adouble>)")

            if has_Omc_trace (line) or has_Omc_equationIndexes (line) or ("infoStreamPrint" in line)\
                   or ("data->simulationInfo->needToIterate = 1") in line:
                continue

            line_tmp = subDivisionSIM(line_tmp)
            if re.search(self.ptrnEvaluatedVar, line_tmp) is None:
                text_to_return.append( line_tmp )
            else:
                text_to_return.append( self.ptrnEvaluatedVar.sub(r'res[%d] = $P\g<1> - ( \g<2> )' % self.getNumDyn(), line_tmp) )
        return text_to_return
##
# class Equation LS (linear system)
#
class EquationLS(EquationBase):
    ##
    # default constructor
    # @param self : object pointer
    # @param body : body of the equation
    # @param eval_var : variable evaluated by the equation
    # @param depend_vars : variables used in the equation
    # @param comes_from : name of the function using the equation
    # @param num_omc : index of the equation in omc arrays
    def __init__(self, body = None, eval_var = None, depend_vars = None, comes_from = None, num_omc = None):
        ## pattern to identify equations
        self.ptrnEq = re.compile(r'(?P<lhs>\([^=]+\))[ ]*=[ ]*(?P<rhs>\([^=]+\))')

        EquationBase.__init__(self, body, eval_var, depend_vars, comes_from, num_omc)

    ##
    # Prepares the body of the equation to be used in setF function
    # @param self : object pointer
    # @return list of lines to print
    def getBodyFor_setF(self):
        text_to_return = []
        for line in self.body:
            line = mmc_strings_len1(line)
            if re.search(self.ptrnEq, line) is None:
                text_to_return.append( line )
            else:
                text_to_return.append( self.ptrnEq.sub(r'  f[%d] = \g<lhs> - ( \g<rhs> );' % self.getNumDyn(), line) )
        return text_to_return

    ##
    # Prepares the body of the equation to be used in evalFAdept function
    # @param self : object pointer
    # @return list of lines to print
    def getBodyFor_evalFAdept(self):
        text_to_return = []
        for line in self.body:
            line = mmc_strings_len1(line)
            line_tmp = line
            line_tmp = line_tmp.replace("modelica_real", "adept::adouble")
            line_tmp = line_tmp.replace("Greater(", "Greater<adept::adouble>(")
            line_tmp = line_tmp.replace("Less(", "Less<adept::adouble>(")
            line_tmp = line_tmp.replace("GreaterEq(", "GreaterEq<adept::adouble>(")
            line_tmp = line_tmp.replace("LessEq(", "LessEq<adept::adouble>(")
            line_tmp = line_tmp.replace("Greater)", "Greater<adept::adouble>)")
            line_tmp = line_tmp.replace("Less)", "Less<adept::adouble>)")
            line_tmp = line_tmp.replace("GreaterEq)", "GreaterEq<adept::adouble>)")
            line_tmp = line_tmp.replace("LessEq)", "LessEq<adept::adouble>)")
            if re.search(self.ptrnEq, line_tmp) is None:
                text_to_return.append( line_tmp )
            else:
                text_to_return.append( self.ptrnEq.sub(r'  res[%d] = \g<lhs> - ( \g<rhs> );' % self.getNumDyn(), line_tmp) )
        return text_to_return

##
# class Equation for non linear system
#
class EquationNLS(EquationBase):
    ##
    # default constructor
    # @param self : object pointer
    # @param body : body of the equation
    # @param eval_var : variable evaluated by the equation
    # @param depend_vars : variables used in the equation
    # @param comes_from : name of the function using the equation
    # @param num_omc : index of the equation in omc arrays
    def __init__(self, body = None, eval_var = None, depend_vars = None, comes_from = None, num_omc = None):
        EquationBase.__init__(self, body, eval_var, depend_vars, comes_from, num_omc)

    ##
    # Prepares the body of the equation to be used in setF function
    # @param self : object pointer
    # @return list of lines to print
    def getBodyFor_setF(self):
        text_to_return = copy.deepcopy( self.body )
        text_to_return.pop () # Remove the last line, replace it with the following
        text_to_return.append( "  f[%d] = %s" % (self.getNumDyn(), self.body[len(self.body) - 1]) )
        return text_to_return

    ##
    # Prepares the body of the equation to be used in evalFAdept function
    # @param self : object pointer
    # @return list of lines to print
    def getBodyFor_evalFAdept(self):

        text_to_return = copy.deepcopy( self.body )
        text_to_return.pop () # Remove the last line, replace it with the following
        text_to_return.append( "  res[%d] = %s" % (self.getNumDyn(), self.body[len(self.body) - 1]) )

        list_tmp = []
        for line in text_to_return:
            line_tmp = ""
            line_tmp = line.replace("modelica_real", "adept::adouble")
            line_tmp = line_tmp.replace("Greater(", "Greater<adept::adouble>(")
            line_tmp = line_tmp.replace("Less(", "Less<adept::adouble>(")
            line_tmp = line_tmp.replace("GreaterEq(", "GreaterEq<adept::adouble>(")
            line_tmp = line_tmp.replace("LessEq(", "LessEq<adept::adouble>(")
            line_tmp = line_tmp.replace("Greater)", "Greater<adept::adouble>)")
            line_tmp = line_tmp.replace("Less)", "Less<adept::adouble>)")
            line_tmp = line_tmp.replace("GreaterEq)", "GreaterEq<adept::adouble>)")
            line_tmp = line_tmp.replace("LessEq)", "LessEq<adept::adouble>)")
            list_tmp.append( line_tmp )

        text_to_return = list_tmp

        return text_to_return


##
# class Root Object: defining a when equation
#
class RootObject:
    ##
    # default constructor
    # @param self: object pointer
    # @param when_var_name : name of the when variable
    def __init__(self, when_var_name = None):
        ## pattern to identify RELATIONHYSTERESIS expression
        self.ptrnHyst = re.compile(r'RELATIONHYSTERESIS\(([^,]*),([^,]*),([^,]*),([^,]*),([^),]*)\)')

        ## name of the when variable
        self.whenVarName = ""

        ## body of the function evaluating the when condition
        self.bodyForNumRelation = []
        ## index of the object in dynawo arrays
        self.numDyn = "-1"

        ## index of the relation
        self.numRelation = "-1"

        ## Condition to evaluate for the when equation
        self.condition = ""

        ## Equations to evaluate if the condition is true
        self.blocksWhenCondIsTrue = []
        ## Equations to evaluate if the condition is False
        self.blockWhenEquation=[]

        if when_var_name is not None:
            self.whenVarName = when_var_name

    ##
    # Get the name of the when variable
    # @param self : object pointer
    # @return name of the when variable
    def getWhenVarName(self):
        return self.whenVarName

    ##
    # Get the index of the object in dynawo arrays
    # @param self : object pointer
    # @return index of the object
    def getNumDyn(self):
        return self.numDyn

    ##
    # Get the index of the relation
    # @param self: object pointer
    # @return index of the relation
    def getNumRelation(self):
        return self.numRelation

    ##
    # get the condition evaluated in the when equation
    # @param self: object pointer
    # @return condition evaluated
    def getCondition(self):
        return self.condition

    ##
    # Get the body evaluated when the condition is true
    # @param self: object pointer
    # @return list of code to evaluate
    def getBlocksWhenCondIsTrue(self):
        return self.blocksWhenCondIsTrue

    ##
    # Set the body of the function evaluating the when condition
    # @param self : object pointer
    # @param body : body of the function
    # @return
    def setBodyForNumRelation(self, body):
        self.bodyForNumRelation = body

    ##
    # Get the body of the function evaluating the when condition
    # @param self : object pointer
    # @return : body of the function
    def getBodyForNumRelation(self):
        return self.bodyForNumRelation

    ##
    # Prepare the body of the object to be print
    # @param self : object pointer
    # @return
    def prepareBody(self):
        # cleaning the block, removing the start and end braces
        new_body = []
        i = 0
        for line in self.bodyForNumRelation:
            if not has_Omc_trace (line) and not has_Omc_equationIndexes (line):
                if i != 0 and i != len(self.bodyForNumRelation)-1:
                    new_body.append(line)
            i = i + 1
        self.bodyForNumRelation = new_body


    ##
    # Filter the when condition in the bodies
    # @param self : object pointer
    # @param list_func_bodies : body to filter
    # @return
    def filterWhenCondBlocks(self, list_func_bodies):
        for body in list_func_bodies:
            block_to_extract = extract_block(body, ["if(", self.whenVarName])
            # I nothing is found in the body None is returned.
            if block_to_extract is not None :

                # Clean and replace....
                block_cleaned = []
                for line in block_to_extract:
                    line_cleaned = line.replace("time", "get_manager_time()")
                    block_cleaned.append(line_cleaned)

                self.blocksWhenCondIsTrue.append(  block_cleaned  )


    ##
    # Set the index of the object in dynawo arrays
    # @param self : object pointer
    # @param num : index of the object
    # @return
    def setNumDyn(self, num):
       self.numDyn = num

    ##
    # Set the condition of the when equation
    # @param self: object pointer
    # @param cond : condition of the when equation
    # @return
    def setCondition(self, cond):
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
    def setBody(self,body):
        self.body = body

    ##
    # Get the body of the equation
    # @param self : object pointer
    # @return body of the equation
    def getBody(self):
        return self.body

    ##
    # Get the name of the equation
    # @param self: object pointer
    # @return name of the equation
    def getName(self):
        return self.name


    ##
    # Prepare the body of the equation to be print
    # @param self : object pointer
    # @return
    def prepareBody(self):
        tmp_body=[]
        for line in self.body:
            line = mmc_strings_len1(line)
            if not has_Omc_equationIndexes (line):
                if "threadData" in line:
                    line=line.replace("threadData,", "")
                    tmp_body.append(line)
                    #removing of clean ifdef
                elif "#ifdef" not in line and "#endif" not in line \
                     and "SIM_PROF_" not in line and "NORETCALL" not in line \
                     and not has_Omc_trace (line):
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
    def setBody(self,body):
        self.body = body

    ##
    # Get the body of the equation
    # @param self : object pointer
    # @return body of the equation
    def getBody(self):
        return self.body

    ##
    # Get the name of the equation
    # @param self: object pointer
    # @return name of the equation
    def getName(self):
        return self.name

    ##
    # Prepare the body of the equation to be print
    # @param self : object pointer
    # @return
    def prepareBody(self):
        tmp_body=[]
        for line in self.body:
            line = mmc_strings_len1(line)
            if not has_Omc_equationIndexes (line):
                if "threadData" in line:
                    line=line.replace("threadData,", "")
                    tmp_body.append(line)
                    #removing of clean ifdef
                elif "#ifdef" not in line and "#endif" not in line \
                     and "SIM_PROF_" not in line and "NORETCALL" not in line \
                     and not has_Omc_trace (line):
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
        self.bodyFor_setF=[]

    ##
    # Prepare the body of the equation to be print
    # @param self : object pointer
    # @return
    def prepareBody(self):
        tmp_body = []
        # remove the start and end braces
        self.body.pop(0)
        self.body.pop()

        #################
        for line in self.body:
            line = throwStreamIndexes(line)
            line = mmc_strings_len1(line)
            line = line.replace("MMC_STRINGDATA","")
            if has_Omc_trace (line) or has_Omc_equationIndexes (line):
                continue
            elif "MMC_DEFSTRINGLIT" in line:
                line = line.replace("static const MMC_DEFSTRINGLIT(","")
                line = line.replace(");","")
                words = line.split(",")
                name_var = words[0]
                index =  words[1]
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
            elif "modelica_metatype tmpMeta" in line:
                words = line.split()
                line_tmp = " modelica_string "+str(words[1])+";\n"
                tmp_body.append(line_tmp)
            elif "FILE_INFO info" in line:
                continue;
            elif "omc_assert_warning" in line:
                line_tmp = line.replace("info, ","")
                tmp_body.append(line_tmp)
            else:
                tmp_body.append(line)

        self.bodyFor_setF=tmp_body

    ##
    # Get the body to print in setF function
    # @param self : object pointer
    # @return body to print in setF
    def getBodyFor_setF(self):
        return self.bodyFor_setF

##
# class Bool Equation : definition of a boolean variable
#
class BoolEquation:
    ##
    # default constructor
    # @param self : object pointer
    # @param name : name of the equation
    def __init__(self,name):
        ## body defining the equation
        self.body=[]
        ## name of the equation
        self.name=name

    ##
    # Set the body of the equation
    # @param self: object pointer
    # @param body : body of the equation
    # @return
    def setBody(self,body):
        self.body = body

    ##
    # Get the body of the equation
    # @param self : object pointer
    # @return body of the equation
    def getBody(self):
        return self.body

    ##
    # Get the name of the equation
    # @param self: object pointer
    # @return name of the equation
    def getName(self):
        return self.name

    ##
    # Prepare the body of the equation to be print
    # @param self : object pointer
    # @return
    def prepareBody(self):
        tmp_body=[]
        for line in self.body:
            line = mmc_strings_len1(line)
            if has_Omc_trace (line) or has_Omc_equationIndexes (line):
                continue

            tmp_body.append(line)

        self.body=tmp_body
