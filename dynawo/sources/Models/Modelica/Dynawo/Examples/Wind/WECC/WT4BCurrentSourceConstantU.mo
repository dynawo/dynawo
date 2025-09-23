within Dynawo.Examples.Wind.WECC;

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

model WT4BCurrentSourceConstantU "WECC Wind Type 4B Model on infinite bus"
  extends Icons.Example;
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 2, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Wind.WECC.WT4BCurrentSource WT4B(
    ConverterLVControl = false,
    DPMaxPu = 2,
    DPMinPu = -2,
    Dbd1Pu = -0.05,
    Dbd2Pu = 0.05,
    IMaxPu = 1.3,
    Id0Pu(fixed = false),
    Iq0Pu(fixed = false),
    IqFrzPu = 0.1,
    Iqh1Pu = 1.1,
    Iql1Pu = -1.1,
    IqrMaxPu = 20,
    IqrMinPu = -20,
    KiPLL = 20,
    KpPLL = 3,
    Kqi = 0.7,
    Kqp = 2,
    Kqv = 2,
    Kvi = 0.7,
    Kvp = 2,
    Lvplsw = false,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    PConv0Pu(fixed = false),
    PF0(fixed = false),
    PFlag = false,
    PInj0Pu(fixed = false),
    PMaxPu = 1,
    PMinPu = 0,
    PQFlag = false,
    PfFlag = false,
    QConv0Pu(fixed = false),
    QFlag = true,
    QInj0Pu(fixed = false),
    QMaxPu = 0.4,
    QMinPu = -0.4,
    RLvTrPu = 0.015,
    RrpwrPu = 10,
    SNom = 100,
    UInj0Pu(fixed = false),
    UPhase0 = 0,
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
    VFlag = false,
    VMaxPu = 1.1,
    VMinPu = 0.9,
    VRef0Pu = 0,
    VRef1Pu = 0,
    VUpPu = 1.1,
    XLvTrPu = 0.06,
    brkpt = 0.1,
    i0Pu(im(fixed = false), re(fixed = false)),
    iConv0Pu(im(fixed = false), re(fixed = false)),
    lvpl1 = 1.22,
    s0Pu = Complex(-0.7, -0.2),
    tFilterGC = 0.02,
    tG = 0.02,
    tHoldIpMax = 0,
    tHoldIq = 0.1,
    tIq = 0.01,
    tP = 0.05,
    tPord = 0.01,
    tRv = 0.01,
    u0Pu = Complex(1, 0),
    uConv0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu(im(fixed = false), re(fixed = false)),
    zerox = 0.05) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  Modelica.Blocks.Sources.Constant PRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WT4B.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

  // Initialization
  Dynawo.Electrical.Wind.WECC.WT4CurrentSource_INIT wt4CurrentSource_INIT(
    ConverterLVControl = WT4B.ConverterLVControl,
    P0Pu = WT4B.s0Pu.re,
    Q0Pu = WT4B.s0Pu.im,
    RLvTrPu = WT4B.RLvTrPu,
    SNom = WT4B.SNom,
    U0Pu = Modelica.ComplexMath.'abs'(WT4B.u0Pu),
    UPhase0 = WT4B.UPhase0,
    XLvTrPu = WT4B.XLvTrPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  WT4B.Id0Pu := wt4CurrentSource_INIT.Id0Pu;
  WT4B.Iq0Pu := wt4CurrentSource_INIT.Iq0Pu;
  WT4B.PF0 := wt4CurrentSource_INIT.PF0;
  WT4B.PInj0Pu := wt4CurrentSource_INIT.PInj0Pu;
  WT4B.QInj0Pu := wt4CurrentSource_INIT.QInj0Pu;
  WT4B.UInj0Pu := wt4CurrentSource_INIT.UInj0Pu;
  WT4B.i0Pu.re := wt4CurrentSource_INIT.i0Pu.re;
  WT4B.i0Pu.im := wt4CurrentSource_INIT.i0Pu.im;
  WT4B.uInj0Pu.re := wt4CurrentSource_INIT.uInj0Pu.re;
  WT4B.uInj0Pu.im := wt4CurrentSource_INIT.uInj0Pu.im;
  WT4B.iConv0Pu.re := wt4CurrentSource_INIT.iConv0Pu.re;
  WT4B.iConv0Pu.im := wt4CurrentSource_INIT.iConv0Pu.im;
  WT4B.uConv0Pu.re := wt4CurrentSource_INIT.uConv0Pu.re;
  WT4B.uConv0Pu.im := wt4CurrentSource_INIT.uConv0Pu.im;
  WT4B.PConv0Pu := wt4CurrentSource_INIT.PConv0Pu;
  WT4B.QConv0Pu := wt4CurrentSource_INIT.QConv0Pu;

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  WT4B.injector.switchOffSignal1.value = false;
  WT4B.injector.switchOffSignal2.value = false;
  WT4B.injector.switchOffSignal3.value = false;
  connect(PFaRef.y, WT4B.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(WT4B.terminal, line.terminal2) annotation(
    Line(points = {{0, 0}, {-20, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-60, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(URefPu.y, WT4B.QConvRefPu) annotation(
    Line(points = {{80, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(PRefPu.y, WT4B.PConvRefPu) annotation(
    Line(points = {{80, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 4A park in response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></figure><figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/PInjPuWT4BCurrentSource.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/QInjPuWT4BCurrentSource.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/UPuWT4BCurrentSource.png\">
    </figure></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end WT4BCurrentSourceConstantU;
