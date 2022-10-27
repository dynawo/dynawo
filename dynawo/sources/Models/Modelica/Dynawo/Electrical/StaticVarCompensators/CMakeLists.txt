# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.


add_subdirectory(BaseControls A)

set(MODEL_FILES
  # Voltage control models
  package.mo
  SVarCPV_INIT.mo
  SVarCPV.mo
  SVarCPV.extvar
  SVarCPVModeHandling.mo
  SVarCPVModeHandling.extvar
  SVarCPVRemote.mo
  SVarCPVRemote.extvar
  SVarCPVRemoteModeHandling.mo
  SVarCPVRemoteModeHandling.extvar
  SVarCPVProp.mo
  SVarCPVProp.extvar
  SVarCPVPropModeHandling.mo
  SVarCPVPropModeHandling.extvar
  SVarCPVPropRemote.mo
  SVarCPVPropRemote.extvar
  SVarCPVPropRemoteModeHandling.mo
  SVarCPVPropRemoteModeHandling.extvar
  SVarCStandard.mo
  SVarCStandard.extvar
  SVarCStandard_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
