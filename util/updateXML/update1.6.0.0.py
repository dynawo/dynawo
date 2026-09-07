# -*- coding: utf-8 -*-

# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.
from content.Ticket import ticket

# remove linearSolverName parameter from solver
@ticket(2291)
def update(job):
    for solver in job.get_solvers():
      solver.parset.remove_param_or_ref("linearSolverName")
