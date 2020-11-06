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
set(MODELICA_PREASSEMBLED_MODELS
    Bus.xml
    Capacitor.xml
    CosineVoltage.xml
    Ground.xml
    #IEEE13Node.xml
    Inductor.xml
    mPhaseCosineVoltage.xml
    Plug_a.xml
    Plug_b.xml
    Plug_c.xml
    Resistor.xml
    Star.xml
    TLM.xml
    ParallelLines.xml
    UnbalancedParallelLine.xml
    )

# PYTHON scripts preassembled models
set(PYTHON_SCRIPTS_PREASSEMBLED_MODELS
    buildChecker.py
    )

install(PROGRAMS ${PYTHON_SCRIPTS_PREASSEMBLED_MODELS} DESTINATION ${SBINDIR_NAME})

foreach( FILE ${MODELICA_PREASSEMBLED_MODELS} )
    compile_preassembled_model(${FILE})
endforeach( FILE )
