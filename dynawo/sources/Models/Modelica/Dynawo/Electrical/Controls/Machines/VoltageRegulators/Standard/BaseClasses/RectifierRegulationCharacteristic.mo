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
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real UHigh = 0.75 "Upper limit of non-linear mode";
  parameter Real ULow = sqrt(3) / 4 "Lower limit of non-linear mode";

  final parameter Real A1 = if ULow == 0 then 0 else (1 - sqrt(UHigh - ULow ^ 2)) / ULow "Characteristic coefficient of first linear mode";
  final parameter Real A2 = if UHigh == 1 then 0 else sqrt(UHigh / (1 - UHigh)) "Characteristic coefficient of second linear mode";

equation
  assert(ULow <= UHigh, "Lower limit is lower than or equal to upper limit");

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
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-90, -80}, {68, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-80, -88}, {-80, 68}}, color = {192, 192, 192}), Text(origin = {-48, 64}, lineColor = {192, 192, 192}, extent = {{-8, -4}, {64, -52}}, textString = "FEX"), Ellipse(origin = {-80, -80}, extent = {{-120, 120}, {120, -120}}, startAngle = -70, endAngle = -20), Line(points = {{32.763114494, -38.957582801}, {40, -80}}), Line(points = {{-38.957582801, 32.763114494}, {-80, 40}}), Polygon(lineColor = {255, 255, 255}, points = {{-80, -80}, {-38.957582801, 32.763114494}, {32.763114494, -38.957582801}, {-80, -80}})}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-92, -80}, {84, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{100, -80}, {84, -74}, {84, -86}, {100, -80}}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 98}, {-86, 82}, {-74, 82}, {-80, 98}}), Line(points = {{-80, -90}, {-80, 84}}, color = {192, 192, 192}), Text(lineColor = {160, 160, 164}, extent = {{-71, 98}, {-44, 78}}, textString = "y"), Text(lineColor = {160, 160, 164}, extent = {{60, -52}, {84, -72}}, textString = "u"), Ellipse(origin = {-80, -80}, extent = {{-120, 120}, {120, -120}}, startAngle = -70, endAngle = -20), Line(points = {{32.763114494, -38.957582801}, {40, -80}}), Line(points = {{-38.957582801, 32.763114494}, {-80, 40}}), Polygon(lineColor = {255, 255, 255}, points = {{-80, -80}, {-38.957582801, 32.763114494}, {32.763114494, -38.957582801}, {-80, -80}})}),
    Documentation(info = "<html><head></head><body>This characteristic function is defined by five different modes :<div><ul><li>Two constant modes (below 0 and above 1)</li><li>Two linear modes (between 0 and ULow, between UHigh and 1)</li><li>One non-linear mode (between ULow and UHigh)</li></ul>The function is continuous thanks to the adjusted coefficients A1 and A2.</div><div><br></div><div>If A1 * A2 = 1, the characteristic is a symmetry : for any value of u between 0 and 1, y(y(u)) = u.</div><div><br></div><div>With the default values of UHigh and ULow :</div><div><ul><li>A1 = 1 / sqrt(3)</li><li>A2 = sqrt(3)</li><li>The characteristic is thus a symmetry</li></ul></div></body></html>"));
end RectifierRegulationCharacteristic;
