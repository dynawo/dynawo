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
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "GEN____1_SM")
    for gen in gens:
        gen.macro_connects.remove_macro_connect("GEN_NETWORK_CONNECTOR")

    omega_refs = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "OMEGA_REF")
    for omega_ref in omega_refs:
        omega_ref.macro_connects.remove_macro_connect("GEN_OMEGAREF_CONNECTOR")
