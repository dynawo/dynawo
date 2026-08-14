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

# update 3 unit dynamic model names in modelica models and model templates
@ticket(3593)
def update(jobs):
    udms = list()
    for mm in jobs.dyds.get_modelica_models(lambda _: True):
        udms.extend(mm.get_unit_dynamic_models(lambda _: True))

    for mt in jobs.dyds.get_model_templates(lambda _: True):
        udms.extend(mt.get_unit_dynamic_models(lambda _: True))

    for udm in udms:
        update_name(udm,"Dynawo.Electrical.Wind.WECC","WTG4ACurrentSource","WTG4ACurrentSource1")
        update_name(udm,"Dynawo.Electrical.Controls.WECC.Mechanical","DriveTrainPmConstant","WTGTa")
        update_name(udm,"Dynawo.Electrical.Controls.WECC.Mechanical","DriveTrainPeFiltered","WTGTb")

    for windxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "WTG4AWeccCurrentSource"):
        windxml.set_lib_name("WTG4AWeccCurrentSource1")

def update_name(udm,prefix,old,new):
    if udm.get_name() == prefix+"."+old:
        udm.set_name(prefix+"."+new)
