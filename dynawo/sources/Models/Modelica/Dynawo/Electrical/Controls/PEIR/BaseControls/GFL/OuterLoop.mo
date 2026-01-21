within Dynawo.Electrical.Controls.PEIR.BaseControls.GFL;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model OuterLoop "Average outer loop for GFL converters"

  parameter Types.PerUnit Kpd "Active power PI controller proportional gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kid "Active power PI controller integral gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu/s (base UNom, SNom)";
  parameter Types.PerUnit Kiq "Reactive power PI controller integral gain in pu/s (base UNom, SNom)";
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s";
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s";

  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -52}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilter0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis current reference at the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis current reference at the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tQFilt, y_start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {82, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Kiq, outMax = 1000, outMin = -1000, y_start = -IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {34, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpq) annotation(
    Placement(visible = true, transformation(origin = {34, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tPFilt, y_start = PFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-76, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(k = Kid, outMax = 1000, outMin = -1000, y_start = IdConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {34, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {84, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpd) annotation(
    Placement(visible = true, transformation(origin = {34, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-42, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-46, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit PFilter0Pu "Start value of active power at the converter's capacitor in pu (base SNom)";
  parameter Types.PerUnit QFilter0Pu "Start value of reactive power at the converter's capacitor in pu (base SNom)";

equation
  connect(QFilterPu, firstOrder1.u) annotation(
    Line(points = {{-110, -70}, {-92, -70}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add1.u2) annotation(
    Line(points = {{45, -68}, {54, -68}, {54, -54}, {70, -54}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{45, -28}, {54, -28}, {54, -42}, {70, -42}}, color = {0, 0, 127}));
  connect(limIntegrator1.y, add.u2) annotation(
    Line(points = {{45, 32}, {54, 32}, {54, 46}, {72, 46}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{45, 74}, {54, 74}, {54, 58}, {72, 58}}, color = {0, 0, 127}));
  connect(add.y, idConvRefPu) annotation(
    Line(points = {{95, 52}, {109, 52}}, color = {0, 0, 127}));
  connect(PFilterRefPu, feedback1.u1) annotation(
    Line(points = {{-110, 54}, {-50, 54}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback1.u2) annotation(
    Line(points = {{-65, 28}, {-42, 28}, {-42, 46}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{-33, 54}, {0, 54}, {0, 74}, {22, 74}}, color = {0, 0, 127}));
  connect(feedback1.y, limIntegrator1.u) annotation(
    Line(points = {{-33, 54}, {0, 54}, {0, 32}, {22, 32}}, color = {0, 0, 127}));
  connect(PFilterPu, firstOrder2.u) annotation(
    Line(points = {{-110, 28}, {-88, 28}}, color = {0, 0, 127}));
  connect(add1.y, iqConvRefPu) annotation(
    Line(points = {{93, -48}, {110, -48}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u2) annotation(
    Line(points = {{-68, -70}, {-46, -70}, {-46, -48}}, color = {0, 0, 127}));
  connect(QFilterRefPu, feedback.u1) annotation(
    Line(points = {{-110, -40}, {-54, -40}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-36, -40}, {0, -40}, {0, -28}, {22, -28}}, color = {0, 0, 127}));
  connect(feedback.y, limIntegrator.u) annotation(
    Line(points = {{-36, -40}, {0, -40}, {0, -68}, {22, -68}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "Outer Loop")}));
end OuterLoop;
