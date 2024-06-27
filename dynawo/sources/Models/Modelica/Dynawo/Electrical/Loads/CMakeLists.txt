# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Models of electrical loads

add_subdirectory(BaseClasses B)
add_subdirectory(BaseClasses_INIT BI)

set(MODEL_FILES
  package.mo
  package.order
  ElectronicLoad.mo
  ElectronicLoad.extvar
  Load_INIT.mo
  LoadAlphaBeta.mo
  LoadAlphaBeta.extvar
  LoadAlphaBetaRestorative.mo
  LoadAlphaBetaRestorative.extvar
  LoadAlphaBetaRestorativeNetwork.mo
  LoadAlphaBetaRestorativeNetwork.extvar
  LoadAlphaBetaRestorativeLimitsRecalc_INIT.mo
  LoadAlphaBetaRestorativeReset.mo
  LoadAlphaBetaRestorativeReset.extvar
  LoadAlphaBetaMotorFifthOrder.mo
  LoadAlphaBetaMotorFifthOrder.extvar
  LoadAlphaBetaMotorFifthOrder_INIT.mo
  LoadAlphaBetaThreeMotorFifthOrder.mo
  LoadAlphaBetaThreeMotorFifthOrder.extvar
  LoadAlphaBetaThreeMotorFifthOrder_INIT.mo
  LoadAlphaBetaTwoMotorFifthOrder.mo
  LoadAlphaBetaTwoMotorFifthOrder.extvar
  LoadAlphaBetaTwoMotorFifthOrder_INIT.mo
  LoadAlphaBetaMotorSimplified.mo
  LoadAlphaBetaMotorSimplified.extvar
  LoadAlphaBetaMotorSimplified_INIT.mo
  LoadAlphaBetaTwoMotorSimplified.mo
  LoadAlphaBetaTwoMotorSimplified.extvar
  LoadAlphaBetaTwoMotorSimplified_INIT.mo
  LoadAuxiliaries_INIT.mo
  LoadConnect_INIT.mo
  LoadPF_INIT.mo
  LoadPQ.mo
  LoadPQ.extvar
  LoadZIP.mo
  LoadZIP.extvar
  SwitchOffLoad.extvar
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)

