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

# Change path of BaseDriveTrain, DriveTrainPeFiltered, DriveTrainPmConstant
# Change path and rename ElectricalControlCommon, ElectricalControlPV, ElectricalControlWind, GeneratorControl and PlantControl models,
# Rename ParamsElectricalControl, ParamsGeneratorControl, ParamsPlantcontrol, PVCurrentSource, PVVoltageSource, CurrentLimitsCalculationWind and CurrentLimitsCalculationPV
# Rename PhotovoltaicsWeccCurrentSource.xml and PhotovoltaicsWeccVoltageSource.xml
# Rename parameters HoldIq, PPriority, HoldIpMax, Tiq, UMinPu, UMaxPu, Rrpwr, DPMax, DPMin, Dbd1, Dbd2, Dbd, EMax, EMin, FDbd1, FDbd2, FEMax, FEMin

@ticket(2996)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.BaseControls.BaseDriveTrain"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.BaseClasses.BaseDriveTrain")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.DriveTrainPeFiltered"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.DriveTrainPeFiltered")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.DriveTrainPmConstant"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.DriveTrainPmConstant")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.BaseControls.ElectricalControlCommon"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.ElectricalControlPV"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REEC.REECb")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.ElectricalControlWind"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REEC.REECa")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.GeneratorControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REGC.REGCbCS")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.PlantControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REPC.REPCa")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Parameters.ParamsElectricalControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Parameters.ParamsREEC")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Parameters.ParamsGeneratorControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Parameters.ParamsREGC")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Parameters.ParamsPlantcontrol"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Parameters.ParamsREPC")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.WECC.Photovoltaics.PVCurrentSource"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.WECC.Photovoltaics.PVCurrentSourceB")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.WECC.Photovoltaics.PVVoltageSource"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.WECC.Photovoltaics.PVVoltageSourceB")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.Photovoltaics.WECC.PVCurrentSource"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.Photovoltaics.WECC.PVCurrentSourceB")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.Photovoltaics.WECC.PVVoltageSource"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.Photovoltaics.WECC.PVVoltageSourceB")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationWind"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationA")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationPV"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationB")

    model_templates = jobs.dyds.get_model_templates(lambda _: True)
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.BaseControls.BaseDriveTrain"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.BaseClasses.BaseDriveTrain")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.DriveTrainPeFiltered"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.DriveTrainPeFiltered")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.DriveTrainPmConstant"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Mechanical.DriveTrainPmConstant")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.BaseControls.ElectricalControlCommon"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.ElectricalControlPV"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REEC.REECb")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.ElectricalControlWind"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REEC.REECa")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.GeneratorControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REGC.REGCbCS")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.PlantControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.REPC.REPCa")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Parameters.ParamsElectricalControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Parameters.ParamsREEC")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Parameters.ParamsGeneratorControl"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Parameters.ParamsREGC")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.Parameters.ParamsPlantcontrol"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.Parameters.ParamsREPC")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.WECC.Photovoltaics.PVCurrentSource"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.WECC.Photovoltaics.PVCurrentSourceB")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.WECC.Photovoltaics.PVVoltageSource"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.WECC.Photovoltaics.PVVoltageSourceB")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.Photovoltaics.WECC.PVCurrentSource"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.Photovoltaics.WECC.PVCurrentSourceB")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Examples.Photovoltaics.WECC.PVVoltageSource"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Examples.Photovoltaics.WECC.PVVoltageSourceB")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationWind"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationA")
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationPV"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationB")

    PVxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccCurrentSource")
    for PVxml in PVxmls:
        PVxml.set_lib_name("PhotovoltaicsWeccCurrentSourceB")
    PVxmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccVoltageSource")
    for PVxml in PVxmls:
        PVxml.set_lib_name("PhotovoltaicsWeccVoltageSourceB")

    weccs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccCurrentSourceB" or bbm.get_lib_name() == "PhotovoltaicsWeccVoltageSourceB")
    for weccPV in weccs:
        value = weccPV.parset.get_param_value("photovoltaics_DPMax")
        weccPV.parset.remove_param_or_ref("photovoltaics_DPMax")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_DPMaxPu", value)
        value = weccPV.parset.get_param_value("photovoltaics_DPMin")
        weccPV.parset.remove_param_or_ref("photovoltaics_DPMin")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_DPMinPu", value)
        value = weccPV.parset.get_param_value("photovoltaics_Dbd")
        weccPV.parset.remove_param_or_ref("photovoltaics_Dbd")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_DbdPu", value)
        value = weccPV.parset.get_param_value("photovoltaics_Dbd1")
        weccPV.parset.remove_param_or_ref("photovoltaics_Dbd1")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_Dbd1Pu", value)
        value = weccPV.parset.get_param_value("photovoltaics_Dbd2")
        weccPV.parset.remove_param_or_ref("photovoltaics_Dbd2")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_Dbd2Pu", value)
        value = weccPV.parset.get_param_value("photovoltaics_EMax")
        weccPV.parset.remove_param_or_ref("photovoltaics_EMax")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_EMaxPu", value)
        value = weccPV.parset.get_param_value("photovoltaics_EMin")
        weccPV.parset.remove_param_or_ref("photovoltaics_EMin")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_EMinPu", value)
        value = weccPV.parset.get_param_value("photovoltaics_FDbd1")
        weccPV.parset.remove_param_or_ref("photovoltaics_FDbd1")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_FDbd1Pu", value)
        value = weccPV.parset.get_param_value("photovoltaics_FDbd2")
        weccPV.parset.remove_param_or_ref("photovoltaics_FDbd2")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_FDbd2Pu", value)
        value = weccPV.parset.get_param_value("photovoltaics_FEMax")
        weccPV.parset.remove_param_or_ref("photovoltaics_FEMax")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_FEMaxPu", value)
        value = weccPV.parset.get_param_value("photovoltaics_FEMin")
        weccPV.parset.remove_param_or_ref("photovoltaics_FEMin")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_FEMinPu", value)
        value = weccPV.parset.get_param_value("photovoltaics_Rrpwr")
        weccPV.parset.remove_param_or_ref("photovoltaics_Rrpwr")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_RrpwrPu", value)
        value = weccPV.parset.get_param_value("photovoltaics_PPriority")
        weccPV.parset.remove_param_or_ref("photovoltaics_PPriority")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_PQFlag", value)
        value = weccPV.parset.get_param_value("photovoltaics_Tiq")
        weccPV.parset.remove_param_or_ref("photovoltaics_Tiq")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_tIq", value)
        value = weccPV.parset.get_param_value("photovoltaics_UMaxPu")
        weccPV.parset.remove_param_or_ref("photovoltaics_UMaxPu")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_VUpPi", value)
        value = weccPV.parset.get_param_value("photovoltaics_UMinPu")
        weccPV.parset.remove_param_or_ref("photovoltaics_UMinPu")
        weccPV.parset.add_param("DOUBLE", "photovoltaics_VDipPu", value)

    weccs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "WTG4AWeccCurrentSource")
    for weccWTG4A in weccs:
        value = weccWTG4A.parset.get_param_value("WTG4A_DPMax")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_DPMax")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_DPMaxPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_DPMin")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_DPMin")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_DPMinPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_Dbd")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_Dbd")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_DbdPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_Dbd1")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_Dbd1")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_Dbd1Pu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_Dbd2")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_Dbd2")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_Dbd2Pu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_EMax")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_EMax")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_EMaxPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_EMin")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_EMin")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_EMinPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_FDbd1")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_FDbd1")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_FDbd1Pu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_FDbd2")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_FDbd2")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_FDbd2Pu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_FEMax")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_FEMax")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_FEMaxPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_FEMin")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_FEMin")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_FEMinPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_Rrpwr")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_Rrpwr")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_RrpwrPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_PPriority")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_PPriority")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_PQFlag", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_Tiq")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_Tiq")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_tIq", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_UMaxPu")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_UMaxPu")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_VUpPi", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_UMinPu")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_UMinPu")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_VDipPu", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_HoldIq")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_HoldIq")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_tHoldIq", value)
        value = weccWTG4A.parset.get_param_value("WTG4A_HoldIpMax")
        weccWTG4A.parset.remove_param_or_ref("WTG4A_HoldIpMax")
        weccWTG4A.parset.add_param("DOUBLE", "WTG4A_tHoldIpMax", value)

    weccs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "WTGBWeccCurrentSource")
    for weccWTG4B in weccs:
        value = weccWTG4B.parset.get_param_value("WTG4B_DPMax")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_DPMax")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_DPMaxPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_DPMin")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_DPMin")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_DPMinPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_Dbd")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_Dbd")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_DbdPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_Dbd1")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_Dbd1")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_Dbd1Pu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_Dbd2")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_Dbd2")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_Dbd2Pu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_EMax")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_EMax")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_EMaxPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_EMin")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_EMin")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_EMinPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_FDbd1")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_FDbd1")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_FDbd1Pu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_FDbd2")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_FDbd2")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_FDbd2Pu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_FEMax")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_FEMax")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_FEMaxPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_FEMin")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_FEMin")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_FEMinPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_Rrpwr")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_Rrpwr")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_RrpwrPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_PPriority")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_PPriority")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_PQFlag", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_Tiq")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_Tiq")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_tIq", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_UMaxPu")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_UMaxPu")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_VUpPi", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_UMinPu")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_UMinPu")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_VDipPu", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_HoldIq")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_HoldIq")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_tHoldIq", value)
        value = weccWTG4B.parset.get_param_value("WTG4B_HoldIpMax")
        weccWTG4B.parset.remove_param_or_ref("WTG4B_HoldIpMax")
        weccWTG4B.parset.add_param("DOUBLE", "WTG4B_tHoldIpMax", value)

    weccs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "WT4AWeccCurrentSource")
    for weccWT4A in weccs:
        value = weccWT4A.parset.get_param_value("WT4A_DPMax")
        weccWT4A.parset.remove_param_or_ref("WT4A_DPMax")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_DPMaxPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_DPMin")
        weccWT4A.parset.remove_param_or_ref("WT4A_DPMin")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_DPMinPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_Dbd")
        weccWT4A.parset.remove_param_or_ref("WT4A_Dbd")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_DbdPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_Dbd1")
        weccWT4A.parset.remove_param_or_ref("WT4A_Dbd1")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_Dbd1Pu", value)
        value = weccWT4A.parset.get_param_value("WT4A_Dbd2")
        weccWT4A.parset.remove_param_or_ref("WT4A_Dbd2")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_Dbd2Pu", value)
        value = weccWT4A.parset.get_param_value("WT4A_EMax")
        weccWT4A.parset.remove_param_or_ref("WT4A_EMax")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_EMaxPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_EMin")
        weccWT4A.parset.remove_param_or_ref("WT4A_EMin")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_EMinPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_FDbd1")
        weccWT4A.parset.remove_param_or_ref("WT4A_FDbd1")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_FDbd1Pu", value)
        value = weccWT4A.parset.get_param_value("WT4A_FDbd2")
        weccWT4A.parset.remove_param_or_ref("WT4A_FDbd2")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_FDbd2Pu", value)
        value = weccWT4A.parset.get_param_value("WT4A_FEMax")
        weccWT4A.parset.remove_param_or_ref("WT4A_FEMax")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_FEMaxPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_FEMin")
        weccWT4A.parset.remove_param_or_ref("WT4A_FEMin")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_FEMinPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_Rrpwr")
        weccWT4A.parset.remove_param_or_ref("WT4A_Rrpwr")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_RrpwrPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_PPriority")
        weccWT4A.parset.remove_param_or_ref("WT4A_PPriority")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_PQFlag", value)
        value = weccWT4A.parset.get_param_value("WT4A_Tiq")
        weccWT4A.parset.remove_param_or_ref("WT4A_Tiq")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_tIq", value)
        value = weccWT4A.parset.get_param_value("WT4A_UMaxPu")
        weccWT4A.parset.remove_param_or_ref("WT4A_UMaxPu")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_VUpPi", value)
        value = weccWT4A.parset.get_param_value("WT4A_UMinPu")
        weccWT4A.parset.remove_param_or_ref("WT4A_UMinPu")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_VDipPu", value)
        value = weccWT4A.parset.get_param_value("WT4A_HoldIq")
        weccWT4A.parset.remove_param_or_ref("WT4A_HoldIq")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_tHoldIq", value)
        value = weccWT4A.parset.get_param_value("WT4A_HoldIpMax")
        weccWT4A.parset.remove_param_or_ref("WT4A_HoldIpMax")
        weccWT4A.parset.add_param("DOUBLE", "WT4A_tHoldIpMax", value)

    weccs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "WT4BWeccCurrentSource")
    for weccWT4B in weccs:
        value = weccWT4B.parset.get_param_value("WT4B_DPMax")
        weccWT4B.parset.remove_param_or_ref("WT4B_DPMax")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_DPMaxPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_DPMin")
        weccWT4B.parset.remove_param_or_ref("WT4B_DPMin")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_DPMinPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_Dbd")
        weccWT4B.parset.remove_param_or_ref("WT4B_Dbd")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_DbdPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_Dbd1")
        weccWT4B.parset.remove_param_or_ref("WT4B_Dbd1")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_Dbd1Pu", value)
        value = weccWT4B.parset.get_param_value("WT4B_Dbd2")
        weccWT4B.parset.remove_param_or_ref("WT4B_Dbd2")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_Dbd2Pu", value)
        value = weccWT4B.parset.get_param_value("WT4B_EMax")
        weccWT4B.parset.remove_param_or_ref("WT4B_EMax")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_EMaxPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_EMin")
        weccWT4B.parset.remove_param_or_ref("WT4B_EMin")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_EMinPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_FDbd1")
        weccWT4B.parset.remove_param_or_ref("WT4B_FDbd1")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_FDbd1Pu", value)
        value = weccWT4B.parset.get_param_value("WT4B_FDbd2")
        weccWT4B.parset.remove_param_or_ref("WT4B_FDbd2")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_FDbd2Pu", value)
        value = weccWT4B.parset.get_param_value("WT4B_FEMax")
        weccWT4B.parset.remove_param_or_ref("WT4B_FEMax")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_FEMaxPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_FEMin")
        weccWT4B.parset.remove_param_or_ref("WT4B_FEMin")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_FEMinPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_Rrpwr")
        weccWT4B.parset.remove_param_or_ref("WT4B_Rrpwr")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_RrpwrPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_PPriority")
        weccWT4B.parset.remove_param_or_ref("WT4B_PPriority")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_PQFlag", value)
        value = weccWT4B.parset.get_param_value("WT4B_Tiq")
        weccWT4B.parset.remove_param_or_ref("WT4B_Tiq")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_tIq", value)
        value = weccWT4B.parset.get_param_value("WT4B_UMaxPu")
        weccWT4B.parset.remove_param_or_ref("WT4B_UMaxPu")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_VUpPi", value)
        value = weccWT4B.parset.get_param_value("WT4B_UMinPu")
        weccWT4B.parset.remove_param_or_ref("WT4B_UMinPu")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_VDipPu", value)
        value = weccWT4B.parset.get_param_value("WT4B_HoldIq")
        weccWT4B.parset.remove_param_or_ref("WT4B_HoldIq")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_tHoldIq", value)
        value = weccWT4B.parset.get_param_value("WT4B_HoldIpMax")
        weccWT4B.parset.remove_param_or_ref("WT4B_HoldIpMax")
        weccWT4B.parset.add_param("DOUBLE", "WT4B_tHoldIpMax", value)
