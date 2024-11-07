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

###############################################################
#             SMIB with GoverNordic and VRNordic              #
###############################################################

case_name = "SMIB - Fault - GoverNordic - VRNordic"
case_description = "SMIB test case with a fault using GoverNordic and VRNordic regulations"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_Nordic", "SMIB_GoverNordicVRNordic", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#      SMIB with constant mechanical power and VRNordic       #
###############################################################

case_name = "SMIB - Fault - PmConst - VRNordic"
case_description = "SMIB test case with a fault using VRNordic regulation"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_Nordic", "SMIB_PmConstVRNordic", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#         SMIB with no mechanical power and VRNordic          #
###############################################################

case_name = "SMIB - Fault - PmConst - VRNordic - SynchronousCondenser"
case_description = "SMIB test case with a fault using VRNordic regulation, for a synchronous condenser"
job_file = os.path.join(os.path.dirname(__file__), "SMIB_Nordic", "SMIB_SynchronousCondenser", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, Ac6a and Pss3b     #
###############################################################

case_name = "SMIB - Fault - PmConst - Ac6a - Pss3b"
case_description = "SMIB test case with a fault using Ac6a and Pss3b regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstAc6aPss3b", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, Ac7b and Pss3b     #
###############################################################

case_name = "SMIB - Fault - PmConst - Ac7b - Pss3b"
case_description = "SMIB test case with a fault using Ac7b and Pss3b regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstAc7bPss3b", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, Ac7c and Pss2c     #
###############################################################

case_name = "SMIB - Fault - PmConst - Ac7c - Pss2c"
case_description = "SMIB test case with a fault using Ac7c and Pss2c regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstAc7cPss2c", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#         SMIB with constant mechanical power and Ac8b        #
###############################################################

case_name = "SMIB - Fault - PmConst - Ac8b"
case_description = "SMIB test case with a fault using Ac8b regulation"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstAc8b", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, Ac8b and Pss3b     #
###############################################################

case_name = "SMIB - Fault - PmConst - Ac8b - Pss3b"
case_description = "SMIB test case with a fault using Ac8b and Pss3b regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstAc8bPss3b", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, St5b and Pss2b     #
###############################################################

case_name = "SMIB - Fault - PmConst - St5b - Pss2b"
case_description = "SMIB test case with a fault using St5b and Pss2b regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstSt5bPss2b", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, St6b and Pss3b     #
###############################################################

case_name = "SMIB - Fault - PmConst - St6b - Pss3b"
case_description = "SMIB test case with a fault using St6b and Pss3b regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstSt6bPss3b", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, St6c and Pss6c     #
###############################################################

case_name = "SMIB - Fault - PmConst - St6c - Pss6c"
case_description = "SMIB test case with a fault using St6c and Pss6c regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstSt6cPss6c", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, St7b and Pss2a     #
###############################################################

case_name = "SMIB - Fault - PmConst - St7b - Pss2a"
case_description = "SMIB test case with a fault using St7b and Pss2a regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstSt7bPss2a", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#     SMIB with constant mechanical power, St9c and Pss2c     #
###############################################################

case_name = "SMIB - Fault - PmConst - St9c - Pss2c"
case_description = "SMIB test case with a fault using St9c and Pss2c regulations"
job_file = os.path.join(os.path.dirname(__file__), "IEEE", "PmConstSt9cPss2c", "SMIB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################################
#             SMIB with GovCt2 and St4b                       #
###############################################################

case_name = "SMIB - TestCase - GovCt2 - St4b"
case_description = "Active power variation on the load"
job_file = os.path.join(os.path.dirname(__file__), "Standard", "TestCaseGovCt2St4b", "TestCaseGovCt2St4b.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
