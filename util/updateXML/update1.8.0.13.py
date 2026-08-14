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

# remove the "_value" suffix or pass it to the other var of connects for given models and member variables
@ticket(3748)
def update(jobs):
    cla_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "CurrentLimitAutomaton" in bbm.get_lib_name())}
    add_value_suffix(jobs.dyds, cla_ids, "currentLimitAutomaton_order")

    dpl_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "DistanceProtectionLine" in bbm.get_lib_name())}
    add_value_suffix(jobs.dyds, dpl_ids, "distance_lineState")

    event_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "EventQuadripole" in bbm.get_lib_name() or bbm.get_lib_name() == "EventConnectedStatus")}
    remove_value_suffix(jobs.dyds, event_ids, "event_state1_value")

def add_value_suffix(dyds, bbm_ids, var):
    if not bbm_ids:
        return
    for idx in ["1", "2"]:
        opp_idx = str(3 - int(idx))
        for connect in dyds.get_connects_with_var_for_models(var, idx, bbm_ids):
            if not connect.attrib['var' + opp_idx].endswith("_value"):
                connect.attrib['var' + opp_idx] += "_value"              # no suffix on opposite side : add suffix on opposite side

def remove_value_suffix(dyds, bbm_ids, var):
    if not bbm_ids:
        return
    for idx in ["1", "2"]:
        for connect in dyds.get_connects_with_var_for_models(var, idx, bbm_ids):
            connect.attrib['var' + idx] = connect.attrib['var' + idx].replace("_value", "")
