# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# 
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Preassembled models

SET(MODELICA_PREASSEMBLED_MODELS
    CurrentLimitAutomaton.xml
    EVT_QUADRIPOLE_CONNECTION.xml
    EVT_QUADRIPOLE_DISCONNECTION.xml
    EVT_CONNECTED_STATUS.xml
    EVT_SET_POINT_BOOL.xml
    EVT_SET_POINT_DOUBLE.xml
    EVT_SET_POINT_TWO_DOUBLES.xml
    EVT_SET_POINT_LOAD.xml
    EVT_SET_POINT_GEN.xml
    GeneratorFictitious.xml
    GenericAutomaton.xml
    LOAD_ALPHA_BETA.xml
    LoadOneTransformer.xml
    LoadTwoTransformers.xml
    MACHINE_4W_NOREGUL.xml
    MACHINE_PQ.xml
    MACHINE_PV.xml
    PHASE_SHIFTER_I.xml
    PHASE_SHIFTER_P.xml
    SET_POINT.xml
    TapChangerAutomaton.xml
    TapChangerBlockingArea.xml
   )

# PYTHON scripts preassembled models
SET(PYTHON_SCRIPTS_PREASSEMBLED_MODELS
  buildChecker.py
  depChecker.py
  )

INSTALL(PROGRAMS ${PYTHON_SCRIPTS_PREASSEMBLED_MODELS} DESTINATION ${sbindir})

FOREACH( FILE ${MODELICA_PREASSEMBLED_MODELS} )
    COMPILE_PREASSEMBLED_MODEL(${FILE})
ENDFOREACH( FILE )
