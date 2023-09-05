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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model IntegratorSetFreeze "Outputs the integral of the input signal with optional set/reset and optional state freeze"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Real K = 1 "Integrator gain";
  parameter Boolean UseReset = false "=true, if reset port enabled" annotation(
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));
  parameter Boolean UseSet = false "=true, if set port enabled and used as reinitialization value when reset" annotation(
    Dialog(enable = UseReset),
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));
  parameter Boolean UseFreeze = false "=true, if freeze port enabled" annotation(
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));
  parameter Real Y0 = 0 "Initial or guess value of output (= state)";

  Modelica.Blocks.Interfaces.BooleanInput reset if UseReset "Optional connector of reset signal" annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {60, -120})));
  Modelica.Blocks.Interfaces.RealInput set if UseReset and UseSet "Optional connector of set signal" annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 270, origin = {60, 120})));
  Modelica.Blocks.Interfaces.BooleanInput freeze if UseFreeze "Optional connector of freeze signal" annotation(
    Placement(visible = true, transformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

protected
  Modelica.Blocks.Interfaces.BooleanOutput resetLocal annotation(
    HideResult = true);
  Modelica.Blocks.Interfaces.BooleanOutput freezeLocal annotation(
    HideResult = true);
  Modelica.Blocks.Interfaces.RealOutput setLocal annotation(
    HideResult = true);

equation
  if UseReset then
    connect(reset, resetLocal);
    if UseSet then
      connect(set, setLocal);
    else
      setLocal = Y0;
    end if;
    when resetLocal then
      reinit(y, setLocal);
    end when;
  else
    resetLocal = false;
    setLocal = 0;
  end if;

  if UseFreeze then
    connect(freeze, freezeLocal);
  else
    freezeLocal = false;
  end if;

  if freezeLocal then
    der(y) = 0;
  else
    der(y) = K * u;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html>
<p>
This blocks computes output <strong>y</strong> as
<em>integral</em> of the input <strong>u</strong> multiplied with
the gain <em>K</em>:
</p>
<pre>
         K
     y = - u
         s
</pre>

<p>
If the <em>reset</em> port is enabled, then the output <strong>y</strong> is reset to <em>set</em>
or to <em>Y0</em> (if the <em>set</em> port is not enabled), whenever the <em>reset</em>
port has a rising edge.
</p>

<p>
<strong>Extended with Freeze functionality:</strong> If boolean input is set to true, the derivative of the state variable is set to zero.
</p>

</html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}), graphics = {Line(points = {{-80.0, 78.0}, {-80.0, -90.0}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80.0, 90.0}, {-88.0, 68.0}, {-72.0, 68.0}, {-80.0, 90.0}}), Line(points = {{-90.0, -80.0}, {82.0, -80.0}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90.0, -80.0}, {68.0, -72.0}, {68.0, -88.0}, {90.0, -80.0}}), Text(lineColor = {192, 192, 192}, extent = {{0.0, -70.0}, {60.0, -10.0}}, textString = "I"), Text(extent = {{-150.0, -150.0}, {150.0, -110.0}}, textString = "K=%K"), Line(points = DynamicSelect({{-80.0, -80.0}, {80.0, 80.0}}, if UseReset then {{-80.0, -80.0}, {60.0, 60.0}, {60.0, -80.0}, {80.0, -60.0}} else {{-80.0, -80.0}, {80.0, 80.0}}), color = {0, 0, 127}), Line(visible = UseReset, points = {{60, -100}, {60, -80}}, color = {255, 0, 255}, pattern = LinePattern.Dot), Text(visible = UseReset, extent = {{-28, -62}, {94, -86}}, textString = "reset")}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-60, 60}, {60, -60}}, lineColor = {0, 0, 255}), Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}), Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255}), Text(extent = {{-36, 60}, {32, 2}}, textString = "K"), Text(extent = {{-32, 0}, {36, -58}}, textString = "s"), Line(points = {{-46, 0}, {46, 0}})}));
end IntegratorSetFreeze;
