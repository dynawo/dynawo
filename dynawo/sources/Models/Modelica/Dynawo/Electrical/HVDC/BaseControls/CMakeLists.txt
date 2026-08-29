# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

set(MODEL_FILES
  package.mo
  package.order
  ACEmulation.mo
  ACEmulation_INIT.mo
  ACEmulation_INIT.mandatoryParam
  ACEmulationSet_INIT.mo
  ACEmulationSet_INIT.mandatoryParam
  ACEmulation.extvar
  ACEmulation.mandatoryParam
  ACEmulationVariableK.mo
  ACEmulationVariableK_INIT.mo
  ACEmulationVariableK_INIT.mandatoryParam
  ACEmulationVariableK.extvar
  ACEmulationVariableK.mandatoryParam
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
