# -*- coding: utf-8 -*-

# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.
from content.Ticket import ticket

# Modification from ImPin to input of generator's signals
@ticket(1272)
def update(jobs):
    generators = jobs.dyds.get_bbms(lambda bbm: "GeneratorSynchronous" in bbm.get_lib_name())
    for generator in generators:
        for var in ["generator_omegaRefPu", "generator_PmPu", "generator_omegaPu", \
                "generator_efdPu", "generator_UStatorPu", "generator_IRotorPu", "generator_QStatorPu"]:
            generator.connects.change_var_name(var + "_value", var)
            suffix_opposite_var_name(generator.connects,var,"_value")

    set_points = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "SetPoint")
    for set_point in set_points:
        set_point.connects.change_var_name("setPoint_setPoint_value","setPoint_setPoint")
        suffix_opposite_var_name(set_point.connects,"setPoint_setPoint","_value")

    steps = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "Step")
    for step in steps:
        step.connects.change_var_name("step_step_value","step_step")
        suffix_opposite_var_name(step.connects,"step_step","_value")

def suffix_opposite_var_name(connects, var, suffix):
    """
    Add suffix to the variable on the other side of all connects in which var appears

    Parameters:
        connects (Connects): the connects member of a model
        var (str): variable to filter the connects by
        suffix (str): suffix to add to the opposite var of a connect
    """
    for idx in ["1", "2"]:
        filtered_connects = connects.get_connects_with_var(var,idx)
        oppIdx = str(3-int(idx))
        for connect in filtered_connects:
            if not connect.attrib['var' + oppIdx].endswith(suffix):
                connect.attrib['var' + oppIdx] += suffix
