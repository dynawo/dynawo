# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODEL_FILES
    # Sources models
    package.mo
    RateLimFirstOrder_freeze.mo
    RateLimFirstOrder_freeze.extvar
    Voltage_check.mo
    Voltage_check.extvar
    CurrentLimitLogic.mo
    CurrentLimitLogic.extvar
    LimPID_freeze.mo
    LimPID_freeze.extvar
    VarLimPID_freeze.mo
    VarLimPID_freeze.extvar
    Integrator_setFreeze.mo
    calcUPCC.mo
    U_dq_ref.mo
    DQ_Transformation.mo
    DQ_BackTransformation.mo
    FallingEdge_delay.mo
    VSourceRef.mo
    )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_file(${MODEL_FILE})
endforeach( MODEL_FILE )
