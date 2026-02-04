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
  ElectronicLoad.extvar
  ElectronicLoad.mandatoryParam
  ElectronicLoad.mo
  Load_INIT.mo
  Load_INIT.mandatoryParam
  LoadAlphaBeta.mo
  LoadAlphaBeta.extvar
  LoadAlphaBeta.mandatoryParam
  LoadAlphaBetaFrequencyDependent.mo
  LoadAlphaBetaFrequencyDependent.extvar
  LoadAlphaBetaFrequencyDependent.mandatoryParam
  LoadAlphaBetaRestorative.mo
  LoadAlphaBetaRestorative.extvar
  LoadAlphaBetaRestorative.mandatoryParam
  LoadAlphaBetaRestorativeNetwork.mo
  LoadAlphaBetaRestorativeNetwork.extvar
  LoadAlphaBetaRestorativeNetwork.mandatoryParam
  LoadAlphaBetaRestorativeLimitsRecalc_INIT.mo
  LoadAlphaBetaRestorativeLimitsRecalc_INIT.mandatoryParam
  LoadAlphaBetaRestorativeReset.mo
  LoadAlphaBetaRestorativeReset.extvar
  LoadAlphaBetaMotorFifthOrder.mo
  LoadAlphaBetaMotorFifthOrder.extvar
  LoadAlphaBetaMotorFifthOrder.mandatoryParam
  LoadAlphaBetaMotorFifthOrder_INIT.mo
  LoadAlphaBetaMotorFifthOrder_INIT.mandatoryParam
  LoadAlphaBetaThreeMotorFifthOrder.mo
  LoadAlphaBetaThreeMotorFifthOrder.extvar
  LoadAlphaBetaThreeMotorFifthOrder.mandatoryParam
  LoadAlphaBetaThreeMotorFifthOrder_INIT.mo
  LoadAlphaBetaThreeMotorFifthOrder_INIT.mandatoryParam
  LoadAlphaBetaTwoMotorFifthOrder.mo
  LoadAlphaBetaTwoMotorFifthOrder.extvar
  LoadAlphaBetaTwoMotorFifthOrder.mandatoryParam
  LoadAlphaBetaTwoMotorFifthOrder_INIT.mo
  LoadAlphaBetaTwoMotorFifthOrder_INIT.mandatoryParam
  LoadAlphaBetaMotorSimplified.mo
  LoadAlphaBetaMotorSimplified.extvar
  LoadAlphaBetaMotorSimplified.mandatoryParam
  LoadAlphaBetaMotorSimplified_INIT.mo
  LoadAlphaBetaMotorSimplified_INIT.mandatoryParam
  LoadAlphaBetaTwoMotorSimplified.mo
  LoadAlphaBetaTwoMotorSimplified.extvar
  LoadAlphaBetaTwoMotorSimplified.mandatoryParam
  LoadAlphaBetaTwoMotorSimplified_INIT.mo
  LoadAlphaBetaTwoMotorSimplified_INIT.mandatoryParam
  LoadAuxiliaries_INIT.mo
  LoadAuxiliaries_INIT.mandatoryParam
  LoadConnect_INIT.mo
  LoadPF_INIT.mo
  LoadPQ.mo
  LoadPQ.extvar
  LoadPQ.mandatoryParam
  LoadZIP.mo
  LoadZIP.extvar
  LoadZIP.mandatoryParam
  LoadZIPFrequencyDependent.mo
  LoadZIPFrequencyDependent.extvar
  LoadZIPFrequencyDependent.mandatoryParam
  SwitchOffLoad.extvar
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)

