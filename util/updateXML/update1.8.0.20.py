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

# add or remove the "_value" suffix in the connect statements for given models and member variables
@ticket(3748)
def update(jobs):
    add_value_suffix(jobs.dyds.get_bbms(lambda _: True),"generator_switchOffSignal1")
    add_value_suffix(jobs.dyds.get_bbms(lambda _: True),"generator_switchOffSignal2")
    add_value_suffix(jobs.dyds.get_bbms(lambda _: True),"generator_switchOffSignal3")
    add_value_suffix(jobs.dyds.get_bbms(lambda _: True),"load_switchOffSignal1")
    add_value_suffix(jobs.dyds.get_bbms(lambda _: True),"currentLimitAutomaton_AutomatonExists")
    add_value_suffix(jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GridFormingConverterDroopControl"),"converter_running")
    add_value_suffix(jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "WTG4AWeccCurrentSource1"),"WTG4A_injector_running")

    for j in range(0,53):
        try:
            concatenate_value_suffix(jobs.dyds.get_bbms(lambda _: True),"running_grp_" + str(j))
        finally:
            pass

    remove_value_suffix(jobs.dyds.get_bbms(lambda bbm: "PowerTransferHVDCEmulation" in bbm.get_lib_name()),"hvdc_running_value")
    remove_value_suffix(jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LineFault"),"line_switchOffSignal1_value")
    remove_value_suffix(jobs.dyds.get_bbms(lambda bbm: "ShuntB" in bbm.get_lib_name()),"shunt_running_value")
    remove_value_suffix(jobs.dyds.get_bbms(lambda bbm: "ShuntB" in bbm.get_lib_name()),"shunt_switchOffSignal1_value")
    remove_value_suffix(jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "EventSetPointBoolean"),"event_state1_value")
    remove_value_suffix(jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "BooleanTable"),"booleanTable_source_value")

def add_value_suffix(bbms, var):
    for bbm in bbms:
        for idx in ["1", "2"]:
            opp_idx = str(3-int(idx))
            for connect in bbm.connects.get_connects_with_var(var,idx):
                if not connect.attrib['var' + opp_idx].endswith("_value"):
                    connect.attrib['var' + opp_idx] += "_value"              # no suffix on opposite side : add suffix on opposite side

def concatenate_value_suffix(bbms, var):
    for bbm in bbms:
        for idx in ["1", "2"]:
            opp_idx = str(3-int(idx))
            for connect in bbm.connects.get_connects_with_var(var,idx):
                if connect.attrib['var' + opp_idx].endswith("_running"):
                    connect.attrib['var' + idx] += "_value"

def remove_value_suffix(bbms, var):
    for bbm in bbms:
        for idx in ["1", "2"]:
            for connect in bbm.connects.get_connects_with_var(var,idx):
                connect.attrib['var' + idx] = connect.attrib['var' + idx].replace("_value","")
