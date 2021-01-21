# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

SET(MODEL_FILES
    # Converter control elements models
    package.mo
    package.order
    CurrentLoop.mo
    CurrentLoop.extvar
    VoltageLoop.mo
    VoltageLoop.extvar
    DCVoltageControl.mo
    DCVoltageControl.extvar
    VirtualImpedance.mo
    VirtualImpedance.extvar
    DroopControl.mo
    DroopControl.extvar
    MatchingControl.mo
    MatchingControl.extvar
    DispatchableVirtualOscillatorControl.mo
    DispatchableVirtualOscillatorControl.extvar
    )

#
# Modelica models install
#
FOREACH( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_FILE(${MODEL_FILE})
ENDFOREACH( MODEL_FILE )
