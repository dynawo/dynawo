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
  # Converter control elements models
  package.mo
  package.order
  PLLGF.mo
  PLL.mo
  PLL.extvar
  Modulation.mo
  Modulation.extvar
  PControl.mo
  PControl.extvar
  QControl.mo
  QControl.extvar
  CurrentLimitation.mo
  CurrentLimitation.extvar
  IECWT4APControl.mo
  IECWT4APControl.extvar
  IECWT4AQControl.mo
  IECWT4AQControl.extvar
  IECWT4AQLimitation.mo
  IECWT4AQLimitation.extvar
  IECWT4ACurrentLimitation.mo
  IECWT4ACurrentLimitation.extvar
  IECWT4ACurrentLimitationAux.mo
  IECQcontrolVDrop.mo
  IECQcontrolVDrop.extvar
  IECWT4AMeasures.mo
  IECWT4AMeasuresAux.mo
  IECWT4AMeasures.extvar
  IECWT4APll.mo
  IECWT4APll.extvar
  IECWP4APControl.mo
  IECWP4APControl.extvar
  IECWP4AQControl.mo
  IECWP4AQControl.extvar
  IECWP4ALinearCommunicationPD.mo
  IECWP4ALinearCommunicationPD.extvar
  IECWP4ALinearCommunicationWPM.mo
  IECWP4ALinearCommunicationWPM.extvar
  IECWP4ALinearCommunicationWPRef.mo
  IECWP4ALinearCommunicationWPRef.extvar
  IECWP4AControlModel.mo
  IECWP4AControlModel.extvar
  IECWT4ACurrentControl.mo
  IECWT4ACurrentControl.extvar
  IECWT4ACurrentControlHani.mo
  IECWT4BPControl.mo
  CurrentLoop.mo
  CurrentLoop.extvar
  VoltageLoop.mo
  VoltageLoop.extvar
  DCVoltageControl.mo
  DCVoltageControl.extvar
  VirtualImpedance.mo
  VirtualImpedance.extvar
  DroopControl.mo
  DroopControl.extvar
  MatchingControl.mo
  MatchingControl.extvar
  DispatchableVirtualOscillatorControl.mo
  DispatchableVirtualOscillatorControl.extvar
  GridProtectionSystem.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
