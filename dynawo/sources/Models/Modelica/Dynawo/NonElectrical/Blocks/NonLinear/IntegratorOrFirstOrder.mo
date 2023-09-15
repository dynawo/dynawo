within Dynawo.NonElectrical.Blocks.NonLinear;

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

block IntegratorOrFirstOrder "Switch between two operators : integrator, first-order filter"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit K = 1 "Integrator gain";
  parameter Types.Time tFilter "First-order time constant in s";
  parameter Real Y0 "Value of y at initial time" annotation(
    Dialog(group="Initialization"));

  Modelica.Blocks.Interfaces.RealInput u1 "Connector of first Real input signal" annotation(
    Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.BooleanInput u2 "Connector of Boolean input signal" annotation(
    Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput u3 "Connector of second Real input signal" annotation(
    Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Connector of Real output signal" annotation(
    Placement(transformation(extent={{100,-10},{120,10}})));

equation
  if u2 then
    der(y) = K * u1;
  else
    der(y) = (u3 - y) / tFilter;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info= "<html><head></head><body><p>The IntegratorOrFirstOrder switches, depending on the
logical connector u2 (the middle connector)
between the two possible input signals
u1 (upper connector) and u3 (lower connector) and applies different operations to them.</p><p>If u2 is <strong>true</strong>, the output signal y is the result of an integration of u1.</p><p>If u2 is&nbsp;<strong>false</strong>,&nbsp;the output signal y&nbsp;is the result of a first order filter applied to u3.</p>
</body></html>"),
    Icon(coordinateSystem(
        initialScale = 0.1), graphics={
        Line(points={{12,0},{100,0}},
          color={0,0,127}),
        Line(points={{-100,0},{-40,0}},
          color={255,0,255}),
        Line(points={{-100,-80},{-40,-80},{-40,-80}},
          color={0,0,127}),
        Line(points={{-40,12},{-40,-12}},
          color={255,0,255}),
        Line(points={{-100,80},{-38,80}},
          color={0,0,127}),
        Line(points = {{-38, 80}, {6, 2}},
          color = {0, 0, 127}, thickness = 1),
        Ellipse(lineColor = {0, 0, 255}, pattern = LinePattern.None,
          fillPattern = FillPattern.Solid, extent = {{2, -8}, {18, 8}}, endAngle = 360),
        Text(lineColor = {192, 192, 192}, extent = {{20, 20}, {80, 80}}, textString = "I"),
        Text(lineColor = {192, 192, 192}, extent = {{20, -20}, {80, -80}}, textString = "F")}));
end IntegratorOrFirstOrder;
