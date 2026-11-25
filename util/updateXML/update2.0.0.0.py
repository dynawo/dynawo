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
    # single injector models: <injectorPrefix>_switchOffSignalN -> switchOffSignalN
    single_injector_models = (
        (lambda bbm: "Wecc" in bbm.get_lib_name() or "DERa" in bbm.get_lib_name() or bbm.get_lib_name() == "StaticVarCompensator",
         "injector_"),
        (lambda bbm: bbm.get_lib_name() in ("InertialGrid", "GridFormingEpri"), "injectorURI_"),
        (lambda bbm: "IECWPP4A" in bbm.get_lib_name(), "wT4ACurrentSource_wT4Injector_"),
        (lambda bbm: "IECWPP4B" in bbm.get_lib_name(), "wT4BCurrentSource_wT4Injector_"),
        (lambda bbm: "IECWT4A" in bbm.get_lib_name() or "IECWT4B" in bbm.get_lib_name(), "wT4Injector_"),
    )
    for selector, prefix in single_injector_models:
        bbms = jobs.dyds.get_bbms(selector)
        for num in ("1", "2", "3"):
            rename_var(jobs.dyds, bbms, prefix + "switchOffSignal" + num, "switchOffSignal" + num)

    # two converters models: Conv{side}_switchOffSignalN -> switchOffSignal{side}N
    hvdc_conv1_bbms = jobs.dyds.get_bbms(lambda bbm: "HvdcVsc" in bbm.get_lib_name())
    hvdc_conv2_bbms = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() in ("HvdcVsc", "HvdcVscEmulation"))
    for side, bbms in (("1", hvdc_conv1_bbms), ("2", hvdc_conv2_bbms)):
        for num in ("1", "2", "3"):
            rename_var(jobs.dyds, bbms, "Conv" + side + "_switchOffSignal" + num, "switchOffSignal" + side + num)


def rename_var(dyds, bbms, old_var, new_var):
    """
    Rename a variable of the given black box models in the connects (.dyd) and in the curves (.crv)
    """
    if not bbms:
        return
    bbm_ids = {bbm.get_id() for bbm in bbms}
    for idx in ("1", "2"):
        for connect in dyds.get_connects_with_var_for_models(old_var, idx, bbm_ids):
            connect.attrib['var' + idx] = new_var
    for bbm in bbms:
        bbm.curves.change_variable_name(old_var, new_var)
