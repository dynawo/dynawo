# -*- coding: utf-8 -*-

# Copyright (c) 2024, RTE (http://www.rte-france.com)
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
import sys

try:
    settings_dir = os.path.join(os.path.dirname(__file__))
    sys.path.append(settings_dir)
    import settings
except Exception as exc:
    print("Failed to import nrtDiff settings : " + str(exc))
    sys.exit(1)

# Check whether two floating numbers are close enough to be considered equals
# @param a : the first floating number to compare
# @param b : the second floating number to compare
# @param rel_tol : the relative tolerance to consider (default is settings.max_iidm_cmp_tol)
# @param abs_tol : the absolute tolerance to consider (default is one fifth of settings.max_iidm_cmp_tol)
def isclose(a, b, rel_tol=settings.max_iidm_cmp_tol, abs_tol=settings.max_iidm_cmp_tol/5.):
    return abs(a-b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)
