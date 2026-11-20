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

# Convert parameter RefFlag from a Boolean into an Integer

@ticket(3583)
def update(jobs):
    names = ["BESSWecc", "PhotovoltaicsWecc", "WT4AWecc", "WT4BWecc", "WTG3Wecc", "WTG4AWecc", "WTG4BWecc"]

    prefixes = ["BESS", "photovoltaics", "WT4A", "WT4B", "WTG3", "WTG4A", "WTG4B"]

    index = 0
    for name in names:
      prefixes = param_prefix[index]
      bbms = jobs.dyds.get_bbms(lambda bbm: name in bbm.get_lib_name())
      for bbm in bbms:
        value = bbm.parset.get_param_value(prefix + "_RefFlag")
        bbm.parset.remove_param_or_ref(prefix + "_RefFlag")
        bbm.parset.add_param("INT", prefix + "_RefFlag", if value = true then 1 else 0)
      index += 1
