within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
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

block Power "Outputs a power of the input"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real N "Exponent of the power function";
  parameter Boolean NInteger "For u < 0 : if true, u ^ N is calculable, if false, u ^ N is not calculable, y = 0 instead";

equation
  if NInteger then
    y = u ^ N;
  else
    y = noEvent(if u > 0 then u ^ N else 0);
  end if;

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(initialScale = 0.1), graphics={Line(points = {{-90, -80},{68, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Line(rotation = 180,points = {{-80, -80}, {-79.2, -68.7}, {-78.4, -64}, {-76.8, -57.3}, {-73.6, -47.9}, {-67.9, -36.1}, {-59.1, -22.2}, {-46.2, -6.49}, {-28.5, 10.7}, {-4.42, 30}, {27.7, 51.3}, {69.5, 74.7}, {80, 80}}, smooth = Smooth.Bezier), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-80, -88}, {-80, 68}}, color = {192, 192, 192}), Text(origin = {-48, 64},lineColor = {192, 192, 192}, extent = {{-8, -4}, {64, -52}}, textString = "power"), Text(extent = {{-150, -150}, {150, -110}}, textString = "N=%N")}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-92, -80}, {84, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{100, -80}, {84, -74}, {84, -86}, {100, -80}}), Line(rotation = 180, points = {{-80, -80}, {-79.2, -68.7}, {-78.4, -64}, {-76.8, -57.3}, {-73.6, -47.9}, {-67.9, -36.1}, {-59.1, -22.2}, {-46.2, -6.49}, {-28.5, 10.7}, {-4.42, 30}, {27.7, 51.3}, {69.5, 74.7}, {80, 80}}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 98}, {-86, 82}, {-74, 82}, {-80, 98}}), Line(points = {{-80, -90}, {-80, 84}}, color = {192, 192, 192}), Text(lineColor = {160, 160, 164}, extent = {{-71, 98}, {-44, 78}}, textString = "y"), Text(lineColor = {160, 160, 164}, extent = {{60, -52}, {84, -72}}, textString = "u")}),
    Documentation(info= "<html><head></head><body><p>If <b>NInteger</b> = true, this block computes the output <strong>y</strong> as <b>N</b>&nbsp;<em>power</em> of the input <strong>u</strong>:</p><pre>  y = u ^ N</pre><p>If&nbsp;<b>NInteger</b> = false, this block computes the output&nbsp;<strong>y</strong>&nbsp;as&nbsp;follows:</p><pre>       u ^ N  <strong>if</strong> u &gt; 0
  y =
         0    <strong>if</strong> u ≤ 0
</pre><p>The noEvent function prevents the negative input values from being evaluated by the power function with a non-integer exponent, thus avoiding an error.</p></body></html>"));
end Power;
