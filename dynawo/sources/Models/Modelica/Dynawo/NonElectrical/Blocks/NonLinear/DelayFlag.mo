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
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block DelayFlag

  parameter Types.PerUnit Ts "Delay flag time constant, specifies how much time F0 will keep the value 2";
  parameter Types.PerUnit Td "Delay flag exponential time constant";

  Modelica.Blocks.Interfaces.BooleanInput u annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput y annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = Ts) annotation(
    Placement(visible = true, transformation(origin = {-10, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch18 annotation(
    Placement(visible = true, transformation(origin = {-44, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {-20, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const7(k = Td) annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInt switch1 annotation(
    Placement(visible = true, transformation(origin = {22, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = 2)  annotation(
    Placement(visible = true, transformation(origin = {-40, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInt switch11 annotation(
    Placement(visible = true, transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.0001, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

  connect(timer.y, less1.u1) annotation(
    Line(points = {{-49, 70}, {-32, 70}}, color = {0, 0, 127}));
  connect(const7.y, switch18.u1) annotation(
    Line(points = {{-78, -50}, {-76, -50}, {-76, -42}, {-56, -42}}, color = {0, 0, 127}));
  connect(fixedDelay.y, switch18.u3) annotation(
    Line(points = {{-21, -80}, {-72, -80}, {-72, -58}, {-56, -58}}, color = {0, 0, 127}));
  connect(u, timer.u) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, 70}, {-72, 70}, {-72, 70}}, color = {255, 0, 255}));
  connect(u, switch18.u2) annotation(
    Line(points = {{-120, 0}, {-70, 0}, {-70, -50}, {-56, -50}}, color = {255, 0, 255}));
  connect(less1.y, switch1.M) annotation(
    Line(points = {{-8, 70}, {0, 70}, {0, 30}, {11, 30}}, color = {255, 0, 255}));
  connect(u, booleanToInteger.u) annotation(
    Line(points = {{-120, 0}, {-54, 0}, {-54, 0}, {-52, 0}}, color = {255, 0, 255}));
  connect(booleanToInteger.y, switch1.u0) annotation(
    Line(points = {{-29, 0}, {-10, 0}, {-10, 36}, {11, 36}}, color = {255, 127, 0}));
  connect(integerConstant.y, switch1.u1) annotation(
    Line(points = {{-28, 36}, {-20, 36}, {-20, 24}, {11, 24}}, color = {255, 127, 0}));
  connect(u, switch11.M) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, 90}, {52, 90}, {52, 0}, {63, 0}}, color = {255, 0, 255}));
  connect(switch11.y, y) annotation(
    Line(points = {{85, 0}, {120, 0}}, color = {255, 127, 0}));
  connect(switch1.y, switch11.u0) annotation(
    Line(points = {{33, 30}, {40, 30}, {40, 6}, {64, 6}}, color = {255, 127, 0}));
  connect(booleanToInteger.y, switch11.u1) annotation(
    Line(points = {{-28, 0}, {40, 0}, {40, -6}, {62, -6}, {62, -6}, {64, -6}}, color = {255, 127, 0}));
  connect(switch18.y, firstOrder.u) annotation(
    Line(points = {{-32, -50}, {-22, -50}}, color = {0, 0, 127}));
  connect(firstOrder.y, fixedDelay.u) annotation(
    Line(points = {{1, -50}, {40, -50}, {40, -80}, {2, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, less1.u2) annotation(
    Line(points = {{2, -50}, {20, -50}, {20, -20}, {-80, -20}, {-80, 56}, {-40, 56}, {-40, 62}, {-32, 62}, {-32, 62}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {6, 25}, extent = {{-52, 59}, {42, -47}}, textString = "Delay"), Text(origin = {-2, -31}, extent = {{-38, 45}, {42, -47}}, textString = "Flag")}, coordinateSystem(initialScale = 0.1)));
end DelayFlag;
