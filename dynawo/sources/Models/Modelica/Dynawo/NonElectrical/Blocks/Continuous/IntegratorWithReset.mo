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

block IntegratorWithReset "Integrator with absolute limits and reset"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.Time tI "Integrator time constant in s";
  parameter Types.PerUnit YMax "Upper limit of output";
  parameter Types.PerUnit YMin = -YMax "Lower limit of output";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput fReset(start = false) "Reset flag, true if yReset should be used" annotation(
    Placement(visible = true, transformation(origin = {-20, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput yReset(start = Y0) "Reset value of output" annotation(
    Placement(visible = true, transformation(origin = {20, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-110, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / tI, y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = YMax, uMin = YMin) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  parameter Types.PerUnit Y0 "Initial value of output";

equation
  connect(integrator.y, limiter.u) annotation(
    Line(points = {{-59, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(switch1.y, y) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(yReset, switch1.u1) annotation(
    Line(points = {{20, -120}, {20, -8}, {58, -8}}, color = {0, 0, 127}));
  connect(fReset, switch1.u2) annotation(
    Line(points = {{-20, -120}, {-20, -60}, {0, -60}, {0, 0}, {58, 0}}, color = {255, 0, 255}));
  connect(limiter.y, switch1.u3) annotation(
    Line(points = {{-18, 0}, {-10, 0}, {-10, 8}, {58, 8}}, color = {0, 0, 127}));
  connect(u, integrator.u) annotation(
    Line(points = {{-120, 0}, {-82, 0}}, color = {0, 0, 127}));

  annotation(
  preferredView = "diagram",
  Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {40, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {20, 118.943}, {60, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {12, 28}, extent = {{-44, 34}, {26, -16}}, textString = "1"), Text(origin = {2, -44}, extent = {{-60, 22}, {60, -22}}, textString = "sT"), Line(origin = {4, 0}, points = {{-86, 0}, {86, 0}})}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end IntegratorWithReset;
