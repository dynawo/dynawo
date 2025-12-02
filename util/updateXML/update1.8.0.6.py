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

# Convert parameter RefFlag from a Boolean into an Integer

@ticket(3583)
def update(jobs):
    names = ["BESSWeccCurrentSource", "BESSWeccCurrentSourceNoPlantControl", "PhotovoltaicsWeccCurrentSource", "PhotovoltaicsWeccCurrentSourceNoPlantControl", "PhotovoltaicsWeccVoltageSource1", "PhotovoltaicsWeccVoltageSource1NoPlantControl", "PhotovoltaicsWeccVoltageSource2", "PhotovoltaicsWeccVoltageSource2NoPlantControl", "PhotovoltaicsWeccVoltageSource3", "PhotovoltaicsWeccVoltageSource3NoPlantControl", "PhotovoltaicsWeccVoltageSource4", "PhotovoltaicsWeccVoltageSource4NoPlantControl", "WT4AWeccCurrentSource", "WT4BWeccCurrentSource", "WTG3WeccCurrentSource1", "WTG3WeccCurrentSource2", "WTG4AWeccCurrentSource", "WTG4AWeccCurrentSource1", "WTG4AWeccCurrentSource2", "WTG4BWeccCurrentSource"]

    param_prefix = ["BESS", "BESS", "photovoltaics", "photovoltaics", "photovoltaics", "photovoltaics", "photovoltaics", "photovoltaics", "photovoltaics", "photovoltaics", "photovoltaics", "photovoltaics", "WT4A", "WT4B", "WTG3", "WTG3", "WTG4A", "WTG4A", "WTG4A", "WTG4B"]

    index = 0
    for name in names:
      prefix = param_prefix[index]
      bbms = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == name)
      for bbm in bbms:
        value = bbm.parset.get_param_value(prefix + "_RefFlag")
        bbm.parset.remove_param_or_ref(prefix + "_RefFlag")
        bbm.parset.add_param("INT", prefix + "_RefFlag", if value = true then 1 else 0)
      index += 1
