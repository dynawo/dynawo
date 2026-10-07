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

# WECC models : adding the LHVRT parameters
@ticket(4202)
def update(jobs):
    weccs = jobs.dyds.get_bbms(lambda bbm: "Wecc" in bbm.get_lib_name())
    for wecc in weccs:
        wecc.parset.add_param("STRING", "lhvrt_TablesFile", "LHVRT.txt")
        wecc.parset.add_param("BOOL", "lhvrt_TablesOnFile", true)
        wecc.parset.add_param("STRING", "lhvrt_TabletUoverUfilt", "hvrt")
        wecc.parset.add_param("STRING", "lhvrt_TabletUunderUfilt", "lvrt")
        wecc.parset.add_param("DOUBLE", "lhvrt_tLagAction", 0.05)
        wecc.parset.add_param("DOUBLE", "lhvrt_tUFilt", 0.01)
        wecc.parset.add_param("DOUBLE", "lhvrt_UOverPu", 1.5)
        wecc.parset.add_param("DOUBLE", "lhvrt_UUnderPu", 0.5)
