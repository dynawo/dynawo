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

# IEC WT models : adding the ConverterLVControl and LvTrPu parameters
@ticket(4207)
def update(jobs):
    iecs = jobs.dyds.get_bbms(lambda bbm: "IECWT" in bbm.get_lib_name())
    for iec in iecs:
        iec.parset.add_param("DOUBLE", "WT_ConverterLVControl", False)
        B = iec.parset.get_param_value("WT_BesPu")
        G = iec.parset.get_param_value("WT_GesPu")
        R = iec.parset.get_param_value("WT_ResPu")
        X = iec.parset.get_param_value("WT_XesPu")
        parset.remove_param_or_ref("WT_BesPu")
        parset.remove_param_or_ref("WT_GesPu")
        parset.remove_param_or_ref("WT_ResPu")
        parset.remove_param_or_ref("WT_XesPu")
        iec.parset.add_param("DOUBLE", "WT_BLvTrPu", B)
        iec.parset.add_param("DOUBLE", "WT_GLvTrPu", G)
        iec.parset.add_param("DOUBLE", "WT_RLvTrPu", R)
        iec.parset.add_param("DOUBLE", "WT_XLvTrPu", X)
