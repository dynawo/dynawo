within Dynawo.Examples.DynaFlow.IEEE14.Grid.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model NetworkComponentsExtVar "Network base for IEEE 14-bus system benchmark with 14 buses, 17 lines and 3 transformers. In this model, components used are defined in IEEE14.Components"
  import Modelica;
  import Dynawo;

  // Base Calculation
  final parameter Modelica.SIunits.Impedance ZBASE1 = 69 ^ 2 / Electrical.SystemBase.SnRef;
  final parameter Modelica.SIunits.Impedance ZBASE2 = 13.8 ^ 2 / Electrical.SystemBase.SnRef;

  // Buses
  Dynawo.Electrical.Buses.Bus Bus1(terminal.V.re(start = 1)) annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus2 annotation(
    Placement(visible = true, transformation(origin = {-78, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus3 annotation(
    Placement(visible = true, transformation(origin = {112, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus4 annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus5 annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus6 annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus7 annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus8 annotation(
    Placement(visible = true, transformation(origin = {132, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus9 annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus10 annotation(
    Placement(visible = true, transformation(origin = {24, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus11 annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus12 annotation(
    Placement(visible = true, transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus13 annotation(
    Placement(visible = true, transformation(origin = {-30, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Bus14 annotation(
    Placement(visible = true, transformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Lines
  Components.LineExtVar LineB10B11(BPu = 0, GPu = 0, RPu = 0.156256 / ZBASE2, XPu = 0.365778 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {14, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB12B13(BPu = 0, GPu = 0, RPu = 0.42072 / ZBASE2, XPu = 0.380651 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-90, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB13B14(BPu = 0, GPu = 0, RPu = 0.325519 / ZBASE2, XPu = 0.662769 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {4, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB1B2(BPu = 5.54505E-4 * ZBASE1, GPu = 0, RPu = 0.922682 / ZBASE1, XPu = 2.81708 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {-104, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB1B5(BPu = 5.167E-4 * ZBASE1, GPu = 0, RPu = 2.57237 / ZBASE1, XPu = 10.6189 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB2B3(BPu = 4.599875E-4 * ZBASE1, GPu = 0, RPu = 2.23719 / ZBASE1, XPu = 9.42535 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB2B4(BPu = 3.57068E-4 * ZBASE1, GPu = 0, RPu = 2.76662 / ZBASE1, XPu = 8.3946 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB2B5(BPu = 3.63369E-4 * ZBASE1, GPu = 0, RPu = 2.71139 / ZBASE1, XPu = 8.27843 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {-58, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB3B4(BPu = 1.344255E-4 * ZBASE1, GPu = 0, RPu = 3.19035 / ZBASE1, XPu = 8.14274 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {102, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB4B5(BPu = 0, GPu = 0, RPu = 0.635593 / ZBASE1, XPu = 2.00486 / ZBASE1) annotation(
    Placement(visible = true, transformation(origin = {12, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB6B11(BPu = 0, GPu = 0, RPu = 0.18088 / ZBASE2, XPu = 0.378785 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB6B12(BPu = 0, GPu = 0, RPu = 0.23407 / ZBASE2, XPu = 0.487165 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB6B13(BPu = 0, GPu = 0, RPu = 0.125976 / ZBASE2, XPu = 0.248086 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {-64, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB7B8(BPu = 0, GPu = 0, RPu = 0, XPu = 0.33546 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {122, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB7B9(BPu = 0, GPu = 0, RPu = 0, XPu = 0.209503 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB9B10(BPu = 0, GPu = 0, RPu = 0.060579 / ZBASE2, XPu = 0.160922 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.LineExtVar LineB9B14(BPu = 0, GPu = 0, RPu = 0.242068 / ZBASE2, XPu = 0.514912 / ZBASE2) annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Transformers
  Components.TransformerFixedRatioExtVar Tfo1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.47994804 / ZBASE2, rTfoPu = 1.0729614) annotation(
    Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.TransformerFixedRatioExtVar Tfo2(BPu = 0, GPu = 0, RPu = 0, XPu = 1.0591881 / ZBASE2, rTfoPu = 1.0319917) annotation(
    Placement(visible = true, transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.TransformerFixedRatioExtVar Tfo3(BPu = 0, GPu = 0, RPu = 0, XPu = 0.39824802 / ZBASE2, rTfoPu = 1.0224948) annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  // Network Connections
  connect(LineB1B5.terminal1, Bus1.terminal) annotation(
    Line(points = {{-80, -60}, {-96, -60}, {-96, -40}, {-120, -40}}, color = {0, 0, 255}));
  connect(LineB1B5.terminal2, Bus5.terminal) annotation(
    Line(points = {{-60, -60}, {-30, -60}}, color = {0, 0, 255}));
  connect(LineB1B2.terminal1, Bus1.terminal) annotation(
    Line(points = {{-114, -100}, {-114, -101}, {-120, -101}, {-120, -40}}, color = {0, 0, 255}));
  connect(LineB1B2.terminal2, Bus2.terminal) annotation(
    Line(points = {{-94, -100}, {-78, -100}}, color = {0, 0, 255}));
  connect(LineB12B13.terminal1, Bus12.terminal) annotation(
    Line(points = {{-100, 100}, {-100, 50}}, color = {0, 0, 255}));
  connect(LineB12B13.terminal2, Bus13.terminal) annotation(
    Line(points = {{-80, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(LineB13B14.terminal1, Bus13.terminal) annotation(
    Line(points = {{-6, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(LineB13B14.terminal2, Bus14.terminal) annotation(
    Line(points = {{14, 100}, {30, 100}, {30, 80}}, color = {0, 0, 255}));
  connect(LineB10B11.terminal1, Bus11.terminal) annotation(
    Line(points = {{4, 60}, {-10, 60}}, color = {0, 0, 255}));
  connect(LineB10B11.terminal2, Bus10.terminal) annotation(
    Line(points = {{24, 60}, {24, 40}}, color = {0, 0, 255}));
  connect(LineB2B3.terminal1, Bus2.terminal) annotation(
    Line(points = {{-10, -100}, {-78, -100}}, color = {0, 0, 255}));
  connect(LineB2B3.terminal2, Bus3.terminal) annotation(
    Line(points = {{10, -100}, {112, -100}, {112, -120}}, color = {0, 0, 255}));
  connect(LineB2B4.terminal1, Bus2.terminal) annotation(
    Line(points = {{-10, -90}, {-78, -90}, {-78, -100}}, color = {0, 0, 255}));
  connect(LineB2B4.terminal2, Bus4.terminal) annotation(
    Line(points = {{10, -90}, {22, -90}, {22, -80}, {70, -80}}, color = {0, 0, 255}));
  connect(LineB2B5.terminal1, Bus2.terminal) annotation(
    Line(points = {{-68, -80}, {-78, -80}, {-78, -100}}, color = {0, 0, 255}));
  connect(LineB2B5.terminal2, Bus5.terminal) annotation(
    Line(points = {{-48, -80}, {-30, -80}, {-30, -60}}, color = {0, 0, 255}));
  connect(LineB3B4.terminal1, Bus4.terminal) annotation(
    Line(points = {{92, -80}, {70, -80}}, color = {0, 0, 255}));
  connect(LineB3B4.terminal2, Bus3.terminal) annotation(
    Line(points = {{112, -80}, {112, -120}}, color = {0, 0, 255}));
  connect(LineB4B5.terminal1, Bus5.terminal) annotation(
    Line(points = {{2, -60}, {-30, -60}}, color = {0, 0, 255}));
  connect(LineB4B5.terminal2, Bus4.terminal) annotation(
    Line(points = {{22, -60}, {70, -60}, {70, -80}}, color = {0, 0, 255}));
  connect(LineB6B11.terminal1, Bus6.terminal) annotation(
    Line(points = {{-50, 60}, {-60, 60}, {-60, 0}, {-30, 0}}, color = {0, 0, 255}));
  connect(LineB6B11.terminal2, Bus11.terminal) annotation(
    Line(points = {{-30, 60}, {-10, 60}}, color = {0, 0, 255}));
  connect(LineB6B12.terminal1, Bus12.terminal) annotation(
    Line(points = {{-100, 0}, {-100, 50}}, color = {0, 0, 255}));
  connect(LineB6B12.terminal2, Bus6.terminal) annotation(
    Line(points = {{-80, 0}, {-30, 0}}, color = {0, 0, 255}));
  connect(LineB6B13.terminal1, Bus13.terminal) annotation(
    Line(points = {{-74, 20}, {-74, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(LineB6B13.terminal2, Bus6.terminal) annotation(
    Line(points = {{-54, 20}, {-30, 20}, {-30, 0}}, color = {0, 0, 255}));
  connect(LineB7B8.terminal1, Bus7.terminal) annotation(
    Line(points = {{112, 20}, {112, -1}, {90, -1}, {90, 0}}, color = {0, 0, 255}));
  connect(LineB7B8.terminal2, Bus8.terminal) annotation(
    Line(points = {{132, 20}, {132, 40}}, color = {0, 0, 255}));
  connect(LineB7B9.terminal2, Bus7.terminal) annotation(
    Line(points = {{90, 20}, {90, 0}}, color = {0, 0, 255}));
  connect(LineB7B9.terminal1, Bus9.terminal) annotation(
    Line(points = {{70, 20}, {50, 20}}, color = {0, 0, 255}));
  connect(LineB9B10.terminal2, Bus9.terminal) annotation(
    Line(points = {{20, 20}, {50, 20}}, color = {0, 0, 255}));
  connect(LineB9B10.terminal1, Bus10.terminal) annotation(
    Line(points = {{0, 20}, {0, 40}, {24, 40}}, color = {0, 0, 255}));
  connect(LineB9B14.terminal1, Bus14.terminal) annotation(
    Line(points = {{70, 80}, {70, 79}, {30, 79}, {30, 80}}, color = {0, 0, 255}));
  connect(LineB9B14.terminal2, Bus9.terminal) annotation(
    Line(points = {{90, 80}, {90, 40}, {50, 40}, {50, 20}}, color = {0, 0, 255}));
  connect(Tfo1.terminal1, Bus5.terminal) annotation(
    Line(points = {{-30, -40}, {-30, -60}}, color = {0, 0, 255}));
  connect(Tfo1.terminal2, Bus6.terminal) annotation(
    Line(points = {{-30, -20}, {-30, 0}}, color = {0, 0, 255}));
  connect(Tfo2.terminal1, Bus4.terminal) annotation(
    Line(points = {{70, -40}, {70, -80}}, color = {0, 0, 255}));
  connect(Tfo2.terminal2, Bus9.terminal) annotation(
    Line(points = {{70, -20}, {70, -1}, {50, -1}, {50, 20}}, color = {0, 0, 255}));
  connect(Tfo3.terminal1, Bus4.terminal) annotation(
    Line(points = {{90, -40}, {70, -40}, {70, -80}}, color = {0, 0, 255}));
  connect(Tfo3.terminal2, Bus7.terminal) annotation(
    Line(points = {{90, -20}, {90, 0}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-06, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end NetworkComponentsExtVar;
