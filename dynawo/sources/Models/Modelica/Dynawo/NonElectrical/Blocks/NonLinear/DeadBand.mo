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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block DeadBand "Provide a region of zero output"
  import Modelica;

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real EpsMax = UMax "Upper dead band hysteresis";
  parameter Real EpsMin = -EpsMax "Lower dead band hysteresis";
  parameter Real UMax "Upper limit of dead band width";
  parameter Real UMin = -UMax "Lower limit of dead band width";

equation
  assert(UMax >= UMin, "DeadZone: Limits must be consistent. However, UMax (=" + String(UMax) + ") < UMin (=" + String(UMin) + ")");

  y = if u > UMax then u - UMax + EpsMax elseif u < UMin then u - UMin + EpsMin else 0;

  annotation(
    preferredView = "text",
    Documentation(info="<html>
<p>
The DeadZone block defines a region of zero output.
</p>

</html>"), Icon(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 90}, {-8, 68}, {8, 68}, {0, 90}}),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, 0}, {68, -8}, {68, 8}, {90, 0}}), Text(lineColor = {160, 160, 164}, extent = {{-150, -150}, {150, -110}}, textString = "UMax=%UMax"), Line(origin = {6.29, -0.03}, points = {{-33.997, -27.677}, {22.0029, 28.323}}), Line(origin = {4.7, 5}, points = {{-75, -75}, {-35, -35}, {-35, -5}, {25, -5}, {25, 25}, {65, 65}})}),
    Diagram(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(points={{0,-60},{0,50}}, color={192,192,192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 90}, {-8, 68}, {8, 68}, {0, 90}}),
    Line(points={{-76,0},{74,0}}, color={192,192,192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{84, 0}, {74, -5}, {74, 5}, {84, 0}}),
    Line(origin = {6.29, -0.03}, points = {{-33.997, -27.677}, {22.0029, 28.323}}),
    Line(origin = {4.7, 5}, points = {{-75, -75}, {-35, -35}, {-35, -5}, {25, -5}, {25, 25}, {65, 65}}),
    Text(lineColor = {128, 128, 128}, extent = {{62, -7}, {88, -25}}, textString = "u"),
    Text(lineColor = {128, 128, 128}, extent = {{-36, 72}, {-5, 50}}, textString = "y"),
    Text(lineColor = {128, 128, 128}, extent = {{-51, 1}, {-28, 19}}, textString = "UMin"),
    Text(origin = {2, 0},lineColor = {128, 128, 128}, extent = {{27, 21}, {52, 5}}, textString = "UMax")}));
end DeadBand;
