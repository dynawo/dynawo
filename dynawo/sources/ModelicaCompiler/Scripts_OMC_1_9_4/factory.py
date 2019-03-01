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

import sys
import itertools
import re
from dataContainer import *
from utils import *

##
# Predicate for the reading of the body in functions in main c file
# @param element : current line reading
# @return @b False if we read the body, @b True else
def stopReadingWhenPattern(element):
    when_return0 = re.compile(r'.*return 0;')
    if when_return0.search(element) == None:
        return True
    else:
        return False

##
# zeroCrossingFilter class : take G data, read and prepare them to be used in factory
#
class zeroCrossingFilter:
    ##
    # default constructor
    # @param self : object pointer
    # @param reader : object that reads input files
    def __init__(self, reader):
        ## object that read input files
        self.reader = reader
        ## List of lines that constitutes the G equation descriptions
        self.functionZeroCrossingDescription_rawFunc = []
        ## List of lines that constitutes the G equations
        self.functionZeroCrossings_rawFunc = []
        ## number of zero crossing/G equations
        self.numberOfZeroCrossings = 0

    ##
    # returns the lines that constitues the body of G equations descriptions
    # @param self : object pointer
    # @return list of lines
    def getFunctionZeroCrossingDescription_rawFunc(self):
        return self.functionZeroCrossingDescription_rawFunc

    ##
    # returns the lines that constitues the body of G equations
    # @param self : object pointer
    # @return list of lines
    def getFunctionZeroCrossings_rawFunc(self):
        return self.functionZeroCrossings_rawFunc

    ##
    # returns the number of zero crossing
    # @param self : object pointer
    # @return number of zero crossing
    def getNumberOfZeroCrossings(self):
        return self.numberOfZeroCrossings

    ##
    # remove fictitious when equations
    # @param self : object pointer
    def removeFictitiousGEquation(self):
        # Filtering the body lines of the function
        def filter_descData(line):
            if "return res[i];" not in line \
               and 'return "empty";' not in line\
               and "static const int" not in line \
               and "*out_EquationIndexes" not in line : return True
            return False

        filtered_func = []
        filtered_iter = itertools.ifilter( filter_descData, self.reader.functionZeroCrossingDescription_rawFunc.getBody() )
        filtered_func = list(filtered_iter)


        indexes_to_filter = []
        self.numberOfZeroCrossings = -2 #to ignore opening and closing {
        nb_zero_crossing_tot = -1; #to ignore opening {
        for line in filtered_func :
            if "time > 999999.0" not in line:
                self.functionZeroCrossingDescription_rawFunc.append(line)
                self.numberOfZeroCrossings +=1
            else:
                indexes_to_filter.append(nb_zero_crossing_tot)
                if "static const char *res[] =" in line and not "}" in line: #this is the first g equation and there is more than 1 equation
                    new_line = line.replace("\"time > 999999.0\",","")
                    new_line = new_line.rstrip()
                    self.functionZeroCrossingDescription_rawFunc.append(new_line)
                elif not "static const char *res[] =" in line and "}" in line: #this is the last g equation
                    new_line = line.replace("\"time > 999999.0\"","")
                    self.functionZeroCrossingDescription_rawFunc.append(new_line)
            nb_zero_crossing_tot +=1

        # Filtering the body lines of the function
        def filter_eqData(line):
            if "TRACE_PUSH" not in line \
                and "TRACE_POP" not in line \
                and "return 0;" not in line \
                and "data->simulationInfo->callStatistics.functionZeroCrossings++" not in line : return True
            return False
        #TODO ALSO REMOVE ASSOCIATED WHEN CONDITION
        filtered_func = []
        filtered_iter = itertools.ifilter( filter_eqData, self.reader.functionZeroCrossings_rawFunc.getBody() )
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
            self.functionZeroCrossings_rawFunc.append(line)


##
# Factory class: take datas, read and prepare them to print them in new file
#
class factory:
    ##
    # default constructor
    # @param self : object pointer
    # @param reader : object that reads input files
    def __init__(self, reader):
        ## object that read input files
        self.reader = reader

        ## All variables of the system : algebraic/state/alias
        self.listAllVars =[]
        ## variables of the system (same as listAllVars without alias)
        self.listVarsSyst = []

        ## List of derivatives variables
        self.listVarsDer = []
        ## List of discretes variables
        self.listVarsDiscr = []
        ## List of ALL discrete variables (including booleans)
        self.listAllVarsDiscr = []
        ## List of internal variables
        self.listVarsInt = []
        ## List of real parameters (external and internal)
        self.listParamsReal = []

        ## List of boolean parameters (external and internal)
        self.listParamsBool = []

        ## List of integer parameters (external and internal)
        self.listParamsInteger = []

        ## List of string parameters (external and internal)
        self.listParamsString = []

        ## List of boolean variables
        self.listVarsBool = []
        ## List of boolean variables defining when conditions
        self.listVarsWhen = []
        ## List of dummy variables
        self.listVarsDummy = []

        ## List of name of discrete variables
        self.listNameDiscreteVars = []
        ## List of name of integer variables
        self.listNameIntegerVars = []
        ## List of boolean variables names
        self.listNameBoolVars = []

        ## LIste of all boolean items
        self.listAllBoolItems = []

        ## map associating omc name with variable name in array [ $Pvar ou $P$DER$Pvar ] --> [ x[i], xd[i], z[i] or rpar[i] ]
        self.map_varOmc_varDyn_evalFAdept = {}

        ## List of functions which should not be written in output files
        self.eraseFunc = []

        ## List of elements
        self.listElements = []

        ## List of all equations
        self.listAllEquations = []
        ## List of equations evaluating variables
        self.listEqSyst = []
        # Map of reinit equations for continuous variables
        self.mapEqReinitContinuous = {}
        # Map of reinit equations for discrete variables
        self.mapEqReinitDiscrete = {}

        ## List of all equations which does not evaluate variables
        self.listOtherEq = []
        ## List of warnings
        self.listWarnings = []
        ## Number of equations of the system
        self.nbEqDyn = 0

        ## List of root function identified in the model
        self.listRootObjects = []
        ## Number of root function identified in the model
        self.nbRootObjects = []
        ## List of when root function  to filter
        self.listWhenEqToFilter = []
        ## List of discrete equations identified in the model
        self.listZEquations = []
        ## List of integer equations identified in the model
        self.listINTEquations = []
        ## List of boolean equations identified in the model
        self.listBoolEquations = []

        ## List of equations to add in setY0 function
        self.listFor_setY0 = []
        ## List of equations to add in setFOmc function
        self.listFor_setF = []
        ## List of equations to add in evalMode function
        self.listFor_evalMode = []
        ## List of equations to add in setZ function
        self.listFor_setZ = []
        ## List of equations to add in setG function
        self.listFor_setG = []
        ## List of equations to add in initRpar function
        self.listFor_initRpar = []
        ## List of equations to add in setupDataStruc function
        self.listFor_setupDataStruc = []
        ## List of equations to add in evalFAdept function
        self.listFor_evalFAdept = []
        ## List of equations to add in setSharedParamsDefault function
        self.listFor_setSharedParamsDefault = []
        ## List of equations to add in setParams function
        self.listFor_setParams = []
        ## List of equations to add in externalCalls function
        self.listFor_externalCalls = []
        ## List of equations to add in externalCallsHeader function
        self.listFor_externalCallsHeader =[]
        ## List of equations to add in fictiveEquations function
        self.listFor_fictEq = []
        ## List of equations to add in setYType function
        self.listFor_setYType = []
        ## List of equations to add in setFType function
        self.listFor_setFType = []
        ## List of equations to add in setVariables function
        self.listFor_setVariables = []
        ## List of equations to add in defineParameters function
        self.listFor_defineParameters = []
        ## List of equations to add in defineElements function
        self.listFor_defElem = []
        ## List of equations to define literal constants
        self.listFor_literalConstants = []
        ## List of equations to define warnings
        self.listFor_warnings = []
        ## List of formula of equations to define setFequations function
        self.listFor_setFequations = []
        ## List of formula of root equations to define setGequations function
        self.listFor_setGequations = []
        ## List of equations identified in main c file and in *_02nls.c
        self.listEqMakerMainCAndNLS = []

        ## List of variables definitions for generic header
        self.listFor_definitionHeader = []

        ## List of external call, called since setFomc
        self.listCallFor_setF =[]
        ## List of external call, called since setZomc
        self.listCallFor_setZ =[]

        ## fictitious G equation filter
        self.zc_filter = zeroCrossingFilter(self.reader)

    ##
    # Getter to obtain the list of system's variables
    # @param self : object pointer
    # @return list of system's variables
    def getVarsSyst(self):
        return self.listVarsSyst

    ##
    # Getter to obtain the number of dynamic equations
    # @param self : object pointer
    # @return number of dynamic equations
    def getNbEqDyn(self):
        return self.nbEqDyn

    ##
    # Getter to obtain all the equations defining the model
    # @param self : object pointer
    # @return list of equations
    def getListEqSyst(self):
        return self.listEqSyst

    def keepContinousModelicaReinit(self):
        return False

    ##
    # Getter to obtain all the equations linked with Modelica reinit for continuous variables
    # @param self : object pointer
    # @return list of equations
    def getMapEqReinitContinuous(self):
        return self.mapEqReinitContinuous

    ##
    # Getter to obtain all the equations linked with Modelica reinit for discrete variables
    # @param self : object pointer
    # @return list of equations
    def getMapEqReinitDiscrete(self):
        return self.mapEqReinitDiscrete

    ##
    # Getter to obtain all equations not defining the model
    # @param self : object pointer
    # @return list of equations
    def getListOtherEq(self):
        return self.listOtherEq

    ##
    # For each variables, give an index useful for omc array, initial value
    # Sort variables by type
    # @param self : object pointer
    # @return
    def buildVariables(self):
        # ---------------------------------------------------------
        # Improvement of information on variables
        # ---------------------------------------------------------
        # Warning: the treatments done by these 3 functions (of the reader) could be put back here, they do not belong
        # in the reader.

        # We assign an omc index to each var (thanks to *_model.h)
        self.reader.give_numOmc_to_vars()

        # We initialize vars of self.listVars with initial values found in *_06inz.c
        self.reader.setStartValueForSystVars06Inz()

        # We initialize vars of self.listVars with initial values found in *_08bnd.c
        self.reader.setStartValueForSystVars()

        # Set if the variables is internal or not
        initial_defined = self.reader.initial_defined

        list_vars_read = self.reader.listVars
        for var in list_vars_read:
            if var.getName() in initial_defined:
                var.setInternal(True)
            else:
                var.setInternal(False)


        # ----------------------------------------------
        # Merging
        # ----------------------------------------------
        # ... We group some vars into categories.
        # For filters, see dataContainer.py
        self.listVarsDer = filter (isDerRealVar, list_vars_read) # Derived from state vars
        self.listVarsDiscr = filter(isDiscreteRealVar, list_vars_read) # Vars discretes reelles
        self.listVarsInt = filter(isIntegerVar, list_vars_read) # vars entieres
        self.listVarsBool = filter(isBoolVar, list_vars_read) # Vars booleennes
        self.listVarsWhen = filter(isWhenVar, list_vars_read) # Vars when (bool & "$whenCondition")
        self.listVarsDummy = filter(isDummyVar, list_vars_read)

        self.listParamsReal = filter(isParamReal, list_vars_read) # Real Params (all)

        self.listParamsBool = filter(isParamBool, list_vars_read) # Params booleans (all)

        self.listParamsInteger = filter(isParamInteger, list_vars_read) # Full Params (all)
        self.listParamsString = filter(isParamString, list_vars_read) # Params string (all)

        ## Removing of WhenVar bool variables, we only keep "real" boolean variables
        tmp_var = []
        for var in self.listVarsBool:
            if var not in self.listVarsWhen:
                tmp_var.append(var)
        self.listVarsBool = tmp_var

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

        self.listVarsSyst = filter(isSystVar, list_vars_read)
        self.listAllVars = filter(isVar, list_vars_read)
        tmp_list = []
        for var in self.listAllVars:
            if var not in self.listVarsWhen:
                tmp_list.append(var)
        self.listAllVars = tmp_list
        self.listAllVarsDiscr = self.listVarsDiscr + self.listVarsBool

        ## type of each variables
        self.varByType = {}
        for var in list_vars_read:
            type_var = var.getType()
            self.varByType[var.getName()] = type_var

        # ----------------------------------------------
        # Order: according to the their number in *_model.h
        # ----------------------------------------------
        self.listParamsReal.sort(cmp = cmp_numOmc_vars)
        self.listParamsBool.sort(cmp = cmp_numOmc_vars)
        self.listParamsInteger.sort(cmp = cmp_numOmc_vars)
        self.listParamsString.sort(cmp = cmp_numOmc_vars)
        self.listVarsBool.sort(cmp = cmp_numOmc_vars)
        self.listVarsDer.sort(cmp = cmp_numOmc_vars)
        self.listAllVarsDiscr.sort(cmp = cmp_numOmc_vars)
        self.listVarsInt.sort(cmp = cmp_numOmc_vars)
        self.listVarsSyst.sort(cmp = cmp_numOmc_vars)

        self.listAllBoolItems = sorted (self.listVarsBool + self.listParamsBool, cmp = cmp_numOmc_vars)

        # ------------------------------------------------------------------
        # We gather the $Pvar --> x[i], xd[i]
        # ------------------------------------------------------------------
        # ... The state vars, state var derivatives, discrete vars and parametres can,
        # in some functions of DYNAWO (evalFAdept (...)), be
        # designated by another expression:
        #    - state vars : $Pvar --> x[i]
        #    - state var derivatives: $P$DER$Pvar --> xd[i]
        # The following gives this expression for each type of vars
        # ------------------------------------------------------------------------
        for v in self.listAllVars:
            v.setDynType()

        i = 0
        for v in self.listVarsDer:
            v.setDynawoName( "xd[%s]" % str(i) )
            i += 1

        i = 0
        for v in self.listAllVarsDiscr:
            v.setDynawoName( "z[%s]" % str(i) )
            if (v not in self.listVarsBool):
                v.setDiscreteDynType()
            i += 1

        i = 0
        for v in self.listVarsInt:
            v.setDynawoName( "i[%s]" %str(i) )
            i += 1

        i = 0
        for v in self.listVarsSyst:
            v.setDynawoName( "x[%s]" % str(i) )
            i += 1

        i = 0
        # only for real parameters!
        for v in self.listParamsReal:
            v.setDynawoName( "rpar[%s]" % str(i) )
            i += 1

        # Assignement of the type "FLOW" to certain vars thanks to information from the reader
        list_flow_vars = self.reader.list_flow_vars
        for v in self.listVarsDiscr + self.listVarsSyst :
            var_name = v.getName()
            if var_name in list_flow_vars : v.setFlowDynType()

        # Filling ot the map giving [ $Pvar or $P$DER$Pvar ] --> [  x[i] ou xd[i]]
        # for the construction of evalFAdept (the vars are left as they are)
        # no need to do it for booleans
        for v in self.listVarsDer + self.listVarsSyst:
            self.map_varOmc_varDyn_evalFAdept[ to_omc_style(v.getName()) ] = v.getDynawoName()

        # List of names of discrete vars
        for v in self.listAllVarsDiscr:
            self.listNameDiscreteVars.append( v.getName() )


        # List of names of integer vars
        for v in self.listVarsInt:
            self.listNameIntegerVars.append( v.getName() )

    ##
    # build the list of all elements
    # @param self : object pointer
    # @return
    def buildElements(self):
        # ----------------------------------------------------------------------------------
        # Building info for the generation of C ++ methods defineElements(...)
        # ----------------------------------------------------------------------------------
        ## everything is done on reading
        self.listElements = self.reader.list_elements

    ##
    # Build equation from functions found in main c file
    # @param self : object pointer
    # @return
    def buildEquationsFromMainC(self):
        pass

    ##
    # Build equation from functions found in *_03lsy.c file
    # @param self : object pointer
    # @return
    def buildEquationsFrom_03lsy(self):
        pass

    ##
    # Build equation from functions found in *_02nls file
    # @param self : object pointer
    # @return

    def buildEquationsFrom_02nls(self):
        pass

    ##
    # Sort external function depending on where they are called:
    # If they are called in functionDAE => original call in a when equation => insert in setZOMC
    # If they are called in eqFunction => insert in setFOMC
    # Native functions such as omc_assert and omc_terminate are also concerned
    # @param self : object pointer
    # @return
    def buildCallFunctions(self):
        map_tags_num_eq = self.reader.getMap_tag_numEq()
        list_omc_functions = self.reader.listOmcFunctions
        name_func_to_search = ["omc_assert", "omc_terminate"]
        for func in list_omc_functions:
            name_func_to_search.append(func.getName())

        # Analysis of MainC functions => if external call => will be added to setFOMC
        list_body_to_analyse = []
        body_to_add = []

        for eq_mak in self.listEqMakerMainCAndNLS:
            tag = find_value_in_map( map_tags_num_eq, eq_mak.getNumOmc() )
            if eq_mak.getEvaluatedVar() == "" and tag != 'when':
                # call to a function and not evaluation of a variable
                body = eq_mak.getBody()
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
                body_to_add.append(False)

        # functions calling an external function ???
        num_body = 0
        for body in list_body_to_analyse:
            for name in name_func_to_search:
                if any(name in line for line in body):
                    body_to_add[num_body] = True
                    break

            num_body += 1

        # Add the functions concerned
        num_body = 0
        for body in list_body_to_analyse:
            if body_to_add[num_body]:
                self.listCallFor_setF.append('  {\n')
                self.listCallFor_setF.extend(body)
                self.listCallFor_setF.append('  }\n')
            num_body +=1


        # Function analysis, if tag when: external call
        for eq_mak in self.listEqMakerMainCAndNLS:
            tag = find_value_in_map( map_tags_num_eq, eq_mak.getNumOmc() )
            if (tag == 'when' and not eq_mak.getIsModelicaReinit()):
                body = eq_mak.getBody()
                body_tmp = []
                for line in body:
                    if "threadData" in line:
                        line = line.replace("threadData,", "")
                        body_tmp.append(line)
                    #removing of clean ifdef
                    elif "#ifdef" not in line and "#endif" not in line \
                            and "SIM_PROF_" not in line and "NORETCALL" not in line:
                        body_tmp.append(line)
                if any(ext in " ".join(body_tmp) for ext in self.listWhenEqToFilter):
                    continue
                self.listCallFor_setZ.extend(body_tmp)

    ##
    # Take the equations found by the read and sort them
    # Change their expression and transforms them in residual function
    # @param self : object pointer
    # @return
    def buildEquations(self):
        # Recovery of the map [var name evaluated] --> [ Func / Eq number in *_info.xml]
        # In the "equations" section of *_info.xml, each equation defines the value
        # of a var with respect to other vars. The name of the evaluated var is in the attribut "defines".
        # We can thus associate the name of the evaluated var with the number of the equation which evaluates it.
        # This map is then used to determine, for each function of a C file, the name of the var it evaluates.
        # Warning:
        # The case of linear and nonlinear systems is particular concerning the determination
        # of the evaluated var considering that several equations must leave a function (see + far).
        map_vars_num_eq = self.reader.getMap_vars_numEq()
        map_num_eq_vars_defined = self.reader.getMap_numEq_vars_defined()


        ##########################################################
        # Equations from main *.c file
        ##########################################################
        # List of equations from main *.c file
        list_eq_maker_main_c = []

        # index of functions calling the resolution of LS or NLS in main *.c file
        list_num_func_to_remove = []

        # Removing functions involving linear or non-linear
        # systems in the list of functions read in the main *.c file
        # These functions are covered later.
        list_num_func_to_remove = self.reader.linearEqNums + self.reader.nonLinearEqNums

        # Build the eqMaker for functions of the main *.c file
        for f in self.reader.listFuncMainC:
            if f.getNumOmc() not in list_num_func_to_remove:
                eq_maker = EqMaker(f)
                list_eq_maker_main_c.append( eq_maker )

        # Find, for each function of the main *.c file :
        # - the variable it evaluates
        # - the vars on which it depends to evaluate this variable
        map_dep = self.reader.get_mapDepVarsForFunc()
        for eq_mak in list_eq_maker_main_c:
            eq_mak_num_omc = eq_mak.getNumOmc()
            name_var_eval = find_key_in_map( map_vars_num_eq, eq_mak_num_omc)

            # for Modelica reinit equations, the evaluated var scan does not always work
            # a fallback is to look at the variable defined in this case
            if (name_var_eval is None) and (eq_mak.getIsModelicaReinit())\
               and (eq_mak_num_omc in map_num_eq_vars_defined.keys()) \
               and (len(map_num_eq_vars_defined[eq_mak_num_omc]) == 1):
                name_var_eval = map_num_eq_vars_defined[eq_mak_num_omc] [0]

            list_depend = [] # list of vars on which depends the function
            if name_var_eval is not None:
                eq_mak.setEvaluatedVar(name_var_eval)
                list_depend.append(name_var_eval) # The / equation function depends on the var it evaluates
                if name_var_eval in map_dep.keys():
                    list_depend.extend( map_dep[name_var_eval] ) # We get the other vars (from *._info.xml)
                eq_mak.setDependVars(list_depend)

        # Build an equation for each function in the main *.c file
        for eq_mak in list_eq_maker_main_c:
            eq_mak.prepareBodyForEquation()
            self.listAllEquations.append( eq_mak.createEquation() )
            self.listEqMakerMainCAndNLS.append(eq_mak)


        ##########################################################
        # Equations from *_03lsy.c (LS)
        ##########################################################

        #######################################################################
        # Warning :
        # *********
        # For system eqs from LS or NLS,
        # the list of vars on which the equation depends could bu useless
        # (to check), like the the one of evaluated vars
        # ===> See where they are used and remove the corresponding code
        #          here or in "dataContainer.py" if the uselessness is confirmed
        #######################################################################

        map_mat_rhs = {} # Association of RawFunc objects.
        list_eq_maker_ls = []

        # Associate matrices with rhs in a map using objects of type RawFunc.
        # Objects RawFunc of matrices and rhs come from the read of *_03lsy.c file.
        for mat_fct in self.reader.listFuncLS_mat:
            for rhs_fct in self.reader.listFuncLS_rhs:
                if rhs_fct.getNumOmc() == mat_fct.getNumOmc():
                    map_mat_rhs[mat_fct] = rhs_fct
                    break

        # Build eqMaker for LS
        for mat_fct in self.reader.listFuncLS_mat:
            list_eq_maker_ls.append(  EqMakerLS(mat_fct, map_mat_rhs[mat_fct])  )

        # Determine, for each LS, the vars it evaluates
        for eq_mak in list_eq_maker_ls:
            raw_list_vars = []
            eq_mak_to_keep = True
            # Here, we do not have a single var evaluated, but several (all the vars intervening in the LS).
            raw_list_vars = find_keys_in_map (map_vars_num_eq, eq_mak.getNumOmc())
            ordered_list_vars = self.reader.LinearSystemCalculatedVariables (eq_mak.getNumOmc())
            # If the list of evaluated vars is empty, it is an LS for the initialization step
            # that openModelica implements for its own simulations.
            # WARNING: ordered_list_vars is never empty
            # We do not need it. We will delete it below.
            if raw_list_vars == [] :
                eq_mak_to_keep = False

            if eq_mak_to_keep:
                eq_mak.setEvaluatedVars(ordered_list_vars)
                eq_mak.getInfosForLSeq()
                eq_mak.prepareBodiesForEquations()
                self.listAllEquations.extend( eq_mak.createEquations() )

        # List of eqMaker of "type NLS" (residualFunc and eqFunction)
        # in *_03lsy.c file and called in residual functions really used
        # in this file
        list_nls_typeclassic_eq_maker = []

        list_eq_maker_nls_type = [] # eqMaker of residual functions really used
        list_eq_to_remove = [] # eqMaker of residual functions never used (see 2.)

        # List of the numbers of the classic functions to take into account in our
        # system of equations (these functions are called from the residual functions)
        list_num_eq_classic = []

        #    Build eqMaker for residual functions of *_03lsy.c
        for f in self.reader.listLSresFunc:
            list_eq_maker_nls_type.append(  EqMakerNLS(f)  )


        # One of the residual functions is selected
        # which serve for the resolution of our system: we eliminate those of the initialization phase
        # that openModelica implements for its own simulations.
        # We take the opportunity to establish the list of vars evaluated by the residual function.
        for eq_mak in list_eq_maker_nls_type:
            list_vars = []
            # Here, we do not have one evaluated var, but several (all the vars intervening in the NLS).
            # Recovery of NLS vars (i.e. evaluated vars).
            list_vars = find_keys_in_map( map_vars_num_eq, eq_mak.getNumOmc() )

            # If the list of evaluated vars is empty, it is an NLS for the initialization step
            # that openModelica implements for its own simulations.
            # We do not need it. We will delete it below
            if list_vars == [] : list_eq_to_remove.append(eq_mak)
            else: eq_mak.setEvaluatedVars(list_vars) # So this would be useless ??

        for em in list_eq_to_remove : list_eq_maker_nls_type.remove(em)

        #    We recover the indices of clasical functions *_eqFunction_${num}
        # in the body of selected residual functions
        #    While we are at it we:
        # - Create the list of variables ("tmp" or not) on which depends the equations to create
        # - Determine the variable that the equations to create evaluate (artificial:
        # the LS contains n equations with n unknowns. These unknowns are arbitrarily attributed to
        # one of the equations to create)
        # - Prepare the body of the function for the creation (later) of the equations
        #    - ...
        for eq_mak in list_eq_maker_nls_type:
            eq_mak.getInfosForNLSeq()
            eq_mak.setNumEqClassic()
            eq_mak.prepareBodiesForEquations()
            list_num_eq_classic.extend( eq_mak.getNumEqClassic() )


        #    Build eqMaker for classic functions of *_03lsy.c
        for f in self.reader.listLSclassicFunc:
            if f.getNumOmc() in list_num_eq_classic:
                list_nls_typeclassic_eq_maker.append( EqMaker(f) )

        #    Determine, for each classic function of *_03lsy.c:
        # - the variable it evaluates
        # - the vars on which it depends to evaluate this variable
        map_dep = self.reader.get_mapDepVarsForFunc()
        for eq_mak in list_nls_typeclassic_eq_maker:
            name_var_eval = find_key_in_map( map_vars_num_eq, eq_mak.getNumOmc() )
            list_depend = [] # list of vars on which depends the function
            if name_var_eval is not None:
                eq_mak.setEvaluatedVar(name_var_eval)
                list_depend.append(name_var_eval) # The / equation function depends on the var it evaluates
                list_depend.extend( map_dep[name_var_eval] ) # We get the other vars (from *._info.xml)
                eq_mak.setDependVars(list_depend)


        #    Building equations associated to each classic function of *_02nls.c
        for eq_mak in list_nls_typeclassic_eq_maker:
            eq_mak.prepareBodyForEquation()
            self.listAllEquations.append( eq_mak.createEquation() )

        # 7. Building equations associated to each residual function of *_02nls.c
        for eq_mak in list_eq_maker_nls_type:
            self.listAllEquations.extend( eq_mak.createEquations() )

        ##########################################################
        # Equations from *_02nls.c (NLS)
        ##########################################################

        #######################################################################
        # Warning :
        # *********
        # For system eqs from LS or NLS,
        # the list of vars on which the equation depends could but useless
        # (to check), like the one of the evaluated vars
        # ===> See where they are used and remove the corresponding code
        #          here or in "dataContainer.py" if the uselessness is confirmed
        #######################################################################


        # List of eqMaker for classic functions (similar to those in main *.c file)
        # in *_02nls.c and called in residual functions really used
        # of this file
        # warning, sometimes classic functions are defined only in *_02nls.c
        # and only declared in the main *.c file
        list_nls_classic_eq_maker = []

        list_eq_maker_nls = [] # eqMaker of residual functions really used
        list_eq_to_remove = [] # eqMaker of residual functions never used (see 2.)

        # List of numbers of the classic functions to take into account in our
        # system of equations (these functions are called from the residual functions)
        list_num_eq_classic = []

        # 1. Build eqMaker for residual functions of *_02nls.c
        for f in self.reader.listNLSresFunc:
            list_eq_maker_nls.append(  EqMakerNLS(f)  )


        # ---------------------------------------------------------------------
        # This part 2 could (to be verified) prove useless
        # ---------------------------------------------------------------------
        # 2. We select among the residual functions those
        # which are used for the resolution of our system: we eliminate those of the initialization phase
        # that openModelica implements for its own simulations.
        # We take the opportunity to establish the list of vars evaluated by the residual function.
        for eq_mak in list_eq_maker_nls:
            list_vars = []
            # Here, we dot not have one evaluated var, but several (all the vars used in the NLS).
            # Recovery of NLS vars (i.e. evaluated vars).
            list_vars = find_keys_in_map( map_vars_num_eq, eq_mak.getNumOmc() )

            # If the list of evaluated vars is empty, it is an NLS for the initialization step
            # that openModelica implements for its own simulations.
            # We do not need it. We will delete it below
            if list_vars == [] : list_eq_to_remove.append(eq_mak)
            else: eq_mak.setEvaluatedVars(list_vars) # So this would be useless ??

        for em in list_eq_to_remove : list_eq_maker_nls.remove(em)

        # 3. We get the indices of classic functions *_eqFunction_${num}
        # in the body of selected residual functions
        # While we are at it we:
        # # - Create the list of variables ("tmp" or not) on which depends the equations to create
        # - Determine the variable that the equations to create evaluate (artificial:
        # The NLS contains n equations with n unknowns. These unknowns are arbitrarily attributed
        # has one of the equations to create)
        # - Prepare the body of the function for the creation (later) of the equations
        #    - ...
        for eq_mak in list_eq_maker_nls:
            eq_mak.getInfosForNLSeq()
            eq_mak.setNumEqClassic()
            eq_mak.prepareBodiesForEquations()
            list_num_eq_classic.extend( eq_mak.getNumEqClassic() )


        # 4. Build eqMaker for classic functions in *_02nls.c
        # For now, each classic function defined in *_02nls.c instead of *.c is used
        # in residual functions
        for f in self.reader.listNLSclassicFunc:
            if f.getNumOmc() in list_num_eq_classic:
                list_nls_classic_eq_maker.append( EqMaker(f) )

        # -----------------------------------------------------------
        # This part 5 could (to be verified) prove to be completely useless
        # -----------------------------------------------------------
        # 5. Find, for each classic of *_02nls.c:
        # - the variable it evaluates
        # - the vars on which it depends to evaluate this variable
        map_dep = self.reader.get_mapDepVarsForFunc()
        for eq_mak in list_nls_classic_eq_maker:
            name_var_eval = find_key_in_map( map_vars_num_eq, eq_mak.getNumOmc() )
            list_depend = [] # list of vars on which depends the function
            if name_var_eval is not None:
                eq_mak.setEvaluatedVar(name_var_eval)
                list_depend.append(name_var_eval) # The / equation function depends on the var it evaluates
                list_depend.extend( map_dep[name_var_eval] ) # We get the other vars (from *._info.xml)
                eq_mak.setDependVars(list_depend)


        # 6. Building of equations associated to each classic function in *_02nls.c
        for eq_mak in list_nls_classic_eq_maker:
            eq_mak.prepareBodyForEquation()
            self.listAllEquations.append( eq_mak.createEquation() )
            self.listEqMakerMainCAndNLS.append(eq_mak)

        # 7. Building of equations associated to each residual function in *_02nls.c
        for eq_mak in list_eq_maker_nls:
            self.listAllEquations.extend( eq_mak.createEquations() )

        ##########################################################

        # ---------------------------------------------------------------------
        # The equations of the system to solve (in DYNAWO)
        # ---------------------------------------------------------------------
        # We recover the equations which will be used to constitute the system to be solved

        # ... We concatene the vars syst (state + alg) and the vars der (state),
        # and we recover the equations associated with these vars, that is to say
        # the equations that evaluate these vars.
        list_vars_for_sys_build = itertools.chain(self.listVarsSyst, self.listVarsDer)
        for var in list_vars_for_sys_build:
            for eq in filter(lambda x: (not x.getIsModelicaReinit()) and (x.getEvaluatedVar() == var.getName()), self.listAllEquations):
                self.listEqSyst.append(eq)

        for eq in self.listAllEquations:
            if eq.getEvaluatedVar() =="" and eq.withThrow():
                warning = Warn(warning)
                warning.prepareBody()
                self.listWarnings.append(warning)

        #... Sort the previous functions with their index in the main *.c file (and other *.c)
        self.listEqSyst.sort(cmp = cmp_equations)

        # ... we give them a number for DYNAWO
        i = 0 # num dyn of the equation
        for eq in self.listEqSyst:
            var_name = eq.getEvaluatedVar()
            if var_name not in self.reader.fictiveContinuousVarsDer:
                eq.setNumDyn(i)
                i += 1
            else:
                eq.setNumDyn (-1) # can detect bugs
        self.nbEqDyn = i

        # ---------------------------------------------------------------------
        # Equations due to Modelica reinit commands
        # ---------------------------------------------------------------------
        # We retrieve all equations due to Modelica reinit commands
        for var in self.listVarsSyst + self.listAllVarsDiscr + self.listVarsInt:
            #retrieve the num_dyn attribute : retrieve the equation linked with the current variable
            num_dyn = None
            for eq_standard in filter(lambda x: (not x.getIsModelicaReinit()) \
                                      and ((x.getEvaluatedVar() == var.getName()) or (x.getEvaluatedVar() == 'der(' + var.getName() + ')')), self.listAllEquations):
                num_dyn = eq_standard.getNumDyn()
                break

            # retrieve all Modelica reinit equations linked with the current variable
            for eq in filter(lambda x: x.getIsModelicaReinit() \
                             and ((x.getEvaluatedVar() == var.getName()) or (x.getEvaluatedVar() == 'der(' + var.getName() + ')')), self.listEqMakerMainCAndNLS):
                equation = Equation (eq.getBody(), eq.getEvaluatedVar(), eq.getDependVars(), eq.getNumOmc())
                if (num_dyn is not None):
                    equation.setNumDyn(num_dyn)

                if (var in self.listVarsSyst):
                    if var.getName() not in self.mapEqReinitContinuous:
                        self.mapEqReinitContinuous [var.getName()] = []
                    self.mapEqReinitContinuous[var.getName()].append(equation)
                elif (var in self.listAllVarsDiscr + self.listVarsInt):
                    if (var.getName()) not in self.mapEqReinitDiscrete:
                        self.mapEqReinitDiscrete [var.getName()] = []
                    self.mapEqReinitDiscrete [var.getName()].append(equation)
                else:
                    errorExit('bad Modelica reinit equation : ' + eq.getBody())


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
        #      The list of whenCondition vars is already built above (in "buildVariables()").
        # At this point, we know which relations concern whenCondition (we can forget the others)
        # and therefore knows the number of relationships to keep
        #    - With this, we can create objects of type "Relations"
        # - Then we recover the eqMaker (or eq?) Functions evaluating the discrete vars
        #      and we send their body in the good "Relations" objects
        #

        # Creation of the rootObject list

        for v in self.listVarsWhen :
            self.listRootObjects.append( RootObject(v.getName()) )

        for r_obj in self.listRootObjects:
            # For the current when variable, search for the body of the function
            # which evaluates the variable whenCondition (for, later, retrieve the number of relationship associated with the
            # var whenCondition)
            for eq_mak in self.listEqMakerMainCAndNLS:
                if r_obj.getWhenVarName() == eq_mak.getEvaluatedVar():
                    r_obj.setBodyForNumRelation( eq_mak.getRawBody() )
                    break
            r_obj.prepareBody()

        # List of function fields evaluating discrete vars
        list_func_bodies_discr = []
        list_func_bodies_discr_names = {}

        for v in self.listAllVarsDiscr:
            for eq_mak in self.listEqMakerMainCAndNLS:
                if v.getName() == eq_mak.getEvaluatedVar():
                    list_func_bodies_discr.append( eq_mak.getBody() )
                    list_func_bodies_discr_names[v.getName()]=eq_mak.getBody()
                    break

        # List of function bodies evaluating integer vars
        list_func_bodies_int = []
        list_func_bodies_int_names = {}

        for v in self.listVarsInt:
            for eq_mak in self.listEqMakerMainCAndNLS:
                if (v.getName() == eq_mak.getEvaluatedVar()) and (not eq_mak.getIsModelicaReinit()):
                    list_func_bodies_int.append( eq_mak.getBody() )
                    list_func_bodies_int_names[v.getName()]= eq_mak.getBody()
                    break

        i = 0
        self.nbRootObjects = 0
        self.listWhenEqToFilter = []
        for r_obj in self.listRootObjects:
            # we assign a DYNAWO number (from 0 -> nb vars whenCondition) to each variable whenCondition
            r_obj.setNumDyn(i)


            # For each RootObject (or each var whenCondition), we review the bodies
            # of function evaluating the discrete vars and we extract the pieces executed
            # when the whenCondition is checked.
            r_obj.filterWhenCondBlocks( list_func_bodies_discr )

            if re.search(r'RELATIONHYSTERESIS\(tmp[0-9]+, data->localData\[0\]->timeValue, 999999.0, [0-9]+, Greater\);',transformRawbodyToString(r_obj.getBodyForNumRelation())):
                r_obj.setNumDyn(-1)
                self.listWhenEqToFilter.append(str(r_obj.getWhenVarName())+" ")
                continue

            #r_obj.printWhenEquation()
            self.nbRootObjects += 1
            i += 1

        # preparation of blocks for setZ
        keys = list_func_bodies_discr_names.keys()
        for key in keys:
            z_equation = ZEquation(key)
            z_equation.setBody(list_func_bodies_discr_names[key])
            z_equation.prepareBody()
            if any(ext in " ".join(z_equation.getBody()) for ext in self.listWhenEqToFilter):
                continue
            self.listZEquations.append(z_equation)

        # add Modelica reinit equations
        for var_name, eq_list in self.getMapEqReinitDiscrete().iteritems():
            for eq in eq_list:
                z_equation = ZEquation("reinit for " + var_name)
                z_equation.setBody(eq.getBodyFor_ModelicaReinitAffectation())
                z_equation.prepareBody()
                if any(ext in " ".join(z_equation.getBody()) for ext in self.listWhenEqToFilter):
                    continue
                self.listZEquations.append(z_equation)

        # add integer equations to setZ
        keys = list_func_bodies_int_names.keys()
        for key in keys:
            int_equation = INTEquation(key)
            int_equation.setBody(list_func_bodies_int_names[key])
            int_equation.prepareBody()
            self.listINTEquations.append(int_equation)

        # preparation of the blocks for the assignment of the variables bool (except whenEquation)
        list_func_bodies_bool_names={}
        for v in self.listVarsBool:
            for eq_mak in self.listEqMakerMainCAndNLS:
                if v.getName() == eq_mak.getEvaluatedVar():
                    list_func_bodies_bool_names[v.getName()]=eq_mak.getBody()
                    break

        keys =  list_func_bodies_bool_names.keys()
        for key in keys:
            bool_equation = BoolEquation(key)
            bool_equation.setBody(list_func_bodies_bool_names[key])
            bool_equation.prepareBody()
            self.listBoolEquations.append(bool_equation)


    ##
    # Change the expression of warnings and assert in order to add them to evalF
    # @param self : object pointer
    # @return
    def buildWarnings(self):
        # omc_assert
        warnings = self.reader.warnings
        for warning in warnings:
            warning = Warn(warning)
            warning.prepareBody()
            self.listWarnings.append(warning)


    ##
    # prepare the equations/variables for setY0 methods
    # @param self : object pointer
    # @return
    def prepareFor_setY0(self):
        # In addition to system vars, discrete vars (bool or not) must be initialized as well
        # We concatenate system vars and discrete vars
        list_vars = itertools.chain(self.listVarsSyst, self.listAllVarsDiscr, self.listVarsInt)
        found_init_by_param_and_at_least2lines = False # for reading comfort when printing

        # sort by taking init function number read in *06inz.c
        list_vars = sorted(list_vars,cmp = cmp_numInit_vars)
        # We prepare the results to print in setY0omc
        for var in list_vars:
            if var.getUseStart():
                init_val = var.getStartText()[0]
                if init_val == "":
                    init_val = "0.0"
                line = "    %s = %s;\n" % ( to_omc_style(var.getName()), init_val )
                self.listFor_setY0.append(line)

            elif var.getInitByParam (): # If the var was initialized with a param (not with an actual value)
                var.cleanStartText () # Clean up initialization text before printing

                # Lines for reading comfort at the impression
                if len(var.getStartText()) > 1 :
                    if not found_init_by_param_and_at_least2lines:
                        self.listFor_setY0.append("\n")
                    found_init_by_param_and_at_least2lines = True
                else : found_init_by_param_and_at_least2lines = False

                for L in var.getStartText() :
                   self.listFor_setY0.append("  " + L)

                if len(var.getStartText()) > 1 : self.listFor_setY0.append("\n") # reading comfort

            elif var.getInitByParamIn06Inz():
                var.cleanStartText06Inz()

                # Lines for reading comfort at the impression
                if len(var.getStartText06Inz()) > 1 :
                    if not found_init_by_param_and_at_least2lines:
                        self.listFor_setY0.append("\n")
                    found_init_by_param_and_at_least2lines = True
                else : found_init_by_param_and_at_least2lines = False

                self.listFor_setY0.append("  {\n")
                for L in var.getStartText06Inz() :
                    self.listFor_setY0.append("  " + L)
                self.listFor_setY0.append("  }\n")

                if len(var.getStartText06Inz()) > 1 : self.listFor_setY0.append("\n") # reading comfort

            else:
                init_val = var.getStartText()[0]
                if init_val == "":
                    init_val = "0.0"
                line = "    %s = %s;\n" % ( to_omc_style(var.getName()), init_val )
                self.listFor_setY0.append(line)

                # for reading comfort when printing
                found_init_by_param_and_at_least2lines = False

        # convert native boolean variables
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems], self.listFor_setY0)

    ##
    # return the list of lines that constitues the body of setY0
    # @param self : object pointer
    # @return list of lines
    def getListFor_setY0(self):
        for line in self.listFor_setY0:
            if "omc_Modelica_Math_atan3" in line:
                index = self.listFor_setY0.index(line)
                line_tmp = transformAtan3Operator(line)
                self.listFor_setY0.pop(index)
                self.listFor_setY0.insert(index,line_tmp)
        return self.listFor_setY0


    ##
    # prepare the lines that constitues the body of setF
    # @param self : object pointer
    # @return
    def prepareFor_setF(self):
        ptrn_f_name ="  // ----- %s -----\n"
        map_eq_reinit_continuous = self.getMapEqReinitContinuous()
        for eq in self.getListEqSyst() + self.getListOtherEq():
            var_name = eq.getEvaluatedVar()
            var_name_without_der = var_name [4 : -1] if 'der(' == var_name [ : 4] else var_name
            if var_name not in self.reader.fictiveContinuousVarsDer:
                standard_eq_body = []
                standard_eq_body.append (ptrn_f_name %(eq.getSrcFctName()))
                standard_eq_body.extend(eq.getBodyFor_setF())

                if self.keepContinousModelicaReinit() and ((var_name in map_eq_reinit_continuous) or (var_name_without_der in map_eq_reinit_continuous)):
                    var_name_modelica_reinit = var_name if var_name in map_eq_reinit_continuous else var_name_without_der
                    eq_list = map_eq_reinit_continuous [var_name_modelica_reinit]
                    first_eq = True
                    self.listFor_setF.append("  //reinit equations for " + var_name_modelica_reinit + "\n")
                    for eq in eq_list:
                        if (not first_eq):
                            self.listFor_setF.append("  else ")
                        self.listFor_setF.extend(eq.getBodyFor_setF())
                        self.listFor_setF.extend("\n")
                        first_eq = False
                    self.listFor_setF.append("  else \n")
                    self.listFor_setF.append("  {\n")
                    self.listFor_setF.extend(standard_eq_body)
                    self.listFor_setF.append("  }")
                else:
                    self.listFor_setF.extend(standard_eq_body)
                self.listFor_setF.append("\n\n")

        for warn in self.listWarnings:
            self.listFor_warnings.append("{\n")
            self.listFor_warnings.extend(warn.getBodyFor_setF())
            self.listFor_warnings.append("\n\n")
            self.listFor_warnings.append("}\n")

        if len(self.listCallFor_setF) > 0:
            self.listFor_setF.append("  // -------------- call functions ----------\n")
            for line in self.listCallFor_setF:
                line = mmc_strings_len1(line)
                line = throwStreamIndexes(line)
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
                    self.listFor_setF.append(line_tmp)
                elif "MMC_REFSTRINGLIT" in line:
                    line = line.replace("MMC_REFSTRINGLIT","")
                    self.listFor_setF.append(line)
                elif "modelica_metatype tmpMeta" in line:
                    words = line.split()
                    line_tmp = " modelica_string "+str(words[1])+";\n"
                    self.listFor_setF.append(line_tmp)
                elif ("TRACE_PUSH" not in line) and ("TRACE_POP" not in line) and ("const int equationIndexes[2]" not in line):
                    self.listFor_setF.append(line)

            self.listFor_setF.append("\n\n")

        # convert native boolean variables
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems], self.listFor_setF)

        # remove atan3, replace pow by pow_dynawo
        for index, line in enumerate(self.listFor_setF):
            if "omc_Modelica_Math_atan3" in line:
                self.listFor_setF [index] = transformAtan3Operator(line)
            if "pow(" in line:
                self.listFor_setF [index] = replacePow(line)

    ##
    # returns the lines that constitues the body of setF
    # @param self : object pointer
    # @return list of lines
    def getListFor_setF(self):
        return self.listFor_setF

    ##
    # returns the lines that constitues the body of setFquations
    # @param self : object pointer
    # @return list of lines
    def getListFor_setFequations(self):
        map_fequation = self.reader.getMap_equation_formula()
        ptrn_f_name ="  // ----- %s -----\n"
        for eq in self.getListEqSyst():
            index = str(eq.getNumOmc())
            fequation_index = str(eq.getNumDyn())
            if fequation_index != '-1':
                if index in map_fequation.keys():
                    equation = map_fequation[index]
                    linetoadd = "  fEquationIndex["+ fequation_index +"] = \"" + map_fequation[index] + "\";//equation_index_omc:"+index+"\n"
                    self.listFor_setFequations.append(linetoadd)

        for eq in self.getListOtherEq():
            index = str(eq.getNumOmc())
            fequation_index = str(eq.getNumDyn())
            if fequation_index != '-1':
                if  index in map_fequation.keys():
                    linetoadd = "  fEquationIndex["+ str(fequation_index) +"] = \"" + map_fequation[index] + "\";//equation_index_omc:"+index+"\n"
                    self.listFor_setFequations.append(linetoadd)
        return self.listFor_setFequations

    ##
    # prepare the lines that constitues the body of setGequations
    # @param self : object pointer
    # @return list of lines
    def prepareFor_setGequations(self):
        line_ptrn = '  gEquationIndex[%s] = " %s " ;\n'
        line_ptrn_res = '  gEquationIndex[%s] =  %s  ;\n'

        filtered_func = list(self.zc_filter.getFunctionZeroCrossingDescription_rawFunc())
        filtered_func = filtered_func[1:-1] # remove last and first elements which are "}" and "{"


        self.listFor_setGequations.append("// ---------------- boolean conditions -------------\n")
        nb_zero_crossing = 0;
        for line in filtered_func :
            self.listFor_setGequations.append(line)
            if not("  static const char *res[] = {" == line) and not("  };" == line.rstrip()):
                nb_zero_crossing +=1
        for i in range(nb_zero_crossing):
            value = "res[" + str(i) + "]"
            self.listFor_setGequations.append( line_ptrn_res %(i, value))
        self.listFor_setGequations.append("// -----------------------------\n")

        line_when_ptrn = "  // ------------- %s ------------\n"
        for r_obj in self.listRootObjects:
            if r_obj.getNumDyn() == -1:
                continue
            index = str(r_obj.getNumDyn()) + " + " + str(nb_zero_crossing)
            self.listFor_setGequations.append(line_when_ptrn %(r_obj.getWhenVarName()))
            when_string = r_obj.getWhenVarName() + ":" + transformRawbodyToString(r_obj.getBodyForNumRelation())
            self.listFor_setGequations.append( line_ptrn % (index, when_string ) )
            self.listFor_setGequations.append(" \n")

        # convert native boolean variables
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems], self.listFor_setGequations)

    ##
    # returns the lines that constitues the body of setGquations
    # @param self : object pointer
    # @return list of lines
    def getListFor_setGequations(self):
        return self.listFor_setGequations


    ##
    # prepare the lines for the evalMode body
    # @param self : object pointer
    def prepareFor_evalMode(self):
        self.listFor_evalMode.append  ("  // modes may either be due to")
        self.listFor_evalMode.append("\n  // - a change in network topology (currently forbidden for Modelica models)")
        self.listFor_evalMode.append("\n  // - a Modelica reinit command")
        self.listFor_evalMode.append("\n")

        if (self.keepContinousModelicaReinit()):
            for var_name, eq_list in self.getMapEqReinitContinuous().iteritems():
                for eq in eq_list:
                    self.listFor_evalMode.append("\n  // mode linked with " + var_name + "\n")
               	    self.listFor_evalMode.extend (eq.getBodyFor_evalMode())
               	    self.listFor_evalMode.append("\n")

        self.listFor_evalMode.append("  // no mode triggered => return false")
        self.listFor_evalMode.append("\n  return false;")

        self.listFor_evalMode.append("\n")

        # convert native boolean variables
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems], self.listFor_evalMode)

    ##
    # returns the lines that constitues the body of evalMode
    # @param self : object pointer
    # @return list of lines
    def getListFor_evalMode(self):
        return self.listFor_evalMode

    ##
    # prepare the lines that constitues the body of setZ
    # @param self : object pointer
    # @return
    def prepareFor_setZ(self):
        ptrn_name="\n  // -------------------- %s ---------------------\n"
        for z_equation in self.listZEquations:
            self.listFor_setZ.append(ptrn_name %(z_equation.getName()))
            self.listFor_setZ.extend(z_equation.getBody())

        for int_equation in self.listINTEquations:
            self.listFor_setZ.append(ptrn_name %(int_equation.getName()))
            self.listFor_setZ.extend(int_equation.getBody())

        if len(self.listCallFor_setZ) > 0:
            self.listFor_setZ.append("\n\n  // -------------- call functions ----------\n")
            for line in self.listCallFor_setZ:
                line = throwStreamIndexes(line)
                line = mmc_strings_len1(line)
                if "MMC_DEFSTRINGLIT" in line:
                    line = line.replace("static const MMC_DEFSTRINGLIT(","")
                    line = line.replace(");","")
                    words = line.split(",")
                    name_var = words[0]
                    value = words[2].replace("\n","")
                    line_tmp = "  const modelica_string "+str(name_var)+" = "+str(value)+";\n"
                    self.listFor_setZ.append(line_tmp)
                elif "MMC_REFSTRINGLIT" in line:
                    line = line.replace("MMC_REFSTRINGLIT","")
                    self.listFor_setZ.append(line)
                elif "modelica_metatype tmpMeta" in line:
                    words = line.split()
                    line_tmp = " modelica_string "+str(words[1])+";\n"
                    self.listFor_setZ.append(line_tmp)
                elif ("TRACE_PUSH" not in line)  and ("TRACE_POP" not in line) \
                     and ("const int equationIndexes[2]" not in line) and ("infoStreamPrint" not in line) \
                     and ("data->simulationInfo->needToIterate = 1") not in line:
                    self.listFor_setZ.append(line)
                elif "TRACE_PUSH" in line:
                  self.listFor_setZ.append("{\n")
                elif "TRACE_POP" in line:
                  self.listFor_setZ.append("}\n")

            self.listFor_setZ.append("\n\n")

        # convert native boolean variables
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems], self.listFor_setZ)

    ##
    # returns the lines that constitues the body of setF
    # @param self : object pointer
    # @return list of lines
    def getListFor_setZ(self):
        return self.listFor_setZ

    ##
    # prepare the lines that constitues the body of setG
    # @param self : object pointer
    # @return
    def prepareFor_setG(self):
        line_ptrn = "  gout[%s] = ( %s ) ? ROOT_UP : ROOT_DOWN;\n"
        line_when_ptrn = "  // ------------- %s ------------\n"
        for r_obj in self.listRootObjects:
            if r_obj.getNumDyn() == -1:
                continue
            self.listFor_setG.append(line_when_ptrn %(r_obj.getWhenVarName()))
            self.listFor_setG.extend(r_obj.getBodyForNumRelation())
            self.listFor_setG.append(" \n")

        filtered_func = list(self.zc_filter.getFunctionZeroCrossings_rawFunc())
        filtered_func = filtered_func[1:-1] # remove last and first elements which are "}" and "{"

        for line in filtered_func :
            if "gout" not in line:
                self.listFor_setG.append(line)

        # print all gout at the end of the function
        nb_zero_crossing = 0;
        for line in filtered_func:
            if "gout" in line:
                line = line.replace("1 : -1;", "ROOT_UP : ROOT_DOWN;")
                self.listFor_setG.append(line)
                nb_zero_crossing +=1

        for r_obj in self.listRootObjects:
            if r_obj.getNumDyn() == -1:
                continue
            index = str(r_obj.getNumDyn()) + " + " + str(nb_zero_crossing)
            self.listFor_setG.append( line_ptrn % (index, "$P"+r_obj.getWhenVarName()) )

        # convert native boolean variables
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems], self.listFor_setG)

    ##
    # returns the lines that constitues the body of setG
    # @param self : object pointer
    # @return list of lines
    def getListFor_setG(self):
        return self.listFor_setG

    ##
    # prepare the lines that constitues the body of initRpar
    # @param self : object pointer
    # @return
    def prepareFor_initRpar(self):

        # -----------------------------------------------------------
        # Shared and external parameters
        # (possibly set through *.mo, and updated by *.par/.iidm)
        # -----------------------------------------------------------

        self.listFor_initRpar.append("  /* Setting shared and external parameters */\n")

        # Pattern of the lines of the body of initRpar
        motif = "  %s = %s;\n"
        motif_string = "%s = %s.c_str();\n"

        for par in filter(lambda x: (paramScope(x) !=  INTERNAL_PARAMETER), self.listParamsReal + self.listParamsBool + self.listParamsInteger + self.listParamsString):
            name_underscore = par.getName() + "_"
            affectation_line = ""
            if (par in self.listParamsString):
                affectation_line = motif_string % ( to_omc_style(par.getName()), to_compile_name(name_underscore) )
            else:
                affectation_line = motif % ( to_omc_style(par.getName()), to_compile_name(name_underscore) )

            self.listFor_initRpar.append(affectation_line)

        # -----------------------------------------------------------
        # Parameters set in *.mo through a mathematical formula
        # -----------------------------------------------------------
        self.listFor_initRpar.append("\n  // Setting internal parameters \n")

        found_init_by_param_and_at_least2lines = False # to enhance readability

        dict_line_par_by_param = {}
        line_par_other = []
        pattern_num = re.compile(r',(?P<num>\d+)}')
        # Prepare initRpar lines
        for par in filter(lambda x: (paramScope(x) ==  INTERNAL_PARAMETER), self.listParamsReal + self.listParamsBool + self.listParamsInteger + self.listParamsString):
            # the variable is initialised through an equation (rather than a hard-coded value)
            if (not par.getInitByParam()) and (not par.getInitByParamIn06Inz()):
                print('failed to generate parameter setting for ' + par.getName() + ' : no initialisation formula')
                sys.exit(1)

            start_text_getter = None
            start_text_cleaner = None
            if par.getInitByParam():
                start_text_getter = "getStartText"
                start_text_cleaner = "cleanStartText"
            elif par.getInitByParamIn06Inz() :
                start_text_getter = "getStartText06Inz"
                start_text_cleaner = "cleanStartText06Inz"

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
                line_par_by_param.append(L)

            if len(getattr(par, start_text_getter)()) > 1 : line_par_by_param.append("\n") # for enhanced readability

            dict_line_par_by_param[num]=line_par_by_param

        keys = dict_line_par_by_param.keys()
        keys.sort()
        for key in keys:
            self.listFor_initRpar +=  dict_line_par_by_param[key]

        # convert native Modelica booleans
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems], self.listFor_initRpar)


    ##
    # returns the lines that constitues the body of initRpar
    # @param self : object pointer
    # @return list of lines
    def getListFor_initRpar(self):
        for line in self.listFor_initRpar:
            if "omc_Modelica_Math_atan3" in line:
                index = self.listFor_initRpar.index(line)
                line_tmp = transformAtan3Operator(line)
                self.listFor_initRpar.pop(index)
                self.listFor_initRpar.insert(index,line_tmp)
        return self.listFor_initRpar


    ##
    # prepare the lines that constitues the body of setupDataStruc
    # @param self : object pointer
    # @return
    def prepareFor_setupDataStruc(self):

        # If there are dummy vars in the main.c generated by omc, you need to
        # substract them to the following lines (in the body of "setupDataStruc(...)") :
        #   data->modelData.nStates = n1;
        #   data->modelData.nVariablesReal = n2;
        # And do (see below in this method):
        #   data->modelData.nStates = n1 - nbDummy;
        #   data->modelData.nVariablesReal = n2 - 2*nbDummy;

        self.listFor_setupDataStruc.append("  data->modelData = (MODEL_DATA *)calloc(1,sizeof(MODEL_DATA));\n");
        self.listFor_setupDataStruc.append("  data->simulationInfo = (SIMULATION_INFO *)calloc(1,sizeof(SIMULATION_INFO));\n");
        self.listFor_setupDataStruc.append("  data->nbDummy = %s;\n" % len(self.listVarsDummy) )

        # Filtering the body lines of the function
        def filter_setupData(line):
            if "data->modelData->n" in line : return True
            return False

        filtered_func = []
        filtered_iter = itertools.ifilter( filter_setupData, self.reader.setupDataStruc_rawFunc.getBody() )
        filtered_func = list(filtered_iter)

        # Change the number of zeroCrossings
        for n, line in enumerate(filtered_func):
            if "data->modelData->nZeroCrossings" in line:
                line = line [ :line.find("=") ] + "= " + str(self.zc_filter.getNumberOfZeroCrossings())+";\n"
                new_line = line [ :line.find(";") ] + " + " + str(self.nbRootObjects) + line[ line.find(";") : ]
                filtered_func[n] = new_line

        # Modification of the number of discrete variables to take into account Booleans
        # We do not change the size of the array of Boolean variables
        nb_vars_bool = len(self.listVarsBool)
        nb_params_bool = len(self.listParamsBool)
        bool_vars_plural_addon = 's' if nb_vars_bool > 1 else ''
        bool_params_plural_addon = 's' if nb_params_bool > 1 else ''
        if (nb_vars_bool > 0) or (nb_params_bool > 0):
            for n, line in enumerate(filtered_func):
                if "data->modelData->nDiscreteReal" in line:
                    new_line = line [ : line.find(";")] + " + " + str(nb_vars_bool) + "; // "  + str(nb_vars_bool) + " boolean" + bool_vars_plural_addon \
                               + " emulated as discrete real variable" + bool_vars_plural_addon \
                               + line [line.find(";") + 1 : ]
                    filtered_func [n] = new_line
                elif "data->modelData->nVariablesBoolean" in line:
                    new_line = line [ : line.find(";")] + " - " + str(nb_vars_bool) \
                                  + "; // "  + str(nb_vars_bool) + " boolean" + bool_vars_plural_addon + " emulated as discrete real variable" + bool_vars_plural_addon + line [line.find(";") + 1 : ]
                    filtered_func [n] = new_line
                elif "data->modelData->nParametersReal" in line:
                    new_line = line [ : line.find(";")] + " + " + str(nb_params_bool) \
                                    + "; // "  + str(nb_params_bool) + " boolean" + bool_params_plural_addon + " emulated as real parameter" + bool_params_plural_addon + line [line.find(";") + 1 : ]
                    filtered_func [n] = new_line
                elif "data->modelData->nParametersBoolean" in line:
                    new_line = line [ : line.find ("data->modelData->nParametersBoolean")] + "data->modelData->nParametersBoolean = 0; // all boolean parameters emulated as real parameters" + line [line.find(";") + 1 : ]
                    filtered_func [n] = new_line

        # Filling the body of setupDataStruc in the generated file
        self.listFor_setupDataStruc = self.listFor_setupDataStruc + filtered_func + ["\n"]

    ##
    # returns the lines that constitues the body of setupDataStruc
    # @param self : object pointer
    # @return list of lines
    def getSetupDataStruc(self):
        return self.listFor_setupDataStruc

    ##
    # prepare the lines that constitues the body of evalFAdept
    # @param self : object pointer
    # @return
    def prepareFor_evalFAdept(self):
        # In comment, we give the correspondence name var -> expression in vectors x, xd or rpar
        self.listFor_evalFAdept.append("  /*\n")
        for v in self.listVarsSyst + self.listVarsDer:
            self.listFor_evalFAdept.append( "    %s : %s\n" % (to_compile_name(v.getName()), v.getDynawoName()) )
        self.listFor_evalFAdept.append("\n")

        self.listFor_evalFAdept.append("  */\n")


        # Recovery of the text content of the equations that evaluate the system's vars
        # and 2-step treatment:
        # - the line of the var evaluation ($Pvar = ...) is changed into " res[i] = $Pvar - ... ".
        #   Replacement of "modelica_real" by "adept::adouble"
        #   Replacement of "Greater" and "Less" by "Greater<adept::adouble>" and "Less<adept::adouble>"
        #   Replacement of "GreaterEq" and "LessEq" by "GreaterEq<adept::adouble>" and "LessEq<adept::adouble>"
        # - vars (of the system) used to evaluate it are replaced by x[i], xd[i] or rpar[i]
        # thanks to the translator (the discreet vars are not replaced)

        # ... Transpose to translate
        #     vars [ $Pvar ou $P$DER$Pvar ] --> [ x[i]  xd[i] ou rpar[i] ]
        trans = Transpose(a_map = self.map_varOmc_varDyn_evalFAdept)

        map_eq_reinit_continuous = self.getMapEqReinitContinuous()

        num_ternary = 0
        for eq in self.getListEqSyst():
            var_name = eq.getEvaluatedVar()
            var_name_without_der = var_name [4 : -1] if 'der(' == var_name [ : 4] else var_name
            if var_name not in self.reader.fictiveContinuousVarsDer:
                line = "  // ----- %s -----\n" % eq.getSrcFctName()
                self.listFor_evalFAdept.append(line)

                # We recover the text of the equations
                standard_body = eq.getBodyFor_evalFAdept()

                # Build the whole equation body as if clauses linked with reinit
                # the standard equation body is written in the last else section
                body = []
                if self.keepContinousModelicaReinit() \
                   and ((var_name in map_eq_reinit_continuous) or (var_name_without_der in map_eq_reinit_continuous)):
                    var_name_modelica_reinit = var_name if var_name in map_eq_reinit_continuous else var_name_without_der
                    eq_list = map_eq_reinit_continuous [var_name_modelica_reinit]
                    first_eq = True
                    for eq in eq_list:
                        if (not first_eq):
                            body.append("  else ")
                        body.extend (eq.getBodyFor_evalFAdept())
                        body.append("\n")

                    body.append("  else \n")
                    body.append("  { \n")
                    body.extend(standard_body)
                    body.append("  } \n")
                else:
                    body = standard_body

                trans.setTxtList(body)
                body_translated = trans.translate()

                # transformation of ternary operators:
                body_to_transform = False
                for line in body_translated:
                    if "?" in line:
                        body_to_transform = True
                        break

                if body_to_transform:
                    body_translated = transformTernaryOperator(body_translated,num_ternary)
                    num_ternary += 1

                # convert native boolean variables
                convert_booleans_body ([item.getName() for item in self.listAllBoolItems], body_translated)

                # L'equation transformee est incorporee dans la fonction a imprimer
                self.listFor_evalFAdept.extend(body_translated)

                self.listFor_evalFAdept.append("\n\n")


    ##
    # returns the lines that constitues the body of evalFAdept
    # @param self : object pointer
    # @return list of lines
    def getListFor_evalFAdept(self):
        for line in self.listFor_evalFAdept:
            if "omc_Modelica_Math_atan3" in line:
                index = self.listFor_evalFAdept.index(line)
                line_tmp = transformAtan3OperatorEvalF(line)
                self.listFor_evalFAdept [index] = line_tmp
        return self.listFor_evalFAdept

    ##
    # prepare the lines that constitues the body of externalCalls
    # @param self : object pointer
    # @return
    def prepareFor_externalCalls(self):
        for func in self.reader.listOmcFunctions:
            # if function does not start with omc_ we do not add it
            name = func.getName()
            if name[0:4] != 'omc_' :
                self.eraseFunc.append(name)
                continue

            self.listFor_externalCalls.append("\n")
            signature = func.getSignature()
            name_to_fill = "__fill_model_name__::"+name
            signature = signature.replace(name, name_to_fill)

            return_type = func.getReturnType()
            # type is not a predefined type
            if (return_type !="void" and return_type[0:9] != 'modelica_' and return_type[0:10] != 'real_array'):
                new_return_type ="__fill_model_name__::"+return_type
                signature = signature.replace(return_type, new_return_type, 1)

            signature = signature.replace('threadData_t *threadData,','')

            self.listFor_externalCalls.append(signature)
            new_body = []
            for line in func.getBody():
                if "modelica_metatype tmpMeta" in line:
                    words = line.split()
                    line_tmp = "  modelica_string " + str(words[1]) + ";\n"
                    new_body.append(line_tmp)
                elif "FILE_INFO info" not in line:
                    line = line.replace("threadData," ,"")
                    line = line.replace("MMC_STRINGDATA","")
                    new_body.append(line)
            self.listFor_externalCalls.extend(new_body)


    ##
    # prepare the lines that constitues the header of externalCalls
    # @param self : object pointer
    # @return
    def prepareFor_externalCallsHeader(self):
        tmp_list = self.reader.list_internal_functions
        for func in self.eraseFunc:
            for line in self.reader.list_internal_functions:
                if func in line:
                    tmp_list.remove(line)

        for line in tmp_list:
            if 'threadData_t *threadData,' in line:
                line = line.replace("threadData_t *threadData,","")
            self.listFor_externalCallsHeader.append(line)

    ##
    # returns the lines that constitues the body of externalCalls
    # @param self : object pointer
    # @return list of lines
    def getListFor_externalCalls(self):
        return self.listFor_externalCalls

    ##
    # returns the lines that constitues the header of externalCalls
    # @param self : object pointer
    # @return list of lines
    def getListFor_externalCallsHeader(self):
        return self.listFor_externalCallsHeader

    ##
    # prepare the lines for the shared parameters default value setting
    # @param self : object pointer
    # @return
    def prepareFor_setSharedParamsDefaultValue(self):
        # -----------------------------------------------------------
        # Parameters default value set in *.mo
        # -----------------------------------------------------------
        self.listFor_setSharedParamsDefault.append("\n   // Propagating shared parameters default value \n")
        self.listFor_setSharedParamsDefault.append("\n   // This value may be updated later on through *.par/*.iidm data \n")
        parameters_set_name = 'parametersSet'
        create_parameter_pattern = '  ' + parameters_set_name + '->createParameter("%s", %s);\n'
        local_name_prefix = "_internal"
        all_parameters_names = {}

        # define local parameters
        lines_local_par_definition = []
        for par in filter(lambda x: (paramScope(x) ==  SHARED_PARAMETER), self.listParamsReal + self.listParamsBool + self.listParamsInteger + self.listParamsString):
            local_par_name = to_omc_style (par.getName()) + local_name_prefix
            all_parameters_names [to_omc_style(par.getName())] = local_par_name
            par_value_type = par.getValueTypeC()
            if (par_value_type == "string"):
                par_value_type = "std::string"
            line_local_par_definition = '  %s %s;\n' % (par_value_type, local_par_name)
            lines_local_par_definition.append (line_local_par_definition)
        lines_local_par_definition.append('\n')

        # create and fill parameters' set
        self.listFor_setSharedParamsDefault.append('  boost::shared_ptr<parameters::ParametersSet> ' + parameters_set_name + ' = parameters::ParametersSetFactory::newInstance("SharedModelicaParameters");\n')

        line_par_other = []
        for par in filter(lambda x: (paramScope(x) ==  SHARED_PARAMETER), self.listParamsReal + self.listParamsBool + self.listParamsInteger + self.listParamsString):
                init_val = par.getStartText()[0]
                local_par_name = all_parameters_names [to_omc_style (par.getName())]

                # add quotes
                if isParamString (par):
                    if init_val != "" :
                        init_val = '"' + str(init_val) + '"'
                    else:
                        init_val = '""'
                else:
                    if init_val == "":
                        init_val = "0.0"

                line_value_setting = "  %s = %s; \n" % (local_par_name, init_val)
                line_par_other.append (line_value_setting)
                line_modelica_params = create_parameter_pattern % (to_compile_name(par.getName()), local_par_name)
                line_par_other.append (line_modelica_params)

        # concatenation of lists
        self.listFor_setSharedParamsDefault += lines_local_par_definition
        self.listFor_setSharedParamsDefault += line_par_other

        self.listFor_setSharedParamsDefault.append('  return parametersSet;\n')

        # convert native Modelica booleans
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems] + [all_parameters_names[to_omc_style(par.getName())] for par in filter(lambda x: (paramScope(x) ==  SHARED_PARAMETER), self.listParamsBool)], self.listFor_setSharedParamsDefault)

    ##
    # returns the lines describing shared parameters initial value setting
    # @param self : object pointer
    # @return list of lines
    def getListFor_setSharedParamsDefaultValue(self):
        return self.listFor_setSharedParamsDefault

    ##
    # prepare the lines that constitues the body of setParameters
    # @param self : object pointer
    # @return
    def prepareFor_setParams(self):
        # Pattern of the body lines of setParameters
        motif_double = "  %s = params->getParameter(\"%s\")->getDouble();\n"
        motif_bool =  "  %s = params->getParameter(\"%s\")->getBool();\n"
        motif_string =  "  %s = params->getParameter(\"%s\")->getString();\n"
        motif_integer = "  %s = params->getParameter(\"%s\")->getInt();\n"

        for par in filter(lambda x: (paramScope(x) !=  INTERNAL_PARAMETER), self.listParamsReal + self.listParamsBool + self.listParamsInteger + self.listParamsString):
            motif = None
            if (par in self.listParamsReal):
                motif = motif_double
            elif (par in self.listParamsBool):
                motif = motif_bool
            elif (par in self.listParamsInteger):
                motif = motif_integer
            elif (par in self.listParamsString):
                motif = motif_string

            name = to_compile_name(par.getName())
            name_underscore = name + "_"
            line = motif % ( name_underscore, name )
            self.listFor_setParams.append(line)

        # convert native boolean variables
        convert_booleans_body ([item.getName() for item in self.listAllBoolItems], self.listFor_setParams)

    ##
    # returns the lines that constitues the body of setParameters
    # @param self : object pointer
    # @return list of lines
    def getListFor_setParams(self):
        return self.listFor_setParams

    ##
    # returns the lines that declares non-internal real parameters
    # @param self : object pointer
    # @return list of lines
    def getListParamsRealNotInternalFor_h(self):
        return filter(lambda x: (paramScope(x) !=  INTERNAL_PARAMETER), self.listParamsReal)

    ##
    # returns the lines that declares non-internal boolean parameters
    # @param self : object pointer
    # @return list of lines
    def getListParamsBoolNotInternalFor_h(self):
        return filter(lambda x: (paramScope(x) !=  INTERNAL_PARAMETER), self.listParamsBool)

    ##
    # returns the lines that declares non-internal string parameters
    # @param self : object pointer
    # @return list of lines
    def getListParamsStringNotInternalFor_h(self):
        return filter(lambda x: (paramScope(x) !=  INTERNAL_PARAMETER), self.listParamsString)

    ##
    # returns the lines that declares non-internal integer parameters
    # @param self : object pointer
    # @return list of lines
    def getListParamsIntegerNotInternalFor_h(self):
        return filter(lambda x: (paramScope(x) !=  INTERNAL_PARAMETER), self.listParamsInteger)

    ##
    # returns the lines that should be included in header to define variables
    # @param self : object pointer
    # @return
    def getListDefinitionsFor_h (self):
        return self.listFor_definitionHeader

    ##
    # Prepare the lines that should be included in header to define variables
    # @param self : object pointer
    # @return
    def prepareFor_DefinitionsFor_h (self):
        variable_definitions = self.reader.model_header_content

        lines_to_write = variable_definitions

        item_types = ['Vars', 'Parameter']
        for item_type in item_types:
            items = None
            item_names = None
            item_external_offset = 0 # offset due to the fact that some items may already exist
            item_internal_offset = 0 # offset due to for loop iteration
            items_full_offsets = {} # map item identifier with its item index

            if (item_type == 'Vars'):
                items = self.listVarsBool
            elif (item_type == 'Parameter'):
                items = self.listParamsBool

            new_type=''
            if (item_type == 'Vars'):
                new_type='discrete'
            elif(item_type == 'Parameter'):
                new_type='real'

            item_names = [to_omc_style(var.getName()) for var in items]

            # sort item names in order to start with the longest one (to avoid taking varXY for varX)
            item_names.sort(key=len, reverse=True)

            for line in variable_definitions:
                if ('->'+ new_type + item_type in line):
                    sub_line = line [line.find ('->' + new_type + item_type) : ]
                    sub_line = sub_line [sub_line.find('[') + 1 : sub_line.find (']')].strip()
                    item_external_offset = max (item_external_offset, int (sub_line) + 1)

            item_identification = '->boolean' + item_type # items for which to change the type
            # prefix and suffix to avoid taking one variable for another (superVar1 for Var1, var12 for var1, ...)
            allowed_suffixes = [' ', '(i)', '__varInfo']
            allowed_prefixes = [' ', ' _', '$P$PRE', '$P$ATTRIBUTE']
            for n, line in enumerate(lines_to_write):
                # change boolean into (discrete) real
                if (item_identification in line) and (any(var_name in line for var_name in item_names)):

                    # find which item was found
                    item_found = None
                    for item_name in item_names:
                        if any(prefix + item_name + suffix in line for (prefix, suffix) in itertools.product (allowed_prefixes, allowed_suffixes)):
                           item_found = item_name
                           break

                    # extract part of the line (without the offset declaration)
                    item_offset_index = line.find (item_name)
                    sub_line = line [item_offset_index : ]

                    item_offset_index += sub_line.find(item_identification) + 1
                    sub_line = line [item_offset_index : ]

                    item_offset_index += sub_line.find('[') + 1
                    item_offset_index_length = sub_line.find (']') - (sub_line.find('[') + 1)
                    sub_line = sub_line [sub_line.find('[') + 1 : sub_line.find (']')].strip()

                    # compute the new item offset and update the OMC variable index
                    if (item_found not in items_full_offsets.keys()):
                        full_offset = item_external_offset + item_internal_offset
                        items_full_offsets [item_found] = full_offset
                        for search_item in items:
                            if (to_omc_style(search_item.getName()) == item_found):
                                search_item.setNumOmc (full_offset)
                                break
                        item_internal_offset += 1

                    item_offset_new = items_full_offsets [item_found]

                    # remove the old offset, and replace it with the new one
                    new_line = line [ : item_offset_index].replace('boolean', new_type) + str(item_offset_new) + line [item_offset_index + item_offset_index_length :]

                else:
                    new_line = line

                # add line ending when relevant
                line_ending = '\n'
                if new_line [ - len(line_ending) : ] !=  line_ending:
                    new_line += line_ending

                lines_to_write [n] = new_line

        self.listFor_definitionHeader.extend (lines_to_write)
        self.listVarsBool.sort (cmp = cmp_numOmc_vars)
        self.listAllVarsDiscr.sort(cmp = cmp_numOmc_vars)
        self.listParamsBool.sort(cmp = cmp_numOmc_vars)


    ##
    # prepare the lines that constitues the body of setYType
    # @param self : object pointer
    # @return
    def prepareFor_setYType(self):
        ind = 0
        for v in self.listVarsSyst:
            spin = "DIFFERENTIAL"
            var_ext = ""
            if isAlgVar(v) : spin = "ALGEBRIC"
            if v.getName() in self.reader.fictiveContinuousVars:
              spin = "EXTERNAL"
              var_ext = "- external variables"
            elif v.getName() in self.reader.fictiveOptionalContinuousVars:
              spin = "OPTIONAL_EXTERNAL"
              var_ext = "- optional external variables"
            line = "   yType[ %s ] = %s;   /* %s (%s) %s */\n" % (str(ind), spin, to_compile_name(v.getName()), v.getType(), var_ext)
            self.listFor_setYType.append(line)
            ind += 1

    ##
    # returns the lines that constitues the body of setYType
    # @param self : object pointer
    # @return list of lines
    def getListFor_setYType(self):
        return self.listFor_setYType


    ##
    # prepare the lines that constitues the body of setFType
    # @param self : object pointer
    # @return
    def prepareFor_setFType(self):
        ind = 0
        for eq in self.getListEqSyst():
            var_name = eq.getEvaluatedVar()
            if var_name not in self.reader.fictiveContinuousVarsDer:
                spin = "ALGEBRIC_EQ" # no derivatives in the equation
                if eq.isDiffEq() : spin = "DIFFERENTIAL_EQ"
                line = "   fType[ %s ] = %s;\n" % (str(ind), spin)
                self.listFor_setFType.append(line)
                ind += 1

    ##
    # returns the lines that constitues the body of setFType
    # @param self : object pointer
    # @return list of lines
    def getListFor_setFType(self):
        return self.listFor_setFType

    ##
    # prepare the lines that constitues the body of setVariables
    # @param self : object pointer
    # @return
    def prepareFor_setVariables(self):
        line_ptrn_native_state = '  variables.push_back (VariableNativeFactory::createState ("%s", %s, %s));\n'
        line_ptrn_native_calculated = '  variables.push_back (VariableNativeFactory::createCalculated ("%s", %s, %s));\n'
        line_ptrn_alias =  '  variables.push_back (VariableAliasFactory::create ("%s", "%s", %s));\n'

        # System vars
        for v in self.listAllVars:
            name = to_compile_name(v.getName())
            is_state = True
            negated = "true" if v.getAliasNegated() else "false"
            line = ""
            if v.getAliasName() != '':
                alias_name = to_compile_name(v.getAliasName())
                line = line_ptrn_alias % ( name, alias_name, negated)

            elif is_state:
                line = line_ptrn_native_state % ( name, v.getDynType(), negated)
            else:
                line = line_ptrn_native_calculated % ( name, v.getDynType(), negated)


            self.listFor_setVariables.append(line)

    ##
    # returns the lines that constitues the body of setVariables
    # @param self : object pointer
    # @return list of lines
    def getListFor_setVariables(self):
        return self.listFor_setVariables

    ##
    # prepare the lines that constitues the body of defineParameters
    # @param self : object pointer
    # @return
    def prepareFor_defineParameters(self):
        line_ptrn = "  parameters.push_back(ParameterModeler(\"%s\", %s, %s));\n"

        # Les parametres
        for par in self.listParamsReal + self.listParamsBool + self.listParamsInteger + self.listParamsString:
            par_type = paramScopeStr (paramScope (par))
            name = to_compile_name(par.getName())
            value_type = par.getValueTypeC().upper()
            line = line_ptrn %( name, value_type, par_type)
            self.listFor_defineParameters.append(line)

    ##
    # returns the lines that constitues the body of defineParameters
    # @param self : object pointer
    # @return list of lines
    def getListFor_defineParameters(self):
        return self.listFor_defineParameters

    ##
    # prepare the lines that constitues the body of defineElements
    # @param self : object pointer
    # @return
    def prepareFor_defElem(self):

        motif1 = "  elements.push_back(Element(\"%s\",\"%s\",Element::%s));\n"
        motif2 = "  mapElement[\"%s\"] = %d;\n"


        # # First part of defineElements (...)
        for elt in self.listElements :
            elt_name = elt.getElementName()
            elt_short_name = elt.getElementShortName()
            line =""
            if not elt.isStructure() :
                line = motif1 % ( to_compile_name(elt_short_name), to_compile_name(elt_name), "TERMINAL" )
            else :
                line = motif1 % ( to_compile_name(elt_short_name), to_compile_name(elt_name), "STRUCTURE" )
            self.listFor_defElem.append(line)


        self.listFor_defElem.append("\n") # Empty line

        # Second part of defineElements (...)
        for elt in self.listElements :
            elt.printLink(self.listFor_defElem)

        self.listFor_defElem.append("\n") # Empty line

        # Third part of defineElements (...)
        for elt in self.listElements :
            elt_name = elt.getElementName()
            elt_index = elt.getElementNum()
            # The structure itself
            line = motif2 % (to_compile_name(elt_name), elt_index)
            self.listFor_defElem.append(line)


    ##
    # returns the lines that constitues the body of defineElements
    # @param self : object pointer
    # @return list of lines
    def getListFor_defElem(self):
       return self.listFor_defElem

    ##
    # prepare the lines that constitues the defines for literal constants
    # @param self : object pointer
    # @return
    def prepareFor_literalConstants(self):
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
                self.listFor_literalConstants.append(define)

            elif 'static const modelica_integer' in var:
                var = var.replace("_data", "")
                var = var.replace ("static const", "const")

                self.listFor_literalConstants.append(var)


    ##
    # returns the lines that constitues the defines for literal constants
    # @param self : object pointer
    # @return list of lines
    def getListFor_literalConstants(self):
        return self.listFor_literalConstants


   ##
   # returns the lines that constitues the body of initializeDataStruc
   # @param self : object pointer
   # @return list of lines
    def getListFor_initializeDataStruc(self):
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
    def getListFor_deInitializeDataStruc(self):
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
    def getListFor_warnings (self):
        return self.listFor_warnings

    ##
    # Prepare all the data stored in dataContainer in list of lines to be printed
    # @param self : object pointer
    # @return
    def prepareForPrint(self):
        # Concern the filling of the _definition.h file
        # To do first, because modifies some variables (Boolean -> real discrete)
        self.prepareFor_DefinitionsFor_h()

        self.zc_filter.removeFictitiousGEquation()

        # Concern the filling of the C file
        self.prepareFor_setF()
        self.prepareFor_evalMode()
        self.prepareFor_setZ()
        self.prepareFor_setG()
        self.prepareFor_setGequations()
        self.prepareFor_setY0()
        self.prepareFor_initRpar()
        self.prepareFor_setupDataStruc()
        self.prepareFor_setYType()
        self.prepareFor_setFType()
        self.prepareFor_defElem()
        self.prepareFor_setSharedParamsDefaultValue()
        self.prepareFor_setParams()
        self.prepareFor_evalFAdept()
        self.prepareFor_setVariables()
        self.prepareFor_defineParameters()
        self.prepareFor_externalCalls()
        self.prepareFor_externalCallsHeader()
        self.prepareFor_literalConstants()
