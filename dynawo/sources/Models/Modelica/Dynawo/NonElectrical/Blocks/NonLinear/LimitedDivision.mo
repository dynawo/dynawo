within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

block LimitedDivision "Outputs first input divided by second input, within a limited range"
  extends Modelica.Blocks.Interfaces.SI2SO;

  parameter Real YMax "Upper limit of output";
  parameter Real YMin "Lower limit of output";

equation
  y = noEvent(if u1 >= u2 * YMax then YMax elseif u1 <= u2 * YMin then YMin else u1 / u2);

  annotation(
    Documentation(info= "<html><head></head><body><p>
This block computes the output <strong>y</strong>
by <em>dividing</em> the two inputs <strong>u1</strong> and <strong>u2</strong> unless the result lies outside the limited range:</p>
<pre>            YMax     <strong>if</strong> u1 / u2 &gt; YMax
  y =       u1 / u2  <strong>if</strong> u1 / u2 in [YMin, YMax]
            YMin     <strong>if</strong> u1 / u2 &lt; YMin
</pre>
<p>It is necessary to have <strong>u2</strong> positive.</p></body></html>"),
    Icon(coordinateSystem(
      preserveAspectRatio = true,
      extent = {{-100, -100}, {100, 100}}), graphics = {
      Line(points = {{-80, -120}, {-40, -120}, {-33.33, -100}}),
      Line(points = {{33.33, 100}, {40, 120}, {80, 120}}),
      Line(points = {{-100, 60}, {-66, 60}, {-40, 30}}, color = {0, 0, 255}),
      Line(points = {{-100, -60}, {0, -60}, {0, -50}}, color = {0, 0, 255}),
      Line(points = {{50, 0}, {100, 0}}, color = {0, 0, 127}),
      Line(points = {{-30, 0}, {30, 0}}),
      Ellipse(fillPattern = FillPattern.Solid, extent = {{-5, 20}, {5, 30}}, endAngle = 360),
      Ellipse(fillPattern = FillPattern.Solid, extent = {{-5, -30}, {5, -20}}, endAngle = 360),
      Ellipse(lineColor = {0, 0, 127}, extent = {{-50, -50}, {50, 50}}, endAngle = 360),
      Line(points = {{-100, 60}, {-66, 60}, {-40, 30}}, color = {0, 0, 127}),
      Line(points = {{-100, -60}, {0, -60}, {0, -50}}, color = {0, 0, 127}),
      Text(lineColor = {128, 128, 128}, extent = {{-60, 94}, {90, 54}}, textString = "u1 / u2")}),
    Diagram(coordinateSystem(
      preserveAspectRatio = true,
      extent = {{-100, -100}, {100, 100}}), graphics = {
      Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}),
      Line(points = {{50, 0}, {100, 0}},color = {0, 0, 255}),
      Line(points = {{-30, 0}, {30, 0}}),
      Ellipse(fillPattern = FillPattern.Solid, extent = {{-5, 20}, {5, 30}}, endAngle = 360),
      Ellipse(fillPattern = FillPattern.Solid, extent = {{-5, -20}, {5, -30}}, endAngle = 360),
      Ellipse(lineColor = {0, 0, 255}, extent = {{-50, 50}, {50, -50}}, endAngle = 360)}));
end LimitedDivision;
