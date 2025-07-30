within Dynawo.Examples.BESS.WECC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model BESSCurrentSource3 "WECC BESS with REEC-D and REGC-B with a plant controller REPC-A on infinite bus"
  extends Modelica.Icons.Example;

  Dynawo.Electrical.BESS.WECC.BESSCurrentSource3 BESS(DDn = 126,
   DPMaxPu = 999,
   DPMinPu = -999,
   DUp = 126,
   Dbd1Pu = -0.05,
   Dbd2Pu = 0.05,
   DbdPu = 0,
   EMaxPu = 0.1,
   EMinPu = -0.1,
   FDbd1Pu = 0.00083,
   FDbd2Pu = 0.00083,
   FEMaxPu = 999,
   FEMinPu = -999,
   FreqFlag = true,
   IMaxPu = 1.11,
   Id0Pu(fixed = false),
   Iq0Pu(fixed = false),
   Iqh1Pu = 0.75,
   Iql1Pu = -0.75,
   IqrMaxPu = 999,
   IqrMinPu = -999,
   Kc = 0.15,
   Ki = 1e-6,
   KiPLL = 20,
   Kig = 1e-6,
   Kp = 1e-6,
   KpPLL = 3,
   Kpg = 1,
   Kqi = 1,
   Kqp = 1e-6,
   Kqv = 15,
   Kvi = 0.1,
   Kvp = 1e-6,
   Lvplsw = false,
   OmegaMaxPu = 1.5,
   OmegaMinPu = 0.5,
   P0Pu = -0.03,
   PF0(fixed = false),
   PInj0Pu(fixed = false),
   PMaxPu = 1,
   PMinPu = -0.667,
   PQFlag = false,
   PfFlag = false,
   Q0Pu = 0,
   QFlag = 0,
   QInj0Pu(fixed = false),
   QMaxPu = 0.75,
   QMinPu = -0.75,
   RPu = 0,
   RefFlag = false,
   RrpwrPu = 10,
   SNom = 6,
   SOC0Pu = 0.5,
   U0Pu = 1,
   UInj0Pu(fixed = false),
   UPhaseInj0 = 0.00000144621,
   VCompFlag = false,
   VDLIp11 = 0.1,
   VDLIp12 = 1.11,
   VDLIp21 = 0.2,
   VDLIp22 = 1.11,
   VDLIp31 = 0.3,
   VDLIp32 = 1.11,
   VDLIp41 = 0.4,
   VDLIp42 = 1.11,
   VDLIq11 = 0,
   VDLIq12 = 0.75,
   VDLIq21 = 0.2,
   VDLIq22 = 0.75,
   VDLIq31 = 0.3,
   VDLIq32 = 0.75,
   VDLIq41 = 0.4,
   VDLIq42 = 0.75,
   VDipPu = -99,
   VFlag = true,
   VFrz = 0,
   VMaxPu = 1.1,
   VMinPu = 0.9,
   VRef0Pu = 1,
   VUpPu = 99,
   XPu = 1e-10,
   brkpt = 0.1,
   i0Pu(re(fixed = false), im(fixed = false)),
   iInj0Pu(re(fixed = false), im(fixed = false)),
   lvpl1 = 1.22, s0Pu(re(fixed = false), im(fixed = false)),
   tFilterGC = 0.02,
   tFilterPC = 0.02,
   tFt = 1e-10,
   tFv = 0.05,
   tG = 0.017,
   tIq = 0.017,
   tLag = 0.1,
   tP = 0.05,
   tPord = 0.017,
   tRv = 0.01,
   u0Pu(re(fixed = false), im(fixed = false)),
   uInj0Pu(re(fixed = false), im(fixed = false)),
   tR1 = 0.02,
   Ke = 0,
   XcPu = 0.15,
   RcPu = 0.02,
   PFlag = false,
   VRef1Pu = 0,
   VDLIp51 = 0.5,
   VDLIp52 = 1.11,
   VDLIp61 = 0.6,
   VDLIp62 = 1.11,
   VDLIp71 = 0.7,
   VDLIp72 = 1.11,
   VDLIp81 = 0.8,
   VDLIp82 = 1.11,
   VDLIp91 = 0.9,
   VDLIp92 = 1.11,
   VDLIp101 = 1.0,
   VDLIp102 = 1.11,
   VDLIq51 = 0.5,
   VDLIq52 = 0.75,
   VDLIq61 = 0.6,
   VDLIq62 = 0.75,
   VDLIq71 = 0.7,
   VDLIq72 = 0.75,
   VDLIq81 = 0.8,
   VDLIq82 = 0.75,
   VDLIq91 = 0.9,
   VDLIq92 = 0.75,
   VDLIq101 = 1.0,
   VDLIq102 = 0.75,
   tHoldIpMax = 0,
   tHoldIq = 0,
   IqFrzPu = 0,
   UBlkHPu = 999,
   UBlkLPu = -999,
   tBlkDelay = 0,
   zerox = 0.05,
   Kpp=1,
   Kpi=1,
   PQFlagFRT=false,
   PEFlag=true) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.5) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(BESS.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0000020661) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.55, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 1.5, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant PAuxPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.BESS.WECC.BESS_INIT bess_INIT(P0Pu = BESS.P0Pu, Q0Pu = BESS.Q0Pu, RPu = BESS.RPu, SNom = BESS.SNom, U0Pu = BESS.U0Pu, UPhase0 = BESS.UPhaseInj0, XPu = BESS.XPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  BESS.Id0Pu := bess_INIT.Id0Pu;
  BESS.Iq0Pu := bess_INIT.Iq0Pu;
  BESS.PF0 := bess_INIT.PF0;
  BESS.PInj0Pu := bess_INIT.PInj0Pu;
  BESS.QInj0Pu := bess_INIT.QInj0Pu;
  BESS.UInj0Pu := bess_INIT.UInj0Pu;
  BESS.i0Pu.re := bess_INIT.i0Pu.re;
  BESS.i0Pu.im := bess_INIT.i0Pu.im;
  BESS.iInj0Pu.re := bess_INIT.iInj0Pu.re;
  BESS.iInj0Pu.im := bess_INIT.iInj0Pu.im;
  BESS.s0Pu.re := bess_INIT.s0Pu.re;
  BESS.s0Pu.im := bess_INIT.s0Pu.im;
  BESS.u0Pu.re := bess_INIT.u0Pu.re;
  BESS.u0Pu.im := bess_INIT.u0Pu.im;
  BESS.uInj0Pu.re := bess_INIT.uInj0Pu.re;
  BESS.uInj0Pu.im := bess_INIT.uInj0Pu.im;

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  BESS.injector.switchOffSignal1.value = false;
  BESS.injector.switchOffSignal2.value = false;
  BESS.injector.switchOffSignal3.value = false;
  connect(URefPu.y, BESS.URefPu) annotation(
    Line(points = {{79, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, BESS.omegaRefPu) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, BESS.QRefPu) annotation(
    Line(points = {{79, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PRefPu.y, BESS.PRefPu) annotation(
    Line(points = {{79, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(PFaRef.y, BESS.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(line.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-60, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(PAuxPu.y, BESS.PAuxPu) annotation(
    Line(points = {{-38, -80}, {12, -80}, {12, -22}}, color = {0, 0, 127}));
  connect(line.terminal2, BESS.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-05, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"),
    Documentation(info = "<html><head></head><body>
    <figure>This example and the data are inspired by the article [P. <span style=\"text-decoration: underline;\">Pourbeik</span> and J. K. <span style=\"text-decoration: underline;\">Petter</span>, <span style=\"text-decoration: underline;\">“Modeling</span> and validation <span style=\"text-decoration: underline;\">of</span> <span style=\"text-decoration: underline;\">battery</span> <span style=\"text-decoration: underline;\">energy</span> <span style=\"text-decoration: underline;\">storage</span> <span style=\"text-decoration: underline;\">systems&nbsp;</span><span style=\"text-decoration: underline;\">using</span> simple <span style=\"text-decoration: underline;\">generic</span> <span style=\"text-decoration: underline;\">models</span> for <span style=\"text-decoration: underline;\">power</span> system <span style=\"text-decoration: underline;\">stability</span> <span style=\"text-decoration: underline;\">studies”</span>, <span style=\"text-decoration: underline;\">CIGRE</span> Science and Engineering, <span style=\"text-decoration: underline;\">October</span> 2017, pp. 63-72.]</figure><figure>At initial time, the active power demanded by the battery is 0.5 pu (base SNom = 6 MVA) and the reactive power is 0 pu (base SNom = 6 MVA).</figure><figure>The BESS is able to discharge since the initial state of charge SOC0Pu = 0.5 is between the accepted range [SOCMinPu = 0.2 , SOCMaxPu = 0.8]. Since the simulation is only for 3 s, and the discharge time is considered much longer, the state of charge SOCPu is considered constant all along the simulation time.</figure><figure>At t = 1 s, a fault at the infinite bus is simulated and it can be seen that the BESS starts injecting reactive power until the fault is cleared at t = 1.5 s.</figure><figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/PInjPuSn3.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/QInjPuSn3.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/UPu3.png\">
    </figure>
    </body></html>"));
end BESSCurrentSource3;
