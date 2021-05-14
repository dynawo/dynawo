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

  parameter Types.PerUnit QmaxPu      "Maximal converter reactive power in p.u (base SNom)";
  parameter Types.PerUnit DroopUQ     "Proportional gain of the reactive power loop (AC voltage regulation), such that Qsp=Qref+DroopUQ*(UacRef-Uac)";
  parameter Types.Time tauIqRef       "Approximation of the response time of the reactive power loop is seconds";

  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit IqConv0Pu   "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit QRef0Pu     "Start value of the reactive power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit URef0Pu     "Start value of the AC voltage reference at the converter terminal (filter) in p.u (base UNom)";


  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Reactive power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, 10}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -24}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = URef0Pu) "AC voltage reference at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 39}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -92}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -19}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 94}, extent = {{5, -5}, {-5, 5}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 30}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput iqConvRefNLPu(start = IqConv0Pu) "q-axis reference for the valve current before limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, -2}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -2}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tauIqRef, k = -1, y_start = IqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {51, -2}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {34.5, -2.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = DroopUQ)  annotation(
    Placement(visible = true, transformation(origin = {3, 34}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {18.5, 12.5}, extent = {{-4.5, -4.5}, {4.5, 4.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-14.5, -2.5}, extent = {{-4.5, -4.5}, {4.5, 4.5}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {1.5, -6.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-43, 20}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-42, 30}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = 1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-11, 34}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = 1, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {-33, 25}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {-24, 25}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = QmaxPu, uMin = -QmaxPu)  annotation(
    Placement(visible = true, transformation(origin = {-31, 10}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

equation
  connect(firstOrder1.y, iqConvRefNLPu) annotation(
    Line(points = {{56.5, -2}, {67, -2}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{7, 34}, {8.75, 34}, {8.75, 15}, {13, 15}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{8, -6.5}, {8, -6}, {28, -6}}, color = {0, 0, 127}));
  connect(udFilterPu, max.u2) annotation(
    Line(points = {{-58, -19}, {-40, -19}, {-40, -10}, {-5, -10}}, color = {0, 0, 127}));
  connect(const.y, max.u1) annotation(
    Line(points = {{-10, -2.5}, {-10, -3}, {-5, -3}}, color = {0, 0, 127}));
  connect(division1.y, firstOrder1.u) annotation(
    Line(points = {{41, -2}, {45, -2}}, color = {0, 0, 127}));
  connect(add1.y, division1.u1) annotation(
    Line(points = {{23, 13}, {25, 13}, {25, 1}, {28, 1}, {28, 1}}, color = {0, 0, 127}));
  connect(uqFilterPu, product1.u1) annotation(
    Line(points = {{-58, 30}, {-46, 30}, {-46, 32}}, color = {0, 0, 127}));
  connect(uqFilterPu, product1.u2) annotation(
    Line(points = {{-58, 30}, {-51, 30}, {-51, 28}, {-46, 28}}, color = {0, 0, 127}));
  connect(udFilterPu, product.u1) annotation(
    Line(points = {{-58, -19}, {-50, -19}, {-50, 22}, {-47, 22}}, color = {0, 0, 127}));
  connect(udFilterPu, product.u2) annotation(
    Line(points = {{-58, -19}, {-50, -19}, {-50, 18}, {-47, 18}}, color = {0, 0, 127}));
  connect(add.y, gain.u) annotation(
    Line(points = {{-7, 34}, {-2, 34}}, color = {0, 0, 127}));
  connect(UFilterRefPu, add.u1) annotation(
    Line(points = {{-58, 39}, {-38.5, 39}, {-38.5, 36}, {-16, 36}}, color = {0, 0, 127}));
  connect(product1.y, add2.u1) annotation(
    Line(points = {{-39, 30}, {-37, 30}, {-37, 27}}, color = {0, 0, 127}));
  connect(product.y, add2.u2) annotation(
    Line(points = {{-40, 20}, {-37, 20}, {-37, 23}}, color = {0, 0, 127}));
  connect(add2.y, sqrt1.y) annotation(
    Line(points = {{-30, 25}, {-21, 25}, {-21, 25}, {-21, 25}}, color = {0, 0, 127}));
  connect(sqrt1.y, add.u2) annotation(
    Line(points = {{-21, 25}, {-19, 25}, {-19, 32}, {-16, 32}, {-16, 32}}, color = {0, 0, 127}));
  connect(QRefPu, limiter.u) annotation(
    Line(points = {{-58, 10}, {-37, 10}}, color = {0, 0, 127}));
  connect(limiter.y, add1.u2) annotation(
    Line(points = {{-25, 10}, {13, 10}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, 99.5}, {100, -100.5}}), Text(origin = {-0.5, -1}, extent = {{-63.5, 47}, {63.5, -47}}, textString = "QControl")}));

end QControl;
