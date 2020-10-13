# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(CPline C)
add_subdirectory(WBline W)
add_subdirectory(Transformer T)
add_subdirectory(Machine M)
add_subdirectory(IEEE39Bus I39)
add_subdirectory(IEEE13Bus I13)
add_subdirectory(Ferroresonance F)
add_subdirectory(Lightning L)

set(MODEL_FILES
    package.mo
    )
#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_file(${MODEL_FILE})
endforeach( MODEL_FILE )
