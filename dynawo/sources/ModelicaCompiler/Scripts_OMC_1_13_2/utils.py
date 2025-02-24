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
import traceback

THREAD_DATA_OMC_PARAM = "threadData,"
HASHTAG_IFDEF = "#ifdef"
HASHTAG_ENDIF = "#endif"
HASHTAG_INCLUDE = "#include \""
OMC_METATYPE_TMPMETA = "modelica_metatype tmpMeta"
MODEL_NAME_NAMESPACE = "__fill_model_name__::"
ADEPT_NAMESPACE = "adept::"
REGULAR_EXPR_ATAN3 = r'omc_Modelica_Math_atan3\(\s*(?P<var1>[^,]*)\s*,\s*(?P<var2>[^,]*)\s*,\s*0.0\)'
NEED_TO_ITERATE_ACTIVATION= "data->simulationInfo->needToIterate = 1;"

DIFFERENTIAL, ALGEBRAIC, MIXED, UNDEFINED_TYPE = range(4)
##
# print an information log
def print_info(log):
    print("    [INFO]: " + log)

##
# print a warning log
def print_warning(log):
    print("  **[WARNING]: " + log)


##
# Indicates whether the variable is a derivative variable
#
# @param var_name : name of the variable
# @return @b true if the variable is a derivative variable
def is_der(var_name):
    ptrn_der_var = re.compile(r'der\((\S*)\)$')
    return ptrn_der_var.search(var_name) is not None



##
# Indicates whether the variable is a temporary absolute variable used to solve equations with multiple solutions
#
# @param var_name : name of the variable
# @return @b true if the variable is a temporary absolute variable
def is_ignored_var(var_name):
    match_is_temporary_abs_var = re.compile(r'\$TMP\$VAR\$[0-9]+\$0X\$ABS')
    return match_is_temporary_abs_var.search(var_name) is not None
##
# Indicates whether the variable is a when condition
#
# @param var_name : name of the variable
# @return @b true if the variable is a when condition
def is_when_condition(var_name):
    return "$whenCondition" in var_name

##
# Indicates whether the function  of type RawOmcFunctions should be transformed to an adept type
#
# @param func : function to analyse
# @param list_adept_structs : list of struct converted into adept
# @return @b true if the function should be transformed to an adept type
def is_adept_func(func, list_adept_structs):
    if "omc_Modelica_Blocks_Tables_Internal_getTable" in func.get_name(): return False
    if "omc_Modelica_Blocks_Tables_Internal_getTimeTableValue" in func.get_name(): return False
    if "array_alloc_scalar_real_array" in func.get_name(): return False
    if "delay" in func.get_name(): return False # Delay shall not use adept
    if "_event_floor" in func.get_name(): return False
    if "_event_ceil" in func.get_name(): return False
    if func.get_return_type() == "modelica_real" : return True
    if func.get_return_type() in list_adept_structs: return True
    for param in func.get_params():
        if not param.get_is_input() and (param.get_type() == "modelica_real" or param.get_type() in list_adept_structs):
            return True
    return False

##
# replace '.' by '_' so that var_name should be correctly analyse by gcc
# replace ']' by '_' A[1] => A_1_
# replace ']' by '_'
# replace ',' by '_' A[1,1] => A_1_1_
# @param var_name : input name of the variable
# @return the variable name without '.'
def to_compile_name(var_name):
    name = var_name.replace(".","_")
    name = name.replace("[","_")
    name = name.replace("]","_")
    name = name.replace(",","_")
    return name

nb_braces_opened = 0
stop_at_next_call = False
crossed_opening_braces = False
map_var_name_2_addresses = {}

##
# Get the address for a variable
# @param var_name: variable name
# @return variable address (form data->simulationInfo->..)
def to_param_address(var_name):
    return find_value_in_map(map_var_name_2_addresses, var_name)

##
# Test if the address of a variable was found and throws if not
# @param var_name: variable name
# @return
def test_param_address(var_name):
    if to_param_address(var_name) == None:
        traceback.print_stack()
        error_exit('Could not find the address of ' + var_name)

##
# reset the address DB
def reset_param_address():
    map_var_name_2_addresses.clear()

##
# Set the address for a variable
# @param var_name: variable name
# @param address: variable address (form data->simulationInfo->..)
def set_param_address(var_name, address):
    map_var_name_2_addresses[var_name] = address

##
# Test if the address of a variable was found
# @param var_name: variable name
# @return whether the variable name has an associated address
def has_param_address(var_name):
    return var_name in map_var_name_2_addresses

def get_map_var_name_2_addresses() :
    return map_var_name_2_addresses

##
# Replace all variables by its correct address
# @param self: object pointer
# @param line: line to analyse
# @return line to use
def replace_var_names(line):
    ptrn_var = re.compile(r'data->localData\[(?P<localDataIdx>[0-9]+)\]->(?P<var>[\w\[\]]+)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
    ptrn_var_no_desc = re.compile(r'data->localData\[(?P<localDataIdx>[0-9]+)\]->(?P<var>[\w\[\]]+)[ ]*\/\* (?P<varName>[\w\$\.()\[\],]*) \*\/')
    ptrn_pre_var = re.compile(r'data->simulationInfo->(?P<var>[\w\[\]]+)Pre\[(?P<dataIdx>[0-9]+)\][ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
    ptrn_param = re.compile(r'data->simulationInfo->(?P<var>[\w\[\]]+)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/')
    ptrn_var_add = re.compile(r'data->localData\[(?P<localDataIdx>[0-9]+)\]->(?P<var>[\w]+)\[(?P<varIdx>[0-9]+)\]')
    data_simulation_info = "data->simulationInfo->"
    dummy_der_var = re.compile(r'data->localData\[(?P<localDataIdx>[0-9]+)\]->(?P<var>[\w\[\]]+)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) DUMMY_DER \*\/')
    state_var = re.compile(    r'data->localData\[(?P<localDataIdx>[0-9]+)\]->(?P<var>[\w\[\]]+)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) STATE\(.*\) \*\/')
    map_to_replace = {}
    pattern_index  = 0
    match = dummy_der_var.findall(line)
    for idx, add, name in match:
        dummy_name = name
        if "_dummy_der" not in dummy_name:
            dummy_name = name.replace("der(","")[:-1] + "_dummy_der"
        test_param_address(dummy_name)
        replacement_string = "@@@" + str(pattern_index) + "@@@"
        line = line.replace("data->localData["+str(idx)+"]->"+add, replacement_string)
        map_to_replace[replacement_string] = to_param_address(dummy_name)
        pattern_index +=1
    match = state_var.findall(line)
    for idx, add, name in match:
        test_param_address(name)
        replacement_string = "@@@" + str(pattern_index) + "@@@"
        line = line.replace("data->localData["+str(idx)+"]->"+add, replacement_string)
        map_to_replace[replacement_string] = to_param_address(name)
        pattern_index +=1
    match = ptrn_var.findall(line)
    for idx, add, name in match:
        test_param_address(name)
        replacement_string = "@@@" + str(pattern_index) + "@@@"
        line = line.replace("data->localData["+str(idx)+"]->"+add, replacement_string)
        map_to_replace[replacement_string] = to_param_address(name)
        pattern_index +=1
    match = ptrn_var_no_desc.findall(line)
    for idx, add, name in match:
        test_param_address(name)
        replacement_string = "@@@" + str(pattern_index) + "@@@"
        line = line.replace("data->localData["+str(idx)+"]->"+add, replacement_string)
        map_to_replace[replacement_string] = to_param_address(name)
        pattern_index +=1
    match = ptrn_pre_var.findall(line)
    for add, index, name in match:
        test_param_address(name)
        match2 = re.search(ptrn_var_add, to_param_address(name))
        if match2 != None:
            replacement_string = "@@@" + str(pattern_index) + "@@@"
            line = line.replace(data_simulation_info+add+"Pre["+str(index)+"]", replacement_string)
            map_to_replace[replacement_string] = data_simulation_info+match2.group("var")+"Pre["+match2.group("varIdx")+"]"
            pattern_index +=1
    match = ptrn_param.findall(line)
    for idx, name in match:
        test_param_address(name)
        replacement_string = "@@@" + str(pattern_index) + "@@@"
        line = line.replace(data_simulation_info+idx, replacement_string)
        map_to_replace[replacement_string] = to_param_address(name)
        pattern_index +=1

    for pattern_to_replace in map_to_replace:
        line = line.replace(pattern_to_replace, map_to_replace[pattern_to_replace])
    return line
##
# Replace all relation indexes by their dynawo index
# @param line: line to analyse
# @param omc_relation_index_2_dynawo_relations_index: dictionary that maps omc relation index to dynawo relations index
# @return line to use
def replace_relation_indexes(line, omc_relation_index_2_dynawo_relations_index):
    if "RELATIONHYSTERESIS" not in line: return line
    index_tmp = 0
    map_to_replace ={}
    relations_found = re.findall(r'RELATIONHYSTERESIS\((?P<target_var>.*?), (?P<variable>.*?), (?P<value>.*?), (?P<rel_index>[0-9]+), (?P<operator>.*?)\)', line)
    for target_var,variable,value,rel_index,operator in relations_found:
        if rel_index not in omc_relation_index_2_dynawo_relations_index: continue
        replacement_string = "@@@" + str(index_tmp) + "@@@"
        line = line.replace("RELATIONHYSTERESIS("+target_var+", "+variable+", "+value+", "+rel_index+", "+operator+")",\
                                      "RELATIONHYSTERESIS("+target_var+", "+variable+", "+value+", "+replacement_string+", "+operator+")")
        map_to_replace[replacement_string] = omc_relation_index_2_dynawo_relations_index[rel_index]
        index_tmp+=1

    for pattern_to_replace in map_to_replace:
        line = line.replace(pattern_to_replace, map_to_replace[pattern_to_replace])
    return line
##
# Count the number of opening braces in an expression
# @param expr : the expression to analyze
# @return the number of opening braces
def count_opening_braces(expr):
    return len(re.findall(r'{', expr))

##
# Count the number of closing braces in an expression
# @param expr : the expression to analyze
# @return the number of opening braces
def count_closing_braces(expr):
    return len(re.findall(r'}', expr))

##
# Predicate for the reading of the body in functions in main c file
# @param element : current line reading
# @return @b False if we read the body, @b True else
def stop_reading_block(element):
    global nb_braces_opened
    global stop_at_next_call
    global crossed_opening_braces
    if stop_at_next_call and crossed_opening_braces : return False
    nb_braces_opened += count_opening_braces(element)
    nb_braces_opened -= count_closing_braces(element)
    if nb_braces_opened != 0 : crossed_opening_braces = True
    elif crossed_opening_braces : stop_at_next_call = True
    return True

##
# throws an error and exit
# @param error_message : the message to display
# @param error_code : the error code to send back
def error_exit(error_message, error_code = 1):
    print("   [ERROR]: " + error_message)
    sys.exit(error_code)

##
# check if the file exist
#
# @param file_name : name of the file to check
#
# @throw sys.exit() if the file does not exist
def exist_file(file_name):
    if not os.path.isfile(file_name) :
        error_exit ("%s does not exist" % file_name)


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
    except OSError:
        error_exit ("failed to open %s with write rights" % destination_file_path)

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
    if the_key in a_map:
        return a_map[the_key]
    return None

##
# Look at a value in a map and return key associated to the value
#
# @param a_map : map where the value should be found
# @param the_value : value to find in the map
#
# @return : the key associated to the value, if the value exists, None otherwise
def find_key_in_map(a_map, the_value):
    for key, value in a_map.items():
        if value == the_value:
            return key
    return None

##
# Find a division expression in a line
# @param line line  to analyze
# @param start_pos : pointer in the line where the division begins
# @returns : the division expression
def get_div_block_sim(line, start_pos):
    nb_brackets = 1
    end_pos = len(line)

    current_pos = start_pos
    for char in line[start_pos:]:
       if char == "(" : nb_brackets += 1
       if char == ")" : nb_brackets -= 1
       if nb_brackets == 0:
           end_pos = current_pos
           break
       current_pos += 1
    if "DIVISION_SIM" in line:
        return "DIVISION_SIM(" + line[start_pos:end_pos] + ")"
    return "DIVISION(" + line[start_pos:end_pos] + ")"

##
# Find an expression between brackets in a line
# @param line line to analyze
# @param start_pos : pointer in the line where the expression begins
# @returns : the expression
def get_argument(line, start_pos):
    nb_brackets = 0
    end_pos = len(line)

    current_pos = start_pos
    for char in line[start_pos:]:
       if char == "(" : nb_brackets += 1
       if char == ")" : nb_brackets -= 1
       if char == "," and nb_brackets == 0:
           end_pos = current_pos
           break
       current_pos += 1
    return line[start_pos:end_pos], end_pos


##
# Replace pow by pow_dynawo in line
# @param line line to analyze
# @returns : the line with the new expression
def replace_pow(line):
    line_to_return = line
    if 'pow(' in line:
        line_to_return = line_to_return.replace("pow(", "pow_dynawo(")
    return line_to_return

##
# Replace equations with v1 = table[v2]
# OpenModelica generates f = v1- &table[firstIndex + v2], we replace it with a if to be complicant with adept
# @param body body to analyze
# @returns : the line with the new expression
def replace_dynamic_indexing(body):
    body_to_return = []
    depend_vars = []
    integer_array_create_tmp = {}
    for line in body:
        if ("calc_base_index_dims_subs" not in line):
            body_to_return.append(line)
            for tmp in integer_array_create_tmp:
                if "&"+tmp in line:
                    table, index, var_name, size = integer_array_create_tmp[tmp]
                    for i in range(0, int(size)):
                        body_to_return.append("    data->localData[0]->" + table + "[" + str(int(index) + i) + "] /* " + var_name + "[" + str(i + 1) +"] DISCRETE */" + " = integer_get(" + tmp + ", " + str(i) + ");\n")
            continue
        ptrn_var_dynamic_index = re.compile(r'\(&data->localData\[[0-9]+\]->(?P<var>[\w\[\]]+)[ ]*\/\* (?P<varName>[ \w\$\.()\[\],]*) [\w\(\),\.]+ \*\/\)\[calc_base_index_dims_subs\([0-9]+, (?P<size>[0-9]+), (?P<expr>.*)\)\]')
        match = ptrn_var_dynamic_index.findall(line)
        index_tmp = 0
        if "real_array_create" in line:
            for var, var_name, size, expr in match:
                index2 = -1
                while var[index2] != '[':
                    index2 -= 1
                body_to_return.append(re.sub(ptrn_var_dynamic_index, "data->localData[0]->" + var[:index2] + "["+var[index2:-1]+"] /* " + var_name+" DISCRETE */", line))
        elif "integer_array_create" in line:
            for var, var_name, size, expr in match:
                index = -1
                while var_name[index] != '[':
                    index -= 1
                index2 = -1
                while var[index2] != '[':
                    index2 -= 1
                ptrn_integer_array_create = re.compile(r'integer_array_create\(\&tmp(?P<tmp_idx>[0-9]+), .*')
                match2 = ptrn_integer_array_create.findall(line)
                for tmp_id in match2:
                    body_to_return.append("  alloc_integer_array(&tmp" + tmp_id + ", " + expr + ", " + size + ");\n")
                    integer_array_create_tmp["tmp" + tmp_id] = [var[:index2], var[index2 + 1:-1], var_name[:index], size]
                #body_to_return.append(re.sub(ptrn_var_dynamic_index, "data->localData[0]->" + var[:index2] + "["+var[index2:-1]+"] /* " + var_name+" DISCRETE */", line))
        else:
            body_to_return.append("  modelica_real tmp_calc_var_" + str(index_tmp)+";\n")
            for var, var_name, size, expr in match:
                for i in range(1, int(size)+1):
                    body_to_return.append("  if (" + expr + " == " + str(i) +") {\n")
                    index = -1
                    while var_name[index] != '[':
                        index -= 1
                    index2 = -1
                    while var[index2] != '[':
                        index2 -= 1
                    body_to_return.append("    tmp_calc_var_" + str(index_tmp) + " = data->localData[0]->" + var[:index2] + "["+var[index2:-1]+"] /* " + var_name[:index]+"[" + str(i) + "]"+" DISCRETE */;\n")
                    body_to_return.append("  }\n")
                    depend_vars.append(var_name[:index]+"[" + str(i) + "]")
                body_to_return.append(re.sub(ptrn_var_dynamic_index,"tmp_calc_var_" + str(index_tmp), line))
                index_tmp+=1

    return (body_to_return, depend_vars)

##
# Replace a DIVISION expression in a line by a/b
# @param line line to analyze
# @returns : the line with the new expression
def sub_division_sim(line):
    line_to_return = line
    ptrn_div = re.compile(r'DIVISION_SIM\(|DIVISION\(')
    nb_iter = 0
    while True:
        match = ptrn_div.search(line_to_return)
        if match is None :
            break
        else:
            pos_start_div = match.end()
            div_block = get_div_block_sim(line_to_return, pos_start_div)

            arg1, end_pos_arg1 = get_argument(line_to_return, pos_start_div)
            arg2, _ = get_argument(line_to_return, end_pos_arg1 + 1)
            line_to_return = line_to_return.replace(div_block, "("+arg1 + ") / (" + arg2+")")
        nb_iter += 1

        if nb_iter == 500:
            error_exit("Infinite loop detected in DIVISION replacement for line " + line)
    return line_to_return

##
# Replace throwStreamPrintEquation by throwStreamPrint
# @param line : line where expression should be replaced
# @returns new line expression
def throw_stream_indexes(line):
    pattern = "throwStreamPrintWithEquationIndexes(threadData, equationIndexes"
    pattern1 = "throwStreamPrint("
    line_to_return = line
    if pattern in line:
        line_to_return = line.replace(pattern,pattern1)

    return line_to_return

##
# Replace the mmc_strings_len1 macro by the mmc_strings_len1 function
# @param line : line where expression should be replaced
# @returns new line expression
def mmc_strings_len1(line):
    ptrn_mmc = re.compile(r'mmc_strings_len1\[(?P<var>\d+)\]')
    pattern = "mmc_strings_len1"
    line_to_return = line
    if pattern in line:
        match = re.search(ptrn_mmc, line)
        if match is not None:
            nb_digits = match.group('var')
            full_word = '(modelica_string) '+ pattern+'['+str(nb_digits)+']'
            full_word1 = pattern+'('+str(nb_digits)+')'
            line_to_return = line.replace(full_word,full_word1)
    return line_to_return

##
# Replace some expressions by other expressions
# @param txt_list : whole text to analyse
# @returns: new text
def make_various_treatments(txt_list):
    """
       Different treatments on a list of text lines.
       See comments in the body of this function.
    """
    txt_list_to_return = txt_list

    # Replace DIVISION(a1,a2,a3) ==> a1 / a2
    # Difficult to do this with a regex and a sub, so we use
    # the function "subDivision()"
    txt_tmp = []
    for line in txt_list_to_return:
        line_tmp = sub_division_sim(line) # Difficult to do this with a regex and a sub.
        txt_tmp.append(line_tmp)

    txt_list_to_return = txt_tmp

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
    for line in txt_list_to_return:
        if "FILE_INFO" in line : continue

    # Line that does not call for processing:
        txt_tmp.append(line)

    txt_list_to_return = txt_tmp

    return txt_list_to_return

##
# Retrieve all variable with name tmp<number> in the line
# @param line the line to analyse
def find_all_temporary_variable_in_line(line):
    return re.findall(r'tmp[0-9]+', line)

def add_tmp_update_relations(tmp, tmps_assignment, tmps_to_add):
    tmps_to_add_depend = []
    if tmp not in tmps_to_add:
        tmps_to_add.append(tmp)
        for tmp_assignment in tmps_assignment:
            if tmp in tmp_assignment:
                tmp_depend_tmps = find_all_temporary_variable_in_line(tmp_assignment)
                for tmp_depend in tmp_depend_tmps:
                    tmps_to_add_depend = add_tmp_update_relations(tmp_depend, tmps_assignment, tmps_to_add)
                    tmps_to_add.extend(tmps_to_add_depend)
    return tmps_to_add_depend

##
# Retrieve all variables with type modelica_metatype tmpMeta by modelica_strings
# @param line the line to analyse
def replace_modelica_strings(line):
    words = line.split()
    return " modelica_string "+str(words[1])+";\n"

##
# Return the adept equivalent of a function
# @param func function
def get_adept_function_name(func):
    return func.get_name()+"_adept"

##
# Class containing a map associated name variable with its reference in x,xd list
# Translate var or der(var) to x[i], xd[i], ...
# Thanks to that, variable name could be replace by value variable in mathematical expressions
class Transpose:
    ##
    # Default constructor
    # @param a_map : map associating var name to var value
    # @param txt_list : expressions where var name should be replaced
    # @param auxiliary_vars_map : auxiliary vars
    # @param residual_vars_map : residual vars
    def __init__(self, auxiliary_vars_map = None, residual_vars_map = None):
        ## pattern to intercept var name in expression
        self.ptrn_vars = re.compile(r'data->localData\[[0-9]+\]->derivativesVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*[ ]variable[ ]\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*[ ]*\*\/')
        ## map associating var name to var value
        self.map = {}
        ## expressions where var name should be replaced
        self.txt_list = []
        if auxiliary_vars_map is not None:
            self.auxiliary_vars_map = auxiliary_vars_map
        if residual_vars_map is not None:
            self.residual_vars_map = residual_vars_map

    ##
    # set the expressions where var name should be replaced
    # @param self : object pointer
    # @param txt_list : list of expressions
    # @return
    def set_txt_list(self, txt_list):
        self.txt_list = txt_list

    ##
    # Run through all expressions and replace all var name contains in map by var value
    # @param self: object pointer
    # @return the list of expressions with var name replaced
    def translate(self):
        tmp_txt_list = []
        for line in self.txt_list:
            line_tmp = line # Line changed by overrides
            line_tmp = transform_line_adept(line_tmp)
            match_global = self.ptrn_vars.findall(line) # Is this a word that matches the regex?
            # first the derivatives then the vars
            for name in match_global:
                if 'derivativesVars' not in name:
                    continue
                # If the var "name" is in the map, we replace it by its other expression (xd[...])
                ptrn_real_var = re.compile(r'data->localData\[[0-9]+\]->derivativesVars\[(?P<varId>[0-9]+)\][ ]+\/\*[ \w\$\.()\[\],]*\*\/')
                match = ptrn_real_var.search(name)
                if match is not None:
                    if "= modelica_real_to_modelica_string(" in line_tmp:
                        line_tmp = line_tmp.replace(name, "xd[" + match.group('varId')+"].value()")
                    else:
                        line_tmp = line_tmp.replace(name, "xd[" + match.group('varId')+"]")
            for name in match_global:
                if 'derivativesVars' in name:
                    continue
                # If the var "name" is in the map, we replace it by its other expression (x[...])
                ptrn_real_var = re.compile(r'data->localData\[[0-9]+\]->realVars\[(?P<varId>[0-9]+)\][ ]+\/\*[ \w\$\.()\[\],]*\*\/')
                match = ptrn_real_var.search(name)
                if match is not None:
                    if "= modelica_real_to_modelica_string(" in line_tmp:
                        line_tmp = line_tmp.replace(name, "x[" + match.group('varId')+"].value()")
                    else:
                        line_tmp = line_tmp.replace(name, "x[" + match.group('varId')+"]")

            for name in self.auxiliary_vars_map.keys():
                line_tmp = line_tmp.replace("$P"+name, name)
                if "(modelica_boolean)"+name in line_tmp:
                    line_tmp = line_tmp.replace("(modelica_boolean)"+name, "(modelica_boolean)( ("+name+">0)? 1: 0 )")
            for name in self.residual_vars_map:
                line_tmp = line_tmp.replace("$P"+name, name)
            assert ("derivativesVars[" not in line_tmp)
            assert ("realVars[" not in line_tmp)
            tmp_txt_list.append(line_tmp)
        return tmp_txt_list


##
# class WatcherBlock
#
class WatcherBlock:
    ##
    # Default constructor
    # @param list_sub_str : list of string to find in a block
    def __init__(self, list_sub_str = None):
        ## list of string to find in a block
        self.list_sub_str = []

        if list_sub_str is not None:
            self.list_sub_str = list_sub_str
    ##
    # Call method
    # @param line : line to analyse
    # @return @b False if no string in list are found in the line
    def __call__(self, line):
        for sub_str in self.list_sub_str:
            if sub_str not in line:
                return True
        return False

##
# class WatcherIntroBlock
#
class WatcherIntroBlock:
    ##
    # Default constructor
    # @param list_sub_str : list of string to find in a block
    def __init__(self, list_sub_str = None):
        ## list of string to find in a block
        self.list_sub_str = []

        if list_sub_str is not None:
            self.list_sub_str = list_sub_str
    ##
    # Call method
    # @param line : line to analyse
    # @return @b True if no string in list are found in the line
    def __call__(self, line):
        for sub_str in self.list_sub_str:
            if sub_str in line:
                return False
        return True

def extract_block(block, list_sub_string):
    """
      - Recovery of all instructions before any block (lines
        not including any substrings of list_sub_string)
      - Recovery of the interesting block: the one introduced by a line
        with all substrings of list_sub_string
      - post processing of the block: we delete the braces at the beginning and end of the block
    """
    w_intro_block = WatcherIntroBlock(list_sub_string)
    w_block = WatcherBlock(list_sub_string)


    global nb_braces_opened
    global crossed_opening_braces
    global stop_at_next_call

    nb_braces_opened = 0
    crossed_opening_braces = False
    stop_at_next_call = False

    # We recover the declarations of the vars used in the block: all the lines
    # before finding an "if" block
    intro_block_to_catch = []
    intro_block_to_catch.extend( list(itertools.takewhile(w_intro_block, block)) )
    # Added spaces in front of each line
    intro_block_to_catch = ["  " + line for line in intro_block_to_catch]

    # Then we neglect all lines until the block
    it = itertools.dropwhile(w_block, block)
    next_iter = next(it, None) # Line on which "dropwhile" stopped

    if next_iter is None: return # If we reach the end of the file, exit.

    # We recover the block
    block_to_catch = list(itertools.takewhile(stop_reading_block, it))

    # Delete lines with a single brace at the beginning and end of the block
    # ... Intercept a line containing only a brace (opening or closing) and spaces
    ptrn_only_one_opening_brace = re.compile(r'^\s*{\s*$')
    ptrn_only_one_closing_brace = re.compile(r'^\s*}\s*$')
    match1 = re.search(ptrn_only_one_opening_brace, block_to_catch[0])
    match2 = re.search(ptrn_only_one_closing_brace, block_to_catch[len(block_to_catch)-1])
    #... Delete
    if match1 is not None and match2 is not None:
        block_to_catch.pop(0)
        block_to_catch.pop()

    block_to_catch = intro_block_to_catch + block_to_catch

    return block_to_catch

##
# Analyse the number of opening/closing brackets in a expression
# and add one opening/closing brackets if one missing
#  @param word : expression to analyse
#  @return new expression
def analyse_bracket(word):
    ## allows you to balance the number of opening / closing parentheses
    open_bracket=len(re.findall(r'\(', word))
    close_bracket=len(re.findall(r'\)', word))

    if open_bracket == close_bracket:
        return word

    if open_bracket < close_bracket:
        nb = close_bracket - open_bracket
        new_word=""
        for _ in range(1,nb+1):
            new_word = '(' + new_word
        new_word += word
        return new_word

    if close_bracket < open_bracket:
        nb = open_bracket - close_bracket
        new_word=""
        for _ in range(1,nb+1):
            new_word = ')' + new_word
        new_word = word + new_word
        return new_word

##
# Analyse and replace ternary expression:
# @param line : line to analyze
# @param body : body where the new expression should be added
# @param num_ternary : num of boolean to create to replace ternary expression
def analyse_and_replace_ternary(line,body,num_ternary):
   pattern_ternary = re.compile(r'.*\( (?P<var>.*\?.*:.*)\).* \)')  #look for for ternary operator identifiable by ( A ? B : C )
   pattern_ternary1 = re.compile(r'.*\( \((?P<var>.*\)\?.*:.*)\)') #look for for ternary operator identifiable by ( (A)? B: C )
   pattern_ternary2 = re.compile(r'.*\(\((?P<var>.*\?.*:.*)\)\) ')  #look for for ternary operator identifiable by (A ? B : C)

   pattern_cond = re.compile(r'.*\( (?P<var>.*)\?.*') #look for the condition
   pattern_cond1 = re.compile(r'.*\( \((?P<var>.*)\)\?.*') #look for the condition
   pattern_cond2 = re.compile(r'.*\(\((?P<var>.*) \?.*') #look for the condition
   pattern_var1 = re.compile(r'.*\?(?P<var1>.*):.*') #look for num 1
   pattern_var2 = re.compile(r'.*:(?P<var2>.*)\).*') #look for possibility number 2

   pattern_aux_var = re.compile(r'\(\$cse[0-9]+>0\)\? 1: 0')

   ternary=""
   cond=""
   var1=""
   var2=""
   ternary_type= 0
   line = line.replace(ADEPT_NAMESPACE,"@@@@")

   if 'omc_assert_warning' in line: # ternary operator in assert, nothing to do
       body.append(line)
       return

   # look for ternary operator
   match_t = re.search(pattern_ternary1,line)
   match_t2 = re.search(pattern_ternary2,line)

   if match_t2 is not None:
       ternary = analyse_bracket("(("+str(match_t2.group('var')))
       ternary_type = 2
   elif match_t is not None:
       ternary = analyse_bracket("( ("+str(match_t.group('var')))
       ternary_type = 1
   else:
       match_t = re.search(pattern_ternary,line)
       if match_t is not None:
           ternary = analyse_bracket("( "+str(match_t.group('var')))
   assert (ternary != "")
   if re.search(pattern_aux_var, ternary) is not None:
       body.append(line)
       return

   #Remove potential useless part
   nb_opening = 0
   nb_closing = 0
   filtered_ternary = ""
   for char in ternary:
        if char == '(':
           nb_opening+=1
        if char == ')':
           nb_closing+=1
        filtered_ternary+=char
        if nb_opening == nb_closing:
            break

   # look for the condition of the operator
   if ternary_type == 1:
       match = re.search(pattern_cond1,filtered_ternary)
       if match is not None:
           cond = analyse_bracket(str(match.group('var')))
   elif ternary_type == 2:
       match = re.search(pattern_cond2,filtered_ternary)
       if match is not None:
           cond = analyse_bracket(str(match.group('var')))
   else:
       match = re.search(pattern_cond,filtered_ternary)
       if match is not None:
           cond = analyse_bracket(str(match.group('var')))
   assert (cond != "")

   # look for possibility 1
   match1 = re.search(pattern_var1,filtered_ternary)
   if match1 is not None:
       var1 = analyse_bracket(match1.group('var1'))
   assert (var1 != "")

   # look for possibility 2
   match2 = re.search(pattern_var2,filtered_ternary)
   if match2 is not None:
       var2 = analyse_bracket(match2.group('var2'))
   assert (var2 != "")

   first_word = line.split()[0]
   blanck = line[0 : line.find(first_word)] # number of black lines to format

   body.append(blanck+"adept::adouble tmpTernary"+str(num_ternary)+";\n")
   body.append(blanck+"if("+cond+")\n")
   body.append(blanck+"{\n")
   body.append(blanck+"    tmpTernary"+str(num_ternary)+" = "+var1.replace("@@@@",ADEPT_NAMESPACE)+";\n")
   body.append(blanck+"}\n")
   body.append(blanck+"else\n")
   body.append(blanck+"{\n")
   body.append(blanck+"    tmpTernary"+str(num_ternary)+" = "+var2.replace("@@@@",ADEPT_NAMESPACE)+";\n")
   body.append(blanck+"}\n")
   new_line = line.replace(filtered_ternary,"tmpTernary"+str(num_ternary))
   body.append(new_line)

##
# Transform ternary expression in if/else expression
# @param body : body to analyse
# @param num_ternary : num to use when creating new boolean condition
# @return new_body without ternary expression
def transform_ternary_operator(body,num_ternary):
    new_body = []

    for line in body:
        if line.find("?") != -1:
            # analysis of the line ....
            analyse_and_replace_ternary(line,new_body,num_ternary)
        else:
            new_body.append(line)

    return new_body

##
# Transform omc_Modelica_Math_atan3 expression to atan2
# @param line : line to analyse
# @return line transformed
def transform_atan3_operator(line):
    line = line.replace('threadData,','')
    atan3_ptrn = re.compile(REGULAR_EXPR_ATAN3)
    line_tmp = atan3_ptrn.sub('atan2(\g<var1>,\g<var2>)',line)

    atan3_ptrn_bis = re.compile(REGULAR_EXPR_ATAN3)
    line_tmp_bis = atan3_ptrn_bis.sub('atan2(\g<var1>,\g<var2>)',line_tmp)

    return line_tmp_bis

##
# Transform omc_Modelica_Math_atan3 expression to atan
# @param line : line to analyse
# @return line transformed
def transform_atan3_operator_evalf(line):
    line = line.replace('threadData,','')
    atan3_ptrn = re.compile(REGULAR_EXPR_ATAN3)
    line_tmp = atan3_ptrn.sub('atan(\g<var1>/\g<var2>)',line)

    atan3_ptrn_bis = re.compile(REGULAR_EXPR_ATAN3)
    line_tmp_bis = atan3_ptrn_bis.sub('atan(\g<var1>/\g<var2>)',line_tmp)

    return line_tmp_bis

##
# Transform a line so that it can be compiled
# @param line : line to analyse
# @return line transformed
def transform_line(line):
    line_tmp = mmc_strings_len1(line)
    line_tmp = transform_atan3_operator(line_tmp)
    line_tmp = sub_division_sim(line_tmp)
    line_tmp = replace_var_names(line_tmp)
    line_tmp = replace_pow(line_tmp)
    line_tmp = line_tmp.replace("threadData,", "")
    line_tmp = line_tmp.replace(", threadData)", ")")
    if "omc_assert_warning" in line_tmp:
        line_tmp = line_tmp.replace("info,","")
    return line_tmp


def replace_getTable1DValue(match):
    ptrn_vars = re.compile(r'data->localData\[[0-9]+\]->derivativesVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*[ ]variable[ ]\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*[ ]*\*\/')
    text = match.group()
    match_state_var = ptrn_vars.search(match.group('var_input'))
    if match_state_var is not None:
        text = text.replace("omc_Modelica_Blocks_Tables_Internal_getTable1DValue", "ModelicaStandardTables_CombiTable1D_getDerValue")
    return text

def replace_getTable2DValue(match):
    ptrn_vars = re.compile(r'data->localData\[[0-9]+\]->derivativesVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*[ ]variable[ ]\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*[ ]*\*\/')
    text = match.group()
    match_state_var1 = ptrn_vars.search(match.group('var_input1'))
    match_state_var2 = ptrn_vars.search(match.group('var_input2'))
    if match_state_var1 is not None and match_state_var2 is not None:
        text = text.replace("omc_Modelica_Blocks_Tables_Internal_getTable2DValue", "ModelicaStandardTables_CombiTable2D_getDerValue")
    return text

def replace_getTimeTableValue(match):
    ptrn_vars = re.compile(r'data->localData\[[0-9]+\]->derivativesVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*[ ]variable[ ]\*\/|data->localData\[[0-9]+\]->realVars\[[0-9]+\][ ]+\/\*[ \w\$\.()\[\],]*[ ]*\*\/')

    text = match.group()
    match_state_var = ptrn_vars.search(match.group('var_input'))
    if match_state_var is not None:
        text = text.replace("omc_Modelica_Blocks_Tables_Internal_getTimeTableValue", "ModelicaStandardTables_CombiTimeTable_getDerValue")
    return text


def replace_combi_table_jacobian_adept(line):
    if "omc_Modelica_Blocks_Tables_Internal_getTable1DValue" not in line \
    and "omc_Modelica_Blocks_Tables_Internal_getTable2DValue" not in line \
    and "omc_Modelica_Blocks_Tables_Internal_getTimeTableValue" not in line:
        return line
    if "omc_Modelica_Blocks_Tables_Internal_getTable1DValue" in line:
        table_value_ptrn = re.compile(r"omc_Modelica_Blocks_Tables_Internal_getTable1DValue\([^,]+,[^,]+,\s*(?P<var_input>.*)\)")
        line = re.sub(table_value_ptrn, replace_getTable1DValue, line)
    if "omc_Modelica_Blocks_Tables_Internal_getTable2DValue" in line:
        table_value_ptrn = re.compile(r'omc_Modelica_Blocks_Tables_Internal_getTable2DValue\(.*,(?P<var_input1>.*),(?P<var_input2>.*)\)')
        line = re.sub(table_value_ptrn, replace_getTable2DValue, line)
    if "omc_Modelica_Blocks_Tables_Internal_getTimeTableValue" in line:
        table_value_ptrn = re.compile(r'omc_Modelica_Blocks_Tables_Internal_getTimeTableValue\(.*,.*,(?P<var_input>.*),.*,.*\)')
        line = re.sub(table_value_ptrn, replace_getTimeTableValue, line)

    match1d = re.search(r"omc_Modelica_Blocks_Tables_Internal_getTable1DValue\([^,]+,[^,]+,\s*(?P<var_input>.*)\)", line)
    match2d = re.search(r'omc_Modelica_Blocks_Tables_Internal_getTable2DValue\(.*,(?P<var_input1>.*),(?P<var_input2>.*)\)', line)
    matcht = re.search(r'omc_Modelica_Blocks_Tables_Internal_getTimeTableValue\(.*,.*,(?P<var_input>.*),.*,.*\)', line)
    if "omc_Modelica_Blocks_Tables_Internal_getTable1DValue" in line and match1d and ('derivativesVars' in match1d.group('var_input') or 'realVars' in match1d.group('var_input')):
        if not 'NoDer' in line:
            print(line)
            sys.exit("Issue with the replacement of omc_Modelica_Blocks_Tables_Internal_getTable1DValue in adept Jacobian.")
    elif "omc_Modelica_Blocks_Tables_Internal_getTable2DValue" in line and match2d and ('derivativesVars' in match2d.group('var_input1') or 'realVars' in match2d.group('var_input1') or 'derivativesVars' in match2d.group('var_input2') or 'realVars' in match2d.group('var_input2')):
        if not 'NoDer' in line:
            print(line)
            sys.exit("Issue with the replacement of omc_Modelica_Blocks_Tables_Internal_getTable2DValue in adept Jacobian.")
    elif "omc_Modelica_Blocks_Tables_Internal_getTimeTableValue" in line and matcht and ('derivativesVars' in matcht.group('var_input') or 'realVars' in matcht.group('var_input')):
        if not 'NoDer' in line:
            print(line)
            sys.exit("Issue with the replacement of omc_Modelica_Blocks_Tables_Internal_getTimeTableValue in adept Jacobian.")

    return line
##
# Transform a line using adept so that it can be compiled
# @param line : line to analyse
# @return line transformed
def transform_line_adept(line):
    line_tmp = mmc_strings_len1(line)
    line_tmp = transform_atan3_operator_evalf(line_tmp)
    line_tmp = sub_division_sim(line_tmp)
    line_tmp = replace_var_names(line_tmp)
    line_tmp = line_tmp.replace("modelica_real ", "adept::adouble ")
    line_tmp = line_tmp.replace("Greater(", "Greater<adept::adouble>(")
    line_tmp = line_tmp.replace("Less(", "Less<adept::adouble>(")
    line_tmp = line_tmp.replace("GreaterEq(", "GreaterEq<adept::adouble>(")
    line_tmp = line_tmp.replace("LessEq(", "LessEq<adept::adouble>(")
    line_tmp = line_tmp.replace("Greater)", "Greater<adept::adouble>)")
    line_tmp = line_tmp.replace("Less)", "Less<adept::adouble>)")
    line_tmp = line_tmp.replace("GreaterEq)", "GreaterEq<adept::adouble>)")
    line_tmp = line_tmp.replace("LessEq)", "LessEq<adept::adouble>)")
    line_tmp = line_tmp.replace("threadData,", "")
    line_tmp = line_tmp.replace(", threadData)", ")")
    line_tmp = replace_combi_table_jacobian_adept(line_tmp)
    if "omc_assert_warning" in line_tmp:
        line_tmp = line_tmp.replace("info,","")
    return line_tmp

##
# Transform raw_body in a list to a string, used by setGequations()
# @param raw_body : raw_body in a list of string
# @return string : string contains raw_body
def transform_rawbody_to_string(raw_body):
    string = ""
    for item in raw_body:
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
    all_boolean_variables_names = []
    for var_name in boolean_variables_names:
        if to_param_address(var_name) != None:
            all_boolean_variables_names.append(to_param_address(var_name) + " /* " + var_name +" */")
            if "Vars" in to_param_address(var_name):
                all_boolean_variables_names.append(to_param_address(var_name) + " /* " + var_name +" DISCRETE */")
                all_boolean_variables_names.append(to_param_address(var_name).replace("Vars","VarsPre").replace("localData[0]","simulationInfo") + " /* " + var_name +" */")
                all_boolean_variables_names.append(to_param_address(var_name).replace("Vars","VarsPre").replace("localData[0]","simulationInfo")  + " /* " + var_name +" DISCRETE */")
            elif "Parameter" in to_param_address(var_name):
                all_boolean_variables_names.append(to_param_address(var_name) + " /* " + var_name +" PARAM */")
            all_boolean_variables_names.append(to_compile_name(var_name)+"_")

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
    allowed_containers = [' ', '(', ')', '=', '!', ',']
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

        for replacement, pattern in patterns_to_avoid.items():
            reading_side = reading_side.replace (pattern, replacement)

        # check that the right variable name (i.e. not part of another variable name) was found
        offset = 0
        for m in find_all_in_str (var_name, reading_side):
            m+=offset
            right_variable = (reading_side [m - 1] in allowed_containers) \
                             and (m + len(var_name) < len(reading_side)) and (reading_side [m + len(var_name)] in allowed_containers)

            if right_variable:
                reading_side = reading_side [ : m] + "(toNativeBool (" + var_name + "))" + reading_side [ m + len(var_name): ]
                offset += len("(toNativeBool (") + len("))")

        # put back quoted names
        for replacement, pattern in patterns_to_avoid.items():
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
# Check whether equationIndexes is within a given line
# These checks are performed after the OMC reader, because the OMC reader sometimes skips some lines (and deals with lines packages)
# @param line : the line to scan
# @return whether TRACE_POP or TRACE_PUSH lies within the line
def has_omc_equation_indexes (line):
    equation_indexes_pattern = re.compile(r'const int equationIndexes.*')
    return (re.search (equation_indexes_pattern, line) is not None)

##
# Check whether OpenModelica Trace (TRACE_PUSH or TRACE_POPO) is within a given line
# These checks are performed after the OMC reader, because the OMC reader sometimes skips some lines (and deals with lines packages)
# @param line : the line to scan
# @return whether TRACE_POP or TRACE_PUSH lies within the line
def has_omc_trace (line):
    push_pattern = re.compile (r'TRACE_PUSH')
    pop_pattern = re.compile (r'TRACE_POP')
    return (re.search(push_pattern, line) is not None) or (re.search(pop_pattern, line) is not None)


##
# Check whether a given function body is associated with a Modelica reinit command
# @param body : a body of lines
# @return whether the body of lines is linked with a Modelica reinit
def is_modelica_reinit_body(body):
    pattern_to_look_for = NEED_TO_ITERATE_ACTIVATION
    return any(pattern_to_look_for in line for line in body)


##
# Format a body for Modelica reinit affectation
# @param body : a body of lines
# @return the formatted body
def format_for_modelica_reinit_affectation(body):
    text_to_return = []
    need_to_iterate_pattern = NEED_TO_ITERATE_ACTIVATION
    for line in body:
        line = mmc_strings_len1(line)

        if has_omc_trace (line) or has_omc_equation_indexes (line) \
           or ("infoStreamPrint" in line) or (need_to_iterate_pattern in line):
            continue

        line = sub_division_sim(line)

        text_to_return.append( line )
    return text_to_return


##
# Format a body for Modelica reinit eval mode
# @param body : a body of lines
# @return the formatted body
def format_for_modelica_reinit_evalmode(body):
    text_to_return = []
    entered_if = False
    exited_if = False
    nb_opened_brackets = 0
    need_to_iterate_pattern = NEED_TO_ITERATE_ACTIVATION
    mode_change_line = "return ALGEBRAIC_J_UPDATE_MODE;"
    for line in body:
        line = mmc_strings_len1(line)

        if has_omc_trace (line) or has_omc_equation_indexes (line) or ("infoStreamPrint" in line):
            continue

        line = sub_division_sim(line)
        line = replace_var_names(line)

        # entering if evaluation : only keep the mode setting line
        if ('if' in line) and ('VarsPre\[' in line):
            entered_if = True

        if (entered_if and (not exited_if)):
            if ('{'in line) or ('}' in line) or ('if' in line):
                if ('{'in line):
                    nb_opened_brackets += 1

                if ('}' in line):
                    nb_opened_brackets -= 1
                    if (nb_opened_brackets == 0):
                        exited_if = True

                text_to_return.append (line)

            elif (nb_opened_brackets > 0):
                if (need_to_iterate_pattern not in line):
                    continue
                else:
                    new_line = line.replace (need_to_iterate_pattern, mode_change_line)
                    text_to_return.append (new_line)
        else:
            text_to_return.append (line)

    return text_to_return

tmp_eq_ptrn = re.compile(r'\s*tmp[0-9]+\s*=.*;')
residual_var_name = "$P$DAEres"

def build_tmp_tree(eq_body):
    tmp_ptrn = re.compile(r'(?P<var1>tmp[0-9]+)')
    tree_deps_tmp = {}
    boolean_tmps = []
    for line in eq_body:
        if re.search(tmp_eq_ptrn, line) is not None:
            main_tmp = line.split("=")[0].strip()
            value = line.split("=")[1]
            if "(modelica_boolean)" in value:
                boolean_tmps.append(main_tmp)
            if "tmp" in value:
                tmps = re.findall(tmp_ptrn, value)
                for tmp in tmps :
                    if main_tmp not in tree_deps_tmp:
                        tree_deps_tmp[main_tmp] = []
                    if tmp not in tree_deps_tmp[main_tmp]:
                        tree_deps_tmp[main_tmp].append(tmp)
            else:
                if main_tmp not in tree_deps_tmp:
                    tree_deps_tmp[main_tmp] = []
                tree_deps_tmp[main_tmp].append("EQ")

    for boolean_tmp in boolean_tmps:
        tmps_to_remove = [boolean_tmp]
        while len(tmps_to_remove) > 0:
            tmp_to_remove = tmps_to_remove[0]
            tmps_to_remove.remove(tmp_to_remove)
            if tmp_to_remove in tree_deps_tmp:
                values = tree_deps_tmp[tmp_to_remove]
                del tree_deps_tmp[tmp_to_remove]
                for value in values:
                    if "tmp" in value:
                        tmps_to_remove.append(value)

    # Detection of local tmp vars used to simplify a line and not used in a condition
    # e.g. tmp1 = sin(a); tmp2= b - tmp1*tmp1
    nb_tmp_deps = {}
    nb_eq_associated_to_tmp = {}
    for tmp in tree_deps_tmp:
        deps = tree_deps_tmp[tmp]
        count = len(list(filter(lambda x: "tmp" in x, deps)))
        nb_tmp_deps[tmp] = count
        count = len(list(filter(lambda x: "EQ" in x, deps)))
        nb_eq_associated_to_tmp[tmp] = count
    for tmp in nb_tmp_deps:
        count = nb_tmp_deps[tmp]
        needs_to_be_removed = True
        if count > 1:
            for dep in tree_deps_tmp[tmp]:
                if "tmp" in dep and (len(tree_deps_tmp[dep]) > 1 or nb_eq_associated_to_tmp[dep] > 1):
                    needs_to_be_removed = False
                    break
        if needs_to_be_removed and count == 0 and len(tree_deps_tmp[tmp]) == 1:
            tree_deps_tmp[tmp] = "IGNORED"

        while needs_to_be_removed and count > 1:
            for dep in tree_deps_tmp[tmp]:
                if "tmp" in dep:
                    tree_deps_tmp[dep] = "IGNORED"
                    tree_deps_tmp[tmp].remove(dep)
                    count-=1
                    break
            if count == 1:
                for dep in tree_deps_tmp[tmp]:
                    if "tmp" in dep:
                        tree_deps_tmp[dep].append("IGNORED")
                        break
    return tree_deps_tmp
##
# replace the equations in the if statement by others lines
# @param eq_body : a body of lines
# @param lines_to_insert : lines to insert
# @return the formatted body
def replace_equations_in_a_if_statement(eq_body, type_tree, line_to_insert_algebraic, line_to_insert_differential, additional_leading_space):
    res_body = []
    tmp_eq_residual = re.compile(r'\s*f\[[0-9]+\]\s*=.*;')
    leading_spaces_gen= ""
    for _ in range(1, additional_leading_space):
        leading_spaces_gen+=" "
    tree_deps_tmp = build_tmp_tree(eq_body)
    ignored = []
    for tmp in tree_deps_tmp:
        if "IGNORED" in tree_deps_tmp[tmp]:
            ignored.append(tmp)

    types = type_tree.get_types()
    idx = 0
    for line in eq_body:
        if "modelica_real tmp" in line : continue
        if re.search(tmp_eq_ptrn, line) is not None:
            main_tmp = line.split("=")[0].strip()
            if main_tmp in tree_deps_tmp:
                value = line.split("=")[1]
                for ignored_tmp in ignored:
                    value = value.replace(ignored_tmp,"")
                if "tmp" not in value and "EQ" in tree_deps_tmp[main_tmp] and "IGNORED" not in tree_deps_tmp[main_tmp]:
                    assert(idx < len(types))
                    nb_leading_spaces = len(line) - len(line.lstrip())
                    leading_spaces= ""
                    for _ in range(1, nb_leading_spaces+additional_leading_space):
                        leading_spaces+=" "
                    line_to_insert = line_to_insert_algebraic
                    if types[idx] == DIFFERENTIAL:
                        line_to_insert = line_to_insert_differential
                    res_body.append(leading_spaces + line_to_insert)
                    idx+=1
            else:
                res_body.append(leading_spaces_gen + line)
        else:
            if residual_var_name in line:
                continue
            if re.search(tmp_eq_residual, line) is not None:
                continue
            res_body.append(leading_spaces_gen + line)
    assert (idx == len(types))
    return res_body


def replace_equations_in_a_if_statement_y(eq_body, type_tree, alg_vars, diff_var_to_eq, additional_leading_space):
    res_body = []
    tmp_eq_residual = re.compile(r'\s*f\[[0-9]+\]\s*=.*;')
    tmp_eq_tmp_ptrn = re.compile(r'\s*tmp[0-9]+\s*=\s*[(-]*tmp[0-9]+[)]*\s*;')
    leading_spaces_gen= ""
    for _ in range(1, additional_leading_space):
        leading_spaces_gen+=" "
    tree_deps_tmp = build_tmp_tree(eq_body)
    to_remove = []
    for tmp in tree_deps_tmp:
        if "IGNORED" in tree_deps_tmp[tmp]:
            to_remove.append(tmp)
    for tmp in to_remove:
        del  tree_deps_tmp[tmp]

    equations = type_tree.get_equations()

    # We need to fix the equations as sometime an embedded if is still dumped with a modelica_real tmp; if ... tmp = ...; else tmp = ...; in the final cpp
    idx = 0
    for main_tmp in tree_deps_tmp:
        if "if" in equations[idx]  and "else" in equations[idx] and len(tree_deps_tmp[main_tmp]) > 1:
            equations.insert(idx + 1, equations[idx][equations[idx].index("if"):equations[idx].index("else")])
            equations.insert(idx + 2, equations[idx][equations[idx].index("else"):])
            equations[idx] = equations[idx][:equations[idx].index("if")]
        idx+=1


    idx = 0
    replacement_done = False
    for line in eq_body:
        if "modelica_real tmp" in line : continue
        if re.search(tmp_eq_ptrn, line) is not None:
            main_tmp = line.split("=")[0].strip()
            if main_tmp in tree_deps_tmp:
                if re.search(tmp_eq_tmp_ptrn, line) is None:
                    assert(idx < len(equations))
                    if equations[idx] == "MIN/MAX value":
                        res_body.pop() # remove the corresponding if
                        idx += 1
                        continue
                    nb_leading_spaces = len(line) - len(line.lstrip())
                    leading_spaces= ""
                    for _ in range(1, nb_leading_spaces+additional_leading_space):
                        leading_spaces+=" "
                    var_idx = 0
                    for var in alg_vars:
                        if var.get_name() not in diff_var_to_eq:
                            var_idx +=1
                            continue
                        if "der(" + var.get_name() in line or "der (" + var.get_name() in line:
                            replacement_done = True
                            line_to_insert = "   yType[ %s ] = %s;   /* %s (%s) */\n" % (str(var_idx), "DIFFERENTIAL", to_compile_name(var.get_name()), var.get_type())
                            res_body.append(leading_spaces + line_to_insert)
                        elif var.get_name() in line:
                            replacement_done = True
                            line_to_insert = "   if (yType[ %s ] != DIFFERENTIAL) yType[ %s ] = %s;   /* %s (%s) */\n" % (str(var_idx), str(var_idx), "ALGEBRAIC", to_compile_name(var.get_name()), var.get_type())
                            res_body.append(leading_spaces + line_to_insert)
                        var_idx +=1
                    idx+=1
            elif main_tmp not in to_remove:
                res_body.append(leading_spaces_gen + line)
        elif residual_var_name in line and  "data->localData" in line:
            assert(idx < len(equations))
            nb_leading_spaces = len(line) - len(line.lstrip())
            leading_spaces= ""
            for _ in range(1, nb_leading_spaces+additional_leading_space):
                leading_spaces+=" "
            var_idx = 0
            for var in alg_vars:
                if var.get_name() not in diff_var_to_eq:
                    var_idx +=1
                    continue
                replacement_done = True
                if "der(" + var.get_name() in line or "der (" + var.get_name() in line:
                    line_to_insert = "   yType[ %s ] = %s;   /* %s (%s) */\n" % (str(var_idx), "DIFFERENTIAL", to_compile_name(var.get_name()), var.get_type())
                    res_body.append(leading_spaces + line_to_insert)
                elif var.get_name() in line:
                    line_to_insert = "   if (yType[ %s ] != DIFFERENTIAL) yType[ %s ] = %s;   /* %s (%s) */\n" % (str(var_idx), str(var_idx), "ALGEBRAIC", to_compile_name(var.get_name()), var.get_type())
                    res_body.append(leading_spaces + line_to_insert)
                var_idx +=1
            idx+=1
        else:
            if residual_var_name in line and "data->localData" not in line:
                continue
            if re.search(tmp_eq_residual, line) is not None:
                continue
            res_body.append(leading_spaces_gen + line)
    assert (idx == len(equations))
    if not replacement_done:
        return []
    return res_body
