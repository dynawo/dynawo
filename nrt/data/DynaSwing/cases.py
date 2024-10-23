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
#     GFM EPRI - Fault      #
#############################

case_name = "DynaSwing - GFM EPRI - Fault"
case_description = "GFM EPRI - Fault"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "GridForming", "EPRI", "GFM_Fault", "GFM.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))


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
#   GFM / GFL - BBS Fault   #
#############################

case_name = "DynaSwing - All converter-interfaced 5-machine system - 3 GFM + 2 GFL - BBS Fault"
case_description = "All converter-interfaced 5-machine system - 3 GFM + 2 GFL - BBS Fault"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "GridForming_GridFollowing", "BBSFault", "fic.JOB")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

#############################
#     GFM / GFL - DisconnectLine     #
#############################

case_name = "DynaSwing - All converter-interfaced 5-machine system - 3 GFM + 2 GFL - DisconnectLine"
case_description = "All converter-interfaced 5-machine system - 3 GFM + 2 GFL - DisconnectLine"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "GridForming_GridFollowing", "DisconnectLine", "fic.JOB")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2015 Current Source Q      #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2015 - Current source - Q"
case_description = "IEC - Wind Turbine Type 4A 2015 - Current source - QRef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2015Q", "WT4ACurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2015 Current Source U      #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2015 - Current source - U"
case_description = "IEC - Wind Turbine Type 4A 2015 - Current source URef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2015U", "WT4ACurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2015 Current Source FOCB   #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2015 - Current source - FOCB"
case_description = "IEC - Wind Turbine Type 4A 2015 - Current source - Disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2015FOCB", "WT4ACurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2015 Current Source MQPRI0 #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2015 - Current source - MQPRI0"
case_description = "IEC - Wind Turbine Type 4A 2015 - Current source - Active current priority"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2015MQPRI0", "WT4ACurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A Current Source MQPRI1 #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2015 - Current source - MQPRI1"
case_description = "IEC - Wind Turbine Type 4A 2015 - Current source - Reactive current priority"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2015MQPRI1", "WT4ACurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4B 2015 Current Source Q      #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4B 2015 - Current source - Q"
case_description = "IEC - Wind Turbine Type 4B 2015 - Current source - QRef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4BCurrentSource2015Q", "WT4BCurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4B 2015 Current Source U      #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4B 2015 - Current source - U"
case_description = "IEC - Wind Turbine Type 4B 2015 - Current source - URef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4BCurrentSource2015U", "WT4BCurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4B 2015 Current Source FOCB   #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4B 2015 - Current source - FOCB"
case_description = "IEC - Wind Turbine Type 4B 2015 - Current source - Disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4BCurrentSource2015FOCB", "WT4BCurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2020 Current Source Q      #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2020 - Current source - Q"
case_description = "IEC - Wind Turbine Type 4A 2020 - Current source - QRef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2020Q", "WT4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2020 Current Source U      #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2020 - Current source - U"
case_description = "IEC - Wind Turbine Type 4A 2020 - Current source URef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2020U", "WT4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2020 Current Source FOCB   #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2020 - Current source - FOCB"
case_description = "IEC - Wind Turbine Type 4A 2020 - Current source - Disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2020FOCB", "WT4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2020 Current Source MQPRI0 #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2020 - Current source - MQPRI0"
case_description = "IEC - Wind Turbine Type 4A 2020 - Current source - Active current priority"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2020MQPRI0", "WT4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4A 2020 Current Source MQPRI1 #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4A 2020 - Current source - MQPRI1"
case_description = "IEC - Wind Turbine Type 4A 2020 - Current source - Reactive current priority"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4ACurrentSource2020MQPRI1", "WT4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4B 2020 Current Source Q      #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4B 2020 - Current source - Q"
case_description = "IEC - Wind Turbine Type 4B 2020 - Current source - QRef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4BCurrentSource2020Q", "WT4BCurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4B 2020 Current Source U      #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4B 2020 - Current source - U"
case_description = "IEC - Wind Turbine Type 4B 2020 - Current source - URef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4BCurrentSource2020U", "WT4BCurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#     IEC Wind Turbine Type 4B 2020 Current Source FOCB   #
######################################################

case_name = "DynaSwing - IEC - Wind Turbine Type 4B 2020 - Current source - FOCB"
case_description = "IEC - Wind Turbine Type 4B 2020 - Current source - Disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WT4BCurrentSource2020FOCB", "WT4BCurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4A 2015 Current Source Q    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4A 2015 - Current source - Q"
case_description = "IEC - Wind Power Plant Type 4A 2015 - Current source - QRef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4ACurrentSource2015Q", "WPP4ACurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4A 2015 Current Source U    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4A 2015 - Current source - U"
case_description = "IEC - Wind Power Plant Type 4A 2015 - Current source - URef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4ACurrentSource2015U", "WPP4ACurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4A 2015 Current Source FOCB #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4A 2015 - Current source - FOCB"
case_description = "IEC - Wind Power Plant Type 4A 2015 - Current source - Disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4ACurrentSource2015FOCB", "WPP4ACurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4B 2015 Current Source Q    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4B 2015 - Current source - Q"
case_description = "IEC - Wind Power Plant Type 4B 2015 - Current source - QRef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4BCurrentSource2015Q", "WPP4BCurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4B 2015 Current Source U    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4B 2015 - Current source - U"
case_description = "IEC - Wind Power Plant Type 4B 2015 - Current source - URef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4BCurrentSource2015U", "WPP4BCurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4B 2015 Current Source FOCB #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4B 2015 - Current source - FOCB"
case_description = "IEC - Wind Power Plant Type 4B 2015 - Current source - Disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4BCurrentSource2015FOCB", "WPP4BCurrentSource2015.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4A 2020 Current Source Q    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4A 2020 - Current source - Q"
case_description = "IEC - Wind Power Plant Type 4A 2020 - Current source - QRef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4ACurrentSource2020Q", "WPP4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4A 2020 Current Source U    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4A 2020 - Current source - U"
case_description = "IEC - Wind Power Plant Type 4A 2020 - Current source - URef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4ACurrentSource2020U", "WPP4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4A 2020 Current Source Voltage Dip    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4A 2020 - Current source - UDip"
case_description = "IEC - Wind Power Plant Type 4A 2020 - Current source - Voltage dip"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4ACurrentSource2020UDip", "WPP4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))


######################################################
#   IEC Wind Power Plant Type 4A 2020 Current Source FOCB #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4A 2020 - Current source - FOCB"
case_description = "IEC - Wind Power Plant Type 4A 2020 - Current source - Disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4ACurrentSource2020FOCB", "WPP4ACurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4B 2020 Current Source Q    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4B 2020 - Current source - Q"
case_description = "IEC - Wind Power Plant Type 4B 2020 - Current source - QRef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4BCurrentSource2020Q", "WPP4BCurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4B 2020 Current Source U    #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4B 2020 - Current source - U"
case_description = "IEC - Wind Power Plant Type 4B 2020 - Current source - URef"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4BCurrentSource2020U", "WPP4BCurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

######################################################
#   IEC Wind Power Plant Type 4B 2020 Current Source FOCB #
######################################################

case_name = "DynaSwing - IEC - Wind Power Plant Type 4B 2020 - Current source - FOCB"
case_description = "IEC - Wind Power Plant Type 4B 2020 - Current source - Disconnection"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "IEC", "Wind", "Neplan", "WPP4BCurrentSource2020FOCB", "WPP4BCurrentSource2020.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##################################
#     WECC PV Current Source     #
##################################

case_name = "DynaSwing - WECC - PV - Current source"
case_description = "WECC - PV - Current Source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "PV", "WECCPVCurrentSource", "WECCPV.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##################################
#     WECC PV Voltage Source 1   #
##################################

case_name = "DynaSwing - WECC - PV - Voltage Source 1"
case_description = "WECC - PV - Voltage Source - REEC-A - REGC-B"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "PV", "WECCPVVoltageSource1", "WECCPVVSource.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##################################
#     WECC PV Voltage Source  2   #
##################################

case_name = "DynaSwing - WECC - PV - Voltage Source 2"
case_description = "WECC - PV - Voltage Source - REEC-A - REGC-B"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "PV", "WECCPVVoltageSource2", "WECCPVVSource.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##################################
#     WECC PV Voltage Source 3   #
##################################

case_name = "DynaSwing - WECC - PV - Voltage Source 3"
case_description = "WECC - PV - Voltage Source - REEC-A - REGC-C"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "PV", "WECCPVVoltageSource3", "WECCPVVSource.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##################################
#     WECC PV Voltage Source 4   #
##################################

case_name = "DynaSwing - WECC - PV - Voltage Source 4"
case_description = "WECC - PV - Voltage Source - REEC-B - REGC-C"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "PV", "WECCPVVoltageSource4", "WECCPVVSource.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

####################################################
#     WECC Wind Type 4A Current Source with WTGTA  #
####################################################

case_name = "DynaSwing - WECC - Wind 4A Type - Current source - WTGTA"
case_description = "WECC - Wind 4A Type - Current Source - WTGTA"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "Wind", "WECCWTG4ACurrentSource1", "WECCWTG4A.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

####################################################
#     WECC Wind Type 3 Current Source  with WTGTB #
####################################################

case_name = "DynaSwing - WECC - Wind 4A Type - Current source - WTGTB"
case_description = "WECC - Wind 4A Type - Current Source - WTGTB"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "Wind", "WECCWTG4ACurrentSource2", "WECCWTG4A.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

####################################################
#     WECC Wind Type 3 Current Source with WTGPA  #
####################################################

case_name = "DynaSwing - WECC - Wind 3 Type - Current source - WTGPA"
case_description = "WECC - Wind 3 Type - Current Source - WTGPA"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "Wind", "WECCWTG3CurrentSource1", "WECCWTG3.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

####################################################
#     WECC Wind Type 3 Current Source with WTGPB  #
####################################################

case_name = "DynaSwing - WECC - Wind 3 Type - Current source - WTGPB"
case_description = "WECC - Wind 3 Type - Current Source - WTGPB"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "Wind", "WECCWTG3CurrentSource2", "WECCWTG3.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

##########################################
#     WECC Wind Type 4B Current Source   #
##########################################

case_name = "DynaSwing - WECC - Wind 4B Type - Current source"
case_description = "WECC - Wind 4B Type - Current Source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "Wind", "WECCWTG4BCurrentSource", "WECCWTG4B.jobs")

test_cases.append((case_name, case_description, job_file, 5, standardReturnCodeType, standardReturnCode))

#########################################################################################
#     WECC Battery Energy Storage System with REPC-A REEC-C and REGC-A Current Source   #
#########################################################################################

case_name = "DynaSwing - WECC - BESS - Current source"
case_description = "WECC - BESS - Current Source"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "WECC", "BESS", "WECCBESSCurrentSource", "WECCBESS.jobs")

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

###############################################
#  Single machine system with electronic load #
###############################################

case_name = "DynaSwing - Single machine system with electronic load - Fault"
case_description = "Single machine system with electronic load - Fault"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "SingleMachineSystem", "SingleMachineSystem_ElectronicLoad", "SingleMachineSystem.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

######################################################
#  Single machine system with fifth order motor load #
######################################################

case_name = "DynaSwing - Single machine system with fifth order motor load - Fault"
case_description = "Single machine system with fifth order motor load - Fault"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaSwing", "SingleMachineSystem", "SingleMachineSystem_LoadAlphaBetaMotorFifthOrder", "SingleMachineSystem.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
