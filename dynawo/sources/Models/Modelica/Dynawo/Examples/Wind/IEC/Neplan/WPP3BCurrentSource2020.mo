within Dynawo.Examples.Wind.IEC.Neplan;

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

model WPP3BCurrentSource2020 "Wind Power Plant model with Turbine Type 3B model from IEC 61400-27-1 standard with infinite bus - voltage drop test."
  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 0.2, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 999, tOmegaEvtStart = 999, tUEvtEnd = 1.1, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Wind.IEC.WT.WT3CurrentSource_INIT init(BesPu = wpp.BesPu, GesPu = wpp.GesPu, IMaxPu = wpp.IMaxPu, Kpqu = wpp.Kpqu, MqG = wpp.MqG, P0Pu = wpp.P0Pu, Q0Pu = wpp.Q0Pu, QMaxPu = wpp.QMaxPu, QMinPu = wpp.QMinPu, QlConst = wpp.QlConst, ResPu = wpp.ResPu, SNom = wpp.SNom, TableIpMaxUwt = wpp.TableIpMaxUwt, TableIqMaxUwt = wpp.TableIqMaxUwt, TableQMaxPwtcFilt = wpp.TableQMaxPwtcFilt, TableQMaxUwtcFilt = wpp.TableQMaxUwtcFilt, TableQMinPwtcFilt = wpp.TableQMinPwtcFilt, TableQMinUwtcFilt = wpp.TableQMinUwtcFilt, U0Pu = wpp.U0Pu, UPhase0 = wpp.UPhase0, UpquMaxPu = wpp.UpquMaxPu, XesPu = wpp.XesPu) annotation(
    Placement(visible = true, transformation(origin = {-12, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Pulse omegaRefPu(amplitude = -0.01, nperiod = 1, offset = 1, period = 2, startTime = 999) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = -0.7, offset = wpp.PWTRef0Pu, startTime = 1 * 99999) annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = 0, startTime = 999) annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Wind.IEC.WPP.WPP3BCurrentSource2020 wpp(BesPu = 0, CdrtPu = 2.344, DPMaxPu = 999, DPOmega0Pu = 0.48, DPOmegaThetaPu = 0.028, DPRefMax4abPu = 0.3, DPRefMaxPu = 1, DPRefMin4abPu = -0.3, DPRefMinPu = -1, DPThetaPu = -0.03, DPwpRefMaxPu = 1, DPwpRefMinPu = -1, DTauMaxPu = 0.25, DTauUvrtMaxPu = 0, DThetaCMax = 6, DThetaCMin = -3, DThetaMax = 6, DThetaMin = -3, DThetaOmegaMax = 6, DThetaOmegaMin = -3, DUdb1Pu = -0.1, DUdb2Pu = 0.1, DXRefMaxPu = 10, DXRefMinPu = -10, DfMaxPu = 5, DfcMaxPu = 5, DfpMaxPu = 5, DipMaxPu = 1, DiqMaxPu = 100, GesPu = 0, Hgen = 3.395, Hwtr = 0.962, IGsIm0Pu = -0.1, IGsRe0Pu = 0.6, IMaxDipPu = 1.3, IMaxPu = 1.3, IpMax0Pu = 1.00005, IqH1Pu = 1.05, IqMax0Pu = 0.33, IqMaxPu = 1.05, IqMin0Pu = -0.33, IqMinPu = -1.05, IqPostPu = 0, KDtd = 1.5, KIcPu = 1e-9, KIomegaPu = 15, KIp = 5, KPXPu = 0.03 * 0 + 1, KPcPu = 0, KPomegaPu = 15, KPp = 8, KdrtPu = 1.378, Kiq = 2, Kiu = 2, Kiwpp = 5, Kiwpx = 10, Kpq = 0, Kpqu = 20, Kpu = 2, Kpufrt = 1e-9, Kpwpp = 2.25, Kpwpx = 0.5, Kqv = 2, KwppRef = 1.5, KwpqRef = 0, Kwpqu = 0, MCrb = false, MOmegaTMax = true, MOmegaTqpi = false, MPUvrt = true, MdfsLim = false, MpUScale = false, MqG = 2, Mqfrt = 2, Mqpri = true, MwpqMode = 0, OmegaDtdPu = 11.3, OmegaOffsetPu = 0, P0Pu = -0.6, PAvailPu = 0.6, PDtdMaxPu = 0.15, PErrMaxPu = 1, PErrMinPu = -1, PKiwppMaxPu = 1, PKiwppMinPu = -1, PRefMaxPu = 1, PRefMinPu = 0, PWTRef0Pu = 1.1, Q0Pu = -0.1, QMax0Pu = 0.8, QMaxPu = 0.8, QMin0Pu = -0.8, QMinPu = -0.8, QlConst = false, RDropPu = 0, ResPu = 0, RwpDropPu = 0, SNom = 100, TTheta = 0.25, TableIpMaxUwt11 = 0, TableIpMaxUwt12 = 0, TableIpMaxUwt21 = 0.1, TableIpMaxUwt22 = 0, TableIpMaxUwt31 = 0.15, TableIpMaxUwt32 = 1, TableIpMaxUwt41 = 0.9, TableIpMaxUwt42 = 1, TableIpMaxUwt51 = 0.91, TableIpMaxUwt52 = 1.2, TableIpMaxUwt61 = 1.2, TableIpMaxUwt62 = 1.2, TableIpMaxUwt71 = 10, TableIpMaxUwt72 = 1.2, TableIqMaxUwt11 = 0, TableIqMaxUwt12 = 0.1, TableIqMaxUwt21 = 0.2, TableIqMaxUwt22 = 0.95, TableIqMaxUwt31 = 0.2 + 1e-6, TableIqMaxUwt32 = 1, TableIqMaxUwt41 = 0.9, TableIqMaxUwt42 = 1, TableIqMaxUwt51 = 0.9 + 1e-6, TableIqMaxUwt52 = 0.36, TableIqMaxUwt61 = 1.1, TableIqMaxUwt62 = 0.3, TableIqMaxUwt71 = 10, TableIqMaxUwt72 = 0.3, TableIqMaxUwt81 = 20, TableIqMaxUwt82 = 0.3, TableOmegaPPu = [0, 0.76; 0.3, 0.76; 0.31, 0.86; 0.4, 0.94; 0.5, 1; 1, 1], TableQMaxPwtcFilt11 = 0, TableQMaxPwtcFilt12 = 0, TableQMaxPwtcFilt21 = 0.3, TableQMaxPwtcFilt22 = 0.33, TableQMaxPwtcFilt31 = 1, TableQMaxPwtcFilt32 = 0.33, TableQMaxPwtcFilt41 = 10, TableQMaxPwtcFilt42 = 0.33, TableQMaxUwtcFilt11 = -1, TableQMaxUwtcFilt12 = 0, TableQMaxUwtcFilt21 = 0, TableQMaxUwtcFilt22 = 0, TableQMaxUwtcFilt31 = 0.8, TableQMaxUwtcFilt32 = 0.33, TableQMaxUwtcFilt41 = 0.9, TableQMaxUwtcFilt42 = 0.33, TableQMaxUwtcFilt51 = 10, TableQMaxUwtcFilt52 = 0.33, TableQMaxUwtcFilt61 = 20, TableQMaxUwtcFilt62 = 0.33, TableQMinPwtcFilt11 = 0, TableQMinPwtcFilt12 = 0, TableQMinPwtcFilt21 = 0.3, TableQMinPwtcFilt22 = -0.33, TableQMinPwtcFilt31 = 1, TableQMinPwtcFilt32 = -0.33, TableQMinPwtcFilt41 = 10, TableQMinPwtcFilt42 = -0.33, TableQMinUwtcFilt11 = 0, TableQMinUwtcFilt12 = 0, TableQMinUwtcFilt21 = 0.8, TableQMinUwtcFilt22 = -0.33, TableQMinUwtcFilt31 = 0.9, TableQMinUwtcFilt32 = -0.33, TableQMinUwtcFilt41 = 10, TableQMinUwtcFilt42 = -0.33, TabletUoverUwtfilt11 = 1.2, TabletUoverUwtfilt12 = 60, TabletUoverUwtfilt21 = 1.2 + 1e-9, TabletUoverUwtfilt22 = 0.1, TabletUoverUwtfilt31 = 1.3, TabletUoverUwtfilt32 = 0.1, TabletUoverUwtfilt41 = 10, TabletUoverUwtfilt42 = 0.1, TabletUoverUwtfilt51 = 20, TabletUoverUwtfilt52 = 0.1, TabletUoverUwtfilt61 = 30, TabletUoverUwtfilt62 = 0.1, TabletUoverUwtfilt71 = 40, TabletUoverUwtfilt72 = 0.1, TabletUoverUwtfilt81 = 50, TabletUoverUwtfilt82 = 0.1, TabletUunderUwtfilt11 = 0, TabletUunderUwtfilt12 = 0.15, TabletUunderUwtfilt21 = 0.85, TabletUunderUwtfilt22 = 3, TabletUunderUwtfilt31 = 0.85 + 1e-9, TabletUunderUwtfilt32 = 9999, TabletUunderUwtfilt41 = 10, TabletUunderUwtfilt42 = 9999, TabletUunderUwtfilt51 = 20, TabletUunderUwtfilt52 = 9999, TabletUunderUwtfilt61 = 30, TabletUunderUwtfilt62 = 9999, TabletUunderUwtfilt71 = 40, TabletUunderUwtfilt72 = 9999, Tabletfoverfwtfilt11 = 1.02, Tabletfoverfwtfilt12 = 1800, Tabletfoverfwtfilt21 = 1.03, Tabletfoverfwtfilt22 = 1800, Tabletfoverfwtfilt31 = 1.03 + 1e-9, Tabletfoverfwtfilt32 = 0.1, Tabletfoverfwtfilt41 = 10, Tabletfoverfwtfilt42 = 0.1, Tabletfunderfwtfilt11 = 0.95, Tabletfunderfwtfilt12 = 0.1, Tabletfunderfwtfilt21 = 0.95 + 1e-9, Tabletfunderfwtfilt22 = 1800, Tabletfunderfwtfilt31 = 0.98, Tabletfunderfwtfilt32 = 1800, Tabletfunderfwtfilt41 = 10, Tabletfunderfwtfilt42 = 1800, Tabletfunderfwtfilt51 = 20, Tabletfunderfwtfilt52 = 1800, Tabletfunderfwtfilt61 = 30, Tabletfunderfwtfilt62 = 1800, TauEMinPu = 0.001, TauUscalePu = 1, Theta0 = 0, ThetaCMax = 35, ThetaCMin = 0, ThetaMax = 35, ThetaMin = 0, ThetaOmegaMax = 35, ThetaOmegaMin = 0, U0Pu = 1, UDvsPu = 0.15, UGsIm0Pu = 0.06, UGsRe0Pu = 1.01, UMaxPu = 2, UMinPu = 0, UOverPu = 1.2, UPhase0 = 0, UPll1Pu = 9, UPll2Pu = 0.13, URef0Pu = 0, UUnderPu = 0.85, UpDipPu = 0.9, UpquMaxPu = 1.1, UqDipPu = 0.9, UqRisePu = 1.1, UwpqDipPu = 0.8, UwpqRisePu = 1.2, X0Pu = 0.1, XDropPu = 0, XEqv = 10, XErrMaxPu = 1, XErrMinPu = -1, XKiwpxMaxPu = 1, XKiwpxMinPu = -1, XRefMaxPu = 1, XRefMinPu = -1, XWT0Pu = 0.1, XesPu = 0.1, XwpDropPu = 0, Zeta = 0.5, fOverPu = 1.02, fUnderPu = 0.98, i0Pu = Complex(-0.6, 0.1), tDvs = 0.05, tG = 0.01, tIFilt = 0.005, tIcFilt = 0.005, tIpFilt = 0.005, tLag = 0.005, tLead = 0.005, tOmegaRef = 0.005, tOmegafiltp3 = 0.005, tPFilt = 0.005, tPcFilt = 0.005, tPll = 0.02, tPord = 0.01, tPost = 1e-9, tPpFilt = 0.005, tQFilt = 0.005, tQcFilt = 0.005, tQord = 1e-9, tQpFilt = 0.005, tS = 1e-6, tUFilt = 0.005, tUcFilt = 0.005, tUpFilt = 0.005, tUqFilt = 0.005, tUss = 30, tWo = 0.001, tfFilt = 0.005, tfcFilt = 0.005, tfpFilt = 0.005, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step xRefPu(height = 0.2, offset = wpp.XWT0Pu, startTime = 999) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  wpp.wT3BCurrentSource.injector.switchOffSignal1.value = false;
  wpp.wT3BCurrentSource.injector.switchOffSignal2.value = false;
  wpp.wT3BCurrentSource.injector.switchOffSignal3.value = false;

  connect(tanPhi.y, wpp.tanPhi) annotation(
    Line(points = {{-118, 60}, {-76, 60}, {-76, 6}, {-40, 6}}, color = {0, 0, 127}));
  connect(PRefPu.y, wpp.PWPRefPu) annotation(
    Line(points = {{-118, 20}, {-84, 20}, {-84, 2}, {-40, 2}}, color = {0, 0, 127}));
  connect(xRefPu.y, wpp.xWPRefPu) annotation(
    Line(points = {{-118, -20}, {-84, -20}, {-84, -2}, {-40, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, wpp.omegaRefPu) annotation(
    Line(points = {{-118, -60}, {-76, -60}, {-76, -6}, {-40, -6}}, color = {0, 0, 127}));
  connect(wpp.terminal, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{-18, 0}, {80, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-05, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-140, -70}, {140, 70}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    Documentation(info = "<html><head></head>
  <body><!--StartFragment-->
    <div style=\"background-color: rgb(255, 255, 255); font-family: Consolas, 'Courier New', monospace; font-size: 14px; line-height: 19px; white-space: pre;\"><div>This test case implements the IEC 61400-27-1
<b>Type 3 B</b> wind <b>power plant</b> model
(inner current loop modeled by PT1 lag element,
with crowbar model)
in a single machine infinite bus system.</div><div>As an event, a voltage drop to 0.2 pu&nbsp;</div><div>with 100ms duration is used.

The following image shows the voltage drop
and the model's P and Q responses.

<b>Active power response:</b> <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/IEC/Resources/Images/wppType3bUdropP.png\"></div><div><b><u><br></u></b></div><div><b>Reactive power response:</b> <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/IEC/Resources/Images/wppType3bUdropQ.png\"></div></div><div><b><u><br></u></b></div><div><b><u><br></u></b></div><div><b><u><br></u></b></div>
<div><b><u>Bug desription:</u></b></div><div>This model does not behave as exptected.</div><div>please see example WT3BCurrentSource2020.</div><div><br></div><!--EndFragment--></body></html>"));
end WPP3BCurrentSource2020;
