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
    var_to_update = ["generator_omegaRefPu", "generator_PmPu", "generator_omegaPu", \
                     "generator_efdPu", "generator_UStatorPu", "generator_IRotorPu", "generator_QStatorPu"]
    var_to_update = ["generator_QStatorPu"]
    generators = jobs.dyds.get_bbms(lambda bbm: "GeneratorSynchronous" in bbm.get_lib_name())
    for generator in generators:
        connects = generator.connects.get_connects()
        for connect in connects:
            for idx in ["1", "2"]:
                id = connect.attrib['id' + idx]
                var = connect.attrib['var' + idx]
                other_idx = "2"
                if idx == "2":
                    other_idx = "1"
                other_var = connect.attrib['var' + other_idx]
                if id != generator.get_id() and (other_var in var_to_update or other_var.replace("_value","") in var_to_update):
                    if "_value" not in other_var:
                        connect.attrib['var' + idx] = var + "_value"
        for var_name in var_to_update:
            generator.connects.change_var_name(var_name + "_value", var_name)

    var_to_update = ["setPoint_setPoint"]
    set_points = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "SetPoint")
    for set_point in set_points:
        connects = set_point.connects.get_connects()
        for connect in connects:
            for idx in ["1", "2"]:
                id = connect.attrib['id' + idx]
                var = connect.attrib['var' + idx]
                other_idx = "2"
                if idx == "2":
                    other_idx = "1"
                other_var = connect.attrib['var' + other_idx]
                if id != set_point.get_id() and (other_var in var_to_update):
                    if "_value" not in other_var:
                        connect.attrib['var' + idx] = var + "_value"
    for set_point in set_points:
        for var_name in var_to_update:
            set_point.connects.change_var_name(var_name + "_value", var_name)

    var_to_update = ["step_step"]
    steps = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "Step")
    for step in steps:
        connects = step.connects.get_connects()
        for connect in connects:
            for idx in ["1", "2"]:
                id = connect.attrib['id' + idx]
                var = connect.attrib['var' + idx]
                other_idx = "2"
                if idx == "2":
                    other_idx = "1"
                other_var = connect.attrib['var' + other_idx]
                if id != step.get_id() and (other_var in var_to_update):
                    if "_value" not in other_var:
                        connect.attrib['var' + idx] = var + "_value"
    for step in steps:
        for var_name in var_to_update:
            step.connects.change_var_name(var_name + "_value", var_name)
