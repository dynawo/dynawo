# -*- coding: utf-8 -*-

# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.

import os

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"
forbiddenReturnCodeType = "FORBIDDEN"

#############################################
# Load Alpha Beta with frequency dependence #
#############################################

case_name = "Load Alpha Beta Frequency Dependent"
case_description = "Test the load model Alpha Beta with frequency dependence"
job_file = os.path.join(os.path.dirname(__file__), "LoadAlphaBetaFrequencyDependent", "LoadAlphaBetaFrequencyDependent.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
# Load ZIP with frequency dependence   #
########################################

case_name = "Load ZIP Frequency Dependent"
case_description = "Test the load model ZIP with frequency dependence"
job_file = os.path.join(os.path.dirname(__file__), "LoadZIPFrequencyDependent", "LoadZIPFrequencyDependent.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
