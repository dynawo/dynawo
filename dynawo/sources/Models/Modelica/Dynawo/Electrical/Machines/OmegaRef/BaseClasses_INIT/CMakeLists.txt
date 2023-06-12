# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.

# Generator base initialization models that are based on OmegaRef for the frequency handling

set(MODEL_FILES
  package.mo
  package.order
  BaseGeneratorSynchronous_INIT.mo
  BaseGeneratorSynchronousExt_INIT.mo
  BaseGeneratorSynchronousExt3W_INIT.mo
  BaseGeneratorSynchronousExt4W_INIT.mo
  BaseGeneratorSynchronousInt_INIT.mo
  MdPPuEfdNomCalculation.mo
  RotorPositionEstimation.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
