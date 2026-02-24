within Dynawo.Examples.Wind.IEC.Neplan;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4ACurrentSource2020 "Wind Turbine Type 4A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;
  extends Dynawo.Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan;

  Dynawo.Electrical.Wind.IEC.WT.WT4ACurrentSource2020 wT4ACurrentSource(
    ConverterLVControl = false,
    DPMaxP4APu = 1,
    DPRefMax4APu = 100,
    DPRefMin4APu = -100,
    DUdb1Pu = -0.1,
    DUdb2Pu = 0.1,
    DfcMaxPu = 1,
    DfpMaxPu = 1,
    DipMaxPu = 1,
    DiqMaxPu = 100,
    DiqMinPu = -100,
    GesPu = 0.0005,
    IMaxDipPu = 1.3,
    IMaxPu = 1.3,
    Ip0Pu(fixed = false),
    IpMax0Pu(fixed = false),
    Iq0Pu(fixed = false),
    IqH1Pu = 1.05,
    IqMax0Pu(fixed = false),
    IqMaxPu = 1.05,
    IqMin0Pu(fixed = false),
    IqMinPu = -1.05,
    IqPostPu = 0,
    Kipaw = 100,
    Kiq = 2.25,
    Kiqaw = 100,
    Kiu = 10,
    Kpaw = 1000,
    Kpq = 1.1,
    Kpqu = 20,
    Kpu = 2,
    Kpufrt = 2,
    Kqv = 2,
    MdfsLim = false,
    MpUScale = false,
    MqG = 1,
    Mqfrt = 1,
    Mqpri = true,
    P0Pu = -1,
    Q0Pu = 0.21,
    QMax0Pu(fixed = false),
    QMaxPu = 0.8,
    QMin0Pu(fixed = false),
    QMinPu = -0.8,
    QlConst = true,
    RDropPu = 0,
    ResPu = 0.001,
    SNom = 100,
    U0Pu = 1,
    UMaxPu = 1.1,
    UMinPu = 0.9,
    UOverPu = 1.1,
    UPhase0 = 0.21949,
    UPll1Pu = 999,
    UPll2Pu = 0.13,
    URef0Pu = 0,
    UUnderPu = 0.9,
    UWt0DroppedPu(fixed = false),
    UpDipPu = 0,
    UpquMaxPu = 1.1,
    UqDipPu = 0.9,
    UqRisePu = 1.1,
    XDropPu = 0,
    XWT0Pu(fixed = false),
    XesPu = 0.01,
    fOverPu = 1.1,
    fUnderPu = 0.9,
    i0Pu(re(fixed = false), im(fixed = false)),
    iGs0Pu(re(fixed = false), im(fixed = false)),
    tG = 0.01,
    tIcFilt = 0.01,
    tIpFilt = 0.01,
    tPOrdP4A = 0.1,
    tPWTRef4A = 0.01,
    tPcFilt = 0.01,
    tPll = 0.01,
    tPost = 0,
    tPpFilt = 0.01,
    tQcFilt = 0.01,
    tQord = 0.05,
    tQpFilt = 0.01,
    tS = 0.001,
    tUcFilt = 0.01,
    tUpFilt = 0.01,
    tUss = 1,
    tfcFilt = 0.01,
    tfpFilt = 0.01,
    u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Faults
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.4, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0.09, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

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
  Dynawo.Electrical.Wind.IEC.WT.WT4CurrentSource_INIT wT4CurrentSource_INIT(
    BesPu = wT4ACurrentSource.BesPu,
    GesPu = wT4ACurrentSource.GesPu,
    IMaxPu = wT4ACurrentSource.IMaxPu,
    Kpqu = wT4ACurrentSource.Kpqu,
    MqG = wT4ACurrentSource.MqG,
    P0Pu = wT4ACurrentSource.P0Pu,
    Q0Pu = wT4ACurrentSource.Q0Pu,
    QMaxPu = wT4ACurrentSource.QMaxPu,
    QMinPu = wT4ACurrentSource.QMinPu,
    QlConst = wT4ACurrentSource.QlConst,
    RDropPu = wT4ACurrentSource.RDropPu,
    ResPu = wT4ACurrentSource.ResPu,
    SNom = wT4ACurrentSource.SNom,
    U0Pu = wT4ACurrentSource.U0Pu,
    UPhase0 = wT4ACurrentSource.UPhase0,
    UpquMaxPu = wT4ACurrentSource.UpquMaxPu,
    URef0Pu = wT4ACurrentSource.URef0Pu,
    XDropPu = wT4ACurrentSource.XDropPu,
    XesPu = wT4ACurrentSource.XesPu) annotation(
    Placement(visible = true, transformation(origin = {130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  wT4ACurrentSource.Ip0Pu := wT4CurrentSource_INIT.Ip0Pu;
  wT4ACurrentSource.IpMax0Pu := wT4CurrentSource_INIT.IpMax0Pu;
  wT4ACurrentSource.Iq0Pu := wT4CurrentSource_INIT.Iq0Pu;
  wT4ACurrentSource.IqMax0Pu := wT4CurrentSource_INIT.IqMax0Pu;
  wT4ACurrentSource.IqMin0Pu := wT4CurrentSource_INIT.IqMin0Pu;
  wT4ACurrentSource.QMax0Pu := wT4CurrentSource_INIT.QMax0Pu;
  wT4ACurrentSource.QMin0Pu := wT4CurrentSource_INIT.QMin0Pu;
  wT4ACurrentSource.UWt0DroppedPu := wT4CurrentSource_INIT.UWt0DroppedPu;
  wT4ACurrentSource.XWT0Pu := wT4CurrentSource_INIT.XWT0Pu;
  wT4ACurrentSource.i0Pu.re := wT4CurrentSource_INIT.i0Pu.re;
  wT4ACurrentSource.i0Pu.im := wT4CurrentSource_INIT.i0Pu.im;
  wT4ACurrentSource.iGs0Pu.re := wT4CurrentSource_INIT.iGs0Pu.re;
  wT4ACurrentSource.iGs0Pu.im := wT4CurrentSource_INIT.iGs0Pu.im;
  wT4ACurrentSource.u0Pu.re := wT4CurrentSource_INIT.u0Pu.re;
  wT4ACurrentSource.u0Pu.im := wT4CurrentSource_INIT.u0Pu.im;

equation
  wT4ACurrentSource.wT4Injector.switchOffSignal1.value = false;
  wT4ACurrentSource.wT4Injector.switchOffSignal2.value = false;
  wT4ACurrentSource.wT4Injector.switchOffSignal3.value = false;

  connect(wT4ACurrentSource.terminal, transformer.terminal1) annotation(
    Line(points = {{-99, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, line2A.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, wT4ACurrentSource.terminal) annotation(
    Line(points = {{-90, -40}, {-90, 0}, {-99, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, wT4ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-139, -60}, {-125, -60}, {-125, -6}, {-121, -6}}, color = {0, 0, 127}));
  connect(PRefPu.y, wT4ACurrentSource.PWTRefPu) annotation(
    Line(points = {{-139, 20}, {-130, 20}, {-130, 2}, {-121, 2}}, color = {0, 0, 127}));
  connect(xRefPu.y, wT4ACurrentSource.xWTRefPu) annotation(
    Line(points = {{-139, -20}, {-130, -20}, {-130, -2}, {-121, -2}}, color = {0, 0, 127}));
  connect(tanPhi.y, wT4ACurrentSource.tanPhi) annotation(
    Line(points = {{-139, 60}, {-125, 60}, {-125, 6}, {-121, 6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WT4ACurrentSource2020;
