within Dynawo.Examples.GridCodeSimulations.BaseSheetSimulations;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseSheetI2
  extends BaseParameters;

  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = UInfPu, UEvtPu = UInfPu, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Electrical.Lines.Line Xcc_a(BPu = 0, GPu = 0, RPu = 0, XPu = XccPu) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

equation
  // Switches
  Xcc_a.switchOffSignal1 = false;
  Xcc_a.switchOffSignal2 = false;

  connect(infiniteBus.terminal, Xcc_a.terminal1) annotation(
    Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram");
end BaseSheetI2;
