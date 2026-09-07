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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block Washout "Washout filter block, allowing for zero time constant"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.Time tW "Washout filter time constant in s";

  Modelica.Blocks.Interfaces.RealInput u(start = U0) "Input signal connector" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = 0) "Output signal connector" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.Derivative derivative(k = tW, T = max(tW, 1e-5), x_start = U0) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Real U0 = 0 "Initial value of input signal";

equation
  if tW > 0 then
    y = derivative.y;
  else
    y = u;
  end if;

  connect(u, derivative.u) annotation(
    Line(points = {{-120, 0}, {-12, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(extent = {{-100, -100},{100, 100}}), graphics = {Text(extent = {{-150, -150}, {150, -110}}, textString = "tW=%tW"), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Text(lineColor = {192, 192, 192}, extent = {{-30, 14}, {86, 60}}, textString = "DT1"), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Line(origin = {-24.667, -27.333}, points = {{-55.333, 87.333}, {-19.333, -40.667}, {86.667, -52.667}}, color = {0, 0, 127}, smooth = Smooth.Bezier), Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}), Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192})}));
end Washout;
