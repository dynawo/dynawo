within Dynawo.Examples.Wind.WECC;

model WT3CurrentSource1 "WECC Wind Type 4A Model on infinite bus"
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
  extends Modelica.Icons.Example;
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.6, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 2, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PConvRefPu(k = WT3.PConv0Pu) annotation(
    Placement(transformation(origin = {90, -20}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QConvRefPu(k = WT3.QConv0Pu) annotation(
    Placement(transformation(origin = {90, 12}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WT3.PF0)) annotation(
    Placement(transformation(origin = {10, -60}, extent = {{10, 10}, {-10, -10}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant omegaRef(k = 1) annotation(
    Placement(transformation(origin = {90, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Initialization
  Electrical.Wind.WECC.WT4CurrentSource_INIT wt4CurrentSource_INIT(ConverterLVControl = WT3.ConverterLVControl, P0Pu = WT3.s0Pu.re, PPCLocal = true, Q0Pu = WT3.s0Pu.im, RLvTrPu = WT3.RLvTrPu, SNom = WT3.SNom, U0Pu = Modelica.ComplexMath.'abs'(WT3.u0Pu), UPhase0 = WT3.UPhase0, XLvTrPu = WT3.XLvTrPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Wind.WECC.WT3CurrentSource1 WT3(
    ConverterLVControl = true,
    DPMaxPu = 2,
    DPMinPu = -2,
    Dshaft = 2.7,
    Hg = 0.5,
    Ht = 6,
    IMaxPu = 1.3,
    IqFrzPu = 0,
    Iqh1Pu = 1.1,
    Iql1Pu = -1.1,
    IqrMaxPu = 20,
    IqrMinPu = -20,
    KiPLL = 20,
    KpPLL = 3,
    Kqi = 0.7,
    Kqp = 1,
    Kqv = 2,
    Kshaft = 15,
    Kvi = 0.7,
    Kvp = 1,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    PFlag = false,
    PMaxPu = 1,
    PMinPu = 0,
    PQFlag = false,
    PfFlag = false,
    QFlag = true,
    QMaxPu = 0.4,
    QMinPu = -0.4,
    RrpwrPu = 10,
    SNom = 100,
    VDLIp11 = 1.1,
    VDLIp12 = 1.1,
    VDLIp21 = 1.15,
    VDLIp22 = 1,
    VDLIp31 = 1.16,
    VDLIp32 = 1,
    VDLIp41 = 1.17,
    VDLIp42 = 1,
    VDLIq11 = 1.1,
    VDLIq12 = 1.1,
    VDLIq21 = 1.15,
    VDLIq22 = 1,
    VDLIq31 = 1.16,
    VDLIq32 = 1,
    VDLIq41 = 1.17,
    VDLIq42 = 1,
    VDipPu = 0.9,
    VFlag = true,
    VMaxPu = 1.1,
    VMinPu = 0.9,
    VRef0Pu = 0,
    VRef1Pu = 0,
    VUpPu = 1.1,
    tFilterGC = 0.02,
    tG = 0.02,
    tHoldIpMax = 0.1,
    tHoldIq = 0,
    tIq = 0.01,
    tP = 0.05,
    tPord = 0.01,
    tRv = 0.01,
    Kip = 10,
    Kpp = 2,
    P1 = 0,
    Spd1 = 0,
    P2 = 10,
    Spd2 = 10,
    P3 = 20,
    Spd3 = 20,
    P4 = 30,
    Spd4 = 30,
    Kiw = 0.1,
    Kpw = 3,
    Kic = 0.1,
    Kpc = 2,
    Kcc = 0,
    ThetaMax = 35,
    ThetaMin = -5,
    ThetaRMax = 10,
    ThetaRMin = -10,
    tOmegaRef = 60,
    TeMaxPu = 1.5,
    TeMinPu = 0,
    TFlag = true,
    Ka = 0.007,
    Pm0Pu(fixed=false),
    brkpt = 0.1,
    zerox = 0.05,
    Lvplsw = false,
    lvpl1 = 1.22,
    omegaRefWTGQPu0(fixed = false),
    tTheta = 0.3,
    Id0Pu(fixed = false),
    Iq0Pu(fixed = false),
    PConv0Pu(fixed = false),
    UPhaseConv0(fixed = false),
    PF0(fixed = false),
    PInj0Pu(fixed = false),
    QConv0Pu(fixed = false),
    QInj0Pu(fixed = false),
    UInj0Pu(fixed = false),
    i0Pu(im(fixed = false), re(fixed = false)),
    iConv0Pu(im(fixed = false), re(fixed = false)),
    s0Pu= Complex(-0.7, -0.2),
    u0Pu= Complex(1, 0),
    UConv0Pu(fixed = false),
    uConv0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu(im(fixed = false), re(fixed = false)),
    RLvTrPu = 0,
    XLvTrPu = 0, Dbd1Pu = -0.01, Dbd2Pu = 0.01, UPhase0 = 0) annotation(
    Placement(transformation(origin = {40, 0}, extent = {{20, 20}, {-20, -20}}, rotation = -0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = WT3.PConv0Pu) annotation(
    Placement(transformation(origin = {-30, 80}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
initial algorithm
  WT3.Id0Pu := wt4CurrentSource_INIT.Id0Pu;
  WT3.Iq0Pu := wt4CurrentSource_INIT.Iq0Pu;
  WT3.PF0 := wt4CurrentSource_INIT.PF0;
  WT3.PInj0Pu := wt4CurrentSource_INIT.PInj0Pu;
  WT3.QInj0Pu := wt4CurrentSource_INIT.QInj0Pu;
  WT3.UInj0Pu := wt4CurrentSource_INIT.UInj0Pu;
  WT3.i0Pu.re := wt4CurrentSource_INIT.i0Pu.re;
  WT3.i0Pu.im := wt4CurrentSource_INIT.i0Pu.im;
  WT3.uInj0Pu.re := wt4CurrentSource_INIT.uInj0Pu.re;
  WT3.uInj0Pu.im := wt4CurrentSource_INIT.uInj0Pu.im;
  WT3.omegaRefWTGQPu0 := wt4CurrentSource_INIT.omegaRefWTGQPu0;
  WT3.iConv0Pu.re := wt4CurrentSource_INIT.iConv0Pu.re;
  WT3.iConv0Pu.im := wt4CurrentSource_INIT.iConv0Pu.im;
  WT3.UConv0Pu := wt4CurrentSource_INIT.UConv0Pu;
  WT3.uConv0Pu.re := wt4CurrentSource_INIT.uConv0Pu.re;
  WT3.uConv0Pu.im := wt4CurrentSource_INIT.uConv0Pu.im;
  WT3.PConv0Pu := wt4CurrentSource_INIT.PConv0Pu;
  WT3.QConv0Pu := wt4CurrentSource_INIT.QConv0Pu;
  WT3.UPhaseConv0 := wt4CurrentSource_INIT.UPhaseConv0;
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  WT3.injector.switchOffSignal1.value = false;
  WT3.injector.switchOffSignal2.value = false;
  WT3.injector.switchOffSignal3.value = false;
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-80, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(PmRefPu.y, WT3.PmRefPu) annotation(
    Line(points = {{-18, 80}, {28, 80}, {28, 22}}, color = {0, 0, 127}));
  connect(PFaRef.y, WT3.PFaRef) annotation(
    Line(points = {{21, -60}, {40, -60}, {40, -22}}, color = {0, 0, 127}));
  connect(QConvRefPu.y, WT3.QConvRefPu) annotation(
    Line(points = {{79, 12}, {62, 12}}, color = {0, 0, 127}));
  connect(PConvRefPu.y, WT3.PConvRefPu) annotation(
    Line(points = {{79, -20}, {74, -20}, {74, 0}, {62, 0}}, color = {0, 0, 127}));
  connect(omegaRef.y, WT3.omegaRefPu) annotation(
    Line(points = {{80, -80}, {70, -80}, {70, -12}, {62, -12}}, color = {0, 0, 127}));
  connect(WT3.terminal, line.terminal2) annotation(
    Line(points = {{18, 0}, {-20, 0}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 4A park in response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></figure><figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WT3CurrentSource_PInjPu.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WT3CurrentSource_QInjPu.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WT3CurrentSource_UPu.png\">
    </figure></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10", variableFilter = ".*"));
end WT3CurrentSource1;
