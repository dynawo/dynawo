within Dynawo.NonElectrical.Blocks.Continuous;

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

block IncreaseDetection "Output y is true, if the input u has risen to a higher value since the previous sample"
  import Modelica;
  import Dynawo.Types;

  extends Modelica.Blocks.Icons.Block;

  parameter Types.Time tS "Integration time step in s";

  Modelica.Blocks.Interfaces.RealInput u(start = U0) "Input signal connector" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput y(start = false) "Output boolean detection connector" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = tS)  annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit U0 "Initial input signal value";

equation
  connect(u, greater.u1) annotation(
    Line(points = {{-120, 0}, {-10, 0}}, color = {0, 0, 127}));
  connect(u, fixedDelay.u) annotation(
    Line(points = {{-120, 0}, {-80, 0}, {-80, -40}, {-62, -40}}, color = {0, 0, 127}));
  connect(fixedDelay.y, greater.u2) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -8}, {-10, -8}}, color = {0, 0, 127}));
  connect(greater.y, y) annotation(
    Line(points = {{14, 0}, {110, 0}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Line(points = {{80, 80}, {0, 80}, {0, -80}, {-80, -80}}), Polygon(lineColor = {32, 74, 135}, fillColor = {52, 101, 164}, fillPattern = FillPattern.Solid, points = {{0, 10}, {10, -10}, {-10, -10}, {0, 10}})}));
end IncreaseDetection;
