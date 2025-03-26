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

block AntiWindupIntegrator "Integrator with absolute and rate limits, anti windup and anti winddown"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit DyMax "Maximum rising slew rate of output";
  parameter Types.PerUnit DyMin = -DyMax "Maximum falling slew rate of output";
  parameter Types.Time tI "Integrator time constant in s";
  parameter Types.PerUnit YMax "Upper limit of output";
  parameter Types.PerUnit YMin = -YMax "Lower limit of output";

  Modelica.Blocks.Interfaces.BooleanInput fMax(start = false) "True if anti windup should be applied" annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput fMin(start = false) "True if anti winddown should be applied" annotation(
    Placement(visible = true, transformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain(k = 1 / tI) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = DyMax, uMin = DyMin) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = YMax, uMin = YMin) annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Y0 "Initial value of output";

equation
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-159, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(limiter1.y, y) annotation(
    Line(points = {{181, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(integrator.y, limiter1.u) annotation(
    Line(points = {{141, 0}, {158, 0}}, color = {0, 0, 127}));
  connect(u, gain.u) annotation(
    Line(points = {{-220, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(switch2.y, integrator.u) annotation(
    Line(points = {{81, 0}, {118, 0}}, color = {0, 0, 127}));
  connect(const.y, max1.u2) annotation(
    Line(points = {{-98, -60}, {-90, -60}, {-90, -46}, {-82, -46}}, color = {0, 0, 127}));
  connect(limiter.y, max1.u1) annotation(
    Line(points = {{-119, 0}, {-90, 0}, {-90, -34}, {-82, -34}}, color = {0, 0, 127}));
  connect(fMin, switch1.u2) annotation(
    Line(points = {{0, -120}, {0, -20}, {-60, -20}, {-60, 0}, {-42, 0}}, color = {255, 0, 255}));
  connect(max1.y, switch1.u1) annotation(
    Line(points = {{-59, -40}, {-50, -40}, {-50, -8}, {-42, -8}}, color = {0, 0, 127}));
  connect(limiter.y, switch1.u3) annotation(
    Line(points = {{-119, 0}, {-80, 0}, {-80, 8}, {-42, 8}}, color = {0, 0, 127}));
  connect(switch1.y, switch2.u3) annotation(
    Line(points = {{-18, 0}, {20, 0}, {20, -8}, {58, -8}}, color = {0, 0, 127}));
  connect(switch1.y, min1.u2) annotation(
    Line(points = {{-18, 0}, {-10, 0}, {-10, 44}, {-2, 44}}, color = {0, 0, 127}));
  connect(const.y, min1.u1) annotation(
    Line(points = {{-98, -60}, {-94, -60}, {-94, 56}, {-2, 56}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(min1.y, switch2.u1) annotation(
    Line(points = {{22, 50}, {40, 50}, {40, 8}, {58, 8}}, color = {0, 0, 127}));
  connect(fMax, switch2.u2) annotation(
    Line(points = {{0, 120}, {0, 80}, {32, 80}, {32, 0}, {58, 0}}, color = {255, 0, 255}));

  annotation(
  preferredView = "diagram",
  Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {-40, 1.06}, points = {{-40, -121.057}, {20, 118.943}}), Line(origin = {40, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {20, 118.943}, {60, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {12, 28}, extent = {{-44, 34}, {26, -16}}, textString = "1"), Text(origin = {2, -44}, extent = {{-60, 22}, {60, -22}}, textString = "sT"), Line(origin = {4, 0}, points = {{-86, 0}, {86, 0}})}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end AntiWindupIntegrator;
