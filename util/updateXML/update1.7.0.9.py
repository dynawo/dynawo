# -*- coding: utf-8 -*-

# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.
from content.Ticket import ticket

# Add UDeadBandPu in secondary voltage control simplified models
@ticket(3546)
def update(jobs):
    SVCs = jobs.dyds.get_bbms(lambda bbm: "SecondaryVoltageControlSimp" in bbm.get_lib_name())
    for svc in SVCs:
        if not svc.parset.check_if_param_exists("secondaryVoltageControl_UDeadBandPu"):
            svc.parset.add_param("DOUBLE", "secondaryVoltageControl_UDeadBandPu", 0.0001)
