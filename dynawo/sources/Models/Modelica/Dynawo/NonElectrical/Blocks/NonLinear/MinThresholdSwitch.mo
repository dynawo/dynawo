within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block MinThresholdSwitch "Switch between two real values, depending on the input crossing a min threshold"
  extends Modelica.Blocks.Icons.Block;

  parameter Real UMin "Minimum allowed u";
  parameter Real ySatMin "y value when u <= UMin";
  parameter Real yNotSatMin "y value when u > UMin";

  Modelica.Blocks.Interfaces.RealInput u(start = u0) "Input signal connector" annotation(Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(start = y0) "Output signal connector" annotation(Placement(
        transformation(extent={{100,-10},{120,10}})));

  parameter Real u0 = 0 "Initial input";
  parameter Real y0 = yNotSatMin "Initial output";

equation
  when u <= UMin then
    y = ySatMin;
  elsewhen (u > UMin) then
    y = yNotSatMin;
  end when;

  annotation(preferredView = "text",
      Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-50,30},{150,100}},
          textString=">",
          lineColor={0,0,255}),
        Text(
          extent={{-50,-30},{150,-100}},
          textString="<=",
          lineColor={0,0,255}),
        Line(points={{12.0,0.0},{100.0,0.0}},
          color={0,0,127}),
        Line(points={{-100.0,0.0},{-40.0,0.0}},
          color={255,0,255}),
        Line(points={{-100.0,-80.0},{-40.0,-80.0},{-40.0,-80.0}},
          color={0,0,127}),
        Line(points={{-40.0,12.0},{-40.0,-12.0}},
          color={255,0,255}),
        Line(points={{-100.0,80.0},{-38.0,80.0}},
          color={0,0,127}),
        Line(points={{-38.0,80.0},{6.0,2.0}},
          color={0,0,127},
          thickness=1.0),
        Ellipse(lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-8.0},{18.0,8.0}})}));
end MinThresholdSwitch;
