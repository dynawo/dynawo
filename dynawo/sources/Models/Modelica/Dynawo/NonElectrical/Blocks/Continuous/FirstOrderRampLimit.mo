within Dynawo.NonElectrical.Blocks.Continuous;

block FirstOrderRampLimit "Anti windup proportional integral controller"
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
  import Modelica;
  /*Parameters*/
  parameter Real T(start = 1) "Time Constant";
  parameter Real DuMax "Maximun ramp rate";
  parameter Real DuMin(start = -DuMax) "Minimun ramp rate";
  parameter Real k(unit = "1") = 1 "Integrator gain";
  parameter Real y_start "Initial or guess value of output (= state)";
  parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialState "Type of initialization (1: no init, 2: steady state, 3,4: initial output)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMax annotation(
    Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMin annotation(
    Placement(visible = true, transformation(origin = {-90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Math.Gain gain(k = 1 / T) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = DuMax, uMin = DuMin) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorVariableLimits integratorVariableLimits(y_start = y_start) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
equation
/*Connectors*/
  connect(u, add1.u1) annotation(
    Line(points = {{-90, 0}, {-78, 0}, {-78, 6}, {-72, 6}, {-72, 6}}, color = {0, 0, 127}));
  connect(add1.y, gain.u) annotation(
    Line(points = {{-48, 0}, {-32, 0}, {-32, 0}, {-32, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-8, 0}, {8, 0}, {8, 0}, {8, 0}}, color = {0, 0, 127}));
  connect(limiter.y, integratorVariableLimits.u) annotation(
    Line(points = {{32, 0}, {48, 0}, {48, 0}, {50, 0}}, color = {0, 0, 127}));
  connect(uMin, integratorVariableLimits.uMin) annotation(
    Line(points = {{-90, -60}, {44, -60}, {44, -8}, {50, -8}, {50, -6}}, color = {0, 0, 127}));
  connect(uMax, integratorVariableLimits.uMax) annotation(
    Line(points = {{-90, 60}, {42, 60}, {42, 8}, {50, 8}, {50, 8}}, color = {0, 0, 127}));
  connect(integratorVariableLimits.y, y) annotation(
    Line(points = {{72, 0}, {84, 0}, {84, 0}, {90, 0}}, color = {0, 0, 127}));
  connect(integratorVariableLimits.y, add1.u2) annotation(
    Line(points = {{72, 0}, {74, 0}, {74, -20}, {-78, -20}, {-78, -6}, {-72, -6}, {-72, -6}}, color = {0, 0, 127}));
//
//
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, -30}, extent = {{-90, -20}, {90, 20}}, textString = "Ramp Limit"), Text(origin = {0, 30}, extent = {{-90, -20}, {90, 20}}, textString = "First Order")}, coordinateSystem(extent = {{-80, -80}, {80, 80}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-80, -80}, {80, 80}})));
end FirstOrderRampLimit;
