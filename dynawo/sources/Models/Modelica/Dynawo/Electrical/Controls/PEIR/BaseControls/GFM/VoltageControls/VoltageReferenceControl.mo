within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls;

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

model VoltageReferenceControl "Voltage reference control block"

  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";

  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = DeltaVVId0) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = DeltaVVIq0) "q-axis virtual impedance output in pu (base UNom) "annotation(
    Placement(visible = true, transformation(origin = {-110, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput udRefPu(start = UdRef0Pu) "d-axis voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqRefPu(start = UqRef0Pu) "q-axis voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 1 / Wff, y_start = -Kff * IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-18, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(visible = true, transformation(origin = {82, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {22, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = -Kff) annotation(
    Placement(visible = true, transformation(origin = {-48, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 1 / Wf, y_start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-76, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Mq) annotation(
    Placement(visible = true, transformation(origin = {-26, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 1 / Wff, y_start = Kff * IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-18, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-58, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kff) annotation(
    Placement(visible = true, transformation(origin = {-48, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {52, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback7 annotation(
    Placement(visible = true, transformation(origin = {82, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdRef0Pu "Start value of d-axis voltage reference in pu (base UNom)";
  parameter Types.PerUnit UqRef0Pu "Start value of q-axis voltage reference in pu (base UNom)";
  parameter Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  parameter Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu URef0Pu "Start value of voltage module reference in pu (base UNom)";

  final parameter Types.ReactivePowerPu QFilterRef0Pu = QFilter0Pu + (Kff * IdPcc0Pu + DeltaVVId0) / Mq "Start value of reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";

equation
  connect(feedback5.y, udRefPu) annotation(
    Line(points = {{91, 78}, {110, 78}}, color = {0, 0, 127}));
  connect(gain1.u, idPccPu) annotation(
    Line(points = {{-60, 4}, {-110, 4}}, color = {0, 0, 127}));
  connect(QPu, firstOrder1.u) annotation(
    Line(points = {{-110, 54}, {-88, 54}}, color = {0, 0, 127}));
  connect(feedback3.y, gain3.u) annotation(
    Line(points = {{-49, 84}, {-38, 84}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder2.u) annotation(
    Line(points = {{-37, 4}, {-30, 4}}, color = {0, 0, 127}));
  connect(gain2.u, iqPccPu) annotation(
    Line(points = {{-60, -36}, {-110, -36}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback3.u2) annotation(
    Line(points = {{-65, 54}, {-58, 54}, {-58, 76}}, color = {0, 0, 127}));
  connect(DeltaVVId, feedback5.u2) annotation(
    Line(points = {{-110, -16}, {82, -16}, {82, 70}}, color = {0, 0, 127}));
  connect(gain2.y, firstOrder3.u) annotation(
    Line(points = {{-37, -36}, {-30, -36}}, color = {0, 0, 127}));
  connect(URefPu, add2.u2) annotation(
    Line(points = {{-110, 24}, {2, 24}, {2, 72}, {10, 72}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u1) annotation(
    Line(points = {{-15, 84}, {10, 84}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback4.u2) annotation(
    Line(points = {{-7, 4}, {52, 4}, {52, 70}}, color = {0, 0, 127}));
  connect(feedback4.y, feedback5.u1) annotation(
    Line(points = {{61, 78}, {74, 78}}, color = {0, 0, 127}));
  connect(add2.y, feedback4.u1) annotation(
    Line(points = {{33, 78}, {44, 78}}, color = {0, 0, 127}));
  connect(firstOrder3.y, feedback7.u1) annotation(
    Line(points = {{-7, -36}, {74, -36}}, color = {0, 0, 127}));
  connect(feedback7.y, uqRefPu) annotation(
    Line(points = {{91, -36}, {110, -36}}, color = {0, 0, 127}));
  connect(DeltaVVIq, feedback7.u2) annotation(
    Line(points = {{-110, -56}, {82, -56}, {82, -44}}, color = {0, 0, 127}));
  connect(QFilterRefPu, feedback3.u1) annotation(
    Line(points = {{-110, 84}, {-66, 84}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(initialScale = 0.2)),
    Icon(coordinateSystem(initialScale = 0.2)));
end VoltageReferenceControl;
