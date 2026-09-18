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
import re
# add or remove the "_value" suffix in the connect/initConnect, curve, finalStateValue and
# staticRef statements, for every model and member variable
ARRAY_INDEX_RE = re.compile(r'_(\d+|@INDEX@)$')

@ticket(3741)
def update(jobs):
    for connect in jobs.dyds.get_all_connects():
        for idx in ("1", "2"):
            migrate_attribute(connect, 'var' + idx)

    for curve in jobs.get_all_curves():
        migrate_attribute(curve, 'variable')

    for final_state_value in jobs.get_all_final_state_values():
        migrate_attribute(final_state_value, 'variable')

    for static_ref in jobs.dyds.get_all_static_refs():
        migrate_attribute(static_ref, 'var')


def migrate_attribute(element, attribute_name):
    if attribute_name not in element.attrib:
        return
    var = element.attrib[attribute_name]
    new_var = migrate_var_name(var)
    if new_var != var:
        element.attrib[attribute_name] = new_var


def migrate_var_name(var):
    base = var[:-len("_value")] if var.endswith("_value") else var
    if ARRAY_INDEX_RE.search(base):
        return base + "_"
    return base
