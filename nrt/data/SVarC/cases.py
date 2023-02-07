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

###########################################
#           SVarC_1_StepURef              #
###########################################

case_name = "SVarC - Step URef"
case_description = "SVarC test case with a step on the reference voltage"
job_file = os.path.join(os.path.dirname(__file__),  "SVarC_1_StepURef", "SVarC.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

##########################################
#           SVarC_2_LoadVarQ             #
##########################################

case_name = "SVarC - Load variation"
case_description = "SVarC test case with a load variation"
job_file = os.path.join(os.path.dirname(__file__),  "SVarC_2_LoadVarQ", "SVarC.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

##########################################
#           SVarC_3_LoadVarQLarge        #
##########################################

case_name = "SVarC - Load variation (large)"
case_description = "SVarC test case with a load variation (activation of the current limiter)"
job_file = os.path.join(os.path.dirname(__file__),  "SVarC_3_LoadVarQLarge", "SVarC.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

#########################################
#          SVarC_4_ModeChange           #
#########################################

case_name = "SVarC - Mode change"
case_description = "SVarC test case with several mode changes"
job_file = os.path.join(os.path.dirname(__file__), "SVarC_4_ModeChange", "SVarC.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

########################################
#           SVarC_5_FaultImp           #
########################################

case_name = "SVarC - Impedent fault"
case_description = "SVarC test case with an impedant three phase fault"
job_file = os.path.join(os.path.dirname(__file__),  "SVarC_5_FaultImp", "SVarC.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))
