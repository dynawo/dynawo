within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2015-2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block VoltageDiffNormalizer "Block to normalize a difference between voltage measure and target level"

  import Modelica;
  import Dynawo;
  import Modelica.Blocks.Interfaces;
  import Modelica.Blocks.Icons.Block;
  import Modelica.Constants;
  import Dynawo.Types;

  extends Block;

  parameter Types.PerUnit gain;
  parameter Types.PerUnit Utarget;

  Interfaces.RealInput u "Input signal connector" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Output signal connector" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.Constant const(k = Utarget)  annotation(
    Placement(visible = true, transformation(origin = {-56, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = gain)  annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(u, add.u2) annotation(
    Line(points = {{-120, 0}, {-70, 0}, {-70, -6}, {-22, -6}}, color = {0, 0, 127}));
  connect(const.y, add.u1) annotation(
    Line(points = {{-44, 70}, {-22, 70}, {-22, 6}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{1, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(gain1.y, y) annotation(
    Line(points = {{65, 0}, {110, 0}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
  Diagram(coordinateSystem(initialScale = 0.1)),
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-2, 2}, extent = {{-64, 38}, {64, -38}}, textString = "Voltage Normalizer")}));

end VoltageDiffNormalizer;
