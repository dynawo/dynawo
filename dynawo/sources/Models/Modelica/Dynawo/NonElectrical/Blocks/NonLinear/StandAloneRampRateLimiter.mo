within Dynawo.NonElectrical.Blocks.NonLinear;

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

block StandAloneRampRateLimiter "Slew rate limiter as in IEC N°61400-27-1"
  import Modelica;

  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit DuMax "Maximum rising slew rate";
  parameter Types.PerUnit DuMin = -DuMax "Maximum falling slew rate";
  parameter Types.Time tS "Integration time step in s";
  parameter Types.PerUnit Y0 "Initial value of output";

  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 1.11022e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = tS * DuMax, uMin = tS * DuMin) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = tS) annotation(
    Placement(visible = true, transformation(origin = {50, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(add.y, y) annotation(
    Line(points = {{62, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(limiter.y, add.u1) annotation(
    Line(points = {{2, 0}, {20, 0}, {20, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(fixedDelay.u, add.y) annotation(
    Line(points = {{62, -60}, {80, -60}, {80, 0}, {62, 0}}, color = {0, 0, 127}));
  connect(fixedDelay.y, add.u2) annotation(
    Line(points = {{40, -60}, {20, -60}, {20, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(fixedDelay.y, feedback.u2) annotation(
    Line(points = {{40, -60}, {-60, -60}, {-60, -8}}, color = {0, 0, 127}));
  connect(feedback.y, limiter.u) annotation(
    Line(points = {{-50, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(u, feedback.u1) annotation(
    Line(points = {{-120, 1.77636e-15}, {-68, 1.77636e-15}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 90}, {-8, 68}, {8, 68}, {0, 90}}), Line(points = {{-90, 0}, {68, 0}}, color = {192, 192, 192}), Line(points = {{-50, -70}, {50, 70}}), Line(points = {{0, -90}, {0, 68}}, color = {192, 192, 192}), Line(visible = false, points = {{50, 70}, {-50, -70}}, color = {255, 0, 0}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, 0}, {68, -8}, {68, 8}, {90, 0}})}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end StandAloneRampRateLimiter;
