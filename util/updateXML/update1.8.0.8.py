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

# Remove outdated WPP parameters, add new ones, replace a single INIT model by two new ones
@ticket(3612)
def update(jobs):
    wpps = jobs.dyds.get_bbms(lambda bbm: "IECWPP" in bbm.get_lib_name())
    for wpp in wpps:
        wpp.parset.remove_param_or_ref("BesPu")
        wpp.parset.remove_param_or_ref("GesPu")
        wpp.parset.remove_param_or_ref("ResPu")
        wpp.parset.remove_param_or_ref("XesPu")
        wpp.parset.add_param("BOOL", "WPP_PPCLocal", True)
        wpp.parset.add_param("DOUBLE", "WPP_BMvHvPu", 0)
        wpp.parset.add_param("DOUBLE", "WPP_GMvHvPu", 0)
        wpp.parset.add_param("DOUBLE", "WPP_RMvHvPu", 0)
        wpp.parset.add_param("DOUBLE", "WPP_XMvHvPu", 0)
        wpp.parset.add_param("BOOL", "WPP_ConverterLVControl", False)
        wpp.parset.add_param("DOUBLE", "WPP_BLvTrPu", 0)
        wpp.parset.add_param("DOUBLE", "WPP_GLvTrPu", 0)
        wpp.parset.add_param("DOUBLE", "WPP_RLvTrPu", 0)
        wpp.parset.add_param("DOUBLE", "WPP_XLvTrPu", 0)

    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: "CurrentSource2015" in unit_dynamic_model.get_name())
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_init_name("Dynawo.Electrical.Wind.IEC.WPP.WPP4CurrentSource2015_INIT")
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: "CurrentSource2020" in unit_dynamic_model.get_name())
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_init_name("Dynawo.Electrical.Wind.IEC.WPP.WPP4CurrentSource2020_INIT")
