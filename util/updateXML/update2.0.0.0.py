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

# remove the "injector" name from .dyd and .crv files

@ticket(4244)
def update(jobs):
    bbm_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "Wecc" in bbm.get_lib_name() \
     or "DERa" in bbm.get_lib_name() or bbm.get_lib_name() == "StaticVarCompensator")}

    remove_injector_name(jobs.dyds, bbm_ids, "injector_switchOffSignal1")
    remove_injector_name(jobs.dyds, bbm_ids, "injector_switchOffSignal2")
    remove_injector_name(jobs.dyds, bbm_ids, "injector_switchOffSignal3")

    ig_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "InertialGrid" \
     or bbm.get_lib_name() == "GridFormingEpri")}

    remove_injector_name(jobs.dyds, ig_ids, "injectorURI_switchOffSignal1")
    remove_injector_name(jobs.dyds, ig_ids, "injectorURI_switchOffSignal2")
    remove_injector_name(jobs.dyds, ig_ids, "injectorURI_switchOffSignal3")

    wppa_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "IECWPP4A" in bbm.get_lib_name())}

    remove_injector_name(jobs.dyds, wppa_ids, "wT4ACurrentSource_wT4Injector_switchOffSignal1")
    remove_injector_name(jobs.dyds, wppa_ids, "wT4ACurrentSource_wT4Injector_switchOffSignal2")
    remove_injector_name(jobs.dyds, wppa_ids, "wT4ACurrentSource_wT4Injector_switchOffSignal3")

    wppb_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "IECWPP4B" in bbm.get_lib_name())}

    remove_injector_name(jobs.dyds, wppb_ids, "wT4BCurrentSource_wT4Injector_switchOffSignal1")
    remove_injector_name(jobs.dyds, wppb_ids, "wT4BCurrentSource_wT4Injector_switchOffSignal2")
    remove_injector_name(jobs.dyds, wppb_ids, "wT4BCurrentSource_wT4Injector_switchOffSignal3")

    wt_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "IECWT4A" in bbm.get_lib_name() \
     or "IECWT4B" in bbm.get_lib_name())}

    remove_injector_name(jobs.dyds, wt_ids, "wT4Injector_switchOffSignal1")
    remove_injector_name(jobs.dyds, wt_ids, "wT4Injector_switchOffSignal2")
    remove_injector_name(jobs.dyds, wt_ids, "wT4Injector_switchOffSignal3")

    hvdc_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: "HvdcVsc" in bbm.get_lib_name())}

    remove_injector_name_hvdc(jobs.dyds, hvdc_ids, "Conv1_switchOffSignal1")
    remove_injector_name_hvdc(jobs.dyds, hvdc_ids, "Conv1_switchOffSignal2")
    remove_injector_name_hvdc(jobs.dyds, hvdc_ids, "Conv1_switchOffSignal3")

    hvdc2_ids = {bbm.get_id() for bbm in jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "HvdcVsc" \
     or bbm.get_lib_name() == "HvdcVscEmulation")}

    remove_injector_name_hvdc(jobs.dyds, hvdc2_ids, "Conv2_switchOffSignal1")
    remove_injector_name_hvdc(jobs.dyds, hvdc2_ids, "Conv2_switchOffSignal2")
    remove_injector_name_hvdc(jobs.dyds, hvdc2_ids, "Conv2_switchOffSignal3")

def remove_injector_name(dyds, bbm_ids, var):
    if not bbm_ids:
        return
    for idx in ["1", "2"]:
        for connect in dyds.get_connects_with_var_for_models(var, idx, bbm_ids):
            connect.attrib['var' + idx] = connect.attrib['var' + idx].replace(str(var), "_switchOffSignal" + str(var)[-1])
    for bbm in bbm_ids:
        bbm.curves.change_variable_name(str(var), "_switchOffSignal" + str(var)[-1])

def remove_injector_name_hvdc(dyds, bbm_ids, var):
    if not bbm_ids:
        return
    for idx in ["1", "2"]:
        for connect in dyds.get_connects_with_var_for_models(var, idx, bbm_ids):
            connect.attrib['var' + idx] = connect.attrib['var' + idx].replace(str(var), "_switchOffSignal" + str(var)[4] + str(var)[-1])
    for bbm in bbm_ids:
        bbm.curves.change_variable_name(str(var), "_switchOffSignal" + str(var)[4] + str(var)[-1])
