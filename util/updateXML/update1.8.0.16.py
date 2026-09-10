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
    cla_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "CurrentLimitAutomaton")}
    add_value_suffix(jobs.dyds, cla_ids, "currentLimitAutomaton_IMonitored")

    ps_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "PhaseShifter" in bbm.get_lib_name())}
    add_value_suffix(jobs.dyds, ps_ids, "phaseShifter_iMonitored")
    add_value_suffix(jobs.dyds, ps_ids, "phaseShifter_P")
    add_value_suffix(jobs.dyds, ps_ids, "phaseShifter_PMonitored")

    tca_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "TapChangerAutomaton")}
    add_value_suffix(jobs.dyds, tca_ids, "tapChanger_UMonitored")

    tcba_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "TapChangerBlockingAutomaton1")}
    add_value_suffix(jobs.dyds, tcba_ids, "tapChangerBlocking_UMonitored")

    ctt_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "CombiTimeTable")}
    remove_value_suffix(jobs.dyds, ctt_ids, "combiTimeTable_source_value")

    ds_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "DoubleStep")}
    remove_value_suffix(jobs.dyds, ds_ids, "doubleStep_step_value")

    lab_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")}
    remove_value_suffix(jobs.dyds, lab_ids, "load_UPu_value")

    gen_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "Generator" in bbm.get_lib_name())}
    remove_value_suffix(jobs.dyds, gen_ids, "generator_omegaRefPu_value")

    sw_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "SineWave" in bbm.get_lib_name())}
    remove_value_suffix(jobs.dyds, sw_ids, "sineWave_source_value")

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
