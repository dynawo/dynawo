# -*- coding: utf-8 -*-

# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.

from optparse import OptionParser
import os
import sys
import platform
from subprocess import Popen, PIPE

options = {}
options[('-m', '--model')] = {'dest': 'modName',
                               'help': 'Designate the model name'}

def exist_file(file_name):
    if not os.path.isfile(file_name) :
        print ("Error : %s does not exist" % file_name)
        sys.exit(1)

def get_checksum(path):
    current_platform = platform.system()
    if current_platform == 'Linux':
        md5sum_pipe = Popen(["md5sum",path],stdout = PIPE)
        check_sum = md5sum_pipe.communicate()[0].split()[0].decode("utf-8")
    elif current_platform == 'Windows':
        md5sum_pipe = Popen(["certutil", "-hashfile", path, "MD5"], stdin = PIPE, stdout = PIPE)
        check_sum = md5sum_pipe.communicate()[0].split(os.linesep.encode())[1]
    return check_sum

if __name__ =='__main__':
    modName=""

    opt_parser = OptionParser()
    for param,option in options.items():
        opt_parser.add_option(*param, **option)
    options, args = opt_parser.parse_args()

    if not options.modName :
        opt_parser.error('Model name is not given')

    modName = options.modName

    file_name_cpp = str(modName)+'.cpp'
    file_name_h = str(modName)+'.h'
    file_name_hpp_in = str(modName)+'.hpp.in'
    file_name_hpp = str(modName)+'.hpp'

    # Test if original files exist
    exist_file(file_name_cpp)
    exist_file(file_name_h)
    exist_file(file_name_hpp_in)

    # create absolute path
    path_cpp = os.path.abspath(file_name_cpp)
    path_h =  os.path.abspath(file_name_h)
    path_hpp_in = os.path.abspath(file_name_hpp_in)
    path_hpp = path_hpp_in.replace('.hpp.in','.hpp')

    # create checkSum wich is the combination of cpp file's checkSum and h file's checkSum
    ckSum1 = get_checksum(path_cpp)
    ckSum2 = get_checksum(path_h)
    ckSum = str(ckSum1)+'-'+str(ckSum2)

    doIt = True
    if os.path.isfile(path_hpp) :
        f = open(path_hpp, 'r')
        lines=[]
        for line in f:
            if '"'+str(ckSum)+'"' in line:
                doIt =False
                break
        f.close()
        if not doIt:
            print ("File " + file_name_hpp + " already exist. It will not be regenerated.")

    if doIt:
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
            print ("Error : %s is not well-formatted, '_CHECKSUM_' is not in file" % file_name_hpp_in)
            sys.exit(1)

        # write new file
        f = open(path_hpp,'w')
        for line in lines:
            f.write(line)
        f.close()
