# -*- coding: utf-8 -*-

# Copyright (c) 2022, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import operator
import os
import sys
import XMLUtils
import diffUtils
import csv

try:
    settings_dir = os.path.join(os.path.dirname(__file__))
    sys.path.append(settings_dir)
    import settings
except Exception as exc:
    print("Failed to import nrtDiff settings : " + str(exc))
    sys.exit(1)

# Utility class to compare Constraints files
class FinalStateValueObject:
    def __init__(self):
        self.model_name=""
        self.variable=""
        self.value = ""

    def get_unique_id(self):
        return self.model_name+"_"+self.variable

# Read a XML FSV file name and build a dictionary object id => values
def get_xml_fsv_info(filename):
    fsv_by_id = {}
    (fsv_root, ns, prefix) = XMLUtils.ImportXMLFileExtended(filename)
    for child in XMLUtils.FindAll(fsv_root, prefix, "finalStateValue", ns):
        my_object = FinalStateValueObject();
        my_object.model_name = child.attrib['model']
        my_object.variable = child.attrib['variable']
        my_object.value = child.attrib['value']
        fsv_by_id[my_object.get_unique_id()] = my_object
    return fsv_by_id

# Read a CSV FSV file name and build a dictionary object id => values
def get_csv_fsv_info(filename):
    fsv_by_id = {}
    with open (filename, "rt") as file:
        reader = list(csv.reader (file, delimiter = ";"))
    row_index = 0
    for row in reader:
        if row_index == 0:
            # skip header
            row_index += 1
            continue
        index = 0
        my_object = FinalStateValueObject();
        for v in row:
            if index == 0:
                my_object.model_name = v
            elif index == 1:
                my_object.variable = v
            elif index == 2:
                my_object.value = v
            index += 1
        fsv_by_id[my_object.get_unique_id()] = my_object
        row_index += 1
    return fsv_by_id

# Compare 2 dictionaries read from two fsv files
# @param left_file_info : the dictionary from the left path
# @param right_file_info : the dictionary from the right path
def compare_fsv_info (left_file_info, right_file_info):
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

# Check whether two xml output fsv files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def output_xml_fsv_close_enough (path_left, path_right):
    left_file_info = get_xml_fsv_info(path_left)
    right_file_info = get_xml_fsv_info(path_right)
    return compare_fsv_info(left_file_info, right_file_info)

# Check whether two csv output fsv files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def output_csv_fsv_close_enough (path_left, path_right):
    left_file_info = get_csv_fsv_info(path_left)
    right_file_info = get_csv_fsv_info(path_right)
    return compare_fsv_info(left_file_info, right_file_info)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Error : not enough arguments")
    path_left = sys.argv[1]
    path_right = sys.argv[2]
    nb_differences = 0
    print("Comparing " + path_left + " and " + path_right)
    if (path_left.endswith(".xml") and path_right.endswith(".xml")):
        nb_differences, msg = output_xml_fsv_close_enough(path_left, path_right)
    elif (path_left.endswith(".csv") and path_right.endswith(".csv")):
        nb_differences, msg = output_csv_fsv_close_enough(path_left, path_right)
    else:
        print ("[ERROR] Could not compare files " + path_left + " and " + path_right)
        exit(1)
    if nb_differences > 0:
        print(msg)
        exit(1)
    print("OK")
