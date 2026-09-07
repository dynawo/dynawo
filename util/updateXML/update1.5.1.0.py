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

# add generator_UseApproximation parameter
@ticket(2818)
def update(job):
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().startswith("Generator"))
    for gen in gens:
        gen.parset.add_param("BOOL", "generator_UseApproximation", True)
