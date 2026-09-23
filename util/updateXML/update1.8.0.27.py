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

# WT3, WTG3 : Pm0Pu calculated with the initialization model, thus removed from .par files
@ticket(4200)
def update(jobs):
    w3s = jobs.dyds.get_bbms(lambda bbm: "WT3" in bbm.get_lib_name() or "WTG3" in bbm.get_lib_name())
    for w3 in w3s:
        w3.parset.remove_param_or_ref("WT3_Pm0Pu")
        w3.parset.remove_param_or_ref("WTG3_Pm0Pu")
