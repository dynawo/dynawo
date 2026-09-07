# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.


def update(jobs):
    gens = jobs.dyds.get_model_templates(
        lambda model_template: model_template.get_id() in ["MachineThreeWindingsTemplate",
                                                            "MachineFourWindingsTemplate"]
    )
    for gen in gens:
        gen.static_refs.change_var_name("generator_PGenPu", "generator_PGenPu_NAME_CHANGED")
        gen.static_refs.change_var_name("generator_QGenPu", "generator_QGenPu_NAME_CHANGED")
