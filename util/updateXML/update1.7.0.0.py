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

# replace PSS2A1 by Pss2a, PssIEEE2B by Pss2b, ExcIEEEAC1A by Ac1a, ExcIEEEST4B by St4b, SCRX by Scrx, HYGOV1 by HyGov, TGOV11 by TGov1
@ticket(3091)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PSS2A1"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.Pss2a")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PssIEEE2B"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.Pss2b")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExcIEEEAC1A"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Ac1a")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExcIEEEST4B"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.St4b")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SCRX"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Scrx")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.HYGOV1"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.HyGov")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGOV11"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGov1")

    model_templates = jobs.dyds.get_model_templates(lambda _: True)
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PSS2A1"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.Pss2a")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PssIEEE2B"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.Pss2b")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExcIEEEAC1A"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Ac1a")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExcIEEEST4B"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.St4b")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SCRX"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Scrx")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.HYGOV1"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.HyGov")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGOV11"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGov1")

    genxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsTGov1SexsPss2A")
    for genxml in genxmls:
        genxml.set_lib_name("GeneratorSynchronousFourWindingsTGov1SexsPss2a")
    genxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsGovSteam1ExcIEEEST4B")
    for genxml in genxmls:
        genxml.set_lib_name("GeneratorSynchronousFourWindingsGovSteam1St4b")
    genxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsGovSteam1ExcIEEEST4BPssIEEE2B")
    for genxml in genxmls:
        genxml.set_lib_name("GeneratorSynchronousFourWindingsGovSteam1St4bPss2b")
    genxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsPmConstExcIeeeAc1a")
    for genxml in genxmls:
        genxml.set_lib_name("GeneratorSynchronousThreeWindingsPmConstExAc1")
    genxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsPmConstExcIeeeAc1aTfo")
    for genxml in genxmls:
        genxml.set_lib_name("GeneratorSynchronousThreeWindingsPmConstExAc1Tfo")
