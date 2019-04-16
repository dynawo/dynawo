#!/usr/bin/python

# -*- coding: utf-8;

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

import os
try:
    import lxml.etree
except:
    print("Error when trying to import lxml.etree")
    sys.exit(1)
from optparse import OptionParser

NAMESPACE = "http://www.rte-france.com/dynawo"

def namespace(tag):
    return "{" + NAMESPACE + "}" + tag

def list_mo_files_used(preassembled_model_file):
    files = []

    preassembled_model_root = lxml.etree.parse(preassembled_model_file).getroot()

    for udm in preassembled_model_root.iter(namespace("unitDynamicModel")):
        mo_file = udm.get("moFile")
        if mo_file and not mo_file in files:
            files.append(mo_file)
        xml_file = os.path.splitext(mo_file)[0]+".xml"
        if xml_file and not xml_file in files:
            files.append(xml_file)
        init_file = udm.get("initFile")
        if init_file and not init_file in files:
            files.append(init_file)

    files.sort()
    return files

def generate_dep(mo_files, mo_files_dir):
    dep_file = []

    for mo_file in mo_files:
        for root, dirs, files in os.walk( mo_files_dir):
            if mo_file in files:
                abs_path = os.path.join(root, mo_file)
                file_content = open(abs_path,'r').readlines()
                for line in file_content:
                    dep_file.append(line.rstrip('\r\n') + "\n")

    return dep_file

def main():
    usage=u""" Usage: %prog <preassembled-model> <model-dep>

    Script checking dependencies validity of a preassembled
    model. A preassembled model must be recompiled when the
    XML file has changed OR when one of the mo files used inside
    has changed.

    This script create a dep file that regroup the content of
    the mo files used. If it has changed from previous one, change
    it and so implies re compilation of the preassembled model.
    """
    parser = OptionParser(usage)
    (options, args) = parser.parse_args()

    if len(args) != 2:
        parser.error("Incorrect args number")
        return -1

    preassembled_model_file = args[0]
    model_dep_file = args[1]

    mo_files = list_mo_files_used(preassembled_model_file)
    mo_files_dir = os.path.dirname(preassembled_model_file)+"/.."
    new_dep = generate_dep(mo_files, mo_files_dir)

    old_dep = []
    if os.path.isfile(model_dep_file):
        old_dep = open(model_dep_file,'r').readlines()

    difference = True
    for line_new, line_old in zip(new_dep,old_dep):
        if line_new != line_old and difference:
            difference=False

    if new_dep != old_dep:
        new_dep_file = open(model_dep_file,'w')
        for line in new_dep:
            new_dep_file.write(line)

if __name__ == "__main__":
    main()
