within Dynawo.Electrical.Controls.PEIR.BaseControls;

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

model DCVoltageControl "DC voltage control for grid forming and grid following converters"

  parameter Types.PerUnit Kpdc "Proportional gain of the dc voltage control";

  Modelica.Blocks.Interfaces.RealInput IdcSourceRefPu(start = IdcSourceRef0Pu) "DC current reference in pu (base UdcNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourcePu(start = UdcSource0Pu) "DC voltage in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-69, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -99}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourceRefPu(start = UdcSourceRef0Pu) "DC voltage reference in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-69, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput IdcSourcePu(start = IdcSource0Pu) "DC current in pu (base UdcNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gaindc(k = Kpdc) annotation(
    Placement(visible = true, transformation(origin = {-10, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit UdcSourceRef0Pu "Start value of DC voltage reference in pu (base UdcNom)";
  parameter Types.PerUnit UdcSource0Pu "Start value of DC voltage in pu (base UdcNom)";
  parameter Types.PerUnit IdcSourceRef0Pu "Start value of DC current reference in pu (base UdcNom, SNom)";
  parameter Types.PerUnit IdcSource0Pu "Start value of DC current in pu (base UdcNom, SNom)";

equation
  connect(feedback.u1, UdcSourceRefPu) annotation(
    Line(points = {{-48, -6}, {-69, -6}}, color = {0, 0, 127}));
  connect(feedback.y, gaindc.u) annotation(
    Line(points = {{-31, -6}, {-22, -6}}, color = {0, 0, 127}));
  connect(add.u2, gaindc.y) annotation(
    Line(points = {{18, -6}, {1, -6}}, color = {0, 0, 127}));
  connect(add.y, IdcSourcePu) annotation(
    Line(points = {{41, 0}, {70, 0}}, color = {0, 0, 127}));
  connect(UdcSourcePu, feedback.u2) annotation(
    Line(points = {{-69, -30}, {-40, -30}, {-40, -14}}, color = {0, 0, 127}));
  connect(IdcSourceRefPu, add.u1) annotation(
    Line(points = {{-70, 20}, {10, 20}, {10, 6}, {18, 6}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -40}, {60, 40}})));
end DCVoltageControl;
