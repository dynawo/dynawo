within Dynawo.Examples.DynamicLineTests;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPD0.5-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model test "Node fault on a line and a dynamic line between two infinite bus"

  import Modelica;
  import Dynawo;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends Icons.Example;

  parameter Types.PerUnit CPu = 3.75e-5;
  parameter Types.PerUnit RPu = 0.00375;
  parameter Types.PerUnit LPu = 0.0375;
  parameter Types.PerUnit GPu = 0.000375;

  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0.1, UPu = 1.01645) annotation(
    Placement(visible = true, transformation(origin = {80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 1.01779) annotation(
    Placement(visible = true, transformation(origin = {-80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.001, XPu = 0.001, tBegin = 1, tEnd = 1 + 0.5) annotation(
    Placement(visible = true, transformation(origin = {70, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = CPu, GPu = GPu, RPu = RPu, XPu = LPu) annotation(
    Placement(visible = true, transformation(origin = {-16, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = CPu, GPu = GPu, RPu = RPu, XPu = LPu) annotation(
    Placement(visible = true, transformation(origin = {32, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine dynamicLine(CPu = CPu, GPu = GPu, LPu = LPu, RPu = RPu) annotation(
    Placement(visible = true, transformation(origin = {-30, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus2(UPhase = 0, UPu = 1.01779) annotation(
    Placement(visible = true, transformation(origin = {-90, -68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus3(UPhase = 0.1, UPu = 1.01645) annotation(
    Placement(visible = true, transformation(origin = {82, -62}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0.001, XPu = 0.001, tBegin = 1, tEnd = 1 + 0.5) annotation(
    Placement(visible = true, transformation(origin = {20, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine dynamicLine1(CPu = CPu, GPu = GPu, LPu = LPu, RPu = RPu) annotation(
    Placement(visible = true, transformation(origin = {32, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine dynamicLine2(CPu = CPu, GPu = GPu, LPu = LPu, RPu = RPu) annotation(
    Placement(visible = true, transformation(origin = {-2, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  dynamicLine.omegaPu = 1;
  dynamicLine1.omegaPu = 1;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  dynamicLine.switchOffSignal1.value = false;
  dynamicLine.switchOffSignal2.value = false;
  dynamicLine1.switchOffSignal1.value = false;
  dynamicLine1.switchOffSignal2.value = false;
  connect(infiniteBus1.terminal, line.terminal1) annotation(
    Line(points = {{-80, -20}, {-53, -20}, {-53, -18}, {-26, -18}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, 6}, {-6, 6}, {-6, -18}}, color = {0, 0, 255}));
  connect(line.terminal2, line1.terminal1) annotation(
    Line(points = {{-6, -18}, {13, -18}, {13, -16}, {22, -16}}, color = {0, 0, 255}));
  connect(line1.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{42, -16}, {62, -16}, {62, -20}, {80, -20}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, dynamicLine.terminal2) annotation(
    Line(points = {{20, -42}, {-20, -42}, {-20, -68}}, color = {0, 0, 255}));
  connect(dynamicLine.terminal1, infiniteBus2.terminal) annotation(
    Line(points = {{-40, -68}, {-90, -68}}, color = {0, 0, 255}));
  connect(dynamicLine1.terminal2, infiniteBus3.terminal) annotation(
    Line(points = {{42, -68}, {54, -68}, {54, -62}, {82, -62}}, color = {0, 0, 255}));
  connect(dynamicLine.terminal2, dynamicLine1.terminal1) annotation(
    Line(points = {{-20, -68}, {22, -68}}, color = {0, 0, 255}));
  connect(dynamicLine.terminal1, dynamicLine2.terminal1) annotation(
    Line(points = {{-40, -68}, {-40, -86}, {-12, -86}}, color = {0, 0, 255}));
  connect(dynamicLine2.terminal2, dynamicLine1.terminal2) annotation(
    Line(points = {{8, -86}, {42, -86}, {42, -68}}, color = {0, 0, 255}));


   annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
This test shows the difference between dynamic and phasor lines for a fault apparition by simulating a node fault for a line with two infinite bus.
</body></html>"));
end test;
