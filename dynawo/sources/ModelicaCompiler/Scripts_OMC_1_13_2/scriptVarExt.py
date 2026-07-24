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
from xml.dom.minidom import parse

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

    doc = parse (external_variables_file_path)
    for node in doc.getElementsByTagName("external_variables"):
        for variable in node.getElementsByTagName("variable"):
            default_value = "0"
            default_value_bool = "true"
            size = 1
            optional = False
            if ( variable.hasAttribute("defaultValue") ):
                default_value = variable.getAttribute("defaultValue")
            if ( variable.hasAttribute("size") ):
                size = int(variable.getAttribute("size"))
            if ( variable.hasAttribute("optional") ):
                optional = (variable.getAttribute("optional") == "true")

            if (variable.getAttribute("type") == "continuous"):
                if not optional:
                    liste_var_ext_continuous.append((variable.getAttribute("id"), default_value))
                else:
                    liste_var_optional_ext_continuous.append((variable.getAttribute("id"), default_value))
            elif (variable.getAttribute("type") == "discrete"):
                liste_var_ext_discrete.append((variable.getAttribute("id"), default_value))
            elif (variable.getAttribute("type") == "boolean"):
                liste_var_ext_boolean.append((variable.getAttribute("id"), default_value_bool))
            elif (variable.getAttribute("type") == "continuousArray"):
              for i in range(1,size+1):
                if not optional:
                  liste_var_ext_continuous.append((variable.getAttribute("id")+"["+str(i)+"]", default_value))
                else:
                  liste_var_optional_ext_continuous.append((variable.getAttribute("id")+"["+str(i)+"]", default_value))
            elif (variable.getAttribute("type") == "discreteArray"):
              for i in range(1,size+1):
                liste_var_ext_discrete.append((variable.getAttribute("id")+"["+str(i)+"]", default_value))

    return (liste_var_ext_continuous, liste_var_optional_ext_continuous, liste_var_ext_discrete, liste_var_ext_boolean)

##
# A voltage's real/imaginary parts (*.V.re / *.V.im) and the corresponding current's
# real/imaginary parts (*.i.re / *.i.im) form an inseparable complex pair: whenever one of the
# four is passed to the dummy functions, its counterparts for the same prefix must be passed
# too, even if they are not themselves external variables needing their own closing equation.
# @param var_names : base list of external variable names
# @return var_names extended with any missing V.re/V.im/i.re/i.im counterpart
def extend_with_vi_pairs(var_names):
    suffixes = (".V.re", ".V.im", ".i.re", ".i.im")
    extended = list(var_names)
    existing = set(var_names)
    for name in var_names:
        matching_suffix = next((s for s in suffixes if name.endswith(s)), None)
        if matching_suffix is None:
            continue
        prefix = name[:-len(matching_suffix)]
        counterparts = (".V.re", ".V.im") if matching_suffix in (".i.re", ".i.im") else (".i.re", ".i.im")
        for suffix in counterparts:
            candidate = prefix + suffix
            if candidate not in existing:
                extended.append(candidate)
                existing.add(candidate)
    return extended

##
# Build, for each continuous external variable, an opaque "dummy" function taking every
# continuous external variable as input (so none of them can be simplified away in isolation
# by OMC), plus their V/i complex counterparts (see extend_with_vi_pairs), and the corresponding
# "der(var) = dummyN(...)" equation, instead of a plain der(var) = 0. The der(...) on the left
# keeps the variable classified as a genuine differential state (with its own derivative slot,
# needed by any other equation that references der(var) directly), while the opaque right-hand
# side keeps OMC from treating that derivative as trivially constant/removable. The dummy calls
# themselves carry no meaning and are filtered out of the generated dynamic model afterwards
# (see factory.py).
# @param liste_var_ext : list of (variable name, default value) tuples for every continuous
#                         external variable (mandatory and optional combined)
# @return (list of function definition lines, list of equation lines)
def build_dummy_equations(liste_var_ext):
    var_names = [var for var, _ in liste_var_ext]
    arg_names = extend_with_vi_pairs(var_names)
    nb_args = len(arg_names)
    functions_lines = []
    equations_lines = []
    for i in range(1, len(var_names) + 1):
        functions_lines.append("function dummy" + str(i) + "\n")
        for j in range(1, nb_args + 1):
            functions_lines.append("  input Real u" + str(j) + ";\n")
        functions_lines.append("  output Real y;\n")
        functions_lines.append("algorithm // doesn't really matter, the function call will eventually be removed from the generated code\n")
        functions_lines.append("  y := " + " + ".join("u" + str(j) for j in range(1, nb_args + 1)) + ";\n")
        functions_lines.append("annotation(Evaluate = false);\n")
        functions_lines.append("end dummy" + str(i) + ";\n\n")

        equations_lines.append("der(" + var_names[i - 1] + ") = dummy" + str(i) + "(" + ", ".join(arg_names) + ");\n")
    return functions_lines, equations_lines

##
# Add fictitious equation read in xml file
def pre_compil():

    liste_var_ext_continuous, liste_var_optional_ext_continuous, liste_var_ext_discrete, liste_var_ext_boolean = list_external_variables (file_var_ext_name)

    model_name = os.path.basename(file_name).replace(".mo", "")
    # modification of the .mo file
    f = open(file_name, "r")
    lines = f.readlines()
    f.close()

    # Temporary A/B test switch (2026-07-24): USE_DUMMY_EXTERNAL_VARS toggles between the new
    # opaque-dummy-function mechanism and the old plain der(var)=0, to check whether the dummy
    # mechanism is responsible for the IEEE14 IDA divergence regression. Revert to True once
    # confirmed either way.
    USE_DUMMY_EXTERNAL_VARS = True
    if USE_DUMMY_EXTERNAL_VARS:
        functions_lines, equations_lines = build_dummy_equations(liste_var_ext_continuous + liste_var_optional_ext_continuous)
        lines = functions_lines + lines
    else:
        equations_lines = []
        for var, default_value in liste_var_ext_continuous:
            equations_lines.append('der(' + str(var) + ') =' + default_value + ';\n')
        for var, default_value in liste_var_optional_ext_continuous:
            equations_lines.append('der(' + str(var) + ') =' + default_value + ';\n')

    for il in lines:
        line = il.rstrip('\n\r\t') # delete end of line characters
        line_save = ""

        if( line.find("end " + str(model_name)) != -1):
            line_save = il
            lines.remove(il)

            lines.extend(equations_lines)

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
