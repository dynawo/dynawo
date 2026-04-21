within Dynawo.Examples.Wind.WECC;

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

model WPP4ACurrentSource "WECC Wind Type 4A Model (including the plant controller) - WPP4B - on infinite bus"
  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(
    U0Pu = 1,
    UEvtPu = 0.6,
    UPhase = 0,
    omega0Pu = 1,
    omegaEvtPu = 1.01,
    tOmegaEvtEnd = 26.5,
    tOmegaEvtStart = 26,
    tUEvtEnd = 2,
    tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(
    RPu = 0,
    XPu = 0.0000020661,
    BPu = 0,
    GPu = 0) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Wind.WECC.WPP4ACurrentSource2 WPP4A(
    ConverterLVControl = true,
    DDn = 20,
    DPMaxPu = 2,
    DPMinPu = -2,
    DUp = 0.001,
    Dbd1Pu = -0.05,
    Dbd2Pu = 0.05,
    DbdPu = 0.01,
    Dshaft = 1.5,
    EMaxPu = 0.5,
    EMinPu = -0.5,
    FDbd1Pu = 0.004,
    FDbd2Pu = 1,
    FEMaxPu = 999,
    FEMinPu = -999,
    FreqFlag = true,
    Hg = 1,
    Ht = 5,
    IMaxPu = 1.3,
    IqFrzPu = 0,
    Iqh1Pu = 1.1,
    Iql1Pu = -1.1,
    IqrMaxPu = 20,
    IqrMinPu = -20,
    Kc = 0,
    Ki = 1.5,
    KiPLL = 20,
    Kig = 2.36,
    Kp = 0.1,
    KpPLL = 3,
    Kpg = 0.05,
    Kqi = 0.7,
    Kqp = 1,
    Kqv = 2,
    Kshaft = 200,
    Kvi = 0.7,
    Kvp = 1,
    Lvplsw = false,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    P0Pu = -0.7,
    PFlag = true,
    PMaxREECPu = 1,
    PMaxREPCPu = 1,
    PMinREECPu = 0,
    PMinREPCPu = 0,
    PPCLocal = true,
    PQFlag = false,
    PfFlag = false,
    Q0Pu = -0.2,
    QFlag = true,
    QMaxREECPu = 0.4,
    QMaxREPCPu = 0.4,
    QMinREECPu = -0.4,
    QMinREPCPu = -0.4,
    RefFlag = true,
    RrpwrPu = 10,
    SNom = 100,
    U0Pu = 1,
    VCompFlag = false,
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
    VFrz = 0,
    VMaxPu = 1.1,
    VMinPu = 0.9,
    VRef0Pu = 0,
    VRef1Pu = 0,
    VUpPu = 1.1,
    brkpt = 0.1,
    lvpl1 = 1.22,
    tFilterGC = 0.02,
    tFilterPC = 0.04,
    tFt = 1e-10,
    tFv = 0.1,
    tG = 0.02,
    tHoldIpMax = 0.1,
    tHoldIq = 0,
    tIq = 0.01,
    tLag = 0.1,
    tpWTGTb = 0.5,
    tpREEC = 0.05,
    tpREPC = 0.05,
    tPord = 0.01,
    tRv = 0.01,
    zerox = 0.05,
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
    s0Pu(im(fixed = false), re(fixed = false)),
    u0Pu(im(fixed = false), re(fixed = false)),
    UConv0Pu(fixed = false),
    uConv0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu(im(fixed = false), re(fixed = false)),
    uPcc0Pu(im(fixed = false), re(fixed = false)),
    RMvHvPu = 0,
    XMvHvPu = 0.15,
    RLvTrPu = 0,
    XLvTrPu = 0,
    UPhase0 = 0,
    omegaRefWTGQPu0(fixed = false)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = WPP4A.PControl0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = WPP4A.QControl0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = WPP4A.wecc_repc.URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WPP4A.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initialization
  Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCPlantCurrentSource_INIT weccPlantCurrentSource_INIT(
    BMvHvPu = WPP4A.BMvHvPu,
    ConverterLVControl = WPP4A.ConverterLVControl,
    GMvHvPu = WPP4A.GMvHvPu,
    P0Pu = WPP4A.P0Pu,
    PPCLocal = WPP4A.PPCLocal,
    PPcc0Pu = WPP4A.PPcc0Pu,
    Q0Pu = WPP4A.Q0Pu,
    QPcc0Pu = WPP4A.QPcc0Pu,
    RLvTrPu = WPP4A.RLvTrPu,
    RMvHvPu = WPP4A.RMvHvPu,
    SNom = WPP4A.SNom,
    U0Pu = WPP4A.U0Pu,
    UPcc0Pu = WPP4A.UPcc0Pu,
    UPhase0 = WPP4A.UPhase0,
    XLvTrPu = WPP4A.XLvTrPu,
    XMvHvPu = WPP4A.XMvHvPu,
    rTfoPu = WPP4A.rTfoPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  WPP4A.Id0Pu := weccPlantCurrentSource_INIT.Id0Pu;
  WPP4A.Iq0Pu := weccPlantCurrentSource_INIT.Iq0Pu;
  WPP4A.PF0 := weccPlantCurrentSource_INIT.PF0;
  WPP4A.PInj0Pu := weccPlantCurrentSource_INIT.PInj0Pu;
  WPP4A.QInj0Pu := weccPlantCurrentSource_INIT.QInj0Pu;
  WPP4A.UInj0Pu := weccPlantCurrentSource_INIT.UInj0Pu;
  WPP4A.i0Pu.re := weccPlantCurrentSource_INIT.i0Pu.re;
  WPP4A.i0Pu.im := weccPlantCurrentSource_INIT.i0Pu.im;
  WPP4A.iConv0Pu.re := weccPlantCurrentSource_INIT.iConv0Pu.re;
  WPP4A.iConv0Pu.im := weccPlantCurrentSource_INIT.iConv0Pu.im;
  WPP4A.s0Pu.re := weccPlantCurrentSource_INIT.s0Pu.re;
  WPP4A.s0Pu.im := weccPlantCurrentSource_INIT.s0Pu.im;
  WPP4A.u0Pu.re := weccPlantCurrentSource_INIT.u0Pu.re;
  WPP4A.u0Pu.im := weccPlantCurrentSource_INIT.u0Pu.im;
  WPP4A.uInj0Pu.re := weccPlantCurrentSource_INIT.uInj0Pu.re;
  WPP4A.uInj0Pu.im := weccPlantCurrentSource_INIT.uInj0Pu.im;
  WPP4A.UConv0Pu := weccPlantCurrentSource_INIT.UConv0Pu;
  WPP4A.uConv0Pu.re := weccPlantCurrentSource_INIT.uConv0Pu.re;
  WPP4A.uConv0Pu.im := weccPlantCurrentSource_INIT.uConv0Pu.im;
  WPP4A.uPcc0Pu.re := weccPlantCurrentSource_INIT.uPcc0Pu.re;
  WPP4A.uPcc0Pu.im := weccPlantCurrentSource_INIT.uPcc0Pu.im;
  WPP4A.PConv0Pu := weccPlantCurrentSource_INIT.PConv0Pu;
  WPP4A.QConv0Pu := weccPlantCurrentSource_INIT.QConv0Pu;
  WPP4A.UPhaseConv0 := weccPlantCurrentSource_INIT.UPhaseConv0;
  WPP4A.omegaRefWTGQPu0 := weccPlantCurrentSource_INIT.omegaRefWTGQPu0;

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  WPP4A.injector.switchOffSignal1 = false;
  WPP4A.injector.switchOffSignal2 = false;
  WPP4A.injector.switchOffSignal3 = false;

  connect(line.terminal2, WPP4A.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-80, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, WPP4A.omegaRefPu) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, WPP4A.QRefPu) annotation(
    Line(points = {{79, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PRefPu.y, WPP4A.PRefPu) annotation(
    Line(points = {{79, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(URefPu.y, WPP4A.URefPu) annotation(
    Line(points = {{79, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(PFaRef.y, WPP4A.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(const.y, WPP4A.PPccPu) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -6}, {-2, -6}}, color = {0, 0, 127}));
  connect(const.y, WPP4A.QPccPu) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(complexConst.y, WPP4A.uPccPu) annotation(
    Line(points = {{-38, -80}, {-10, -80}, {-10, -14}, {-2, -14}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 0.0001, Interval = 0.0001),
    Documentation(info = "<html><head></head><body><!--StartFragment-->This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 4A park in response to a voltage and frequency variation at its terminal.<br data-start=\"530\" data-end=\"533\">
    In this improved version, the type A drive train model with constant mechanical power (Pm) is replaced by the type B model (WTGT_B), a two-mass equivalent model including a lag block between electrical power (Pe) and mechanical power (Pm). This lag mimics the effect of pitch control after disturbances, allowing Pm to adapt and preventing steady-state errors in Pe without modeling the full pitch control loop. &nbsp;&nbsp;<span style=\"font-size: 12px;\"><br><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></span></figure><figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WPP4ACurrentSource_PInjPu.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WPP4ACurrentSource_QInjPu.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WPP4ACurrentSource_UPu.png\">
    </figure></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10", variableFilter = ".*"));
end WPP4ACurrentSource;
