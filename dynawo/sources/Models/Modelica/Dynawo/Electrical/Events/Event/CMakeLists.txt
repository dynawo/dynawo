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

set(MODEL_FILES
  package.mo
  package.order
  EventEquations.mo
  EventBoolean.mo
  EventReal.mo
  EventInteger.mo
  SingleBooleanEvent.mo
  SingleBooleanEvent.mandatoryParam
  DoubleBooleanEvent.mo
  TripleBooleanEvent.mo
  SingleRealEvent.mo
  SingleRealEvent.mandatoryParam
  DoubleRealEvent.mo
  DoubleRealEvent.mandatoryParam
  TripleRealEvent.mo
  SingleIntegerEvent.mo
  EventQuadripoleStatus.mo
  EventQuadripoleConnection.mo
  EventQuadripoleConnection.mandatoryParam
  EventQuadripoleDisconnection.mo
  EventQuadripoleDisconnection.mandatoryParam
  EventConnectedStatus.mo
  EventConnectedStatus.mandatoryParam
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
