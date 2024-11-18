within Dynawo.NonElectrical.Blocks.Continuous;

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

model IntegratorVariableLimitsAntiWindup "Integrator with limited value of output (variable limits) and anti-windup"
  extends Dynawo.NonElectrical.Blocks.Continuous.BaseClasses.BaseIntegratorVariableLimits;

  parameter Types.PerUnit Kaw "Antiwindup gain";
  parameter Types.PerUnit Tol "Tolerance on limit crossing as a fraction of the difference between initial limits";

  final parameter Boolean FrozenMax0 = Y0 > LimitMax0 - Tol * abs(LimitMax0 - LimitMin0) "If true, integration is initially frozen at upper limit";
  final parameter Boolean FrozenMin0 = Y0 < LimitMin0 + Tol * abs(LimitMax0 - LimitMin0) "If true, integration is initially frozen at lower limit";

protected
  Boolean isFrozenMax(start = FrozenMax0) "If true, integration is frozen at upper limit";
  Boolean isFrozenMin(start = FrozenMin0) "If true, integration is frozen at lower limit";
  Boolean keepFreezingMax(start = FrozenMax0) "If true, integration stays frozen at upper limit";
  Boolean keepFreezingMin(start = FrozenMin0) "If true, integration stays frozen at lower limit";
  Boolean startFreezingMax(start = FrozenMax0) "If true, integration becomes frozen at upper limit";
  Boolean startFreezingMin(start = FrozenMin0) "If true, integration becomes frozen at lower limit";

equation
  startFreezingMax = w > limitMax and v > 0;
  keepFreezingMax = w > limitMax - Tol * abs(LimitMax0 - LimitMin0) and v > 0 and pre(isFrozenMax);
  isFrozenMax = startFreezingMax or keepFreezingMax;

  startFreezingMin = w < limitMin and v < 0;
  keepFreezingMin = w < limitMin + Tol * abs(LimitMax0 - LimitMin0) and v < 0 and pre(isFrozenMin);
  isFrozenMin = startFreezingMin or keepFreezingMin;

  v = K * u + Kaw * (y - w);

  if isFrozenMax then
    w = limitMax;
  elseif isFrozenMin then
    w = limitMin;
  else
    der(w) = v;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info= "<html><head></head><body><p>
This blocks computes <strong>w</strong> as <em>integral</em>
of variable&nbsp;<strong>v&nbsp;</strong>which is equal to input <b>u</b> multiplied by gain <em>K</em> added to an antiwindup term.</p>

<p>If the integral reaches a given upper limit <b>limitMax</b> or lower limit&nbsp;<b>limitMin</b>, the integration is halted and only restarted if the input drives
the integral away from the bounds, with a sufficient margin defined by <em>Tol</em>.</p>

<p>This margin is aimed at avoiding chattering i.e. rapid swings between frozen and unfrozen sates.</p>

<p>If the integration is halted, the integrator output follows the variable limit it has reached.</p>

<p>The output <strong>y</strong> is the result of the limitation of <b>w</b> by both variable limits.</p>

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
end IntegratorVariableLimitsAntiWindup;
