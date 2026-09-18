# -*- coding: utf-8 -*-

# Copyright (c) 2026, RTE (http://www.rte-france.com)
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

# WECC models : adding the HVRT and LVRT parameters
@ticket(4202)
def update(jobs):
    weccs = jobs.dyds.get_bbms(lambda bbm: "Wecc" in bbm.get_lib_name())
    for wecc in weccs:
        if "Photovoltaics" in wecc:
            instance = "photovoltaics"
        elif "WT3" in wecc:
            instance = "WT3"
        else:
            instance = str(wecc.split("Wecc")[0])
        wecc.parset.add_param("STRING", instance + "_TablesFile", "LHVRT.txt")
        wecc.parset.add_param("STRING", instance + "_TabletUoverUfilt", "hvrt")
        wecc.parset.add_param("STRING", instance + "_TabletUunderUfilt", "lvrt")
        wecc.parset.add_param("DOUBLE", instance + "_tLagAction", 0.05)
        wecc.parset.add_param("DOUBLE", instance + "_tUFilt", 0.01)
        wecc.parset.add_param("DOUBLE", instance + "_UOverPu", 1.5)
        wecc.parset.add_param("DOUBLE", instance + "_UUnderPu", 0.5)
