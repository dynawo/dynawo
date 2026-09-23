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

# Base models for SignalN generator models

set(MODEL_FILES
  package.mo
  package.order
  BaseDiagramPQ.mo
  BaseFixedReactiveLimits.mo
  BaseGenerator.mo
  BaseGeneratorSignalN.mo
  BaseGeneratorSignalNDiagramPQ.mo
  BaseGeneratorSignalNFixedReactiveLimits.mo
  BaseGeneratorSignalNSFR.mo
  BaseGeneratorSignalNSFRDiagramPQ.mo
  BaseGeneratorSignalNSFRFixedReactiveLimits.mo
  BasePQProp.mo
  BasePV.mo
  BasePVProp.mo
  BasePVRemote.mo
  BaseQStator.mo
  BaseTfo.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
