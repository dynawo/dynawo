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

# Remove unused IEC INIT models
@ticket(3989)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda _: True)
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(lambda unit_dynamic_model:
            unit_dynamic_model.get_init_name() == "Dynawo.Electrical.Wind.IEC.WPP.WPP4CurrentSource2015_INIT" or \
            unit_dynamic_model.get_init_name() == "Dynawo.Electrical.Wind.IEC.WPP.WPP4CurrentSource2020_INIT" or \
            unit_dynamic_model.get_init_name() == "Dynawo.Electrical.Wind.IEC.WT.WT4CurrentSource_INIT")
        for unit_dynamic_model in unit_dynamic_models:
            del unit_dynamic_model.attrib['initName']
