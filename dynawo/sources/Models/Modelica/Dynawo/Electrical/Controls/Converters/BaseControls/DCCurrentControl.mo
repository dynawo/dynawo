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

model DCCurrentControl "DC current source control"

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Kpdc          "Proportional gain of the dc voltage control";
  parameter Types.PerUnit IdcSource0Pu  "Start value of the DC source current in p.u (base UNom, SNom)";
  parameter Types.PerUnit UdcSource0Pu  "Start value of the DC bus voltage in p.u (base UNom)";

  Modelica.Blocks.Interfaces.RealInput IdcSourceRefPu(start = IdcSource0Pu) "DC source reference current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-119, 53}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -83}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = UdcSource0Pu) "DC bus voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-119, -27}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = UdcSource0Pu) "DC bus reference voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-119, 13}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput IdcSourcePu(start = IdcSource0Pu) "DC current source in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {120, 19}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gaindc (k = Kpdc) annotation(
    Placement(visible = true, transformation(origin = {-25, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-69, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {15, 19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(feedback.u1, UdcRefPu) annotation(
    Line(points = {{-77, 13}, {-119, 13}}, color = {0, 0, 127}));
  connect(feedback.u2, UdcPu) annotation(
    Line(points = {{-69, 5}, {-69, -27}, {-119, -27}}, color = {0, 0, 127}));
  connect(feedback.y, gaindc.u) annotation(
    Line(points = {{-60, 13}, {-37, 13}}, color = {0, 0, 127}));
  connect(add.u2, gaindc.y) annotation(
    Line(points = {{3, 13}, {-14, 13}}, color = {0, 0, 127}));
  connect(add.u1, IdcSourceRefPu) annotation(
    Line(points = {{3, 25}, {3, 53}, {-119, 53}}, color = {0, 0, 127}));
  connect(add.y, IdcSourcePu) annotation(
    Line(points = {{26, 19}, {120, 19}}, color = {0, 0, 127}));

annotation(
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {-0.5, 3.5}, extent = {{-99.5, 97.5}, {100.5, -102.5}}), Text(origin = {-74, 98}, extent = {{-4, 11}, {161, -163}}, textString = "DC Current"), Text(origin = {-150, 130}, extent = {{92, -111}, {216, -183}}, textString = "Control")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})));

end DCCurrentControl;
