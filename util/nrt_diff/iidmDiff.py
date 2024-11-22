# -*- coding: utf-8 -*-

# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import os
import sys
import operator
import XMLUtils
import diffUtils

try:
    settings_dir = os.path.join(os.path.dirname(__file__))
    sys.path.append(settings_dir)
    import settings
except Exception as exc:
    print("Failed to import nrtDiff settings : " + str(exc))
    sys.exit(1)

# Utility class to compare IIDM files
class IIDMobject:
    def __init__(self,ID):
        self.id=ID
        self.type=""
        self.values = {}

# Utility method to compare IIDM files
def set_values(element,what,IIDMobject):
    if  what in element.attrib:
        IIDMobject.values[what] = element.attrib[what]

# Read a IIDM file name and build a dictionary object id => values
# Only values that can be changed by dynawo are taken into account
def getOutputIIDMInfo(filename):
    IIDM_objects_byID = {}
    (iidm_root, ns, prefix) = XMLUtils.ImportXMLFileExtended(filename)
    for voltageLevel in XMLUtils.FindAll(iidm_root, prefix, "voltageLevel", ns):
        for child in XMLUtils.FindAll(voltageLevel, prefix, "*", ns):
            if 'id' in child.attrib:
                myId = child.attrib['id']
                myObject = IIDMobject(myId)
                myObject.type = child.tag.replace("{"+ns[prefix]+"}", "")
                if myObject.type == 'bus':
                    set_values(child,'v',myObject)
                    set_values(child,'angle',myObject)
                elif myObject.type == 'generator' or myObject.type == 'load':
                    set_values(child,'p',myObject)
                    set_values(child,'q',myObject)
                    set_values(child,'bus',myObject)
                elif myObject.type == 'switch':
                    set_values(child,'open',myObject)
                elif myObject.type == 'line':
                    set_values(child,'p1',myObject)
                    set_values(child,'q1',myObject)
                    set_values(child,'p2',myObject)
                    set_values(child,'q2',myObject)
                    set_values(child,'bus1',myObject)
                    set_values(child,'bus2',myObject)
                elif myObject.type == 'danglineLine':
                    set_values(child,'p',myObject)
                    set_values(child,'q',myObject)
                    set_values(child,'bus',myObject)
                elif myObject.type == 'twoWindingsTransformer':
                    set_values(child,'p1',myObject)
                    set_values(child,'q1',myObject)
                    set_values(child,'p2',myObject)
                    set_values(child,'q2',myObject)
                    set_values(child,'bus1',myObject)
                    set_values(child,'bus2',myObject)
                elif myObject.type == 'ratioTapChanger' or  myObject.type == 'phaseTapChanger':
                    set_values(child,'tapPosition',myObject)
                elif myObject.type == 'vscConverterStation'or  myObject.type == 'lccConverterStation':
                    set_values(child,'p',myObject)
                    set_values(child,'q',myObject)
                    set_values(child,'bus',myObject)
                elif myObject.type == 'shunt':
                    set_values(child,'currentSectionCount',myObject)
                    set_values(child,'sectionCount',myObject)
                    set_values(child,'bus',myObject)
                    set_values(child,'q',myObject)
                elif myObject.type == 'staticVarCompensator':
                    set_values(child,'p',myObject)
                    set_values(child,'bus',myObject)
                    set_values(child,'q',myObject)
                    set_values(child,'regulationMode',myObject)
                IIDM_objects_byID[myId] = myObject
    return IIDM_objects_byID

# Check whether two output IIDM values files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def OutputIIDMCloseEnough (path_left, path_right):
    is_left_powsybl_iidm = False
    with open(path_left) as f:
        if 'iidm:network' in f.read():
            is_left_powsybl_iidm = True
    left_file_info = getOutputIIDMInfo(path_left)
    is_right_powsybl_iidm = False
    with open(path_right) as f:
        if 'iidm:network' in f.read():
            is_right_powsybl_iidm = True
    right_file_info = getOutputIIDMInfo(path_right)
    nb_differences = 0
    msg = ""
    differences = []

    for firstId in left_file_info:
        if firstId not in right_file_info:
            if (not is_left_powsybl_iidm and is_right_powsybl_iidm) and left_file_info[firstId].type == "busbarSection":
                continue
            nb_differences+=1
            msg += "[ERROR] object " + firstId + " is in left path but not in right one\n"
    for firstId in right_file_info:
        if firstId not in left_file_info:
            if (not is_right_powsybl_iidm and is_left_powsybl_iidm) and right_file_info[firstId].type == "busbarSection":
                continue
            nb_differences+=1
            msg += "[ERROR] object " + firstId + " is in right path but not in left one\n"
    for firstId in left_file_info:
        firstObj = left_file_info[firstId]
        if firstId in right_file_info:
            secondObj = right_file_info[firstId]
            for attr1 in firstObj.values:
                if attr1 not in secondObj.values:
                    if attr1=="currentSectionCount":
                        if ('sectionCount' in secondObj.values):
                            if (firstObj.values[attr1] == secondObj.values['sectionCount']):
                                continue
                            else:
                                nb_differences+=1
                                msg += "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " has another value on right side (value: " + secondObj.values['sectionCount'] + ")\n"
                                continue
                    elif attr1=="sectionCount":
                        if ('currentSectionCount' in secondObj.values):
                            if (firstObj.values[attr1] == secondObj.values['currentSectionCount']):
                                continue
                            else:
                                nb_differences+=1
                                msg += "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " has another value on right side (value: " + secondObj.values['currentSectionCount'] + ")\n"
                                continue
                    nb_differences+=1
                    msg += "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " is not in the equivalent object on right side\n"
                else:
                    try:
                        difference = abs(float(firstObj.values[attr1])- float(secondObj.values[attr1]))
                        if not diffUtils.isclose(float(firstObj.values[attr1]), float(secondObj.values[attr1])):
                            nb_differences+=1
                            differences.append([difference, firstObj, attr1])
                    except ValueError:
                        if (firstObj.values[attr1] != secondObj.values[attr1]):
                            if (not is_left_powsybl_iidm and is_right_powsybl_iidm) or (not is_right_powsybl_iidm and is_left_powsybl_iidm):
                                if "switch" in firstObj.type and attr1=="open":
                                    #we ignore the open differences between the 2 differents libiidm as NODE_BREAKER topology is handled differently
                                    continue
                            nb_differences+=1
                            msg += "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " has another value on right side (value: " + secondObj.values[attr1] + ")\n"
            for attr1 in secondObj.values:
                if attr1 not in firstObj.values:
                    if attr1=="currentSectionCount":
                        if ('sectionCount' in firstObj.values):
                            if (secondObj.values[attr1] == firstObj.values['sectionCount']):
                                continue
                            else:
                                nb_differences+=1
                                msg += "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + secondObj.values[attr1] + " has another value on right side (value: " + firstObj.values['sectionCount'] + ")\n"
                                continue
                    elif attr1=="sectionCount":
                        if ('currentSectionCount' in firstObj.values):
                            if (secondObj.values[attr1] == firstObj.values['currentSectionCount']):
                                continue
                            else:
                                nb_differences+=1
                                msg += "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + secondObj.values[attr1] + " has another value on right side (value: " + firstObj.values['currentSectionCount'] + ")\n"
                                continue
                    nb_differences+=1
                    msg += "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + secondObj.values[attr1] + " is not in the equivalent object on left side\n"
    for error in sorted(differences, key=operator.itemgetter(0), reverse=True)[:settings.max_nb_iidm_outputs]:
        msg += "[ERROR] attribute " + error[2] + " of object " + error[1].id + " (type " + error[1].type + ") has different values (delta = " + str(error[0]) + ") \n"
    return (nb_differences, msg)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Error : not enough arguments")
    path_left = sys.argv[1]
    path_right = sys.argv[2]
    print("Comparing " + path_left + " and " + path_right)
    nb_differences, msg = OutputIIDMCloseEnough(path_left, path_right)
    if nb_differences > 0:
        print(msg)
        exit(1)
    print("OK")
