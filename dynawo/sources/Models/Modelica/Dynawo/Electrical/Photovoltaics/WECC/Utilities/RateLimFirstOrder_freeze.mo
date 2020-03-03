within Dynawo.Electrical.Photovoltaics.WECC.Utilities;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/


block RateLimFirstOrder_freeze "First order transfer function block (= 1 pole)"
  import Modelica.Blocks.Types.Init;
  import Dynawo.Connectors;
  import Dynawo.Types;
  import Modelica.Blocks;
  import Modelica.ComplexMath;

  parameter Real k(unit = "1") = 1 "Gain";
  parameter Types.Time T(start = 1) "Time Constant";
  parameter Init initType = Init.NoInit "Type of initialization (1: no init, 2: steady state, 3/4: initial output)" annotation(
    Evaluate = true,
    Dialog(group = "Initialization"));
  parameter Real y_start = 0 "Initial or guess value of output (= state)" annotation(
    Dialog(group = "Initialization"));
  parameter Boolean use_freeze = false "= if true, freeze port enabled" annotation(
  Evaluate = true,
  HideResult = true,
  choices(checkBox = true));
  parameter Boolean use_rateLim = false "= if true, rate limiter ports enabled" annotation(
  Evaluate = true,
  HideResult = true,
  choices(checkBox = true));

  extends Blocks.Interfaces.SISO(y(start = y_start));

  Blocks.Interfaces.BooleanInput freeze if use_freeze annotation(
    Placement(visible = true, transformation(origin = {3,-119}, extent = {{-19, -19}, {19, 19}}, rotation = 90), iconTransformation(origin = {-56, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Blocks.Interfaces.RealInput dy_min if use_rateLim annotation(
    Placement(visible = true, transformation(origin = {-119, -79}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {-113, -63}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Blocks.Interfaces.RealInput dy_max if use_rateLim annotation(
    Placement(visible = true, transformation(origin = {-119, 79}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {-113, 69}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));

protected
  Blocks.Interfaces.BooleanOutput local_freeze annotation(
    HideResult = true);
  Blocks.Interfaces.RealOutput local_dymin annotation(
    HideResult = true);
  Blocks.Interfaces.RealOutput local_dymax annotation(
    HideResult = true);

initial equation
  if initType == Init.SteadyState then
    der(y) = 0;
  elseif initType == Init.InitialState or initType == Init.InitialOutput then
    y = y_start;
  end if;

equation
  if use_freeze then
    connect(freeze,local_freeze);
  else
    local_freeze = false;
  end if;

  if use_rateLim then
    connect(local_dymin,dy_min);
    connect(local_dymax,dy_max);
  else
    local_dymin = -9999;
    local_dymax =  9999;
  end if;

  if local_freeze then
    der(y) = 0;
  else
    der(y) = min(max((k * u - y) / T,local_dymin),local_dymax);
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
If you would like to be able to change easily between different
transfer functions (FirstOrder, SecondOrder, ... ) by changing
parameters, use the general block <strong>TransferFunction</strong> instead
and model a first order SISO system with parameters<br>
b = {k}, a = {T, 1}.
</p>
<pre>
Example:
 parameter: k = 0.3, T = 0.4
 results in:
           0.3
    y = ----------- * u
        0.4 s + 1.0
</pre>

<p>
<strong>Extended with Freeze functionality:</strong> If boolean input is set to true, the derrivative of the state variable is set to zero.
</p>

</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Line(origin = {-26.667, 6.667}, points = {{106.667, 43.333}, {-13.333, 29.333}, {-53.333, -86.667}}, color = {0, 0, 127}, smooth = Smooth.Bezier), Text(lineColor = {192, 192, 192}, extent = {{0, -60}, {60, 0}}, textString = "PT1"), Text(origin = {26, 8}, extent = {{-150, -150}, {150, -110}}, textString = "T=%T")}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Text(extent = {{-48, 52}, {50, 8}}, textString = "k"), Text(extent = {{-54, -6}, {56, -56}}, textString = "T s + 1"), Line(points = {{-50, 0}, {50, 0}}), Rectangle(extent = {{-60, 60}, {60, -60}}, lineColor = {0, 0, 255}), Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}), Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255})}));
end RateLimFirstOrder_freeze;
