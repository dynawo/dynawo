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

model VirtualImpedance "Virtual Impedance model for the current limitation"
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.PerUnit Imax;

  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current created by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current created by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput DeltaVVId(start = 0) "d-axis virtual impedance output" annotation(
    Placement(visible = true, transformation(origin = {196, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput DeltaVVIq(start = 0) "q-axis virtual impedance output" annotation(
    Placement(visible = true, transformation(origin = {196, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gainKpVI (k = KpVI) annotation(
      Placement(visible = true, transformation(origin = {56, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainXRratio (k = XRratio) annotation(
      Placement(visible = true, transformation(origin = {86, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant one (k= Imax) annotation(
      Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
      Placement(visible = true, transformation(origin = {-4, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
      Placement(visible = true, transformation(origin = {138, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product3 annotation(
      Placement(visible = true, transformation(origin = {140, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
      Placement(visible = true, transformation(origin = {166, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product4 annotation(
      Placement(visible = true, transformation(origin = {140, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product5 annotation(
      Placement(visible = true, transformation(origin = {140, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
      Placement(visible = true, transformation(origin = {172, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {26, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zerosource(k = 0)  annotation(
    Placement(visible = true, transformation(origin = { -30, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-84, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-84, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-58, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit IdConv0Pu;
  parameter Types.PerUnit IqConv0Pu;
  Types.PerUnit maximum;
equation
  maximum = max.y;
  connect(feedback.u2, one.y) annotation(
    Line(points = {{-4, 22}, {-4, 22}, {-4, 0}, {-18, 0}, {-18, 0}}, color = {0, 0, 127}));
  connect(gainKpVI.y, gainXRratio.u) annotation(
    Line(points = {{68, 24}, {72, 24}, {72, 24}, {74, 24}}, color = {0, 0, 127}));
  connect(product.y, feedback1.u1) annotation(
    Line(points = {{150, 80}, {158, 80}, {158, 80}, {158, 80}}, color = {0, 0, 127}));
  connect(product3.y, feedback1.u2) annotation(
    Line(points = {{152, 18}, {166, 18}, {166, 72}, {166, 72}}, color = {0, 0, 127}));
  connect(DeltaVVId, feedback1.y) annotation(
    Line(points = {{196, 80}, {176, 80}}, color = {0, 0, 127}));
  connect(product4.y, add1.u1) annotation(
    Line(points = {{152, -26}, {158, -26}, {158, -34}, {160, -34}}, color = {0, 0, 127}));
  connect(product5.y, add1.u2) annotation(
    Line(points = {{152, -64}, {158, -64}, {158, -46}, {160, -46}}, color = {0, 0, 127}));
  connect(add1.y, DeltaVVIq) annotation(
    Line(points = {{184, -40}, {186, -40}, {186, -40}, {196, -40}}, color = {0, 0, 127}));
  connect(gainXRratio.y, product3.u1) annotation(
    Line(points = {{98, 24}, {126, 24}, {126, 24}, {128, 24}}, color = {0, 0, 127}));
  connect(product.u2, gainKpVI.y) annotation(
    Line(points = {{126, 74}, {66, 74}, {66, 24}, {68, 24}}, color = {0, 0, 127}));
  connect(product.u1, idConvPu) annotation(
    Line(points = {{126, 86}, {-176, 86}, {-176, 60}, {-190, 60}}, color = {0, 0, 127}));
  connect(product3.u2, iqConvPu) annotation(
    Line(points = {{128, 12}, {100, 12}, {100, -100}, {-174, -100}, {-174, 0}, {-190, 0}}, color = {0, 0, 127}));
  connect(product4.u1, gainKpVI.y) annotation(
    Line(points = {{128, -20}, {66, -20}, {66, 24}, {68, 24}}, color = {0, 0, 127}));
  connect(product4.u2, iqConvPu) annotation(
    Line(points = {{128, -32}, {106, -32}, {106, -108}, {-180, -108}, {-180, 0}, {-190, 0}}, color = {0, 0, 127}));
  connect(product5.u1, gainXRratio.y) annotation(
    Line(points = {{128, -58}, {96, -58}, {96, 24}, {98, 24}}, color = {0, 0, 127}));
  connect(product5.u2, idConvPu) annotation(
    Line(points = {{128, -70}, {-200, -70}, {-200, 40}, {-176, 40}, {-176, 60}, {-190, 60}}, color = {0, 0, 127}));
  connect(max.y, gainKpVI.u) annotation(
    Line(points = {{38, 24}, {44, 24}, {44, 24}, {44, 24}}, color = {0, 0, 127}));
  connect(max.u2, zerosource.y) annotation(
    Line(points = {{14, 18}, {0, 18}, {0, -32}, {-18, -32}, {-18, -32}}, color = {0, 0, 127}));
  connect(product1.u2, idConvPu) annotation(
    Line(points = {{-96, 54}, {-172, 54}, {-172, 60}, {-190, 60}}, color = {0, 0, 127}));
  connect(product1.u1, idConvPu) annotation(
    Line(points = {{-96, 66}, {-172, 66}, {-172, 60}, {-190, 60}}, color = {0, 0, 127}));
  connect(product2.u2, iqConvPu) annotation(
    Line(points = {{-96, -6}, {-172, -6}, {-172, 0}, {-190, 0}}, color = {0, 0, 127}));
  connect(product2.u1, iqConvPu) annotation(
    Line(points = {{-96, 6}, {-172, 6}, {-172, 0}, {-190, 0}}, color = {0, 0, 127}));
  connect(product1.y, add.u1) annotation(
    Line(points = {{-72, 60}, {-70, 60}, {-70, 36}, {-70, 36}}, color = {0, 0, 127}));
  connect(product2.y, add.u2) annotation(
    Line(points = {{-72, 0}, {-70, 0}, {-70, 24}, {-70, 24}}, color = {0, 0, 127}));
  connect(feedback.y, max.u1) annotation(
    Line(points = {{6, 30}, {14, 30}, {14, 30}, {14, 30}}, color = {0, 0, 127}));
  connect(add.y, feedback.u1) annotation(
    Line(points = {{-47, 30}, {-12, 30}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})));
end VirtualImpedance;
