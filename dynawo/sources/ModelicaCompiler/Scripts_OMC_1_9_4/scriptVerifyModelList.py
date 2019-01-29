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
from lxml import etree

DYN_NAMESPACE = "http://www.rte-france.com/dynawo"
##
# Define tag with namespace
# @param tag : input tag
# @return tag with namespace
def namespaceDYD(tag):
    return "{" + DYN_NAMESPACE + "}" + tag

##
# Script to verify a model list file
def main():
    usage="""

    Script to verify a model list file

    """
    parser = OptionParser(usage)
    parser.add_option( '--dyd',     dest = "dydFileName",     default="",    metavar="<dydFileName>",
                       help="dydFileName")
    parser.add_option( '--model', dest = "modelListfile", default="",    metavar="<modelListfile>",
                       help="modelListfile")

    (options, args) = parser.parse_args()

    global dydFileName
    global modelListfile

    dydFileName = options.dydFileName
    modelListfile = options.modelListfile

    print (dydFileName, modelListfile)
    if( os.path.isfile(options.modelListfile) ):
      dyd = open(dydFileName,"w")
      modellist = open(modelListfile,"r")
    else:
      print ("Error: modelListfile not valid.")
      return

    root = etree.parse(modellist).getroot()
#    for udm in root.iter(namespaceDYD("unitDynamicModel")):
#        if not udm.attrib.get("parFile"):
#            udm.attrib["parFile"] = "-1"
#        if not udm.attrib.get("parId"):
#            udm.attrib["parId"] = "-1"
    output_tree = etree.ElementTree(root)
    output_tree.write(dyd, encoding = 'UTF-8', pretty_print = True, xml_declaration=True)

    modellist.close()
    dyd.close()

    print ("Verified Model List File: "+ dydFileName)


if __name__ == "__main__":
    main()














