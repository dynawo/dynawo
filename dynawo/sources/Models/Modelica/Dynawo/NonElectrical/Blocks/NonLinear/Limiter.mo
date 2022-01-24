within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block Limiter "Limits the range of a signal"
  import Modelica;

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real YMax "Upper limit of output";
  parameter Real YMin = -YMax "Lower limit of output";

equation
  y = if u > YMax then YMax else if u < YMin then YMin else u;

  annotation(preferredView = "text",
    Documentation(info="<html>
<p>
The Limiter block passes its input signal as output signal
as long as the input is within the specified upper and lower
limits. If this is not the case, the corresponding limits are passed
as output.
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {
    Line(points = {{0, -60}, {0, 50}}, color = {192, 192, 192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 60}, {-5, 50}, {5, 50}, {0, 60}}),
    Line(points = {{-60, 0}, {50, 0}}, color = {192, 192, 192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{60, 0}, {50, -5}, {50, 5}, {60, 0}}),
    Line(points = {{-50, -40}, {-30, -40}, {30, 40}, {50, 40}}),
    Text(lineColor = {128, 128, 128}, extent = {{46, -6}, {68, -18}}, textString = "u"),
    Text(lineColor = {128, 128, 128}, extent = {{-30, 70}, {-5, 50}}, textString = "y"),
    Text(lineColor = {128, 128, 128}, extent = {{-58, -54}, {-28, -42}}, textString = "uMin"),
    Text(lineColor = {128, 128, 128}, extent = {{26, 40}, {66, 56}}, textString = "uMax")}),
    Icon(graphics = {
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, 0}, {68, -8}, {68, 8}, {90, 0}}),
    Line(points = {{-80, -70}, {-50, -70}, {50, 70}, {80, 70}}),
    Line(points = {{0, -90}, {0, 68}}, color = {192, 192, 192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 90}, {-8, 68}, {8, 68}, {0, 90}}),
    Line(points = {{-90, 0}, {68, 0}}, color = {192, 192, 192})}));
end Limiter;
