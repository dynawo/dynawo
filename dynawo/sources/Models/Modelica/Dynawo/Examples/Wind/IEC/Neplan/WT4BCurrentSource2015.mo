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

model WT4BCurrentSource2015 "Wind Turbine Type 4B model from IEC 61400-27-1:2020 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;
  extends Dynawo.Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan;

  Dynawo.Electrical.Wind.IEC.WT.WT4BCurrentSource2015 wT4BCurrentSource(
    CdrtPu = 15,
    ConverterLVControl = false,
    DPMaxP4BPu = 1,
    DfMaxPu = 1,
    DipMaxPu = 1,
    DiqMaxPu = 100,
    DiqMinPu = -100,
    GesPu = 0.0005,
    Hgen = 1,
    Hwtr = 5,
    IMaxDipPu = 1.3,
    IMaxPu = 1.3,
    IpMax0Pu = Modelica.Math.Vectors.interpolate(wT4BCurrentSource.TableIpMaxUwt[:, 1], wT4BCurrentSource.TableIpMaxUwt[:, 2], wT4BCurrentSource.U0Pu),
    IqH1Pu = 1.05,
    IqMax0Pu = min(Modelica.Math.Vectors.interpolate(wT4BCurrentSource.TableIqMaxUwt[:, 1], wT4BCurrentSource.TableIqMaxUwt[:, 2], wT4BCurrentSource.U0Pu), max(0, wT4BCurrentSource.IMaxPu ^ 2 - min(wT4BCurrentSource.IpMax0Pu, -wT4BCurrentSource.P0Pu * SystemBase.SnRef / (wT4BCurrentSource.SNom * wT4BCurrentSource.U0Pu)) ^ 2) ^ 0.5),
    IqMaxPu = 1.05,
    IqMin0Pu = max(-wT4BCurrentSource.IqMax0Pu, wT4BCurrentSource.Kpqu * (wT4BCurrentSource.U0Pu - wT4BCurrentSource.UpquMaxPu)),
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
    Q0Pu = 0.21,
    QMax0Pu = if wT4BCurrentSource.QlConst then wT4BCurrentSource.QMaxPu else min(Modelica.Math.Vectors.interpolate(wT4BCurrentSource.TableQMaxUwtcFilt[:, 1], wT4BCurrentSource.TableQMaxUwtcFilt[:, 2], wT4BCurrentSource.U0Pu), Modelica.Math.Vectors.interpolate(wT4BCurrentSource.TableQMaxPwtcFilt[:, 1], wT4BCurrentSource.TableQMaxPwtcFilt[:, 2], -wT4BCurrentSource.P0Pu * SystemBase.SnRef / wT4BCurrentSource.SNom)),
    QMaxPu = 0.8,
    QMin0Pu = if wT4BCurrentSource.QlConst then wT4BCurrentSource.QMinPu else max(Modelica.Math.Vectors.interpolate(wT4BCurrentSource.TableQMinUwtcFilt[:, 1], wT4BCurrentSource.TableQMinUwtcFilt[:, 2], wT4BCurrentSource.U0Pu), Modelica.Math.Vectors.interpolate(wT4BCurrentSource.TableQMinPwtcFilt[:, 1], wT4BCurrentSource.TableQMinPwtcFilt[:, 2], -wT4BCurrentSource.P0Pu * SystemBase.SnRef / wT4BCurrentSource.SNom)),
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
    UWt0DroppedPu = ((wT4BCurrentSource.U0Pu + wT4BCurrentSource.RDropPu * wT4BCurrentSource.P0Pu * SystemBase.SnRef / (wT4BCurrentSource.SNom * wT4BCurrentSource.U0Pu) + wT4BCurrentSource.XDropPu * wT4BCurrentSource.Q0Pu * SystemBase.SnRef / (wT4BCurrentSource.SNom * wT4BCurrentSource.U0Pu)) ^ 2 + ((-wT4BCurrentSource.XDropPu * wT4BCurrentSource.P0Pu * SystemBase.SnRef / (wT4BCurrentSource.SNom * wT4BCurrentSource.U0Pu)) + wT4BCurrentSource.RDropPu * wT4BCurrentSource.Q0Pu * SystemBase.SnRef / (wT4BCurrentSource.SNom * wT4BCurrentSource.U0Pu)) ^ 2) ^ 0.5,
    Udb1Pu = 0.9,
    Udb2Pu = 1.1,
    UpquMaxPu = 1.1,
    UqDipPu = 0.9,
    XDropPu = 0,
    XWT0Pu = if wT4BCurrentSource.MqG == 0 then wT4BCurrentSource.UWt0DroppedPu - wT4BCurrentSource.URef0Pu else -wT4BCurrentSource.iq0Pu * wT4BCurrentSource.U0Pu,
    XesPu = 0.01,
    fOverPu = 1.1,
    fUnderPu = 0.9,
    i0Pu = Modelica.ComplexMath.conj(Complex(wT4BCurrentSource.P0Pu, wT4BCurrentSource.Q0Pu) / wT4BCurrentSource.u0Pu),
    iGs0Pu = Complex(wT4BCurrentSource.GesPu, wT4BCurrentSource.BesPu) * (wT4BCurrentSource.u0Pu - Complex(wT4BCurrentSource.ResPu, wT4BCurrentSource.XesPu) * wT4BCurrentSource.i0Pu * SystemBase.SnRef / wT4BCurrentSource.SNom) - wT4BCurrentSource.i0Pu * SystemBase.SnRef / wT4BCurrentSource.SNom,
    ip0Pu = cos(wT4BCurrentSource.UPhase0) * wT4BCurrentSource.iGs0Pu.re + sin(wT4BCurrentSource.UPhase0) * wT4BCurrentSource.iGs0Pu.im,
    iq0Pu = cos(wT4BCurrentSource.UPhase0) * wT4BCurrentSource.iGs0Pu.im - sin(wT4BCurrentSource.UPhase0) * wT4BCurrentSource.iGs0Pu.re,
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
    u0Pu = Modelica.ComplexMath.fromPolar(wT4BCurrentSource.U0Pu, wT4BCurrentSource.UPhase0)) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WT4BCurrentSource2015;
