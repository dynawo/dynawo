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

model DroopControl "Droop Control"
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Mp "Active power droop control coefficient";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";

  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid" annotation(
    Placement(visible = true, transformation(origin = {-140, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid" annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "active power reference at the converter's capacitor in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "grid frequency in pu" annotation(
    Placement(visible = true, transformation(origin = {140, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = UdFilter0Pu) "reference voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {68, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "reactive power reference at the converter's capacitor in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = 0) "d-axis virtual impedance output" annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = 0) "q-axis virtual impedance output" annotation(
    Placement(visible = true, transformation(origin = {140, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency" annotation(
    Placement(visible = true, transformation(origin = {160,60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame" annotation(
    Placement(visible = true, transformation(origin = {240, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = UdFilter0Pu) "d-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {194, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterRefPu(start = 0) "q-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {194, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product3 annotation(
    Placement(visible = true, transformation(origin = {-50, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-12, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-12, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {20, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain (k=Mp)annotation(
    Placement(visible = true, transformation(origin = {46, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1/Wf, k=1) annotation(
    Placement(visible = true, transformation(origin = {76, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {122, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {176, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k=SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {208, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 1 / Wf, k=1)  annotation(
    Placement(visible = true, transformation(origin = {20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kff)  annotation(
    Placement(visible = true, transformation(origin = {14, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kff)  annotation(
    Placement(visible = true, transformation(origin = {14, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 1 / Wff, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {44, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 1 / Wff, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {44, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {50, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Mq)  annotation(
    Placement(visible = true, transformation(origin = {78, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {136, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(visible = true, transformation(origin = {168, -22}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {88, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback6 annotation(
    Placement(visible = true, transformation(origin = {116, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback7 annotation(
    Placement(visible = true, transformation(origin = {168, -96}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaSetPu(k = SystemBase.omegaRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {60, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit PRef0Pu "Start value of the active power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.PerUnit QRef0Pu "Start value of the reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu;
  parameter Types.PerUnit IqPcc0Pu;
  parameter Types.PerUnit UdFilter0Pu;
  parameter Types.Angle Theta0;

equation
  connect(product.u1, idPccPu) annotation(
    Line(points = {{-62, 66}, {-81, 66}, {-81, 60}, {-140, 60}}, color = {0, 0, 127}));
  connect(product.u2, udFilterPu) annotation(
    Line(points = {{-62, 54}, {-78, 54}, {-78, 20}, {-100, 20}}, color = {0, 0, 127}));
  connect(product1.u1, uqFilterPu) annotation(
    Line(points = {{-62, 26}, {-76, 26}, {-76, -20}, {-100, -20}}, color = {0, 0, 127}));
  connect(product1.u2, iqPccPu) annotation(
    Line(points = {{-62, 14}, {-74, 14}, {-74, -60}, {-140, -60}}, color = {0, 0, 127}));
  connect(product2.u1, uqFilterPu) annotation(
    Line(points = {{-62, -14}, {-70, -14}, {-70, -20}, {-100, -20}, {-100, -20}}, color = {0, 0, 127}));
  connect(product2.u2, idPccPu) annotation(
    Line(points = {{-62, -26}, {-72, -26}, {-72, 60}, {-140, 60}}, color = {0, 0, 127}));
  connect(product3.u1, iqPccPu) annotation(
    Line(points = {{-62, -54}, {-70, -54}, {-70, -60}, {-140, -60}}, color = {0, 0, 127}));
  connect(product3.u2, udFilterPu) annotation(
    Line(points = {{-62, -66}, {-68, -66}, {-68, 20}, {-100, 20}, {-100, 20}}, color = {0, 0, 127}));
  connect(product2.y, feedback.u1) annotation(
    Line(points = {{-38, -20}, {-22, -20}, {-22, -40}, {-20, -40}}, color = {0, 0, 127}));
  connect(product3.y, feedback.u2) annotation(
    Line(points = {{-38, -60}, {-12, -60}, {-12, -48}, {-12, -48}}, color = {0, 0, 127}));
  connect(product1.y, add.u2) annotation(
    Line(points = {{-38, 20}, {-26, 20}, {-26, 34}, {-24, 34}}, color = {0, 0, 127}));
  connect(product.y, add.u1) annotation(
    Line(points = {{-38, 60}, {-26, 60}, {-26, 46}, {-24, 46}}, color = {0, 0, 127}));
  connect(add.y, feedback1.u2) annotation(
    Line(points = {{0, 40}, {20, 40}, {20, 52}, {20, 52}}, color = {0, 0, 127}));
  connect(feedback1.u1, PRefPu) annotation(
    Line(points = {{12, 60}, {0, 60}, {0, 100}, {-100, 100}, {-100, 100}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{30, 60}, {34, 60}, {34, 60}, {34, 60}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder.u) annotation(
    Line(points = {{58, 60}, {62, 60}, {62, 60}, {64, 60}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u2) annotation(
    Line(points = {{88, 60}, {100, 60}, {100, 54}, {110, 54}, {110, 54}}, color = {0, 0, 127}));
  connect(add1.y, omegaPu) annotation(
    Line(points = {{134, 60}, {140, 60}, {140, 60}, {160, 60}}, color = {0, 0, 127}));
  connect(feedback2.u1, omegaPu) annotation(
    Line(points = {{168, 60}, {158, 60}, {158, 60}, {160, 60}}, color = {0, 0, 127}));
  connect(feedback2.u2, omegaRefPu) annotation(
    Line(points = {{176, 68}, {176, 68}, {176, 100}, {140, 100}, {140, 100}}, color = {0, 0, 127}));
  connect(integrator.u, feedback2.y) annotation(
    Line(points = {{196, 60}, {186, 60}, {186, 60}, {186, 60}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{220, 60}, {230, 60}, {230, 60}, {240, 60}}, color = {0, 0, 127}));
  connect(theta, integrator.y) annotation(
    Line(points = {{240, 60}, {218, 60}, {218, 60}, {220, 60}}, color = {0, 0, 127}));
  connect(feedback.y, firstOrder1.u) annotation(
    Line(points = {{-2, -40}, {6, -40}, {6, -40}, {8, -40}}, color = {0, 0, 127}));
  connect(gain1.u, idPccPu) annotation(
    Line(points = {{2, -80}, {-108, -80}, {-108, 60}, {-140, 60}, {-140, 60}}, color = {0, 0, 127}));
  connect(gain2.u, iqPccPu) annotation(
    Line(points = {{2, -110}, {-100, -110}, {-100, -60}, {-140, -60}, {-140, -60}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder2.u) annotation(
    Line(points = {{26, -80}, {30, -80}, {30, -80}, {32, -80}}, color = {0, 0, 127}));
  connect(gain2.y, firstOrder3.u) annotation(
    Line(points = {{26, -110}, {30, -110}, {30, -110}, {32, -110}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback3.u2) annotation(
    Line(points = {{32, -40}, {50, -40}, {50, -36}, {50, -36}}, color = {0, 0, 127}));
  connect(feedback3.u1, QRefPu) annotation(
    Line(points = {{42, -28}, {34, -28}, {34, 0}, {0, 0}, {0, 0}}, color = {0, 0, 127}));
  connect(feedback3.y, gain3.u) annotation(
    Line(points = {{60, -28}, {64, -28}, {64, -28}, {66, -28}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u2) annotation(
    Line(points = {{90, -28}, {96, -28}, {96, -28}, {98, -28}}, color = {0, 0, 127}));
  connect(UFilterRefPu, add2.u1) annotation(
    Line(points = {{68, 0}, {96, 0}, {96, -16}, {98, -16}}, color = {0, 0, 127}));
  connect(add2.y, feedback4.u1) annotation(
    Line(points = {{122, -22}, {128, -22}, {128, -22}, {128, -22}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback4.u2) annotation(
    Line(points = {{56, -80}, {136, -80}, {136, -30}, {136, -30}}, color = {0, 0, 127}));
  connect(feedback4.y, feedback5.u1) annotation(
    Line(points = {{146, -22}, {160, -22}, {160, -22}, {160, -22}}, color = {0, 0, 127}));
  connect(DeltaVVId, feedback5.u2) annotation(
    Line(points = {{140, 0}, {168, 0}, {168, -14}, {168, -14}}, color = {0, 0, 127}));
  connect(feedback5.y, udFilterRefPu) annotation(
    Line(points = {{178, -22}, {184, -22}, {184, -22}, {194, -22}}, color = {0, 0, 127}));
  connect(const.y, feedback6.u1) annotation(
    Line(points = {{99, -96}, {108, -96}}, color = {0, 0, 127}));
  connect(firstOrder3.y, feedback6.u2) annotation(
    Line(points = {{56, -110}, {116, -110}, {116, -104}}, color = {0, 0, 127}));
  connect(feedback6.y, feedback7.u1) annotation(
    Line(points = {{126, -96}, {158, -96}, {158, -96}, {160, -96}}, color = {0, 0, 127}));
  connect(DeltaVVIq, feedback7.u2) annotation(
    Line(points = {{140, -60}, {168, -60}, {168, -88}, {168, -88}}, color = {0, 0, 127}));
  connect(feedback7.y, uqFilterRefPu) annotation(
    Line(points = {{178, -96}, {184, -96}, {184, -96}, {194, -96}}, color = {0, 0, 127}));
  connect(omegaSetPu.y, add1.u1) annotation(
    Line(points = {{71, 100}, {100, 100}, {100, 66}, {110, 66}, {110, 66}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})));
end DroopControl;
