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

#####################################
#     IEEE 14 - Disconnect Line     #
#####################################

case_name = "IEEE14_DisconnectLine"
case_description = "IEEE 14 test case with a line disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "SteadyStateSimulator", "IEEE14", "IEEE14_BasicTestCases", "IEEE14_DisconnectLine", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##############################################
#  Small System with an HVDC link and a CLA  #
##############################################

case_name = "HVDC_CLA"
case_description = "Small System with an HVDC link and a CLA"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "SteadyStateSimulator", "IllustrativeExamples", "HVDC_CLA", "HVDC_CLA.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################################
#  Small System with an HVDC link and a Phase Shifter  #
########################################################

case_name = "HVDC_PhaseShifter"
case_description = "Small System with an HVDC link and a Phase Shifter"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "SteadyStateSimulator", "IllustrativeExamples", "HVDC_PhaseShifter", "HVDC_PhaseShifter.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##########################################
#  Small System with a Load Restoration  #
##########################################

case_name = "LoadRestoration"
case_description = "Small System with a Load Restoration"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "SteadyStateSimulator", "IllustrativeExamples", "LoadRestoration", "LoadRestoration.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##########################################
#  Small System with two Phase Shifters  #
##########################################

case_name = "PhaseShifters"
case_description = "Small System with two Phase Shifters"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "SteadyStateSimulator", "IllustrativeExamples", "PhaseShifters", "PhaseShifters.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
