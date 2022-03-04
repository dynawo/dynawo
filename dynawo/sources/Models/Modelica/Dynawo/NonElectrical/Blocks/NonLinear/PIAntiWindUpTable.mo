within Dynawo.NonElectrical.Blocks.NonLinear;

model PIAntiWindUpTable "Integrator with wind up and discrete output"
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
  import Modelica;
  parameter Real Ki "Integrator constant";
  parameter Real U0 "Start value of input";
  parameter Real Y0 "Start value of output";
  parameter Real Kp "Gain constant";
  parameter String PiTableFile "Name of the file describing the table";
  parameter String PiTableName "Name of the table in the text file";
  Modelica.Blocks.Interfaces.RealInput u(start = U0) annotation(
    Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(tableOnFile = true, tableName = PiTableName, fileName = PiTableFile) annotation(
    Placement(visible = true, transformation(origin = {64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) annotation(
    Placement(visible = true, transformation(extent = {{138, -10}, {158, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback discreteError annotation(
    Placement(visible = true, transformation(origin = {44, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Ki, y_start = Y0 + U0) annotation(
    Placement(visible = true, transformation(origin = {-11, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-60, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-11, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {29, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-49, -6}, {-23, -6}}, color = {0, 0, 127}));
  connect(u, add1.u1) annotation(
    Line(points = {{-120, 0}, {-72, 0}}, color = {0, 0, 127}));
  connect(discreteError.y, add1.u2) annotation(
    Line(points = {{35, -36}, {-80, -36}, {-80, -12}, {-72, -12}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], y) annotation(
    Line(points = {{75, 0}, {148, 0}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], discreteError.u1) annotation(
    Line(points = {{75, 0}, {80, 0}, {80, -36}, {52, -36}}, color = {0, 0, 127}));
  connect(u, gain1.u) annotation(
    Line(points = {{-120, 0}, {-86, 0}, {-86, 28}, {-22, 28}}, color = {0, 0, 127}));
  connect(add.y, combiTable1D.u[1]) annotation(
    Line(points = {{40, 0}, {52, 0}}, color = {0, 0, 127}));
  connect(add.y, discreteError.u2) annotation(
    Line(points = {{40, 0}, {44, 0}, {44, -28}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{0, 28}, {8, 28}, {8, 6}, {18, 6}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{0, -6}, {18, -6}}, color = {0, 0, 127}));
  annotation(
    preferredView = Diagram,
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Line(points = {{-80, -80}, {-80, -20}, {60, 80}}, color = {0, 0, 127}), Text(lineColor = {192, 192, 192}, extent = {{0, 6}, {60, -56}}, textString = "PI"), Text(extent = {{-150, -150}, {150, -110}}, textString = "T=%T")}));
end PIAntiWindUpTable;
