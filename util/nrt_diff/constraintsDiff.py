# -*- coding: utf-8 -*-

# Copyright (c) 2022, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import operator
import os
import sys
import XMLUtils
import diffUtils

try:
    settings_dir = os.path.join(os.path.dirname(__file__))
    sys.path.append(settings_dir)
    import settings
except Exception as exc:
    print("Failed to import nrtDiff settings : " + str(exc))
    sys.exit(1)

# Utility class to compare Constraints files
class ConstraintsObject:
    def __init__(self):
        self.model_name=""
        self.description=""
        self.time=""
        self.type=""
        self.kind = ""
        self.limit = ""
        self.value = ""
        self.valueMin = ""
        self.valueMax = ""
        self.side = ""
        self.acceptable_duration = ""

    def get_unique_id(self):
        return self.model_name+"_"+self.time+"_"+self.description

# Read a XML Constraints file name and build a dictionary object id => values
def get_xml_constraints_info(filename):
    constraints_by_id = {}
    (cstr_root, ns, prefix) = XMLUtils.ImportXMLFileExtended(filename)
    for child in XMLUtils.FindAll(cstr_root, prefix, "constraint", ns):
        my_object = ConstraintsObject();
        my_object.model_name = child.attrib['modelName']
        my_object.description = child.attrib['description']
        my_object.time = child.attrib['time']
        if "type" in child.attrib:
            my_object.type = child.attrib['type']
        if "kind" in child.attrib:
            my_object.kind = child.attrib['kind']
        if "limit" in child.attrib:
            my_object.limit = child.attrib['limit']
        if "value" in child.attrib:
            my_object.value = child.attrib['value']
        if "valueMin" in child.attrib:
            my_object.valueMin = child.attrib['valueMin']
        if "valueMax" in child.attrib:
            my_object.valueMax = child.attrib['valueMax']
        if "side" in child.attrib:
            my_object.side = child.attrib['side']
        if "acceptableDuration" in child.attrib:
            my_object.acceptable_duration = child.attrib['acceptableDuration']
        constraints_by_id[my_object.get_unique_id()] = my_object
    return constraints_by_id

# Read a TXT Constraints file name and build a dictionary object id => values
def get_txt_constraints_info(filename):
    constraints_by_id = {}
    possible_kinds = ["OverloadOpen", "OverloadUp", "PATL", "UInfUmin", "USupUmax"]
    f=open(filename, "r")
    for line in f.readlines():
        array = line.split('|')
        if (len(array) < 3):
            continue
        my_object = ConstraintsObject()
        my_object.model_name = array[0].strip()
        my_object.description = array[1].strip()
        my_object.time = array[2].strip()
        latest_index = 3
        if (len(array) > latest_index):
            next_iter = array[latest_index].strip()
            latest_index+=1
            if next_iter not in possible_kinds:
                my_object.type = next_iter
                if (len(array) > latest_index):
                    my_object.kind = array[latest_index].strip()
                    latest_index+=1
            else:
                my_object.kind = next_iter
            if (len(array) > latest_index):
                my_object.limit = array[latest_index].strip()
                latest_index+=1
                my_object.value = array[latest_index].strip()
                latest_index+=1
            if (len(array) > latest_index):
                my_object.side = array[latest_index].strip()
                latest_index+=1
            if (len(array) > latest_index):
                my_object.acceptable_duration = array[latest_index].strip()
                latest_index+=1
        constraints_by_id[my_object.get_unique_id()] = my_object
    f.close()
    return constraints_by_id

# Compare 2 dictionaries read from two constraint files
# @param left_file_info : the dictionary from the left path
# @param right_file_info : the dictionary from the right path
def compare_constraints_info (left_file_info, right_file_info):
    nb_differences = 0
    msg = ""
    differences = []

    for firstId in sorted(left_file_info):
        if firstId not in right_file_info:
            nb_differences+=1
            msg += "[ERROR] object " + firstId + " is in left path but not in right one\n"
    for firstId in sorted(right_file_info):
        if firstId not in left_file_info:
            nb_differences+=1
            msg += "[ERROR] object " + firstId + " is in right path but not in left one\n"
    for firstId in sorted(left_file_info):
        firstObj = left_file_info[firstId]
        if firstId in sorted(right_file_info):
            secondObj = right_file_info[firstId]
            if firstObj.type != secondObj.type :
                nb_differences+=1
                msg += "[ERROR] object " + firstId + " has different types in the two files\n"
            if firstObj.limit != secondObj.limit:
                nb_differences+=1
                msg += "[ERROR] object " + firstId + " has different limits in the two files\n"
            if firstObj.side != secondObj.side:
                nb_differences+=1
                msg += "[ERROR] object " + firstId + " has different sides in the two files\n"
            if firstObj.acceptable_duration != secondObj.acceptable_duration:
                nb_differences+=1
                msg += "[ERROR] object " + firstId + " has different acceptable durations in the two files\n"
            if firstObj.kind != secondObj.kind:
                nb_differences+=1
                msg += "[ERROR] object " + firstId + " has different kinds in the two files\n"
            if firstObj.valueMin != secondObj.valueMin:
                nb_differences+=1
                msg += "[ERROR] object " + firstId + " has different valueMin in the two files\n"
            if firstObj.valueMax != secondObj.valueMax:
                nb_differences+=1
                msg += "[ERROR] object " + firstId + " has different valueMax in the two files\n"
            if firstObj.value != "" or secondObj.value != "":
                try:
                    difference = abs(float(firstObj.value)- float(secondObj.value))
                    if not diffUtils.isclose(float(firstObj.value), float(secondObj.value)):
                        nb_differences+=1
                        differences.append([difference, firstId])
                except ValueError:
                    nb_differences+=1
                    msg += "[ERROR] object " + firstId + " has different values in the two files\n"

    for error in sorted(differences, key=operator.itemgetter(0), reverse=True)[:settings.max_nb_iidm_outputs]:
        msg += "[ERROR] values of object " +  error[1] + " are different (delta = " + str(error[0]) + ") \n"
    return (nb_differences, msg)

# Check whether two txt output Constraints values files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def ouput_txt_constraints_close_enough (path_left, path_right):
    left_file_info = get_txt_constraints_info(path_left)
    right_file_info = get_txt_constraints_info(path_right)
    return compare_constraints_info(left_file_info, right_file_info)

# Check whether two xml output Constraints values files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def ouput_xml_constraints_close_enough (path_left, path_right):
    left_file_info = get_xml_constraints_info(path_left)
    right_file_info = get_xml_constraints_info(path_right)
    return compare_constraints_info(left_file_info, right_file_info)

# Check whether two output Constraints values files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def output_constraints_close_enough (path_left, path_right):
    file_type = getFileType(path_left)
    if (file_type != getFileType(path_right)):
        print("[ERROR] different file extensions between left and right files.")
        exit(1)
    if (file_type == "XML"):
        return ouput_xml_constraints_close_enough(path_left, path_right)
    if (file_type == "TXT"):
        return ouput_txt_constraints_close_enough(path_left, path_right)
    return None

def getFileType(filename):
    if os.path.basename(filename).endswith(".txt"):
        return "TXT"
    elif os.path.basename(filename).endswith(".xml"):
        return "XML"
    else:
        print("[ERROR] unrecognized file extension.")
        exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Error : not enough arguments")
    path_left = sys.argv[1]
    path_right = sys.argv[2]
    print("Comparing " + path_left + " and " + path_right)
    nb_differences, msg = output_constraints_close_enough(path_left, path_right)
    if nb_differences > 0:
        print(msg)
        exit(1)
    print("OK")
