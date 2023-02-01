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


#########################################
#          Kundur Example 13            #
#########################################

case_name = "DynaSwing - Kundur - Example 13"
case_description = "Impact of the excitation control on a synchronous generator transient stability - Kundur Example 13"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "Kundur_Example13", "KundurExample13.jobs")

test_cases.append((case_name, case_description, job_file, 150, standardReturnCodeType, standardReturnCode))

###############################################
#     WSCC9 - Fault on generator 2 node     #
###############################################
case_name = "DynaSwing - WSCC9 - Fault"
case_description = "WSCC 9-bus - Fault on generator 2"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WSCC9", "WSCC9_Fault", "WSCC9.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################
#     IEEE14 - Fault on generator 2 node     #
###############################################
case_name = "DynaSwing - IEEE14 - Fault"
case_description = "IEEE14 - Fault on generator 2"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEEE14", "IEEE14_Fault", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

####################################################################
#     IEEE57 - Fault on generator 12 node                         #
####################################################################

case_name = "DynaSwing - IEEE57 - Fault"
case_description = "IEEE57 - Fault on generator 12"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEEE57", "IEEE57_Fault", "IEEE57.jobs")

test_cases.append((case_name, case_description, job_file, 2, standardReturnCodeType, standardReturnCode))

#############################
#     GFM / GFL - Steps     #
#############################

case_name = "DynaSwing - All converter-interfaced 5-machine system - 3 GFM + 2 GFL - Steps"
case_description = "All converter-interfaced 5-machine system - 3 GFM + 2 GFL - Steps"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "GridForming_GridFollowing", "Steps", "fic.JOB")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

#############################
#     GFM / GFL - Fault     #
#############################

case_name = "DynaSwing - All converter-interfaced 5-machine system - 3 GFM + 2 GFL - Fault"
case_description = "All converter-interfaced 5-machine system - 3 GFM + 2 GFL - Fault"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "GridForming_GridFollowing", "Fault", "fic.JOB")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

#############################
#     GFM / GFL - DisconnectLine     #
#############################

case_name = "DynaSwing - All converter-interfaced 5-machine system - 3 GFM + 2 GFL - DisconnectLine"
case_description = "All converter-interfaced 5-machine system - 3 GFM + 2 GFL - DisconnectLine"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "GridForming_GridFollowing", "DisconnectLine", "fic.JOB")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

###################################################
#     IEC Wind Turbine Type 4A Current Source     #
###################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A - Current source"
case_description = "IEC - Wind Turbine Type 4A - Current source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource", "WT4ACurrentSource.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

###################################################
#     IEC Wind Turbine Type 4B Current Source     #
###################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4B - Current source"
case_description = "IEC - Wind Turbine Type 4B - Current source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4BCurrentSource", "WT4BCurrentSource.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##################################
#     WECC PV Current Source     #
##################################

case_name = "DynaSwing - WECC - PV - Current source"
case_description = "WECC - PV - Current Source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "PV", "WECCPVCurrentSource", "WECCPV.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##################################
#     WECC PV Voltage Source     #
##################################

case_name = "DynaSwing - WECC - PV - Voltage Source"
case_description = "WECC - PV - Voltage Source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "PV", "WECCPVVoltageSource", "WECCPVVSource.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##########################################
#     WECC Wind Type 4A Current Source   #
##########################################

case_name = "DynaSwing - WECC - Wind 4A Type - Current source"
case_description = "WECC - Wind 4A Type - Current Source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "Wind", "WECCWTG4ACurrentSource", "WECCWTG4A.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##########################################
#     WECC Wind Type 4B Current Source   #
##########################################

case_name = "DynaSwing - WECC - Wind 4B Type - Current source"
case_description = "WECC - Wind 4B Type - Current Source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "Wind", "WECCWTG4BCurrentSource", "WECCWTG4B.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))
###############################################
#     ENTSO-E Test Case 1                     #
###############################################

case_name = "DynaSwing - ENTSO-E - Test Case 1"
case_description = "Voltage reference step on the synchronous machine (and its regulations) connected to a zero current bus"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "ENTSOE", "TestCase1", "TestCase1.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

###############################################
#     ENTSO-E Test Case 2                     #
###############################################

case_name = "DynaSwing - ENTSO-E - Test Case 2"
case_description = "Active power variation on the load"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "ENTSOE", "TestCase2", "TestCase2.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

###############################################
#     ENTSO-E Test Case 3                     #
###############################################

case_name = "DynaSwing - ENTSO-E - Test Case 3"
case_description = "Bolted three-phase short circuit at the high-level side of the transformer"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "ENTSOE", "TestCase3", "TestCase3.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###############################################
#     ENTSO-E Test Case 3 PlayBack            #
###############################################

case_name = "DynaSwing - ENTSO-E - Test Case 3 - PlayBack"
case_description = "Bolted three-phase short circuit at the high-level side of the transformer played back using an infinite bus with table data"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "nrt", "data", "DynaSwing", "EntsoeTestCase3PlayBack", "TestCase3.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
