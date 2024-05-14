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


def update(jobs):
    loads1 = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "_LOAD___2_EC")
    for load1 in loads1:
        load1.connects.add_connect("load_terminal", "NETWORK", "_BUS____2_TN_ACPIN")

    loads2 = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "_LOAD___3_EC")
    for load2 in loads2:
        load2.connects.add_connect("load_terminal", "NETWORK", "_BUS____3_TN_ACPIN")

    omega_refs = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "OMEGA_REF")
    for omega_ref in omega_refs:
        omega_ref.connects.add_connect("omega_grp_0", "GEN____1_SM", "generator_omegaPu")
