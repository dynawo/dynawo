within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block PotentialCircuit "Computes the absolute value of a generator field voltage"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit Ki "Gain coefficient applied to Real part of complex stator current";
  parameter Types.PerUnit Kp "Gain coefficient";
  parameter Types.Angle Theta "Phase angle in rad";
  parameter Types.PerUnit X "Reactance associated with potential source";

  constant Types.ComplexPerUnit j = Complex(0,1) "Unitary imaginary constant";

  Modelica.ComplexBlocks.Interfaces.ComplexInput uT "Complex bus voltage" annotation(
    Placement(visible = true, transformation(extent = {{-140, 20}, {-100, 60}}, rotation = 0), iconTransformation(extent = {{-140, 20}, {-100, 60}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iT "Complex stator current" annotation(
    Placement(visible = true, transformation(extent = {{-140, -60}, {-100, -20}}, rotation = 0), iconTransformation(extent = {{-140, -60}, {-100, -20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput vE "Output voltage" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Types.ComplexPerUnit v1 "First intermediate voltage";
  Types.ComplexPerUnit v2 "Second intermediate voltage";

equation
  v1 = uT * Complex(Kp * cos(Theta), Kp * sin(Theta));
  v2 = iT * Complex(Ki + X * Kp * cos(Theta), X * Kp * sin(Theta));
  vE = Modelica.ComplexMath.'abs'(v1 + j * v2);

  annotation(preferredView = "text",
    Icon(graphics = {Text(origin = {10, -58}, lineColor = {0, 0, 127}, extent = {{20, 80}, {100, 40}}, textString = "vE"), Polygon(lineColor = {0, 128, 255}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, points = {{40, 0}, {20, 20}, {20, 10}, {-10, 10}, {-10, -10}, {20, -10}, {20, -20}, {40, 0}}), Text(origin = {0, 38},lineColor = {85, 170, 255}, extent = {{-100, 60}, {-20, -60}}, textString = "uT"), Text(origin = {0, -42}, lineColor = {85, 170, 255}, extent = {{-100, 60}, {-20, -60}}, textString = "iT")}));
end PotentialCircuit;
