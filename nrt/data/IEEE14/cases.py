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

#########################################
#      IEEE14 - Modelica models         #
#########################################

case_name = "IEEE14 - Modelica models"
case_description = "IEEE14 - Modelica models"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_ModelicaModel", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Template models         #
#########################################

case_name = "IEEE14 - Template models"
case_description = "IEEE14 - Template models"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_TemplateModels", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Black box models        #
#########################################

case_name = "IEEE14 - Black box models"
case_description = "IEEE14 - Black box models"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_BlackBoxModels", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - FSV without CRV         #
#########################################

case_name = "IEEE14 - FSV without CRV"
case_description = "IEEE14 - FSV without CRV"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_FSVWithoutCRV", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 -IterationAndTimeSteps    #
#########################################

case_name = "IEEE14 - IterationAndTimeSteps"
case_description = "IEEE14 - IterationAndTimeSteps"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_IterationAndTimeSteps", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - MacroConnects           #
#########################################

case_name = "IEEE14 - MacroConnects"
case_description = "IEEE14 - MacroConnects"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_MacroConnects", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - MacroStaticRefs         #
#########################################

case_name = "IEEE14 - MacroStaticRefs"
case_description = "IEEE14 - MacroStaticRefs"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_MacroStaticRefs", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - MacroParameterSet         #
#########################################

case_name = "IEEE14 - MacroParameterSet"
case_description = "IEEE14 - MacroParameterSet"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_MacroParameterSet", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

################################################
#      IEEE14 - NonDefaultLocalInitParams      #
################################################

case_name = "IEEE14 - Non default local initialisation parameters"
case_description = "IEEE14 - Non default local initialisation parameters"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_SyntaxExamples", "IEEE14_NonDefaultLocalInitParams", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Disconnect line         #
#########################################

case_name = "IEEE14 - Disconnect line"
case_description = "IEEE14 - Disconnect line 1-5"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_BasicTestCases", "IEEE14_DisconnectLine", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "IEEE14 - Disconnect line with init"
case_description = "IEEE14 - Disconnect line 1-5"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_BasicTestCases", "IEEE14_DisconnectLineInit", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "IEEE14 - Disconnect line with timeout"
case_description = "IEEE14 - Disconnect line 1-5 : timeout interrupts simulation"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_BasicTestCases", "IEEE14_DisconnectLine_timeout", "IEEE14.jobs")
# WARNING this nrt can only work on release

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Disconnect group        #
#########################################

case_name = "IEEE14 - Disconnect group"
case_description = "IEEE14 - Disconnect group 2"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_BasicTestCases", "IEEE14_DisconnectGroup", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Load Variation          #
#########################################

case_name = "IEEE14 - Load Variation"
case_description = "IEEE14 - Load 2 Variation"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_BasicTestCases", "IEEE14_LoadVariation", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - UVA                     #
#########################################

case_name = "IEEE14 - Under Voltage Automaton"
case_description = "IEEE14 with an under-voltage automaton on generator 3"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_WithAutomata", "IEEE14_UnderVoltageAutomaton", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - PhaseShifterI           #
#########################################

case_name = "IEEE14 - Phase Shifter I"
case_description = "IEEE14 with a phase shifter I monitoring bus5-bus6 transformer's current"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_WithAutomata", "IEEE14_PhaseShifterI", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - PhaseShifterP           #
#########################################

case_name = "IEEE14 - Phase Shifter P"
case_description = "IEEE14 with a phase shifter P monitoring bus5-bus6 transformer's active power"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_WithAutomata", "IEEE14_PhaseShifterP", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#           IEEE14 - CLA                #
#########################################

case_name = "IEEE14 - Current Limit Automaton"
case_description = "IEEE14 with a current limit automaton on line 2-4 and on line 2-5"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_WithAutomata", "IEEE14_CurrentLimitAutomaton", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#    IEEE14 - Tap Changer (Modelica)    #
#########################################

case_name = "IEEE14 - Tap Changer (Modelica)"
case_description = "IEEE14 with load 3 behind a transformer with a tap changer"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_WithAutomata", "IEEE14_TapChanger", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Tap Changer (CPP)       #
#########################################

case_name = "IEEE14 - Tap Changer (CPP)"
case_description = "IEEE14 with a tap changer on transformer 5-6"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_WithAutomata", "IEEE14_TapChangerCpp", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#       IEEE14 - Tap Changer Blocking   #
#########################################

case_name = "IEEE14 - Tap Changer Blocking"
case_description = "IEEE14 with load 2 and 3 behind a transformer with a tap changer + Tap Changer Blocking"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_WithAutomata", "IEEE14_TapChangerBlocking", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
