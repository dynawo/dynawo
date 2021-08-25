within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block IntegratorSetFreeze "Outputs the integral of the input signal with optional reset and optional state freeze"
  import Modelica;
  import Modelica.Blocks;
  import Modelica.Blocks.Types.Init;

  extends Blocks.Interfaces.SISO(y(start = y_start));

  parameter Real k(unit = "1") = 1 "Integrator gain";
  parameter Boolean use_reset = false "=true, if reset port enabled" annotation(
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));
  parameter Boolean use_set = false "=true, if set port enabled and used as reinitialization value when reset" annotation(
    Dialog(enable = use_reset),
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));
  parameter Boolean use_freeze = false "=true, if freeze port enabled" annotation(
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));
  parameter Init initType = Init.InitialState "Type of initialization (1: no init, 2: steady state, 3,4: initial output)" annotation(
    Evaluate = true,
    Dialog(group = "Initialization"));
  parameter Real y_start = 0 "Initial or guess value of output (= state)" annotation(
    Dialog(group = "Initialization"));

  Blocks.Interfaces.BooleanInput reset if use_reset "Optional connector of reset signal" annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {60, -120})));
  Blocks.Interfaces.RealInput set if use_reset and use_set "Optional connector of set signal" annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 270, origin = {60, 120})));
  Blocks.Interfaces.BooleanInput freeze if use_freeze "Optional connector of set signal" annotation(
    Placement(visible = true, transformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

protected
  Blocks.Interfaces.BooleanOutput local_reset annotation(
    HideResult = true);
  Blocks.Interfaces.BooleanOutput local_freeze annotation(
    HideResult = true);
  Blocks.Interfaces.RealOutput local_set annotation(
    HideResult = true);

initial equation
  if initType == Init.SteadyState then
    der(y) = 0;
  elseif initType == Init.InitialState or initType == Init.InitialOutput then
    y = y_start;
  end if;

equation
  if use_reset then
    connect(reset, local_reset);
    if use_set then
      connect(set, local_set);
    else
      local_set = y_start;
    end if;
    when local_reset then
      reinit(y, local_set);
    end when;
  else
    local_reset = false;
    local_set = 0;
  end if;

  if use_freeze then
    connect(freeze, local_freeze);
  else
    local_freeze = false;
  end if;

  if local_freeze then
    der(y) = 0;
  else
    der(y) = k * u;
  end if;

  annotation(
    Documentation(info = "<html>
<p>
This blocks computes output <strong>y</strong> as
<em>integral</em> of the input <strong>u</strong> multiplied with
the gain <em>k</em>:
</p>
<pre>
         k
     y = - u
         s
</pre>

<p>
It might be difficult to initialize the integrator in steady state.
This is discussed in the description of package
<a href=\"modelica://Modelica.Blocks.Continuous#info\">Continuous</a>.
</p>

<p>
If the <em>reset</em> port is enabled, then the output <strong>y</strong> is reset to <em>set</em>
or to <em>y_start</em> (if the <em>set</em> port is not enabled), whenever the <em>reset</em>
port has a rising edge.
</p>

<p>
<strong>Extended with Freeze functionality:</strong> If boolean input is set to true, the derivative of the state variable is set to zero.
</p>

</html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}), graphics = {Line(points = {{-80.0, 78.0}, {-80.0, -90.0}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80.0, 90.0}, {-88.0, 68.0}, {-72.0, 68.0}, {-80.0, 90.0}}), Line(points = {{-90.0, -80.0}, {82.0, -80.0}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90.0, -80.0}, {68.0, -72.0}, {68.0, -88.0}, {90.0, -80.0}}), Text(lineColor = {192, 192, 192}, extent = {{0.0, -70.0}, {60.0, -10.0}}, textString = "I"), Text(extent = {{-150.0, -150.0}, {150.0, -110.0}}, textString = "k=%k"), Line(points = DynamicSelect({{-80.0, -80.0}, {80.0, 80.0}}, if use_reset then {{-80.0, -80.0}, {60.0, 60.0}, {60.0, -80.0}, {80.0, -60.0}} else {{-80.0, -80.0}, {80.0, 80.0}}), color = {0, 0, 127}), Line(visible = use_reset, points = {{60, -100}, {60, -80}}, color = {255, 0, 255}, pattern = LinePattern.Dot), Text(visible = use_reset, extent = {{-28, -62}, {94, -86}}, textString = "reset")}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-60, 60}, {60, -60}}, lineColor = {0, 0, 255}), Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}), Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255}), Text(extent = {{-36, 60}, {32, 2}}, textString = "k"), Text(extent = {{-32, 0}, {36, -58}}, textString = "s"), Line(points = {{-46, 0}, {46, 0}})}));
end IntegratorSetFreeze;
