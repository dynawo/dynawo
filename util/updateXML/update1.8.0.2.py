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
    tfo_prefix = "Dynawo.Electrical.Transformers."

    fixed_tap_tfos = ["GeneratorTransformer",
                      "GeneratorTransformer_INIT",
                      "NetworkTransformer",
                      "NetworkTransformer_INIT",
                      "TransformerFixedRatio",
                      "TransformerFixedRatioAndPhase",
                      "TransformerFixedRatioAndPhase_INIT"]

    variable_tap_tfos = ["IdealTransformerVariableTap",
                        "IdealTransformerVariableTapPQ_INIT",
                        "IdealTransformerVariableTapI_INIT",
                        "TransformerPhaseTapChanger",
                        "TransformerPhaseTapChanger_INIT",
                        "TransformerRatioTapChanger",
                        "TransformerRatioTapChanger_INIT",
                        "TransformerVariableTap",
                        "TransformerVariableTapXtdPu",
                        "TransformerVariableTapPQ_INIT",
                        "TransformerVariableTapI_INIT"]

    udms = list()
    for mm in jobs.dyds.get_modelica_models(lambda _: True):
        udms.extend(mm.get_unit_dynamic_models(lambda _: True))

    for mt in jobs.dyds.get_model_templates(lambda _: True):
        udms.extend(mt.get_unit_dynamic_models(lambda _: True))

    for udm in udms:
        sep_idx = udm.get_name().rfind(".")
        if sep_idx < 0 or udm.get_name()[:sep_idx+1] != tfo_prefix: # not of the form "Dynawo.Electrical.Transformers." + shortname
            continue
        shortname = udm.get_name()[sep_idx+1:]

        if shortname in fixed_tap_tfos:
            udm.set_name(tfo_prefix+"TransformersFixedTap."+shortname)
        elif shortname in variable_tap_tfos:
            udm.set_name(tfo_prefix+"TransformersVariableTap."+shortname)

    tfos = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadTwoTransformersTapChangers")
    for tfo in tfos:
        if tfo.parset.check_if_param_exists("tapChangerD_UDeadBand"):
            rename_params(tfo,"D")
            rename_params(tfo,"T")

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
            rename_params(tfo,"")

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

def rename_params(tfo,DT):
    rename_param(tfo,DT,"UDeadBand","DOUBLE")
    rename_param(tfo,DT,"UTarget","DOUBLE")
    rename_param(tfo,DT,"regulating0","BOOL")
    rename_param(tfo,DT,"t1st","DOUBLE")
    rename_param(tfo,DT,"tNext","DOUBLE")
    rename_param(tfo,DT,"tapMax","INT")
    rename_param(tfo,DT,"tapMin","INT")

def rename_param(tfo,DT,name,type_str):
    old_name = "tapChanger"+DT+"_"+name
    new_name = "transformer"+DT+"_"+name
    value = tfo.parset.get_param_value(old_name)
    tfo.parset.remove_param_or_ref(old_name)
    tfo.parset.add_param(type_str, new_name, value)
