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

  parameter Types.PerUnit PMaxPu "Maximal converter active power in p.u (base SNom)";
  parameter Types.PerUnit DroopFP "Proportional gain of the active power loop (frequency regulation), such that Psp=Pref-DroopFP*(fnom-f)";
  parameter Types.Time tauIdRef "Approximation of the response time of the active power loop is seconds";
  parameter Types.PerUnit RPmaxPu "Maximal primary reserve in p.u (base SNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit PRef0Pu "Start value of the active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)";

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-65, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-65, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-65, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-65, -9.99201e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefNLPu(start = IdConv0Pu) "d-axis reference for the valve current before limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {73, 25}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {110, 49}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idMaxPu(start = PMaxPu/UdFilter0Pu) "d-axis maximal valve current in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {73, -25}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {109.5, -40.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tauIdRef, k = 1, y_start = IdConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {51, 25}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {33, 25}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {25, -25}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 0.01, k = 1, y_start = PMaxPu/UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {45, -25}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-47.5, -15.5}, extent = {{-4.5, -4.5}, {4.5, 4.5}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {-28.5, -26.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = PMaxPu) annotation(
    Placement(visible = true, transformation(origin = {5, -15}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = PMaxPu, uMin = -PMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {12.5, 35.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = 1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-3.5, 35.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -DroopFP)  annotation(
    Placement(visible = true, transformation(origin = {-29, 25}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2 annotation(
    Placement(visible = true, transformation(origin = {-48, 12}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = RPmaxPu, uMin = -RPmaxPu) annotation(
    Placement(visible = true, transformation(origin = {-18, 25}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-42, 25}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
  connect(firstOrder.y, idConvRefNLPu) annotation(
    Line(points = {{56.5, 25}, {73, 25}}, color = {0, 0, 127}));
  connect(firstOrder1.y, idMaxPu) annotation(
    Line(points = {{51, -25}, {73, -25}}, color = {0, 0, 127}));
  connect(division1.y, firstOrder1.u) annotation(
    Line(points = {{30.5, -25}, {39, -25}}, color = {0, 0, 127}));
  connect(division.y, firstOrder.u) annotation(
    Line(points = {{38.5, 25}, {45, 25}}, color = {0, 0, 127}));
  connect(const.y, max.u1) annotation(
    Line(points = {{-43, -15.5}, {-40, -15.5}, {-40, -23}, {-35, -23}}, color = {0, 0, 127}));
  connect(udFilterPu, max.u2) annotation(
    Line(points = {{-65, -30}, {-35, -30}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{-22, -26.5}, {19, -26.5}, {19, -28}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{-22, -26.5}, {-6, -26.5}, {-6, 22}, {27, 22}}, color = {0, 0, 127}));
  connect(constant1.y, division1.u1) annotation(
    Line(points = {{10.5, -15}, {13, -15}, {13, -22}, {19, -22}}, color = {0, 0, 127}));
  connect(limiter.y, division.u1) annotation(
    Line(points = {{19, 35.5}, {19, 28}, {27, 28}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{3, 35.5}, {6, 35.5}}, color = {0, 0, 127}));
  connect(PRefPu, add.u1) annotation(
    Line(points = {{-65, 46}, {-33, 46}, {-33, 39}, {-10, 39}}, color = {0, 0, 127}));
  connect(omegaPu, firstOrder2.u) annotation(
    Line(points = {{-65, 0}, {-55.5, 0}, {-55.5, 12}, {-52, 12}}, color = {0, 0, 127}));
  connect(limiter1.y, add.u2) annotation(
    Line(points = {{-15, 25}, {-12, 25}, {-12, 32}, {-10, 32}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{-25, 25}, {-22, 25}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback.u2) annotation(
    Line(points = {{-45, 12}, {-42, 12}, {-42, 21}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback.u1) annotation(
    Line(points = {{-65, 25}, {-46, 25}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-37, 25}, {-34, 25}, {-34, 25}, {-34, 25}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, 99.5}, {100, -100.5}}), Text(origin = {-32.5, 28}, extent = {{-63.5, 47}, {129.5, -102}}, textString = "PControl")}));

end PControl;
