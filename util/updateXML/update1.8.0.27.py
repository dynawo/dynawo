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

# Associate new INIT models with WECC WT (wind turbine) and WTG (wind power plant) models
@ticket(4128)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)

    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: "Dynawo.Electrical.Wind.WECC.WT3" in unit_dynamic_model.get_name() or
            "Dynawo.Electrical.Wind.WECC.WT4" in unit_dynamic_model.get_name())
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_init_name("Dynawo.Electrical.Wind.WECC.WTCurrentSource_INIT")

    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: "Dynawo.Electrical.Wind.WECC.WTG3" in unit_dynamic_model.get_name() or
            "Dynawo.Electrical.Wind.WECC.WTG4" in unit_dynamic_model.get_name())
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_init_name("Dynawo.Electrical.Wind.WECC.WTGCurrentSource_INIT")
