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

# update unit dynamic model names in modelica models and model templates
@ticket(3443)
def update(jobs):
    udms = list()
    for mm in jobs.dyds.get_modelica_models(lambda _: True):
        udms.extend(mm.get_unit_dynamic_models(lambda _: True))

    for mt in jobs.dyds.get_model_templates(lambda _: True):
        udms.extend(mt.get_unit_dynamic_models(lambda _: True))

    for udm in udms:
        update_name(udm,"Dynawo.Electrical.BESS.WECC","BESScbCurrentSource","BESSCurrentSource")
        update_name(udm,"Dynawo.Electrical.BESS.WECC","BESScbCurrentSourceNoPlantControl","BESSCurrentSourceNoPlantControl")
        update_name(udm,"Dynawo.Electrical.Photovoltaics.WECC","PVCurrentSourceB","PVCurrentSource")
        update_name(udm,"Dynawo.Electrical.Photovoltaics.WECC","PVCurrentSourceBNoPlantControl","PVCurrentSourceNoPlantControl")
        update_name(udm,"Dynawo.Electrical.Photovoltaics.WECC","PVVoltageSourceA","PVVoltageSource1")
        update_name(udm,"Dynawo.Electrical.Photovoltaics.WECC","PVVoltageSourceANoPlantControl","PVVoltageSource1NoPlantcontrol")
        update_name(udm,"Dynawo.Electrical.Photovoltaics.WECC","PVVoltageSourceB","PVVoltageSource2")
        update_name(udm,"Dynawo.Electrical.Photovoltaics.WECC","PVVoltageSourceBNoPlantControl","PVVoltageSource2NoPlantControl")

    for bessxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "BESScbWeccCurrentSource"):
        bessxml.set_lib_name("BESSWeccCurrentSource")
    for bessxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "BESScbWeccCurrentSourceNoPlantControl"):
        bessxml.set_lib_name("BESSWeccCurrentSourceNoPlantControlSource")
    for pvxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccCurrentSourceB"):
        pvxml.set_lib_name("PhotovoltaicsWeccCurrentSource")
    for pvxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccCurrentSourceBNoPlantControl"):
        pvxml.set_lib_name("PhotovoltaicsWeccCurrentSourceNoPlantControl")
    for pvxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccVoltageSourceA"):
        pvxml.set_lib_name("PhotovoltaicsWeccVoltageSource1")
    for pvxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccVoltageSourceANoPlantControl"):
        pvxml.set_lib_name("PhotovoltaicsWeccVoltageSource1NoPlantControl")
    for pvxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccVoltageSourceB"):
        pvxml.set_lib_name("PhotovoltaicsWeccVoltageSource2")
    for pvxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "PhotovoltaicsWeccVoltageSourceBNoPlantControl"):
        pvxml.set_lib_name("PhotovoltaicsWeccVoltageSource2NoPlantControl")

    for lib_name in ["WTG3WeccCurrentSource1","WTG3WeccCurrentSource2"]:
        for wtg3 in jobs.dyds.get_bbms(lambda bbm: lib_name in bbm.get_lib_name()):
            wtg3.parset.add_param("BOOL", "WTG3_Lvplsw", False)
            wtg3.parset.add_param("DOUBLE", "WTG3_zerox", 0.1)
            wtg3.parset.add_param("DOUBLE", "WTG3_brkpt", 0.05)
            wtg3.parset.add_param("DOUBLE", "WTG3_lvpl1", 1.22)

    for wtg4b in jobs.dyds.get_bbms(lambda bbm: "WTG4BWeccCurrentSource" in bbm.get_lib_name()):
        wtg4b.parset.add_param("BOOL", "WTG4B_Lvplsw", False)
        wtg4b.parset.add_param("DOUBLE", "WTG4B_zerox", 0.1)
        wtg4b.parset.add_param("DOUBLE", "WTG4B_brkpt", 0.05)
        wtg4b.parset.add_param("DOUBLE", "WTG4B_lvpl1", 1.22)

    for wtg4a in jobs.dyds.get_bbms(lambda bbm: "WTG4AWeccCurrentSource" in bbm.get_lib_name()):
        wtg4a.parset.add_param("BOOL", "WTG4A_Lvplsw", False)
        wtg4a.parset.add_param("DOUBLE", "WTG4A_zerox", 0.1)
        wtg4a.parset.add_param("DOUBLE", "WTG4A_brkpt", 0.05)
        wtg4a.parset.add_param("DOUBLE", "WTG4A_lvpl1", 1.22)

    for wt4b in jobs.dyds.get_bbms(lambda bbm: "WT4BWeccCurrentSource" in bbm.get_lib_name()):
        wt4b.parset.add_param("BOOL", "WT4B_Lvplsw", False)
        wt4b.parset.add_param("DOUBLE", "WT4B_zerox", 0.1)
        wt4b.parset.add_param("DOUBLE", "WT4B_brkpt", 0.05)
        wt4b.parset.add_param("DOUBLE", "WT4B_lvpl1", 1.22)

    for wt4a in jobs.dyds.get_bbms(lambda bbm: "WT4AWeccCurrentSource" in bbm.get_lib_name()):
        wt4a.parset.add_param("BOOL", "WT4A_Lvplsw", False)
        wt4a.parset.add_param("DOUBLE", "WT4A_zerox", 0.1)
        wt4a.parset.add_param("DOUBLE", "WT4A_brkpt", 0.05)
        wt4a.parset.add_param("DOUBLE", "WT4A_lvpl1", 1.22)

    for bess in jobs.dyds.get_bbms(lambda bbm: "BESSWeccCurrentSource" in bbm.get_lib_name()):
        bess.parset.add_param("BOOL", "BESS_Lvplsw", False)
        bess.parset.add_param("DOUBLE", "BESS_zerox", 0.1)
        bess.parset.add_param("DOUBLE", "BESS_brkpt", 0.05)
        bess.parset.add_param("DOUBLE", "BESS_lvpl1", 1.22)

def update_name(udm,prefix,old,new):
    if udm.get_name() == prefix+"."+old:
        udm.set_name(prefix+"."+new)
