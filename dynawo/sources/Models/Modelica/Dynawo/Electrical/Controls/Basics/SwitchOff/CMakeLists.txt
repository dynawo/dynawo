# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.

# Switch-off models

set(MODEL_FILES
  package.mo
  package.order
  SwitchOffDCLine.mo
  SwitchOffGenerator.mo
  SwitchOffIdealSwitch.mo
  SwitchOffInjector.mo
  SwitchOffLine.mo
  SwitchOffLoad.mo
  SwitchOffLogic.mo
  SwitchOffLogicSide1.mo
  SwitchOffLogicSide2.mo
  SwitchOffMotor.mo
  SwitchOffProtection.mo
  SwitchOffShunt.mo
  SwitchOffTapChangerPhaseShifter.mo
  SwitchOffTransformer.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
