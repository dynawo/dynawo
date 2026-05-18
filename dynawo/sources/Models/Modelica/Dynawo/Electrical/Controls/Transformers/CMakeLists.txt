# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Controls for transformers models

add_subdirectory(BaseClasses B)
add_subdirectory(BaseClasses_INIT BI)
add_subdirectory(Images I)

set(MODEL_FILES
  package.mo
  package.order
  PhaseShifterI.mo
  PhaseShifterI.extvar
  PhaseShifterI.mandatoryParam
  PhaseShifterI_INIT.mo
  PhaseShifterI_INIT.mandatoryParam
  PhaseShifterP.mo
  PhaseShifterP.extvar
  PhaseShifterP.mandatoryParam
  PhaseShifterP_INIT.mo
  PhaseShifterP_INIT.mandatoryParam
  TapChanger.mo
  TapChanger.extvar
  TapChanger.mandatoryParam
  TapChanger_INIT.mo
  TapChanger_INIT.mandatoryParam
  TapChangerWithTransformer_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
