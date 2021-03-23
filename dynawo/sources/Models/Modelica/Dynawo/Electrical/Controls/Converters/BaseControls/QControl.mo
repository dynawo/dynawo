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

model QControl "Reactive power Control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit QMaxPu "Maximal converter reactive power in pu (base SNom)";
  parameter Types.PerUnit DroopUQ "Proportional gain of the reactive power loop (AC voltage regulation), such that Qsp=Qref+DroopUQ*(UacRef-Uac)";
  parameter Types.Time tauIqRef "Approximation of the response time of the reactive power loop is seconds";
  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis valve current (before filter) in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit QRef0Pu "Start value of the reactive power reference at the converter terminal (filter) in pu (base SNom) (generator convention)";

  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Reactive power reference at the converter terminal (filter) in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-65, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -31}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = UdFilter0Pu) "AC voltage reference at the converter terminal (filter) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-65, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-65, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "d-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-65, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput iqConvRefNLPu(start = IqConv0Pu) "q-axis reference for the valve current before limitation in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {75, 0}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tauIqRef, k = -1, y_start = IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {52, 4.44089e-16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {34, -4.44089e-16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = DroopUQ)  annotation(
    Placement(visible = true, transformation(origin = {4, 40}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {18.5, 37.5}, extent = {{-4.5, -4.5}, {4.5, 4.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-25, -35}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {5, -47}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-42, 9}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-42, 26}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = 1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-10, 48}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-31, 18}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {-22, 18}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = QMaxPu, uMin = -QMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {-25, -10}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

equation
  connect(firstOrder1.y, iqConvRefNLPu) annotation(
    Line(points = {{59, 0}, {75, 0}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{8, 40}, {13, 40}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{10.5, -47}, {10.5, -4}, {27, -4}}, color = {0, 0, 127}));
  connect(udFilterPu, max.u2) annotation(
    Line(points = {{-65, -50}, {-1, -50}}, color = {0, 0, 127}));
  connect(division1.y, firstOrder1.u) annotation(
    Line(points = {{41, 0}, {45, 0}}, color = {0, 0, 127}));
  connect(add1.y, division1.u1) annotation(
    Line(points = {{23, 37.5}, {27, 37.5}, {27, 4}}, color = {0, 0, 127}));
  connect(udFilterPu, product.u1) annotation(
    Line(points = {{-65, -50}, {-50, -50}, {-50, 11}, {-47, 11}}, color = {0, 0, 127}));
  connect(udFilterPu, product.u2) annotation(
    Line(points = {{-65, -50}, {-50, -50}, {-50, 7}, {-47, 7}}, color = {0, 0, 127}));
  connect(add.y, gain.u) annotation(
    Line(points = {{-6, 48}, {-4.5, 48}, {-4.5, 40}, {-1, 40}}, color = {0, 0, 127}));
  connect(UFilterRefPu, add.u1) annotation(
    Line(points = {{-65, 50}, {-15, 50}}, color = {0, 0, 127}));
  connect(product1.y, add2.u1) annotation(
    Line(points = {{-38, 26}, {-35, 26}, {-35, 20}}, color = {0, 0, 127}));
  connect(product.y, add2.u2) annotation(
    Line(points = {{-38, 9}, {-35, 9}, {-35, 16}}, color = {0, 0, 127}));
  connect(add2.y, sqrt1.y) annotation(
    Line(points = {{-28, 18}, {-19, 18}}, color = {0, 0, 127}));
  connect(QRefPu, limiter.u) annotation(
    Line(points = {{-65, -20}, {-43.5, -20}, {-43.5, -10}, {-31, -10}}, color = {0, 0, 127}));
  connect(limiter.y, add1.u2) annotation(
    Line(points = {{-19.5, -10}, {0, -10}, {0, 27}, {13, 27}, {13, 35}}, color = {0, 0, 127}));
  connect(uqFilterPu, product1.u1) annotation(
    Line(points = {{-65, 20}, {-51, 20}, {-51, 28}, {-47, 28}, {-47, 28}}, color = {0, 0, 127}));
  connect(uqFilterPu, product1.u2) annotation(
    Line(points = {{-65, 20}, {-47, 20}, {-47, 24}, {-47, 24}}, color = {0, 0, 127}));
  connect(sqrt1.y, add.u2) annotation(
    Line(points = {{-19, 18}, {-17, 18}, {-17, 46}, {-15, 46}, {-15, 46}}, color = {0, 0, 127}));
  connect(const.y, max.u1) annotation(
    Line(points = {{-19.5, -35}, {-13, -35}, {-13, -44}, {-1, -44}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, 99.5}, {100, -100.5}}), Text(origin = {17.5, -19}, extent = {{-112.5, 96}, {80.5, -59}}, textString = "QControl")}));

end QControl;
