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

block WeightedDifference "Block which calculates the weighted difference between an input variable and a reference parameter"
  import Modelica;
  import Modelica.Blocks.Interfaces;
  import Modelica.Blocks.Icons.Block;

  extends Block;

  parameter Real Weight "Multiplicative weight for the associated entry";
  parameter Real Target "Reference (target) parameter";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation (Placement(
        visible = true, transformation(extent = {{-140, -60}, {-100, -20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Interfaces.RealOutput y "Output signal connector" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Sources.Constant const(k = Target)  annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Weight)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(add.y, gain1.u) annotation(
    Line(points = {{11, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(gain1.y, y) annotation(
    Line(points = {{61, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(const.y, add.u1) annotation(
    Line(points = {{-98, 40}, {-40, 40}, {-40, 6}, {-12, 6}}, color = {0, 0, 127}));
  connect(u, add.u2) annotation(
    Line(points = {{-120, -40}, {-40, -40}, {-40, -6}, {-12, -6}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
  Diagram(coordinateSystem(initialScale = 0.1)),
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-2, 2}, extent = {{-64, 38}, {64, -38}}, textString = "Weighted Difference")}));
end WeightedDifference;
