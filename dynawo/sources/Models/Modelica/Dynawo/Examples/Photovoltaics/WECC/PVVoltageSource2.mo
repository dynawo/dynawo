within Dynawo.Examples.Photovoltaics.WECC;

model PVVoltageSource2 "WECC PV Vsource Model on infinite bus"
  /*
  * Copyright (c) 2025, RTE (http://www.rte-france.com)
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
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.5, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 16.5, tOmegaEvtStart = 16, tUEvtEnd = 8, tUEvtStart = 4) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.3) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource2 PV(DDn = 20, DPMaxPu = 999, DPMinPu = -999, DUp = 0.001, Dbd1Pu = -0.1, Dbd2Pu = 0.1, DbdPu = 0.01, EMaxPu = 999, EMinPu = -999, FDbd1Pu = 0.004, FDbd2Pu = 1, FEMaxPu = 999, FEMinPu = -999, FreqFlag = true, IMaxPu = 1.05, Iqh1Pu = 2, Iql1Pu = -2, IqrMaxPu = 20, IqrMinPu = -20, Kc = 0, Ki = 1.5, KiPLL = 20, Kig = 2.36, Kp = 0.1, KpPLL = 3, Kpg = 0.05, Kqi = 0.5, Kqp = 1, Kqv = 2, Kvi = 1, Kvp = 1, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.7, PMaxPu = 1, PMinPu = 0, PQFlag = false, PfFlag = false, Q0Pu = -0.2, QFlag = true, QMaxPu = 0.4, QMinPu = -0.4, RSourcePu = 0, RateFlag = false, RefFlag = true, RrpwrPu = 10, SNom = 100, U0Pu = 1.03713742957, VCompFlag = false, VDipPu = 0.9, VFlag = true, VFrz = 0, VMaxPu = 1.1, VMinPu = 0.9, VRef0Pu = 1, VRef1Pu = 0, VUpPu = 1.1, XSourcePu = 0.1, tE = 0.005, tFilterGC = 0.02, tFilterPC = 0.04, tFt = 1e-10, tFv = 0.1, tG = 0.2, tIq = 0.02, tLag = 0.1, tP = 0.04, tPord = 0.02, tRv = 0.02, i0Pu(im(fixed = false), re(fixed = false)), u0Pu(im(fixed = false), re(fixed = false)), s0Pu(im(fixed = false), re(fixed = false)), uConv0Pu(im(fixed = false), re(fixed = false)), iSource0Pu(im(fixed = false), re(fixed = false)), iConv0Pu(im(fixed = false), re(fixed = false)), uInj0Pu(im(fixed = false), re(fixed = false)), uSource0Pu(im(fixed = false), re(fixed = false)), Id0Pu(fixed = false), Iq0Pu(fixed = false), PConv0Pu(fixed = false), PF0(fixed = false), PInj0Pu(fixed = false), QConv0Pu(fixed = false), QInj0Pu(fixed = false), UInj0Pu(fixed = false), UConv0Pu(fixed = false), UdInj0Pu(fixed = false), UqInj0Pu(fixed = false), uPcc0Pu(im(fixed = false), re(fixed = false)), UPhase0 = 0.203890124, RLvTrPu = 0, XLvTrPu = 0, XMvHvPu = 0.15) annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.2) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = PV.URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(PV.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  // Initialization
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource_INIT pvVoltageSource_INIT(P0Pu = PV.P0Pu, Q0Pu = PV.Q0Pu, RSourcePu = PV.RSourcePu, SNom = PV.SNom, U0Pu = PV.U0Pu, UPhase0 = PV.UPhase0, XSourcePu = PV.XSourcePu, BMvHvPu = PV.BMvHvPu, GMvHvPu = PV.GMvHvPu, RMvHvPu = PV.RMvHvPu, XMvHvPu = PV.XMvHvPu, RLvTrPu = PV.RLvTrPu, XLvTrPu = PV.XLvTrPu, PPcc0Pu = PV.PPcc0Pu, QPcc0Pu = PV.QPcc0Pu, UPcc0Pu = PV.UPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}})));
initial algorithm
  PV.uPcc0Pu.re := pvVoltageSource_INIT.uPcc0Pu.re;
  PV.uPcc0Pu.im := pvVoltageSource_INIT.uPcc0Pu.im;
  PV.i0Pu.re := pvVoltageSource_INIT.i0Pu.re;
  PV.i0Pu.im := pvVoltageSource_INIT.i0Pu.im;
  PV.u0Pu.re := pvVoltageSource_INIT.u0Pu.re;
  PV.u0Pu.im := pvVoltageSource_INIT.u0Pu.im;
  PV.PF0 := pvVoltageSource_INIT.PF0;
  PV.PInj0Pu := pvVoltageSource_INIT.PInj0Pu;
  PV.QInj0Pu := pvVoltageSource_INIT.QInj0Pu;
  PV.UInj0Pu := pvVoltageSource_INIT.UInj0Pu;
  PV.UdInj0Pu := pvVoltageSource_INIT.UdInj0Pu;
  PV.UqInj0Pu := pvVoltageSource_INIT.UqInj0Pu;
  PV.uInj0Pu.re := pvVoltageSource_INIT.uInj0Pu.re;
  PV.uInj0Pu.im := pvVoltageSource_INIT.uInj0Pu.im;
  PV.PConv0Pu := pvVoltageSource_INIT.PConv0Pu;
  PV.QConv0Pu := pvVoltageSource_INIT.QConv0Pu;
  PV.UConv0Pu := pvVoltageSource_INIT.UConv0Pu;
  PV.uConv0Pu.re := pvVoltageSource_INIT.uConv0Pu.re;
  PV.uConv0Pu.im := pvVoltageSource_INIT.uConv0Pu.im;
  PV.iConv0Pu.re := pvVoltageSource_INIT.iConv0Pu.re;
  PV.iConv0Pu.im := pvVoltageSource_INIT.iConv0Pu.im;
  PV.Id0Pu := pvVoltageSource_INIT.Id0Pu;
  PV.Iq0Pu := pvVoltageSource_INIT.Iq0Pu;
  PV.uSource0Pu.re := pvVoltageSource_INIT.uSource0Pu.re;
  PV.uSource0Pu.im := pvVoltageSource_INIT.uSource0Pu.im;
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  PV.injector.switchOffSignal1.value = false;
  PV.injector.switchOffSignal2.value = false;
  PV.injector.switchOffSignal3.value = false;
  connect(line.terminal2, PV.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, PV.omegaRefPu) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, PV.QRefPu) annotation(
    Line(points = {{79, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PRefPu.y, PV.PRefPu) annotation(
    Line(points = {{79, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(URefPu.y, PV.URefPu) annotation(
    Line(points = {{79, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(PFaRef.y, PV.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(const.y, PV.PPccPu) annotation(
    Line(points = {{-38, -20}, {-20, -20}, {-20, -4}, {6, -4}}, color = {0, 0, 127}));
  connect(const.y, PV.QPccPu) annotation(
    Line(points = {{-38, -20}, {-20, -20}, {-20, -6}, {6, -6}}, color = {0, 0, 127}));
  connect(complexConst.y, PV.uPccPu) annotation(
    Line(points = {{-38, -50}, {0, -50}, {0, -10}, {6, -10}}, color = {85, 170, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one PV park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 4 s to t = 8 s, and which frequency is increased to 1.01 pu from t = 16 s to t = 16.5 s. This is a way to observe the PV park's response to a voltage and frequency variation at its terminal.
     <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/PPuSnRef_PVVoltageSource2.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/QPuSnRef_PVVoltageSource2.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/UPu_PVVoltageSource2.png\">
  </figure>
   </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
 "),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end PVVoltageSource2;
