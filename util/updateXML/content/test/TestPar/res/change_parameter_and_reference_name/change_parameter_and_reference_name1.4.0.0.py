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
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
    for load in loads:
        load.parset.change_param_or_ref_name("load_alpha", "load_alpha_NAME_CHANGED")
        load.parset.change_param_or_ref_name("load_P0Pu", "load_P0Pu_NAME_CHANGED")

    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsProportionalRegulations")
    for gen in gens:
        gen.parset.change_param_or_ref_name("generator_md", "generator_md_NAME_CHANGED")
        gen.parset.change_param_or_ref_name("generator_P0Pu", "generator_P0Pu_NAME_CHANGED")
