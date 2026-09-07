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
    gens = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_template_id() in ["MachineFourWindingsTemplate",
                                                                                        "MachineThreeWindingsTemplate"]
    )
    for gen in gens:
        gen.macro_static_refs.remove_macro_static_ref("GEN")
        gen.macro_static_refs.remove_macro_static_ref("GEN1")
        gen.macro_static_refs.remove_macro_static_ref("GEN2")
