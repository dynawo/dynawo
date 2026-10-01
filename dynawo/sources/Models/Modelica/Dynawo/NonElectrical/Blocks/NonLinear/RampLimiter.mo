within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block RampLimiter "Slew rate limiter, simplified from Modelica Standard Library"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit DuMax "Maximum rising slew rate";
  parameter Types.PerUnit DuMin = -DuMax "Maximum falling slew rate";
  parameter Types.Time tS "Integration time step in s";
  parameter Types.PerUnit Y0 "Initial value of output";

  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = DuMax, uMin = DuMin) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / tS) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(u, feedback.u1) annotation(
    Line(points = {{-120, 0}, {-94, 0}, {-94, 0}, {-88, 0}}, color = {0, 0, 127}));
  connect(integrator.y, y) annotation(
    Line(points = {{62, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(integrator.y, feedback.u2) annotation(
    Line(points = {{62, 0}, {80, 0}, {80, -40}, {-80, -40}, {-80, -8}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-70, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-18, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(limiter.y, integrator.u) annotation(
    Line(points = {{22, 0}, {38, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 90}, {-8, 68}, {8, 68}, {0, 90}}), Line(points = {{-90, 0}, {68, 0}}, color = {192, 192, 192}), Line(points = {{-50, -70}, {50, 70}}), Line(points = {{0, -90}, {0, 68}}, color = {192, 192, 192}), Line(visible = false, points = {{50, 70}, {-50, -70}}, color = {255, 0, 0}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, 0}, {68, -8}, {68, 8}, {90, 0}})}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end RampLimiter;
