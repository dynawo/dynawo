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

# change path for transformers and update LoadTwoTransformersTapChanger and LoadOneTransformerTapChanger
@ticket(3585)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.GeneratorTransformer"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.GeneratorTransformer")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.GeneratorTransformer_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.GeneratorTransformer_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.NetworkTransformer"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.NetworkTransformer")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.NetworkTransformer_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.NetworkTransformer_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerFixedRatio"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerFixedRatioAndPhase"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatioAndPhase")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerFixedRatioAndPhase_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatioAndPhase_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.IdealTransformerVariableTap"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.IdealTransformerVariableTap")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.IdealTransformerVariableTapPQ_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.IdealTransformerVariableTapPQ_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.IdealTransformerVariableTapI_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.IdealTransformerVariableTapI_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerPhaseTapChanger"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerPhaseTapChanger")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerPhaseTapChanger_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerPhaseTapChanger_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerRatioTapChanger"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerRatioTapChanger")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerRatioTapChanger_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerRatioTapChanger_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerVariableTap"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTap")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerVariableTapXtdPu"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTapXtdPu")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerVariableTapPQ_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTapPQ_INIT")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerVariableTapI_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTapI_INIT")

    model_templates = jobs.dyds.get_model_templates(lambda _: True)
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.GeneratorTransformer"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.GeneratorTransformer")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.GeneratorTransformer_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.GeneratorTransformer_INIT")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.NetworkTransformer"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.NetworkTransformer")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.NetworkTransformer_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.NetworkTransformer_INIT")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerFixedRatio"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerFixedRatioAndPhase"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatioAndPhase")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerFixedRatioAndPhase_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatioAndPhase_INIT")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.IdealTransformerVariableTap"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.IdealTransformerVariableTap")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.IdealTransformerVariableTapPQ_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.IdealTransformerVariableTapPQ_INIT")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.IdealTransformerVariableTapI_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.IdealTransformerVariableTapI_INIT")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerPhaseTapChanger"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerPhaseTapChanger")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerPhaseTapChanger_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerPhaseTapChanger_INIT")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerRatioTapChanger"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerRatioTapChanger")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerRatioTapChanger_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerRatioTapChanger_INIT")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerVariableTap"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTap")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerVariableTapXtdPu"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTapXtdPu")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerVariableTapPQ_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTapPQ_INIT")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Transformers.TransformerVariableTapI_INIT"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTapI_INIT")

    tfos = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadTwoTransformersTapChangers")
    for tfo in tfos:
        if tfo.parset.check_if_param_exists("tapChangerD_UDeadBand"):
            value = tfo.parset.get_param_value("tapChangerD_UDeadBand")
            tfo.parset.remove_param_or_ref("tapChangerD_UDeadBand")
            tfo.parset.add_param("DOUBLE", "transformerD_UDeadBand", value)
            value = tfo.parset.get_param_value("tapChangerD_UTarget")
            tfo.parset.remove_param_or_ref("tapChangerD_UTarget")
            tfo.parset.add_param("DOUBLE", "transformerD_UTarget", value)
            value = tfo.parset.get_param_value("tapChangerD_regulating0")
            tfo.parset.remove_param_or_ref("tapChangerD_regulating0")
            tfo.parset.add_param("BOOL", "transformerD_regulating0", value)
            value = tfo.parset.get_param_value("tapChangerD_t1st")
            tfo.parset.remove_param_or_ref("tapChangerD_t1st")
            tfo.parset.add_param("DOUBLE", "transformerD_t1st", value)
            value = tfo.parset.get_param_value("tapChangerD_tNext")
            tfo.parset.remove_param_or_ref("tapChangerD_tNext")
            tfo.parset.add_param("DOUBLE", "transformerD_tNext", value)
            value = tfo.parset.get_param_value("tapChangerD_tapMax")
            tfo.parset.remove_param_or_ref("tapChangerD_tapMax")
            tfo.parset.add_param("INT", "transformerD_tapMax", value)
            value = tfo.parset.get_param_value("tapChangerD_tapMin")
            tfo.parset.remove_param_or_ref("tapChangerD_tapMin")
            tfo.parset.add_param("INT", "transformerD_tapMin", value)
            value = tfo.parset.get_param_value("tapChangerT_UDeadBand")
            tfo.parset.remove_param_or_ref("tapChangerT_UDeadBand")
            tfo.parset.add_param("DOUBLE", "transformerT_UDeadBand", value)
            value = tfo.parset.get_param_value("tapChangerT_UTarget")
            tfo.parset.remove_param_or_ref("tapChangerT_UTarget")
            tfo.parset.add_param("DOUBLE", "transformerT_UTarget", value)
            value = tfo.parset.get_param_value("tapChangerT_regulating0")
            tfo.parset.remove_param_or_ref("tapChangerT_regulating0")
            tfo.parset.add_param("BOOL", "transformerT_regulating0", value)
            value = tfo.parset.get_param_value("tapChangerT_t1st")
            tfo.parset.remove_param_or_ref("tapChangerT_t1st")
            tfo.parset.add_param("DOUBLE", "transformerT_t1st", value)
            value = tfo.parset.get_param_value("tapChangerT_tNext")
            tfo.parset.remove_param_or_ref("tapChangerT_tNext")
            tfo.parset.add_param("DOUBLE", "transformerT_tNext", value)
            value = tfo.parset.get_param_value("tapChangerT_tapMax")
            tfo.parset.remove_param_or_ref("tapChangerT_tapMax")
            tfo.parset.add_param("INT", "transformerT_tapMax", value)
            value = tfo.parset.get_param_value("tapChangerT_tapMin")
            tfo.parset.remove_param_or_ref("tapChangerT_tapMin")
            tfo.parset.add_param("INT", "transformerT_tapMin", value)

    var_to_delete = ["tapChangerT_switchOffSignal1", "tapChangerD_switchOffSignal1"]
    tfos = jobs.dyds.get_bbms(lambda bbm: "LoadTwoTransformersTapChangers" in bbm.get_lib_name())
    for tfo in tfos:
        for var_name in var_to_delete:
            tfo.connects.remove_connect(var_name)

    var_to_update_1 = ["tapChangerD_locked"]
    var_to_update_2 = ["tapChangerT_locked"]
    tfos = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadTwoTransformersTapChangers")
    for tfo in tfos:
        connects = tfo.connects.get_connects()
    for tfo in tfos:
        for var_name in var_to_update_1:
            tfo.connects.change_var_name(var_name, "transformerD_locked")
        for var_name in var_to_update_2:
            tfo.connects.change_var_name(var_name, "transformerT_locked")

    tfos = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadOneTransformerTapChanger")
    for tfo in tfos:
        if tfo.parset.check_if_param_exists("tapChanger_UDeadBand"):
            value = tfo.parset.get_param_value("tapChanger_UDeadBand")
            tfo.parset.remove_param_or_ref("tapChanger_UDeadBand")
            tfo.parset.add_param("DOUBLE", "transformer_UDeadBand", value)
            value = tfo.parset.get_param_value("tapChanger_UTarget")
            tfo.parset.remove_param_or_ref("tapChanger_UTarget")
            tfo.parset.add_param("DOUBLE", "transformer_UTarget", value)
            value = tfo.parset.get_param_value("tapChanger_regulating0")
            tfo.parset.remove_param_or_ref("tapChanger_regulating0")
            tfo.parset.add_param("BOOL", "transformer_regulating0", value)
            value = tfo.parset.get_param_value("tapChanger_t1st")
            tfo.parset.remove_param_or_ref("tapChanger_t1st")
            tfo.parset.add_param("DOUBLE", "transformer_t1st", value)
            value = tfo.parset.get_param_value("tapChanger_tNext")
            tfo.parset.remove_param_or_ref("tapChanger_tNext")
            tfo.parset.add_param("DOUBLE", "transformer_tNext", value)
            value = tfo.parset.get_param_value("tapChanger_tapMax")
            tfo.parset.remove_param_or_ref("tapChanger_tapMax")
            tfo.parset.add_param("INT", "transformer_tapMax", value)
            value = tfo.parset.get_param_value("tapChanger_tapMin")
            tfo.parset.remove_param_or_ref("tapChanger_tapMin")
            tfo.parset.add_param("INT", "transformer_tapMin", value)

    var_to_delete = ["tapChanger_switchOffSignal1"]
    tfos = jobs.dyds.get_bbms(lambda bbm: "LoadOneTransformerTapChanger" in bbm.get_lib_name())
    for tfo in tfos:
        for var_name in var_to_delete:
            tfo.connects.remove_connect(var_name)

    var_to_update = ["tapChanger_locked"]
    tfos = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadOneTransformerTapChanger")
    for tfo in tfos:
        connects = tfo.connects.get_connects()
    for tfo in tfos:
        for var_name in var_to_update:
            tfo.connects.change_var_name(var_name, "transformer_locked")
