within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block PI "Proportional-integral controller"
  import Modelica;

  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit Ki "Integrator gain";
  parameter Types.PerUnit Kp "Proportional gain";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(
    Placement(visible = true, transformation(extent = {{-120, -20}, {-80, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(
    Placement(visible = true, transformation(extent = {{80, -10}, {100, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = Kp, k2 = Ki) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Y0 / Ki) annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Y0 = 0 "Initial value of output" annotation(
    Dialog(group="Initialization"));

equation
  connect(add.y, y) annotation(
    Line(points = {{41, 0}, {90, 0}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{-19, -20}, {0, -20}, {0, -6}, {18, -6}}, color = {0, 0, 127}));
  connect(u, integrator.u) annotation(
    Line(points = {{-100, 0}, {-60, 0}, {-60, -20}, {-42, -20}}, color = {0, 0, 127}));
  connect(u, add.u1) annotation(
    Line(points = {{-100, 0}, {-60, 0}, {-60, 20}, {0, 20}, {0, 6}, {18, 6}}, color = {0, 0, 127}));

  annotation(
  preferredView = "diagram",
  Diagram(coordinateSystem(extent = {{-80, -60}, {80, 60}})),
  Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{60, -100}, {60, -80}}, color = {255, 0, 255}, pattern = LinePattern.Dot), Line(origin = {-14.38, -5.34}, points = {{8, 10}, {8, 0}}), Line(origin = {-7.71, 0}, points = {{-6, 0}, {8, 0}}), Line(points = {{80, 0}, {100, 0}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, extent = {{-80, 60}, {80, -60}}), Line(points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {17.67, 0}, points = {{-6, 0}, {56, 0}}), Text(origin = {16, 0}, extent = {{-8, -2}, {60, -60}}, textString = "s"), Text(origin = {18, 0}, extent = {{-8, 60}, {60, 2}}, textString = "Ki"), Text(origin = {-72, -30}, extent = {{-8, 60}, {60, 2}}, textString = "Kp")}),
  Documentation(info = "<html><head></head><body><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">This blocks computes&nbsp;<strong>y</strong>&nbsp;as&nbsp;<em>integral</em>&nbsp;of the input&nbsp;<strong>u</strong>&nbsp;multiplied by gain&nbsp;<i>Ki </i>plus input <b>u</b> multiplied by <i>Kp</i>. </p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The integrator is initialized with&nbsp;<em>Y0.</em></p></body></html>"));
end PI;
