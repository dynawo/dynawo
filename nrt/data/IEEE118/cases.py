# -*- coding: utf-8 -*-

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

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"

###############################
#     IEEE118 - NodeFault     #
###############################

case_name = "IEEE118 - NodeFault"
case_description = "IEEE118 - Fault on node B19"
job_file = os.path.join(os.path.dirname(__file__), "IEEE118_BasicTestCases", "IEEE118_NodeFault", "IEEE118.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
