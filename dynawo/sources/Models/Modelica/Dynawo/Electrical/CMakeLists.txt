# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(Constants Cs)
add_subdirectory(Controls C)
add_subdirectory(Events E)
add_subdirectory(BESS BE)
add_subdirectory(Buses B)
add_subdirectory(Loads L)
add_subdirectory(HVDC H)
add_subdirectory(Machines M)
add_subdirectory(Transformers T)
add_subdirectory(Lines N)
add_subdirectory(PEIR Pe)
add_subdirectory(Sources I)
add_subdirectory(Shunts Q)
add_subdirectory(StaticVarCompensators V)
add_subdirectory(Switches S)
add_subdirectory(Photovoltaics P)
add_subdirectory(Wind W)

set(MODEL_FILES
  package.mo
  package.order
  SystemBase.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
