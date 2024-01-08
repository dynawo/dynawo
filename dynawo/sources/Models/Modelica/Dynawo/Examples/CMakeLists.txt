# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(BaseClasses B)
add_subdirectory(SMIB S)
add_subdirectory(ENTSOE E)
add_subdirectory(GridForming G)
add_subdirectory(HVDC H)
add_subdirectory(Nordic N)
add_subdirectory(RVS R)
add_subdirectory(SVarC SV)
add_subdirectory(BESS BE)
add_subdirectory(Photovoltaics P)
add_subdirectory(Wind W)
add_subdirectory(DynaFlow DF)

set(MODEL_FILES
  package.mo
  package.order
  Overview.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
