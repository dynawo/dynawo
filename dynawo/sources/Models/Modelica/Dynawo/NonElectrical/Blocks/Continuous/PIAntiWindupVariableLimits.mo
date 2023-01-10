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

block PIAntiWindupVariableLimits "Anti windup proportional integral controller with variable limits"

  import Modelica;
  import Dynawo;
  import Modelica.Blocks.Interfaces;
  import Modelica.Blocks.Icons.Block;
  import Modelica.Constants;

  extends Block;

  parameter Types.PerUnit Ki;
  parameter Types.PerUnit Kp;

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(Placement(
        visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));

  Interfaces.RealOutput y "Output signal connector" annotation(Placement(
        transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {29, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Ki, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-9, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-9, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-42, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {42, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput limitMax annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput limitMin annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(integrator.y, add.u2) annotation(
    Line(points = {{2, -6}, {17, -6}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{2, 24}, {12, 24}, {12, 6}, {17, 6}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-31, -6}, {-21, -6}}, color = {0, 0, 127}));
  connect(feedback.y, add1.u2) annotation(
    Line(points = {{33, -40}, {-66, -40}, {-66, -12}, {-54, -12}}, color = {0, 0, 127}));
  connect(u, add1.u1) annotation(
    Line(points = {{-120, 0}, {-54, 0}}, color = {0, 0, 127}));
  connect(u, gain1.u) annotation(
    Line(points = {{-120, 0}, {-62, 0}, {-62, 24}, {-21, 24}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{40, 0}, {70, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, y) annotation(
    Line(points = {{94, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback.u1) annotation(
    Line(points = {{94, 0}, {96, 0}, {96, -40}, {50, -40}}, color = {0, 0, 127}));
  connect(limitMax, variableLimiter.limit1) annotation(
    Line(points = {{-120, 60}, {60, 60}, {60, 8}, {70, 8}, {70, 8}}, color = {0, 0, 127}));
  connect(limitMin, variableLimiter.limit2) annotation(
    Line(points = {{-120, -60}, {66, -60}, {66, -8}, {70, -8}, {70, -8}}, color = {0, 0, 127}));
  connect(add.y, feedback.u2) annotation(
    Line(points = {{40, 0}, {42, 0}, {42, -32}, {42, -32}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
  Diagram(coordinateSystem(initialScale = 0.1)),
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-2, 2}, extent = {{-64, 38}, {64, -38}}, textString = "PI Anti Windup Variable Limits")}));

end PIAntiWindupVariableLimits;
