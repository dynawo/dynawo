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

model PControl "Active power control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit PmaxPu      "Maximal converter active power in p.u (base SNom)";
  parameter Types.PerUnit DroopFP     "Proportional gain of the active power loop (frequency regulation), such that Psp=Pref-DroopFP*(fnom-f)";
  parameter Types.Time tauIdRef       "Approximation of the response time of the active power loop is seconds";
  parameter Types.PerUnit RPmaxPu     "Maximal primary reserve in p.u (base SNom)";

  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu   "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit PRef0Pu     "Start value of the active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)";

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, 39}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-106, -26}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -84}, extent = {{5, -5}, {-5, 5}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-58, 25}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 81}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-58, 12}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-106, 27}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefNLPu(start = IdConv0Pu) "d-axis reference for the valve current before limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, 24}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 52}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idMaxPu(start = PmaxPu/UdFilter0Pu) "d-axis maximal valve current in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, -24}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tauIdRef, k = 1, y_start = IdConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {50, 24}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {33, 24}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {23, -24}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 0.01, k = 1, y_start = PmaxPu/UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {41, -24}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-47.5, -15.5}, extent = {{-4.5, -4.5}, {4.5, 4.5}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {-28.5, -26.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = PmaxPu) annotation(
    Placement(visible = true, transformation(origin = {2.5, -15.5}, extent = {{-4.5, -4.5}, {4.5, 4.5}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = PmaxPu, uMin = -PmaxPu)  annotation(
    Placement(visible = true, transformation(origin = {12, 36}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = 1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-2.5, 36.5}, extent = {{-4.5, -4.5}, {4.5, 4.5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-37, 23}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -DroopFP)  annotation(
    Placement(visible = true, transformation(origin = {-27.5, 23.5}, extent = {{-3.5, -3.5}, {3.5, 3.5}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2 annotation(
    Placement(visible = true, transformation(origin = {-49, 12}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = RPmaxPu, uMin = -RPmaxPu) annotation(
    Placement(visible = true, transformation(origin = {-17, 24}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
equation
  connect(firstOrder.y, idConvRefNLPu) annotation(
    Line(points = {{55.5, 24}, {67, 24}}, color = {0, 0, 127}));
  connect(firstOrder1.y, idMaxPu) annotation(
    Line(points = {{46.5, -24}, {67, -24}}, color = {0, 0, 127}));
  connect(division1.y, firstOrder1.u) annotation(
    Line(points = {{28.5, -24}, {35, -24}}, color = {0, 0, 127}));
  connect(division.y, firstOrder.u) annotation(
    Line(points = {{38.5, 24}, {44, 24}}, color = {0, 0, 127}));
  connect(const.y, max.u1) annotation(
    Line(points = {{-43, -15.5}, {-40, -15.5}, {-40, -23}, {-35, -23}}, color = {0, 0, 127}));
  connect(udFilterPu, max.u2) annotation(
    Line(points = {{-58, -30}, {-35, -30}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{-22, -26.5}, {17, -26.5}, {17, -27}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{-22, -26.5}, {-4, -26.5}, {-4, 21}, {27, 21}}, color = {0, 0, 127}));
  connect(constant1.y, division1.u1) annotation(
    Line(points = {{7, -15}, {13, -15}, {13, -21}, {17, -21}, {17, -21}}, color = {0, 0, 127}));
  connect(limiter.y, division.u1) annotation(
    Line(points = {{17.5, 36}, {18, 36}, {18, 27}, {27, 27}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{2, 36.5}, {6, 36.5}, {6, 36}}, color = {0, 0, 127}));
  connect(PRefPu, add.u1) annotation(
    Line(points = {{-58, 39}, {-8, 39}}, color = {0, 0, 127}));
  connect(add1.y, gain.u) annotation(
    Line(points = {{-34, 23}, {-29.5, 23}, {-29.5, 23.5}, {-32, 23.5}}, color = {0, 0, 127}));
  connect(omegaRefPu, add1.u1) annotation(
    Line(points = {{-58, 25}, {-41, 25}}, color = {0, 0, 127}));
  connect(firstOrder2.y, add1.u2) annotation(
    Line(points = {{-46, 12}, {-41, 12}, {-41, 21}}, color = {0, 0, 127}));
  connect(omegaPu, firstOrder2.u) annotation(
    Line(points = {{-58, 12}, {-53, 12}}, color = {0, 0, 127}));
  connect(limiter1.y, add.u2) annotation(
    Line(points = {{-14, 24}, {-12, 24}, {-12, 33}, {-8, 33}, {-8, 34}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{-24, 24}, {-21, 24}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, 99.5}, {100, -100.5}}), Text(origin = {-0.5, -1}, extent = {{-63.5, 47}, {63.5, -47}}, textString = "PControl")}));

end PControl;
