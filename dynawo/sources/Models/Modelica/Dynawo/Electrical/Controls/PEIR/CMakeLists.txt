# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(BaseControls B)
add_subdirectory(Converters C)
add_subdirectory(Plants P)

set(MODEL_FILES
  # PEIR control models
  package.mo
  package.order
  GridFormingControlDroopControl.mo
  GridFormingControlDroopControl.extvar
  GridFormingControlMatchingControl.mo
  GridFormingControlMatchingControl.extvar
  GridFormingControlDispatchableVirtualOscillatorControl.mo
  GridFormingControlDispatchableVirtualOscillatorControl.extvar
  GridFormingControl_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
