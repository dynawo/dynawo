# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(Exciters_Governor C)
add_subdirectory(Lines T)
add_subdirectory(Load_Models L)
add_subdirectory(Machines M)
add_subdirectory(Nonlinear N)
add_subdirectory(RLC_Branches R)
add_subdirectory(Sources S)
add_subdirectory(Switches W)
add_subdirectory(Transformers Tr)
# modified this from T to Tr because error in dynawo building


set(MODEL_FILES
    package.mo
    )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    INSTALL_MODEL_file(${MODEL_FILE})
endforeach( MODEL_FILE )
