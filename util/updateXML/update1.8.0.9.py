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
def update(jobs):
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

    add_rename_params("BESS",jobs.dyds.get_bbms(lambda bbm: "BESSWecc" in bbm.get_lib_name() and "NoPlantControl" not in bbm.get_lib_name()))
    add_rename_params("photovoltaics",jobs.dyds.get_bbms(lambda bbm: "PhotovoltaicsWecc" in bbm.get_lib_name() and "NoPlantControl" not in bbm.get_lib_name()))
    add_rename_params("WT3",jobs.dyds.get_bbms(lambda bbm: "WeccWT3" in bbm.get_lib_name()))
    add_rename_params("WT4A",jobs.dyds.get_bbms(lambda bbm: "WT4AWecc" in bbm.get_lib_name()))
    add_rename_params("WT4B",jobs.dyds.get_bbms(lambda bbm: "WT4BWecc" in bbm.get_lib_name()))
    add_rename_params("WTG3",jobs.dyds.get_bbms(lambda bbm: "WTG3Wecc" in bbm.get_lib_name()))
    add_rename_params("WTG4A",jobs.dyds.get_bbms(lambda bbm: "WTG4AWecc" in bbm.get_lib_name()))
    add_rename_params("WTG4B",jobs.dyds.get_bbms(lambda bbm: "WTG4BWecc" in bbm.get_lib_name()))

    hvrt = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "HVRTWecc")
    for bbm in hvrt:
        for idx in ["1", "2"]:
            opp_idx = str(3-int(idx))
            for connect in bbm.connects.get_connects("hvrt_UMonitoredPu",idx):
                if connect.attrib['var' + opp_idx].endswith("_measurements_UPu"):
                    var_name = connect.attrib['var' + opp_idx]
                    connect.attrib['var' + opp_idx] = var_name.replace("measurements","LvMeasurements")

    lvrt = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LVRTWecc")
    for bbm in lvrt:
        for idx in ["1", "2"]:
            opp_idx = str(3-int(idx))
            for connect in bbm.connects.get_connects("lvrt_UMonitoredPu",idx):
                if connect.attrib['var' + opp_idx].endswith("_measurements_UPu"):
                    var_name = connect.attrib['var' + opp_idx]
                    connect.attrib['var' + opp_idx] = var_name.replace("measurements","HvMeasurements")

def add_rename_params(instance,weccs):
    for wecc in weccs:
        if wecc.parset.check_if_ref_exists(instance + "_P0Pu"):
            wecc.parset.add_ref("DOUBLE", instance + "_PPcc0Pu", "IIDM", "p_pu")
        else:
            value = wecc.parset.get_param_value(instance + "_P0Pu")
            wecc.parset.add_param("DOUBLE", instance + "_PPcc0Pu", value)

        if wecc.parset.check_if_ref_exists(instance + "_Q0Pu"):
            wecc.parset.add_ref("DOUBLE", instance + "_QPcc0Pu", "IIDM", "q_pu")
        else:
            value = wecc.parset.get_param_value(instance + "_Q0Pu")
            wecc.parset.add_param("DOUBLE", instance + "_QPcc0Pu", value)

        if wecc.parset.check_if_ref_exists(instance + "_U0Pu"):
            wecc.parset.add_ref("DOUBLE", instance + "_UPcc0Pu", "IIDM", "v_pu")
        else:
            value = wecc.parset.get_param_value(instance + "_U0Pu")
            wecc.parset.add_param("DOUBLE", instance + "_UPcc0Pu", value)

        if wecc.parset.check_if_ref_exists(instance + "_UPhase0"):
            wecc.parset.add_ref("DOUBLE", instance + "_UPhasePcc0", "IIDM", "angle_pu")
        else:
            value = wecc.parset.get_param_value(instance + "_UPhase0")
            wecc.parset.add_param("DOUBLE", instance + "_UPhasePcc0", value)

        value = wecc.parset.get_param_value(instance + "_RPu")
        wecc.parset.remove_param_or_ref(instance + "_RPu")
        wecc.parset.add_param("DOUBLE", instance + "_RMvHvPu", value)
        value = wecc.parset.get_param_value(instance + "_XPu")
        wecc.parset.remove_param_or_ref(instance + "_XPu")
        wecc.parset.add_param("DOUBLE", instance + "_XMvHvPu", value)
        wecc.parset.add_param("DOUBLE", instance + "_RLvTrPu", 0)
        wecc.parset.add_param("DOUBLE", instance + "_XLvTrPu", 0)
        wecc.parset.add_param("DOUBLE", instance + "_BMvHvPu", 0)
        wecc.parset.add_param("DOUBLE", instance + "_GMvHvPu", 0)
        wecc.parset.add_param("BOOL", instance + "_PPCLocal", True)
        wecc.parset.add_param("BOOL", instance + "_ConverterLVControl", True)
        if (wecc.static_refs.get_number_of_static_ref() > 0 or wecc.static_refs.get_number_of_macro_static_ref() > 0):
            wecc.static_refs.remove_static_ref(instance + "_measurements_PPuSnRef")
            wecc.static_refs.add_static_ref(instance + "_HvMeasurements_PPuSnRef", "p")
            wecc.static_refs.remove_static_ref(instance + "_measurements_QPuSnRef")
            wecc.static_refs.add_static_ref(instance + "_HvMeasurements_QPuSnRef", "q")
