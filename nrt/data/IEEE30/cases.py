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

##################################
#       IEEE30 - NodeFault       #
##################################

case_name = "IEEE30 - NodeFault"
case_description = "IEEE30 - Fault on node B2"
job_file = os.path.join(os.path.dirname(__file__), "IEEE30_BasicTestCases", "IEEE30_NodeFault", "IEEE30.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#       IEEE30 - DisconnectGroup       #
########################################

case_name = "IEEE30 - DisconnectGroup"
case_description = "IEEE30 - Disconnection of generator G1 at node B2"
job_file = os.path.join(os.path.dirname(__file__), "IEEE30_BasicTestCases", "IEEE30_DisconnectGroup", "IEEE30.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#######################################
#       IEEE30 - DisconnectLine       #
#######################################

case_name = "IEEE30 - DisconnectLine"
case_description = "IEEE30 - Disconnection of line L-2-5-1"
job_file = os.path.join(os.path.dirname(__file__), "IEEE30_BasicTestCases", "IEEE30_DisconnectLine", "IEEE30.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
