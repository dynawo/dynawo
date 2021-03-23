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

  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  parameter Types.PerUnit Td "Delay flag time constant, specifies the duration F0 will keep the value 2";
  parameter Types.PerUnit Ts "Integration step";

  Modelica.Blocks.Interfaces.BooleanInput u annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput y annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = Ts) annotation(
    Placement(visible = true, transformation(origin = {-10, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-24, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch18 annotation(
    Placement(visible = true, transformation(origin = {-44, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {16, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const7(k = Td) annotation(
    Placement(visible = true, transformation(origin = {-86, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInt switch1 annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = 2)  annotation(
    Placement(visible = true, transformation(origin = {8, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInt switch11 annotation(
    Placement(visible = true, transformation(origin = {84, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger annotation(
    Placement(visible = true, transformation(origin = {-26, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.0001, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {-64, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(const7.y, switch18.u1) annotation(
    Line(points = {{-75, -42}, {-56, -42}}, color = {0, 0, 127}));
  connect(fixedDelay.y, switch18.u3) annotation(
    Line(points = {{-21, -80}, {-72, -80}, {-72, -58}, {-56, -58}}, color = {0, 0, 127}));
  connect(u, switch18.u2) annotation(
    Line(points = {{-120, 0}, {-70, 0}, {-70, -50}, {-56, -50}}, color = {255, 0, 255}));
  connect(less1.y, switch1.M) annotation(
    Line(points = {{27, 64}, {32, 64}, {32, 40}, {39, 40}}, color = {255, 0, 255}));
  connect(u, booleanToInteger.u) annotation(
    Line(points = {{-120, 0}, {-38, 0}}, color = {255, 0, 255}));
  connect(booleanToInteger.y, switch1.u0) annotation(
    Line(points = {{-15, 0}, {-10, 0}, {-10, 46}, {39, 46}}, color = {255, 127, 0}));
  connect(u, switch11.M) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, 90}, {68, 90}, {68, 6}, {73, 6}}, color = {255, 0, 255}));
  connect(switch11.y, y) annotation(
    Line(points = {{95, 6}, {107.5, 6}, {107.5, 0}, {120, 0}}, color = {255, 127, 0}));
  connect(switch1.y, switch11.u0) annotation(
    Line(points = {{61, 40}, {72, 40}, {72, 12}, {73, 12}}, color = {255, 127, 0}));
  connect(booleanToInteger.y, switch11.u1) annotation(
    Line(points = {{-15, 0}, {73, 0}}, color = {255, 127, 0}));
  connect(switch18.y, firstOrder.u) annotation(
    Line(points = {{-32, -50}, {-22, -50}}, color = {0, 0, 127}));
  connect(firstOrder.y, fixedDelay.u) annotation(
    Line(points = {{1, -50}, {40, -50}, {40, -80}, {2, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, less1.u2) annotation(
    Line(points = {{2, -50}, {20, -50}, {20, -20}, {-58, -20}, {-58, 56}, {4, 56}}, color = {0, 0, 127}));
  connect(integerConstant.y, switch1.u1) annotation(
    Line(points = {{20, 16}, {32, 16}, {32, 34}, {40, 34}, {40, 34}, {40, 34}}, color = {255, 127, 0}));
  connect(u, not1.u) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, 70}, {-76, 70}}, color = {255, 0, 255}));
  connect(not1.y, timer.u) annotation(
    Line(points = {{-53, 70}, {-36, 70}}, color = {255, 0, 255}));
  connect(timer.y, less1.u1) annotation(
    Line(points = {{-12, 70}, {-4, 70}, {-4, 64}, {4, 64}, {4, 64}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {6, 25}, extent = {{-52, 59}, {42, -47}}, textString = "Delay"), Text(origin = {-2, -31}, extent = {{-38, 45}, {42, -47}}, textString = "Flag")}, coordinateSystem(initialScale = 0.1)));
end DelayFlag;
