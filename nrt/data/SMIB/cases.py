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

import os

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"
forbiddenReturnCodeType = "FORBIDDEN"

########################################
#           SMIB_1_StepPm              #
########################################

case_name = "SMIB - StepPm"
case_description = "SMIB test case with a step on the mechanical power"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_BasicTestCases", "SMIB_1_StepPm", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

########################################
#           SMIB_1_StepPm_IIDM         #
########################################

case_name = "SMIB - StepPm IIDM"
case_description = "SMIB test case with a step on the mechanical power and an iidm network"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_BasicTestCases", "SMIB_1_StepPm_IIDM", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))


########################################
#           SMIB_2_StepEfd             #
########################################

case_name = "SMIB - StepEfd"
case_description = "SMIB test case with a step on the excitation voltage"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_BasicTestCases", "SMIB_2_StepEfd", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

########################################
#           SMIB_3_LoadVarQ            #
########################################

case_name = "SMIB - LoadVarQ"
case_description = "SMIB test case with a step on the load reactive power"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_BasicTestCases", "SMIB_3_LoadVarQ", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

########################################
#           SMIB_4_DisconnectLine      #
########################################

case_name = "SMIB - DisconnectLine"
case_description = "SMIB test case with a line disconnection"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_BasicTestCases", "SMIB_4_DisconnectLine", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

########################################
#           SMIB_5_Fault               #
########################################

case_name = "SMIB - Fault"
case_description = "SMIB test case with a fault"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_BasicTestCases", "SMIB_5_Fault", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

###############################################
#           SMIB Test Case 1 ST4B             #
###############################################

case_name = "SMIB - Test Case 1 ST4B"
case_description = "Voltage reference step on the synchronous machine (and its regulations) connected to a zero current bus"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "nrt", "data", "SMIB", "Standard", "TestCase1ST4B", "TestCase1ST4B.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

###############################################
#           SMIB Test Case 2 ST4B             #
###############################################

case_name = "SMIB - Test Case 2 ST4B"
case_description = "Active power variation on the load"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "nrt", "data", "SMIB", "Standard", "TestCase2ST4B", "TestCase2ST4B.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

###############################################
#           SMIB Test Case 3 ST4B             #
###############################################

case_name = "SMIB - Test Case 3 ST4B"
case_description = "Bolted three-phase short circuit at the high-level side of the transformer"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "nrt", "data", "SMIB", "Standard", "TestCase3ST4B", "TestCase3ST4B.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
