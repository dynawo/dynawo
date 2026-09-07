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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block AbsLimRateLimFirstOrderAntiWindup "First order filter with absolute and rate limits, and an anti-windup loop"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit DyMax "Maximum rising slew rate of output";
  parameter Types.PerUnit DyMin = -DyMax "Maximum falling slew rate of output";
  parameter Types.PerUnit Kaw "Antiwindup gain";
  parameter Types.Time tI "Filter time constant in s";
  parameter Boolean UseLimits = false "True if the limits of the output are variable" annotation(
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));
  parameter Types.PerUnit YMax "Upper limit of output";
  parameter Types.PerUnit YMin = -YMax "Lower limit of output";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput yMax if UseLimits "Upper limit of output" annotation(
    Placement(visible = true, transformation(origin = {-220, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput yMin if UseLimits "Lower limit of output" annotation(
    Placement(visible = true, transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain(k = 1 / tI) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = DyMax, uMin = DyMin) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add(k2 = Kaw) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Y0 "Initial value of output";

protected
  Modelica.Blocks.Interfaces.RealOutput yMaxLocal annotation(
    HideResult = true);
  Modelica.Blocks.Interfaces.RealOutput yMinLocal annotation(
    HideResult = true);

equation
  if UseLimits then
    connect(yMax, yMaxLocal);
    connect(yMin, yMinLocal);
  else
    yMaxLocal = YMax;
    yMinLocal = YMin;
  end if;

  connect(gain.y, limiter.u) annotation(
    Line(points = {{-99, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(u, feedback.u1) annotation(
    Line(points = {{-220, 0}, {-168, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-151, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, y) annotation(
    Line(points = {{121, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(integrator.y, variableLimiter.u) annotation(
    Line(points = {{61, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback.u2) annotation(
    Line(points = {{121, 0}, {180, 0}, {180, -60}, {-160, -60}, {-160, -8}}, color = {0, 0, 127}));
  connect(yMaxLocal, variableLimiter.limit1);
  connect(yMinLocal, variableLimiter.limit2);
  connect(variableLimiter.y, feedback1.u1) annotation(
    Line(points = {{122, 0}, {140, 0}, {140, -40}, {88, -40}}, color = {0, 0, 127}));
  connect(integrator.y, feedback1.u2) annotation(
    Line(points = {{62, 0}, {80, 0}, {80, -32}}, color = {0, 0, 127}));
  connect(add.y, integrator.u) annotation(
    Line(points = {{22, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(limiter.y, add.u1) annotation(
    Line(points = {{-38, 0}, {-20, 0}, {-20, 6}, {-2, 6}}, color = {0, 0, 127}));
  connect(feedback1.y, add.u2) annotation(
    Line(points = {{71, -40}, {-20, -40}, {-20, -6}, {-2, -6}}, color = {0, 0, 127}));

  annotation(
  preferredView = "diagram",
  Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {-40, 1.06}, points = {{-40, -121.057}, {20, 118.943}}), Line(origin = {40, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {20, 118.943}, {60, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {12, 28}, extent = {{-44, 34}, {26, -16}}, textString = "1"), Text(origin = {2, -44}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT"), Line(origin = {4, 0}, points = {{-86, 0}, {86, 0}})}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}}), graphics = {Line(origin = {-52, 34}, points = {{-148, 26}, {142, 26}, {142, -26}, {148, -26}}, pattern = LinePattern.Dot), Line(origin = {-51, -34}, points = {{-149, -26}, {141, -26}, {141, 26}, {149, 26}}, pattern = LinePattern.Dot)}));
end AbsLimRateLimFirstOrderAntiWindup;
