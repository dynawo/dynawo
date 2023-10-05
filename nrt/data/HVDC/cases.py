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

##############################################################
#                   HVDC standard model                      #
##############################################################

case_name = "HVDC standard model"
case_description = "HVDC standard model - Two nodes system"
job_file = os.path.join(os.path.dirname(__file__), "HVDC.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
