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

# replace PSS2A1 by Pss2a, PssIEEE2B by Pss2b, ExcIEEEAC1A by ExAc1, ExcIEEEST4B by St4b, HYGOV1 by HyGov, TGOV11 by TGov1, IEEET1 : UStator0Pu -> Us0Pu, Standard.IEEET1_INIT -> Exciter_INIT
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
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExAc1")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExcIEEEST4B"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.St4b")
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
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExAc1")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExcIEEEST4B"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.St4b")
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

    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.SMIB.Standard.GovSteam1ExcIEEEST4BPssIEEE2B1"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.SMIB.Standard.GovSteam1St4bPss2b1")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.SMIB.Standard.GovSteam1ExcIEEEST4BPssIEEE2B2"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.SMIB.Standard.GovSteam1St4b2")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.SMIB.Standard.GovSteam1ExcIEEEST4BPssIEEE2B3"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.SMIB.Standard.GovSteam1St4bPss2b3")

    model_templates = jobs.dyds.get_model_templates(lambda _: True)
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.SMIB.Standard.GovSteam1ExcIEEEST4BPssIEEE2B1"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.SMIB.Standard.GovSteam1St4bPss2b1")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.SMIB.Standard.GovSteam1ExcIEEEST4BPssIEEE2B2"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.SMIB.Standard.GovSteam1St4b2")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.SMIB.Standard.GovSteam1ExcIEEEST4BPssIEEE2B3"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.SMIB.Standard.GovSteam1St4bPss2b3")

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
    genxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsHyGovScrxRvs")
    for genxml in genxmls:
        genxml.set_lib_name("GeneratorSynchronousThreeWindingsHyGovScrx")
    genxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsHyGovScrxRvsTfo")
    for genxml in genxmls:
        genxml.set_lib_name("GeneratorSynchronousThreeWindingsHyGovScrxTfo")

    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsGovSteam1St4b")
    for gen in gens:
        value = gen.parset.get_param_value("voltageRegulator_VrMaxPu")
        gen.parset.add_param("DOUBLE", "voltageRegulator_VaMaxPu", value)
        value = gen.parset.get_param_value("voltageRegulator_VrMinPu")
        gen.parset.add_param("DOUBLE", "voltageRegulator_VaMinPu", value)
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsGovSteam1St4bPss2b")
    for gen in gens:
        value = gen.parset.get_param_value("voltageRegulator_VrMaxPu")
        gen.parset.add_param("DOUBLE", "voltageRegulator_VaMaxPu", value)
        value = gen.parset.get_param_value("voltageRegulator_VrMinPu")
        gen.parset.add_param("DOUBLE", "voltageRegulator_VaMinPu", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_tw1")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_tw1")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_tW1", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_tw2")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_tw2")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_tW2", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_tw3")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_tw3")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_tW3", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_tw4")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_tw4")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_tW4", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_Vsi1MaxPu")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Vsi1MaxPu")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_OmegaMaxPu", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_Vsi1MinPu")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Vsi1MinPu")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_OmegaMinPu", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_Vsi2MaxPu")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Vsi2MaxPu")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_PGenMaxPu", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_Vsi2MinPu")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Vsi2MinPu")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_PGenMinPu", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_VstMaxPu")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_VstMaxPu")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_VPssMaxPu", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_VstMinPu")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_VstMinPu")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_VPssMinPu", value)
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsTGov1Sexs")
    for gen in gens:
        value = gen.parset.get_param_value("governor_Tg1")
        gen.parset.remove_param_or_ref("governor_Tg1")
        gen.parset.add_param("DOUBLE", "governor_t1", value)
        value = gen.parset.get_param_value("governor_Tg2")
        gen.parset.remove_param_or_ref("governor_Tg2")
        gen.parset.add_param("DOUBLE", "governor_t2", value)
        value = gen.parset.get_param_value("governor_Tg3")
        gen.parset.remove_param_or_ref("governor_Tg3")
        gen.parset.add_param("DOUBLE", "governor_t3", value)
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsTGov1SexsPss2a")
    for gen in gens:
        value = gen.parset.get_param_value("governor_Tg1")
        gen.parset.remove_param_or_ref("governor_Tg1")
        gen.parset.add_param("DOUBLE", "governor_t1", value)
        value = gen.parset.get_param_value("governor_Tg2")
        gen.parset.remove_param_or_ref("governor_Tg2")
        gen.parset.add_param("DOUBLE", "governor_t2", value)
        value = gen.parset.get_param_value("governor_Tg3")
        gen.parset.remove_param_or_ref("governor_Tg3")
        gen.parset.add_param("DOUBLE", "governor_t3", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_Tw1")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Tw1")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_tW1", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_Tw2")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Tw2")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_tW2", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_Tw3")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Tw3")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_tW3", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_Tw4")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Tw4")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_tW4", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_T1")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_T1")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_t1", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_T2")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_T2")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_t2", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_T3")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_T3")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_t3", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_T4")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_T4")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_t4", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_T6")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_T6")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_t6", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_T7")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_T7")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_t7", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_T8")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_T8")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_t8", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_T9")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_T9")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_t9", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_VstMax")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_VstMax")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_VPssMaxPu", value)
        value = gen.parset.get_param_value("powerSystemStabilizer_VstMin")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_VstMin")
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_VPssMinPu", value)
        gen.parset.remove_param_or_ref("powerSystemStabilizer_IC1")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_IC2")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_PNomAlt")
        gen.parset.remove_param_or_ref("powerSystemStabilizer_Upss0Pu")
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsHyGovScrx")
    for gen in gens:
        value = gen.parset.get_param_value("governor_VelMax")
        gen.parset.remove_param_or_ref("governor_VelMax")
        gen.parset.add_param("DOUBLE", "governor_VelMaxPu", value)
        gen.parset.remove_param_or_ref("governor_PNomAlt")
        gen.parset.remove_param_or_ref("governor_SNom")
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsHyGovScrxTfo")
    for gen in gens:
        value = gen.parset.get_param_value("governor_VelMax")
        gen.parset.remove_param_or_ref("governor_VelMax")
        gen.parset.add_param("DOUBLE", "governor_VelMaxPu", value)
        gen.parset.remove_param_or_ref("governor_PNomAlt")
        gen.parset.remove_param_or_ref("governor_SNom")
