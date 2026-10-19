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

# IEC WPP models : create distinct lead-lag parameters for each communication module
@ticket(4237)
def update(jobs):
    iecs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "IECWPP4ACurrentSource2020" or bbm.get_lib_name() == "IECWPP4BCurrentSource2020")
    for iec in iecs:
        tLag = iec.parset.get_param_value("WPP_tLag")
        tLead = iec.parset.get_param_value("WPP_tLead")
        iec.parset.remove_param_or_ref("WPP_tLag")
        iec.parset.remove_param_or_ref("WPP_tLead")
        iec.parset.add_param("DOUBLE", "WPP_tLagM", tLag)
        iec.parset.add_param("DOUBLE", "WPP_tLagPD", tLag)
        iec.parset.add_param("DOUBLE", "WPP_tLagRef", tLag)
        iec.parset.add_param("DOUBLE", "WPP_tLeadM", tLead)
        iec.parset.add_param("DOUBLE", "WPP_tLeadPD", tLead)
        iec.parset.add_param("DOUBLE", "WPP_tLeadRef", tLead)
