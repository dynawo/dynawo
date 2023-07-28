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

import os, sys
import shutil
from optparse import OptionParser
import lxml.etree

from modelicaScriptsExceptions import UnknownExtVar

##
# Copy file to tmp file
def default_pre_compil():
    name = os.path.basename(file_name).replace('.mo', '-tmp.mo')
    dirname = os.path.dirname(file_name)
    tmp_file_name = ""
    if( dirname != ""):
        tmp_file_name = os.path.join (dirname, name)
    else:
        tmp_file_name = name
    shutil.copy (file_name, tmp_file_name)


##
# Extract external variables from an external variables file
# (for fictitious equations)
def list_external_variables (external_variables_file_path):
    if (not os.path.isfile (external_variables_file_path)):
        print("Failed to extract external variables : missing file")
        sys.exit(1)

    liste_var_ext_continuous = []
    liste_var_ext_discrete = []
    liste_var_optional_ext_continuous = []
    liste_var_ext_boolean = []

    xml_tree = lxml.etree.parse(external_variables_file_path)
    root_element = xml_tree.getroot()

    xmlns = "{http://www.rte-france.com/dynawo}"
    if root_element.tag != (xmlns + "external_variables"):
        raise UnknownExtVar(root_element.tag)

    for elem in root_element:
        if elem.tag == (xmlns + "variable"):
            default_value = "0"
            default_value_bool = "true"
            size = 1
            optional = False
            if "defaultValue" in elem.attrib:
                default_value = elem.attrib["defaultValue"]
            if "size" in elem.attrib:
                size = int(elem.attrib["size"])
            if "optional" in elem.attrib:
                optional = (elem.attrib["optional"] == "true")

            if elem.attrib["type"] == "continuous":
                if not optional:
                    liste_var_ext_continuous.append((elem.attrib["id"], default_value))
                else:
                    liste_var_optional_ext_continuous.append((elem.attrib["id"], default_value))
            elif elem.attrib["type"] == "discrete":
                liste_var_ext_discrete.append((elem.attrib["id"], default_value))
            elif elem.attrib["type"] == "boolean":
                liste_var_ext_boolean.append((elem.attrib["id"], default_value_bool))
            elif elem.attrib["type"] == "continuousArray":
                for i in range(1, size + 1):
                    if not optional:
                        liste_var_ext_continuous.append((elem.attrib["id"] + "[" + str(i) + "]", default_value))
                    else:
                        liste_var_optional_ext_continuous.append((elem.attrib["id"] + "[" + str(i) + "]", default_value))
            elif elem.attrib["type"] == "discreteArray":
                for i in range(1, size + 1):
                    liste_var_ext_discrete.append((elem.attrib["id"] + "[" + str(i) + "]", default_value))
        else:
            raise UnknownExtVar(elem.tag)

    return (liste_var_ext_continuous, liste_var_optional_ext_continuous, liste_var_ext_discrete, liste_var_ext_boolean)

##
# Add fictitious equation read in xml file
def pre_compil():

    liste_var_ext_continuous, liste_var_optional_ext_continuous, liste_var_ext_discrete, liste_var_ext_boolean = list_external_variables(file_var_ext_name)

    model_name = os.path.basename(file_name).replace(".mo", "")
    # modification of the .mo file
    f = open(file_name, "r")
    lines = f.readlines()
    f.close()

    for il in lines:
        line = il.rstrip('\n\r\t') # delete end of line characters
        line_save = ""

        if( line.find("end " + str(model_name)) != -1):
            line_save = il
            lines.remove(il)

            for var, default_value in liste_var_ext_continuous:
                value = 'der(' + str(var) + ') =' + default_value + ';\n'
                lines.append(value)

            for var, default_value in liste_var_optional_ext_continuous:
                value = 'der(' + str(var) + ') =' + default_value + ';\n'
                lines.append(value)

            if len(liste_var_ext_discrete) > 0 or len(liste_var_ext_boolean) > 0:
                value = " when(time > 999999) then \n"
                lines.append(value)
                for (var, val) in liste_var_ext_discrete:
                    value = "    " + str(var) + ' = ' + val + ';\n'
                    lines.append(value)
                for (var, val) in liste_var_ext_boolean:
                    value = "    " + str(var) + ' = ' + val + ';\n'
                    lines.append(value)
                value = " end when;\n"
                lines.append(value)

            lines.append(line_save)

            break

    name = os.path.basename(file_name).replace('.mo','-tmp.mo')
    dirname = os.path.dirname(file_name)
    tmp_file = ""
    file_path = name
    if( dirname != ""):
        file_path = os.path.join(dirname, name)

    tmp_file = open(file_path, 'w')

    for il in lines:
        tmp_file.write(il)
    tmp_file.close()

##
# Script adding fictitious equations in file thanks to description made in xml file
def main():

    usage=""" Usage: %prog [options]


    Script to make the variables listed in the .conf file fictitious

    """

     # In/out files
    parser = OptionParser(usage)
    parser.add_option( '--file',     dest = "file",     default="",    metavar="<file>",
                       help="file")
    parser.add_option( '--fileVarExt', dest = "fileVarExt", default="",    metavar="<fileVarExt>",
                       help="fichierVarExt")
    parser.add_option( '--pre', action="store_true", dest="preCompil",
                       help="Launch script precompilation mode")

    (options, args) = parser.parse_args()

    global file_var_ext_name
    global file_name

    file_var_ext_name = options.fileVarExt
    file_name = options.file

    if( os.path.isfile(file_var_ext_name) ):
        if( options.preCompil):
            pre_compil()
    else:
        if( options.preCompil):
            default_pre_compil()

if __name__ == "__main__":
    main()
