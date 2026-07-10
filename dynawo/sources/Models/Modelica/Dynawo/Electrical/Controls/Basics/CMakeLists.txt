# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(SwitchOff S)

set(MODEL_FILES
  package.mo
  package.order
  BooleanTable.mo
  BooleanTable.mandatoryParam
  CombiTimeTable.mo
  CombiTimeTable.mandatoryParam
  DoubleStep.mo
  DoubleStep.mandatoryParam
  IntegerDoubleStep.mo
  IntegerDoubleStep.mandatoryParam
  IntegerTable.mo
  IntegerTable.mandatoryParam
  Perturbation.mo
  Perturbation.mandatoryParam
  Perturbation_INIT.mo
  SetPoint.mo
  SetPoint.mandatoryParam
  SetPoint_INIT.mo
  SineWave.mo
  SineWave.mandatoryParam
  Step.mo
  Step.mandatoryParam
  Step_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
