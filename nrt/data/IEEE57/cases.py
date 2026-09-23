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

import os

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"

##############################################################
#       IEEE57 - Step on the load connected at node 9        #
##############################################################

case_name = "IEEE57 - StepLoad"
case_description = "IEEE57 - Step on the load connected at node 9"
job_file = os.path.join(os.path.dirname(__file__), "IEEE57_BasicTestCases", "IEEE57_1_StepLoad", "IEEE57.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

############################################################################
#       IEEE57 - Disconnection of the generator connected to node 12       #
############################################################################

case_name = "IEEE57 - DisconnectGroup"
case_description = "IEEE57 - Disconnection of the generator connected to node 12"
job_file = os.path.join(os.path.dirname(__file__), "IEEE57_BasicTestCases", "IEEE57_2_DisconnectGroup", "IEEE57.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

############################################################################
#       IEEE57 - Disconnection of the line 6-8                             #
############################################################################

case_name = "IEEE57 - DisconnectLine"
case_description = "IEEE57 - Disconnection of the line 6-8"
job_file = os.path.join(os.path.dirname(__file__), "IEEE57_BasicTestCases", "IEEE57_3_DisconnectLine", "IEEE57.jobs")

test_cases.append((case_name, case_description, job_file, 2, standardReturnCodeType, standardReturnCode))

############################################################################
#               IEEE57 - Node fault on bus 45                           #
############################################################################

case_name = "IEEE57 - Node fault"
case_description = "IEEE57 - Node fault on bus 45"
job_file = os.path.join(os.path.dirname(__file__), "IEEE57_BasicTestCases", "IEEE57_4_NodeFault", "IEEE57.jobs")

test_cases.append((case_name, case_description, job_file, 2, standardReturnCodeType, standardReturnCode))
