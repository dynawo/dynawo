within Dynawo.NonElectrical.Blocks.NonLinear;

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

block MultiSwitch "Switch between N Real signals"
  
  parameter Integer nu(min=0) = 0 "Number of input connections" annotation(
    Dialog(connectorSizing=true), HideResult=true);
  parameter Boolean DynamicSelection=true "The output is selected depending on an integer input(1) or an integer parameter (0)";
  parameter Integer fp=1 " Integer parameter to select the output signal";

  Modelica.Blocks.Interfaces.RealVectorInput u[nu] "Connector of Real vector input signal" annotation(
    Placement(transformation(extent={{-120,70},{-80,-70}})));
  Modelica.Blocks.Interfaces.IntegerInput fd if DynamicSelection "Connector of Integer input signal to select the output signal" annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if DynamicSelection then
  assert(fd + 1 <= nu, "MultiSwitch: Inputs must be consistent. However, there are not enough inputs connected :
    fd + 1 (= " + String(fd + 1) + ") > nu (= " + String(nu) + ")");
  assert(fd >= 0, "MultiSwitch: fd must be positive. However, fd = " + String(fd));
    y = u[fd+1];
  else
    y = u[fp+1];
  end if;
  
  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Line(origin = {2.69362e-06, -2.31317e-06},points = {{-40, 44}, {2, -4}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-2, -36}, points = {{-100, 80}, {-38, 80}}, color = {0, 0, 127}), Line(origin = {0, 40},points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127}), Line(points = {{8, 0}, {100, 0}}, color = {0, 0, 127}), Ellipse(origin = {-8, 0},lineColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{2, -8}, {18, 8}}), Line(origin = {0, 60}, points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127}), Line(origin = {0, 100}, points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127}), Line(origin = {0, 80}, points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127}), Line(origin = {-79.9093, -0.250745}, rotation = -90, points = {{-100, 80}, {-24, 80}}, color = {245, 121, 0}), Line(origin = {-69.9094, 103.579}, rotation = 180, points = {{-76, 80}, {-64, 80}}, color = {245, 121, 0})}));
end MultiSwitch;
