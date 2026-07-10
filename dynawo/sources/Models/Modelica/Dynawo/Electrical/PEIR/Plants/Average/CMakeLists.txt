# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.


set(MODEL_FILES
  package.mo
  package.order
  current_loop.mo
  DynLine.mo
  DynLine.extvar
  frst_smib_simulation.mo
  GFLControl.mo
  GFLmodel.mo
  GFLmodel.extvar
  IdealSwitch.mo
  LCDynFilter.mo
  LCnoDynFilter.mo
  MeasurementBlock.mo
  outer_loop_linearized.mo
  outer_loop.mo
  Plant_controller.mo
  pll.mo
  RLDynTrafo.mo
  simulation_weak_grid.mo
  test_dyn.mo
  test_outer_loop_linearized.mo
  test_outer_loop.mo
  TwoConvertersDynamicLine.mo
  TwoConvertersStaticLine_7Hz.mo
  TwoConvertersStaticLine.mo
  TwoConvertersWECC.mo
  TwoConvertersDynamicLine_7Hz.mo
  )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    install_model_file(${MODEL_FILE})
endforeach( MODEL_FILE )
