within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block SecondOrder "Second order filter block, allowing for zero coefficients"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Real A1 "First order coefficient in s";
  parameter Real A2 "Second order coefficient in s ^ 2";
  parameter Real K = 1 "Gain";

  final parameter Real D = A1 * (w / 2) "Damping of second order filter";
  final parameter Real tFo = if A2 <> 0 then 1e-5 elseif A1 <> 0 then A1 else 1e-5 "Time constant of first order filter in s";
  final parameter Real w = if A2 > 0 then 1 / sqrt(A2) else 1 "Angular frequency of second order filter in Hz";

  Modelica.Blocks.Continuous.SecondOrder secondOrder(D = D, k = K, w = w, y_start = Y0, yd_start = Yd0) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k = K, T = tFo, y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = K) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Real Y0 = 0 "Initial value of output signal";
  parameter Real Yd0 = 0 "Initial value of derivative of output signal";

equation
  if A2 <> 0 then
    y = secondOrder.y;
  elseif A1 <> 0 then
    y = firstOrder.y;
  else
    y = gain.y;
  end if;

  connect(u, secondOrder.u) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, 60}, {-12, 60}}, color = {0, 0, 127}));
  connect(u, firstOrder.u) annotation(
    Line(points = {{-120, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(u, gain.u) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, -60}, {-12, -60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}),   Line(origin = {-1.939,-1.816}, points = {{81.939, 36.056}, {65.362, 36.056}, {14.39, -26.199}, {-29.966, 113.485}, {-65.374, -61.217}, {-78.061, -78.184}}, color = {0,0,127}, smooth = Smooth.Bezier), Text(lineColor = {192, 192, 192}, extent = {{0, -70}, {60, -10}}, textString = "PT2"), Text(extent = {{-150, -150}, {150, -110}}, textString = "w=%w")}));
end SecondOrder;
