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

# LoadAuxiliaries_INIT : initConnect : P0Pu -> P0PuVar, Q0Pu -> Q0PuVar
@ticket(3895)
def update(jobs):
#    for aux_xml in jobs.dyds.get_bbms(lambda bbm: "Aux" in bbm.get_lib_name()):
        change_var_name(aux_xml, "P0Pu", "P0PuVar")
        change_var_name(aux_xml, "Q0Pu", "Q0PuVar")
