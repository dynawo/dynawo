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

from optparse import OptionParser
import os
import sys
from subprocess import Popen, PIPE

options = {}
options[('-m', '--model')] = {'dest': 'modName',
                               'help': 'Designate the model name'}

def existFile(fileName):
    if not os.path.isfile(fileName) :
        print ("Error : %s does not exist" % fileName)
        sys.exit(1)

def getCheckSum(path):
    md5sum_pipe = Popen(["md5sum",path],stdout = PIPE)
    checkSum = md5sum_pipe.communicate()[0].split()[0]
    return checkSum

if __name__ =='__main__':
    modName=""

    opt_parser = OptionParser()
    for param,option in options.items():
        opt_parser.add_option(*param, **option)
    options, args = opt_parser.parse_args()

    if not options.modName :
        opt_parser.error('Model name is not given')

    modName = options.modName

    fileName_cpp = str(modName)+'.cpp'
    fileName_h = str(modName)+'.h'
    fileName_hpp_in = str(modName)+'.hpp.in'
    fileName_hpp = str(modName)+'.hpp'

    # Test if original files exist
    existFile(fileName_cpp)
    existFile(fileName_h)
    existFile(fileName_hpp_in)

    # create absolute path
    path_cpp = os.path.abspath(fileName_cpp)
    path_h =  os.path.abspath(fileName_h)
    path_hpp_in = os.path.abspath(fileName_hpp_in)
    path_hpp = path_hpp_in.replace('.hpp.in','.hpp')

    # create checkSum wich is the combination of cpp file's checkSum and h file's checkSum
    ckSum1 = getCheckSum(path_cpp)
    ckSum2 = getCheckSum(path_h)
    ckSum = str(ckSum1)+'-'+str(ckSum2)

    # read hpp.in file and replace _CHECKSUM_ by new ckSum in hpp file
    # _CHECKSUM_ must be read !
    f = open(path_hpp_in, 'r')
    lines=[]
    found = False
    for line in f:
        if '_CHECKSUM_' in line:
            line = line.replace('_CHECKSUM_','"'+str(ckSum)+'"')
            found =True
        lines.append(line)

    f.close()

    if not found:
        print ("Error : %s is not well-formatted, '_CHECKSUM_' is not in file" % fileName_hpp_in)
        sys.exit(1)

    # write new file
    f = open(path_hpp,'w')
    for line in lines:
        f.write(line)
    f.close()
