within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
  */

block FirstOrderVariableLimitsAntiWindup "First order filter with absolute and rate limits, and a freezing flag"
  extends Modelica.Blocks.Icons.Block;
  
  parameter Types.PerUnit DyMax "Maximum rising slew rate of output";
  parameter Types.PerUnit DyMin = -DyMax "Maximum falling slew rate of output";
  parameter Types.Time tI "Filter time constant in s";
  
  Modelica.Blocks.Interfaces.RealInput yMax "Upper limit of output" annotation(
    Placement(visible = true, transformation(origin = {-220, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput yMin "Lower limit of output" annotation(
    Placement(visible = true, transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / tI) annotation(
    Placement(visible = true, transformation(origin = {-74, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = DyMax, uMin = DyMin) annotation(
    Placement(visible = true, transformation(origin = {-34, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {66, -2}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {16, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {108, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-138, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {160, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Y0 "Initial value of output";

equation
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-63, -2}, {-46, -2}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-101, -2}, {-86, -2}}, color = {0, 0, 127}));
  connect(freeze, switch1.u2) annotation(
    Line(points = {{0, 120}, {0, -2}, {54, -2}}, color = {255, 0, 255}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{27, -24}, {36, -24}, {36, -10}, {54, -10}}, color = {0, 0, 127}));
  connect(limiter.y, switch1.u3) annotation(
    Line(points = {{-23, -2}, {16, -2}, {16, 6}, {54, 6}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback.u1) annotation(
    Line(points = {{-127, -2}, {-119, -2}}, color = {0, 0, 127}));
  connect(switch1.y, integrator.u) annotation(
    Line(points = {{77, -2}, {95, -2}}, color = {0, 0, 127}));
  connect(integrator.y, feedback.u2) annotation(
    Line(points = {{119, -2}, {131, -2}, {131, -58}, {-111, -58}, {-111, -10}}, color = {0, 0, 127}));
  connect(integrator.y, variableLimiter1.u) annotation(
    Line(points = {{119, -2}, {147, -2}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, y) annotation(
    Line(points = {{171, -2}, {189.5, -2}, {189.5, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(u, variableLimiter.u) annotation(
    Line(points = {{-220, 0}, {-150, 0}, {-150, -2}}, color = {0, 0, 127}));
  connect(yMax, variableLimiter.limit1) annotation(
    Line(points = {{-220, 60}, {-160, 60}, {-160, 6}, {-150, 6}}, color = {0, 0, 127}));
  connect(variableLimiter1.limit1, yMax) annotation(
    Line(points = {{148, 6}, {138, 6}, {138, 60}, {-220, 60}}, color = {0, 0, 127}));
  connect(yMin, variableLimiter.limit2) annotation(
    Line(points = {{-220, -60}, {-160, -60}, {-160, -10}, {-150, -10}}, color = {0, 0, 127}));
  connect(yMin, variableLimiter1.limit2) annotation(
    Line(points = {{-220, -60}, {140, -60}, {140, -10}, {148, -10}}, color = {0, 0, 127}));
  
  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {-40, 1.06}, points = {{-40, -121.057}, {20, 118.943}}), Line(origin = {40, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {20, 118.943}, {60, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {12, 28}, extent = {{-44, 34}, {26, -16}}, textString = "1"), Text(origin = {2, -44}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT"), Line(origin = {4, 0}, points = {{-86, 0}, {86, 0}})}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end FirstOrderVariableLimitsAntiWindup;
