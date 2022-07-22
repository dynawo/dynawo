within Dynawo.Electrical.Controls.Utilities;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block TransferFunction "Linear transfer function"
    import Modelica;
    extends Modelica.Blocks.Interfaces.SISO;

    parameter Real b[:]={1}
      "Numerator coefficients of transfer function (e.g., 2*s+3 is specified as {2,3})";
    parameter Real a[:]={1}
      "Denominator coefficients of transfer function (e.g., 5*s+6 is specified as {5,6})";
    parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
      "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                       annotation(Evaluate=true, Dialog(group=
            "Initialization"));
    parameter Real x_start[size(a, 1) - 1]=zeros(nx)
      "Initial or guess values of states"
      annotation (Dialog(group="Initialization"));
    parameter Real y_start=0
      "Initial value of output (derivatives of y are zero up to nx-1-th derivative)"
      annotation(Dialog(enable=initType == Init.InitialOutput, group=
            "Initialization"));
    output Real x[size(a, 1) - 1](start=x_start)
      "State of transfer function from controller canonical form";
    Real x_scaled[size(x,1)] (start=x_start) "Scaled vector x";
  protected
    parameter Integer na=size(a, 1) "Size of Denominator of transfer function.";
    parameter Integer nb=size(b, 1) "Size of Numerator of transfer function.";
    parameter Integer nx=size(a, 1) - 1;
    parameter Real bb[:] = vector([zeros(max(0,na-nb),1);b]);
    parameter Real d = bb[1]/a[1];
    parameter Real a_end = if a[end] > 100*Modelica.Constants.eps*sqrt(a*a) then a[end] else 1.0;

  equation
    assert(size(b,1) <= size(a,1), "Transfer function is not proper");
    if nx == 0 then
       y = d*u;
    else
       der(x_scaled[1])    = (-a[2:na]*x_scaled + a_end*u)/a[1];
       der(x_scaled[2:nx]) = x_scaled[1:nx-1];
       y = ((bb[2:na] - d*a[2:na])*x_scaled)/a_end + d*u;
       x = x_scaled/a_end;
    end if;
    annotation (
      Documentation(info="<html>
<p>
This block defines the transfer function between the input
u and the output y
as (nb = dimension of b, na = dimension of a):
</p>
<pre>
           b[1]*s^[nb-1] + b[2]*s^[nb-2] + ... + b[nb]
   y(s) = --------------------------------------------- * u(s)
           a[1]*s^[na-1] + a[2]*s^[na-2] + ... + a[na]
</pre>
<p>
State variables <strong>x</strong> are defined according to <strong>controller canonical</strong>
form. Internally, vector <strong>x</strong> is scaled to improve the numerics (the states in versions before version 3.0 of the Modelica Standard Library have been not scaled). This scaling is
not visible from the outside of this block because the non-scaled vector <strong>x</strong>
is provided as output signal and the start value is with respect to the non-scaled
vector <strong>x</strong>.
Initial values of the states <strong>x</strong> can be set via parameter <strong>x_start</strong>.
</p>

<p>
Example:
</p>
<pre>
     TransferFunction g(b = {2,4}, a = {1,3});
</pre>
<p>
results in the following transfer function:
</p>
<pre>
        2*s + 4
   y = --------- * u
         s + 3
</pre>
</html>"),
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
