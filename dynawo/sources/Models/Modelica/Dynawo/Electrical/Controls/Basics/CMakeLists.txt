# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODEL_FILES
  package.mo
  package.order
  BooleanTable.mo
  CombiTimeTable.mo
  DoubleStep.mo
  IntegerDoubleStep.mo
  Perturbation.mo
  Perturbation_INIT.mo
  SetPoint.mo
  SetPoint_INIT.mo
  SineWave.mo
  Step.mo
  Step_INIT.mo
  SwitchOff.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
