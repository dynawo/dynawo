within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block LimRateLimFirstOrder "First-order filter with non-windup limiter and slew rate limiter"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit DuMax "Maximum rising slew rate";
  parameter Types.PerUnit DuMin = -DuMax "Maximum falling slew rate";
  parameter Types.Time tS "Integration time step in s";
  parameter Real YMax "Upper limit of output signal";
  parameter Real YMin = -YMax "Lower limit of output signal";

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
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = YMax, outMin = YMin, y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Y0 "Initial value of output";

equation
  connect(u, feedback.u1) annotation(
    Line(points = {{-120, 0}, {-94, 0}, {-94, 0}, {-88, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, y) annotation(
    Line(points = {{62, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, feedback.u2) annotation(
    Line(points = {{62, 0}, {80, 0}, {80, -40}, {-80, -40}, {-80, -8}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-70, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-18, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(limiter.y, limIntegrator.u) annotation(
    Line(points = {{22, 0}, {38, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {0, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {42, 118.943}, {80, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {12, 28}, extent = {{-44, 34}, {26, -16}}, textString = "k"), Text(origin = {2, -44}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT"), Line(origin = {4, 0}, points = {{-86, 0}, {86, 0}})}),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">Block to implement a first order filter:</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>y &nbsp; &nbsp; &nbsp; &nbsp; 1</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>- = ---------------</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>u &nbsp; &nbsp; &nbsp;1 + s*tS</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">It is required that tS &gt; 0.</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Both the rate of output variation and the output itself are limited.&nbsp;</div></body></html>"));
end LimRateLimFirstOrder;
