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

# add former default parameter values to .par
@ticket(3593)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
        for modelica_model in modelica_models:
            unit_dynamic_models = modelica_model.get_unit_dynamic_models(
                lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource"
            )
            for unit_dynamic_model in unit_dynamic_models:
                unit_dynamic_model.set_name("Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource1")
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
        for modelica_model in modelica_models:
            unit_dynamic_models = modelica_model.get_unit_dynamic_models(
                lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Mechanical.DriveTrainPmConstant"
            )
            for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.WTGTa")
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
        for modelica_model in modelica_models:
            unit_dynamic_models = modelica_model.get_unit_dynamic_models(
                lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Mechanical.DriveTrainPeFiltered"
            )
            for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.WTGTb")

    model_templates = jobs.dyds.get_model_templates(lambda _: True)
        for model_template in model_templates:
            unit_dynamic_models = model_template.get_unit_dynamic_models(
                lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource"
            )
            for unit_dynamic_model in unit_dynamic_models:
                unit_dynamic_model.set_name("Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource1")
    model_templates = jobs.dyds.get_model_templates(lambda _: True)
        for model_template in model_templates:
            unit_dynamic_models = model_template.get_unit_dynamic_models(
                lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Mechanical.DriveTrainPmConstant"
            )
            for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.WTGTa")
    model_templates = jobs.dyds.get_model_templates(lambda _: True)
        for model_template in model_templates:
            unit_dynamic_models = model_template.get_unit_dynamic_models(
                lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Mechanical.DriveTrainPeFiltered"
            )
            for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.WTGTb")

    windxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "WTG4AWeccCurrentSource")
    for windxml in windxmls:
        windxml.set_lib_name("WTG4AWeccCurrentSource1")
