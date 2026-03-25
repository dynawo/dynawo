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

model BaseSheetI5
  extends BaseParameters;

  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = UInfPu, UEvtPu = UInfPu, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Electrical.Lines.Line line(RPu = 0, XPu = XbPu, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {-50, 20}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Lines.Line line21(BPu = 0, GPu = 0, RPu = 0, XPu = 3*XbPu*0.99) annotation(
    Placement(transformation(origin = {-64, -20}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line22(BPu = 0, GPu = 0, RPu = 0, XPu = 3*XbPu*0.01) annotation(
    Placement(transformation(origin = {-36, -20}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.0001, tBegin = 2, tEnd = 2.15) annotation(
    Placement(transformation(origin = {-50, -40}, extent = {{-20, 20}, {20, -20}})));

equation
  // Switches
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line21.switchOffSignal1.value = if time < 2.1501 then false else true;
  line21.switchOffSignal2.value = if time < 2.1501 then false else true;
  line22.switchOffSignal1.value = if time < 2.1501 then false else true;
  line22.switchOffSignal2.value = if time < 2.1501 then false else true;

  // If the fault test doesn't run, try changing the switches equations with those below
  //  line21.switchOffSignal1.value = false;
  //  line21.switchOffSignal2.value = false;
  //  line22.switchOffSignal1.value = false;
  //  line22.switchOffSignal2.value = false;
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-100, 0}, {-80, 0}, {-80, 20}, {-70, 20}}, color = {0, 0, 255}));
  connect(line21.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-74, -20}, {-80, -20}, {-80, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(line21.terminal2, line22.terminal1) annotation(
    Line(points = {{-54, -20}, {-46, -20}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line22.terminal1) annotation(
    Line(points = {{-50, -40}, {-50, -20}, {-46, -20}}, color = {0, 0, 255}));

  annotation(
    Diagram);
end BaseSheetI5;
