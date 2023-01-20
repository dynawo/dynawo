within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of time domain simulation tools for power systems.
*/

block DiscretePI "Proportional integrator with discrete input"
  import Dynawo.Types;
  import Modelica.Blocks.Interfaces;
  import Modelica;

  parameter Real Gain "Control gain";
  parameter Types.Time tIntegral "Time integration constant";

  discrete Interfaces.RealInput u "Input connector" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Interfaces.RealOutput y(start = Y0) "Output of the PI controller." annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.PI pi(T = tIntegral, k = Gain, x_start = Y0/Gain, y_start=Y0) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Real Y0 "Start value of the PI output ";

equation
  connect(u, pi.u) annotation(
    Line(points = {{-100, 0}, {-13, 0}, {-13, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(pi.y, y) annotation(
    Line(points = {{11, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));

  annotation(defaultComponentName="DiscretePI",
    Documentation(info="<html>
<p>
This block is a dynawo-compatible wrapper around Modelica's PI block constrained to discrete inputs. It defines the transfer function between the input u and
the output y as <em>PI</em> system:
</p>
<pre>
                        1
 y = Gain * (1 + -------------) * u
                  tIntegral*s
             tIntegral*s + 1
   = Gain * ----------------- * u
               tIntegral*s
</pre>


</html>"), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points = {{-80.0,-80.0},{-80.0,-20.0},{60.0,80.0}}, color = {0,0,127}),
        Text(
          extent={{0,6},{60,-56}},
          lineColor={192,192,192},
          textString="PI"),
        Text(
          extent={{-150,-150},{150,-110}},
          textString="T=%T")}));
end DiscretePI;
