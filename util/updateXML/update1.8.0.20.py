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
    all_bbm_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda _: True)}

    add_value_suffix(jobs.dyds, all_bbm_ids, "generator_switchOffSignal1")
    add_value_suffix(jobs.dyds, all_bbm_ids, "generator_switchOffSignal2")
    add_value_suffix(jobs.dyds, all_bbm_ids, "generator_switchOffSignal3")
    add_value_suffix(jobs.dyds, all_bbm_ids, "load_switchOffSignal1")
    add_value_suffix(jobs.dyds, all_bbm_ids, "currentLimitAutomaton_AutomatonExists")
    add_value_suffix(jobs.dyds, all_bbm_ids, "phaseShifter_AutomatonExists")
    add_value_suffix(jobs.dyds, all_bbm_ids, "reactivePowerControlLoop_groupParticipating")
    add_value_suffix(jobs.dyds, all_bbm_ids, "reactivePowerControlLoop_limUQDown")
    add_value_suffix(jobs.dyds, all_bbm_ids, "reactivePowerControlLoop_limUQUp")
    add_value_suffix(jobs.dyds, all_bbm_ids, "reactivePowerControlLoop_limUQUp")
    add_value_suffix(jobs.dyds, all_bbm_ids, "hvdc_switchOffSignal1Side1")
    add_value_suffix(jobs.dyds, all_bbm_ids, "hvdc_switchOffSignal1Side2")

    gfc_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GridFormingConverterDroopControl")}
    add_value_suffix(jobs.dyds, gfc_ids, "converter_running")

    wtg_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "WTG4AWeccCurrentSource1")}
    add_value_suffix(jobs.dyds, wtg_ids, "WTG4A_injector_running")

    concatenate_value_suffix_grp(jobs.dyds, all_bbm_ids)

    hvdc_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "PowerTransferHVDCEmulation" in bbm.get_lib_name())}
    remove_value_suffix(jobs.dyds, hvdc_ids, "hvdc_running_value")

    line_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LineFault")}
    remove_value_suffix(jobs.dyds, line_ids, "line_switchOffSignal1_value")

    shunt_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "ShuntB" in bbm.get_lib_name())}
    remove_value_suffix(jobs.dyds, shunt_ids, "shunt_running_value")
    remove_value_suffix(jobs.dyds, shunt_ids, "shunt_switchOffSignal1_value")

    event_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "EventSetPointBoolean")}
    remove_value_suffix(jobs.dyds, event_ids, "event_state1_value")

    bool_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "BooleanTable")}
    remove_value_suffix(jobs.dyds, bool_ids, "booleanTable_source_value")

def add_value_suffix(dyds, bbm_ids, var):
    if not bbm_ids:
        return
    for idx in ["1", "2"]:
        opp_idx = str(3 - int(idx))
        for connect in dyds.get_connects_with_var_for_models(var, idx, bbm_ids):
            if not connect.attrib['var' + opp_idx].endswith("_value"):
                connect.attrib['var' + opp_idx] += "_value"              # no suffix on opposite side : add suffix on opposite side

def concatenate_value_suffix_grp(dyds, bbm_ids):
    if not bbm_ids:
        return
    for idx in ["1", "2"]:
        opp_idx = str(3 - int(idx))
        for connect in dyds.get_connects_with_var_prefix_for_models("running_grp_", idx, bbm_ids):
            if connect.attrib['var' + opp_idx].endswith("_running") and not connect.attrib['var' + idx].endswith("_value"):
                connect.attrib['var' + idx] += "_value"

def remove_value_suffix(dyds, bbm_ids, var):
    if not bbm_ids:
        return
    for idx in ["1", "2"]:
        for connect in dyds.get_connects_with_var_for_models(var, idx, bbm_ids):
            connect.attrib['var' + idx] = connect.attrib['var' + idx].replace("_value", "")
