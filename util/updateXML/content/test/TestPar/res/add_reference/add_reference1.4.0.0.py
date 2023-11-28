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
        load.parset.add_ref("DOUBLE", "load_U0Pu", "IIDM", "v_pu")

    gens1 = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsProportionalRegulations")
    for gen1 in gens1:
        gen1.parset.add_ref("DOUBLE", "myRef", orig_data="PAR", orig_name="myParam", component_id="GEN____1_SM", par_id="5", par_file="myPar.par")

    gens2 = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsProportionalRegulations")
    for gen2 in gens2:
        gen2.parset.add_ref("DOUBLE", "generator_Q0Pu", orig_data="IIDM", orig_name="q_pu", component_id="GEN____1_SM")
