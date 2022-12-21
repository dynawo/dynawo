within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block PIAntiWindup "Anti windup proportional integral controller"

  import Modelica;
  import Dynawo;
  import Modelica.Blocks.Interfaces;
  import Modelica.Blocks.Icons.Block;
  import Modelica.Constants;

  extends Block;

  parameter Types.PerUnit Ki;
  parameter Types.PerUnit Kp;
  parameter Types.PerUnit uMax;
  parameter Types.PerUnit uMin;

  Interfaces.RealInput u "Input signal connector" annotation(Placement(
        transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Output signal connector" annotation(Placement(
        transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = uMax, uMin = uMin) annotation(
    Placement(visible = true, transformation(origin = {71, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {43, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Ki, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {5, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {5, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-28, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {56, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation

  connect(add.y, limiter1.u) annotation(
    Line(points = {{54, 0}, {59, 0}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{16, -6}, {32, -6}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{16, 24}, {26, 24}, {26, 6}, {32, 6}, {32, 6}}, color = {0, 0, 127}));
  connect(limiter1.y, y) annotation(
    Line(points = {{82, 0}, {100, 0}, {100, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-16, -6}, {-8, -6}, {-8, -6}, {-6, -6}}, color = {0, 0, 127}));
  connect(add.y, feedback.u2) annotation(
    Line(points = {{54, 0}, {56, 0}, {56, -32}, {56, -32}}, color = {0, 0, 127}));
  connect(limiter1.y, feedback.u1) annotation(
    Line(points = {{82, 0}, {86, 0}, {86, -40}, {64, -40}, {64, -40}}, color = {0, 0, 127}));
  connect(feedback.y, add1.u2) annotation(
    Line(points = {{46, -40}, {-52, -40}, {-52, -12}, {-40, -12}, {-40, -12}}, color = {0, 0, 127}));
  connect(u, add1.u1) annotation(
    Line(points = {{-120, 0}, {-42, 0}, {-42, 0}, {-40, 0}}, color = {0, 0, 127}));
  connect(u, gain1.u) annotation(
    Line(points = {{-120, 0}, {-48, 0}, {-48, 24}, {-6, 24}, {-6, 24}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
  Diagram(coordinateSystem(initialScale = 0.1)),
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-2, 2}, extent = {{-64, 38}, {64, -38}}, textString = "PI Anti Windup")}));

end PIAntiWindup;
