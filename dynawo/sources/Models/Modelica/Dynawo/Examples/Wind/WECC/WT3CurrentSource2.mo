within Dynawo.Examples.Wind.WECC;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model WT3CurrentSource2 "WECC Wind Type 3 Model on infinite bus"
  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(
    U0Pu = 1,
    UEvtPu = 0.6,
    UPhase = 0,
    omega0Pu = 1,
    omegaEvtPu = 1.01,
    tOmegaEvtEnd = 6.5,
    tOmegaEvtStart = 6,
    tUEvtEnd = 2,
    tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(
    RPu = 0,
    XPu = 0.0000020661,
    BPu = 0,
    GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Wind.WECC.WT3CurrentSource2 WT3(
    ConverterLVControl = false,
    DPMaxPu = 2,
    DPMinPu = -2,
    Dbd1Pu = -0.05,
    Dbd2Pu = 0.05,
    Dshaft = 1.5,
    Hg = 1,
    Ht = 5,
    IMaxPu = 1.3,
    IqFrzPu = 0.1,
    Iqh1Pu = 1.1,
    Iql1Pu = -1.1,
    IqrMaxPu = 20,
    IqrMinPu = -20,
    Ka = 0.007,
    Kcc = 0,
    Kic = 0.1,
    Kip = 10,
    KiPLL = 20,
    Kiw = 0.1,
    Kpc = 2,
    Kpp = 2,
    KpPLL = 3,
    Kpw = 3,
    Kqi = 0.7,
    Kqp = 1,
    Kqv = 2,
    Kshaft = 200,
    Kvi = 0.7,
    Kvp = 1,
    Lvplsw = false,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    P1 = 0,
    Spd1 = 0,
    P2 = 10,
    Spd2 = 10,
    P3 = 20,
    Spd3 = 20,
    P4 = 30,
    Spd4 = 30,
    PFlag = true,
    Pm0Pu = 0.7,
    PMaxREECPu = 1,
    PMinREECPu = 0,
    PQFlag = false,
    PfFlag = false,
    QFlag = true,
    QMaxREECPu = 0.4,
    QMinREECPu = -0.4,
    RLvTrPu = 0,
    RrpwrPu = 10,
    SNom = 100,
    TeMaxPu = 1.5,
    TeMinPu = 0,
    TFlag = true,
    ThetaCMax = 30,
    ThetaCMin = -5,
    ThetaMax = 35,
    ThetaMin = -5,
    ThetaRMax = 10,
    ThetaRMin = -10,
    ThetaWMax = 30,
    ThetaWMin = -5,
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
    XLvTrPu = 0.15,
    brkpt = 0.1,
    lvpl1 = 1.22,
    s0Pu = Complex(-0.7, -0.2),
    tFilterGC = 0.02,
    tG = 0.02,
    tHoldIpMax = 0,
    tHoldIq = 0.1,
    tIq = 0.01,
    tOmegaRef = 60,
    tpREEC = 0.05,
    tpWTGQa = 0.05,
    tPord = 0.01,
    tRv = 0.01,
    tTheta = 0.3,
    u0Pu = Complex(1, 0),
    zerox = 0.05,
    UConv0Pu(fixed = false),
    uConv0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu(im(fixed = false), re(fixed = false)),
    i0Pu(im(fixed = false), re(fixed = false)),
    iConv0Pu(im(fixed = false), re(fixed = false)),
    UInj0Pu(fixed = false),
    QInj0Pu(fixed = false),
    QConv0Pu(fixed = false),
    PInj0Pu(fixed = false),
    PConv0Pu(fixed = false),
    UPhaseConv0(fixed = false),
    PF0(fixed = false),
    Id0Pu(fixed = false),
    Iq0Pu(fixed = false),
    UPhase0 = 1.4461e-06,
    omegaRefWTGQPu0(fixed = false)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PConvRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QConvRefPu(k = 0.2) annotation(
    Placement(transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WT3.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRef(k = 1) annotation(
    Placement(transformation(origin = {90, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = WT3.Pm0Pu) annotation(
    Placement(transformation(origin = {90, 80}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));

  // Initialization
  Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCInverterCurrentSource_INIT weccInverterCurrentSource_INIT(
    ConverterLVControl = WT3.ConverterLVControl,
    P0Pu = WT3.s0Pu.re,
    Q0Pu = WT3.s0Pu.im,
    RLvTrPu = WT3.RLvTrPu,
    SNom = WT3.SNom,
    U0Pu = Modelica.ComplexMath.'abs'(WT3.u0Pu),
    UPhase0 = WT3.UPhase0,
    XLvTrPu = WT3.XLvTrPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  WT3.Id0Pu := weccInverterCurrentSource_INIT.Id0Pu;
  WT3.Iq0Pu := weccInverterCurrentSource_INIT.Iq0Pu;
  WT3.PF0 := weccInverterCurrentSource_INIT.PF0;
  WT3.PInj0Pu := weccInverterCurrentSource_INIT.PInj0Pu;
  WT3.QInj0Pu := weccInverterCurrentSource_INIT.QInj0Pu;
  WT3.UInj0Pu := weccInverterCurrentSource_INIT.UInj0Pu;
  WT3.i0Pu.re := weccInverterCurrentSource_INIT.i0Pu.re;
  WT3.i0Pu.im := weccInverterCurrentSource_INIT.i0Pu.im;
  WT3.uInj0Pu.re := weccInverterCurrentSource_INIT.uInj0Pu.re;
  WT3.uInj0Pu.im := weccInverterCurrentSource_INIT.uInj0Pu.im;
  WT3.omegaRefWTGQPu0 := weccInverterCurrentSource_INIT.omegaRefWTGQPu0;
  WT3.iConv0Pu.re := weccInverterCurrentSource_INIT.iConv0Pu.re;
  WT3.iConv0Pu.im := weccInverterCurrentSource_INIT.iConv0Pu.im;
  WT3.UConv0Pu := weccInverterCurrentSource_INIT.UConv0Pu;
  WT3.uConv0Pu.re := weccInverterCurrentSource_INIT.uConv0Pu.re;
  WT3.uConv0Pu.im := weccInverterCurrentSource_INIT.uConv0Pu.im;
  WT3.PConv0Pu := weccInverterCurrentSource_INIT.PConv0Pu;
  WT3.QConv0Pu := weccInverterCurrentSource_INIT.QConv0Pu;
  WT3.UPhaseConv0 := weccInverterCurrentSource_INIT.UPhaseConv0;

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  WT3.injector.switchOffSignal1 = false;
  WT3.injector.switchOffSignal2 = false;
  WT3.injector.switchOffSignal3 = false;

  connect(line.terminal2, WT3.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-80, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(PConvRefPu.y, WT3.PConvRefPu) annotation(
    Line(points = {{79, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(QConvRefPu.y, WT3.QConvRefPu) annotation(
    Line(points = {{79, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PFaRef.y, WT3.PFaRef) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(omegaRef.y, WT3.omegaRefPu) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(PmRefPu.y, WT3.PmRefPu) annotation(
    Line(points = {{80, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 3 in response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></figure><figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WT3CurrentSource2_PInjPu.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WT3CurrentSource2_QInjPu.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WT3CurrentSource2_UPu.png\">
    </figure></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10", variableFilter = ".*"));
end WT3CurrentSource2;
