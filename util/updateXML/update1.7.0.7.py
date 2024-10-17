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
from content.Ticket import ticket

# Add Q/V Deadband for DynaFlow generator models
@ticket(3452)
def update(jobs):
    gens = jobs.dyds.get_bbms(lambda bbm: "GeneratorPQProp" in bbm.get_lib_name())
    for gen in gens:
        gen.parset.add_param("DOUBLE", "generator_QDeadBand", 0.0001)
        gen.parset.add_param("DOUBLE", "generator_UDeadBand", 0.0001)

    gens = jobs.dyds.get_bbms(lambda bbm: "GeneratorPV" in bbm.get_lib_name())
    for gen in gens:
        gen.parset.add_param("DOUBLE", "generator_QDeadBand", 0.0001)
        gen.parset.add_param("DOUBLE", "generator_UDeadBand", 0.0001)
