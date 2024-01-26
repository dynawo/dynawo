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
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-3, 115}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
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
    Icon(coordinateSystem(extent = {{-50, -100}, {50, 100}}), graphics = {Rectangle(extent = {{-50, 100}, {50, -100}})}),
  Diagram(coordinateSystem(extent = {{-50, -100}, {50, 100}})));
end MultiSwitchNoVector;
