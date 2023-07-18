# -*- coding: utf-8 -*-

# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.

import os

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"
forbiddenReturnCodeType = "FORBIDDEN"

###########################################
#         AggregatedIBG test case         #
###########################################

case_name = "AggregatedIBG"
case_description = "AggregatedIBG test on a SMIB network"
job_file = os.path.join(os.path.dirname(__file__), "AggregatedIBG", "AggregatedIBG.jobs")

test_cases.append((case_name, case_description, job_file, 2, standardReturnCodeType, standardReturnCode))

###########################################
#             DERa test case             #
###########################################

case_name = "DERa"
case_description = "DERa test on a SMIB network"
job_file = os.path.join(os.path.dirname(__file__), "DERa", "DERa.jobs")

test_cases.append((case_name, case_description, job_file, 2, standardReturnCodeType, standardReturnCode))
