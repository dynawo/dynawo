# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

# Models for static var compensator

add_subdirectory(BaseClasses B)
add_subdirectory(BaseControls BC)

set(MODEL_FILES
  package.mo
  package.order
  SVarCPV_INIT.mo
  SVarCPV_INIT.mandatoryParam
  SVarCPV.mo
  SVarCPV.extvar
  SVarCPV.mandatoryParam
  SVarCPVNoLimits.mo
  SVarCPVNoLimits.extvar
  SVarCPVModeHandling.mo
  SVarCPVModeHandling.extvar
  SVarCPVModeHandling.mandatoryParam
  SVarCPVRemote.mo
  SVarCPVRemote.extvar
  SVarCPVRemote.mandatoryParam
  SVarCPVRemoteModeHandling.mo
  SVarCPVRemoteModeHandling.extvar
  SVarCPVRemoteModeHandling.mandatoryParam
  SVarCPVProp.mo
  SVarCPVProp.extvar
  SVarCPVProp.mandatoryParam
  SVarCPVPropModeHandling.mo
  SVarCPVPropModeHandling.extvar
  SVarCPVPropModeHandling.mandatoryParam
  SVarCPVPropRemote.mo
  SVarCPVPropRemote.extvar
  SVarCPVPropRemote.mandatoryParam
  SVarCPVPropRemoteModeHandling.mo
  SVarCPVPropRemoteModeHandling.extvar
  SVarCPVPropRemoteModeHandling.mandatoryParam
  SVarCStandard.mo
  SVarCStandard.extvar
  SVarCStandard.mandatoryParam
  SVarCStandard_INIT.mo
  SVarCStandard_INIT.mandatoryParam
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
