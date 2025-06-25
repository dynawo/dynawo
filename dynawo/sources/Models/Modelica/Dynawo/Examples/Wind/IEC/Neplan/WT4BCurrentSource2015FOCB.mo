within Dynawo.Examples.Wind.IEC.Neplan;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4BCurrentSource2015FOCB "Wind Turbine Type 4B model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;
  extends Dynawo.Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan;

  Dynawo.Electrical.PEIR.Converters.Wind.IEC.WT.WT4BCurrentSource2015 wT4BCurrentSource(
    BesPu = 0,
    CdrtPu = 15,
    DPMaxP4BPu = 1,
    DfMaxPu = 1,
    DipMaxPu = 1,
    DiqMaxPu = 100,
    DiqMinPu = -100,
    GesPu = 0,
    Hgen = 1,
    Hwtr = 5,
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
    KdrtPu = 500,
    Kipaw = 100,
    Kiq = 2.25,
    Kiqaw = 100,
    Kiu = 10,
    Kpaw = 1000,
    Kpq = 1.1,
    Kpqu = 20,
    Kpu = 2,
    Kqv = 2,
    MdfsLim = false,
    MqG = 1,
    MqUvrt = 1,
    Mqpri = true,
    Mzc = false,
    P0Pu = -1,
    PAg0Pu(fixed = false),// = 1,
    Q0Pu = 0.21,
    QMax0Pu(fixed = false),// = 0.8,
    QMaxPu = 0.8,
    QMin0Pu(fixed = false),// = -0.8,
    QMinPu = -0.8,
    QlConst = true,
    RDropPu = 0,
    ResPu = 0,
    SNom = 100,
    TabletUunderUwtfilt12 = 0.5,
    TabletUunderUwtfilt22 = 0.5,
    TabletUunderUwtfilt32 = 0.5,
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
    Udb1Pu = 0.9,
    Udb2Pu = 1.1,
    UpquMaxPu = 1.1,
    UqDipPu = 0.9,
    XDropPu = 0,
    XWT0Pu(fixed = false),// = -0.21,
    XesPu = 0,
    fOverPu = 1.1,
    fUnderPu = 0.9,
    i0Pu(re(fixed = false), im(fixed = false)),// = Complex(-0.930069, -0.423168),
    tG = 0.01,
    tPAero = 0.1,
    tPFiltQ = 0.01,
    tPFiltql = 0.01,
    tPOrdP4B = 0.05,
    tPll = 0.01,
    tPost = 0,
    tQord = 0.05,
    tS = 0.001,
    tUFilt = 0.01,
    tUFiltP4B = 0.01,
    tUFiltQ = 0.01,
    tUFiltcl = 0.01,
    tUFiltql = 0.01,
    tfFilt = 0.01,
    tphiFilt = 0.02,
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
  Dynawo.Electrical.PEIR.Converters.Wind.IEC.WT.WT4CurrentSource_INIT wT4CurrentSource_INIT(
    BesPu = wT4BCurrentSource.BesPu,
    GesPu = wT4BCurrentSource.GesPu,
    IMaxPu = wT4BCurrentSource.IMaxPu,
    Kpqu = wT4BCurrentSource.Kpqu,
    MqG = wT4BCurrentSource.MqG,
    P0Pu = wT4BCurrentSource.P0Pu,
    Q0Pu = wT4BCurrentSource.Q0Pu,
    QMaxPu = wT4BCurrentSource.QMaxPu,
    QMinPu = wT4BCurrentSource.QMinPu,
    QlConst = wT4BCurrentSource.QlConst,
    ResPu = wT4BCurrentSource.ResPu,
    SNom = wT4BCurrentSource.SNom,
    U0Pu = wT4BCurrentSource.U0Pu,
    UPhase0 = wT4BCurrentSource.UPhase0,
    UpquMaxPu = wT4BCurrentSource.UpquMaxPu,
    XesPu = wT4BCurrentSource.XesPu) annotation(
    Placement(visible = true, transformation(origin = {130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  wT4BCurrentSource.IGsIm0Pu := wT4CurrentSource_INIT.IGsIm0Pu;
  wT4BCurrentSource.IGsRe0Pu := wT4CurrentSource_INIT.IGsRe0Pu;
  wT4BCurrentSource.IpMax0Pu := wT4CurrentSource_INIT.IpMax0Pu;
  wT4BCurrentSource.IqMax0Pu := wT4CurrentSource_INIT.IqMax0Pu;
  wT4BCurrentSource.IqMin0Pu := wT4CurrentSource_INIT.IqMin0Pu;
  wT4BCurrentSource.PAg0Pu := wT4CurrentSource_INIT.PAg0Pu;
  wT4BCurrentSource.QMax0Pu := wT4CurrentSource_INIT.QMax0Pu;
  wT4BCurrentSource.QMin0Pu := wT4CurrentSource_INIT.QMin0Pu;
  wT4BCurrentSource.UGsIm0Pu := wT4CurrentSource_INIT.UGsIm0Pu;
  wT4BCurrentSource.UGsRe0Pu := wT4CurrentSource_INIT.UGsRe0Pu;
  wT4BCurrentSource.XWT0Pu := wT4CurrentSource_INIT.XWT0Pu;
  wT4BCurrentSource.i0Pu.re := wT4CurrentSource_INIT.i0Pu.re;
  wT4BCurrentSource.i0Pu.im := wT4CurrentSource_INIT.i0Pu.im;
  wT4BCurrentSource.u0Pu.re := wT4CurrentSource_INIT.u0Pu.re;
  wT4BCurrentSource.u0Pu.im := wT4CurrentSource_INIT.u0Pu.im;

equation
  wT4BCurrentSource.wT4Injector.switchOffSignal1.value = false;
  wT4BCurrentSource.wT4Injector.switchOffSignal2.value = false;
  wT4BCurrentSource.wT4Injector.switchOffSignal3.value = false;

  connect(wT4BCurrentSource.terminal, transformer1.terminal1) annotation(
    Line(points = {{-99, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, wT4BCurrentSource.terminal) annotation(
    Line(points = {{-90, -40}, {-90, 0}, {-99, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, wT4BCurrentSource.omegaRefPu) annotation(
    Line(points = {{-139, -60}, {-125, -60}, {-125, -6}, {-121, -6}}, color = {0, 0, 127}));
  connect(PRefPu.y, wT4BCurrentSource.PWTRefPu) annotation(
    Line(points = {{-139, 20}, {-130, 20}, {-130, 2}, {-121, 2}}, color = {0, 0, 127}));
  connect(xRefPu.y, wT4BCurrentSource.xWTRefPu) annotation(
    Line(points = {{-139, -20}, {-130, -20}, {-130, -2}, {-121, -2}}, color = {0, 0, 127}));
  connect(tanPhi.y, wT4BCurrentSource.tanPhi) annotation(
    Line(points = {{-139, 60}, {-125, 60}, {-125, 6}, {-121, 6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 15, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WT4BCurrentSource2015FOCB;
