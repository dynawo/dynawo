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

'''
takes contents of delimited file and transposes columns and rows
outputs to txt file
'''
import sys

try:
    import argparse
except:
    print("argparse module missing. Please run yum install python-argparse")
    sys.exit(1)

def transpose(i, o=None, d=','):
    f = open (i, 'r')
    file_contents = f.readlines ()
    f.close ()

    out_data = map((lambda x: d.join([y for y in x])),
                   zip(* [x.strip().split(d) for x in file_contents if x]))
    if o:
        f = open (o,'w')

        # here we map a lambda, that joins the first element of a column, the
        # header, to the rest of the members joined by a comma and a space.
        # the lambda is mapped against a zipped comprehension on the
        # original lines of the csv file. This groups members vertically
        # down the columns into rows.
        f.write ('\n'.join (out_data))
        f.close ()

    return out_data
