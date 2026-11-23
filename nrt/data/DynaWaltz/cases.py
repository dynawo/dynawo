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

##########################################################################################
#     Nordic Test System with a fault, the tripping of a line and a voltage collapse     #
##########################################################################################
case_name = "DynaWaltz - Nordic Test System"
case_description = "Nordic Test System with a fault, the tripping of a line and a voltage collapse"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "Nordic", "Nordic.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###################################################################################################################
#     Nordic Test System with a fault, the tripping of a line and a voltage collapse avoided thanks to the TCB    #
###################################################################################################################
case_name = "DynaWaltz - Nordic Test System - TCB"
case_description = "Nordic Test System with a fault, the tripping of a line and a voltage collapse avoided thanks to the TCB"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "NordicTCB", "NordicTCB.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#################################################
#           NORDIC dump-load sequence           #
#################################################

case_name = "NORDIC dump-load sequence"
case_description = "NORDIC dump-load from dump sequence while tap changers are moving."
job_file = os.path.join(os.path.dirname(__file__), "Nordic_DumpLoad/Nordic_seq.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

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

##################################################
#  Model examples - HVDC links with AC emulation  #
##################################################

case_name = "DynaWaltz - ModelExamples - HvdcPQPropEmulationVariableK"
case_description = "HvdcPQPropEmulationVariableK model example: power transfer after the disconnection of one of two parallel HVDC links"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "ModelExamples", "Hvdc", "HvdcPQPropEmulationVariableK", "HvdcPQPropEmulationVariableK.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "DynaWaltz - ModelExamples - HvdcPQPropDiagramPQEmulationVariableK"
case_description = "HvdcPQPropDiagramPQEmulationVariableK model example: power transfer after the disconnection of one of two parallel HVDC links"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "ModelExamples", "Hvdc", "HvdcPQPropDiagramPQEmulationVariableK", "HvdcPQPropDiagramPQEmulationVariableK.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "DynaWaltz - ModelExamples - HvdcPVDiagramPQEmulationVariableK"
case_description = "HvdcPVDiagramPQEmulationVariableK model example: power transfer after the disconnection of one of two parallel HVDC links"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "ModelExamples", "Hvdc", "HvdcPVDiagramPQEmulationVariableK", "HvdcPVDiagramPQEmulationVariableK.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "DynaWaltz - ModelExamples - HvdcPVDiagramPQEmulation"
case_description = "HvdcPVDiagramPQEmulation model example: disconnection of an AC line in parallel with two HVDC links"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "ModelExamples", "Hvdc", "HvdcPVDiagramPQEmulation", "HvdcPVDiagramPQEmulation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "DynaWaltz - ModelExamples - HvdcPVEmulationRpcl2Side1"
case_description = "HvdcPVEmulationRpcl2Side1 model example: disconnection of an AC line in parallel with two HVDC links"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "ModelExamples", "Hvdc", "HvdcPVEmulationRpcl2Side1", "HvdcPVEmulationRpcl2Side1.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "DynaWaltz - ModelExamples - HvdcPVDiagramPQEmulationRpcl2Side1"
case_description = "HvdcPVDiagramPQEmulationRpcl2Side1 model example: disconnection of an AC line in parallel with two HVDC links"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "ModelExamples", "Hvdc", "HvdcPVDiagramPQEmulationRpcl2Side1", "HvdcPVDiagramPQEmulationRpcl2Side1.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "DynaWaltz - ModelExamples - HvdcPVEmulationVariableKRpcl2Side1"
case_description = "HvdcPVEmulationVariableKRpcl2Side1 model example: disconnection of an AC line in parallel with two HVDC links"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "ModelExamples", "Hvdc", "HvdcPVEmulationVariableKRpcl2Side1", "HvdcPVEmulationVariableKRpcl2Side1.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

case_name = "DynaWaltz - ModelExamples - HvdcPVDiagramPQEmulationVariableKRpcl2Side1"
case_description = "HvdcPVDiagramPQEmulationVariableKRpcl2Side1 model example: disconnection of an AC line in parallel with two HVDC links"
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaWaltz", "ModelExamples", "Hvdc", "HvdcPVDiagramPQEmulationVariableKRpcl2Side1", "HvdcPVDiagramPQEmulationVariableKRpcl2Side1.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
