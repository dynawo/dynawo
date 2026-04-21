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

# rename WECC models
@ticket(4081)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    # BESS
    rename_modelica_model(modelica_models,"Dynawo.Electrical.BESS.WECC.BESSCurrentSource","Dynawo.Electrical.BESS.WECC.BESSPlantCurrentSource")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.BESS.WECC.BESSCurrentSourceNoPlantControl","Dynawo.Electrical.BESS.WECC.BESSInverterCurrentSource")
    # PV
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSource","Dynawo.Electrical.Photovoltaics.WECC.PVPlantCurrentSource")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource1","Dynawo.Electrical.Photovoltaics.WECC.PVPlantVoltageSource1")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource2","Dynawo.Electrical.Photovoltaics.WECC.PVPlantVoltageSource2")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource3","Dynawo.Electrical.Photovoltaics.WECC.PVPlantVoltageSource3")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4","Dynawo.Electrical.Photovoltaics.WECC.PVPlantVoltageSource4")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSourceNoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterCurrentSource")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource1NoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource1")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource2NoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource2")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource3NoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource3")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4NoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource4")
    # Wind
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Wind.WECC.WTG3CurrentSource1","Dynawo.Electrical.Wind.WECC.WPP3CurrentSource1")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Wind.WECC.WTG3CurrentSource2","Dynawo.Electrical.Wind.WECC.WPP3CurrentSource2")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource1","Dynawo.Electrical.Wind.WECC.WPP4ACurrentSource")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource2","Dynawo.Electrical.Wind.WECC.WPP4ACurrentSource")
    rename_modelica_model(modelica_models,"Dynawo.Electrical.Wind.WECC.WTG4BCurrentSource","Dynawo.Electrical.Wind.WECC.WPP4BCurrentSource")

    model_templates = jobs.dyds.get_model_templates(lambda _: True)
    # BESS
    rename_model_template(model_templates,"Dynawo.Electrical.BESS.WECC.BESSCurrentSource","Dynawo.Electrical.BESS.WECC.BESSPlantCurrentSource")
    rename_model_template(model_templates,"Dynawo.Electrical.BESS.WECC.BESSCurrentSourceNoPlantControl","Dynawo.Electrical.BESS.WECC.BESSInverterCurrentSource")
    # PV
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSource","Dynawo.Electrical.Photovoltaics.WECC.PVPlantCurrentSource")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource1","Dynawo.Electrical.Photovoltaics.WECC.PVPlantVoltageSource1")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource2","Dynawo.Electrical.Photovoltaics.WECC.PVPlantVoltageSource2")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource3","Dynawo.Electrical.Photovoltaics.WECC.PVPlantVoltageSource3")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4","Dynawo.Electrical.Photovoltaics.WECC.PVPlantVoltageSource4")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSourceNoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterCurrentSource")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource1NoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource1")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource2NoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource2")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource3NoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource3")
    rename_model_template(model_templates,"Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4NoPlantControl","Dynawo.Electrical.Photovoltaics.WECC.PVInverterVoltageSource4")
    # Wind
    rename_model_template(model_templates,"Dynawo.Electrical.Wind.WECC.WTG3CurrentSource1","Dynawo.Electrical.Wind.WECC.WPP3CurrentSource1")
    rename_model_template(model_templates,"Dynawo.Electrical.Wind.WECC.WTG3CurrentSource2","Dynawo.Electrical.Wind.WECC.WPP3CurrentSource2")
    rename_model_template(model_templates,"Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource1","Dynawo.Electrical.Wind.WECC.WPP4ACurrentSource")
    rename_model_template(model_templates,"Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource2","Dynawo.Electrical.Wind.WECC.WPP4ACurrentSource")
    rename_model_template(model_templates,"Dynawo.Electrical.Wind.WECC.WTG4BCurrentSource","Dynawo.Electrical.Wind.WECC.WPP4BCurrentSource")

    # BESS
    rename_xml("BESSWeccCurrentSource","WeccBESSPlantCurrentSource")
    rename_xml("BESSWeccCurrentSourceNoPlantControl","WeccBESSInverterCurrentSource")
    # PV
    rename_xml("PhotovoltaicsWeccCurrentSource","WeccPVPlantCurrentSource")
    rename_xml("PhotovoltaicsWeccVoltageSource1","WeccPVPlantVoltageSource1")
    rename_xml("PhotovoltaicsWeccVoltageSource2","WeccPVPlantVoltageSource2")
    rename_xml("PhotovoltaicsWeccVoltageSource3","WeccPVPlantVoltageSource3")
    rename_xml("PhotovoltaicsWeccVoltageSource4","WeccPVPlantVoltageSource4")
    rename_xml("PhotovoltaicsWeccCurrentSourceNoPlantControl","WeccPVInverterCurrentSource")
    rename_xml("PhotovoltaicsWeccVoltageSource1NoPlantControl","WeccPVInverterVoltageSource1")
    rename_xml("PhotovoltaicsWeccVoltageSource2NoPlantControl","WeccPVInverterVoltageSource2")
    rename_xml("PhotovoltaicsWeccVoltageSource3NoPlantControl","WeccPVInverterVoltageSource3")
    rename_xml("PhotovoltaicsWeccVoltageSource4NoPlantControl","WeccPVInverterVoltageSource4")
    # Wind
    rename_xml("WTG3WeccCurrentSource1","WeccWPP3CurrentSource1")
    rename_xml("WTG3WeccCurrentSource2","WeccWPP3CurrentSource2")
    rename_xml("WTG4AWeccCurrentSource1","WeccWPP4ACurrentSource")
    rename_xml("WTG4AWeccCurrentSource2","WeccWPP4ACurrentSource")
    rename_xml("WTG4BWeccCurrentSource","WeccWPP4BCurrentSource")
    rename_xml("WT4AWeccCurrentSource","WeccWT4ACurrentSource")
    rename_xml("WT4BWeccCurrentSource","WeccWT4BCurrentSource")

    for modelica_model in modelica_models:
       unit_dynamic_models = modelica_model.get_unit_dynamic_models(
           lambda unit_dynamic_model: unit_dynamic_model.get_init_name() == "Dynawo.Electrical.Wind.WECC.WT4CurrentSource_INIT")
       for unit_dynamic_model in unit_dynamic_models:
           unit_dynamic_model.set_init_name("Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCInverterCurrentSource_INIT")

def rename_modelica_model(models,old,new):
    for modelica_model in models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == old
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name(new)

def rename_model_template(templates,old,new):
    for model_template in templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == old
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name(new)

def rename_xml(old,new):
    xmls = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == old)
    for xml in xmls:
        xml.set_lib_name(new)
