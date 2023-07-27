within Dynawo.Examples.DynaFlow.IllustrativeExamples;

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

model CoordinatedVControl "System with two generators and a coordinated voltage control"
  import Dynawo;

  extends Icons.Example;

  // Generators
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp Generator1(KGover = 1, PGen0Pu = 1.5, PMaxPu = 10000, PMinPu = -10000, PNom = 1, PRef0Pu = -1.5, QGen0Pu = 0.5, QMaxPu = 0.62, QMinPu = -2, QPercent = 1, QRef0Pu = -0.5, U0Pu = 1.05, i0Pu = Complex(-1.42857, 0.47619), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPQPropDiagramPQ.QStatus.Standard, u0Pu = Complex(1.05, 0)) annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Dynawo.Electrical.Machines.SignalN.GeneratorPQPropDiagramPQ Generator2(KGover = 1, PGen0Pu = 1.5, PMaxPu = 10000, PMinPu = -10000, PNom = 1, PRef0Pu = -1.5, QGen0Pu = 0.5, QMax0Pu = 2, QPercent = 1, QRef0Pu = -0.5, U0Pu = 1.05, i0Pu = Complex(-1.42857, 0.47619), limUQDown0 = false, limUQUp0 = false, qStatus0 = Dynawo.Electrical.Machines.SignalN.GeneratorPQPropDiagramPQ.QStatus.Standard, tableQMax.table = [0, 2; 1.5, 2; 1.601, 0], tableQMax.tableOnFile = false, tableQMin.table = [0, -2; 2, -1], tableQMin.tableOnFile = false, u0Pu = Complex(1.05, 0)) annotation(
     Placement(visible = true, transformation(origin = {-80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Lines
  Dynawo.Electrical.Lines.Line Line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.045044) annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line Line1bis(BPu = 0, GPu = 0, RPu = 0, XPu = 0.045044) annotation(
    Placement(visible = true, transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Buses
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 1.0305614) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Bus annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Generators Control
  Dynawo.Electrical.Controls.Basics.Step SignalN(Height = 0.1, Value0 = 0, tStep = 70);
  Dynawo.Electrical.Controls.Voltage.VRRemote SignalNQ(FreezingActivated = true, Gain = 1, NbGenMax = 2, U0 = 1.05, URef0 = 1.05, tIntegral = 10);

  // Event
  Dynawo.Electrical.Events.Event.SingleBooleanEvent DisconnectLine(stateEvent1 = true, tEvent = 50);

equation
  // SwitchOffSignals
  Generator1.switchOffSignal1.value = false;
  Generator1.switchOffSignal2.value = false;
  Generator1.switchOffSignal3.value = false;
  Generator2.switchOffSignal1.value = false;
  Generator2.switchOffSignal2.value = false;
  Generator2.switchOffSignal3.value = false;
  Line1.switchOffSignal1.value = false;
  Line1.switchOffSignal2.value = false;
  Line1bis.switchOffSignal1.value = false;

  // Generators controls and references
  Generator1.N = SignalN.step.value;
  Generator1.NQ = SignalNQ.NQ;
  Generator1.PRefPu = Generator1.PRef0Pu;
  Generator2.N = SignalN.step.value;
  Generator2.NQ = SignalNQ.NQ;
  Generator2.PRefPu = Generator2.PRef0Pu;
  SignalNQ.URegulated = Generator1.UPu;
  SignalNQ.URef = SignalNQ.URef0;
  SignalNQ.limUQDown[1] = Generator1.limUQDown;
  SignalNQ.limUQDown[2] = Generator2.limUQDown;
  SignalNQ.limUQUp[1] = Generator1.limUQUp;
  SignalNQ.limUQUp[2] = Generator2.limUQUp;

  // Network connections
  connect(DisconnectLine.state1, Line1bis.switchOffSignal2);
  connect(Line1bis.terminal2, infiniteBus1.terminal) annotation(
    Line(points = {{20, 20}, {40, 20}, {40, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(Line1.terminal2, infiniteBus1.terminal) annotation(
    Line(points = {{20, -20}, {40, -20}, {40, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(Generator2.terminal, Bus.terminal) annotation(
    Line(points = {{-80, -20}, {-60, -20}, {-60, 0}, {-40, 0}}, color = {0, 0, 255}));
  connect(Generator1.terminal, Bus.terminal) annotation(
    Line(points = {{-80, 20}, {-60, 20}, {-60, 0}, {-40, 0}}, color = {0, 0, 255}));
  connect(Bus.terminal, Line1bis.terminal1) annotation(
    Line(points = {{-40, 0}, {-20, 0}, {-20, 20}, {0, 20}}, color = {0, 0, 255}));
  connect(Bus.terminal, Line1.terminal1) annotation(
    Line(points = {{-40, 0}, {-20, 0}, {-20, -20}, {0, -20}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3000, Tolerance = 1e-06, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"),
  Documentation(info = "<html><head></head><body><div>This test case is composed of generator 1 (GeneratorPQProp), generator 2 (GeneratorPQPropDiagram), one infinite bus, one regular bus, and two lines.&nbsp;</div><div>Both generators use a coordinated voltage control (SignalNQ) that dispatches the needed reactive power between the two generators to control the voltage at the generators connection bus.&nbsp;</div><div>They are also responsible for the primary frequency regulation through the active power control (SignalN). Here, SignalN is modeled as a step function rather than a proper regulation. Finally, the role of the infinite bus is to balance the generation and consumption of power.</div><div><br></div><div>A disconnection of Line1bis from the infinite bus caused by an event is simulated with this test case:</div><div>At t = 50s, Line1bis is disconnected from the infinite bus; thus, the voltage at the generator level will increase. A signal NQ is calculated using a PI controller and will differ from 0 since URegulated is greater than URef. As a consequence, the reactive power generation QGenPu of the generators will decrease; thus, the URegulated will decrease following the PI control.</div><div>The freezing should be activated to stop the integration when the reactive power limits are reached.</div><div>At t = 70s, SignalN will modify the generated active power PGenPu of generator 1 and generator 2 as long as it stays within the minimum and maximum limits. Here, PGenPu will be increased, causing the URegulated at the generator level to decrease below URef. SignalNQ will cause QGenPu to increase, which consequently increases the voltage.</div></body></html>"));
end CoordinatedVControl;
