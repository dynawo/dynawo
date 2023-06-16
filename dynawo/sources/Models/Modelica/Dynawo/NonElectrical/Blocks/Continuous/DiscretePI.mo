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
  import Modelica;

  parameter Types.Time tIntegral "Time integration constant";

  discrete Modelica.Blocks.Interfaces.RealInput u "Input connector" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, -50}, {-100, -30}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput frozen(start = false) "True if the integration is blocked" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output of the PI controller." annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(y_start = Y0, k=1/tIntegral ) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) "Constant 0 value in case of frozen PI" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Real Y0 "Start value of the PI output";

equation
  connect(integrator.y, y) annotation(
  Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 127})); 
  connect(switch1.y, integrator.u) annotation(
    Line(points = {{-19, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(switch1.u3, u) annotation(
    Line(points = {{-42, -8}, {-80, -8}, {-80, -40}, {-110, -40}}, color = {0, 0, 127}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{-98, 40}, {-80, 40}, {-80, 8}, {-42, 8}}, color = {0, 0, 127}));
  connect(frozen, switch1.u2) annotation(
    Line(points = {{-110, 0}, {-42, 0}}));

  annotation(defaultComponentName="DiscretePI",
    Documentation(info="<html>
<p>
This block is a dynawo-compatible wrapper around Modelica's PI block constrained to discrete inputs. It defines the transfer function between the input u and
the output y as <em>PI</em> system:
</p>
<pre>
              1
 y = 	(--------------) * u
          tIntegral*s
</pre>


</html>"), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}),
        Line(points = {{-80, -80}, {-80, -20}, {60, 80}}, color = {0, 0, 127}),
        Text(lineColor = {192, 192, 192}, extent = {{0, 6}, {60, -56}}, textString = "PI"),
        Text(
          extent={{-150,-150},{150,-110}},
          textString="T=%T")}));
end DiscretePI;

