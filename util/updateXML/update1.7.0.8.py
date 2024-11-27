# -*- coding: utf-8 -*-

# Copyright (c) 2024, RTE (http://www.rte-france.com)
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

# Change variables PGenNomPu to PPu and QGenNomPu tp QPu in MeasurementsPQ.mo
@ticket(3470)
def update(jobs):
    IECs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "IECWPP4ACurrentSource2015" or bbm.get_lib_name() == "IECWPP4ACurrentSource2020"
    or bbm.get_lib_name() == "IECWPP4BCurrentSource2015" or bbm.get_lib_name() == "IECWPP4BCurrentSource2020")
    for IEC in IECs:
        IEC.curves.change_variable_name("WPP_wPPControl_measurements_PGenNomPu", "WPP_wPPControl_measurements_PPu")
        IEC.curves.change_variable_name("WPP_wPPControl_measurements_QGenNomPu", "WPP_wPPControl_measurements_QPu")

    IECs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "IECWT4ACurrentSource2015" or bbm.get_lib_name() == "IECWT4ACurrentSource2020"
    or bbm.get_lib_name() == "IECWT4BCurrentSource2015" or bbm.get_lib_name() == "IECWT4BCurrentSource2020")
    for IEC in IECs:
        IEC.curves.change_variable_name("WT_measurementsPQ_PGenNomPu", "WT_measurementsPQ_PPu")
        IEC.curves.change_variable_name("WT_measurementsPQ_QGenNomPu", "WT_measurementsPQ_QPu")
