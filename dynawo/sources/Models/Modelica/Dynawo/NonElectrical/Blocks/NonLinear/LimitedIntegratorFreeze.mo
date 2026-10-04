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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block LimitedIntegratorFreeze "Integrator with limited value of the output and a freeze port"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Types.PerUnit K = 1 "Integrator gain";
  parameter Real YMax "Upper limit of output";
  parameter Real YMin "Lower limit of output";

  Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(transformation(origin = {-120, 58}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-82, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  parameter Real Y0 = 0 "Initial or guess value of output (must be in the limits YMin .. YMax)" annotation(
    Dialog(group = "Initialization"));

equation
  if freeze then
    der(y) = 0;
  else
    if y >= YMax and K*u > 0 then
      der(y) = 0;
    elseif y<= YMin and K*u < 0 then
      der(y) = 0;
    else
      der(y) = K*u;
    end if;
  end if;

  annotation(
    preferredView = "text",
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(
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
        Line(
          points=DynamicSelect({{-80,-80},{20,20},{80,20}}, {{-80,-80},{20,20},{80,20}}),
          color={0,0,127}),
        Text(
          extent={{0,-10},{60,-70}},
          lineColor={192,192,192},
          textString="I"),
        Text(
          extent={{-150,-150},{150,-110}},
          textString="K=%K"),
        Line(
          points={{60,-100},{60,-80}},
          color={255,0,255},
          pattern=LinePattern.Dot)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Text(
          extent={{-54,46},{-4,-48}},
          textString="lim"),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-8,60},{60,2}},
          textString="k"),
        Text(
          extent={{-8,-2},{60,-60}},
          textString="s"),
        Line(points={{4,0},{46,0}})}));
end LimitedIntegratorFreeze;
