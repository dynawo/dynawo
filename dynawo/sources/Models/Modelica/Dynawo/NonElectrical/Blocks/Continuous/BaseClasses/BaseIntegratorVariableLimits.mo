within Dynawo.NonElectrical.Blocks.Continuous.BaseClasses;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

block BaseIntegratorVariableLimits "Integrator with variable limits on output and frozen integration on the limits"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Boolean DefaultLimitMax = true "If limitMin > limitMax : if true, y = limitMax, if false, y = limitMin";
  parameter Types.PerUnit K = 1 "Integrator gain";

  Modelica.Blocks.Interfaces.RealInput limitMax(start = LimitMax0) "Connector of Real input signal used as maximum of output y" annotation(
    Placement(transformation(extent={{-140, 60}, {-100, 100}})));
  Modelica.Blocks.Interfaces.RealInput limitMin(start = LimitMin0) "Connector of Real input signal used as minimum of output y" annotation(
    Placement(transformation(extent={{-140, -100}, {-100, -60}})));

  parameter Types.PerUnit LimitMax0 "Initial value of upper limit";
  parameter Types.PerUnit LimitMin0 "Initial value of lower limit";
  parameter Types.PerUnit Y0 = 0 "Initial or guess value of output";

protected
  Types.PerUnit v(start = 0) "Non-frozen integrator input";
  Types.PerUnit w(start = Y0) "Non-limited integrator output";

equation
  if limitMin > limitMax and DefaultLimitMax then
    y = limitMax;
  elseif limitMin > limitMax then
    y = limitMin;
  elseif w < limitMin then
    y = limitMin;
  elseif w > limitMax then
    y = limitMax;
  else
    y = w;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info= "<html><head></head><body><p>The output <strong>y</strong> is the result of the limitation of <b>w</b> by both variable limits.</p>

<p>If the \"upper\" limit is smaller than the \"lower\" one, the output <i>y</i> is ruled by the parameter <i>DefaultLimitMax</i>: <i>y</i> is equal to either&nbsp;<b>limitMax&nbsp;</b>or&nbsp;<b>limitMin</b>.</p>

<p>The integrator output is initialized with the parameter <em>Y0</em>.</p>
</body></html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}),
        Line(points = {{-80, -80}, {20, 20}, {80, 20}}, color = {0, 0, 127}),
        Text(lineColor = {192, 192, 192}, extent = {{0, -10}, {60, -70}}, textString = "I"),
        Text(
          extent={{-150,-150},{150,-110}},
          textString="K=%K"),
        Line(
          points={{60,-100},{60,-80}},
          color={255,0,255},
          pattern=LinePattern.Dot)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(lineColor={0,0,255}, extent={{-60,60},{60,-60}}),
        Text(
          extent={{-54,46},{-4,-48}},
          textString="lim"),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-8,60},{60,2}},
          textString="k"),
        Text(
          extent={{-8,-2},{60,-60}},
          textString="s"),
        Line(points={{4,0},{46,0}})}));
end BaseIntegratorVariableLimits;
