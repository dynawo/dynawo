# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(Parameters Pa)
add_subdirectory(AcVoltageControl A)
add_subdirectory(ActivePowerControl P)
add_subdirectory(DcVoltageControl D)
add_subdirectory(BlockingFunction B)
add_subdirectory(LimitsCalculation L)
add_subdirectory(DcLine Dc)

set(MODEL_FILES
  package.mo
  package.order
  ActivePowerControlSide.mo
  ActivePowerControlSideDangling.mo
  DcVoltageControlSide.mo
  DcVoltageControlSideDangling.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
