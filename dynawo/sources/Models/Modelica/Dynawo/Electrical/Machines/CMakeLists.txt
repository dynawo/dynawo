# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Machines models

set(MODEL_FILES
    package.mo
    BaseClasses.mo
    BaseClasses_INIT.mo
    GeneratorFictitious.mo
    GeneratorFictitious.extvar
    GeneratorFictitious_INIT.mo
    GeneratorPQ.mo
    GeneratorPQ.extvar
    GeneratorPQ_INIT.mo
    GeneratorPV.mo
    GeneratorPV.extvar
    GeneratorPV_INIT.mo
    GeneratorSynchronous.mo
    GeneratorSynchronous.extvar
    GeneratorSynchronousInt_INIT.mo
    GeneratorSynchronousExt_4E_INIT.mo
    GeneratorSynchronousExt_3E_INIT.mo
    GeneratorSynchronousIntTfo_INIT.mo
    GeneratorSynchronousExtTfo_4E_INIT.mo
    GeneratorSynchronousExtTfo_3E_INIT.mo
    SwitchOffGenerator.extvar
    )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_file(${MODEL_FILE})
endforeach( MODEL_FILE )
