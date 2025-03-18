within Dynawo.Examples.Wind.WECC;

model Zone1_Fault_Transient "WECC Wind Type 4B Model on infinite bus"
  /*
  * Copyright (c) 2023, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
  */
  extends Icons.Example;
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1.00125, UEvtPu = 0, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WT4B.PF0)) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Wind.WECC.WT4CurrentSource_INIT wT4CurrentSource_INIT(P0Pu = -1, Q0Pu = 0, RPu = 0.01, SNom = 100, U0Pu = 1, UPhase0 = 0.0499584, XPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.001, tBegin = 1, tEnd = 1.15) annotation(
    Placement(visible = true, transformation(origin = {-20, -60}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
  Electrical.Wind.WECC.WT4BCurrentSource WT4B(DPMaxPu = 1, DPMinPu = -1, Dbd1Pu = -0.1, Dbd2Pu = 0.1, IMaxPu = 1, Id0Pu(fixed = false), Iq0Pu(fixed = false), IqFrzPu = 0, Iqh1Pu = 1.05, Iql1Pu = -1.05, IqrMaxPu = 999, IqrMinPu = -999, KiPLL = 20, KpPLL = 3, Kqi = 1e-3, Kqp = 1e-3, Kqv = 1.95, Kvi = 0.1, Kvp = 5, Lvplsw = false, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu(fixed = false), PF0(fixed = false), PFlag = false, PInj0Pu(fixed = false), PMaxPu = 1.1, PMinPu = 0, PQFlag = false, PfFlag = false, Q0Pu(fixed = false), QFlag = false, QInj0Pu(fixed = false), QMaxPu = 0.6, QMinPu = -0.6, RPu(fixed = false), RrpwrPu = 1.1, SNom(fixed = false), U0Pu(fixed = false), UInj0Pu(fixed = false), UPhase0(fixed = false), UPhaseInj0(fixed = false), VDLIp11 = 0.5, VDLIp12 = 99, VDLIp21 = 0.7, VDLIp22 = 99, VDLIp31 = 1, VDLIp32 = 99, VDLIp41 = 1.1, VDLIp42 = 99, VDLIq11 = 0.5, VDLIq12 = 99, VDLIq21 = 0.7, VDLIq22 = 99, VDLIq31 = 1, VDLIq32 = 99, VDLIq41 = 1.1, VDLIq42 = 99, VDipPu = 0.9, VFlag = false, VMaxPu = 1, VMinPu = 0, VRef0Pu = 1, VRef1Pu = 1, VUpPu = 1.1, XPu(fixed = false), brkpt = 0.9, i0Pu(im(fixed = false), re(fixed = false)), lvpl1 = 1.22, s0Pu(im(fixed = false), re(fixed = false)), tFilterGC = 0.02, tG = 0.001, tHoldIpMax = 0, tHoldIq = 0, tIq = 0.15, tP = 0.02, tPord = 0.12, tRv = 0.01, u0Pu(im(fixed = false), re(fixed = false)), uInj0Pu(im(fixed = false), re(fixed = false)), zerox = 0.4) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Step step( height = 0,offset = 1, startTime = 3)  annotation(
    Placement(visible = true, transformation(origin = {80, -12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0, offset = 0, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {80, 24}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
initial algorithm
  WT4B.Id0Pu := wT4CurrentSource_INIT.Id0Pu;
  WT4B.Iq0Pu := wT4CurrentSource_INIT.Iq0Pu;
  WT4B.PInj0Pu := wT4CurrentSource_INIT.PInj0Pu;
  WT4B.QInj0Pu := wT4CurrentSource_INIT.QInj0Pu;
  WT4B.UInj0Pu := wT4CurrentSource_INIT.UInj0Pu;
  WT4B.U0Pu := wT4CurrentSource_INIT.U0Pu;
  WT4B.P0Pu := wT4CurrentSource_INIT.P0Pu;
  WT4B.Q0Pu := wT4CurrentSource_INIT.Q0Pu;
  WT4B.UPhaseInj0 := wT4CurrentSource_INIT.UPhaseInj0;
  WT4B.UPhase0 := wT4CurrentSource_INIT.UPhase0;
  WT4B.i0Pu.re := wT4CurrentSource_INIT.i0Pu.re;
  WT4B.i0Pu.im := wT4CurrentSource_INIT.i0Pu.im;
  WT4B.u0Pu.re := wT4CurrentSource_INIT.u0Pu.re;
  WT4B.u0Pu.im := wT4CurrentSource_INIT.u0Pu.im;
  WT4B.uInj0Pu.re := wT4CurrentSource_INIT.uInj0Pu.re;
  WT4B.uInj0Pu.im := wT4CurrentSource_INIT.uInj0Pu.im;
  WT4B.s0Pu.re := wT4CurrentSource_INIT.s0Pu.re;
  WT4B.s0Pu.im := wT4CurrentSource_INIT.s0Pu.im;
  WT4B.PF0 := wT4CurrentSource_INIT.PF0;
  WT4B.XPu := wT4CurrentSource_INIT.XPu;
  WT4B.RPu := wT4CurrentSource_INIT.RPu;
  WT4B.SNom := wT4CurrentSource_INIT.SNom;
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  WT4B.injector.switchOffSignal1.value = false;
  WT4B.injector.switchOffSignal2.value = false;
  WT4B.injector.switchOffSignal3.value = false;
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, nodeFault.terminal) annotation(
    Line(points = {{-20, 0}, {-20, -60}}, color = {0, 0, 255}));
  connect(PFaRef.y, WT4B.PFaRef) annotation(
    Line(points = {{70, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(line.terminal2, WT4B.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(step.y, WT4B.PInjRefPu) annotation(
    Line(points = {{69, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(step1.y, WT4B.QInjRefPu) annotation(
    Line(points = {{70, 24}, {42, 24}, {42, 12}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-04, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 4A park in response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end Zone1_Fault_Transient;
