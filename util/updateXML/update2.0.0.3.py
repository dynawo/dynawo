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

# Convert parameter RefFlag from a Boolean into an Integer, rename VFrz as VFrzPu

@ticket(3583)
def update(jobs):
    names = ["BESSWecc", "PhotovoltaicsWecc", "WT4AWecc", "WT4BWecc", "WTG3Wecc", "WTG4AWecc", "WTG4BWecc"]

    prefixes = ["BESS", "photovoltaics", "WT4A", "WT4B", "WTG3", "WTG4A", "WTG4B"]

    index = 0
    for name in names:
      prefix = prefixes[index]
      bbms = jobs.dyds.get_bbms(lambda bbm: name in bbm.get_lib_name())
      for bbm in bbms:
        value = bbm.parset.get_param_value(prefix + "_RefFlag")
        bbm.parset.remove_param_or_ref(prefix + "_RefFlag")
        bbm.parset.add_param("INT", prefix + "_RefFlag", if value = true then 1 else 0)
        value2 = bbm.parset.get_param_value(prefix + "_VFrz")
        bbm.parset.remove_param_or_ref(prefix + "_VFrz")
        bbm.parset.add_param("DOUBLE", prefix + "_VFrzPu", value2)
      index += 1

    names2 = ["BESSWecc", "PhotovoltaicsWecc", "WT4AWecc", "WT4BWecc"]

    prefixes2 = ["BESS", "photovoltaics", "WT4A", "WT4B"]

    index = 0
    for name in names2:
      prefix = prefixes2[index]
      bbms = jobs.dyds.get_bbms(lambda bbm: name in bbm.get_lib_name() and "NoPlantControl" not in bbm.get_lib_name())
      for bbm in bbms:
        value = bbm.parset.get_param_value(prefix + "_FDbd1Pu")
        bbm.parset.remove_param_or_ref(prefix + "_FDbd1Pu")
        bbm.parset.add_param("DOUBLE", prefix + "_FDbd1Pu", -value)
      index += 1
