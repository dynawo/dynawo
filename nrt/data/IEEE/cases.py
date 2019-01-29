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

#########################################
#      IEEE14 - Modelica models         #
#########################################

case_name = "IEEE14 - Modelica models"
case_description = "IEEE14 - Modelica models"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_ModelicaModel", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Template models         #
#########################################

case_name = "IEEE14 - Template models"
case_description = "IEEE14 - Template models"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_TemplateModels", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 30, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Black box models        #
#########################################

case_name = "IEEE14 - Black box models"
case_description = "IEEE14 - Black box models"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_BlackBoxModels", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - MacroConnects           #
#########################################

case_name = "IEEE14 - MacroConnects"
case_description = "IEEE14 - MacroConnects"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_MacroConnects", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - MacroStaticRefs         #
#########################################

case_name = "IEEE14 - MacroStaticRefs"
case_description = "IEEE14 - MacroStaticRefs"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_MacroStaticRefs", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Disconnect line         #
#########################################

case_name = "IEEE14 - Disconnect line"
case_description = "IEEE14 - Disconnect line"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_DisconnectLine", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#########################################
#      IEEE14 - Disconnect group        #
#########################################

case_name = "IEEE14 - Disconnect group"
case_description = "IEEE14 - Disconnect group"
job_file = os.path.join(os.path.dirname(__file__), "IEEE14_DisconnectGroup", "IEEE14.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
