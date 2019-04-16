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

import os.path
try:
    import lxml.etree
except:
    print("Error when trying to import lxml.etree")
    sys.exit(1)
from optparse import OptionParser

NAMESPACE = "http://www.rte-france.com/dynawo"

def namespace(tag):
    return "{" + NAMESPACE + "}" + tag


def main():
    usage=u""" Usage: %prog <preassembled-model>

    Script checking if the preassembled-model fils is well built.
    Some implicit rules must be verify before launching the built of the
    preassembled model

    Return an error if theses rules are not verified
    """

    parser = OptionParser(usage)
    (options, args) = parser.parse_args()

    if len(args) != 1:
        parser.error("Incorrect args number")
        exit(1)

    preassembled_model_file = args[0]

    preassembled_model_root = lxml.etree.parse(preassembled_model_file).getroot()

    preassembled_model_id = ""
    for modelica_model in preassembled_model_root.iter(namespace("modelicaModel")):
        preassembled_model_id = modelica_model.get("id")

    list_words=preassembled_model_file.split("/")
    name_file = list_words[len(list_words)-1]
    name_file = name_file.replace(".xml","")

    if name_file != preassembled_model_id:
        print ('ERROR : '+str(preassembled_model_file)+' is not well build')
        print ('         file name and preassembled model id must be equal')
        print ('         file name ='+str(name_file))
        print ('         preassembled model id ='+str(preassembled_model_id))
        exit(1)

if __name__ == "__main__":
    main()
