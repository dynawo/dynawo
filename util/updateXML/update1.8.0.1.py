# -*- coding: utf-8 -*-

# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.

from content.Ticket import ticket

# add former default parameter values to .par
@ticket(3636)
def update(job):
    for lib_name in ["Pss2","Pss3","Pss6c"]:
        for bbm in job.dyds.get_bbms(lambda bbm: lib_name in bbm.get_lib_name()):
            instance_name = "pss" if bbm.parset.check_if_param_exists("pss_t1") else "powerSystemStabilizer"
            bbm.parset.add_param("DOUBLE", instance_name+"_KOmega", 1)
            bbm.parset.add_param("DOUBLE", instance_name+"_KOmegaRef", 0)

    for lib_name in ["Ac6a","Ac7b","Dc1a"]:
        for bbm in job.dyds.get_bbms(lambda bbm: lib_name in bbm.get_lib_name()):
            bbm.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    for lib_name in ["Ac1a","St1a","St4b","St5b","St6b"]:
        for bbm in job.dyds.get_bbms(lambda bbm: lib_name in bbm.get_lib_name()):
            bbm.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
            bbm.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)

    for lib_name in ["Ac1c","Ac6c","Ac7c","Ac8c","Dc1c","St1c","St4c","St5c","St6c","St7b","St7c","St9c"]:
        for bbm in job.dyds.get_bbms(lambda bbm: lib_name in bbm.get_lib_name()):
            bbm.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
            bbm.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
            bbm.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
            bbm.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
