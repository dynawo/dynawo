within Dynawo.Electrical.Controls.Converters.BaseControls;

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
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit KpDc "Proportional gain of the dc voltage control";
  parameter Types.PerUnit IdcSourceRef0Pu;
  parameter Types.PerUnit IdcSource0Pu;
  parameter Types.PerUnit Udc0Pu;

  Modelica.Blocks.Interfaces.RealInput IdcSourceRefPu(start = IdcSourceRef0Pu) "DC current reference in p.u" annotation(
    Placement(visible = true, transformation(origin = {-119, 51}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-119, -49}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc0Pu) "DC voltage reference in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-119, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput IdcSourcePu(start = IdcSource0Pu) "DC current in p.u" annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gaindc(k = KpDc) annotation(
    Placement(visible = true, transformation(origin = {-25, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-69, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {30, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(feedback.u1, UdcRefPu) annotation(
    Line(points = {{-77, 0}, {-119, 0}}, color = {0, 0, 127}));
  connect(feedback.u2, UdcPu) annotation(
    Line(points = {{-69, -8}, {-69, -49}, {-119, -49}}, color = {0, 0, 127}));
  connect(feedback.y, gaindc.u) annotation(
    Line(points = {{-60, 0}, {-37, 0}}, color = {0, 0, 127}));
  connect(add.u2, gaindc.y) annotation(
    Line(points = {{18, 0}, {-14, 0}}, color = {0, 0, 127}));
  connect(add.u1, IdcSourceRefPu) annotation(
    Line(points = {{18, 12}, {18, 51}, {-119, 51}}, color = {0, 0, 127}));
  connect(add.y, IdcSourcePu) annotation(
    Line(points = {{41, 6}, {70.5, 6}, {70.5, 0}, {120, 0}}, color = {0, 0, 127}));

annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})));

end DCVoltageControl;
