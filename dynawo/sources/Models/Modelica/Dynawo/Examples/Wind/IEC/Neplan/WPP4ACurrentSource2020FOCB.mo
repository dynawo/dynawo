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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPP4ACurrentSource2020FOCB "Wind Power Plant Type 4A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;
  extends Dynawo.Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan;

  Dynawo.Electrical.Wind.IEC.WPP.WPP4ACurrentSource2020 wPP4ACurrentSource(
    BesPu = 0,
    DPMaxP4APu = 1,
    DPRefMax4APu = 100,
    DPRefMaxPu = 1,
    DPRefMin4APu = -100,
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
    GesPu = 0,
    IGsIm0Pu(fixed = false),// = 0.423168,
    IGsRe0Pu(fixed = false),// = 0.930069,
    IMaxDipPu = 1.3,
    IMaxPu = 1.3,
    IpMax0Pu(fixed = false),// = 1.2,
    IqH1Pu = 1.05,
    IqMax0Pu(fixed = false),// = 0.4,
    IqMaxPu = 1.05,
    IqMin0Pu(fixed = false),// = -0.4,
    IqMinPu = -1.05,
    IqPostPu = 0,
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
    P0Pu = -1,
    PAg0Pu(fixed = false),
    PErrMaxPu = 1,
    PErrMinPu = -1,
    PKiwppMaxPu = 1,
    PKiwppMinPu = -1,
    PRefMaxPu = 1,
    PRefMinPu = 0,
    Q0Pu = 0.21,
    QMax0Pu(fixed = false),
    QMaxPu = 0.8,
    QMin0Pu(fixed = false),
    QMinPu = -0.8,
    QlConst = true,
    RDropPu = 0,
    ResPu = 0,
    RwpDropPu = 0,
    SNom = 100,
    U0Pu = 1,
    UGsIm0Pu(fixed = false),// = 0.21823,
    UGsRe0Pu(fixed = false),// = 0.975897,
    UMaxPu = 1.1,
    UMinPu = 0.9,
    UOverPu = 1.1,
    UPhase0 = 0.21949,
    UPll1Pu = 999,
    UPll2Pu = 0.13,
    URef0Pu = 0,
    UUnderPu = 0.9,
    UpDipPu = 0,
    UpquMaxPu = 1.1,
    UqDipPu = 0.9,
    UqRisePu = 1.1,
    UwpqDipPu = 0.8,
    UwpqRisePu = 1.2,
    X0Pu(fixed = false),
    XDropPu = 0,
    XErrMaxPu = 1,
    XErrMinPu = -1,
    XKiwpxMaxPu = 1,
    XKiwpxMinPu = -1,
    XRefMaxPu = 1,
    XRefMinPu = -1,
    XWT0Pu(fixed = false),
    XesPu = 0,
    XwpDropPu = 0,
    fOverPu = 1.1,
    fUnderPu = 0.9,
    i0Pu(re(fixed = false), im(fixed = false)),// = Complex(-0.930069, -0.423168),
    tG = 0.01,
    tIFilt = 0.01,
    tIcFilt = 0.01,
    tIpFilt = 0.01,
    tLag = 0.01,
    tLead = 0.01,
    tPFilt = 0.01,
    tPOrdP4A = 0.1,
    tPWTRef4A = 0.01,
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
    u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Faults
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.09, tBegin = 6, tEnd = 6.4) annotation(
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
    BesPu = wPP4ACurrentSource.BesPu,
    GesPu = wPP4ACurrentSource.GesPu,
    IMaxPu = wPP4ACurrentSource.IMaxPu,
    Kpqu = wPP4ACurrentSource.Kpqu,
    MqG = wPP4ACurrentSource.MqG,
    MwpqMode = wPP4ACurrentSource.MwpqMode,
    P0Pu = wPP4ACurrentSource.P0Pu,
    Q0Pu = wPP4ACurrentSource.Q0Pu,
    QMaxPu = wPP4ACurrentSource.QMaxPu,
    QMinPu = wPP4ACurrentSource.QMinPu,
    QlConst = wPP4ACurrentSource.QlConst,
    ResPu = wPP4ACurrentSource.ResPu,
    SNom = wPP4ACurrentSource.SNom,
    U0Pu = wPP4ACurrentSource.U0Pu,
    UPhase0 = wPP4ACurrentSource.UPhase0,
    UpquMaxPu = wPP4ACurrentSource.UpquMaxPu,
    XesPu = wPP4ACurrentSource.XesPu) annotation(
    Placement(visible = true, transformation(origin = {130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  wPP4ACurrentSource.IGsIm0Pu := wPP4CurrentSource_INIT.IGsIm0Pu;
  wPP4ACurrentSource.IGsRe0Pu := wPP4CurrentSource_INIT.IGsRe0Pu;
  wPP4ACurrentSource.IpMax0Pu := wPP4CurrentSource_INIT.IpMax0Pu;
  wPP4ACurrentSource.IqMax0Pu := wPP4CurrentSource_INIT.IqMax0Pu;
  wPP4ACurrentSource.IqMin0Pu := wPP4CurrentSource_INIT.IqMin0Pu;
  wPP4ACurrentSource.PAg0Pu := wPP4CurrentSource_INIT.PAg0Pu;
  wPP4ACurrentSource.QMax0Pu := wPP4CurrentSource_INIT.QMax0Pu;
  wPP4ACurrentSource.QMin0Pu := wPP4CurrentSource_INIT.QMin0Pu;
  wPP4ACurrentSource.UGsIm0Pu := wPP4CurrentSource_INIT.UGsIm0Pu;
  wPP4ACurrentSource.UGsRe0Pu := wPP4CurrentSource_INIT.UGsRe0Pu;
  wPP4ACurrentSource.X0Pu := wPP4CurrentSource_INIT.X0Pu;
  wPP4ACurrentSource.XWT0Pu := wPP4CurrentSource_INIT.XWT0Pu;
  wPP4ACurrentSource.i0Pu.re := wPP4CurrentSource_INIT.i0Pu.re;
  wPP4ACurrentSource.i0Pu.im := wPP4CurrentSource_INIT.i0Pu.im;
  wPP4ACurrentSource.u0Pu.re := wPP4CurrentSource_INIT.u0Pu.re;
  wPP4ACurrentSource.u0Pu.im := wPP4CurrentSource_INIT.u0Pu.im;

equation
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal1.value = false;
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal2.value = false;
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal3.value = false;

  connect(wPP4ACurrentSource.terminal, transformer1.terminal1) annotation(
    Line(points = {{-99, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, wPP4ACurrentSource.terminal) annotation(
    Line(points = {{-90, -40}, {-90, 0}, {-99, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, wPP4ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-139, -60}, {-125, -60}, {-125, -6}, {-121, -6}}, color = {0, 0, 127}));
  connect(PRefPu.y, wPP4ACurrentSource.PWPRefPu) annotation(
    Line(points = {{-139, 20}, {-130, 20}, {-130, 2}, {-121, 2}}, color = {0, 0, 127}));
  connect(xRefPu.y, wPP4ACurrentSource.xWPRefPu) annotation(
    Line(points = {{-139, -20}, {-130, -20}, {-130, -2}, {-121, -2}}, color = {0, 0, 127}));
  connect(tanPhi.y, wPP4ACurrentSource.tanPhi) annotation(
    Line(points = {{-139, 60}, {-125, 60}, {-125, 6}, {-121, 6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 15, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WPP4ACurrentSource2020FOCB;
