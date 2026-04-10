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
    add_value_suffix(jobs.dyds.get_bbms(lambda bbm: "CurrentLimitAutomaton" in bbm.get_lib_name()),"currentLimitAutomaton_order")
    add_value_suffix(jobs.dyds.get_bbms(lambda bbm: "DistanceProtectionLine" in bbm.get_lib_name()),"distance_lineState")
    remove_value_suffix(jobs.dyds.get_bbms(lambda bbm: "EventQuadripole" in bbm.get_lib_name() or bbm.get_lib_name() == "EventConnectedStatus"),"event_state1_value")

def add_value_suffix(bbms, var):
    for bbm in bbms:
        for idx in ["1", "2"]:
            opp_idx = str(3-int(idx))
            for connect in bbm.connects.get_connects_with_var(var,idx):
                if not connect.attrib['var' + opp_idx].endswith("_value"):
                    connect.attrib['var' + opp_idx] += "_value"              # no suffix on opposite side : add suffix on opposite side

def remove_value_suffix(bbms, var):
    for bbm in bbms:
        for idx in ["1", "2"]:
            for connect in bbm.connects.get_connects_with_var(var,idx):
                connect.attrib['var' + idx] = connect.attrib['var' + idx].replace("_value","")
