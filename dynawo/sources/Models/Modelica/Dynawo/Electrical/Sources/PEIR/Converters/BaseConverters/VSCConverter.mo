within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model VSCConverter "Simplified representation of a Voltage-Source Controller behavior"

  parameter Types.Time tVSC "VSC time response in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = UdConv0Pu) "Converter d-axis voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-116, 40}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-109.5, 39.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = UqConv0Pu) "Converter q-axis voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-114, -40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-109.5, -39.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput udConvPu(start = UdConv0Pu) "Converter d-axis voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvPu(start = UqConv0Pu) "Converter q-axis voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tVSC, y_start = UdConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tVSC, y_start = UqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit UdConv0Pu "Start value of converter d-axis voltage in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of converter q-axis voltage in pu (base UNom)";

equation
  connect(firstOrder.y, udConvPu) annotation(
    Line(points = {{12, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(udConvRefPu, firstOrder.u) annotation(
    Line(points = {{-116, 40}, {-12, 40}}, color = {0, 0, 127}));
  connect(uqConvRefPu, firstOrder1.u) annotation(
    Line(points = {{-114, -40}, {-12, -40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, uqConvPu) annotation(
    Line(points = {{12, -40}, {110, -40}}, color = {0, 0, 127}));

annotation(preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1})));
end VSCConverter;
