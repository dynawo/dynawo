# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.

add_subdirectory(BaseClasses B)

set(MODEL_FILES
  package.mo
  package.order
  ExcIEEEAC1A.mo
  ExcIEEEAC1A.extvar
  ExcIEEEST4B.mo
  ExcIEEEST4B.extvar
  ExcIEEEST4B_INIT.mo
  IEEET1.mo
  IEEET1.extvar
  SCRX.mo
  SCRX.extvar
  SEXS.mo
  SEXS.extvar
  SEXS_INIT.mo
  VRKundur.mo
  VRKundur.extvar
  VRKundur_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
