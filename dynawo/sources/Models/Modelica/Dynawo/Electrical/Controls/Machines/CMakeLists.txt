# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(Protections P)
add_subdirectory(VoltageRegulators V)
add_subdirectory(Governors G)
add_subdirectory(OverExcitationLimiters O)
add_subdirectory(PowerSystemStabilizers PSS)
add_subdirectory(ReactivePowerControlLoops R)
add_subdirectory(StatorCurrentLimiters S)
add_subdirectory(UnderExcitationLimiters U)

set(MODEL_FILES
  # Machines control models
  package.mo
  package.order
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
