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

model RateLimFirstOrderFreeze "First order transfer function block with rate limiter and freeze functionality"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Real k = 1 "Gain";
  parameter Types.Time T(start = 1) "Time Constant in s";
  parameter Real Y0 = 0 "Initial or guess value of output (= state)";
  parameter Boolean UseFreeze = false "= if true, freeze port enabled" annotation(
  Evaluate = true,
  HideResult = true,
  choices(checkBox = true));
  parameter Boolean UseRateLim = false "= if true, rate limiter ports enabled" annotation(
  Evaluate = true,
  HideResult = true,
  choices(checkBox = true));

  Modelica.Blocks.Interfaces.BooleanInput freeze if UseFreeze annotation(
    Placement(visible = true, transformation(origin = {0,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-56, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput dyMin if UseRateLim annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -63}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput dyMax if UseRateLim annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 69}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

protected
  Modelica.Blocks.Interfaces.BooleanOutput local_freeze annotation(
    HideResult = true);
  Modelica.Blocks.Interfaces.RealOutput dyMinLocal annotation(
    HideResult = true);
  Modelica.Blocks.Interfaces.RealOutput dyMaxLocal annotation(
    HideResult = true);

equation
  if UseFreeze then
    connect(freeze,local_freeze);
  else
    local_freeze = false;
  end if;

  if UseRateLim then
    connect(dyMinLocal,dyMin);
    connect(dyMaxLocal,dyMax);
  else
    dyMinLocal = -9999;
    dyMaxLocal = 9999;
  end if;

  if local_freeze then
    der(y) = 0;
  else
    der(y) = min(max((k * u - y) / T, dyMinLocal), dyMaxLocal);
  end if;

  annotation(
    Documentation(info = "<html>
<p>
This blocks defines the transfer function between the input u
and the output y as <em>first order</em> system:
</p>
<pre>
             k
   y = ------------ * u
          T * s + 1
</pre>

<p>
<strong>Extended with Freeze functionality:</strong> If boolean input is set to true, the derivative of the state variable is set to zero.
</p>

</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Line(origin = {-26.667, 6.667}, points = {{106.667, 43.333}, {-13.333, 29.333}, {-53.333, -86.667}}, color = {0, 0, 127}, smooth = Smooth.Bezier), Text(lineColor = {192, 192, 192}, extent = {{0, -60}, {60, 0}}, textString = "PT1"), Text(origin = {26, 8}, extent = {{-150, -150}, {150, -110}}, textString = "T=%T")}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Text(extent = {{-48, 52}, {50, 8}}, textString = "k"), Text(extent = {{-54, -6}, {56, -56}}, textString = "T s + 1"), Line(points = {{-50, 0}, {50, 0}}), Rectangle(lineColor = {0, 0, 255},extent = {{-60, 60}, {60, -60}}), Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}), Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255})}));
end RateLimFirstOrderFreeze;
