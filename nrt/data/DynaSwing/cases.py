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
