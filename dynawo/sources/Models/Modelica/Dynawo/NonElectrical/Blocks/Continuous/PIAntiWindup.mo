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

block PIAntiWindup "Anti-windup proportional integral controller"
  extends Dynawo.NonElectrical.Blocks.Continuous.BaseClasses.BasePIAntiWindup;

  parameter Types.PerUnit YMax "Maximum output of controller";
  parameter Types.PerUnit YMin "Minimum output of controller";

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = YMax, uMin = YMin) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(add.y, limiter.u) annotation(
    Line(points = {{22, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(limiter.y, y) annotation(
    Line(points = {{102, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(limiter.y, feedback1.u1) annotation(
    Line(points = {{102, 0}, {120, 0}, {120, -60}, {48, -60}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(initialScale = 0.1)),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-2, 2}, extent = {{-64, 38}, {64, -38}}, textString = "PI Anti Windup")}));
end PIAntiWindup;
