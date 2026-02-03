within Dynawo.Examples.Wind.IEC.Neplan;

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

model WPP4BCurrentSource2020 "Wind Power Plant Type 4B model from IEC 61400-27-1:2020 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;
  extends Dynawo.Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan(infiniteBusWithVariations(tOmegaEvtStart = 100, tOmegaEvtEnd = 100));

  Dynawo.Electrical.Wind.IEC.WPP.WPP4BCurrentSource2020 wPP4BCurrentSource(
    BLvTrPu = 0.001,
    BMvHvPu = 0.001,
    CdrtPu = 15,
    ConverterLVControl = false,
    DPMaxP4BPu = 1,
    DPRefMax4BPu = 100,
    DPRefMaxPu = 1,
    DPRefMin4BPu = -100,
    DPRefMinPu = -1,
    DPwpRefMaxPu = 1,
    DPwpRefMinPu = -1,
    DUdb1Pu = -0.1,
    DUdb2Pu = 0.1,
    DXRefMaxPu = 10,
    DXRefMinPu = -10,
    DfMaxPu = 1,
    DfcMaxPu = 1,
    DfpMaxPu = 1,
    DipMaxPu = 1,
    DiqMaxPu = 100,
    DiqMinPu = -100,
    GLvTrPu = 0.0005,
    GMvHvPu = 0.0005,
    Hgen = 1,
    Hwtr = 5,
    IMaxDipPu = 1.3,
    IMaxPu = 1.3,
    IpMax0Pu(fixed = false),
    IqH1Pu = 1.05,
    IqMax0Pu(fixed = false),
    IqMaxPu = 1.05,
    IqMin0Pu(fixed = false),
    IqMinPu = -1.05,
    IqPostPu = 0,
    KdrtPu = 500,
    Kipaw = 100,
    Kiq = 2.25,
    Kiqaw = 100,
    Kiu = 10,
    Kiwpp = 5,
    Kiwpx = 10,
    Kpaw = 1000,
    Kpq = 1.1,
    Kpqu = 20,
    Kpu = 2,
    Kpufrt = 2,
    Kpwpp = 2.25,
    Kpwpx = 0.5,
    Kqv = 2,
    KwppRef = 1.5,
    KwpqRef = 0,
    Kwpqu = 0,
    MdfsLim = false,
    MpUScale = false,
    MqG = 2,
    Mqfrt = 1,
    Mqpri = true,
    MwpqMode = 0,
    P0Pu = -PRefPu.offset * wPP4BCurrentSource.SNom / SystemBase.SnRef,
    PControl0Pu(fixed = false),
    PErrMaxPu = 1,
    PErrMinPu = -1,
    PKiwppMaxPu = 1.01,
    PKiwppMinPu = -1,
    PPCLocal = true,
    PRefMaxPu = 1.01,
    PRefMinPu = 0,
    Q0Pu = -xRefPu.offset * wPP4BCurrentSource.SNom / SystemBase.SnRef,
    QControl0Pu(fixed = false),
    QMax0Pu(fixed = false),
    QMaxPu = 0.8,
    QMin0Pu(fixed = false),
    QMinPu = -0.8,
    QlConst = true,
    RDropPu = 0,
    RLvTrPu = 0.001,
    RMvHvPu = 0.001,
    RwpDropPu = 0,
    SNom = 100,
    TableIpMaxUwt52 = 1.01,
    TableIpMaxUwt62 = 1.01,
    TableIpMaxUwt72 = 1.01,
    U0Pu = 1.00018,
    UMaxPu = 1.1,
    UMinPu = 0.9,
    UOverPu = 1.1,
    UPhase0 = 0.219441,
    UPll1Pu = 999,
    UPll2Pu = 0.13,
    URef0Pu = 0,
    UUnderPu = 0.9,
    UWt0DroppedPu(fixed = false),
    UpDipPu = 0,
    UpquMaxPu = 1.1,
    UqDipPu = 0.9,
    UqRisePu = 1.1,
    UwpqDipPu = 0.8,
    UwpqRisePu = 1.2,
    XDropPu = 0,
    XErrMaxPu = 1,
    XErrMinPu = -1,
    XKiwpxMaxPu = 1,
    XKiwpxMinPu = -1,
    XLvTrPu = 0.01,
    XMvHvPu = 0.01,
    XRefMaxPu = 1,
    XRefMinPu = -1,
    XWT0Pu(fixed = false),
    XwpDropPu = 0,
    fOverPu = 1.1,
    fUnderPu = 0.9,
    i0Pu(re(fixed = false), im(fixed = false)),
    iControl0Pu(re(fixed = false), im(fixed = false)),
    iGs0Pu(re(fixed = false), im(fixed = false)),
    iWt0Pu(re(fixed = false), im(fixed = false)),
    ip0Pu(fixed = false),
    iq0Pu(fixed = false),
    tG = 0.01,
    tIFilt = 0.01,
    tIcFilt = 0.01,
    tIpFilt = 0.01,
    tLag = 0.01,
    tLead = 0.01,
    tPAero = 0.1,
    tPFilt = 0.01,
    tPOrdP4B = 0.05,
    tPcFilt = 0.01,
    tPll = 0.01,
    tPost = 0,
    tPpFilt = 0.01,
    tQFilt = 0.01,
    tQcFilt = 0.01,
    tQord = 0.05,
    tQpFilt = 0.01,
    tS = 0.001,
    tUFilt = 0.01,
    tUcFilt = 0.01,
    tUpFilt = 0.01,
    tUqFilt = 0.01,
    tUss = 1,
    tfFilt = 0.01,
    tfcFilt = 0.01,
    tfpFilt = 0.01,
    u0Pu(re(fixed = false), im(fixed = false)),
    uControl0Pu(re(fixed = false), im(fixed = false)),
    uWt0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-116, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {-104, -64}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));

  // Faults
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.09, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0.4, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  // Reference inputs
  Modelica.Blocks.Sources.Pulse omegaRefPu(amplitude = -0.01, nperiod = 1, offset = 1, period = 2, startTime = 20) annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = -0.5, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step xRefPu(height = 0.41, offset = -0.21, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = -0.21, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initialization
  Dynawo.Electrical.Wind.IEC.WPP.WPP4CurrentSource_INIT wPP4CurrentSource_INIT(
    BesPu = wPP4BCurrentSource.BesPu,
    BLvTrPu = wPP4BCurrentSource.BLvTrPu,
    ConverterLVControl = wPP4BCurrentSource.ConverterLVControl,
    GesPu = wPP4BCurrentSource.GesPu,
    GLvTrPu = wPP4BCurrentSource.GLvTrPu,
    IMaxPu = wPP4BCurrentSource.IMaxPu,
    Kpqu = wPP4BCurrentSource.Kpqu,
    MqG = wPP4BCurrentSource.MqG,
    MwpqMode = wPP4BCurrentSource.MwpqMode,
    P0Pu = wPP4BCurrentSource.P0Pu,
    PPCLocal = wPP4BCurrentSource.PPCLocal,
    Q0Pu = wPP4BCurrentSource.Q0Pu,
    QMaxPu = wPP4BCurrentSource.QMaxPu,
    QMinPu = wPP4BCurrentSource.QMinPu,
    QlConst = wPP4BCurrentSource.QlConst,
    RDropPu = wPP4BCurrentSource.RDropPu,
    ResPu = wPP4BCurrentSource.ResPu,
    RLvTrPu = wPP4BCurrentSource.RLvTrPu,
    SNom = wPP4BCurrentSource.SNom,
    U0Pu = wPP4BCurrentSource.U0Pu,
    UPhase0 = wPP4BCurrentSource.UPhase0,
    UpquMaxPu = wPP4BCurrentSource.UpquMaxPu,
    URef0Pu = wPP4BCurrentSource.URef0Pu,
    XDropPu = wPP4BCurrentSource.XDropPu,
    XesPu = wPP4BCurrentSource.XesPu,
    XLvTrPu = wPP4BCurrentSource.XLvTrPu) annotation(
    Placement(visible = true, transformation(origin = {130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  wPP4BCurrentSource.IpMax0Pu := wPP4CurrentSource_INIT.IpMax0Pu;
  wPP4BCurrentSource.IqMax0Pu := wPP4CurrentSource_INIT.IqMax0Pu;
  wPP4BCurrentSource.IqMin0Pu := wPP4CurrentSource_INIT.IqMin0Pu;
  wPP4BCurrentSource.PControl0Pu := wPP4CurrentSource_INIT.PControl0Pu;
  wPP4BCurrentSource.QControl0Pu := wPP4CurrentSource_INIT.QControl0Pu;
  wPP4BCurrentSource.QMax0Pu := wPP4CurrentSource_INIT.QMax0Pu;
  wPP4BCurrentSource.QMin0Pu := wPP4CurrentSource_INIT.QMin0Pu;
  wPP4BCurrentSource.UWt0DroppedPu := wPP4CurrentSource_INIT.UWt0DroppedPu;
  wPP4BCurrentSource.XWT0Pu := wPP4CurrentSource_INIT.XWT0Pu;
  wPP4BCurrentSource.i0Pu.re := wPP4CurrentSource_INIT.i0Pu.re;
  wPP4BCurrentSource.i0Pu.im := wPP4CurrentSource_INIT.i0Pu.im;
  wPP4BCurrentSource.iGs0Pu.re := wPP4CurrentSource_INIT.iGs0Pu.re;
  wPP4BCurrentSource.iGs0Pu.im := wPP4CurrentSource_INIT.iGs0Pu.im;
  wPP4BCurrentSource.ip0Pu := wPP4CurrentSource_INIT.ip0Pu;
  wPP4BCurrentSource.iq0Pu := wPP4CurrentSource_INIT.iq0Pu;
  wPP4BCurrentSource.iWt0Pu.re := wPP4CurrentSource_INIT.iWt0Pu.re;
  wPP4BCurrentSource.iWt0Pu.im := wPP4CurrentSource_INIT.iWt0Pu.im;
  wPP4BCurrentSource.u0Pu.re := wPP4CurrentSource_INIT.u0Pu.re;
  wPP4BCurrentSource.u0Pu.im := wPP4CurrentSource_INIT.u0Pu.im;
  wPP4BCurrentSource.uControl0Pu.re := wPP4CurrentSource_INIT.uControl0Pu.re;
  wPP4BCurrentSource.uControl0Pu.im := wPP4CurrentSource_INIT.uControl0Pu.im;
  wPP4BCurrentSource.uWt0Pu.re := wPP4CurrentSource_INIT.uWt0Pu.re;
  wPP4BCurrentSource.uWt0Pu.im := wPP4CurrentSource_INIT.uWt0Pu.im;

equation
  wPP4BCurrentSource.wT4BCurrentSource.wT4Injector.switchOffSignal1.value = false;
  wPP4BCurrentSource.wT4BCurrentSource.wT4Injector.switchOffSignal2.value = false;
  wPP4BCurrentSource.wT4BCurrentSource.wT4Injector.switchOffSignal3.value = false;

  connect(wPP4BCurrentSource.terminal, transformer1.terminal1) annotation(
    Line(points = {{-99, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, wPP4BCurrentSource.terminal) annotation(
    Line(points = {{-90, -40}, {-90, 0}, {-99, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, wPP4BCurrentSource.omegaRefPu) annotation(
    Line(points = {{-139, -60}, {-125, -60}, {-125, -6}, {-121, -6}}, color = {0, 0, 127}));
  connect(PRefPu.y, wPP4BCurrentSource.PWPRefPu) annotation(
    Line(points = {{-139, 20}, {-130, 20}, {-130, 2}, {-121, 2}}, color = {0, 0, 127}));
  connect(xRefPu.y, wPP4BCurrentSource.xWPRefPu) annotation(
    Line(points = {{-139, -20}, {-130, -20}, {-130, -2}, {-121, -2}}, color = {0, 0, 127}));
  connect(tanPhi.y, wPP4BCurrentSource.tanPhi) annotation(
    Line(points = {{-139, 60}, {-125, 60}, {-125, 6}, {-121, 6}}, color = {0, 0, 127}));
  connect(const.y, wPP4BCurrentSource.PPccPu) annotation(
    Line(points = {{-116, -78}, {-116, -10}}, color = {0, 0, 127}));
  connect(const.y, wPP4BCurrentSource.QPccPu) annotation(
    Line(points = {{-116, -78}, {-116, -40}, {-110, -40}, {-110, -10}}, color = {0, 0, 127}));
  connect(complexConst.y, wPP4BCurrentSource.uPccPu) annotation(
    Line(points = {{-104, -58}, {-104, -10}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WPP4BCurrentSource2020;
