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

model WT4ACurrentSource "WECC Wind Type 4A Model on infinite bus"
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
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Wind.WECC.WT4ACurrentSource WT4A(
    DPMaxPu = 2,
    DPMinPu = -2,
    Dbd1Pu = -0.05,
    Dbd2Pu = 0.05,
    Dshaft = 1.5,
    Hg = 1,
    Ht = 5,
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
    Kqp = 1,
    Kqv = 2,
    Kshaft = 200,
    Kvi = 0.7,
    Kvp = 1,
    Lvplsw = false,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    PF0(fixed = false),
    PFlag = true,
    PInj0Pu(fixed = false),
    PMaxPu = 1,
    PMinPu = 0,
    PQFlag = false,
    PfFlag = false,
    QFlag = true,
    QInj0Pu(fixed = false),
    QMaxPu = 0.4,
    QMinPu = -0.4,
    RPu = 0,
    RrpwrPu = 10,
    SNom = 100,
    UInj0Pu(fixed = false),
    UPhaseInj0(fixed = false),
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
    XPu = 0.15,
    brkpt = 0.1,
    i0Pu( im(fixed = false),re(fixed = false)),
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
    uInj0Pu( im(fixed = false),re(fixed = false)),
    zerox = 0.05) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  Modelica.Blocks.Sources.Constant PInjRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QInjRefPu(k = 0.2) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WT4A.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

  // Initialization
  Dynawo.Electrical.Wind.WECC.WT4CurrentSource_INIT wt4CurrentSource_INIT(
    P0Pu = WT4A.s0Pu.re,
    Q0Pu = WT4A.s0Pu.im,
    RPu = WT4A.RPu,
    SNom = WT4A.SNom,
    U0Pu = Modelica.ComplexMath.'abs'(WT4A.u0Pu),
    UPhase0 = 1.4461e-06,
    XPu = WT4A.XPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  WT4A.Id0Pu := wt4CurrentSource_INIT.Id0Pu;
  WT4A.Iq0Pu := wt4CurrentSource_INIT.Iq0Pu;
  WT4A.PF0 := wt4CurrentSource_INIT.PF0;
  WT4A.PInj0Pu := wt4CurrentSource_INIT.PInj0Pu;
  WT4A.QInj0Pu := wt4CurrentSource_INIT.QInj0Pu;
  WT4A.UInj0Pu := wt4CurrentSource_INIT.UInj0Pu;
  WT4A.UPhaseInj0 := wt4CurrentSource_INIT.UPhaseInj0;
  WT4A.i0Pu.re := wt4CurrentSource_INIT.i0Pu.re;
  WT4A.i0Pu.im := wt4CurrentSource_INIT.i0Pu.im;
  WT4A.uInj0Pu.re := wt4CurrentSource_INIT.uInj0Pu.re;
  WT4A.uInj0Pu.im := wt4CurrentSource_INIT.uInj0Pu.im;

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  WT4A.injector.switchOffSignal1.value = false;
  WT4A.injector.switchOffSignal2.value = false;
  WT4A.injector.switchOffSignal3.value = false;

  connect(line.terminal2, WT4A.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(PInjRefPu.y, WT4A.PInjRefPu) annotation(
    Line(points = {{79, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(QInjRefPu.y, WT4A.QInjRefPu) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(PFaRef.y, WT4A.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 4A park in response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></figure><figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/PInjPuWT4ACurrentSource.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/QInjPuWT4ACurrentSource.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/UPuWT4ACurrentSource.png\">
    </figure></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end WT4ACurrentSource;
