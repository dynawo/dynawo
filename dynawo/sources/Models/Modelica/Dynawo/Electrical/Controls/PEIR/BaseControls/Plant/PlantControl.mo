within Dynawo.Electrical.Controls.PEIR.BaseControls.Plant;

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

model PlantControl "Generic plant controller"

  Modelica.Blocks.Interfaces.RealInput UPccPu annotation(
    Placement(visible = true, transformation(origin = {-114, -80}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-106, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPccPu annotation(
    Placement(visible = true, transformation(origin = {-114, -20}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-106, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPccPu annotation(
    Placement(visible = true, transformation(origin = {-114, -50}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-106, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tQFilt, y_start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-76, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tUFilt, y_start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-76, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-12, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {6, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpq) annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Kiq, outMax = 1, outMin = -1, y_start = IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {44, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {82, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QRefPu annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Lambda annotation(
    Placement(visible = true, transformation(origin = {-42, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(QPccPu, firstOrder1.u) annotation(
    Line(points = {{-114, -50}, {-88, -50}}, color = {0, 0, 127}));
  connect(UPccPu, firstOrder.u) annotation(
    Line(points = {{-114, -80}, {-88, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{-64, -80}, {-50, -80}, {-50, -68}, {-24, -68}}, color = {0, 0, 127}));
  connect(add.y, feedback1.u2) annotation(
    Line(points = {{-1, -62}, {6, -62}, {6, -28}}, color = {0, 0, 127}));
  connect(URefPccPu, feedback1.u1) annotation(
    Line(points = {{-114, -20}, {-2, -20}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{15, -20}, {23, -20}, {23, 0}, {31, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, limIntegrator.u) annotation(
    Line(points = {{15, -20}, {23, -20}, {23, -40}, {31, -40}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{55, 0}, {63, 0}, {63, -14}, {69, -14}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add1.u2) annotation(
    Line(points = {{55, -40}, {63, -40}, {63, -26}, {69, -26}}, color = {0, 0, 127}));
  connect(add1.y, QRefPu) annotation(
    Line(points = {{93, -20}, {110, -20}}, color = {0, 0, 127}));
  connect(Lambda.y, add.u1) annotation(
    Line(points = {{-30, -50}, {-28, -50}, {-28, -56}, {-24, -56}}, color = {0, 0, 127}));
  connect(firstOrder1.y, Lambda.u) annotation(
    Line(points = {{-64, -50}, {-54, -50}}, color = {0, 0, 127}));
end PlantControl;
