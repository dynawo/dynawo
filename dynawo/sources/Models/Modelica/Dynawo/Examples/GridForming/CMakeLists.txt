# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(Resources R)

set(MODEL_FILES
  package.mo
  package.order
  EpriSmib.mo
  GridForming.mo
  ENTSOE.mo
  ENTSOE2.mo
  ENTSOE3.mo
  ENTSOE4.mo
  ENTSOE5_GFL.mo
  ENTSOE_csGFL.mo
  ENTSOE_DynLine.mo
  ENTSOE_DynVcGFMVSM.mo
  TP_GFL_SMIB.mo
  TP_GFM_Droop_SMIB.mo
  TP_2GFM_Droop.mo
  TP_2GFM_NOFR.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
