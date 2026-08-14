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

# Remove U1Ref0Pu parameter from HvdcPV* models
@ticket(3528)
def update(jobs):
    for hvdc in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name().startswith("HvdcPV")):
        if hvdc.parset.check_if_param_exists("hvdc_U1Ref0Pu") or hvdc.parset.check_if_ref_exists("hvdc_U1Ref0Pu"):
            hvdc.parset.remove_param_or_ref("hvdc_U1Ref0Pu")
