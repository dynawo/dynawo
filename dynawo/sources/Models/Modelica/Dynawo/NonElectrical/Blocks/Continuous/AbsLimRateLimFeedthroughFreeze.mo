within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block AbsLimRateLimFeedthroughFreeze "First order filter with absolute and rate limits, and a freezing flag"
  import Modelica;

  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit DyMax "Maximun ramp rate";
  parameter Types.PerUnit DyMin(start = -DyMax) "Minimun ramp rate";
  parameter Types.Time tS "Integration time step in s";
  parameter Types.PerUnit Y0 "Initial value of output";
  parameter Types.PerUnit YMax "Upper limit of output";
  parameter Types.PerUnit YMin = -YMax "Lower limit of output";

  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-120, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = DyMax, uMin = DyMin) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = tS)  annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(freeze, switch1.u2) annotation(
    Line(points = {{0, 120}, {0, 60}, {20, 60}, {20, 0}, {38, 0}}, color = {255, 0, 255}));
  connect(switch1.y, fixedDelay.u) annotation(
    Line(points = {{62, 0}, {80, 0}, {80, 60}, {62, 60}}, color = {0, 0, 127}));
  connect(switch1.y, y) annotation(
    Line(points = {{62, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(fixedDelay.y, switch1.u1) annotation(
    Line(points = {{40, 60}, {30, 60}, {30, 8}, {38, 8}}, color = {0, 0, 127}));
  connect(u, limiter.u) annotation(
    Line(points = {{-120, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(limiter.y, slewRateLimiter.u) annotation(
    Line(points = {{-38, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, switch1.u3) annotation(
    Line(points = {{2, 0}, {10, 0}, {10, -8}, {38, -8}}, color = {0, 0, 127}));

  annotation(
  preferredView = "diagram",
  Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {-40, 1.06}, points = {{-40, -121.057}, {20, 118.943}}), Line(origin = {40, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {20, 118.943}, {60, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {12, 28}, extent = {{-44, 34}, {26, -16}}, textString = "1"), Text(origin = {2, -44}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT"), Line(origin = {4, 0}, points = {{-86, 0}, {86, 0}})}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end AbsLimRateLimFeedthroughFreeze;
