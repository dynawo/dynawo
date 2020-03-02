within Dynawo.Electrical.Controls.Converters.BasicBlocks;

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

model DCVoltageControl "DC Voltage control"

  import Modelica;

  import Dynawo.Types;
  import Dynawo.Connectors;

  parameter Types.PerUnit Kpdc "Proportional gain of the dc voltage control";

  parameter Types.PerUnit idcref0;
  parameter Types.PerUnit idc0;
  parameter Types.PerUnit vdc0;
  parameter Types.PerUnit vdcref0;

  Modelica.Blocks.Math.Gain gaindc (k = Kpdc) annotation(
    Placement(visible = true, transformation(origin = {-46, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idcref(start = idcref0) "DC current reference in p.u" annotation(
    Placement(visible = true, transformation(origin = {-140, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idc(start = idc0) "DC current in p.u" annotation(
    Placement(visible = true, transformation(origin = {40, 46}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdc (start = vdc0) "DC voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdcref (start = vdcref0) "DC voltage reference in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-6, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  connect(feedback.u1, vdcref) annotation(
    Line(points = {{-98, 40}, {-120, 40}, {-120, 40}, {-140, 40}}, color = {0, 0, 127}));
  connect(feedback.u2, vdc) annotation(
    Line(points = {{-90, 32}, {-90, 32}, {-90, 0}, {-140, 0}, {-140, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gaindc.u) annotation(
    Line(points = {{-80, 40}, {-60, 40}, {-60, 40}, {-58, 40}}, color = {0, 0, 127}));
  connect(add.u2, gaindc.y) annotation(
    Line(points = {{-18, 40}, {-36, 40}, {-36, 40}, {-34, 40}}, color = {0, 0, 127}));
  connect(add.u1, idcref) annotation(
    Line(points = {{-18, 52}, {-20, 52}, {-20, 80}, {-140, 80}, {-140, 80}}, color = {0, 0, 127}));
  connect(add.y, idc) annotation(
    Line(points = {{6, 46}, {20, 46}, {20, 46}, {40, 46}}, color = {0, 0, 127}));

annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})));

end DCVoltageControl;
