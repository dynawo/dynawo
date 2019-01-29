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

nbBracesOpened = 0
stopAtNextCall = False
crossedOpeningBraces = False

##
# Count the number of opening braces in an expression
# @param expr : the expression to analyze
# @return the number of opening braces
def countOpeningBraces(expr):
    return len(re.findall(r'{', expr))

##
# Count the number of closing braces in an expression
# @param expr : the expression to analyze
# @return the number of opening braces
def countClosingBraces(expr):
    return len(re.findall(r'}', expr))

##
# Predicate for the reading of the body in functions in main c file
# @param element : current line reading
# @return @b False if we read the body, @b True else
def stopReadingFunction(element):
    global nbBracesOpened
    global stopAtNextCall
    global crossedOpeningBraces
    if stopAtNextCall and crossedOpeningBraces : return False
    nbBracesOpened += countOpeningBraces(element)
    nbBracesOpened -= countClosingBraces(element)
    if nbBracesOpened != 0 : crossedOpeningBraces = True
    elif crossedOpeningBraces : stopAtNextCall = True
    return True

##################################

##
# class readerOMC
#
class readerOMC:
    ##
    # Default contstructor
    # @param modName : model read
    # @param inputDir : directory where the files should be read
    # @param isInitPb : @b True is we should read the init model
    def __init__(self, modName, inputDir, isInitPb):
        ## model read
        self.modName = modName

        ## directory where the files should be read
        self.inDir = inputDir

        # -------------------
        # File to read
        # -------------------
        ## Full name of the _info.xml file
        # self.infoXmlFile = os.path.join (inputDir, self.modName + "_info.xml")
        # existFile(self.infoXmlFile)

        ## Full name of the _info.json file
        self.infoJsonFile = os.path.join (inputDir, self.modName + "_info.json")
        existFile(self.infoJsonFile)

        ## Full name of the _init.xml file
        self.initXmlFile = os.path.join (inputDir, self.modName + "_init.xml")
        existFile(self.initXmlFile)

        ## Full name of the _model.h file
        self.modelHeader = os.path.join (inputDir, self.modName + "_model.h")
        existFile(self.modelHeader)

        ## Full name of the .c file
        self.mainCfile = os.path.join (inputDir, self.modName + ".c")
        existFile(self.mainCfile)

        ## Full name of the _02nls.c file
        self._02nlsCfile = os.path.join (inputDir, self.modName + "_02nls.c")
        existFile(self._02nlsCfile)

        ## Full name of the _03lsy.c file
        self._03lsyCfile = os.path.join (inputDir, self.modName + "_03lsy.c")
        existFile(self._03lsyCfile)

        ## Full name of the _08bnd.c file
        self._08bndCfile = os.path.join (inputDir, self.modName + "_08bnd.c")
        existFile(self._08bndCfile)

        ## Full name of the _06inz.c file
        self._06inzCfile = os.path.join (inputDir, self.modName + "_06inz.c")
        existFile(self._06inzCfile)

        ## Full name of the _05evt.c file
        self._05evtCfile = os.path.join (inputDir, self.modName + "_05evt.c")
        existFile(self._05evtCfile)

        ## Full name of xml containing fictitious equations description
        self.eqFictiveXmlFile = os.path.join (inputDir, self.modName + ".xml")

        ## Full name of the _structure.xml file
        self.structXmlFile = os.path.join (inputDir, self.modName + "_structure.xml")
        if not isInitPb : existFile(self.structXmlFile)

        ## Full name of the _functions.h file
        self._functionsHeader = os.path.join (inputDir, self.modName + "_functions.h")
        ## Full name of the _functions.c file
        self._functionsCfile  = os.path.join (inputDir, self.modName + "_functions.c")
        ## Full name of the _literals.h file
        self._literalsFile = os.path.join (inputDir, self.modName + "_literals.h")

        # ---------------------------------------
        # Attribute for reading *_info.json file
        # ---------------------------------------
        ## Association between var evaluated and var used to evaluate
        self.map_vars_dependVars = {}

        ## Association between var evaluated and index of the  function /equation in xml file
        self.map_vars_numEq = {}
        self.map_numEq_vars_defined = {}

        ## Association between the tag of the equation (when,assign,...) and the index of the function/equation
        self.map_tag_numEq ={}

        ## List of number associated to linear equation
        self.linearEqNums = []

        ## Order list of variables for the linear system
        self.LSCalculatedVariables = {}

        ## List of number associated to non linear equation
        self.nonLinearEqNums = []

        ## List of variables defined by initial equation
        self.initial_defined = []


        # ---------------------------------------
        # Attribute for reading *_init.xml
        # ---------------------------------------
        ## List containing all variables found in *_init.xml file : differential/alegbraic/discrete variables and parameters
        self.listVars = []


        # ---------------------------------------------
        # Attribute for reading xml file of fictitious equations
        # ---------------------------------------------
        ## list of fictitious continuous variables
        self.fictiveContinuousVars = []
        ## list of optional fictitious continuous variables
        self.fictiveOptionalContinuousVars = []
        ## list of fictitious differential variables
        self.fictiveContinuousVarsDer = []
        ## list of fictitious discrete variables
        self.fictiveDiscreteVars = []


        # ---------------------------------------
        # Attribute for reading *_model.h file
        # ---------------------------------------
        ## Raw _model content
        self.model_header_content = []
        ## Map associating var name and index in omc
        self.map_vars_numOmc = {}


        # ---------------------------------------
        # Attribute for reading main c file
        # ---------------------------------------
        ## Root name for functions to extract
        self.functionsRootName = modName + "_eqFunction_"

        ## Pattern to find function definition and retrieve num of the function
        self.ptrnFuncDeclMainC = re.compile(r'%s[ ]+%s(?P<num>\d+)\(.*\)[^;]$' % ("void", self.functionsRootName))

        ## List of functions read in file
        self.listFuncMainC = []

        ## Raw body of function  ..._setupDataStruc(...)
        self.setupDataStruc_rawFunc = None

        ## Raw body of function ..._functionDAE(...)
        self.functionDAE_rawFunc = None


        # ---------------------------------------
        # Attribute for reading *_02nls.c file
        # ---------------------------------------
        ## pattern to find function definition and retrieve index of the function
        self.ptrnEqFct_02nls = re.compile(r'%s[ ]+%s(?P<num>\d+)\(.*\)[^;]$' % ("void", self.functionsRootName))
        ## pattern to find function definition and retrieve index of the function (for non linear function)
        self.ptrnNLSresFct_02nls = re.compile(r'void[ ]+residualFunc(?P<num>\d+)\(.*\)[^;]$')

        ## list of functions with type : "eqFunction_"
        self.listNLSclassicFunc = []
        ## list of functions with type : "residualFunc
        self.listNLSresFunc = []



        # ---------------------------------------
        # Attribute for reading *_03lsy.c file
        # ---------------------------------------
        ## pattern to find function definition with type 'void setLinearMatrixA' and retrieve index
        self.ptrnFctMat_03lsy = re.compile(r'void[ ]+setLinearMatrixA(?P<num>\d+)\(.*\)[^;]$')
        ## pattern to find function definition with type 'void setLinearVectorb' and retrieve index
        self.ptrnFctRhs_03lsy = re.compile(r'void[ ]+setLinearVectorb(?P<num>\d+)\(.*\)[^;]$')
        ## pattern to find function definition with type '_eqFunction' and retrieve index
        self.ptrnEqFct_03lsy = re.compile(r'%s[ ]+%s(?P<num>\d+)\(.*\)[^;]$' % ("void", self.functionsRootName))
        ## pattern to find function definition with type 'residualFunc' and retrieve index
        self.ptrnLSresFct_03lsy = re.compile(r'void[ ]+residualFunc(?P<num>\d+)\(.*\)[^;]$')

        ## List of function defining matrix A
        self.listFuncLS_mat = []
        ## List of function defining vector B
        self.listFuncLS_rhs = []
        ## List of function defining eqFunctions
        self.listLSclassicFunc = []
        ## List of function defining residual functions
        self.listLSresFunc = []

        # ---------------------------------------
        # Attribute for reading *_06inz.c file
        # ---------------------------------------
        ## Association between var name and initial value
        self.var_initVal06Inz = {}
        ## Association between var and external assignment
        self.var_initVal06Extend = {}
        ## Association between var and function which initialise this variable
        self.var_numInitVal06Inz = {}
        ## Association between formula of an equation and index of the equation
        self.map_equation_formula = {}

        # ---------------------------------------
        # Attribute for reading *_08bnd.c file
        # ---------------------------------------
        ## Association between variable and initial value
        self.var_initVal = {}
        ## List of warnings defined in this file
        self.warnings = []

        # ---------------------------------------------
        # reading zeroCrossings func in *_05evt.c file
        # ---------------------------------------------
        self.functionZeroCrossings_rawFunc = None
        self.functionZeroCrossingDescription_rawFunc = None


        # ----------------------------------------------------------------------
        # Attribute for reading *_structure.xml file (containing elements and structures)
        # ----------------------------------------------------------------------
        ## List of elements found in file
        self.list_elements = []
        ## Association between struct name and struct definition
        self.map_structName_structObj = {}

        ## Association between one component and the struct of which it belongs to
        self.map_compoName_structName = {}

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
        self.listOmcFunctions = []

        # --------------------------------------------------------------------
        # Attribute for reading *_literals.h file
        #---------------------------------------------------------------------
        ## List of literal definitions
        self.list_vars_literal = []

    ##
    # Read a function in a file and try to identify a function thanks to a pattern
    # @param self : object pointer
    # @param fileToRead : file to read
    # @param ptrnFuncToRead : pattern to use to identify a function
    # @param funcName : name to use when creating the raw function
    #
    # @return the new raw function
    def readFunction(self, fileToRead, ptrnFuncToRead, funcName):
        global nbBracesOpened
        global crossedOpeningBraces
        global stopAtNextCall

        with open(fileToRead, 'r') as f:
            nbBracesOpened = 0
            crossedOpeningBraces = False
            stopAtNextCall = False

            it = itertools.dropwhile(lambda line: ptrnFuncToRead.search(line) is None, f)
            nextIter = next(it, None) # Line on which "dropwhile" stopped
            if nextIter is None: return None # If we reach the end of the file, exit

            func = RawFunc()
            func.setName(funcName)

            # "takewhile" only stops when the whole body of the function is read
            func.setBody( list(itertools.takewhile(stopReadingFunction, it)) )

            return func

    ##
    # Read several functions in a file and try to identify them thanks to a pattern
    # @param self: object pointer
    # @param fileToRead : file to read
    # @param ptrnFuncToRead : pattern to use to identify a function
    # @param funcRootName : root name function to use when creating the raw function
    #
    # @return: a list of raw functions identified in the file
    def readFunctions(self, fileToRead, ptrnFuncToRead, funcRootName):
        global nbBracesOpened
        global crossedOpeningBraces
        global stopAtNextCall

        listRawFunc = []

        with open(fileToRead, 'r') as f:
            while True:
                nbBracesOpened = 0
                crossedOpeningBraces = False
                stopAtNextCall = False

                it = itertools.dropwhile(lambda line: ptrnFuncToRead.search(line) is None, f)
                nextIter = next(it, None) # Line on which "dropwhile" stopped
                if nextIter is None: break # If we reach the end of the file, exit loop

                func = RawFunc()

                match = re.search(ptrnFuncToRead, nextIter)
                numOmc = match.group('num')
                func.setNumOmc(numOmc)
                func.setName(funcRootName + numOmc)

                # "takewhile" only stops when the whole body of the function is read
                func.setBody( list(itertools.takewhile(stopReadingFunction, it)) )
                listRawFunc.append(func)
        return listRawFunc

    ##
    # Read the *_info.json file
    #
    # @param self : object pointer
    # @return
    def readInfoJson(self):
        json_data=open(self.infoJsonFile).read()
        data = json.loads(json_data)
        nbEquations = len(data["equations"])
        for i in range(nbEquations):
            equation = data["equations"][i]
            keys =  equation.keys()
            typeEq = ""
            if "section" in keys:
                typeEq = equation["section"]

            tagEq = ""
            if "tag" in keys:
                tagEq = equation["tag"]

            if typeEq == "regular" or  typeEq == "container":
                index = str(int(equation["eqIndex"]))
                display =""
                if "display" in keys:
                    display = equation["display"]

                # Retrieving numbers from linear equations
                if display == "linear":
                    self.linearEqNums.append(index)

                self.map_tag_numEq[index]=str(tagEq)

                # Retrieving numbers from nonlinear equations
                if display == "non-linear":
                    self.nonLinearEqNums.append(index)

                # Get map [calculated var] --> [Func num / Eq in .xml]
                listDefinedVars=[]
                if "defines" in keys:
                    listDefinedVars = equation["defines"]
                    listDefinedVars = [s.encode('utf-8') for s in listDefinedVars]
                    for name in listDefinedVars :
                        if (index not in self.map_numEq_vars_defined.keys()):
                            self.map_numEq_vars_defined [index] = []
                        self.map_numEq_vars_defined [index].append(name)

                        if name not in self.map_vars_numEq.keys(): # if/else split in two in the json file
                            self.map_vars_numEq[name] = index

                # Get map [calculated var] --> [vars on which the equation depends]
                listDependVars=[]
                if "uses" in keys:
                    listDependVars = equation["uses"]
                    listDependVars = [s.encode('utf-8') for s in listDependVars]
                    for name in listDefinedVars :
                        self.map_vars_dependVars[name] = listDependVars
            elif typeEq == "initial":
                listDefinedVars=[]
                if "defines" in keys:
                    listDefinedVars = equation["defines"]
                    listDefinedVars = [s.encode('utf-8') for s in listDefinedVars]
                    for name in listDefinedVars :
                        if name not in self.initial_defined: # if/else split in two in the json file
                            self.initial_defined.append(name)


    ##
    # getter for the map associating variables to variables used to evaluate them
    # @param self: object pointer
    # @return the map associating variavles and variables used to evaluate them
    def get_mapDepVarsForFunc(self):
        return self.map_vars_dependVars

    ##
    # getter for the map associating var evaluated and index of the function evaluating them
    # @param self : object pointer
    # @return the map associating var evaluated and index of the function evaluating them
    def getMap_vars_numEq(self):
        return self.map_vars_numEq

    def getMap_numEq_vars_defined(self):
        return self.map_numEq_vars_defined

    ##
    # getter for the map associating formuala of an equation and index of the equation
    # @param self : object pointer
    # @return the map associating formuala of an equation and index of the equation
    def getMap_equation_formula(self):
        return self.map_equation_formula

    ##
    # getter for the map associating tag of the function and the index of it
    # @param self : object pointer
    # @return the map associating tag of the function and the index of it
    def getMap_tag_numEq(self):
        return self.map_tag_numEq

    ##
    # Read the _init.xml file
    # @param self : object pointer
    # @return
    def readInitXml(self):
        doc = minidom.parse(self.initXmlFile)
        root = doc.documentElement
        listVarsXml = root.getElementsByTagName('ScalarVariable')
        for node in listVarsXml:
            var = variable()
            var.setName(node.getAttribute('name'))
            var.setVariability(node.getAttribute('variability')) # "continuous", "discrete"
            var.setCausality(node.getAttribute('causality')) # "output" or "internal"
            var.setType(node.getAttribute('classType'))

            # Vars represented by an output var have an attribute
            # 'aliasVariable', which is the name of the output var
            if node.getAttribute('alias') == "alias":
                var.setAliasName( node.getAttribute('aliasVariable'), False)
            if node.getAttribute('alias') == "negatedAlias":
                var.setAliasName( node.getAttribute('aliasVariable'), True)


            # 'Start' attribute: this attribute is only assigned for real vars
            if var.getType()[0] == "r":
                listReal = node.getElementsByTagName('Real')
                if len(listReal) != 1:
                    print ("pb : readInitXml")
                    sys.exit()
                start = listReal[0].getAttribute('start')
                if start != '':
                    var.setStartText( [start] )
                    var.setUseStart(listReal[0].getAttribute('useStart'))
                else:
                    var.setUseStart("false")
            # 'Start' attribute for integer vars
            elif var.getType()[0] == "i":
                listInteger = node.getElementsByTagName('Integer')
                if len(listInteger) != 1:
                    print ("pb: readInitXml")
                    sys.exit()
                start = listInteger[0].getAttribute('start')
                if start != '':
                    var.setStartText( [start] )
                    var.setUseStart(listInteger[0].getAttribute('useStart'))
                else:
                    var.setUseStart("false")
            # 'Start' attribute for boolean vars
            elif var.getType()[0] =="b":
                listBoolean = node.getElementsByTagName('Boolean')
                if len(listBoolean) != 1:
                    print ("pb : readInitXml")
                    sys.exit()
                start = listBoolean[0].getAttribute('start')
                if start != '':
                    var.setStartText( [start] )
                    var.setUseStart(listBoolean[0].getAttribute('useStart'))
                else:
                    var.setUseStart("false")
            # 'Start' attribute for string vars
            elif var.getType()[0] =="s":
                listString = node.getElementsByTagName('String')
                if len(listString) != 1:
                    print ("pb : readInitXml")
                    sys.exit()
                start = listString[0].getAttribute('start')
                if start != '':
                    var.setStartText( [start] )
                    var.setUseStart(listString[0].getAttribute('useStart'))
                else:
                    var.setUseStart("false")

            # Vars after the read of *_init.xml
            self.listVars.append(var)


    ##
    # Read the *.xml defining the fictitious equations
    # @param self : object pointer
    # @return
    def readEqFictiveXml(self):
        # If this file does not exist, we exit
        if not os.path.isfile(self.eqFictiveXmlFile) :
            print ("Warning: xml file of fictitious variables does not exist...")
            return

        listeVarExtContinuous, listeVarExtOptionalContinuous, listeVarExtDiscrete = scriptVarExt.listExternalVariables (self.eqFictiveXmlFile)

        for variableId, defaultValue in listeVarExtContinuous:
            self.fictiveContinuousVars.append (variableId)

        for variableId, defaultValue in listeVarExtDiscrete:
            self.fictiveDiscreteVars.append (variableId)

        for variableId, defaultValue in listeVarExtOptionalContinuous:
            self.fictiveOptionalContinuousVars.append(variableId)

        for name in self.fictiveContinuousVars:
          self.fictiveContinuousVarsDer.append("der(%s)" % name)

        for name in self.fictiveOptionalContinuousVars:
          self.fictiveContinuousVarsDer.append("der(%s)" % name)

    ##
    # Read the *_model.h file
    # Find all vars with a defined type and store them in "map_vars_numOmc"
    # @param self : object pointer
    # @return
    def read_modelHeader(self):
        # Searches for real types: state + diff + discrete + algebraic
        self.getVars_from_modelHeader("realVars")

        # Search real settings
        self.getVars_from_modelHeader("realParams")

        # Search vars alg booleennes
        self.getVars_from_modelHeader("boolVars")

        # look for variables definitions
        with open(self.modelHeader, 'r') as f:
            for line in f:
                self.model_header_content.append(line.replace('\n', ''))

    ##
    # Read the header file and find all vars with a defined type and store them in "map_vars_numOmc"
    # @param self : object pointer
    # @param typeVar : type of variable to find
    # @return
    def getVars_from_modelHeader(self, typeVar):
        varPattern = None
        varNameAndNumPtrn = ""

        if typeVar == "realVars" :
            varPattern = re.compile(r'\->realVars\[')
            varNameAndNumPtrn = r'#define _\$P(?P<var>.*)\(i\).*\[(?P<num>\d+)\]$'

        elif typeVar == "realParams" :
            varPattern = re.compile(r'\.realParameter\[')
            varNameAndNumPtrn = r'#define \$P(?P<var>.*)[ ].*\[(?P<num>\d+)\]$'

        elif typeVar == "boolVars" :
            varPattern = re.compile(r'\->booleanVars\[')
            varNameAndNumPtrn = r'#define _\$P(?P<var>.*)\(i\).*\[(?P<num>\d+)\]$'

        else :
            print ("getVars_from_modelHeader : typeVar unknown.")
            sys.exit(1)


        with open(self.modelHeader, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: varPattern.search(line) is None, f)
                nextIter = next(it, None)
                if nextIter is None: break
                match = re.search(varNameAndNumPtrn, nextIter)

                # If the name of the var if of type "$DER$Pvar", we replace it by "der(var)"
                varName = to_omc_style(match.group('var'))

                self.map_vars_numOmc[varName] = match.group('num')


    ##
    # Give an omx index to variables stored in listVars
    # @param self : object pointer
    # @return
    def give_numOmc_to_vars(self):
       for var in self.listVars:
            name = to_omc_style(var.getName())
            val = find_value_in_map(self.map_vars_numOmc, name)
            if val is not None : var.setNumOmc(val)

    ##
    # Read the main c file
    # @param self: object pointer
    # @return
    def readMainC(self):
        # Reading of functions "..._eqFunction_${num}(...)"
        self.listFuncMainC = self.readFunctions(self.mainCfile, self.ptrnFuncDeclMainC, self.functionsRootName)

        # Reading the function ..._setupDataStruc(...)
        fileToRead = self.mainCfile
        # functionName = "DYNModel" + self.modName + "_setupDataStruc"
        functionName = self.modName + "_setupDataStruc"
        ptrnFuncToRead = re.compile(r'%s[ ]+%s\(.*\)[^;]$' % ("void", functionName))
        self.setupDataStruc_rawFunc = self.readFunction(fileToRead, ptrnFuncToRead, functionName)

        # Reading function ..._functionDAE(...)
        fileToRead = self.mainCfile
        functionName = self.modName + "_functionDAE"
        ptrnFuncToRead = re.compile(r'%s[ ]+%s\(.*\)[^;]$' % ("int", functionName))
        self.functionDAE_rawFunc = self.readFunction(fileToRead, ptrnFuncToRead, functionName)

        for function in self.listFuncMainC:
          for line in function.body:
              if ('data->simulationInfo->linearSystemData' in line):
                  self.LSCalculatedVariables [function.numOmc] = function.body
                  break

        ptrnComments = re.compile(r'\sequation index:[ ]*(?P<index>.*)[ ]*\n')
        commentsOpening = "/*"
        commentsEnd = "*/"
        with open(self.mainCfile, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: commentsOpening not in line, f)
                nextIter = next(it, None)
                if nextIter is None: break
                listBody = list(itertools.takewhile(lambda line: commentsEnd not in line, f))
                for line in listBody:
                    if ptrnComments.search(line) is not None:
                        match = re.search(ptrnComments, line)
                        index = match.group('index')
                        self.map_equation_formula[index] = listBody[-1].lstrip().strip('\n')
                        if "matrix" in listBody[-1]:
                            itVar = itertools.dropwhile(lambda line: "var" not in line, listBody)
                            xmlstring = '<equations>' + ''.join(list(itVar)) + '</equations>'
                            self.map_equation_formula[index] = ' '.join(xmlstring.split()).replace('"', "'")
                        break

    ##
    # Read the  *_02nls.c file
    # @param self : object pointer
    # @return
    def read_02nlsCFile(self):
        # Reading functions of type "eqFunction_". They are called in "residualFunc" (read after)
        self.listNLSclassicFunc =  self.readFunctions(self._02nlsCfile, self.ptrnEqFct_02nls, self.functionsRootName)
        # Reading residual functions of NLS (non linear system)
        self.listNLSresFunc =  self.readFunctions(self._02nlsCfile, self.ptrnNLSresFct_02nls, "residualFunc")

        ptrnComments = re.compile(r'\sequation index:[ ]*(?P<index>.*)[ ]*\n')
        commentsOpening = "/*"
        commentsEnd = "*/"
        with open(self._02nlsCfile, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: commentsOpening not in line, f)
                nextIter = next(it, None)
                if nextIter is None: break
                listBody = list(itertools.takewhile(lambda line: commentsEnd not in line, f))
                for line in listBody:
                    if ptrnComments.search(line) is not None:
                        match = re.search(ptrnComments, line)
                        index = match.group('index')
                        self.map_equation_formula[index] = listBody[-1].lstrip().strip('\n')
                        break
    ##
    # Read the  *_03lsy.c file
    # @param self : object pointer
    # @return
    def read_03lsyCFile(self):
        # Reading functions containing matrices
        self.listFuncLS_mat =  self.readFunctions(self._03lsyCfile, self.ptrnFctMat_03lsy, "setLinearMatrixA")
        # Reading functions containing rhs
        self.listFuncLS_rhs =  self.readFunctions(self._03lsyCfile, self.ptrnFctRhs_03lsy, "setLinearVectorb")
        # Reading functions of type "eqFunction_". They are called in "residualFunc" (read just after)
        self.listLSclassicFunc =  self.readFunctions(self._03lsyCfile, self.ptrnEqFct_03lsy, self.functionsRootName)
        # Reading residual functions of NLS (non linear system)
        self.listLSresFunc =  self.readFunctions(self._03lsyCfile, self.ptrnLSresFct_03lsy, "residualFunc")

        ptrnComments = re.compile(r'\sequation index:[ ]*(?P<index>.*)[ ]*\n')
        commentsOpening = "/*"
        commentsEnd = "*/"
        with open(self._03lsyCfile, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: commentsOpening not in line, f)
                nextIter = next(it, None)
                if nextIter is None: break
                listBody = list(itertools.takewhile(lambda line: commentsEnd not in line, f))
                for line in listBody:
                    if ptrnComments.search(line) is not None:
                        match = re.search(ptrnComments, line)
                        index = match.group('index')
                        self.map_equation_formula[index] = listBody[-1].lstrip().strip('\n')
                        break

    ##
    # Read the *_06inz.c to find initial value of variables
    # @param self : object pointer
    # @return
    def read_06inzCFile(self):
        global nbBracesOpened
        global crossedOpeningBraces
        global stopAtNextCall

        # Find functions of type MODEL_NAME_eqFunction_N and variable assignment expressions
        # Regular expression to recognize a line of type $Pvar = $Prhs
        ptrnAssignVar = re.compile(r'^[ ]*\$P(?P<var>\S*)[ ]*=[ ]*(?P<rhs>[^;]+);')
        with open(self._06inzCfile, 'r') as f:
            while True:
                nbBracesOpened = 0
                crossedOpeningBraces = False
                stopAtNextCall = False

                it = itertools.dropwhile(lambda line: self.ptrnFuncDeclMainC.search(line) is None, f)
                nextIter = next(it, None) # Line on which "dropwhile" stopped
                if nextIter is None: break # If we reach the end of the file, exit loop
                match = re.search(self.ptrnFuncDeclMainC, nextIter)
                numFunction = match.group('num')

                # "takewhile" only stops when the whole body of the function is read
                listBody = list(itertools.takewhile(stopReadingFunction, it))

                for line in listBody:
                    if ptrnAssignVar.search(line) is not None:
                        match = re.search(ptrnAssignVar, line)
                        var = "$P"+str(match.group('var'))
                        rhs = match.group('rhs')
                        # rejection of inits of type var = ATTRIBUTE$.. and var = $P$PRE
                        if '$P$ATTRIBUTE$' not in rhs and '$P$PRE$' not in rhs and 'data->simulationInfo' not in rhs:
                            self.var_initVal06Inz[ to_classic_style(var) ] = listBody
                            self.var_numInitVal06Inz[to_classic_style(var)] = numFunction
                            break
                        elif ('data->simulationInfo->linearSystemData' in rhs):
                            self.LSCalculatedVariables [numFunction] = listBody
                            break

        ptrnComments = re.compile(r'\sequation index:[ ]*(?P<index>.*)[ ]*\n')
        commentsOpening = "/*"
        commentsEnd = "*/"
        with open(self._06inzCfile, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: commentsOpening not in line, f)
                nextIter = next(it, None)
                if nextIter is None: break
                listBody = list(itertools.takewhile(lambda line: commentsEnd not in line, f))
                for line in listBody:
                    if ptrnComments.search(line) is not None:
                        match = re.search(ptrnComments, line)
                        index = match.group('index')
                        self.map_equation_formula[index] = listBody[-1].lstrip().strip('\n')
                        break


        # Look for MODEL_initial_residual type functions due to extend commands
        extendFunctionName = "_initial_residual(DATA *data, double *initialResiduals)"
        extendAssignVar = "initialResiduals[i++]"
        with open(self._06inzCfile, 'r') as f:
            while True:
                nbBracesOpened = 0
                crossedOpeningBraces = False
                stopAtNextCall = False

                it = itertools.dropwhile(lambda line: extendFunctionName not in line, f)
                nextIter = next(it, None) # Line on which "dropwhile" stopped
                if nextIter is None: break # If we reach the end of the file, exit loop

                # "takewhile" only stops when the whole body of the function is read
                listBody = list(itertools.takewhile(stopReadingFunction, it))

                for line in listBody:
                    if extendAssignVar in line:
                        # extract the part of the line related to the assignment
                        subLine = line[line.index(extendAssignVar) + len(extendAssignVar) + 3:]
                        index_plus = 99999
                        index_minus = 99999
                        if ("+" in subLine and "-" in subLine):
                            index_plus = subLine.index("+")
                            index_minus = subLine.index("-")
                        elif ("+" in subLine and "-" not in subLine):
                            index_plus = subLine.index("+")
                        elif ("+" not in subLine and "-" in subLine):
                            index_minus = subLine.index("-")

                        var = "" # variable to assign
                        assignment = "" # assignment
                        if "(" in subLine:
                            var = subLine [subLine.index("(") + 1 : min(index_plus, index_minus)]

                            if (index_plus < index_minus):
                                assignment += "(-1) * ("

                            assignment += subLine [min(index_plus, index_minus) + 1 : subLine.index(";") - 1]

                            if (index_plus < index_minus):
                                assignment += ")"

                        elif ("+" not in subLine and "-" not in subLine):
                            if ("*" in subLine or "/" in subLine):
                                print("error during equations export due to extends")
                                sys.exit(1)

                            # where we use extends (x = 0)
                            var = subLine [:subLine.index(";")]
                            assignment = "0"

                        # the assignment line is composed of:
                        # spaces for indentation
                        # the name of the variable to assign
                        # the assignment formula
                        # the end of line
                        newLine = line [:line.index(extendAssignVar)] + var + " = " + assignment + ";"
                        self.var_initVal06Extend [to_classic_style(var)] = newLine

    ##
    # Initialise variables in listVars by values found in 06inz file
    # @param self : object pointer
    # @return
    def setStartValueForSystVars06Inz(self):
        for key, value in self.var_initVal06Inz.iteritems():
            for var in self.listVars:
                if var.getName() == key:
                    var.setStartText06Inz(value)
                    var.setInitByParamIn06Inz(True)
                    var.setNumFunc06Inz(self.var_numInitVal06Inz[var.getName()])

        for varName, varAssignment in self.var_initVal06Extend.iteritems():
            for var in self.listVars:
                if var.getName() == varName:
                    var.setStartText06Inz(['{/n', varAssignment, '}'])
                    var.setInitByExtendIn06Inz(True)

    ##
    # Retrieve the ordered calculated variables for linear systems
    # @param self : object pointer
    # @param OMC_equation_index : the OMC equation index
    # @return the ordered list of calculated variables
    def LinearSystemCalculatedVariables (self, OMC_equation_index):
        if (OMC_equation_index not in self.LSCalculatedVariables.keys()):
            print("pb : LinearSystemCalculatedVariables")
            sys.exit(1)
        else:
            string_to_find = "data->simulationInfo->linearSystemData["
            initial_variables_list = []
            for line in self.LSCalculatedVariables [OMC_equation_index]:
                if (string_to_find in line):
                    variable_name = to_classic_style (line [:line.find("=")])
                    if string_to_find in variable_name:
                        continue
                    # find .x[VAL] to retrieve the variable index
                    end_of_found_string = line.find(string_to_find) + len (string_to_find)
                    opening_index = line [end_of_found_string:].find (".x[") + len (".x[")
                    closing_index = line [end_of_found_string + opening_index:].find ("]")

                    variable_index = int (line[end_of_found_string + opening_index : end_of_found_string + opening_index + closing_index ])
                    initial_variables_list.append((variable_name, variable_index))

            # sort the list of variables according to their index
            initial_variables_list.sort (key=lambda tup: tup[1])
            variables_list = []
            for (variable_name, variable_index) in initial_variables_list:
                variables_list.append (variable_name)

            return variables_list


    ##
    # Read the *_08nbd.c to find initial value of variables
    # @param self : object pointer
    # @return
    def read_08bndCFile(self):
        global nbBracesOpened
        global crossedOpeningBraces
        global stopAtNextCall
        # Regular expression to recognize a line of type $Pvar = $Prhs
        ptrnAssignVar = re.compile(r'^[ ]*\$P(?P<var>\S*)[ ]*=[^;]*;$')
        with open(self._08bndCfile, 'r') as f:
            while True:
                nbBracesOpened = 0
                crossedOpeningBraces = False
                stopAtNextCall = False

                it = itertools.dropwhile(lambda line: self.ptrnFuncDeclMainC.search(line) is None, f)
                nextIter = next(it, None) # Line on which "dropwhile" stopped
                if nextIter is None: break # If we reach the end of the file, exit loop

                # "takewhile" only stops when the whole body of the function is read
                listBody = list(itertools.takewhile(stopReadingFunction, it))

                for line in listBody:
                    if ptrnAssignVar.search(line) is not None:
                        match = re.search(ptrnAssignVar, line)
                        var = "$P"+str(match.group('var'))
                        self.var_initVal[ to_classic_style(var) ] = listBody

                for line in listBody:
                    if 'omc_assert_warning(' in line:
                        self.warnings.append(listBody)

        ptrnComments = re.compile(r'\sequation index:[ ]*(?P<index>.*)[ ]*\n')
        commentsOpening = "/*"
        commentsEnd = "*/"
        with open(self._08bndCfile, 'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: commentsOpening not in line, f)
                nextIter = next(it, None)
                if nextIter is None: break
                listBody = list(itertools.takewhile(lambda line: commentsEnd not in line, f))
                for line in listBody:
                    if ptrnComments.search(line) is not None:
                        match = re.search(ptrnComments, line)
                        index = match.group('index')
                        self.map_equation_formula[index] = listBody[-1].lstrip().strip('\n')
                        break
    ##
    #  Initialise variables in listVars by values found in 08bnd file
    # @param self : object pointer
    # @return
    def setStartValueForSystVars(self):
        for key, value in self.var_initVal.iteritems():
            for var in self.listVars:
                if var.getName() == key:
                    var.setStartText(value)
                    var.setInitByParam(True) # Indicates that the var is initialized with a param

    ##
    # Read *_05evt.c file, and try to find declarations of zeroCrossing functions :
    # @param self : object pointer
    # @return
    def read_05evtCFile(self):
        # Reading body of *_function_ZeroCrossings(...) function
        fileToRead = self._05evtCfile
        functionName = self.modName + "_function_ZeroCrossings"

        ptrnFuncToRead = re.compile(r'%s[ ]+%s\(.*\)[^;]$' % ("int", functionName))
        self.functionZeroCrossings_rawFunc = self.readFunction(fileToRead, ptrnFuncToRead, functionName)

        functionName = self.modName + "_zeroCrossingDescription"
        ptrnFuncToRead = re.compile(r'%s[ ]+[*]+%s\(.*\)[^;]$' % ("const char", functionName))
        self.functionZeroCrossingDescription_rawFunc = self.readFunction(fileToRead, ptrnFuncToRead, functionName)


    ##
    # read _structure.xml file
    # @param self : object pointer
    # @return
    def read_structXmlFile(self):
        doc = minidom.parse(self.structXmlFile)
        root = doc.documentElement
        # read file structures
        elements = root.getElementsByTagName('elements')

        # list of structures/terminals encountered during reading
        list_struct = []
        self.list_elements=[]
        if(len(elements) > 0 ):
            for nodeElement in elements:
                # reading structures
                nodesStruct = nodeElement.getElementsByTagName('struct')
                for node in nodesStruct:
                    structName = node.getElementsByTagName('name')[0].firstChild.nodeValue
                    nodeTerminal = node.getElementsByTagName('terminal')[0]
                    nameTerminal = nodeTerminal.getElementsByTagName('name')[0].firstChild.nodeValue
                    connectorNode =  nodeTerminal.getElementsByTagName('connector')[0]
                    typeConnector = str(connectorNode.getAttribute('type'))
                    compoName=structName + "."+nameTerminal

                    # we store all this in an object
                    structure = Element(True,structName,len(self.list_elements))
                    if structName not in list_struct:
                        list_struct.append(structName)
                        self.list_elements.append(structure)
                        self.map_structName_structObj[structName] = structure
                    else:
                        structure =  self.map_structName_structObj[structName]

                    # terminal name can be composed of a sub-structure (or several) and the actual name of the terminal
                    splitName = nameTerminal.split('.')
                    structName1 = structName
                    structure1 = structure
                    if(len(splitName)>1): #terminal is composed of substructure:
                        listOfStructure=splitName[0:len(splitName)-1]
                        for struct in listOfStructure:
                            structName1=structName1+"."+struct
                            if structName1 not in list_struct:
                                s =  Element(True, structName1, len(self.list_elements));
                                list_struct.append(structName1)
                                self.list_elements.append(s)
                                self.map_structName_structObj[structName1] = s
                                structure1.listElements.append(s)
                                structure1=s
                            else:
                                structure1 = self.map_structName_structObj[structName1]

                    terminal = Element(False, compoName, len(self.list_elements))
                    self.list_elements.append(terminal)
                    structure1.listElements.append(terminal)

                    #Find vars that are "flow"
                    if typeConnector == "Flow" :  self.list_flow_vars.append(compoName)

                # reading terminals
                for child in nodeElement.childNodes:
                    if child.nodeType== child.ELEMENT_NODE:
                        if child.localName=='terminal':
                            name = child.getElementsByTagName('name')[0].firstChild.nodeValue
                            typeTerminal = child.getElementsByTagName('type')[0].firstChild.nodeValue
                            connectorNode =  child.getElementsByTagName('connector')[0]
                            typeConnector = str(connectorNode.getAttribute('type'))

                            splitName = name.split('.')
                            nameTerminal=name
                            structName1 =""
                            structure1 = Element(True,"")
                            if (len(splitName)> 1): #component name: terminal name: last in the list, the rest is a composite of structures
                                listOfStructure=splitName[0:len(splitName)-1]
                                for struct in listOfStructure:
                                    if structName1 != "":
                                        structName1=structName1+"."+struct
                                    else:
                                        structName1 = struct
                                    if structName1 not in list_struct:
                                        s =  Element(True,structName1,len(self.list_elements));
                                        list_struct.append(structName1)
                                        self.list_elements.append(s)
                                        self.map_structName_structObj[structName1] = s
                                        structure1.listElements.append(s)
                                        structure1=s
                                    else:
                                        structure1 = self.map_structName_structObj[structName1]

                            terminal = Element(False,nameTerminal,len(self.list_elements))
                            self.list_elements.append(terminal)
                            structure1.listElements.append(terminal)

                             #Find vars that are "flow"
                            if typeConnector == "Flow" :  self.list_flow_vars.append(name)


    ##
    # Read _functions.h file and store internal/external functions declaration
    # @param self : object pointer
    # @return
    def read_functionsHeader(self):
        ptrnFuncExtern = re.compile(r'extern .*;')
        ptrnFunc = re.compile(r'.*;')
        ptrnNotFunc = re.compile(r'static const MMC_.*;')
        ptrnStruct = re.compile(r'.*typedef struct .* {.*')

        fileToRead = self._functionsHeader
        if not os.path.isfile(fileToRead) :
            return

        with open(fileToRead,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: ptrnFuncExtern.search(line) is None, f)
                nextIter = next(it,None) # Line on which "dropwhile" stopped
                if nextIter is None: break # If we reach the end of the file, exit loop
                self.list_external_functions.append(nextIter)

        with open(fileToRead,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: (ptrnFunc.search(line) is None) and (ptrnStruct.search(line) is None), f)
                nextIter = next(it,None) # Line on which "dropwhile" stopped
                if nextIter is None: break # If we reach the end of the file, exit loop
                if nextIter not in self.list_external_functions:
                    if ptrnNotFunc.search(nextIter) is None:
                        self.list_internal_functions.append(nextIter)


    ##
    # Read *_literals.h file and store all string declaration with type '_OMC_LIT'
    # @param self : object pointer
    # @return
    def read_literalsHFile(self):
        fileToRead = self._literalsFile
        if not os.path.isfile(fileToRead):
            return

        ptrnVar = re.compile(r'#define _OMC_LIT.*')
        ptrnVar1 = re.compile(r'static const MMC_DEFSTRINGLIT*')
        ptrnVar2 = re.compile(r'static const modelica_integer _OMC_LIT.*')

        with open(fileToRead,'r') as f:
            while True:
                it = itertools.dropwhile(lambda line: (ptrnVar.search(line) is None) and (ptrnVar1.search(line) is None)\
                                         and (ptrnVar2.search(line) is None), f)
                nextIter = next(it, None) # Line on which "dropwhile" stopped
                if nextIter is None: break # If we reach the end of the file, exit loop

                self.list_vars_literal.append(nextIter)

    ##
    # Read *_functions.c file and store all functions' body declared
    # @param self : object pointer
    # @return
    def read_functionsCfile(self):
        fileToRead = self._functionsCfile
        if not os.path.isfile(fileToRead) :
            return

        global nbBracesOpened
        global crossedOpeningBraces
        global stopAtNextCall
        ptrnFunc = re.compile(r'.* (?P<var>.*)\(.*\)')
        with open(fileToRead, 'r') as f:
            while True:
                nbBracesOpened = 0
                crossedOpeningBraces = False
                stopAtNextCall = False

                it = itertools.dropwhile(lambda line: ptrnFunc.search(line) is None, f)
                nextIter = next(it, None) # Line on which "dropwhile" stopped
                if nextIter is None: break # If we reach the end of the file, exit loop

                match = re.search(ptrnFunc, nextIter)

                if ";" not in nextIter: # it is a function declaration
                    func = RawOmcFunctions()
                    func.setName(match.group('var'))
                    func.setSignature(nextIter)
                    func.setReturnType(nextIter.split()[0])

                    # "takewhile" only stops when the whole body of the function is read
                    func.setBody( list(itertools.takewhile(stopReadingFunction, it)) )
                    self.listOmcFunctions.append(func)
