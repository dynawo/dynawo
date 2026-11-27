# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.


from ..utils.Common import *
from ..Par.Parset import Parset
from .Curves import Curves
from .FinalStateValues import FinalStateValues


class Network:
    """
    Represents the network model

    Attribute
    ----------
    parset : Parset
        parset related to the network
    curves : Curves
        curves data of the jobs
    final_state_values : FinalStateValues
        final state values data of the job
    """
    def __init__(self, parset, curves_collection, final_state_values_collection):
        self.parset = Parset(parset)
        self.curves = Curves(curves_collection, NETWORK_ID)
        self.final_state_values = FinalStateValues(final_state_values_collection, NETWORK_ID)
