within Dynawo.Examples.LoadFrequencyDependent;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model LoadAlphaBetaFrequencyDependent
  extends Modelica.Icons.Example;

  // Load Alpha Beta with Frequency Dependence
  Dynawo.Electrical.Loads.LoadAlphaBetaFrequencyDependent loadAlphaBetaFrequencyDependent(i0Pu(re(fixed = false), im(fixed = false)), s0Pu(re(fixed = false), im(fixed = false)), u0Pu(re(fixed = false), im(fixed = false)), KiPLL = 10, KpPLL = 1.0, OmegaMaxPu = 1.10, OmegaMinPu = 0.90, alpha = 1.5, beta = 2.0, Kpf = 2.0, Kqf = -2.0) annotation(
    Placement(transformation(origin = {56, 6}, extent = {{10, -10}, {-10, 10}})));

  // Infinite Bus with Variations == Grid
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 0.8, omega0Pu = 1, omegaEvtPu = 1.05, UPhase = 0, tUEvtStart = 2, tUEvtEnd = 4, tOmegaEvtStart = 6, tOmegaEvtEnd = 8) annotation(
    Placement(transformation(origin = {-68, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Line
  Dynawo.Electrical.Lines.Line line(RPu = 0.02, XPu = 0.08, GPu = 0, BPu = 0, SwitchOffSignal30 = false) annotation(
    Placement(transformation(origin = {-32, 10}, extent = {{-10, -10}, {10, 10}})));

  // Sources
  Modelica.Blocks.Sources.Constant PRefPu(k = 1.0) annotation(
    Placement(transformation(origin = {90, -80}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 1.0) annotation(
    Placement(transformation(origin = {10, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant deltaP(k = 0) annotation(
    Placement(transformation(origin = {90, -40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant deltaQ(k = 0) annotation(
    Placement(transformation(origin = {10, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1.0) annotation(
    Placement(transformation(origin = {90, 6}, extent = {{10, -10}, {-10, 10}})));

  // Bus
  Dynawo.Electrical.Buses.Bus bus annotation(
    Placement(transformation(origin = {12, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Initialization
  Dynawo.Electrical.Loads.Load_INIT load_INIT(P0Pu = PRefPu.k, Q0Pu = QRefPu.k, U0Pu = 0.884660, UPhase0 = -0.067875) annotation(
    Placement(transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}})));

initial algorithm
  loadAlphaBetaFrequencyDependent.i0Pu.re := load_INIT.i0Pu.re;
  loadAlphaBetaFrequencyDependent.i0Pu.im := load_INIT.i0Pu.im;
  loadAlphaBetaFrequencyDependent.s0Pu.re := load_INIT.s0Pu.re;
  loadAlphaBetaFrequencyDependent.s0Pu.im := load_INIT.s0Pu.im;
  loadAlphaBetaFrequencyDependent.u0Pu.re := load_INIT.u0Pu.re;
  loadAlphaBetaFrequencyDependent.u0Pu.im := load_INIT.u0Pu.im;

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  loadAlphaBetaFrequencyDependent.switchOffSignal1 = false;
  loadAlphaBetaFrequencyDependent.switchOffSignal2 = false;

  connect(infiniteBusWithVariations.terminal, line.terminal1) annotation(
    Line(points = {{-68, 10}, {-42, 10}}, color = {0, 0, 255}));
  connect(PRefPu.y, loadAlphaBetaFrequencyDependent.PRefPu) annotation(
    Line(points = {{79, -80}, {60, -80}, {60, -2}, {60, -2}}, color = {0, 0, 127}));
  connect(QRefPu.y, loadAlphaBetaFrequencyDependent.QRefPu) annotation(
    Line(points = {{21, -80}, {52, -80}, {52, -2}}, color = {0, 0, 127}));
  connect(deltaP.y, loadAlphaBetaFrequencyDependent.deltaP) annotation(
    Line(points = {{80, -40}, {64, -40}, {64, -2}}, color = {0, 0, 127}));
  connect(deltaQ.y, loadAlphaBetaFrequencyDependent.deltaQ) annotation(
    Line(points = {{22, -40}, {48, -40}, {48, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, loadAlphaBetaFrequencyDependent.omegaRefPu) annotation(
    Line(points = {{79, 6}, {68, 6}}, color = {0, 0, 127}));
  connect(line.terminal2, bus.terminal) annotation(
    Line(points = {{-22, 10}, {12, 10}}, color = {0, 0, 255}));
  connect(bus.terminal, loadAlphaBetaFrequencyDependent.terminal) annotation(
    Line(points = {{12, 10}, {56, 10}, {56, 6}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 12, Tolerance = 1e-06, Interval = 0.024),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in an Infinite Bus with variating voltage and frequency connected to an Alpha Beta load with frequency dependence through a RL line.&nbsp;</span><div><br></div><div>For the model, alpha = 1.5 and beta = 2 while sensitivity to frequency is defined as Kpf = 2.0 and Kqd = -2.0.</div><div><div>Between t = 2.0 s and t = 4.0 s, the nominal voltage of the infinite bus decreases from 1.0 pu to 0.8 pu. Between t = 6.0 s and t = 8.0 s, the nominal frequency of the infinite bus increases from 1.0 pu to 1.05 pu.<br><span style=\"font-size: 12px;\"><div><figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/LoadFrequencyDependent/Resources/Images/LoadAlphaBeta.png\">
    </figure>
    <br></div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></span></div></div></body></html>"));
end LoadAlphaBetaFrequencyDependent;
