# -*- coding: utf-8 -*-

# Copyright (c) 2025, RTE (http://www.rte-france.com)
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
import csv
import os

usage=u""" Usage: %prog --repertory=<directory>"""
parser = OptionParser(usage)
parser.add_option('--repertory', dest='repertory', type=str, help='path to the working directory -- absolute path')

(options, args) = parser.parse_args()

if not os.path.exists(options.repertory):
   raise ValueError("directory "+options.repertory + " does not exist")

input_file = csv.reader(open(os.path.join(options.repertory,"file_in.csv")),delimiter=';')
dataEntry = {}
for row in input_file:
   print(row)
   if len(row) == 3:
      dataEntry[row[0],row[1]] = row[2]
   else:
      dataEntry[row[0],'t'] = row[1]

for (name,type) in dataEntry:
   if name == 'time' :
      time= dataEntry[name,type]

output = open(os.path.join(options.repertory,"file_out.csv"), 'w')
for (name,type) in dataEntry:
   print(name)
   print(type)
   if type == 'S' and name == '_BUS___10-BUS___11-1_AC':
      value = dataEntry[name,type]
      if float(time) > 5:
         value = 1
      output.write(name+';'+type+';'+str(value)+'\n')

output.close()
