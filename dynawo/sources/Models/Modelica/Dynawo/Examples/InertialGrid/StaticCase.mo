within Dynawo.Examples.InertialGrid;

/*
 * Copyright (c) 2024, RTE (http://www.rte-france.com)
 * See AUTHORS.txt
 * All rights reserved.
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at http://mozilla.org/MPL/2.0/.
 * SPDX-License-Identifier: MPL-2.0
 *
  This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model StaticCase
  extends Modelica.Icons.Example;

  parameter Dynawo.Types.VoltageModule UNom = 400 "Nominal voltage for the test case";

  // Network parameters
  parameter Dynawo.Types.PerUnit R1Pu = 0.02 * Dynawo.Electrical.SystemBase.SnRef / (UNom * UNom) "Line resistance in pu (base SnRef/UNom) by kilometer for branch 1";
  parameter Dynawo.Types.PerUnit X1Pu = 0.27 * Dynawo.Electrical.SystemBase.SnRef / (UNom * UNom) "Line reactance in pu (base SnRef/UNom) by kilometer for branch 1";
  parameter Dynawo.Types.PerUnit R2Pu = 0.02 * Dynawo.Electrical.SystemBase.SnRef / (UNom * UNom) "Line resistance in pu (base SnRef/UNom) by kilometer for branch 2";
  parameter Dynawo.Types.PerUnit X2Pu = 0.27 * Dynawo.Electrical.SystemBase.SnRef / (UNom * UNom) "Line reactance in pu (base SnRef/UNom) by kilometer for branch 2";
  parameter Dynawo.Types.PerUnit R3Pu = 0.18 * Dynawo.Electrical.SystemBase.SnRef / (UNom * UNom) "Line resistance in pu (base SnRef/UNom) by kilometer for branch 3";
  parameter Dynawo.Types.PerUnit X3Pu = 0.81 * Dynawo.Electrical.SystemBase.SnRef / (UNom * UNom) "Line reactance in pu (base SnRef/UNom) by kilometer for branch 3";
  parameter Real L1 = 120 "Branch 1 length (in km)";
  parameter Real L2 = 120 "Branch 2 length (in km)";
  parameter Real L3 = 100 "Branch 3 length (in km)";

  Dynawo.Electrical.Loads.LoadZIP load(Ip = 0, Iq = 0, Pp = 1, Pq = 1, Zp = 0, Zq = 0, i0Pu = Modelica.ComplexMath.conj(load.s0Pu / load.u0Pu), s0Pu = Complex(5, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {84, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ loadPQ(i0Pu = Modelica.ComplexMath.conj(loadPQ.s0Pu / loadPQ.u0Pu), s0Pu = Complex(0, 0), u0Pu = Complex(slackBus.UPu * cos(slackBus.UPhase), slackBus.UPu * sin(slackBus.UPhase))) annotation(
    Placement(visible = true, transformation(origin = {-20, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus busIG1 annotation(
    Placement(visible = true, transformation(origin = {-2, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus busIG2 annotation(
    Placement(visible = true, transformation(origin = {-2, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus busL annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = R1Pu * L1, XPu = X1Pu * L1) annotation(
    Placement(visible = true, transformation(origin = {16, 24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus annotation(
    Placement(visible = true, transformation(origin = {16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = R2Pu * L2, XPu = X2Pu * L2) annotation(
    Placement(visible = true, transformation(origin = {16, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0, GPu = 0, RPu = R3Pu * L3, XPu = X3Pu * L3) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBus slackBus(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-36, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.Simplified.GeneratorAlphaBeta Gen2(Alpha = 0, Beta = 0, PGen0Pu = 3.3, QGen0Pu = 0, U0Pu = 1, i0Pu = ComplexMath.conj(Complex(Gen2.PGen0Pu, Gen2.QGen0Pu) / Gen2.u0Pu), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-26, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  //Switch-off equations inhibitions
  load.switchOffSignal1.value = false;
  load.switchOffSignal2.value = false;
  loadPQ.switchOffSignal1.value = false;
  loadPQ.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  Gen2.switchOffSignal1.value = false;
  Gen2.switchOffSignal2.value = false;
  Gen2.switchOffSignal3.value = false;

  // No variations in the loads
  der(load.PRefPu) = 0;
  der(load.QRefPu) = 0;
  load.deltaP = 0;
  load.deltaQ = 0;
  der(loadPQ.PRefPu) = 0;
  der(loadPQ.QRefPu) = 0;
  loadPQ.deltaP = 0;
  loadPQ.deltaQ = 0;

  connect(busIG1.terminal, loadPQ.terminal) annotation(
    Line(points = {{-2, 40}, {-20, 40}, {-20, 18}}, color = {0, 0, 255}));
  connect(load.terminal, busL.terminal) annotation(
    Line(points = {{84, 0}, {72, 0}}, color = {0, 0, 255}));
  connect(bus.terminal, line1.terminal2) annotation(
    Line(points = {{16, 0}, {16, 14}}, color = {0, 0, 255}));
  connect(line1.terminal1, busIG1.terminal) annotation(
    Line(points = {{16, 34}, {16, 40}, {-2, 40}}, color = {0, 0, 255}));
  connect(line2.terminal1, bus.terminal) annotation(
    Line(points = {{16, -36}, {16, 0}}, color = {0, 0, 255}));
  connect(busIG2.terminal, line2.terminal2) annotation(
    Line(points = {{-2, -40}, {16, -40}, {16, -16}}, color = {0, 0, 255}));
  connect(line3.terminal1, busL.terminal) annotation(
    Line(points = {{60, 0}, {72, 0}}, color = {0, 0, 255}));
  connect(line3.terminal2, bus.terminal) annotation(
    Line(points = {{40, 0}, {16, 0}}, color = {0, 0, 255}));
  connect(slackBus.terminal, busIG1.terminal) annotation(
    Line(points = {{-36, 40}, {-2, 40}}, color = {0, 0, 255}));
  connect(Gen2.terminal, busIG2.terminal) annotation(
    Line(points = {{-26, -40}, {-2, -40}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>It is a static version of the double inertia test case to easily calculate initial values for the time-domain example.</body></html>"));
end StaticCase;
