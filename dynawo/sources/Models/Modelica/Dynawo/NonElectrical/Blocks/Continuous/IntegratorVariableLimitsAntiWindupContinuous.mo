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

model IntegratorVariableLimitsAntiWindupContinuous "Integrator with limited value of output (variable limits) and anti-windup"
  extends Dynawo.NonElectrical.Blocks.Continuous.BaseClasses.BaseIntegratorVariableLimits;

  parameter Types.PerUnit Kaw "Antiwindup gain";
  parameter Real TolInput "Tolerance on limit crossing for integrator input";
  parameter Real TolOutput "Tolerance on limit crossing for integrator output";

protected
  Types.PerUnit kFreezeMax "Freeze coefficient for upper limit";
  Types.PerUnit kFreezeMin "Freeze coefficient for lower limit";

equation
  v = K * u + Kaw * (y - w);

  kFreezeMax = (1 / 4) * (1 + tanh((w - limitMax) / TolOutput)) * (1 + tanh(v / TolInput));
  kFreezeMin = (1 / 4) * (1 + tanh((limitMin - w) / TolOutput)) * (1 - tanh(v / TolInput));

  der(w) = v * (1 - kFreezeMax - kFreezeMin);

  annotation(
    preferredView = "text",
    Documentation(info= "<html><head></head><body><p>
This blocks computes <strong>w</strong> as <em>integral</em>
of variable&nbsp;<strong>v&nbsp;</strong>which is equal to input <b>u</b> multiplied by gain <em>K</em> added to an antiwindup term.</p>

<p>If the integral reaches a given upper limit <b>limitMax</b> or lower limit&nbsp;<b>limitMin</b>, the integration is halted and only restarted if the input drives
the integral away from the bounds.</p>

<p>This freeze is imposed through two coefficients <b>kFreezeMax</b> and <b>kFreezeMin</b>, each defined by a continuous expression involving the hyperbolic tangent, the integrator input <b>v</b>, the integrator output <b>w</b>, the limit <b>limitMax</b> or <b>limitMin</b>.</p>

<p>w &gt; limitMax and v &gt; 0 =&gt; kFreezeMax = 1, kFreezeMin = 0 =&gt; der(w) = 0</p>

<p>w &lt; limitMin and v &lt; 0 =&gt; kFreezeMax = 0, kFreezeMin = 1 =&gt; der(w) = 0</p>

<p>limitMax &gt; w &gt; limitMin =&gt; kFreezeMax = kFreezeMin = 0 =&gt; der(w) = v</p>

<p>The parameters <i>TolInput</i> and <i>TolOutput</i> determine the width of the transition zone from one domain to another.</p>

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
end IntegratorVariableLimitsAntiWindupContinuous;
