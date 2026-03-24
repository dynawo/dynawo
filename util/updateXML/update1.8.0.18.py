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

# Same INIT models for BESS, PV and Wind
@ticket(3801)
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.BESS.WECC.BESSCurrentSource" or
            unit_dynamic_model.get_name() == "Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSource" or
            "Dynawo.Electrical.Wind.WECC.WTG" in unit_dynamic_model.get_name())
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_init_name("Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCPlantCurrentSource_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "BESSCurrentSourceNoPlantControl" or
            unit_dynamic_model.get_name() == "Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSourceNoPlantControl" or
            "Dynawo.Electrical.Wind.WECC.WT4" in unit_dynamic_model.get_name())
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_init_name("Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCInverterCurrentSource_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource1NoPlantControl" or
            unit_dynamic_model.get_name() == "Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource2NoPlantControl" or
            unit_dynamic_model.get_name() == "Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource3NoPlantControl" or
            unit_dynamic_model.get_name() == "Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4NoPlantControl")
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_init_name("Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource_INIT")
