within Dynawo.Examples.Photovoltaics.WECC;

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

model PVCurrentSource2 "WECC PV Model on infinite bus"
  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(
    U0Pu = 1,
    UEvtPu = 0.5,
    UPhase = 0,
    omega0Pu = 1,
    omegaEvtPu = 1.01,
    tOmegaEvtEnd = 16.5,
    tOmegaEvtStart = 16,
    tUEvtEnd = 8,
    tUEvtStart = 4) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(
    RPu = 0,
    XPu = 0.0000020661,
    BPu = 0,
    GPu = 0) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSource2 PV(
    ConverterLVControl = true,
    DDn = 20,
    DPMaxPu = 999,
    DPMinPu = -999,
    DUp = 0.001,
    Dbd1Pu = -0.1,
    Dbd2Pu = 0.1,
    DbdPu = 0.01,
    EMaxPu = 999,
    EMinPu = -999,
    FDbd1Pu = 0.004,
    FDbd2Pu = 1,
    FEMaxPu = 999,
    FEMinPu = -999,
    FreqFlag = true,
    IMaxPu = 1.05,
    Iqh1Pu = 2,
    Iql1Pu = -2,
    IqrMaxPu = 20,
    IqrMinPu = -20,
    Kc = 0,
    Ki = 1.5,
    KiPLL = 20,
    Kig = 2.36,
    Kp = 0.1,
    KpPLL = 3,
    Kpg = 0.05,
    Kqi = 0.5,
    Kqp = 1,
    Kqv = 2,
    Kvi = 1,
    Kvp = 1,
    Lvplsw = false,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    P0Pu = -0.7,
    PMaxREPCPu = 1,
    PMinREPCPu = 0,
    PPCLocal = true,
    PQFlag = false,
    PfFlag = false,
    Q0Pu = -0.2,
    QFlag = true,
    QMaxREPCPu = 0.4,
    QMinREPCPu = -0.4,
    RLvTrPu = 0,
    RMvHvPu = 0,
    RefFlag = 1,
    RrpwrPu = 10,
    SNom = 100,
    U0Pu = 1,
    VCompFlag = false,
    VDipPu = 0.9,
    VFlag = true,
    VFrz = 0.2,
    VMaxPu = 1.1,
    VMinPu = 0.9,
    VRef0Pu = 1,
    VRef1Pu = 0,
    VUpPu = 1.1,
    XLvTrPu = 0,
    XMvHvPu = 0.15,
    brkpt = 0.1,
    lvpl1 = 1.22,
    tFilterGC = 0.02,
    tFilterPC = 0.04,
    tFt = 1e-10,
    tFv = 0.1,
    tG = 0.02,
    tIq = 0.02,
    tLag = 0.1,
    tpREPC = 0.04,
    tPord = 0.02,
    tRv = 0.02,
    zerox = 0.05,
    DfMaxPu = 999,
    DfMinPu = -999,
    DPrMax = 999,
    DPrMin = -999,
    DQRefMax = 999,
    DQRefMin = -999,
    FfwrdFlag = false,
    PefdFlag = true,
    PfMax = 0.95,
    PfMin = -0.95,
    PiMaxPu = 0.1,
    PiMinPu = -0.1,
    PrMaxPu = 999,
    PrMinPu = -999,
    QRefMaxPu = 999,
    QRefMinPu = -999,
    QVFlag = true,
    QvrMax = 999,
    QvrMin = -999,
    tC = 0.02,
    tFrq = 0.1,
    tFrz = 0,
    UFreqPu = 0.8,
    URefMaxPu = 1.1,
    URefMinPu = 0.9,
//    VDLIp11 = 1.1,
//    VDLIp12 = 1.1,
//    VDLIp21 = 1.15,
//    VDLIp22 = 1,
//    VDLIp31 = 1.16,
//    VDLIp32 = 1,
//    VDLIp41 = 1.17,
//    VDLIp42 = 1,
//    VDLIq11 = 1.1,
//    VDLIq12 = 1.1,
//    VDLIq21 = 1.15,
//    VDLIq22 = 1,
//    VDLIq31 = 1.16,
//    VDLIq32 = 1,
//    VDLIq41 = 1.17,
//    VDLIq42 = 1,
//    IqFrzPu = 0,
//    PFlag = true,
//    tHoldIpMax = 0.1,
//    tHoldIq = 0,
    Id0Pu(fixed = false),
    Iq0Pu(fixed = false),
    PF0(fixed = false),
    PInj0Pu(fixed = false),
    QInj0Pu(fixed = false),
    UInj0Pu(fixed = false),
    i0Pu(im(fixed = false), re(fixed = false)),
    iInj0Pu(im(fixed = false), re(fixed = false)),
    s0Pu(im(fixed = false), re(fixed = false)),
    u0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu(im(fixed = false), re(fixed = false))) annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.7) annotation(
    Placement(transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.2) annotation(
    Placement(transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = PV.URef0Pu) annotation(
    Placement(transformation(origin = {90, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(PV.PF0)) annotation(
    Placement(transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initialization
  Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCPlantCurrentSource_INIT weccPlantCurrentSource_INIT(
    BMvHvPu = PV.BMvHvPu,
    ConverterLVControl = PV.ConverterLVControl,
    GMvHvPu = PV.GMvHvPu,
    P0Pu = PV.P0Pu,
    PPCLocal = PV.PPCLocal,
    PPcc0Pu = PV.PPcc0Pu,
    Q0Pu = PV.Q0Pu,
    QPcc0Pu = PV.QPcc0Pu,
    RLvTrPu = PV.RLvTrPu,
    RMvHvPu = PV.RMvHvPu,
    SNom = PV.SNom,
    U0Pu = PV.U0Pu,
    UPcc0Pu = PV.UPcc0Pu,
    UPhase0 = 0,
    XLvTrPu = PV.XLvTrPu,
    XMvHvPu = PV.XMvHvPu,
    rTfoPu = PV.rTfoPu) annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  PV.Id0Pu := weccPlantCurrentSource_INIT.Id0Pu;
  PV.Iq0Pu := weccPlantCurrentSource_INIT.Iq0Pu;
  PV.PF0 := weccPlantCurrentSource_INIT.PF0;
  PV.PInj0Pu := weccPlantCurrentSource_INIT.PInj0Pu;
  PV.QInj0Pu := weccPlantCurrentSource_INIT.QInj0Pu;
  PV.UInj0Pu := weccPlantCurrentSource_INIT.UInj0Pu;
  PV.i0Pu.re := weccPlantCurrentSource_INIT.i0Pu.re;
  PV.i0Pu.im := weccPlantCurrentSource_INIT.i0Pu.im;
  PV.iConv0Pu.re := weccPlantCurrentSource_INIT.iConv0Pu.re;
  PV.iConv0Pu.im := weccPlantCurrentSource_INIT.iConv0Pu.im;
  PV.s0Pu.re := weccPlantCurrentSource_INIT.s0Pu.re;
  PV.s0Pu.im := weccPlantCurrentSource_INIT.s0Pu.im;
  PV.u0Pu.re := weccPlantCurrentSource_INIT.u0Pu.re;
  PV.u0Pu.im := weccPlantCurrentSource_INIT.u0Pu.im;
  PV.uInj0Pu.re := weccPlantCurrentSource_INIT.uInj0Pu.re;
  PV.uInj0Pu.im := weccPlantCurrentSource_INIT.uInj0Pu.im;
  PV.UConv0Pu := weccPlantCurrentSource_INIT.UConv0Pu;
  PV.uConv0Pu.re := weccPlantCurrentSource_INIT.uConv0Pu.re;
  PV.uConv0Pu.im := weccPlantCurrentSource_INIT.uConv0Pu.im;
  PV.uPcc0Pu.re := weccPlantCurrentSource_INIT.uPcc0Pu.re;
  PV.uPcc0Pu.im := weccPlantCurrentSource_INIT.uPcc0Pu.im;
  PV.PConv0Pu := weccPlantCurrentSource_INIT.PConv0Pu;
  PV.QConv0Pu := weccPlantCurrentSource_INIT.QConv0Pu;
  PV.UPhaseConv0 := weccPlantCurrentSource_INIT.UPhaseConv0;
  PV.UControl0Pu := weccPlantCurrentSource_INIT.UControl0Pu;

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  PV.switchOffSignal1 = false;
  PV.switchOffSignal2 = false;
  PV.switchOffSignal3 = false;

  connect(line.terminal2, PV.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-80, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, PV.omegaRefPu) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, PV.QRefPu) annotation(
    Line(points = {{79, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PRefPu.y, PV.PRefPu) annotation(
    Line(points = {{79, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(URefPu.y, PV.URefPu) annotation(
    Line(points = {{79, 80}, {79, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(PFaRef.y, PV.PFaRef) annotation(
    Line(points = {{79, -80}, {79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(const.y, PV.PPccPu) annotation(
    Line(points = {{-19, 40}, {-10.5, 40}, {-10.5, -6}, {-2, -6}}, color = {0, 0, 127}));
  connect(const.y, PV.QPccPu) annotation(
    Line(points = {{-19, 40}, {-10.5, 40}, {-10.5, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(const.y, PV.PAuxPu) annotation(
    Line(points = {{-19, 40}, {10, 40}, {10, 22}}, color = {0, 0, 127}));
  connect(const.y, PV.UAuxPu) annotation(
    Line(points = {{-19, 40}, {34, 40}, {34, 22}}, color = {0, 0, 127}));
  connect(complexConst.y, PV.uPccPu) annotation(
    Line(points = {{-39, -80}, {-10, -80}, {-10, -14}, {-2, -14}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info ="<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one PV park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 4 s to t = 8 s, and which frequency is increased to 1.01 pu from t = 16 s to t = 16.5 s. This is a way to observe the PV park's response to a voltage and frequency variation at its terminal.
     <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/PPuSnRef_PVCurrentSource2.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/QPuSnRef_PVCurrentSource2.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/UPu_PVCurrentSource2.png\">
  </figure>
        </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
 "),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end PVCurrentSource2;
