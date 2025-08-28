within Dynawo.Examples.Wind.WECC;

model WTG4BCurrentSourceExternalPCS "WECC Wind Type 4B Model(including a plant controller) - WTG4B - on infinite bus"
  /*
    * Copyright (c) 2021, RTE (http://www.rte-france.com)
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
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 0.9906184368094055, UEvtPu = 0.6, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 17.5, tOmegaEvtStart = 17, tUEvtEnd = 13, tUEvtStart = 12) annotation(
    Placement(visible = true, transformation(origin = {-180, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.1) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WTG4B.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Dynawo.Electrical.Wind.WECC.WTG4CurrentSource_INIT wTG4CurrentSource_INIT(BMvHvPu = WTG4B.BMvHvPu, ConverterLVControl = WTG4B.ConverterLVControl, GMvHvPu = WTG4B.GMvHvPu, P0Pu = WTG4B.P0Pu, PPCLocal = WTG4B.PPCLocal, PPcc0Pu = WTG4B.PPcc0Pu, Q0Pu = WTG4B.Q0Pu, QPcc0Pu = WTG4B.QPcc0Pu, RLvTrPu = WTG4B.RLvTrPu, RMvHvPu = WTG4B.RMvHvPu, SNom = WTG4B.SNom, U0Pu = WTG4B.U0Pu, UPcc0Pu = WTG4B.UPcc0Pu, UPhase0 = WTG4B.UPhase0, UPhasePcc0 = 0.03533563863002929, XLvTrPu = WTG4B.XLvTrPu, XMvHvPu = WTG4B.XMvHvPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Initialization
  Dynawo.Electrical.Lines.Line Zcc(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Utilities.Measurements PCCmeasurements annotation(
    Placement(visible = true, transformation(origin = {-90, 1.11022e-15}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio ZPcs(BPu = 0, GPu = 0, RPu = 0.01, XPu = 0.15, rTfoPu = 0.95) annotation(
    Placement(visible = true, transformation(origin = {-40, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URef(height = 0.02, offset = WTG4B.URef0Pu, startTime = 1)  annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef(height = 0.05, offset = 0.35, startTime = 8) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.Wind.WECC.WTG4BCurrentSource WTG4B(BMvHvPu = 0, ConverterLVControl = true, DDn = 20, DPMaxPu = 2, DPMinPu = -2, DUp = 0.001, Dbd1Pu = -0.05, Dbd2Pu = 0.05, DbdPu = 0.0001, EMaxPu = 0.5, EMinPu = -0.5, FDbd1Pu = 0.004, FDbd2Pu = 1, FEMaxPu = 999, FEMinPu = -999, FreqFlag = true, GMvHvPu = 0, IMaxPu = 1.3, Id0Pu(fixed = false), Iq0Pu(fixed = false), IqFrzPu = 0, Iqh1Pu = 1.1, Iql1Pu = -1.1, IqrMaxPu = 20, IqrMinPu = -20, Kc = 0.2, Ki = 7, KiPLL = 20, Kig = 7, Kp = 2, KpPLL = 3, Kpg = 2, Kqi = 10, Kqp = 2, Kqv = 2, Kvi = 10, Kvp = 2, Lvplsw = false, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.7058725761772852, PConv0Pu(fixed = false), PF0(fixed = false), PFlag = true, PInj0Pu(fixed = false), PMaxPu = 1, PMinPu = 0, PPCLocal = false, PPcc0Pu = -0.7, PQFlag = false, PfFlag = false, Q0Pu = -0.28808864265927975, QConv0Pu(fixed = false), QFlag = true, QInj0Pu(fixed = false), QMaxPu = 0.4, QMinPu = -0.4, QPcc0Pu = -0.2, RLvTrPu = 0.015, RMvHvPu = 0, RefFlag = true, RrpwrPu = 10, SNom = 200, U0Pu = 0.9948728673356535, UInj0Pu(fixed = false), UPcc0Pu = 1, UPhase0 = 0.14453232453351325, VCompFlag = false, VDLIp11 = 1.1, VDLIp12 = 1.1, VDLIp21 = 1.15, VDLIp22 = 1, VDLIp31 = 1.16, VDLIp32 = 1, VDLIp41 = 1.17, VDLIp42 = 1, VDLIq11 = 1.1, VDLIq12 = 1.1, VDLIq21 = 1.15, VDLIq22 = 1, VDLIq31 = 1.16, VDLIq32 = 1, VDLIq41 = 1.17, VDLIq42 = 1, VDipPu = 0.9, VFlag = true, VFrz = 0, VMaxPu = 1.1, VMinPu = 0.9, VRef0Pu = 0, VRef1Pu = 0, VUpPu = 1.1, XLvTrPu = 0.06, XMvHvPu = 1e-5, brkpt = 0.1, i0Pu(im(fixed = false), re(fixed = false)), iConv0Pu(im(fixed = false), re(fixed = false)), iPcc0Pu(im(fixed = false), re(fixed = false)), lvpl1 = 1.22, s0Pu(im(fixed = false), re(fixed = false)), tFilterGC = 0.02, tFilterPC = 0.04, tFt = 1e-10, tFv = 0.1, tG = 0.02, tHoldIpMax = 0, tHoldIq = 0, tIq = 0.01, tLag = 0.1, tP = 0.05, tPord = 0.01, tRv = 0.01, u0Pu(im(fixed = false), re(fixed = false)), uConv0Pu(im(fixed = false), re(fixed = false)), uInj0Pu(im(fixed = false), re(fixed = false)), uPcc0Pu(im(fixed = false), re(fixed = false)), zerox = 0.05) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
initial algorithm
  WTG4B.Id0Pu := wTG4CurrentSource_INIT.Id0Pu;
  WTG4B.Iq0Pu := wTG4CurrentSource_INIT.Iq0Pu;
  WTG4B.PF0 := wTG4CurrentSource_INIT.PF0;
  WTG4B.PInj0Pu := wTG4CurrentSource_INIT.PInj0Pu;
  WTG4B.QInj0Pu := wTG4CurrentSource_INIT.QInj0Pu;
  WTG4B.UInj0Pu := wTG4CurrentSource_INIT.UInj0Pu;
  WTG4B.i0Pu.re := wTG4CurrentSource_INIT.i0Pu.re;
  WTG4B.i0Pu.im := wTG4CurrentSource_INIT.i0Pu.im;
  WTG4B.iPcc0Pu.re := wTG4CurrentSource_INIT.iPcc0Pu.re;
  WTG4B.iPcc0Pu.im := wTG4CurrentSource_INIT.iPcc0Pu.im;
  WTG4B.s0Pu.re := wTG4CurrentSource_INIT.s0Pu.re;
  WTG4B.s0Pu.im := wTG4CurrentSource_INIT.s0Pu.im;
  WTG4B.u0Pu.re := wTG4CurrentSource_INIT.u0Pu.re;
  WTG4B.u0Pu.im := wTG4CurrentSource_INIT.u0Pu.im;
  WTG4B.uInj0Pu.re := wTG4CurrentSource_INIT.uInj0Pu.re;
  WTG4B.uInj0Pu.im := wTG4CurrentSource_INIT.uInj0Pu.im;
  WTG4B.uConv0Pu.re := wTG4CurrentSource_INIT.uConv0Pu.re;
  WTG4B.uConv0Pu.im := wTG4CurrentSource_INIT.uConv0Pu.im;
  WTG4B.PConv0Pu := wTG4CurrentSource_INIT.PConv0Pu;
  WTG4B.QConv0Pu := wTG4CurrentSource_INIT.QConv0Pu;
equation
  ZPcs.switchOffSignal1.value = false;
  ZPcs.switchOffSignal2.value = false;
  Zcc.switchOffSignal1.value = false;
  Zcc.switchOffSignal2.value = false;
  WTG4B.injector.switchOffSignal1.value = false;
  WTG4B.injector.switchOffSignal2.value = false;
  WTG4B.injector.switchOffSignal3.value = false;
  connect(infiniteBus.terminal, Zcc.terminal1) annotation(
    Line(points = {{-180, 0}, {-160, 0}}, color = {0, 0, 255}));
  connect(Zcc.terminal2, PCCmeasurements.terminal1) annotation(
    Line(points = {{-120, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(PCCmeasurements.terminal2, ZPcs.terminal1) annotation(
    Line(points = {{-80, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(PRef.y, WTG4B.PRefPu) annotation(
    Line(points = {{80, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(URef.y, WTG4B.URefPu) annotation(
    Line(points = {{80, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(WTG4B.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{42, 12}, {60, 12}, {60, 40}, {80, 40}}, color = {0, 0, 127}));
  connect(ZPcs.terminal2, WTG4B.terminal) annotation(
    Line(points = {{-20, 0}, {-2, 0}}, color = {0, 0, 255}));
  connect(PCCmeasurements.PPu, WTG4B.PPccPu) annotation(
    Line(points = {{-88, -10}, {-88, -24}, {-24, -24}, {-24, -6}, {-2, -6}}, color = {0, 0, 127}));
  connect(PCCmeasurements.QPu, WTG4B.QPccPu) annotation(
    Line(points = {{-86, -10}, {-86, -20}, {-20, -20}, {-20, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(PCCmeasurements.uPu, WTG4B.uPccPu) annotation(
    Line(points = {{-82, -10}, {-82, -14}, {-2, -14}}, color = {85, 170, 255}));
  connect(PCCmeasurements.iPu, WTG4B.iPccPu) annotation(
    Line(points = {{-80, -10}, {-80, -18}, {-2, -18}}, color = {85, 170, 255}));
  connect(PFaRef.y, WTG4B.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(QRefPu.y, WTG4B.QRefPu) annotation(
    Line(points = {{79, 0}, {42, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 4B park in response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></figure><figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/PInjPuWTG4BCurrentSource.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/QInjPuWTG4BCurrentSource.png\">
    </figure>
    <figure>
      <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/WECC/Resources/UPuWTG4BCurrentSource.png\">
    </figure></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end WTG4BCurrentSourceExternalPCS;
