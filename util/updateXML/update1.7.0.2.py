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

# Change path of IEEE14Base, IEEE14DisconnectLine, IEEE14NoEvent, IEEE14CLA and CoordinatedVControl, CoordinatedVControl_INIT
@ticket(3024)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IEEE14.BaseClasses.IEEE14Base"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IEEE14.BaseClasses.IEEE14Base")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IEEE14.TestCases.IEEE14NoEvent"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IEEE14.TestCases.IEEE14NoEvent")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IEEE14.TestCases.IEEE14DisconnectLine"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IEEE14.TestCases.IEEE14DisconnectLine")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IEEE14.TestCases.IEEE14CLA"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IEEE14.TestCases.IEEE14CLA")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IllustrativeExamples.CoordinatedVControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IllustrativeExamples.DynaFlow.CoordinatedVControl")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IllustrativeExamples.CoordinatedVControl_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IllustrativeExamples.DynaFlow.CoordinatedVControl_INIT")

    model_templates = jobs.dyds.get_model_templates(lambda _: True)
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IEEE14.BaseClasses.IEEE14Base"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IEEE14.BaseClasses.IEEE14Base")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IEEE14.TestCases.IEEE14NoEvent"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IEEE14.TestCases.IEEE14NoEvent")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IEEE14.TestCases.IEEE14DisconnectLine"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IEEE14.TestCases.IEEE14DisconnectLine")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IEEE14.TestCases.IEEE14CLA"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IEEE14.TestCases.IEEE14CLA")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IllustrativeExamples.CoordinatedVControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IllustrativeExamples.DynaFlow.CoordinatedVControl")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.DynaFlow.IllustrativeExamples.CoordinatedVControl_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.IllustrativeExamples.DynaFlow.CoordinatedVControl_INIT")
