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

# Base initialization models of controls for transformers

set(MODEL_FILES
  package.mo
  package.order
  BaseTapChanger_INIT.mo
  BaseTapChangerPhaseShifter_INIT.mo
  BaseTapChangerPhaseShifterInterval_INIT.mo
  BaseTapChangerPhaseShifterMax_INIT.mo
  BaseTapChangerPhaseShifterTarget_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
