# -*- coding: utf-8 -*-
# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0

import os

test_cases = []
job_file = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__)))), "examples", "DynaStream", "Nordic", "Nordic_nrt.jobs")
test_cases.append(("DynaStream - Nordic external clock action", "Drive an action and verify the resulting curve", job_file, 10, "ALLOWED", [0]))
internal_job_file = os.path.join(os.path.dirname(job_file), "Nordic_internal_nrt.jobs")
test_cases.append(("DynaStream - Nordic internal clock", "Interactive Nordic simulation with an accelerated internal clock", internal_job_file, 10, "ALLOWED", [0]))
