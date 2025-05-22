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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model IntegratorVariableLimitsContinuousSetFreeze "Integrator with limited value of output (variable limits), set/reset and freeze"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Boolean DefaultLimitMax = true "If limitMin > limitMax : if true, y = limitMax, if false, y = limitMin";
  Real derLimitMax "Filtered derivative of upper limit of output";
  Real derLimitMin "Filtered derivative of lower limit of output";
  parameter Types.PerUnit K = 1 "Integrator gain";
  parameter Real LimitMax0 "Initial value of upper limit";
  parameter Real LimitMin0 "Initial value of lower limit";
  parameter Boolean ReinitWhenResetIsReleased = true "true: integrator state gets reinitialized to 'set' when 'reset' turns false. false: integrator state gets reinitialized to 'set' when 'reset' turns true.";
  parameter Types.Time tDer = 1e-3 "Time constant of derivative filter for limits in s";
  parameter Real TolInput = 1e-5 "Tolerance on limit crossing for integrator input";
  parameter Real TolOutput = 1e-5 "Tolerance on limit crossing for integrator output";
  parameter Real LimitDeadband = 0.001 "Deadband for detecting a limit crossing of the integrator's state";
  parameter Boolean UseFreeze = false "=true, if freeze port enabled" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
  parameter Boolean UseReset = false "=true, if reset port enabled" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
  parameter Boolean UseSet = false "=true, if set port enabled and used as reinitialization value when reset" annotation( Dialog(enable = UseReset), Evaluate = true, HideResult = true, choices(checkBox = true));
  Real w(start = Y0) "Integrator state variable";
  parameter Real Y0 = 0 "Initial or guess value of output (must be in the limits limitMin .. limitMax)";
  
  Modelica.Blocks.Continuous.Derivative derivativeLimitMax(T = tDer, x_start = LimitMax0) annotation(Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivativeLimitMin(T = tDer, x_start = LimitMin0) annotation(Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput freeze if UseFreeze "Optional connector of freeze signal" annotation(Placement(visible = true, transformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput limitMax "Connector of Real input signal used as maximum of output y" annotation(Placement(visible = true, transformation(extent = {{-140, 60}, {-100, 100}}, rotation = 0), iconTransformation(extent = {{-140, 60}, {-100, 100}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput limitMin "Connector of Real input signal used as minimum of output y" annotation(Placement(visible = true, transformation(extent = {{-140, -100}, {-100, -60}}, rotation = 0), iconTransformation(extent = {{-140, -100}, {-100, -60}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput reset if UseReset "Optional connector of reset signal" annotation(Placement(visible = true, transformation(origin = {60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(extent = {{40, -140}, {80, -100}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput set if UseReset and UseSet "Optional connector of set signal" annotation(Placement(visible = true, transformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 270), iconTransformation(extent = {{40, 100}, {80, 140}}, rotation = 270)));

protected
  Types.PerUnit kFreezeMax "Freeze coefficient for upper limit";
  Types.PerUnit kFreezeMin "Freeze coefficient for lower limit";
  Modelica.Blocks.Interfaces.BooleanOutput freezeLocal annotation(HideResult = true);
  Modelica.Blocks.Interfaces.BooleanOutput resetLocal annotation(HideResult = true);
  Modelica.Blocks.Interfaces.RealOutput setLocal annotation(HideResult = true);
  Real v "Integrator input";

equation
  if freezeLocal or resetLocal then
    v = 0;
  else
    v = K * u;
  end if;
////////// reset
  if UseReset then
    connect(reset, resetLocal);
    if UseSet then
      connect(set, setLocal);
    else
      setLocal = Y0;
    end if;
    when if ReinitWhenResetIsReleased then not resetLocal else resetLocal then
      reinit(w, setLocal);
    end when;
  else
    resetLocal = false;
    setLocal = 0;
  end if;
////////// freeze
  if UseFreeze then
    connect(freeze, freezeLocal);
  else
    freezeLocal = false;
  end if;
////////// integrator with limits
  derLimitMax = derivativeLimitMax.y;
  derLimitMin = derivativeLimitMin.y;
  kFreezeMax = 1 / 4 * (1 + tanh((w - limitMax) / TolOutput)) * (1 + tanh((v - derLimitMax) / TolInput));
  kFreezeMin = 1 / 4 * (1 + tanh((limitMin - w) / TolOutput)) * (1 + tanh((derLimitMin - v) / TolInput));
  der(w) = derLimitMax * kFreezeMax + derLimitMin * kFreezeMin + v * (1 - kFreezeMax - kFreezeMin);
////////// apply limit or set to output
  if limitMin > limitMax and DefaultLimitMax then
    y = limitMax;
  elseif limitMin > limitMax then
    y = limitMin;
  elseif w > limitMax+LimitDeadband then
    y = limitMax;
  elseif w < limitMin-LimitDeadband then
    y = limitMin;
  elseif resetLocal then
    y = setLocal;
  else
    y = w;
  end if;
  
  connect(limitMax, derivativeLimitMax.u) annotation(
    Line(points = {{-120, 80}, {-82, 80}}, color = {0, 0, 127}));
  connect(limitMin, derivativeLimitMin.u) annotation(
    Line(points = {{-120, -80}, {-82, -80}}, color = {0, 0, 127}));
  
  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body><p>
This blocks computes <strong>w</strong> as integral
of the input <strong>u</strong> multiplied by the gain <em>K</em>, with v = K * u<em>.</em></p>
<p>If the integral reaches a given upper limit <b>limitMax</b> or lower limit&nbsp;<b>limitMin</b>, the
integration is halted and only restarted if the input drives
the integral away from the bounds.</p><p>This freeze is imposed through two coefficients <b>kFreezeMax</b> and <b>kFreezeMin</b>, each defined by a continuous expression involving the hyperbolic tangent, the integrator input <b>v</b>, the integrator output <b>w</b>, the limit <b>limitMax</b> or <b>limitMin</b> and its filtered derivative <b>derLimitMax</b> or <b>derLimitMin</b>.</p><p>w &gt; limitMax and v &gt; derLimitMax =&gt; kFreezeMax = 1, kFreezeMin = 0 =&gt; der(w) = derLimitMax</p><p>w &lt; limitMin and v &lt; derLimitMin =&gt; kFreezeMax = 0, kFreezeMin = 1 =&gt; der(w) = derLimitMin</p><p>limitMax &gt; w &gt; limitMin or derLimitMax &gt; v &gt; derLimitMin =&gt; kFreezeMax = kFreezeMin = 1 =&gt; der(w) = v</p><p>The parameters <i>TolInput</i> and <i>TolOutput</i> determine the width of the transition zone from one domain to another.</p>
<p>The output <strong>y</strong> is the result of the limitation of <b>w</b> by both variable limits.</p>
<p>If the \"upper\" limit is smaller than the \"lower\" one, the output <i>y</i> is ruled by the parameter <i>DefaultLimitMax</i>: <i>y</i> is equal to either&nbsp;<b>limitMax&nbsp;</b>or&nbsp;<b>limitMin</b>.</p>
<p>The integrator is initialized with the value <em>Y0</em>.</p><p><br></p><p><b>Extended with set/reset functionality:</b></p><p>If the&nbsp;<em>reset</em>&nbsp;port and <i>set</i>&nbsp;port are enabled, then the integrator's output is forced to the value of <i>set </i>while <i>reset</i>=true. If the <i>set</i>&nbsp;port is not enabled, the output is instead forced to&nbsp;<em>Y0. &nbsp;</em></p><p>When&nbsp;<em>reset</em>&nbsp;returns to false (=falling edge), the integrator's state is reinitialized to <i>set&nbsp;</i>to resume integration without a jump discontinuity (change&nbsp;<i>ReinitWhenResetIsReleased</i>&nbsp;to false to reinitialize at a rising edge instead).</p><p><br></p>
<p><strong>Extended with Freeze functionality:</strong>&nbsp;</p><p>&nbsp;If boolean input is set to true, the derivative of the state variable is set to zero.</p>
</body></html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Line(points = {{-80, -80}, {20, 20}, {80, 20}}, color = {0, 0, 127}), Text(lineColor = {192, 192, 192}, extent = {{0, -10}, {60, -70}}, textString = "I"), Text(origin = {4, -2}, extent = {{-150, -150}, {150, -110}}, textString = "K=%K"), Line(points = {{60, -100}, {60, -80}}, color = {255, 0, 255}, pattern = LinePattern.Dot)}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(lineColor = {0, 0, 255}, extent = {{-60, 60}, {60, -60}}), Text(extent = {{-54, 46}, {-4, -48}}, textString = "lim"), Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}), Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255}), Text(extent = {{-8, 60}, {60, 2}}, textString = "k"), Text(extent = {{-8, -2}, {60, -60}}, textString = "s"), Line(points = {{4, 0}, {46, 0}})}));
end IntegratorVariableLimitsContinuousSetFreeze;
