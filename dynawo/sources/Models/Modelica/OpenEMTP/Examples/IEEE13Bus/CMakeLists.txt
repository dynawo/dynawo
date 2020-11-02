# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

#Adding subdirectories to the build

set(MODEL_FILES
    package.mo
    CpHistoryTerm.mo
    IdealBreaker.mo
    IdealUnit.mo
    IEEE13Node.mo
    MultiphaseBreaker.mo
    multiPhaseCP.mo
    Norton.mo
    PlugToPlug.mo
    PlugToPlug_a.mo
    PlugToPlug_ac.mo
    PlugToPlug_bc.mo
    PlugToPlug_c.mo
    ThreePhaseRL.mo
    UnsatSTC_XFMR.mo
    YgYg.mo
    )
#
# Installing models (MODEL_FILE iterator through the MODEL_FILES array)
#
foreach( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_file(${MODEL_FILE})
endforeach( MODEL_FILE )
