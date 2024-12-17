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
  extends Modelica.Blocks.Interfaces.SI2SO;

equation
  if u1 <= 0 then
    y = 1;
  elseif u1 > 0 and u1 <= u2 * sqrt(3) / 4 then
    y = 1 - u1 / (u2 * sqrt(3));
  elseif u1 > u2 * sqrt(3) / 4 and u1 < u2 * 0.75 then
    y = sqrt(0.75 - (u1 / u2) ^ 2);
  elseif u1 >= u2 * 0.75 and u1 < u2 then
    y = sqrt(3) * (1 - u1 / u2);
  else
    y = 0;
  end if;

//  y = noEvent(if u1 <= 0 then 1 elseif u1 >= u2 then 0
//          elseif (u1 > 0 and u1 <= u2 * sqrt(3) / 4) then 1 - u1 / (u2 * sqrt(3))
//          elseif (u1 >= u2 * 0.75 and u1 < u2) then sqrt(3) * (1 - u1 / u2)
//          else sqrt(0.75 - (u1 / u2) ^ 2));

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-90, -80}, {68, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-80, -88}, {-80, 68}}, color = {192, 192, 192}), Text(origin = {-48, 64}, lineColor = {192, 192, 192}, extent = {{-8, -4}, {64, -52}}, textString = "FEX"), Ellipse(origin = {-80, -80}, extent = {{-120, 120}, {120, -120}}, startAngle = -70, endAngle = -20), Line(points = {{32.763114494, -38.957582801}, {40, -80}}), Line(points = {{-38.957582801, 32.763114494}, {-80, 40}}), Polygon(lineColor = {255, 255, 255}, points = {{-80, -80}, {-38.957582801, 32.763114494}, {32.763114494, -38.957582801}, {-80, -80}})}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-92, -80}, {84, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{100, -80}, {84, -74}, {84, -86}, {100, -80}}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 98}, {-86, 82}, {-74, 82}, {-80, 98}}), Line(points = {{-80, -90}, {-80, 84}}, color = {192, 192, 192}), Text(lineColor = {160, 160, 164}, extent = {{-71, 98}, {-44, 78}}, textString = "y"), Text(lineColor = {160, 160, 164}, extent = {{60, -52}, {84, -72}}, textString = "u"), Ellipse(origin = {-80, -80}, extent = {{-120, 120}, {120, -120}}, startAngle = -70, endAngle = -20), Line(points = {{32.763114494, -38.957582801}, {40, -80}}), Line(points = {{-38.957582801, 32.763114494}, {-80, 40}}), Polygon(lineColor = {255, 255, 255}, points = {{-80, -80}, {-38.957582801, 32.763114494}, {32.763114494, -38.957582801}, {-80, -80}})}),
    Documentation(info = "<html><head></head><body>The inputs of this block are<div><ul><li>u1 : field current signal</li><li>u2 : exciter output voltage</li></ul>The ratio u1/u2 is then fed into the characteristic function.<br><br>This characteristic function is defined by five different modes :<div><ul><li>Two constant modes (below 0 and above 1)</li><li>Two linear modes (between 0 and sqrt(3) / 4, between 0.75 and 1)</li><li>One quadratic mode (between sqrt(3) / 4 and 0.75)</li></ul>The function is continuous and symmetric : for any value of&nbsp;u = u1/u2&nbsp;between 0 and 1, y(y(u)) = u.</div></div><div><br></div><div>The noEvent() operator prevents a simulation failure involving a negative input for the square root or a division by zero.</div></body></html>"));
end RectifierRegulationCharacteristic;
