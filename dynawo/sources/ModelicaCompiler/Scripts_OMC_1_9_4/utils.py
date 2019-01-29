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
# Model writer utility functions : all functions/class usefull for the model writer
#

import re
import os
import sys
import itertools

##
# Indicates whether is the variable a derivative variable
#
# @param varName : name of the variable
# @return @b true if the variable is a derivative variable
def isDer(varName):
    ptrn_derVar = re.compile(r'der\((\S*)\)$')
    return ptrn_derVar.search(varName) is not None

##
# Transforms the variable name to omc style variable name
# var -> $Pvar
# der(var) -> $P$DER$var
#
# @param varName : variable name to transform
# @return the variable name with omc style
def to_omc_style(varName):

    name = ""
    if isDer (varName):
        ptrn_derVar = re.compile(r'der\((\S*)\)$')
        name = ptrn_derVar.sub(r'$P$DER$P\g<1>', varName)
    else:
        name = "$P%s" % varName

    name = name.replace(".","$P")
    name = name.replace("[","$lB")
    name = name.replace("]","$rB")
    name = name.replace(",","$c")
    return name

##
# replace '.' by '_' so that varName should be correctly analyse by gcc
# replace ']' by '_' A[1] => A_1_
# replace ']' by '_'
# replace ',' by '_' A[1,1] => A_1_1_
# @param varName : input name of the variable
# @return the variable name without '.'
def to_compile_name(varName):
    name = varName.replace(".","_")
    name = name.replace("[","_")
    name = name.replace("]","_")
    name = name.replace(",","_")
    return name

##
# transforms variable name from omc style to classic style
#
# $Pvar -> var
# $P$DER$PvarName -> der(varName)
#
# @param varName : input variable name
# @return the variable name with classic style
def to_classic_style(varName):
    # search for the derivative of variables being component of a 2D table
    ptrnDerVar = re.compile(r'\$P\$DER\$P(?P<var>\S*)\$lB(?P<int1>\S*)\$c(?P<int2>\S*)\$rB')
    match = re.search(ptrnDerVar, varName)
    if match is not None :
        derVar = "der("+match.group('var')
        derVar = derVar.replace("$P",".")
        derVar = derVar + "[" + match.group('int1') + "," + match.group('int2') + "]"+")"
        return derVar

    # search for variables being component of a 2D table
    ptrnVar = re.compile(r'\$P(?P<var>\S*)\$lB(?P<int1>\S*)\$c(?P<int2>\S*)\$rB')
    match = re.search(ptrnVar, varName)
    if match is not None :
        var = match.group('var')
        var =  var.replace("$P",".")
        var = var + "[" + match.group('int1') + "," + match.group('int2') + "]"
        return var

    # search for the derivative of variables being component of a vector
    ptrnDerVar = re.compile(r'\$P\$DER\$P(?P<var>\S*)\$lB(?P<int>\S*)\$rB')
    match = re.search(ptrnDerVar, varName)
    if match is not None :
        derVar = "der("+match.group('var')
        derVar = derVar.replace("$P",".")
        derVar = derVar + "[" + match.group('int') + "]"+")"
        return derVar

    # search for variables being component of a vector
    ptrnVar = re.compile(r'\$P(?P<var>\S*)\$lB(?P<int>\S*)\$rB')
    match = re.search(ptrnVar, varName)
    if match is not None :
        var = match.group('var')
        var =  var.replace("$P",".")
        var = var + "[" + match.group('int') + "]"
        return var

    # search for the derivative of variables
    ptrnDerVar = re.compile(r'\$P\$DER\$P(?P<var>\S*)')
    match = re.search(ptrnDerVar, varName)
    if match is not None :
        derVar = "der("+match.group('var')+")"
        derVar = derVar.replace("$P",".")
        return derVar

    # search for variables
    ptrnVar = re.compile(r'\$P(?P<var>\S*)')
    match = re.search(ptrnVar, varName)
    if match is not None :
        var = match.group('var')
        var =  var.replace("$P",".")
        return var

    return varName

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
def stopReadingBlock(element):
    global nbBracesOpened
    global stopAtNextCall
    global crossedOpeningBraces
    if stopAtNextCall and crossedOpeningBraces : return False
    nbBracesOpened += countOpeningBraces(element)
    nbBracesOpened -= countClosingBraces(element)
    if nbBracesOpened != 0 : crossedOpeningBraces = True
    elif crossedOpeningBraces : stopAtNextCall = True
    return True

##
# throws an error and exit
# @param errorMessage : the message to display
# @param errorCode : the error code to send back
def errorExit(errorMessage, errorCode = 1):
    print(errorMessage)
    sys.exit(errorCode)

##
# check if the file exist
#
# @param fileName : name of the file to check
#
# @throw sys.exit() if the file does not exist
def existFile(fileName):
    if not os.path.isfile(fileName) :
        errorExit ("%s does not exist" % fileName)


##
# write a content into a given file
#
# @param content : the content to write as a table of string
# @param destination_file_path : the full path to the destination file
# @throw sys.exit() if the user does not have write rights
def write_file (content, destination_file_path):
    # check whether write rights are granted
    try:
        open (destination_file_path, 'w').close()
    except:
        errorExit ("failed to open %s with write rights" % destination_file_path)

    # write the file
    f = open (destination_file_path, 'w')
    for line in content:
        f.write(line)
    f.close()

##
# Look at a key in a map and return value associated to the key
#
# @param a_map : map where the key should be found
# @param the_key: key to find in the map
#
# @return : the value associated to the key, if the key exists, None otherwise
def find_value_in_map(a_map, the_key):
    for key, value in a_map.iteritems():
        if key == the_key:
            return value
    return None

##
# Look at a value in a map and return key associated to the value
#
# @param a_map : map where the value should be found
# @param the_value : value to find in the map
#
# @return : the key associated to the value, if the value exists, None otherwise
def find_key_in_map(a_map, the_value):
    for key, value in a_map.iteritems():
        if value == the_value:
            return key
    return None

##
# Look at a value in a map and return keys associated to the value
#
# @param a_map : map where the value should be found
# @param the_value : value to find in the map
#
# @return : a list of keys associated to the value (empty list if the value does not exist)
def find_keys_in_map(a_map, the_value):
    list_keys = []
    for key, value in a_map.iteritems():
        if value == the_value:
            list_keys.append( key )
    return list_keys


##
# Find a division expression in a line
# @param line line  to analize
# @param startPos : pointer in the line where the division begins
# @returns : the division expression
def getDivBlock_SIM(line, startPos):
    nbBrackets = 1
    endPos = len(line)

    currentPos = startPos
    for char in line[startPos:]:
       if char == "(" : nbBrackets += 1
       if char == ")" : nbBrackets -= 1
       if nbBrackets == 0:
	    endPos = currentPos
	    break
       currentPos += 1
    return "DIVISION_SIM(" + line[startPos:endPos] + ")"

##
# Find an expression between brackets in a line
# @param line line to analize
# @param startPos : pointer in the line where the expression begins
# @returns : the expression
def getArgument(line, startPos):
    nbBrackets = 0
    endPos = len(line)

    currentPos = startPos
    for char in line[startPos:]:
       if char == "(" : nbBrackets += 1
       if char == ")" : nbBrackets -= 1
       if char == "," and nbBrackets == 0:
	    endPos = currentPos
	    break
       currentPos += 1
    return line[startPos:endPos], endPos


##
# Replace pow by pow_dynawo in line
# @param line line to analize
# @returns : the line with the new expression
def replacePow(line):
    lineToReturn = line
    if 'pow(' in line:
        lineToReturn = lineToReturn.replace("pow(", "pow_dynawo(")
    return lineToReturn

##
# Replace a DIVISION expression in a line by a/b
# @param line line to analize
# @returns : the line with the new expression
def subDivisionSIM(line):
    lineToReturn = line
    ptrnDiv = re.compile(r'DIVISION_SIM\(')
    nbIter = 0
    while True:
        match = ptrnDiv.search(lineToReturn)
	if match is None : break
        else:
	    posStartDiv = match.end()
	    divBlock = getDivBlock_SIM(lineToReturn, posStartDiv)

            arg1, endPosArg1 = getArgument(lineToReturn, posStartDiv)
            arg2, endPosArg2 = getArgument(lineToReturn, endPosArg1 + 1)
	    lineToReturn = lineToReturn.replace(divBlock, "("+arg1 + ") / (" + arg2+")")

	nbIter += 1

	if nbIter == 5:
            errorExit("pb avec subDivision_SIM. " + line)
    return lineToReturn

##
# Replace throwStreamPrintEquation by throwStreamPrint
# @param line : line where expression should be replaced
# @returns new line expression
def throwStreamIndexes(line):
    pattern = "throwStreamPrintWithEquationIndexes(threadData, equationIndexes"
    pattern_bis = "throwStreamPrintWithEquationIndexes(data->threadData, equationIndexes"
    pattern1 = "throwStreamPrint("
    pattern1_bis = "throwStreamPrint("
    lineToReturn = line
    if pattern in line:
        lineToReturn = line.replace(pattern,pattern1)
    elif pattern_bis in line:
        lineToReturn = line.replace(pattern_bis, pattern1_bis)

    return lineToReturn

##
# Replace the mmc_strings_len1 macro by the mmc_strings_len1 function
# @param line : line where expression should be replaced
# @returns new line expression
def mmc_strings_len1(line):
    ptrnMMC = re.compile(r'mmc_strings_len1\[(?P<var>\d+)\]')
    pattern = "mmc_strings_len1"
    lineToReturn = line
    if pattern in line:
        match = re.search(ptrnMMC, line)
        if match is not None:
            nbDigits = match.group('var')
            fullWord = '(modelica_string) '+ pattern+'['+str(nbDigits)+']'
            fullWord1 = pattern+'('+str(nbDigits)+')'
            lineToReturn = line.replace(fullWord,fullWord1)
    return lineToReturn

##
# Replace some expressions by other expressions
# @param txtList : whole text to analyse
# @returns: new text
def makeVariousTreatments(txtList):
    """
       Different treatments on a list of text lines.
       See comments in the body of this function.
    """
    txtListToReturn = txtList

    # Replace DIVISION(a1,a2,a3) ==> a1 / a2
    # Difficult to do this with a regex and a sub, so we use
    # the function "subDivision()"
    txt_tmp = []
    for line in txtListToReturn:
        line_tmp = subDivisionSIM(line) # Difficult to do this with a regex and a sub.
        txt_tmp.append(line_tmp)

    txtListToReturn = txt_tmp

    # Sample block to process:
    # -------------------------
    # if(!(tmp62 >= 0.0))
    # {
    #     FILE_INFO info = {"",0,0,0,0,0};
    #     omc_assert(info, "Model error: Argument of sqrt(E02) was %g should be >= 0", tmp62);
    # }
    #
    # Replace by:
    # ---------------
    # if(!(tmp62 >= 0.0))
    # {
    #     assert(0 && "Model error: Argument of sqrt should be >= 0");
    # }

    txt_tmp = []
    for line in txtListToReturn:
        if "FILE_INFO" in line : continue

    # Line that does not call for processing:
	txt_tmp.append(line)

    txtListToReturn = txt_tmp

    return txtListToReturn



##
# Class containing a map associated name variable with its reference in x,xd list
# Translate $Pvar or $P$DER$Pvar to x[i], xd[i], ...
# Thanks to that, variable name could be replace by value variable in mathematical expressions
class Transpose:
    ##
    # Default constructor
    # @param a_map : map associating var name to var value
    # @param txtList : expressions where var name should be replaced
    def __init__(self, a_map = None, txtList = None):
	## pattern to intercept var name in expression
	self.ptrnVars = re.compile(r'\$P\$DER[\w\$]+|\$P[\w\$]+')
        ## map associating var name to var value
	self.map = {}
        ## expressions where var name should be replaced
	self.txtList = []

        if a_map is not None:
	    self.map = a_map
	if txtList is not None:
	    self.txtList = txtList

    ##
    # set the expressions where var name should be replaced
    # @param self : object pointer
    # @param txtList : list of expressions
    # @return
    def setTxtList(self, txtList):
        self.txtList = txtList

    ##
    # Run through all expressions and replace all var name contains in map by var value
    # @param self: object pointer
    # @return the list of expressions with var name replaced
    def translate(self):
        tmp_txtList = []
        for line in self.txtList:
            line_tmp = line # Line changed by overrides
            match = self.ptrnVars.findall(line) # Is this a word that matches the regex?
            iterMatch = self.ptrnVars.finditer (line)
            line_tmp = line_tmp.replace ('$PRE$P', '@@@@@@@')
            # first the $PDER then the vars
            for name in match:
                if '$P$DER' not in name:
                    continue
                # If the var "name" is in the map, we replace it by its other expression (self.map[name])
                if self.map.has_key(name):
                    name_ptrn = re.sub(r'\$', '\$', name) # Replace $ in "name" by \$ in "name_ptrn" for the following line suivante
                    line_tmp = re.sub(r'%s([^\w])' % name_ptrn, '%s\g<1>' % self.map[name], line_tmp)
            for name in match:
                if '$P$DER' in name:
                    continue
                # If the var "name" is in the map, we replace it by its other expression (self.map[name])
                if self.map.has_key(name):
                    name_ptrn = re.sub(r'\$', '\$', name) # Replace $ in "name" by \$ in "name_ptrn" for the following line suivante
                    line_tmp = re.sub(r'%s([^\w])' % name_ptrn, '%s\g<1>' % self.map[name], line_tmp)
            line_tmp = line_tmp.replace ('@@@@@@@', '$PRE$P')
            tmp_txtList.append(line_tmp)
	return tmp_txtList


##
# class watcherBlock
#
class watcherBlock:
    ##
    # Default constructor
    # @param listSubStr : list of string to find in a block
    def __init__(self, listSubStr = None):
        ## list of string to find in a block
        self.listSubStr = []

        if listSubStr is not None:
	    self.listSubStr = listSubStr
    ##
    # Call method
    # @param line : line to analyse
    # @return @b False if no string in list are found in the line
    def __call__(self, line):
        for subStr in self.listSubStr:
	    if subStr not in line:
	        return True
	return False

##
# class watcherIntroBlock
#
class watcherIntroBlock:
    ##
    # Default constructor
    # @param listSubStr : list of string to find in a block
    def __init__(self, listSubStr = None):
        ## list of string to find in a block
        self.listSubStr = []

        if listSubStr is not None:
	    self.listSubStr = listSubStr
    ##
    # Call method
    # @param line : line to analyse
    # @return @b True if no string in list are found in the line
    def __call__(self, line):
        for subStr in self.listSubStr:
	    if subStr in line:
	        return False
	return True

def extractBlock(block, listSubString):
    """
      - Recovery of all instructions before any block (lines
        not including any substrings of listSubString)
      - Recovery of the interesting block: the one introduced by a line
        with all substrings of listSubString
      - post processing of the block: we delete the braces at the beginning and end of the block
    """
    wIntroBlock = watcherIntroBlock(listSubString)
    wBlock = watcherBlock(listSubString)


    global nbBracesOpened
    global crossedOpeningBraces
    global stopAtNextCall

    nbBracesOpened = 0
    crossedOpeningBraces = False
    stopAtNextCall = False

    # We recover the declarations of the vars used in the block: all the lines
    # before finding an "if" block
    introBlockToCatch = []
    introBlockToCatch.extend( list(itertools.takewhile(wIntroBlock, block)) )
    # Added spaces in front of each line
    introBlockToCatch = ["  " + line for line in introBlockToCatch]

    # Then we neglect all lines until the block
    it = itertools.dropwhile(wBlock, block)
    nextIter = next(it, None) # Line on which "dropwhile" stopped

    if nextIter is None: return # If we reach the end of the file, exit.

    # We recover the block
    blockToCatch = list(itertools.takewhile(stopReadingBlock, it))

    # Delete lines with a single brace at the beginning and end of the block
    # ... Intercept a line containing only a brace (opening or closing) and spaces
    ptrnOnlyOneOpeningBrace = re.compile(r'^\s*{\s*$')
    ptrnOnlyOneClosingBrace = re.compile(r'^\s*}\s*$')
    match1 = re.search(ptrnOnlyOneOpeningBrace, blockToCatch[0])
    match2 = re.search(ptrnOnlyOneClosingBrace, blockToCatch[len(blockToCatch)-1])
    #... Delete
    if match1 is not None and match2 is not None:
	blockToCatch.pop(0)
	blockToCatch.pop()

    blockToCatch = introBlockToCatch + blockToCatch

    return blockToCatch

##
# Analyse the number of opening/closing brackets in a expression
# and add one opening/closing brackets if one missing
#  @param word : expression to analyse
#  @return new expression
def analyseBracket(word):
    ## allows you to balance the number of opening / closing parentheses
    openBracket=len(re.findall(r'\(', word))
    closeBracket=len(re.findall(r'\)', word))

    if openBracket == closeBracket:
        return word

    if openBracket < closeBracket:
        nb = closeBracket - openBracket
        newWord=""
        for i in range(1,nb+1):
            newWord = '(' + newWord
        newWord += word
        return newWord

    if closeBracket < openBracket:
        nb = openBracket - closeBracket
        newWord=""
        for i in range(1,nb+1):
            newWord = ')' + newWord
        newWord = word + newWord
        return newWord

##
# Analyse and replace ternary expression:
# @param line : line to analyze
# @param body : body where the new expression should be added
# @param numTernary : num of boolean to create to replace ternary expression
def analyseAndReplaceTernary(line,body,numTernary):
   patternTernary = re.compile(r'.*\((?P<var>.*\?.*:.*)\).*')  #look for for ternary operator identifiable by (A ? B : C)

   patternTernary1 = re.compile(r'.*\(\((?P<var>.*\)\?.*:.*)\).*') #look for for ternary operator identifiable by ((A)? B: C)

   patternCond = re.compile(r'.*\((?P<var>.*)\?.*') #look for the condition
   patternCond1 = re.compile(r'.*\(\((?P<var>.*)\)\?.*') #look for the condition
   patternVar1 = re.compile(r'.*\?(?P<var1>.*):.*') #look for num 1
   patternVar2 = re.compile(r'.*:(?P<var2>.*)\).*') #look for possibility number 2

   ternary=""
   cond=""
   cond1=""
   var1=""
   var2=""
   ternaryType1= False

   if 'omc_assert_warning' in line: # ternary operator in assert, nothing to do
       body.append(line)
       return

   # look for ternary operator
   matchT = re.search(patternTernary1,line)
   if matchT is not None:
       ternary = analyseBracket(str(matchT.group('var')))
       ternaryType1 = True
   else:
       matchT = re.search(patternTernary,line)
       if matchT is not None:
           ternary = analyseBracket(str(matchT.group('var')))

   # look for the condition of the operator
   if ternaryType1:
       match = re.search(patternCond1,line)
       if match is not None:
           cond = analyseBracket(str(match.group('var')))
   else:
       match = re.search(patternCond,line)
       if match is not None:
           cond = analyseBracket(str(match.group('var')))

   # look for possibility 1
   match1 = re.search(patternVar1,line)
   if match1 is not None:
       var1 = analyseBracket(match1.group('var1'))

   # look for possibility 2
   match2 = re.search(patternVar2,line)
   if match2 is not None:
       var2 = analyseBracket(match2.group('var2'))

   firstWord = line.split()[0]
   blanck = line[0 : line.find(firstWord)] # number of black lines to format

   body.append(blanck+"adept::adouble tmpTernary"+str(numTernary)+";\n")
   body.append(blanck+"if("+cond+")\n")
   body.append(blanck+"{\n")
   body.append(blanck+"    tmpTernary"+str(numTernary)+" = "+var1+";\n")
   body.append(blanck+"}\n")
   body.append(blanck+"else\n")
   body.append(blanck+"{\n")
   body.append(blanck+"    tmpTernary"+str(numTernary)+" = "+var2+";\n")
   body.append(blanck+"}\n")
   newLine = line.replace(ternary,"tmpTernary"+str(numTernary))
   body.append(newLine)

##
# Transform ternary expression in if/else expression
# @param body : body to analyse
# @param numTernary : num to use when creating new boolean condition
# @return newBody without ternary expression
def transformTernaryOperator(body,numTernary):
    newBody = []

    for line in body:
        if line.find("?") != -1:
            # analysis of the line ....
            analyseAndReplaceTernary(line,newBody,numTernary)
        else:
            newBody.append(line)

    return newBody

##
# Transform omc_Modelica_Math_atan3 expression to atan2
# @param line : line to analyse
# @return line transformed
def transformAtan3Operator(line):
    line = line.replace('threadData,','')
    atan3_ptrn = re.compile(r'omc_Modelica_Math_atan3\(\s*(?P<var1>.*)\s*,\s*(?P<var2>.*)\s*,\s*0.0\)')
    line_tmp = atan3_ptrn.sub('atan2(\g<var1>,\g<var2>)',line)

    atan3_ptrn_bis = re.compile(r'omc_Modelica_Math_atan3\(\s*(?P<var1>.*)\s*,\s*(?P<var2>.*)\s*,\s*0.0\)')
    line_tmp_bis = atan3_ptrn_bis.sub('atan2(\g<var1>,\g<var2>)',line_tmp)

    return line_tmp_bis

##
# Transform omc_Modelica_Math_atan3 expression to atan
# @param line : line to analyse
# @return line transformed
def transformAtan3OperatorEvalF(line):
    line = line.replace('threadData,','')
    atan3_ptrn = re.compile(r'omc_Modelica_Math_atan3\(\s*(?P<var1>.*)\s*,\s*(?P<var2>.*)\s*,\s*0.0\)')
    line_tmp = atan3_ptrn.sub('atan(\g<var1>/\g<var2>)',line)

    atan3_ptrn_bis = re.compile(r'omc_Modelica_Math_atan3\(\s*(?P<var1>.*)\s*,\s*(?P<var2>.*)\s*,\s*0.0\)')
    line_tmp_bis = atan3_ptrn_bis.sub('atan(\g<var1>/\g<var2>)',line_tmp)

    return line_tmp_bis

##
# Transform Rawbody in a list to a string, used by setGequations()
# @param Rawbody : Rawbody in a list of string
# @return string : string contains Rawbody
def transformRawbodyToString(Rawbody):
    string = ""
    for item in Rawbody:
        string += item.strip('\n')
    return string

##
# Find all occurences of pattern in string
# re.finditer does not seem to work
# @param pattern : the pattern to find (ex : "test")
# @param string : the string to scan (ex : "Many tests in test")
# @return the list of pattern occurences indexes in the initial string (ex : [5, 14])
def find_all_in_str (pattern, string):
    if (pattern not in string):
        return []
    else:
        sub_string = string
        offset = 0
        indexes = []
        while (pattern in sub_string):
            new_index = sub_string.find(pattern) + offset
            local_offset = sub_string.find(pattern) + len(pattern)
            indexes.append(new_index)
            offset += local_offset
            if len(sub_string) < local_offset :
                break
            else:
                sub_string = sub_string [local_offset : ]
        return indexes


##
# Convert boolean variables in order to allow Dynawo to deal
# with them as discrete variables
# @param boolean_variables_names : a list of variable and parameters names (following Dynawo)
# @param body : a list of lines to convert
def convert_booleans_body (boolean_variables_names, body):
    # deal with many types of variable names => create a full list of variable names to update
    all_boolean_variables_names = [to_compile_name(var_name) + "_" for var_name in boolean_variables_names] \
                                  + [to_omc_style(var_name) for var_name in boolean_variables_names] \
                                  + ['$P$PRE' + to_omc_style(var_name) for var_name in boolean_variables_names]

    for n, line in enumerate(body):
        if (any (var_name in line for var_name in all_boolean_variables_names)):
            new_line = convert_booleans_line (all_boolean_variables_names, line)
            body [n] = new_line


##
# Convert boolean variables in order to allow Dynawo to deal
# with them as discrete variables
# @param omc_boolean_variable_names : a list of variable and parameters names (following Dynawo AND OMC convention)
# @param line : the line to convert
# @return the converted line as a string
def convert_booleans_line (boolean_variables_names, line):
    allowed_containers = [' ', '(', ')', '=', '!']
    # temporary patterns for avoiding to convert quoted names
    patterns_temp = ["@@@@@@@@", "$$$$$$$$"]
    for n, pattern in enumerate(patterns_temp):
        new_pattern = pattern
        while (new_pattern in line):
            new_pattern.append(new_pattern [0])
        patterns_temp [n] = new_pattern

    # when there is a left hand side, convert it using fromBool
    affectation_side = line [ : line.find("=") + 1]

    # when there is a right hand side, convert the booleans used inside with toBool (add a space at the end to ease pattern matching)
    reading_side = line [line.find("=") + 1 : line.find(";")] + " "

    for var_name in boolean_variables_names:
        # avoid quoted names
        patterns_to_avoid = {patterns_temp[0] : "'" + var_name + "'", patterns_temp [1] : '"' + var_name + '"'}

        for replacement, pattern in patterns_to_avoid.iteritems():
            reading_side = reading_side.replace (pattern, replacement)

        # check that the right variable name (i.e. not part of another variable name) was found
        for m in find_all_in_str (var_name, reading_side):
            right_variable = (reading_side [m - 1] in allowed_containers) \
                             and (m + len(var_name) < len(reading_side)) and (reading_side [m + len(var_name)] in allowed_containers)

            if right_variable:
                reading_side = reading_side [ : m] + "(toNativeBool (" + var_name + "))" + reading_side [ m + len(var_name): ]

        # put back quoted names
        for replacement, pattern in patterns_to_avoid.iteritems():
            reading_side = reading_side.replace (replacement, pattern)

    # remove the " " added at the end of the reading_side to ease processing
    reading_side = reading_side [ : -1]

    return_string = None
    if (affectation_side is not None):
        return_string = affectation_side
        use_standard_reading_side = True
        if (any (var_name in affectation_side for var_name in boolean_variables_names)):
            for var_name in boolean_variables_names:
                if (var_name in affectation_side):
                    var_index = affectation_side.find(var_name)
                    if (affectation_side [var_index - 1] in allowed_containers) \
                     and (affectation_side [var_index + len(var_name)] in allowed_containers):
                        use_standard_reading_side = False
                        break

        if not use_standard_reading_side:
            return_string += " fromNativeBool (" + reading_side + ")"
        else:
            return_string += reading_side
    else:
        return_string = reading_side

    return_string += line [line.find(";") : ]

    return return_string

##
# Split function arguments
# @param line : a raw code line to process
# @param function_name : the name of the function for which to extract arguments
# @return the arguments as a list
def split_function_arguments (line, function_name):
    if (function_name not in line) or (';' not in line):
        errorExit('failed to extract function arguments linked with ' + function_name + ' for ' + line)

    # extract the content between the function name and ";"
    end_name_index = line.find(function_name) + len (function_name)
    semicolon_index = line.find (";", end_name_index)

    # remove the opening and closing argument brackets
    arguments_raw_content = line [end_name_index + 1 : semicolon_index - 1]
    arguments = []

    # individually extract each argument
    end_position = 0
    while (end_position < len (arguments_raw_content)):
        argument, end_position = getArgument (arguments_raw_content, end_position)
        argument = argument.strip()

        arguments.append(argument)

        # skip ","
        end_position += 1

    return arguments

##
# Check whether equationIndexes is within a given line
# These checks are performed after the OMC reader, because the OMC reader sometimes skips some lines (and deals with lines packages)
# @param line : the line to scan
# @return whether TRACE_POP or TRACE_PUSH lies within the line
def has_Omc_equationIndexes (line):
    equationIndexesPattern = re.compile(r'const int equationIndexes.*')
    return (re.search (equationIndexesPattern, line) is not None)

##
# Check whether OpenModelica Trace (TRACE_PUSH or TRACE_POPO) is within a given line
# These checks are performed after the OMC reader, because the OMC reader sometimes skips some lines (and deals with lines packages)
# @param line : the line to scan
# @return whether TRACE_POP or TRACE_PUSH lies within the line
def has_Omc_trace (line):
    pushPattern = re.compile (r'TRACE_PUSH')
    popPattern = re.compile (r'TRACE_POP')
    return (re.search(pushPattern, line) is not None) or (re.search(popPattern, line) is not None)


##
# Check whether a given function body is associated with a Modelica reinit command
# @param body : a body of lines
# @return whether the body of lines is linked with a Modelica reinit
def is_Modelica_reinit_body(body):
    patternToLookFor = "data->simulationInfo->needToIterate = 1;"
    return any(patternToLookFor in line for line in body)


##
# Format a body for Modelica reinit affectation
# @param body : a body of lines
# @return the formatted body
def formatFor_ModelicaReinitAffectation(body):
    textToReturn = []
    needToIteratePattern = "data->simulationInfo->needToIterate = 1;"
    for line in body:
        line = mmc_strings_len1(line)

        if has_Omc_trace (line) or has_Omc_equationIndexes (line) \
           or ("infoStreamPrint" in line) or (needToIteratePattern in line):
            continue

        line = subDivisionSIM(line)

        textToReturn.append( line )
    return textToReturn


##
# Format a body for Modelica reinit eval mode
# @param body : a body of lines
# @return the formatted body
def formatFor_ModelicaReinitEvalMode(body):
    textToReturn = []
    entered_if = False
    exited_if = False
    nb_opened_brackets = 0
    needToIteratePattern = "data->simulationInfo->needToIterate = 1;"
    modeChangeLine = "return true;"
    for line in body:
        line = mmc_strings_len1(line)

        if has_Omc_trace (line) or has_Omc_equationIndexes (line) or ("infoStreamPrint" in line):
            continue

        line = subDivisionSIM(line)

        # entering if evaluation : only keep the mode setting line
        if ('if' in line) and ('$P$PRE$P$' in line):
            entered_if = True

        if (entered_if and (not exited_if)):
            if ('{'in line) or ('}' in line) or ('if' in line):
                if ('{'in line):
                    nb_opened_brackets += 1

                if ('}' in line):
                    nb_opened_brackets -= 1
                    if (nb_opened_brackets == 0):
                        exited_if = True

                textToReturn.append (line)

            elif (nb_opened_brackets > 0):
                if (needToIteratePattern not in line):
                    continue
                else:
                    new_line = line.replace (needToIteratePattern, modeChangeLine)
                    textToReturn.append (new_line)
        else:
            textToReturn.append (line)

    return textToReturn
