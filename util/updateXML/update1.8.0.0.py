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

# pass the "_value" suffix to the other var of connects for given models and member variables
@ticket(1272)
def update(jobs):
    for gen_var in ["omegaPu","omegaRefPu","PmPu","efdPu","UStatorPu","IRotorPu","QStatorPu"]:
        transfer_value_suffix(jobs.dyds.get_bbms(lambda bbm: "GeneratorSynchronous" in bbm.get_lib_name()),"generator_"+gen_var)

    transfer_value_suffix(jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "SetPoint"),"setPoint_setPoint")
    transfer_value_suffix(jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "Step"),"step_step")

def transfer_value_suffix(bbms, var):
    for bbm in bbms:
        for idx in ["1", "2"]:
            opp_idx = str(3-int(idx))
            for connect in bbm.connects.get_connects_with_var(var,idx):
                if not connect.attrib['var' + opp_idx].endswith("_value"):
                    connect.attrib['var' + opp_idx] += "_value"              # no suffix on var : add suffix opposite side
            for connect in bbm.connects.get_connects_with_var(var+"_value",idx):
                connect.attrib['var' + idx] = var                            # suffix on var : remove it, do not touch opposite side
