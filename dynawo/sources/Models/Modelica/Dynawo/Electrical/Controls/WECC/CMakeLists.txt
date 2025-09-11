# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.

add_subdirectory(BaseControls B)
add_subdirectory(Mechanical M)
add_subdirectory(Parameters P)
add_subdirectory(REEC EC)
add_subdirectory(REGC GC)
add_subdirectory(REPC PC)
add_subdirectory(Utilities U)

set(MODEL_FILES
  package.mo
  package.order
  )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    install_model_file(${MODEL_FILE})
endforeach( MODEL_FILE )
