# -*- coding: utf-8 -*-

# Copyright (c) 2024, RTE (http://www.rte-france.com)
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

# rename IEEEG1 as IEEEG11, SCRX as SCRX1, IEEET1 : UStator0Pu -> Us0Pu, Standard.IEEET1_INIT -> Exciter_INIT
@ticket(3091)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.IEEEG1"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.IEEEG11")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SCRX"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SCRX1")

    model_templates = jobs.dyds.get_model_templates(lambda _: True)
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.IEEEG1"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.IEEEG11")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SCRX"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SCRX1")

    modelica_models = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.IEEET1")
    for modelica_model in modelica_models:
        unit_dynamic_models1 = modelica_model.get_unit_dynamic_models(lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator")
        for unit_dynamic_model1 in unit_dynamic_models1:
            unit_dynamic_model1.init_connects.change_var_name("UStator0Pu", "Us0Pu")
    model_templates = jobs.dyds.get_model_templates(lambda modelica_model: modelica_model.get_id() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.IEEET1")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator")
        for unit_dynamic_model1 in unit_dynamic_models1:
            unit_dynamic_model1.init_connects.change_var_name("UStator0Pu", "Us0Pu")

    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.IEEET1_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT")
    model_templates = jobs.dyds.get_model_templates(lambda _: True)
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.IEEET1_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT")
