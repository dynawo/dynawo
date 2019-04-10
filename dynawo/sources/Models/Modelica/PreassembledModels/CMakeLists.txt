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
    EventConnectedStatus.xml
    EventQuadripoleConnection.xml
    EventQuadripoleDisconnection.xml
    EventSetPointBoolean.xml
    EventSetPointDouble.xml
    EventSetPointGenerator.xml
    EventSetPointLoad.xml
    EventSetPointTwoDoubles.xml
    GeneratorFictitious.xml
    GeneratorPQ.xml
    GeneratorPV.xml
    GeneratorSynchronousFourWindings.xml
    GeneratorSynchronousThreeWindings.xml
    GenericAutomaton.xml
    LoadAlphaBeta.xml
    LoadOneTransformer.xml
    LoadTwoTransformers.xml
    NodeFault.xml
    PhaseShifterI.xml
    PhaseShifterP.xml
    SetPoint.xml
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
