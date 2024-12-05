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

model WT3ACurrentSource2020 "Wind Turbine Type 3A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;

  Dynawo.Electrical.Wind.IEC.WT.WT3ACurrentSource2020 wT3ACurrentSource(BesPu = 0, CdrtPu = 0.3, DPMaxPu = 999, DPOmega0Pu = 0.48, DPOmegaThetaPu = 0.028, DPRefMax4abPu = 0.3, DPRefMin4abPu = -0.3, DPThetaPu = -0.03, DTauMaxPu = 0.25, DTauUvrtMaxPu = 0, DThetaCmax = 6, DThetaCmin = -3, DThetaMax = 6, DThetaMin = -3, DThetaOmegamax = 6, DThetaOmegamin = -3,DUdb1Pu = -0.1, DUdb2Pu = 0.1, DfcMaxPu = 1, DfpMaxPu = 1, DipMaxPu = 9999, DiqMaxPu = 9999, GesPu = 0, Hgen = 5, Hwtr = 5, IGsIm0Pu = 0.423168, IGsRe0Pu = 0.930069, IpMax0Pu = 1.2, IqH1Pu = 1.05, IqMax0Pu = 0.4, IqMaxPu = 1.05, IqMin0Pu = -0.4, IqMinPu = -1.05, IqPostPu = 0, KDtd = 1.5, KIcPu = 1e-9, KIomegaPu = 15, KIp = 5, KPXPu = 0.03, KPc = 40, KPcPu = 0, KPomegaPu = 15, KPp = 8, KdrtPu = 200, Kiq = 2, Kiu = 2, Kpq = 0, Kpu = 2, Kpufrt = 0, Kqv = 2, MOmegaTMax = true, MOmegaTqpi = true, MPUvrt = true, MpUScale = false, MqG = 1, Mqfrt = 2, OmegaDtdPu = 11.3, OmegaOffsetPu = 0, P0Pu = -1, PAg0Pu = 1, PAvailPu = 1,PBaseMeasurement = SystemBase.SnRef, PDtdMaxPu = 0.15, POrd0Pu = 1, Q0Pu = 0.21, QMax0Pu = 0.8, QMin0Pu = -0.8, RDropPu = 0, ResPu = 0, SNom = 100, TIc = 0.02, TTheta = 0.25, TauEMinPu = 0.001, TauUscalePu = 1, Theta0 = 0, ThetaCmax = 35, ThetaCmin = 0, ThetaMax = 35, ThetaMin = 0, ThetaOmegamax = 35, ThetaOmegamin = 0, U0Pu = 1, UDvsPu = 0.15, UGsIm0Pu = 0.2183, UGsRe0Pu = 0.975897, UMaxPu = 2, UMinPu = 0, UOverPu = 1.2, UPhase0 = 0.21949, UPll1Pu = 999, UPll2Pu = 0.13, URef0Pu = 0, UUnderPu = 0.85, UpDipPu = 0.9, UqDipPu = 0.9, UqRisePu = 1.1, XDropPu = 0, XEqv = 0.4, XWT0Pu = -0.21, XesPu = 0, Zeta = 0.5, fOverPu = 1.02, fUnderPu = 0.98, i0Pu = Complex(-0.930069, -0.423168), tDvs = 0.05, tIcFilt = 0.01, tIpFilt = 0.01, tOmegaRef = 0.005, tOmegafiltp3 = 0.005, tPcFilt = 0.01, tPll = 0.01, tPord = 0.01, tPost = 0, tPpFilt = 0.01, tQcFilt = 0.01, tQord = 0, tQpFilt = 0.01, tS = 1e-6, tUcFilt = 0.01, tUpFilt = 0.01, tUss = 30, tfcFilt = 0.01, tfpFilt = 0.01, u0Pu = Complex(0.975897, 0.2183))  annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0.4, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.1, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line4(BPu = 0.005, GPu = 0, RPu = 0.015, XPu = 0.025) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0.01, GPu = 0, RPu = 0.01, XPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0457) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.0678, UEvtPu = 0, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = 0.99, tOmegaEvtEnd = 21, tOmegaEvtStart = 20, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.09, tBegin = 6, tEnd = 6.4) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = -0.21, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step xRefPu(height = 0.41, offset = -0.21, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Pulse omegaRefPu(amplitude = -0.01, nperiod = 1, offset = 1, period = 2, startTime = 20) annotation(
    Placement(visible = true, transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = -0.5, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  wT3ACurrentSource.injector.switchOffSignal1.value = false;
  wT3ACurrentSource.injector.switchOffSignal2.value = false;
  wT3ACurrentSource.injector.switchOffSignal3.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  line4.switchOffSignal1.value = false;
  line4.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  transformer1.switchOffSignal1.value = false;
  transformer1.switchOffSignal2.value = false;
  connect(wT3ACurrentSource.terminal, transformer1.terminal1) annotation(
    Line(points = {{-119, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(transformer1.terminal2, line4.terminal1) annotation(
    Line(points = {{-80, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(line4.terminal2, transformer.terminal1) annotation(
    Line(points = {{-40, 0}, {-20, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line.terminal1) annotation(
    Line(points = {{0, 0}, {20, 0}, {20, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line3.terminal1) annotation(
    Line(points = {{0, 0}, {20, 0}, {20, 20}, {40, 20}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, line1.terminal2) annotation(
    Line(points = {{140, 0}, {120, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, line2.terminal2) annotation(
    Line(points = {{100, 0}, {80, 0}, {80, -20}}, color = {0, 0, 255}));
  connect(line.terminal2, line2.terminal1) annotation(
    Line(points = {{40, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(line3.terminal2, line1.terminal1) annotation(
    Line(points = {{60, 20}, {80, 20}, {80, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{50, -40}, {50, -20}, {40, -20}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, wT3ACurrentSource.terminal) annotation(
    Line(points = {{-110, -40}, {-110, 0}, {-119, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, wT3ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-158, -60}, {-146, -60}, {-146, -6}, {-140, -6}}, color = {0, 0, 127}));
  connect(xRefPu.y, wT3ACurrentSource.xWTRefPu) annotation(
    Line(points = {{-158, -20}, {-150, -20}, {-150, -2}, {-140, -2}}, color = {0, 0, 127}));
  connect(PRefPu.y, wT3ACurrentSource.PWTRefPu) annotation(
    Line(points = {{-158, 20}, {-150, 20}, {-150, 2}, {-140, 2}}, color = {0, 0, 127}));
  connect(tanPhi.y, wT3ACurrentSource.tanPhi) annotation(
    Line(points = {{-158, 60}, {-146, 60}, {-146, 6}, {-140, 6}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 15, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-140, -70}, {140, 70}})),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WT3ACurrentSource2020;
