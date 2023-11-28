# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.


import os
import sys

parent_dir = os.path.abspath(os.path.dirname(__file__))
sys.path.append(parent_dir)
from sources.utils.Common import *


def ticket(num_ticket):
    options = get_command_line_options()
    if not options.update_nrt:
        print("Apply ticket " + str(num_ticket))
    if options.log:
        dynawo_version_str = str(options.version)
        outputs_path = os.path.abspath(options.outputs_path)
        if options.update_nrt:
            outputs_dir_path = outputs_path
        else:
            outputs_dir_name = "outputs" + dynawo_version_str
            outputs_dir_path = os.path.join(outputs_path, outputs_dir_name)
        pid = os.getpid()
        log_filename = "applied_tickets.log." + str(pid)
        log_filepath = os.path.join(outputs_dir_path, log_filename)
        if not os.path.exists(outputs_dir_path):
            os.makedirs(outputs_dir_path)
        with open(log_filepath, 'a') as fichier:
            print(str(num_ticket), file=fichier)
    def new_function(func):
        return func
    return new_function
