within Dynawo.Examples.BESS.WECC;

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

model BESSCurrentSource "WECC BESS with REEC-C and REGC-B with a plant controller REPC-A on infinite bus"
  extends Icons.Example;

  Dynawo.Electrical.BESS.WECC.BESSCurrentSource BESS(
    ConverterLVControl = true,DDn = 126,
    DPMaxPu = 999,
    DPMinPu = -999,
    DUp = 126,
    Dbd1Pu = -0.12,
    Dbd2Pu = 0.12,
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
    Kc = 0.2,
    Ki = 5,
    KiPLL = 20,
    Kig = 5,
    Kp = 1,
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
    P0Pu = -0.7, PConv0Pu(fixed = false),
    PF0(fixed = false),
    PInj0Pu(fixed = false),
    PMaxPu = 1,
    PMinPu = -0.667, PPCLocal = true,
    PQFlag = false,
    PfFlag = false,
    Q0Pu = -0.2, QConv0Pu(fixed = false),
    QFlag = false,
    QInj0Pu(fixed = false),
    QMaxPu = 0.75,
    QMinPu = -0.75, RLvTrPu = 0.015, RMvHvPu = 0.02,
    RefFlag = true,
    RrpwrPu = 10,
    SNom = 200,
    SOC0Pu = 0.5,
    SOCMaxPu = 0.8,
    SOCMinPu = 0.2,
    U0Pu = 1,
    UInj0Pu(fixed = false), UPhase0 = 0.03533563863002929,
    VCompFlag = false,
    VDLIp11 = 0.2,
    VDLIp12 = 1.11,
    VDLIp21 = 0.5,
    VDLIp22 = 1.11,
    VDLIp31 = 0.75,
    VDLIp32 = 1.11,
    VDLIp41 = 1,
    VDLIp42 = 1.11,
    VDLIq11 = 0,
    VDLIq12 = 0.75,
    VDLIq21 = 0.2,
    VDLIq22 = 0.75,
    VDLIq31 = 0.5,
    VDLIq32 = 0.75,
    VDLIq41 = 1,
    VDLIq42 = 0.75,
    VDipPu = -99,
    VFlag = true,
    VFrz = 0,
    VMaxPu = 1.1,
    VMinPu = 0.9,
    VRef0Pu = 1,
    VUpPu = 99, XLvTrPu = 0.06, XMvHvPu = 0.1,
    brkpt = 0.1,
    i0Pu( im(fixed = false),re(fixed = false)), iConv0Pu(im(fixed = false), re(fixed = false)),
    iPcc0Pu(im(fixed = false), re(fixed = false)),
    lvpl1 = 1.22, rTfoPu = 0.97,
    s0Pu( im(fixed = false),re(fixed = false)),
    tBattery = 999,
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
    u0Pu( im(fixed = false),re(fixed = false)), uConv0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu( im(fixed = false),re(fixed = false)), uPcc0Pu(im(fixed = false), re(fixed = false)),
    zerox = 0.05) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(BESS.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(
    U0Pu = 0.9906184368094055,
    UEvtPu = 0.5,
    UPhase = 0,
    omega0Pu = 1,
    omegaEvtPu = 1.01,
    tOmegaEvtEnd = 17.5,
    tOmegaEvtStart = 17,
    tUEvtEnd = 13.5,
    tUEvtStart = 13) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant PAuxPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Wind.WECC.WTG4CurrentSource_INIT wTG4CurrentSource_INIT(BMvHvPu = BESS.BMvHvPu, ConverterLVControl = BESS.ConverterLVControl, GMvHvPu = BESS.GMvHvPu, P0Pu = BESS.P0Pu, PPCLocal = BESS.PPCLocal, PPcc0Pu = BESS.PPcc0Pu, Q0Pu = BESS.Q0Pu, QPcc0Pu = BESS.QPcc0Pu, RLvTrPu = BESS.RLvTrPu, RMvHvPu = BESS.RMvHvPu, SNom = BESS.SNom, U0Pu = BESS.U0Pu, UPcc0Pu = BESS.UPcc0Pu, UPhase0 = BESS.UPhase0, XLvTrPu = BESS.XLvTrPu, XMvHvPu = BESS.XMvHvPu, rTfoPu = BESS.rTfoPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef(height = 0.2, offset = BESS.PControl0Pu, startTime = 10) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URef(height = 0.02, offset = BESS.URef0Pu, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
initial algorithm

  BESS.Id0Pu := wTG4CurrentSource_INIT.Id0Pu;
  BESS.Iq0Pu := wTG4CurrentSource_INIT.Iq0Pu;
  BESS.PF0 := wTG4CurrentSource_INIT.PF0;
  BESS.PInj0Pu := wTG4CurrentSource_INIT.PInj0Pu;
  BESS.QInj0Pu := wTG4CurrentSource_INIT.QInj0Pu;
  BESS.UInj0Pu := wTG4CurrentSource_INIT.UInj0Pu;
  BESS.i0Pu.re := wTG4CurrentSource_INIT.i0Pu.re;
  BESS.i0Pu.im := wTG4CurrentSource_INIT.i0Pu.im;
  BESS.iConv0Pu.re := wTG4CurrentSource_INIT.iConv0Pu.re;
  BESS.iConv0Pu.im := wTG4CurrentSource_INIT.iConv0Pu.im;
  BESS.iPcc0Pu.re := wTG4CurrentSource_INIT.iPcc0Pu.re;
  BESS.iPcc0Pu.im := wTG4CurrentSource_INIT.iPcc0Pu.im;
  BESS.s0Pu.re := wTG4CurrentSource_INIT.s0Pu.re;
  BESS.s0Pu.im := wTG4CurrentSource_INIT.s0Pu.im;
  BESS.u0Pu.re := wTG4CurrentSource_INIT.u0Pu.re;
  BESS.u0Pu.im := wTG4CurrentSource_INIT.u0Pu.im;
  BESS.uInj0Pu.re := wTG4CurrentSource_INIT.uInj0Pu.re;
  BESS.uInj0Pu.im := wTG4CurrentSource_INIT.uInj0Pu.im;
  BESS.uConv0Pu.re := wTG4CurrentSource_INIT.uConv0Pu.re;
  BESS.uConv0Pu.im := wTG4CurrentSource_INIT.uConv0Pu.im;
  BESS.uPcc0Pu.re := wTG4CurrentSource_INIT.uPcc0Pu.re;
  BESS.uPcc0Pu.im := wTG4CurrentSource_INIT.uPcc0Pu.im;
  BESS.PConv0Pu := wTG4CurrentSource_INIT.PConv0Pu;
  BESS.QConv0Pu := wTG4CurrentSource_INIT.QConv0Pu;

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  BESS.injector.switchOffSignal1.value = false;
  BESS.injector.switchOffSignal2.value = false;
  BESS.injector.switchOffSignal3.value = false;
  connect(omegaRefPu.y, BESS.omegaRefPu) annotation(
    Line(points = {{80, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, BESS.QRefPu) annotation(
    Line(points = {{80, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PFaRef.y, BESS.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(line.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-60, 0}, {-82, 0}}, color = {0, 0, 255}));
  connect(PAuxPu.y, BESS.PAuxPu) annotation(
    Line(points = {{-38, -80}, {12, -80}, {12, -22}}, color = {0, 0, 127}));
  connect(line.terminal2, BESS.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(complexConst.y, BESS.uPccPu) annotation(
    Line(points = {{-38, -50}, {-20, -50}, {-20, -14}, {-2, -14}}, color = {85, 170, 255}));
  connect(complexConst.y, BESS.iPccPu) annotation(
    Line(points = {{-38, -50}, {-20, -50}, {-20, -18}, {-2, -18}}, color = {85, 170, 255}));
  connect(const.y, BESS.PPccPu) annotation(
    Line(points = {{-38, -20}, {-30, -20}, {-30, -6}, {-2, -6}}, color = {0, 0, 127}));
  connect(const.y, BESS.QPccPu) annotation(
    Line(points = {{-38, -20}, {-30, -20}, {-30, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(PRef.y, BESS.PRefPu) annotation(
    Line(points = {{80, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(URef.y, BESS.URefPu) annotation(
    Line(points = {{80, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-05, Interval = 0.001),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"),
  Documentation(info = "<html><head></head><body>
  <figure>This example and the data are inspired by the article [P. <span style=\"text-decoration: underline;\">Pourbeik</span> and J. K. <span style=\"text-decoration: underline;\">Petter</span>, <span style=\"text-decoration: underline;\">“Modeling</span> and validation <span style=\"text-decoration: underline;\">of</span> <span style=\"text-decoration: underline;\">battery</span> <span style=\"text-decoration: underline;\">energy</span> <span style=\"text-decoration: underline;\">storage</span> <span style=\"text-decoration: underline;\">systems&nbsp;</span><span style=\"text-decoration: underline;\">using</span> simple <span style=\"text-decoration: underline;\">generic</span> <span style=\"text-decoration: underline;\">models</span> for <span style=\"text-decoration: underline;\">power</span> system <span style=\"text-decoration: underline;\">stability</span> <span style=\"text-decoration: underline;\">studies”</span>, <span style=\"text-decoration: underline;\">CIGRE</span> Science and Engineering, <span style=\"text-decoration: underline;\">October</span> 2017, pp. 63-72.]</figure><figure>At initial time, the active power demanded by the battery is 0.5 pu (base SNom = 6MVA) and the reactive power is 0 pu (base SNom = 6MVA).</figure><figure>The BESS is able to discharge since the initial state of charge SOC0Pu = 0.5 is between the accepted range [SOCMinPu = 0.2 , SOCMaxPu = 0.8]. Since the simulation is only for 3 s, and the discharge time is considered much longer, the state of charge SOCPu is considered constant all along the simulation time.</figure><figure>At t = 1 s, a fault at the infinite bus is simulated and it can be seen that the BESS starts injecting reactive power until the fault is cleared at t = 1.5 s.</figure><figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/PInjPuSn.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/QInjPuSn.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/UPu.png\">
  </figure>
</body></html>"));
end BESSCurrentSource;
