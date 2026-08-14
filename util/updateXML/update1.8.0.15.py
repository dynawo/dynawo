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

# add ISide1 and ISide2 in staticRef of Line and TransformerFixedRatio
@ticket(3923)
def update(jobs):
    for linexml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "Line"):
        if (linexml.static_refs.get_number_of_static_ref() > 0 or linexml.static_refs.get_number_of_macro_static_ref() > 0):
            linexml.static_refs.add_static_ref("line_ISide1", "i1")
            linexml.static_refs.add_static_ref("line_ISide2", "i2")

    for tfoxml in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "TransformerFixedRatio"):
        if (tfoxml.static_refs.get_number_of_static_ref() > 0 or tfoxml.static_refs.get_number_of_macro_static_ref() > 0):
            tfoxml.static_refs.add_static_ref("transformer_ISide1", "i1")
            tfoxml.static_refs.add_static_ref("transformer_ISide2", "i2")
