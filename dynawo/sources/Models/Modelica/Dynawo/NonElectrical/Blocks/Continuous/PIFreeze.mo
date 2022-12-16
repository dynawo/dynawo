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

block PIFreeze "Proportional-integrator controller with freezing of the state"
  import Modelica;

  extends Modelica.Blocks.Icons.Block;

  parameter Real Gain "Control gain";
  parameter Types.Time tIntegral "Time integration constant";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation (Placement(
        visible = true, transformation(extent = {{-200, -20}, {-160, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation (Placement(
        visible = true, transformation(extent = {{160, -10}, {180, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add(k1 = Gain, k2 = Gain / tIntegral) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1, y_start = Y0 * tIntegral / Gain) annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(visible = true, transformation(origin = {-100, -122}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  parameter Types.PerUnit Y0 = 0 "Initial value of output" annotation(
  Dialog(group="Initialization"));

equation
  connect(integrator.y, add.u2) annotation(
    Line(points = {{22, -20}, {40, -20}, {40, -6}, {59, -6}}, color = {0, 0, 127}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{-79, 20}, {-60, 20}, {-60, -12}, {-42, -12}}, color = {0, 0, 127}));
  connect(switch1.y, integrator.u) annotation(
    Line(points = {{-19, -20}, {-1, -20}}, color = {0, 0, 127}));
  connect(u, switch1.u3) annotation(
    Line(points = {{-180, 0}, {-120, 0}, {-120, -28}, {-42, -28}}, color = {0, 0, 127}));
  connect(u, add.u1) annotation(
    Line(points = {{-180, 0}, {-120, 0}, {-120, 60}, {40, 60}, {40, 6}, {58, 6}}, color = {0, 0, 127}));
  connect(add.y, y) annotation(
    Line(points = {{82, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(switch1.u2, freeze) annotation(
    Line(points = {{-42, -20}, {-100, -20}, {-100, -122}}, color = {255, 0, 255}));

  annotation(
  preferredView = "diagram",
  Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
  Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{60, -100}, {60, -80}}, color = {255, 0, 255}, pattern = LinePattern.Dot), Line(origin = {-14.38, -5.34}, points = {{8, 10}, {8, 0}}), Line(origin = {-7.71, 0}, points = {{-6, 0}, {8, 0}}), Line(origin = {17.67, 0}, points = {{-6, 0}, {56, 0}}), Text(origin = {16, 0}, extent = {{-8, -2}, {60, -60}}, textString = "tIntegral*s"), Text(origin = {18, 0}, extent = {{-8, 60}, {60, 2}}, textString = "Gain"), Text(origin = {-72, -30}, extent = {{-8, 60}, {60, 2}}, textString = "Gain")}),
  Documentation(info = "<html><head></head><body><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">This blocks computes&nbsp;<strong>y</strong>&nbsp;as&nbsp;<em>integral</em>&nbsp;of the input&nbsp;<strong>u</strong>&nbsp;multiplied by &nbsp;<i>Gain</i> and divided by &nbsp;<i>tIntegral </i>plus input <b>u</b> multiplied by <i>Gain</i>. If the integration is halted by the &nbsp;<i>freeze</i> boolean, only the proportional contribution is considered.</p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The integrator is initialized with the value&nbsp;<em>Y0.</em></p></body></html>"));
end PIFreeze;
