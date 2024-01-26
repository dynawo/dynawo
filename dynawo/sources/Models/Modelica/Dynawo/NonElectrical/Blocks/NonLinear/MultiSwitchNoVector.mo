within Dynawo.NonElectrical.Blocks.NonLinear;

block MultiSwitchNoVector "Switch between N Real signals"
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
  Modelica.Blocks.Interfaces.RealInput u0 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-140, 60}, {-100, 100}}, rotation = 0), iconTransformation(origin = {-64, 80}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-140, 60}, {-100, 100}}, rotation = 0), iconTransformation(origin = {-64, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u2 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-140, 60}, {-100, 100}}, rotation = 0), iconTransformation(origin = {-64, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u3 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-140, 60}, {-100, 100}}, rotation = 0), iconTransformation(origin = {-64, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u4 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-140, 60}, {-100, 100}}, rotation = 0), iconTransformation(origin = {-64, -80}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput selection "Connector of Integer input signal to select the output signal" annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {1, 113}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


equation
  assert(selection <= 4, "MultiSwitchNoVector: Integer input (signal selector) is out of range.");
  
  if selection == 0 then
    y = u0;
  elseif selection == 1 then
    y = u1;
  elseif selection == 2 then
    y = u2;
  elseif selection == 3 then
    y = u3;
  else
    y = u4;
  end if;

annotation(
    Icon(coordinateSystem(extent = {{-50, -100}, {50, 100}}), graphics = {Rectangle(extent = {{-50, 100}, {50, -100}}), Ellipse(origin = {-8, 0}, lineColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{2, -8}, {18, 8}}), Line(points = {{8, 0}, {50, 0}}, color = {0, 0, 127}), Line(origin = {50.8094, 0.306483}, points = {{-100, 80}, {-80, 80}}, color = {0, 0, 127}), Line(origin = {49.9843, -39.7688}, points = {{-100, 80}, {-80, 80}}, color = {0, 0, 127}), Line(origin = {49.6348, -79.8632}, points = {{-100, 80}, {-80, 80}}, color = {0, 0, 127}), Line(origin = {48.8097, -119.938}, points = {{-100, 80}, {-80, 80}}, color = {0, 0, 127}), Line(origin = {49.397, -160.463}, points = {{-100, 80}, {-80, 80}}, color = {0, 0, 127}), Line(origin = {0.412574, -0.412574}, points = {{-30, 80}, {0, 0}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-79.9093, -0.250745}, rotation = -90, points = {{-100, 80}, {-36, 80}}, color = {245, 121, 0}), Line(origin = {-70.2383, 116.104}, rotation = 180, points = {{-76, 80}, {-64, 80}}, color = {245, 121, 0})}),
    Diagram(coordinateSystem(extent = {{-50, -100}, {50, 100}})));
end MultiSwitchNoVector;
