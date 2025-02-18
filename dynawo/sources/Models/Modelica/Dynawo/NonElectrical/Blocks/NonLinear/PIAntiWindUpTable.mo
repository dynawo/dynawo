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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PIAntiWindUpTable "Proportional Integrator with anti-windup and table-based output. This model has discrete inputs and outputs."

  Dynawo.Connectors.ZPin u(value(start = U0)) "Input connector" annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ZPin y(value(start = Y0)) "Output connector" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Real Ki "Integrator constant";
  parameter Real Kp "Gain constant";
  parameter Real Kaw "Gain constant for AntiWindup";
  parameter String PiTableFile "Name of the file describing the table";
  parameter String PiTableName "Name of the table in the text file";

  Modelica.Blocks.Tables.CombiTable1Dv combiTable1D(tableOnFile = true, tableName = PiTableName, fileName = PiTableFile) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback discreteError annotation(
    Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Ki, y_start = Y0 + (1 - Kp) * U0) annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = Kaw) annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Real U0 "Start value of input";
  parameter Real Y0 "Start value of output";

equation
  if time >= 0 then
    y.value = combiTable1D.y[1];
  else
    y.value = pre(y.value);
  end if;

  connect(add1.y, integrator.u) annotation(
    Line(points = {{-59, -20}, {-41, -20}}, color = {0, 0, 127}));
  connect(discreteError.y, add1.u2) annotation(
    Line(points = {{51, -40}, {-100, -40}, {-100, -26}, {-82, -26}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], discreteError.u1) annotation(
    Line(points = {{101, 0}, {120, 0}, {120, -40}, {68, -40}}, color = {0, 0, 127}));
  connect(add.y, combiTable1D.u[1]) annotation(
    Line(points = {{41, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(add.y, discreteError.u2) annotation(
    Line(points = {{41, 0}, {60, 0}, {60, -32}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{-18, -20}, {0, -20}, {0, -6}, {18, -6}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{-18, 20}, {0, 20}, {0, 6}, {18, 6}}, color = {0, 0, 127}));
  u.value = gain1.u;
  u.value = add1.u1;

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}), Line(points = {{-80, -80}, {-80, -20}, {60, 80}}, color = {0, 0, 127}), Text(lineColor = {192, 192, 192}, extent = {{0, 6}, {60, -56}}, textString = "PI"), Text(extent = {{-150, -150}, {150, -110}}, textString = "T=%T")}),
    Diagram(coordinateSystem(extent = {{-120, -100}, {140, 100}})));
end PIAntiWindUpTable;
