# -*- coding: utf-8 -*-

# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.

import os

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"
forbiddenReturnCodeType = "FORBIDDEN"

###########################################
#           WECC WT4A test case           #
###########################################

case_name = "WECC WT4A"
case_description = "WECC WT4A (without plant controller) test on a SMIB network"
job_file = os.path.join(os.path.dirname(__file__),  "Wind", "WT4ACurrentSource", "WT4A.jobs")

test_cases.append((case_name, case_description, job_file, 2, standardReturnCodeType, standardReturnCode))

###########################################
#           WECC WT4B test case           #
###########################################

case_name = "WECC WT4B"
case_description = "WECC WT4B (without plant controller) test on a SMIB network"
job_file = os.path.join(os.path.dirname(__file__),  "Wind", "WT4BCurrentSource", "WT4B.jobs")

test_cases.append((case_name, case_description, job_file, 2, standardReturnCodeType, standardReturnCode))
