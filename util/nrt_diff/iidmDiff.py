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
                elif myObject.type == 'generator' or myObject.type == 'load' or myObject.type == 'battery':
                    set_values(child,'p',myObject)
                    set_values(child,'q',myObject)
                    set_values(child,'bus',myObject)
                    if myObject.type == 'generator' and 'voltageRegulatorOn' in child.attrib and child.attrib['voltageRegulatorOn'] == "true":
                        set_values(child,'targetV',myObject)
                    if myObject.type == 'generator':
                        set_values(child,'targetQ',myObject)
                elif myObject.type == 'switch':
                    set_values(child,'open',myObject)
                    set_values(child,'node1',myObject)
                    set_values(child,'node2',myObject)
                    set_values(child,'bus1',myObject)
                    set_values(child,'bus2',myObject)
                elif myObject.type == 'danglineLine':
                    set_values(child,'p',myObject)
                    set_values(child,'q',myObject)
                    set_values(child,'bus',myObject)
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
            elif child.tag.replace("{"+ns[prefix]+"}", "") == 'bus' and 'nodes' in child.attrib : # in powsybl iidm, nodebreaker voltage level buses ids are computed:
                nodesString = child.attrib['nodes']
                firstNode = nodesString.split(",")[0] # computed id here will be based on the frst node in the its list (they are sorted in iidm def)
                nodeBusId = voltageLevel.attrib['id'] + "_" + str(firstNode)
                myObject = IIDMobject(nodeBusId)
                myObject.type = 'bus'
                set_values(child,'v',myObject)
                set_values(child,'angle',myObject)
                set_values(child, 'nodes', myObject) # will compare the raw list of nodes indexes
                IIDM_objects_byID[nodeBusId] = myObject
    for line in XMLUtils.FindAll(iidm_root, prefix, "line", ns):
         if 'id' in line.attrib:
            myId = line.attrib['id']
            myObject = IIDMobject(myId)
            myObject.type = line.tag.replace("{"+ns[prefix]+"}", "")
            set_values(line,'p1',myObject)
            set_values(line,'q1',myObject)
            set_values(line,'p2',myObject)
            set_values(line,'q2',myObject)
            set_values(line,'bus1',myObject)
            set_values(line,'bus2',myObject)
            IIDM_objects_byID[myId] = myObject
    for twoWT in XMLUtils.FindAll(iidm_root, prefix, "twoWindingsTransformer", ns):
        if 'id' in twoWT.attrib:
            myId = twoWT.attrib['id']
            myObject = IIDMobject(myId)
            myObject.type = twoWT.tag.replace("{"+ns[prefix]+"}", "")
            set_values(twoWT,'p1',myObject)
            set_values(twoWT,'q1',myObject)
            set_values(twoWT,'p2',myObject)
            set_values(twoWT,'q2',myObject)
            set_values(twoWT,'bus1',myObject)
            set_values(twoWT,'bus2',myObject)
            IIDM_objects_byID[myId] = myObject
            for tapChanger in XMLUtils.FindAllWithAttribute(twoWT, "tapPosition"):
                tapChangerType = tapChanger.tag.replace("{"+ns[prefix]+"}", "")
                if tapChangerType == 'ratioTapChanger' or  tapChangerType == 'phaseTapChanger':
                    tapChangerId = myId + "_" + tapChangerType
                    tapChangerObject = IIDMobject(tapChangerId)
                    tapChangerObject.type = tapChangerType
                    tapPosition = tapChanger.attrib['tapPosition']
                    lowTapPosition = tapChanger.attrib['lowTapPosition']
                    tapChangerObject.values['tapPosition'] = str(float(tapPosition) - float(lowTapPosition))
                    IIDM_objects_byID[tapChangerId] = tapChangerObject
    return IIDM_objects_byID

# Check whether an IIDM file was written by powsybl
# @param path : the absolute path to the file
def isPowsyblIIDM(path):
    with open(path) as f:
        return 'iidm:network' in f.read()

# Compare two output IIDM files object by object, on the values that can be changed by dynawo
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
# @param keep_within_tolerance : also return the numeric values that differ but are within tolerance
# @return the list of differences, in the order of the legacy messages. Each difference is a dict:
#   category : "missing_left", "missing_right" (object only on one side), "attribute" (attribute only on one side),
#              "discrete" (non numeric value), "numeric"
#   id, type, attribute (None for an object only on one side), left, right (values as strings, None when missing)
#   delta : absolute difference for numeric values, None otherwise
#   within_tolerance : True only for numeric values within tolerance (returned if keep_within_tolerance)
#   message : legacy message of the difference, None for numeric values (summarized afterwards)
def compareOutputIIDM (path_left, path_right, keep_within_tolerance = False):
    is_left_powsybl_iidm = isPowsyblIIDM(path_left)
    left_file_info = getOutputIIDMInfo(path_left)
    is_right_powsybl_iidm = isPowsyblIIDM(path_right)
    right_file_info = getOutputIIDMInfo(path_right)
    mixed_iidm_libraries = (not is_left_powsybl_iidm and is_right_powsybl_iidm) or (not is_right_powsybl_iidm and is_left_powsybl_iidm)
    differences = []

    def add(category, obj, attribute, left, right, message, delta = None, within_tolerance = False):
        differences.append({"category": category, "id": obj.id, "type": obj.type, "attribute": attribute,
                            "left": left, "right": right, "delta": delta, "within_tolerance": within_tolerance, "message": message})

    for firstId in sorted(left_file_info):
        if firstId not in right_file_info:
            if (not is_left_powsybl_iidm and is_right_powsybl_iidm) and left_file_info[firstId].type == "busbarSection":
                continue
            add("missing_right", left_file_info[firstId], None, None, None, "[ERROR] object " + firstId + " is in left path but not in right one\n")
    for firstId in sorted(right_file_info):
        if firstId not in left_file_info:
            if (not is_right_powsybl_iidm and is_left_powsybl_iidm) and right_file_info[firstId].type == "busbarSection":
                continue
            add("missing_left", right_file_info[firstId], None, None, None, "[ERROR] object " + firstId + " is in right path but not in left one\n")
    for firstId in sorted(left_file_info):
        firstObj = left_file_info[firstId]
        if firstId in right_file_info:
            secondObj = right_file_info[firstId]
            for attr1 in sorted(firstObj.values):
                if attr1 not in secondObj.values:
                    if attr1=="currentSectionCount":
                        if ('sectionCount' in secondObj.values):
                            if (firstObj.values[attr1] == secondObj.values['sectionCount']):
                                continue
                            else:
                                add("discrete", firstObj, attr1, firstObj.values[attr1], secondObj.values['sectionCount'],
                                    "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " has another value on right side (value: " + secondObj.values['sectionCount'] + ")\n")
                                continue
                    elif attr1=="sectionCount":
                        if ('currentSectionCount' in secondObj.values):
                            if (firstObj.values[attr1] == secondObj.values['currentSectionCount']):
                                continue
                            else:
                                add("discrete", firstObj, attr1, firstObj.values[attr1], secondObj.values['currentSectionCount'],
                                    "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " has another value on right side (value: " + secondObj.values['currentSectionCount'] + ")\n")
                                continue
                    add("attribute", firstObj, attr1, firstObj.values[attr1], None,
                        "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " is not in the equivalent object on right side\n")
                elif firstObj.type=='switch' and (attr1=="node1" or attr1=="node2" or attr1=="bus1" or attr1=="bus2"):
                    if ('node1' in firstObj.values and 'node2' in firstObj.values and 'node1' in secondObj.values and 'node2' in secondObj.values) \
                        and (firstObj.values['node1'] == secondObj.values['node2']) and (firstObj.values['node2'] == secondObj.values['node1']) :
                        continue
                    if ('bus1' in firstObj.values and 'bus2' in firstObj.values and 'bus1' in secondObj.values and 'bus2' in secondObj.values) \
                        and (firstObj.values['bus1'] == secondObj.values['bus2']) and (firstObj.values['bus2'] == secondObj.values['bus1']) :
                        continue
                    else:
                        if (firstObj.values[attr1] != secondObj.values[attr1]):
                            if mixed_iidm_libraries:
                                if "switch" in firstObj.type and attr1=="open":
                                    #we ignore the open differences between the 2 differents libiidm as NODE_BREAKER topology is handled differently
                                    continue
                            add("discrete", firstObj, attr1, firstObj.values[attr1], secondObj.values[attr1],
                                "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " has another value on right side (value: " + secondObj.values[attr1] + ")\n")
                else:
                    try:
                        difference = abs(float(firstObj.values[attr1])- float(secondObj.values[attr1]))
                        rel_tol = settings.max_iidm_cmp_tol
                        for exception in settings.iidm_exceptions:
                            if exception in path_left or exception in path_right:
                                rel_tol = settings.iidm_exceptions[exception]
                                break
                        if not diffUtils.isclose(float(firstObj.values[attr1]), float(secondObj.values[attr1]), rel_tol, rel_tol/5):
                            add("numeric", firstObj, attr1, firstObj.values[attr1], secondObj.values[attr1], None, difference)
                        elif keep_within_tolerance and difference > 0:
                            add("numeric", firstObj, attr1, firstObj.values[attr1], secondObj.values[attr1], None, difference, True)
                    except ValueError:
                        if (firstObj.values[attr1] != secondObj.values[attr1]):
                            if mixed_iidm_libraries:
                                if "switch" in firstObj.type and attr1=="open":
                                    #we ignore the open differences between the 2 differents libiidm as NODE_BREAKER topology is handled differently
                                    continue
                            add("discrete", firstObj, attr1, firstObj.values[attr1], secondObj.values[attr1],
                                "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + firstObj.values[attr1] + " has another value on right side (value: " + secondObj.values[attr1] + ")\n")
            for attr1 in sorted(secondObj.values):
                if attr1 not in firstObj.values:
                    if attr1=="currentSectionCount":
                        if ('sectionCount' in firstObj.values):
                            if (secondObj.values[attr1] == firstObj.values['sectionCount']):
                                continue
                            else:
                                add("discrete", firstObj, attr1, firstObj.values['sectionCount'], secondObj.values[attr1],
                                    "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + secondObj.values[attr1] + " has another value on right side (value: " + firstObj.values['sectionCount'] + ")\n")
                                continue
                    elif attr1=="sectionCount":
                        if ('currentSectionCount' in firstObj.values):
                            if (secondObj.values[attr1] == firstObj.values['currentSectionCount']):
                                continue
                            else:
                                add("discrete", firstObj, attr1, firstObj.values['currentSectionCount'], secondObj.values[attr1],
                                    "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + secondObj.values[attr1] + " has another value on right side (value: " + firstObj.values['currentSectionCount'] + ")\n")
                                continue
                    add("attribute", firstObj, attr1, None, secondObj.values[attr1],
                        "[ERROR] attribute " + attr1 + " of object " + firstId + " (type " + firstObj.type +") value: " + secondObj.values[attr1] + " is not in the equivalent object on left side\n")
    return differences

# Check whether two output IIDM values files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def OutputIIDMCloseEnough (path_left, path_right):
    differences = compareOutputIIDM(path_left, path_right)
    nb_differences = len(differences)
    msg = "".join(difference["message"] for difference in differences if difference["message"] is not None)
    numeric_differences = [difference for difference in differences if difference["category"] == "numeric"]
    for error in sorted(numeric_differences, key=lambda difference: difference["delta"], reverse=True)[:settings.max_nb_iidm_outputs]:
        msg += "[ERROR] attribute " + error["attribute"] + " of object " + error["id"] + " (type " + error["type"] + ") has different values (delta = " + '{:15g}'.format(error["delta"]).lstrip() + ") \n"
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
