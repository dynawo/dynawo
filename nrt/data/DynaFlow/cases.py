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

case_name = "DynaFlow - IEEE14 - DisconnectLine"
case_description = "IEEE 14 test case with a line disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaFlow", "IEEE14", "IEEE14_DisconnectLine", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##############################################
#  Small System with an HVDC link and a CLA  #
##############################################

case_name = "DynaFlow - HVDC and CLA"
case_description = "Small System with an HVDC link and a CLA"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaFlow", "IllustrativeExamples", "HVDC_CLA", "HVDC_CLA.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################################
#  Small System with an HVDC link and a Phase Shifter  #
########################################################

case_name = "DynaFlow - HVDC and PhaseShifter"
case_description = "Small System with an HVDC link and a Phase Shifter"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaFlow", "IllustrativeExamples", "HVDC_PhaseShifter", "HVDC_PhaseShifter.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##########################################
#  Small System with a Load Restoration  #
##########################################

case_name = "DynaFlow - LoadRestoration"
case_description = "Small System with a Load Restoration"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaFlow", "IllustrativeExamples", "LoadRestoration", "LoadRestoration.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##########################################
#  Small System with two Phase Shifters  #
##########################################

case_name = "DynaFlow - PhaseShifters"
case_description = "Small System with two Phase Shifters"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaFlow", "IllustrativeExamples", "PhaseShifters", "PhaseShifters.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#############################################
#  Small System with a Shunt with sections  #
#############################################

case_name = "DynaFlow - Shunts"
case_description = "Small System with a Shunt with Sections"
job_file = os.path.join(os.path.dirname(__file__), "Shunts", "Shunt.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

######################################################################
#  Small System with a Shunt with sections and a section regulation  #
######################################################################

case_name = "DynaFlow - Shunts with regulation"
case_description = "Small System with a Shunt with Sections and a Section Regulation"
job_file = os.path.join(os.path.dirname(__file__), "ShuntWithRegulation", "Shunt.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################################
#  Small System with dangling HVDC links (VSC and LCC) #
########################################################

case_name = "DynaFlow - Dangling HVDC links"
case_description = "Small System with dangling HVDC links (VSC and LCC)"
job_file = os.path.join(os.path.dirname(__file__), "HvdcDangling", "HvdcDangling.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

####################################################################################
#  Small System with two HVDC links with AC Emulation and a power transfer control #
####################################################################################

case_name = "DynaFlow - HVDC links with AC Emulation and a power transfer control"
case_description = "Small System with two HVDC links with AC Emulation and a power transfer control"
job_file = os.path.join(os.path.dirname(__file__), "HvdcPowerTransfer", "HvdcPowerTransfer.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

################################################################################################
#  Small System with with a Load Restoration following a line disconnection, using a cpp model #
################################################################################################

case_name = "DynaFlow - LoadRestoration with line disconnection"
case_description = "Small System with with a Load Restoration following a line disconnection, using a cpp model"
job_file = os.path.join(os.path.dirname(__file__), "LoadRestorativeWithLimits", "LoadRestorativeWithLimits.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
