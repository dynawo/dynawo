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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block TransferFunctionBypass "Linear transfer function, bypassed if highest-order coefficient of denominator is zero"
  extends Modelica.Blocks.Interfaces.SISO(y(start = y_start));

  parameter Real b[:] = {1} "Numerator coefficients of transfer function (e.g., 2*s+3 is specified as {2,3})";
  parameter Real a[:] = {1} "Denominator coefficients of transfer function (e.g., 5*s+6 is specified as {5,6})";

  output Real x[nx](start = x_start) "State of transfer function from controller canonical form";

  parameter Real x_start[nx] = zeros(nx) "Initial or guess values of states" annotation(
    Dialog(group = "Initialization"));
  parameter Real y_start = 0 "Initial value of output (derivatives of y are zero up to nx-1-th derivative)" annotation(
    Dialog(group = "Initialization"));

protected
  parameter Integer na = size(a, 1) "Size of denominator of transfer function";
  parameter Integer nb = size(b, 1) "Size of numerator of transfer function";
  parameter Integer nx = size(a, 1) - 1 "Size of vector x";
  parameter Real bb[:] = vector([zeros(max(0,na-nb),1);b]) "Numerator coefficients, padded if necessary by zeroes for highest-order coefficients";
  parameter Real d = bb[1] / a_one "Ratio of highest-order coefficients of numerator and denominator";
  parameter Real a_one = if a[1] > 100 * Modelica.Constants.eps then a[1] else 1 "Non-zero value of highest-order coefficient of denominator";
  parameter Real a_end = if a[end] > 100 * Modelica.Constants.eps * sqrt(a*a) then a[end] else 1 "Non-zero value of lowest-order coefficient of denominator";

  Real x_scaled[nx](start = a_end * x_start) "Scaled vector x";

equation
  assert(size(b,1) <= size(a,1), "Transfer function is not proper");

  if a[1] <= 100 * Modelica.Constants.eps then
    y = u;
    if nx > 0 then
      der(x_scaled[1:nx]) = zeros(nx);
      x = x_start;
    end if;
  elseif nx == 0 then
    y = d*u;
  else
    der(x_scaled[1])    = (-a[2:na]*x_scaled + a_end*u) / a_one;
    der(x_scaled[2:nx]) = x_scaled[1:nx-1];
    y = ((bb[2:na] - d*a[2:na])*x_scaled) / a_end + d*u;
    x = x_scaled / a_end;
  end if;

  annotation(
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
vector <strong>x</strong>.
Initial values of the states <strong>x</strong> can be set via parameter <strong>x_start</strong>.</p>

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
       s + 3</pre><p><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">This block differs from the one of the same name in the Modelica Standard Library</span>&nbsp;on two counts :</p><ul><li>If the highest-order component of the denominator is zero, the block returns the input as output;</li><li>The initial equations are absent since Dynawo ignores them, start values are given for&nbsp;<b>y</b>&nbsp;and for&nbsp;<b>x_scaled</b>&nbsp;instead.</li></ul><p></p>
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
end TransferFunctionBypass;
