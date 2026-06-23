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

model WPP4BCurrentSourceExternalPCS "WECC Wind Type 4B Model (including a plant controller and an external power collection system) - WPP4B - on infinite bus"
  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(
    U0Pu = 0.9906184368094055,
    UEvtPu = 0.6,
    UPhase = 0,
    omega0Pu = 1,
    omegaEvtPu = 1.01,
    tOmegaEvtEnd = 17.5,
    tOmegaEvtStart = 17,
    tUEvtEnd = 13,
    tUEvtStart = 12) annotation(
    Placement(visible = true, transformation(origin = {-180, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.1) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WPP4B.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line Zcc(
    BPu = 0,
    GPu = 0,
    RPu = 0,
    XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Utilities.Measurements PCCmeasurements annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio ZPcs(
    BPu = 0,
    GPu = 0,
    RPu = 0.01,
    XPu = 0.15,
    rTfoPu = 0.95) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URef(
    height = 0.02,
    offset = WPP4B.wecc_repc.URef0Pu,
    startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef(
    height = 0.05,
    offset = 0.35,
    startTime = 8) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Wind.WECC.WPP4BCurrentSource WPP4B(
    BMvHvPu = 0,
    ConverterLVControl = true,
    DDn = 20,
    DPMaxPu = 2,
    DPMinPu = -2,
    DUp = 0.001,
    Dbd1Pu = -0.05,
    Dbd2Pu = 0.05,
    DbdPu = 0.0001,
    EMaxPu = 0.5,
    EMinPu = -0.5,
    FDbd1Pu = 0.004,
    FDbd2Pu = 1,
    FEMaxPu = 999,
    FEMinPu = -999,
    FreqFlag = true,
    GMvHvPu = 0,
    IMaxPu = 1.3,
    Id0Pu(fixed = false),
    Iq0Pu(fixed = false),
    IqFrzPu = 0,
    Iqh1Pu = 1.1,
    Iql1Pu = -1.1,
    IqrMaxPu = 20,
    IqrMinPu = -20,
    Kc = 0.2,
    Ki = 7,
    KiPLL = 20,
    Kig = 7,
    Kp = 2,
    KpPLL = 3,
    Kpg = 2,
    Kqi = 10,
    Kqp = 2,
    Kqv = 2,
    Kvi = 10,
    Kvp = 2,
    Lvplsw = false,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    P0Pu = -0.7058725761772852,
    PConv0Pu(fixed = false),
    UPhaseConv0(fixed = false),
    PF0(fixed = false),
    PFlag = true,
    PInj0Pu(fixed = false),
    PMaxREECPu = 1,
    PMaxREPCPu = 1,
    PMinREECPu = 0,
    PMinREPCPu = 0,
    PPCLocal = false,
    PPcc0Pu = -0.7,
    PQFlag = false,
    PfFlag = false,
    Q0Pu = -0.28808864265927975,
    QConv0Pu(fixed = false),
    QFlag = true,
    QInj0Pu(fixed = false),
    QMaxREECPu = 0.5,
    QMaxREPCPu = 0.5,
    QMinREECPu = -0.5,
    QMinREPCPu = -0.5,
    QPcc0Pu = -0.2,
    RLvTrPu = 0.015,
    RMvHvPu = 0,
    RefFlag = true,
    RrpwrPu = 10,
    SNom = 200,
    U0Pu = 0.9948728673356535,
    UInj0Pu(fixed = false),
    UPcc0Pu = 1,
    UPhase0 = 0.14453232453351325,
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
    XLvTrPu = 0.06,
    XMvHvPu = 1e-5,
    brkpt = 0.1,
    i0Pu(im(fixed = false), re(fixed = false)),
    iConv0Pu(im(fixed = false), re(fixed = false)),
    lvpl1 = 1.22,
    s0Pu(im(fixed = false), re(fixed = false)),
    tFilterGC = 0.02,
    tFilterPC = 0.04,
    tFt = 1e-10,
    tFv = 0.1,
    tG = 0.02,
    tHoldIpMax = 0,
    tHoldIq = 0,
    tIq = 0.01,
    tLag = 0.1,
    tpREEC = 0.05,
    tpREPC = 0.05,
    tPord = 0.01,
    tRv = 0.01,
    u0Pu(im(fixed = false), re(fixed = false)),
    UConv0Pu(fixed = false),
    uConv0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu(im(fixed = false), re(fixed = false)),
    uPcc0Pu(im(fixed = false), re(fixed = false)),
    zerox = 0.05,
    omegaRefWTGQPu0(fixed = false)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // Initialization
  Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCPlantCurrentSource_INIT weccPlantCurrentSource_INIT(
    BMvHvPu = WPP4B.BMvHvPu,
    ConverterLVControl = WPP4B.ConverterLVControl,
    GMvHvPu = WPP4B.GMvHvPu,
    P0Pu = WPP4B.P0Pu,
    PPCLocal = WPP4B.PPCLocal,
    PPcc0Pu = WPP4B.PPcc0Pu,
    Q0Pu = WPP4B.Q0Pu,
    QPcc0Pu = WPP4B.QPcc0Pu,
    RLvTrPu = WPP4B.RLvTrPu,
    RMvHvPu = WPP4B.RMvHvPu,
    SNom = WPP4B.SNom,
    U0Pu = WPP4B.U0Pu,
    UPcc0Pu = WPP4B.UPcc0Pu,
    UPhase0 = WPP4B.UPhase0,
    UPhasePcc0 = 0.03533563863002929,
    XLvTrPu = WPP4B.XLvTrPu,
    XMvHvPu = WPP4B.XMvHvPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  WPP4B.Id0Pu := weccPlantCurrentSource_INIT.Id0Pu;
  WPP4B.Iq0Pu := weccPlantCurrentSource_INIT.Iq0Pu;
  WPP4B.PF0 := weccPlantCurrentSource_INIT.PF0;
  WPP4B.PInj0Pu := weccPlantCurrentSource_INIT.PInj0Pu;
  WPP4B.QInj0Pu := weccPlantCurrentSource_INIT.QInj0Pu;
  WPP4B.UInj0Pu := weccPlantCurrentSource_INIT.UInj0Pu;
  WPP4B.i0Pu.re := weccPlantCurrentSource_INIT.i0Pu.re;
  WPP4B.i0Pu.im := weccPlantCurrentSource_INIT.i0Pu.im;
  WPP4B.iConv0Pu.re := weccPlantCurrentSource_INIT.iConv0Pu.re;
  WPP4B.iConv0Pu.im := weccPlantCurrentSource_INIT.iConv0Pu.im;
  WPP4B.s0Pu.re := weccPlantCurrentSource_INIT.s0Pu.re;
  WPP4B.s0Pu.im := weccPlantCurrentSource_INIT.s0Pu.im;
  WPP4B.u0Pu.re := weccPlantCurrentSource_INIT.u0Pu.re;
  WPP4B.u0Pu.im := weccPlantCurrentSource_INIT.u0Pu.im;
  WPP4B.uInj0Pu.re := weccPlantCurrentSource_INIT.uInj0Pu.re;
  WPP4B.uInj0Pu.im := weccPlantCurrentSource_INIT.uInj0Pu.im;
  WPP4B.UConv0Pu := weccPlantCurrentSource_INIT.UConv0Pu;
  WPP4B.uConv0Pu.re := weccPlantCurrentSource_INIT.uConv0Pu.re;
  WPP4B.uConv0Pu.im := weccPlantCurrentSource_INIT.uConv0Pu.im;
  WPP4B.uPcc0Pu.re := weccPlantCurrentSource_INIT.uPcc0Pu.re;
  WPP4B.uPcc0Pu.im := weccPlantCurrentSource_INIT.uPcc0Pu.im;
  WPP4B.PConv0Pu := weccPlantCurrentSource_INIT.PConv0Pu;
  WPP4B.QConv0Pu := weccPlantCurrentSource_INIT.QConv0Pu;
  WPP4B.UPhaseConv0 := weccPlantCurrentSource_INIT.UPhaseConv0;
  WPP4B.omegaRefWTGQPu0 := weccPlantCurrentSource_INIT.omegaRefWTGQPu0;

equation
  ZPcs.switchOffSignal1 = false;
  ZPcs.switchOffSignal2 = false;
  Zcc.switchOffSignal1 = false;
  Zcc.switchOffSignal2 = false;
  WPP4B.injector.switchOffSignal1 = false;
  WPP4B.injector.switchOffSignal2 = false;
  WPP4B.injector.switchOffSignal3 = false;

  connect(infiniteBus.terminal, Zcc.terminal1) annotation(
    Line(points = {{-180, 0}, {-160, 0}}, color = {0, 0, 255}));
  connect(Zcc.terminal2, PCCmeasurements.terminal1) annotation(
    Line(points = {{-120, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(PCCmeasurements.terminal2, ZPcs.terminal1) annotation(
    Line(points = {{-80, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(PRef.y, WPP4B.PRefPu) annotation(
    Line(points = {{80, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(URef.y, WPP4B.URefPu) annotation(
    Line(points = {{80, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(WPP4B.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{42, 12}, {60, 12}, {60, 40}, {79, 40}}, color = {0, 0, 127}));
  connect(ZPcs.terminal2, WPP4B.terminal) annotation(
    Line(points = {{-20, 0}, {-2, 0}}, color = {0, 0, 255}));
  connect(PCCmeasurements.PPu, WPP4B.PPccPu) annotation(
    Line(points = {{-88, -10}, {-88, -24}, {-24, -24}, {-24, -6}, {-2, -6}}, color = {0, 0, 127}));
  connect(PCCmeasurements.QPu, WPP4B.QPccPu) annotation(
    Line(points = {{-86, -10}, {-86, -20}, {-20, -20}, {-20, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(PCCmeasurements.uPu, WPP4B.uPccPu) annotation(
    Line(points = {{-82, -10}, {-82, -14}, {-2, -14}}, color = {85, 170, 255}));
  connect(PFaRef.y, WPP4B.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(QRefPu.y, WPP4B.QRefPu) annotation(
    Line(points = {{79, 0}, {42, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 0.001, Interval = 0.0001),
    Documentation(info = "<html><head></head><body>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WPP4BCurrentSourceExternalPCS_PInjPu.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WPP4BCurrentSourceExternalPCS_QInjPu.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/WPP4BCurrentSourceExternalPCS_UPu.png\">
  </figure>
</body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10", variableFilter = ".*"));
end WPP4BCurrentSourceExternalPCS;
