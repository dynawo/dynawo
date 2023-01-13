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

block BacklashHysteresis "Provides a region of offset with a hysteresis logic"
  import Modelica;

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Boolean H0 = false "Value of h at initial time";
  parameter Real Tolerance = 1e-5 "Tolerance on derivative of input";
  parameter Real U0 "Start value of input";
  parameter Real UHigh "Upper limit of the hysteresis";
  parameter Real ULow = -UHigh "Lower limit of the hysteresis";

  final parameter Real Aux0 = if H0 then max(U0 - UHigh, 0) else min(U0 - ULow, 0) "Initial auxiliary variable";

  Real aux(start = Aux0) "Auxiliary variable to stabilize y when the derivative of u changes";
  Boolean h(start = H0) "Boolean to detect changes of behaviour of u";

equation
  when der(u) < -Tolerance and u >= UHigh then
    h = true;
    aux = u - UHigh;
  elsewhen der(u) > Tolerance and u <= ULow then
    h = false;
    aux = u - ULow;
  end when;

  if pre(h) and u <= pre(aux) - UHigh then
    y = u - ULow;
  elseif not pre(h) and u >= pre(aux) - ULow then
    y = u - UHigh;
  else
    y = pre(aux);
  end if;

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(origin = {-0.29661, 0.29661},points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 90}, {-8, 68}, {8, 68}, {0, 90}}),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, 0}, {68, -8}, {68, 8}, {90, 0}}),
    Text(lineColor = {160, 160, 164}, extent = {{-150, -150}, {150, -110}}, textString = "uMax=%uMax"), Line(origin = {-1.27112, -12.2458}, points = {{-48, -72}, {28, 98}}), Line(origin = {-40.3301, -78.4152}, points = {{15, -6}, {-9, -6}}), Line(origin = {21.7797, -12.3305}, points = {{-48, -72}, {28, 98}}), Line(origin = {35.5174, 91.4577}, points = {{15, -6}, {-9, -6}})}),
    Diagram(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(points={{0,-60},{0,50}}, color={192,192,192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 60}, {-5, 50}, {5, 50}, {0, 60}}),
    Line(points={{-76,0},{74,0}}, color={192,192,192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{84, 0}, {74, -5}, {74, 5}, {84, 0}}),
    Text(lineColor = {128, 128, 128}, extent = {{62, -7}, {88, -25}}, textString = "u"),
    Text(lineColor = {128, 128, 128}, extent = {{-36, 72}, {-5, 50}}, textString = "y"), Line(origin = {21.7797, -12.3305}, points = {{-48, -72}, {28, 98}}), Line(origin = {-1.27112, -12.2458}, points = {{-48, -72}, {28, 98}}), Line(origin = {-40.3301, -78.4152}, points = {{15, -6}, {-9, -6}}), Line(origin = {35.5174, 91.4577}, points = {{15, -6}, {-9, -6}})}));
end BacklashHysteresis;
