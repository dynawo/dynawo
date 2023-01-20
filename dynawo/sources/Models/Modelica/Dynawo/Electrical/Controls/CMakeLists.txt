# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(Basics B)
add_subdirectory(Converters I)
add_subdirectory(Current C)
add_subdirectory(Frequency F)
add_subdirectory(Generic G)
add_subdirectory(HVDC H)
add_subdirectory(IEC WT)
add_subdirectory(Loads L)
add_subdirectory(Machines M)
add_subdirectory(PLL P)
add_subdirectory(Transformers T)
add_subdirectory(Utilities U)
add_subdirectory(Voltage V)
add_subdirectory(WECC W)

set(MODEL_FILES
  package.mo
  package.order
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
