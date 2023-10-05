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

block PIAntiWindupVariableLimits "Anti-windup proportional integral controller with variable limits"
  extends Dynawo.NonElectrical.Blocks.Continuous.BaseClasses.BasePIAntiWindup;

  Modelica.Blocks.Interfaces.RealInput limitMax "Maximum output of controller" annotation(
    Placement(visible = true, transformation(origin = {-160, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput limitMin "Minimum output of controller" annotation(
    Placement(visible = true, transformation(origin = {-160, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{22, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, y) annotation(
    Line(points = {{102, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback1.u1) annotation(
    Line(points = {{102, 0}, {120, 0}, {120, -60}, {48, -60}}, color = {0, 0, 127}));
  connect(limitMax, variableLimiter.limit1) annotation(
    Line(points = {{-160, 80}, {60, 80}, {60, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(limitMin, variableLimiter.limit2) annotation(
    Line(points = {{-160, -80}, {60, -80}, {60, -8}, {78, -8}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(initialScale = 0.1)),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-2, 2}, extent = {{-64, 38}, {64, -38}}, textString = "PI Anti Windup Variable Limits")}));
end PIAntiWindupVariableLimits;
