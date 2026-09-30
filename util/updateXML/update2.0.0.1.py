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
from content.sources.utils.Common import NETWORK_ID

# Add in the dyd the connection of fault switchOffSignal to the node switchOff

@ticket(4223)
def update(jobs):
    bbm_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "NodeFault" in bbm.get_lib_name())}

    if not bbm_ids:
        return

    nodefault_bbms_by_id = {bbm.get_id(): bbm for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_id() in bbm_ids)}

    all_connects = jobs.dyds.get_all_connects()

    for connect in all_connects:
        id1 = connect.attrib.get("id1")
        id2 = connect.attrib.get("id2")
        var1 = connect.attrib.get("var1", "")
        var2 = connect.attrib.get("var2", "")

        nodefault_id = None
        network_var = None

        # Case 1: NodeFault is on side 1, and fault_terminal is var1
        if id1 in bbm_ids and var1 == "fault_terminal" and id2 == NETWORK_ID:
            nodefault_id = id1
            network_var = var2

        # Case 2: NodeFault is on side 2, and fault_terminal is var2
        elif id2 in bbm_ids and var2 == "fault_terminal" and id1 == NETWORK_ID:
            nodefault_id = id2
            network_var = var1

        if nodefault_id is None or network_var is None:
            continue

        try:
            prefix, suffix = network_var.rsplit("_", 1)
        except ValueError:
            # Unexpected format (no '_' in var name)
            continue

        if suffix != "ACPIN":
            # Only handle AC terminal pins
            continue

        new_network_var = prefix + "_switchOff"

        # Add the new connect:
        fault_bbm = nodefault_bbms_by_id.get(nodefault_id)
        if fault_bbm is None:
            continue

        # Do not add if a switchOff connection already exists
        already_connected = False
        for c in all_connects:
            cid1 = c.attrib.get("id1")
            cid2 = c.attrib.get("id2")
            cvar1 = c.attrib.get("var1", "")
            cvar2 = c.attrib.get("var2", "")
            if (
                cid1 == nodefault_id
                and cvar1 == "fault_switchOffSignal1"
                and cid2 == NETWORK_ID
                and cvar2 == new_network_var
            ) or (
                cid2 == nodefault_id
                and cvar2 == "fault_switchOffSignal1"
                and cid1 == NETWORK_ID
                and cvar1 == new_network_var
            ):
                already_connected = True
                break

        if already_connected:
            continue

        fault_bbm.connects.add_connect("fault_switchOffSignal1", NETWORK_ID, new_network_var)
