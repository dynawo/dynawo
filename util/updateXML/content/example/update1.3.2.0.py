# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.


import os
import sys

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)

from Ticket import ticket

@ticket(930)
def update(jobs):
    omegarefs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "DYNModelOmegaRef")
    for omegaref in omegarefs:
        omegaref.set_lib_name("DYNModelOmegaRef_NAME_CHANGED")
