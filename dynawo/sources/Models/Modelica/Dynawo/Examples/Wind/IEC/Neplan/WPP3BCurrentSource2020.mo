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

model WPP3BCurrentSource2020 "Wind Power Plant Type 4A model from IEC 61400-27-1:2020 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;

  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0.4, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.1, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line4(BPu = 0.005, GPu = 0, RPu = 0.015, XPu = 0.025) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0.01, GPu = 0, RPu = 0.01, XPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0457) annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.0678, UEvtPu = 1, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = 0.99, tOmegaEvtEnd = 21, tOmegaEvtStart = 20, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.09, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = -0.21, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step xRefPu(height = 0.41, offset = -0.21, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Pulse omegaRefPu(amplitude = -0.01, nperiod = 1, offset = 1, period = 2, startTime = 20) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = -0.6, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Wind.IEC.WPP.WPP3BCurrentSource2020 wPP3BCurrentSource(BesPu = 0, CdrtPu = 2.344, DPMaxPu = 999, DPOmega0Pu = 0.48, DPOmegaThetaPu = 0.028, DPRefMax4abPu = 0.3, DPRefMaxPu = 1, DPRefMin4abPu = -0.3, DPRefMinPu = -1, DPThetaPu = -0.03, DPwpRefMaxPu = 1, DPwpRefMinPu = -1, DTauMaxPu = 0.25, DTauUvrtMaxPu = 0, DThetaCmax = 6, DThetaCmin = -3, DThetaMax = 6, DThetaMin = -3, DThetaOmegamax = 6, DThetaOmegamin = -3, DUdb1Pu = -0.1, DUdb2Pu = 0.1, DXRefMaxPu = 10, DXRefMinPu = -10, DfMaxPu = 1, DfcMaxPu = 1, DfpMaxPu = 1, DipMaxPu = 1, DiqMaxPu = 100, GesPu = 0, Hgen = 3.395, Hwtr = 0.962, IGsIm0Pu = 0.423168, IGsRe0Pu = 0.930069, IMaxDipPu = 1.3, IMaxPu = 1.3, IpMax0Pu = 1.2, IqH1Pu = 1.05, IqMax0Pu = 0.4, IqMaxPu = 1.05, IqMin0Pu = -0.4, IqMinPu = -1.05, IqPostPu = 0, KDtd = 1.5, KIcPu = 1e-9, KIomegaPu = 15, KIp = 5, KPXPu = 1, KPcPu = 0, KPomegaPu = 15, KPp = 8, KdrtPu = 1.378, Kiq = 2.25, Kiu = 10, Kiwpp = 5, Kiwpx = 10, Kpq = 1.1, Kpqu = 20, Kpu = 2, Kpufrt = 2, Kpwpp = 2.25, Kpwpx = 0.5, Kqv = 2, KwppRef = 1.5, KwpqRef = 0, Kwpqu = 0, MCrb = false, MOmegaTMax = true, MOmegaTqpi = false, MPUvrt = true, MdfsLim = false, MpUScale = false, MqG = 2, Mqfrt = 1, Mqpri = true, MwpqMode = 0, OmegaDtdPu = 11.3, OmegaOffsetPu = 0, P0Pu = -1, PAg0Pu = 1, PAvailPu = 1, PDtdMaxPu = 0.15, PErrMaxPu = 1, PErrMinPu = -1, PKiwppMaxPu = 1, PKiwppMinPu = -1, PRefMaxPu = 1, PRefMinPu = 0, PWTRef0Pu = 1, Q0Pu = 0.21, QMax0Pu = 0.8, QMaxPu = 0.8, QMin0Pu = -0.8, QMinPu = -0.8, QlConst = true, RDropPu = 0, ResPu = 0, RwpDropPu = 0, SNom = 100, TTheta = 0.25, TauEMinPu = 0.001, TauUscalePu = 1, Theta0 = 0, ThetaCmax = 35, ThetaCmin = 0, ThetaMax = 35, ThetaMin = 0, ThetaOmegamax = 35, ThetaOmegamin = 0, U0Pu = 1, UDvsPu = 0.15, UGsIm0Pu = 0.21823, UGsRe0Pu = 0.975897, UMaxPu = 1.1, UMinPu = 0.9, UOverPu = 1.1, UPhase0 = 0.21949, UPll1Pu = 999, UPll2Pu = 0.13, URef0Pu = 0, UUnderPu = 0.9, UpDipPu = 0.9, UpquMaxPu = 1.1, UqDipPu = 0.9, UqRisePu = 1.1, UwpqDipPu = 0.8, UwpqRisePu = 1.2, X0Pu = -0.21, XDropPu = 0, XEqv = 10, XErrMaxPu = 1, XErrMinPu = -1, XKiwpxMaxPu = 1, XKiwpxMinPu = -1, XRefMaxPu = 1, XRefMinPu = -1, XWT0Pu = -0.21, XesPu = 0, XwpDropPu = 0, Zeta = 0.5, fOverPu = 1.1, fUnderPu = 0.9, i0Pu = Complex(-0.930069, -0.423168), tDvs = 0.05, tG = 0.01, tIFilt = 0.01, tIcFilt = 0.01, tIpFilt = 0.01, tLag = 0.01, tLead = 0.01, tOmegaRef = 0.005, tOmegafiltp3 = 0.005, tPFilt = 0.01, tPcFilt = 0.01, tPll = 0.01, tPord = 0.01, tPost = 0, tPpFilt = 0.01, tQFilt = 0.01, tQcFilt = 0.01, tQord = 0.05, tQpFilt = 0.01, tS = 0.001, tUFilt = 0.01, tUcFilt = 0.01, tUpFilt = 0.01, tUqFilt = 0.01, tUss = 1, tWo = 0.001, tfFilt = 0.01, tfcFilt = 0.01, tfpFilt = 0.01, u0Pu = Complex(0.975897, 0.2183)) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));

equation
  wPP3BCurrentSource.wT3BCurrentSource.injector.switchOffSignal1.value = false;
  wPP3BCurrentSource.wT3BCurrentSource.injector.switchOffSignal2.value = false;
  wPP3BCurrentSource.wT3BCurrentSource.injector.switchOffSignal3.value = false;
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
  connect(transformer1.terminal2, line4.terminal1) annotation(
    Line(points = {{-40, 0}, {-30, 0}}, color = {0, 0, 255}));
  connect(line4.terminal2, transformer.terminal1) annotation(
    Line(points = {{-10, 0}, {10, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line.terminal1) annotation(
    Line(points = {{30, 0}, {40, 0}, {40, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line3.terminal1) annotation(
    Line(points = {{30, 0}, {40, 0}, {40, 20}, {80, 20}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, line1.terminal2) annotation(
    Line(points = {{140, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, line2.terminal2) annotation(
    Line(points = {{110, 0}, {100, 0}, {100, -20}}, color = {0, 0, 255}));
  connect(line.terminal2, line2.terminal1) annotation(
    Line(points = {{60, -20}, {80, -20}}, color = {0, 0, 255}));
  connect(line3.terminal2, line1.terminal1) annotation(
    Line(points = {{100, 20}, {100, 0}, {110, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, wPP3BCurrentSource.terminal) annotation(
    Line(points = {{-70, -40}, {-70, 0}, {-77, 0}}, color = {0, 0, 255}));
  connect(wPP3BCurrentSource.terminal, transformer1.terminal1) annotation(
    Line(points = {{-77, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(tanPhi.y, wPP3BCurrentSource.tanPhi) annotation(
    Line(points = {{-118, 60}, {-108, 60}, {-108, 8}, {-104, 8}}, color = {0, 0, 127}));
  connect(PRefPu.y, wPP3BCurrentSource.PWPRefPu) annotation(
    Line(points = {{-118, 20}, {-114, 20}, {-114, 2}, {-104, 2}}, color = {0, 0, 127}));
  connect(xRefPu.y, wPP3BCurrentSource.xWPRefPu) annotation(
    Line(points = {{-118, -20}, {-114, -20}, {-114, -2}, {-104, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, wPP3BCurrentSource.omegaRefPu) annotation(
    Line(points = {{-118, -60}, {-108, -60}, {-108, -8}, {-104, -8}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-140, -70}, {140, 70}})),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WPP3BCurrentSource2020;
