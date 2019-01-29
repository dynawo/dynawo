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

import os, sys,re, locale, codecs
import shutil
from optparse import OptionParser
from xml.dom.minidom import parse

##
# Copy file to tmp file
def defaultPreCompil():
    name = os.path.basename(fileName).replace('.mo', '-tmp.mo')
    dirname = os.path.dirname(fileName)
    fichierTmpName = ""
    if( dirname != ""):
        fichierTmpName = os.path.join (dirname, name)
    else:
        fichierTmpName = name
    shutil.copy (fileName, fichierTmpName)


##
# Extract external variables from an external variables file
# (for fictitious equations)
def listExternalVariables (externalVariablesFilePath):
    if (not os.path.isfile (externalVariablesFilePath)):
        print("Failed to extract external variables : missing file")
        sys.exit(1)

    listeVarExtContinuous = []
    listeVarExtDiscrete = []
    listeVarOptionalExtContinuous = []

    doc = parse (externalVariablesFilePath)
    for node in doc.getElementsByTagName("external_variables"):
        for variable in node.getElementsByTagName("variable"):
            defaultValue = "0"
            size = 1
            optional = False
            if ( variable.hasAttribute("defaultValue") ):
                defaultValue = variable.getAttribute("defaultValue")
            if ( variable.hasAttribute("size") ):
                size = int(variable.getAttribute("size"))
            if ( variable.hasAttribute("optional") ):
                optional = (variable.getAttribute("optional") == "true")

            if (variable.getAttribute("type") == "continuous"):
                listeVarExtContinuous.append((variable.getAttribute("id"), defaultValue))
            elif (variable.getAttribute("type") == "discrete"):
                listeVarExtDiscrete.append((variable.getAttribute("id"), defaultValue))
            elif (variable.getAttribute("type") == "continuousArray"):
              for i in range(1,size+1):
                if not optional:
                  listeVarExtContinuous.append((variable.getAttribute("id")+"["+str(i)+"]", defaultValue))
                else:
                  listeVarOptionalExtContinuous.append((variable.getAttribute("id")+"["+str(i)+"]", defaultValue))
            elif (variable.getAttribute("type") == "discreteArray"):
              for i in range(1,size+1):
                listeVarExtDiscrete.append((variable.getAttribute("id")+"["+str(i)+"]", defaultValue))

    return (listeVarExtContinuous, listeVarOptionalExtContinuous, listeVarExtDiscrete)

##
# Add fictious equation read in xml file
def preCompil():

    listeVarExtContinuous, listeVarOptionalExtContinuous, listeVarExtDiscrete = listExternalVariables (fileVarExtName)

    nomModele = os.path.basename(fileName).replace(".mo", "")
    # modification of the .mo file
    file = open(fileName, "r")
    lines = file.readlines()
    file.close()

    for il in lines:
        line = il.rstrip('\n\r\t') # delete end of line characters
        lineSave = ""

        if( line.find("end " + str(nomModele)) != -1):
            lineSave = il
            lines.remove(il)

            for var, defaultValue in listeVarExtContinuous:
                value = 'der(' + str(var) + ') =' + defaultValue + ';\n'
                lines.append(value)

            for var, defaultValue in listeVarOptionalExtContinuous:
                value = 'der(' + str(var) + ') =' + defaultValue + ';\n'
                lines.append(value)

            if len(listeVarExtDiscrete) > 0 :
                value = " when(time > 999999) then \n"
                lines.append(value)
                for (var, val) in listeVarExtDiscrete:
                    value = "    " + str(var) + ' = ' + val + ';\n'
                    lines.append(value)
                value = " end when;\n"
                lines.append(value)

            lines.append(lineSave)

            break

    name = os.path.basename(fileName).replace('.mo','-tmp.mo')
    dirname = os.path.dirname(fileName)
    fichierTmp = ""
    filePath = name
    if( dirname != ""):
        filePath = os.path.join(dirname, name)

    fichierTmp = open(filePath, 'w')

    for il in lines:
        fichierTmp.write(il)
    fichierTmp.close()

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

    global fileVarExtName
    global fileName

    fileVarExtName = options.fileVarExt
    fileName = options.file

    if( os.path.isfile(fileVarExtName) ):
        if( options.preCompil):
            preCompil()
    else:
        if( options.preCompil):
            defaultPreCompil()

if __name__ == "__main__":
    main()
