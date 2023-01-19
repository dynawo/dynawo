# -*- coding: utf-8 -*-

# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import os

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"
forbiddenReturnCodeType = "FORBIDDEN"

#################################################
#     IEEE14 - Generator disconnections         #
#################################################
case_name = "DynaWaltz - IEEE14 - Generator disconnections"
case_description = "IEEE14 - Generator disconnections"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "IEEE14", "IEEE14_GeneratorDisconnections", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

####################################################################
#     IEEE14 - Cascading line tripping                             #
####################################################################

case_name = "DynaWaltz - IEEE14 - Cascading line tripping"
case_description = "IEEE14 - Cascading line tripping"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "IEEE14", "IEEE14_CascadingLineTrippings", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

####################################################################
#     IEEE57 - Generator disconnection                             #
####################################################################

case_name = "DynaWaltz - IEEE57 - Generator disconnection"
case_description = "IEEE57 - Generator disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "IEEE57", "IEEE57_GeneratorDisconnection", "IEEE57.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################
#     CLA with two levels     #
###############################

case_name = "DynaWaltz - CLA with two levels"
case_description = "Simple case to test the CLA with two levels"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "nrt", "data", "DynaWaltz", "CLATwoLevels", "CLATwoLevels.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
