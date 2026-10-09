# -*- coding: utf-8 -*-

# Copyright (c) 2026, RTE (http://www.rte-france.com)
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
import re
import sys
import diffUtils

try:
    settings_dir = os.path.join(os.path.dirname(__file__))
    sys.path.append(settings_dir)
    import settings
except Exception as exc:
    print("Failed to import nrtDiff settings : " + str(exc))
    sys.exit(1)

# jacobian in the row;column;value format: linearization_<time>.txt or linearization_prim_<time>.txt
TRIPLETS_FILE_PATTERN = re.compile(r'^linearization_(prim_)?[-+0-9.eE]+$')
# values of the compressed storage of a jacobian: linearization_<time>_Ax.txt or linearization_prim_<time>_Ax.txt
VALUES_FILE_PATTERN = re.compile(r'^linearization_.*_Ax$')
SEPARATOR = ";"

# Index of the fields compared with a tolerance in a linearization file, the others must be identical
# @param file_name : the file name without its extension
def get_value_fields(file_name):
    if TRIPLETS_FILE_PATTERN.match(file_name):
        return [2]
    if VALUES_FILE_PATTERN.match(file_name):
        return [0]
    return []

# Read a linearization file: one list of fields per line
def get_lines(filename):
    with open(filename, "rt") as file:
        return [line.rstrip("\n").split(SEPARATOR) for line in file]

# Check whether two linearization files are close enough
# The values of the jacobians are compared with a tolerance, all the other fields (indexes, names, types) must be identical
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def output_linearization_close_enough(path_left, path_right):
    file_name = os.path.splitext(os.path.basename(path_left))[0]
    value_fields = get_value_fields(file_name)
    lines_left = get_lines(path_left)
    lines_right = get_lines(path_right)

    if len(lines_left) != len(lines_right):
        return (1, "[ERROR] different number of lines (" + str(len(lines_left)) + " in left path, " + str(len(lines_right)) + " in right one)\n")

    nb_differences = 0
    msg = ""
    differences = []
    for line_index, (fields_left, fields_right) in enumerate(zip(lines_left, lines_right)):
        if len(fields_left) != len(fields_right):
            nb_differences += 1
            msg += "[ERROR] line " + str(line_index + 1) + " has a different number of fields in the two files\n"
            continue
        for field_index, (field_left, field_right) in enumerate(zip(fields_left, fields_right)):
            if field_left == field_right:
                continue
            if field_index in value_fields:
                try:
                    value_left = float(field_left)
                    value_right = float(field_right)
                    if not diffUtils.isclose(value_left, value_right):
                        nb_differences += 1
                        differences.append([abs(value_left - value_right), line_index + 1])
                    continue
                except ValueError:
                    pass
            nb_differences += 1
            msg += "[ERROR] line " + str(line_index + 1) + " is different in the two files: " + SEPARATOR.join(fields_left) + \
                " / " + SEPARATOR.join(fields_right) + "\n"
            break

    for error in sorted(differences, key=operator.itemgetter(0), reverse=True)[:settings.max_nb_iidm_outputs]:
        msg += "[ERROR] values of line " + str(error[1]) + " are different (delta = " + str(error[0]) + ") \n"
    return (nb_differences, msg)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Error : not enough arguments")
        sys.exit(1)
    path_left = sys.argv[1]
    path_right = sys.argv[2]
    print("Comparing " + path_left + " and " + path_right)
    nb_differences, msg = output_linearization_close_enough(path_left, path_right)
    if nb_differences > 0:
        print("[ERROR] " + str(nb_differences) + " differences found:")
        print(msg)
    else:
        print("No difference")
