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
  # EMT models
  package.mo
  package.order
  PwPin.mo
  TwoPin.mo
  TwoPort.mo
  SignalVoltage.mo
  RLBranchDisym.mo
  CParallel.mo
  Ground.mo
  VoltageSensor.mo
  RVariable.mo
  Bus.mo
  Ideal.mo
  Circuit_RLC.mo
  ISGT.mo
  IEEE_14bus.mo
  GFf_Load_InfBus.mo
  GFf_Load_InfBus_shunt.mo
  PQLoad.mo
  PQLoad_Circuit.mo
  IEEE_5bus.mo
  IEEE_5bus_modular.mo
  GridFeedingConverter.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
