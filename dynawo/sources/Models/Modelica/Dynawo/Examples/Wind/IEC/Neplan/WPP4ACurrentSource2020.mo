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

model WPP4ACurrentSource2020 "Wind Power Plant Type 4A model from IEC 61400-27-1:2020 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;
  extends Dynawo.Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan;

  Dynawo.Electrical.Wind.IEC.WPP.WPP4ACurrentSource2020 wPP4ACurrentSource(
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
    IMaxDipPu = 1.3,
    IMaxPu = 1.3,
    IqH1Pu = 1.05,
    IqMaxPu = 1.05,
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
    P0Pu = -PRefPu.offset*wPP4ACurrentSource.SNom/SystemBase.SnRef,
    PErrMaxPu = 1,
    PErrMinPu = -1,
    PKiwppMaxPu = 1.01,
    PKiwppMinPu = -1,
    PRefMaxPu = 1.01,
    PRefMinPu = 0,
    Q0Pu = -xRefPu.offset*wPP4ACurrentSource.SNom/SystemBase.SnRef,
    QMaxPu = 0.8,
    QMinPu = -0.8,
    QlConst = true,
    RDropPu = 0,
    RwpDropPu = 0,
    SNom = 100,
    U0Pu = 1.00018,
    UMaxPu = 1.1,
    UMinPu = 0.9,
    UOverPu = 1.1,
    UPhase0 = 0.219441,
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
    XDropPu = 0,
    XErrMaxPu = 1,
    XErrMinPu = -1,
    XKiwpxMaxPu = 1,
    XKiwpxMinPu = -1,
    XRefMaxPu = 1,
    XRefMinPu = -1,
    XwpDropPu = 0,
    fOverPu = 1.1,
    fUnderPu = 0.9,
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
    TableIpMaxUwt52 = 1.01,
    TableIpMaxUwt62 = 1.01,
    TableIpMaxUwt72 = 1.01, BMvHvPu = 0.001, GMvHvPu = 0.0005, RMvHvPu = 0.001, XMvHvPu = 0.01, PPCLocal = true, BLvTrPu = 0.001, GLvTrPu = 0.0005, RLvTrPu = 0.001, XLvTrPu = 0.01, ConverterLVControl = false
    ) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(transformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0))  annotation(
    Placement(transformation(origin = {-104, -40}, extent = {{-4, -4}, {4, 4}}, rotation = 90)));

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

equation
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal1.value = false;
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal2.value = false;
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal3.value = false;

  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(wPP4ACurrentSource.terminal, transformer1.terminal1) annotation(
    Line(points = {{-98, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(wPP4ACurrentSource.terminal, nodeFault1.terminal) annotation(
    Line(points = {{-98, 0}, {-90, 0}, {-90, -40}}, color = {0, 0, 255}));
  connect(tanPhi.y, wPP4ACurrentSource.tanPhi) annotation(
    Line(points = {{-138, 60}, {-124, 60}, {-124, 6}, {-120, 6}}, color = {0, 0, 127}));
  connect(PRefPu.y, wPP4ACurrentSource.PWPRefPu) annotation(
    Line(points = {{-138, 20}, {-126, 20}, {-126, 2}, {-120, 2}}, color = {0, 0, 127}));
  connect(xRefPu.y, wPP4ACurrentSource.xWPRefPu) annotation(
    Line(points = {{-138, -20}, {-126, -20}, {-126, -2}, {-120, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, wPP4ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-138, -60}, {-124, -60}, {-124, -6}, {-120, -6}}, color = {0, 0, 127}));
  connect(const.y, wPP4ACurrentSource.PPccPu) annotation(
    Line(points = {{-110, -78}, {-110, -24}, {-116, -24}, {-116, -10}}, color = {0, 0, 127}));
  connect(const.y, wPP4ACurrentSource.QPccPu) annotation(
    Line(points = {{-110, -78}, {-110, -10}}, color = {0, 0, 127}));
  connect(complexConst.y, wPP4ACurrentSource.uPccPu) annotation(
    Line(points = {{-104, -36}, {-104, -10}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-07, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WPP4ACurrentSource2020;
