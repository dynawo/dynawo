within Dynawo.NonElectrical.Blocks.Continuous;

block IntegratorFixLimits "Anti windup proportional integral controller"
  /*
    * Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
    * See AUTHORS.txt
    * All rights reserved.
    * This Source Code Form is subject to the terms of the Mozilla Public
    * License, v. 2.0. If a copy of the MPL was not distributed with this
    * file, you can obtain one at http://mozilla.org/MPL/2.0/.
    * SPDX-License-Identifier: MPL-2.0
    *
    * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
    */
  import Modelica;
  import Dynawo;
  import Modelica.Blocks.Interfaces;
  import Modelica.Blocks.Icons.Block;
  import Modelica.Constants;
  extends Block;
  /*Parameters*/
  parameter Real uMax(start=1) "Upper limits of input signals";
  parameter Real uMin= -uMax "Lower limits of input signals";
  parameter Real k(unit = "1") = 1 "Integrator gain";
  parameter Real y_start "Initial or guess value of output (= state)";
  parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialState "Type of initialization (1: no init, 2: steady state, 3,4: initial output)";
  parameter Types.PerUnit GainAW;
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Continuous.Integrator integrator(k = k, y_start = y_start) annotation(
    Placement(visible = true, transformation(origin = {4, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = +1, k2 = -GainAW) annotation(
    Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = +1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-42, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = uMax, uMin = uMin) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
equation
/*Connectors*/
  connect(integrator.y, add1.u1) annotation(
    Line(points = {{20.5, 0}, {30, 0}, {30, -28}, {-30, -28}}, color = {0, 0, 127}));
  connect(add.y, integrator.u) annotation(
    Line(points = {{-33, 0}, {-14, 0}}, color = {0, 0, 127}));
  connect(add1.y, add.u2) annotation(
    Line(points = {{-53, -34}, {-68, -34}, {-68, -6}, {-58, -6}, {-58, -6.5}, {-56, -6.5}, {-56, -6}}, color = {0, 0, 127}));
  connect(u, add.u1) annotation(
    Line(points = {{-120, 0}, {-78, 0}, {-78, 6}, {-56, 6}}, color = {0, 0, 127}));
//
//
  connect(integrator.y, limiter.u) annotation(
    Line(points = {{20, 0}, {43, 0}}, color = {0, 0, 127}));
  connect(limiter.y, y) annotation(
    Line(points = {{76, 0}, {102, 0}, {102, 0}, {120, 0}}, color = {0, 0, 127}));
  connect(limiter.y, add1.u2) annotation(
    Line(points = {{76, 0}, {90, 0}, {90, -40}, {-30, -40}, {-30, -40}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-80, -20}, {80, 20}}, textString = "Fix"), Text(origin = {0, 50}, extent = {{-100, -20}, {100, 20}}, textString = "Integrator"), Text(origin = {0, -50}, extent = {{-60, -20}, {70, 20}}, textString = "Limits")}, coordinateSystem(initialScale = 0.1)));
end IntegratorFixLimits;
