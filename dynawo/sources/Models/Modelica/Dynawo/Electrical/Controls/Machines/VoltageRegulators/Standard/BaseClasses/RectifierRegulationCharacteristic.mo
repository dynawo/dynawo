within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

block RectifierRegulationCharacteristic "Characteristic function of rectifier regulation"
  import Modelica;

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real UHigh = 0.75 "Upper limit of non-linear mode";
  parameter Real ULow = 0.433 "Lower limit of non-linear mode";

  final parameter Real A1 = (1 - sqrt(UHigh - ULow ^ 2)) / ULow "Characteristic coefficient of first linear mode";
  final parameter Real A2 = sqrt(UHigh / (1 - UHigh)) "Characteristic coefficient of second linear mode";

equation
  assert(ULow < UHigh, "Lower limit is lower than upper limit");

  if u <= 0 then
    y = 1;
  elseif u > 0 and u <= ULow then
    y = 1 - A1 * u;
  elseif u > ULow and u < UHigh then
    y = sqrt(UHigh - u ^ 2);
  elseif u >= UHigh and u <= 1 then
    y = A2 * (1 - u);
  else
    y = 0;
  end if;

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-90, -80}, {68, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Line(origin = {-0.00386326, -0.00386326},rotation = 180, points = {{-57.9, 79.9}, {-44.5, 79.85}, {-27.1, 79.8}, {-8.2, 69.51}, {9.5, 56.7}, {17.58, 52}, {43.7, 39.3}, {69.5, 0}, {80, 0}}, smooth = Smooth.Bezier), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-80, -88}, {-80, 68}}, color = {192, 192, 192}), Text(origin = {-48, 64}, lineColor = {192, 192, 192}, extent = {{-8, -4}, {64, -52}}, textString = "FEX")}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-92, -80}, {84, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{100, -80}, {84, -74}, {84, -86}, {100, -80}}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 98}, {-86, 82}, {-74, 82}, {-80, 98}}), Line(points = {{-80, -90}, {-80, 84}}, color = {192, 192, 192}), Text(lineColor = {160, 160, 164}, extent = {{-71, 98}, {-44, 78}}, textString = "y"), Text(lineColor = {160, 160, 164}, extent = {{60, -52}, {84, -72}}, textString = "u"), Line(origin = {-0.00386326, -0.00386326}, rotation = 180, points = {{-57.9, 79.9}, {-44.5, 79.85}, {-27.1, 79.8}, {-8.2, 69.51}, {9.5, 56.7}, {17.58, 52}, {43.7, 39.3}, {69.5, 0}, {80, 0}}, smooth = Smooth.Bezier)}),
  Documentation(info = "<html><head></head><body>This characteristic function is defined by five different modes :<div><ul><li>Two constant modes (below 0 and above 1)</li><li>Two linear modes (between 0 and ULow, between UHigh and 1)</li><li>One non-linear mode (between ULow and UHigh)</li></ul>The function is continuous thanks to the adjusted cefficients A1 and A2.</div></body></html>"));
end RectifierRegulationCharacteristic;
