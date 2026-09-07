within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

block TransferFunction "Linear transfer function"
  import Modelica.Blocks.Types.Init;

  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Real b[:] = {1} "Numerator coefficients of transfer function (e.g., 2*s+3 is specified as {2,3})";
  parameter Real a[:] = {1} "Denominator coefficients of transfer function (e.g., 5*s+6 is specified as {5,6})";

  output Real x[nx](start = X0) "State of transfer function from controller canonical form";

  parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.NoInit "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)" annotation(
    Dialog(group = "Initialization"));
  parameter Real u_start = 0 "Initial value of input (SteadyState)" annotation(
    Dialog(enable = initType == Init.SteadyState, group = "Initialization"));
  parameter Real x_start[nx] = zeros(nx) "Initial or guess values of states (InitialState or InitialOutput)" annotation(
    Dialog(enable = initType == Init.InitialState or initType == Init.InitialOutput, group = "Initialization"));
  parameter Real y_start = 0 "Initial value of output (derivatives of y are zero up to nx-1-th derivative) (InitialState or InitialOutput)" annotation(
    Dialog(enable = initType == Init.InitialState or initType == Init.InitialOutput, group = "Initialization"));

protected
  parameter Integer na = size(a, 1) "Size of denominator of transfer function";
  parameter Integer nb = size(b, 1) "Size of numerator of transfer function";
  parameter Integer nx = size(a, 1) - 1 "Size of vector x";
  parameter Real bb[:] = vector([zeros(max(0,na-nb),1);b]) "Numerator coefficients, padded if necessary by zeroes for highest-order coefficients";
  parameter Real d = bb[1] / a[1] "Ratio of highest-order coefficients of numerator and denominator";
  parameter Real a_end = if a[end] > 100 * Modelica.Constants.eps * sqrt(a*a) then a[end] else 1 "Non-zero value of lowest-order coefficient of denominator";
  parameter Real X0[nx] = if nx == 0 then {0} elseif initType == Init.SteadyState then cat(1, zeros(nx-1), {u_start / a_end}) elseif initType == Init.InitialState or initType == Init.InitialOutput then x_start else zeros(nx) "Initial or guess values of states";
  parameter Real Y0 = if initType == Init.SteadyState then u_start * b[end] / a_end elseif initType == Init.InitialState or initType == Init.InitialOutput then y_start else 0 "Initial value of output (derivatives of y are zero up to nx-1-th derivative)";

  Real x_scaled[nx](start = X0 * a_end) "Scaled vector x";

equation
  assert(size(b,1) <= size(a,1), "Transfer function is not proper");

  if nx == 0 then
    y = d*u;
  else
    der(x_scaled[1])    = (-a[2:na]*x_scaled + a_end*u) / a[1];
    der(x_scaled[2:nx]) = x_scaled[1:nx-1];
    y = ((bb[2:na] - d*a[2:na])*x_scaled) / a_end + d*u;
    x = x_scaled / a_end;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info= "<html><head></head><body><p>
This block defines the transfer function between the input
u and the output y
as (nb = dimension of b, na = dimension of a):
</p>
<pre>         b[1]*s^[nb-1] + b[2]*s^[nb-2] + ... + b[nb]
 y(s) = --------------------------------------------- * u(s)
         a[1]*s^[na-1] + a[2]*s^[na-2] + ... + a[na]
</pre>
<p>
State variables <strong>x</strong> are defined according to <strong>controller canonical</strong>
form. Internally, vector <strong>x</strong> is scaled to improve the numerics (the states in versions before version 3.0 of the Modelica Standard Library have been not scaled). This scaling is
not visible from the outside of this block because the non-scaled vector <strong>x</strong>
is provided as output signal and the start value is with respect to the non-scaled
vector <strong>x</strong>.&nbsp;</p>

<p>
Example:
</p>
<pre>   TransferFunction g(b = {2,4}, a = {1,3});
</pre>
<p>
results in the following transfer function:
</p>
<pre>      2*s + 4
 y = --------- * u
       s + 3</pre><p>This block differs from the one of the same name in the Modelica Standard Library in one respect : the initial equations are absent since Dynawo ignores them, start values are given for&nbsp;<b>y</b>&nbsp;and for&nbsp;<b>x_scaled</b>&nbsp;instead.<br><br>Three initialization options are available :</p><p></p><ul><li>NoInit : <b>x</b>, <b>x_scaled</b> and <b>y</b> are initialized at 0;</li><li>SteadyState : the initial values of <b>x</b>, <b>x_scaled</b> and <b>y</b> depend on <b>u_start</b> (a parameter for the initial input value) with the goal of having derivative values equal to 0;</li><li>InitialState or InitialOutput : <b>x</b> and <b>x_scaled</b> are initialized on the basis of <b>x_start</b>, <b>y</b> is initialized at <b>y_start</b>.</li></ul>
</body></html>"),
    Icon(
        coordinateSystem(preserveAspectRatio=true,
          extent={{-100.0,-100.0},{100.0,100.0}}),
          graphics={
        Line(points={{-80.0,0.0},{80.0,0.0}},
          color={0,0,127}),
      Text(lineColor={0,0,127},
        extent={{-90.0,10.0},{90.0,90.0}},
        textString="b(s)"),
      Text(lineColor={0,0,127},
        extent={{-90.0,-90.0},{90.0,-10.0}},
        textString="a(s)")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{40,0},{-40,0}}),
        Text(
          extent={{-55,55},{55,5}},
          textString="b(s)"),
        Text(
          extent={{-55,-5},{55,-55}},
          textString="a(s)"),
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255})}));
end TransferFunction;
