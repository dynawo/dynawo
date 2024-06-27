within Dynawo.Examples.Nordic.TestCases;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model LoadFlowB "Model of load flow calculation for the Nordic 32 test system used for voltage stability studies (operating point B)"
  extends Dynawo.Examples.Nordic.TestCases.LoadFlowA(
    P0Pu_g15 = 5.4,
    P0Pu_g18 = 5.3);

  Dynawo.Electrical.Buses.Bus bus_BG15b annotation(
    Placement(visible = true, transformation(origin = {80, -130}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_BG16b annotation(
    Placement(visible = true, transformation(origin = {5, -145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_BG18b annotation(
    Placement(visible = true, transformation(origin = {-60, -130}, extent = {{-5, 5}, {5, -5}}, rotation = -90)));

  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g15b_4047(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {80, -120}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g16b_4051(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 700.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {5, -137}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio trafo_g18b_4063(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 1.05 ^ 2 * (100 / 600.0), rTfoPu = 1.05) annotation(
    Placement(visible = true, transformation(origin = {-70, -130}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));

  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed g15b(PGen0Pu = P0Pu_g15, U0Pu = U0Pu_g15) annotation(
    Placement(visible = true, transformation(origin = {80, -140}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed g16b(PGen0Pu = P0Pu_g16, U0Pu = U0Pu_g16) annotation(
    Placement(visible = true, transformation(origin = {5, -150}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed g18b(PGen0Pu = P0Pu_g18, U0Pu = U0Pu_g18) annotation(
    Placement(visible = true, transformation(origin = {-56, -130}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));

equation
  trafo_g15b_4047.switchOffSignal1.value = false;
  trafo_g15b_4047.switchOffSignal2.value = false;
  trafo_g16b_4051.switchOffSignal1.value = false;
  trafo_g16b_4051.switchOffSignal2.value = false;
  trafo_g18b_4063.switchOffSignal1.value = false;
  trafo_g18b_4063.switchOffSignal2.value = false;
  g15b.switchOffSignal1.value = false;
  g15b.switchOffSignal2.value = false;
  g15b.switchOffSignal3.value = false;
  g16b.switchOffSignal1.value = false;
  g16b.switchOffSignal2.value = false;
  g16b.switchOffSignal3.value = false;
  g18b.switchOffSignal1.value = false;
  g18b.switchOffSignal2.value = false;
  g18b.switchOffSignal3.value = false;

  connect(trafo_g15b_4047.terminal1, bus_BG15b.terminal) annotation(
    Line(points = {{80, -125}, {80, -130}}, color = {0, 0, 255}));
  connect(trafo_g15b_4047.terminal2, bus_4047.terminal) annotation(
    Line(points = {{80, -115}, {80, -110}, {70, -110}}, color = {0, 0, 255}));
  connect(trafo_g16b_4051.terminal1, bus_BG16b.terminal) annotation(
    Line(points = {{5, -142}, {5, -145}}, color = {0, 0, 255}));
  connect(trafo_g16b_4051.terminal2, bus_4051.terminal) annotation(
    Line(points = {{5, -132}, {5, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(trafo_g18b_4063.terminal1, bus_BG18b.terminal) annotation(
    Line(points = {{-65, -130}, {-60, -130}}, color = {0, 0, 255}));
  connect(trafo_g18b_4063.terminal2, bus_4063.terminal) annotation(
    Line(points = {{-75, -130}, {-87, -130}}, color = {0, 0, 255}));
  connect(g15b.terminal, bus_BG15b.terminal) annotation(
    Line(points = {{80, -140}, {80, -130}}, color = {0, 0, 255}));
  connect(g16b.terminal, bus_BG16b.terminal) annotation(
    Line(points = {{5, -151}, {5, -145}}, color = {0, 0, 255}));
  connect(g18b.terminal, bus_BG18b.terminal) annotation(
    Line(points = {{-56, -130}, {-60, -130}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002), __OpenModelica_commandLineOptions = "--daemode", __OpenModelica_simulationFlags(lv = "LOG_STATS", noEquidistantTimeGrid = "()", s = "ida"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body>The LoadFlow model extends the network with PQ loads model and adds nonregulated transformers and PQ generators. It could also extend the network with alpha-beta loads model.<div><br></div><div>The initial power values have been taken from the&nbsp;<span style=\"font-size: 12px; font-family: 'MS Shell Dlg 2';\">IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015. The initial voltage values are taken from the report, operating point B.</span><div><font face=\"MS Shell Dlg 2\"><br></font><div>The initial power and voltage values should produce steady state.</div></div></div></body></html>"));
end LoadFlowB;
