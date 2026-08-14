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

# Static VAR compensators : mode_value -> mode
@ticket(3748)
def update(jobs):
    svarcs = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "StaticVarCompensator" in bbm.get_lib_name() and "ModeHandling" in bbm.get_lib_name())}
    for svarc in svarcs:
        if (svarc.static_refs.get_number_of_static_ref() > 0 or svarc.static_refs.get_number_of_macro_static_ref() > 0):
            svarc.static_refs.change_static_ref_var_name("SVarC_modeHandling_mode_value", "SVarC_modeHandling_mode")
