# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.


def update(jobs):
    gens1 = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_template_id() == "MachineThreeWindingsTemplate"
    )
    for gen1 in gens1:
        gen1.parset.add_param("DOUBLE", "myParam1", 0.215)

    gens2 = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_template_id() == "MachineFourWindingsTemplate"
    )
    for gen2 in gens2:
        gen2.parset.add_param("BOOL", "myParam2", True)
