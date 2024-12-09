within Dynawo.Examples.Wind.IEC;

package SMIB "SMIB tests for IEC WT models"
  
  model WT3ACurrentSource2020 "Wind Turbine Type 3A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
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
    extends Icons.Example;
    Dynawo.Electrical.Wind.IEC.WT.WT3ACurrentSource2020 wt(BesPu = 0, CdrtPu = 0.3, DPMaxPu = 999, DPOmega0Pu = 0.48, DPOmegaThetaPu = 0.028, DPRefMax4abPu = 0.3, DPRefMin4abPu = -0.3, DPThetaPu = -0.03, DTauMaxPu = 0.25, DTauUvrtMaxPu = 0, DThetaCmax = 6, DThetaCmin = -3, DThetaMax = 6, DThetaMin = -3, DThetaOmegamax = 6, DThetaOmegamin = -3, DUdb1Pu = -0.1, DUdb2Pu = 0.1, DfcMaxPu = 1, DfpMaxPu = 1, DipMaxPu = 9999, DiqMaxPu = 9999, GesPu = 0, Hgen = 5, Hwtr = 5, IGsIm0Pu = 0, IGsRe0Pu = 1, IMaxDipPu = 1.3, IMaxPu = 1.3, IpMax0Pu = 1.00005, IqH1Pu = 1.05, IqMax0Pu = 0.33, IqMaxPu = 1.05, IqMin0Pu = -0.33, IqMinPu = -1.05, IqPostPu = 0, KDtd = 1.5, KIcPu = 1e-9, KIomegaPu = 15, KIp = 5, KPXPu = 0.03, KPc = 40, KPcPu = 0, KPomegaPu = 15, KPp = 8, KdrtPu = 200, Kiq = 2, Kiu = 2, Kpq = 0, Kpqu = 20, Kpu = 2, Kpufrt = 1e-6, Kqv = 2, MOmegaTMax = true, MOmegaTqpi = true, MPUvrt = true, MdfsLim = false, MpUScale = false, MqG = 1, Mqfrt = 2, Mqpri = true, OmegaDtdPu = 11.3, OmegaOffsetPu = 0, P0Pu = -1, PAg0Pu = 1, PAvailPu = 1, PBaseMeasurement = SystemBase.SnRef, PDtdMaxPu = 0.15, Q0Pu = 0, QMax0Pu = 0.8, QMaxPu = 0.8, QMin0Pu = -0.8, QMinPu = -0.8, QlConst = true, RDropPu = 0, ResPu = 0, SNom = 100, TIc = 0.02, TTheta = 0.25, TauEMinPu = 0.001, TauUscalePu = 1, Theta0 = 0, ThetaCmax = 35, ThetaCmin = 0, ThetaMax = 35, ThetaMin = 0, ThetaOmegamax = 35, ThetaOmegamin = 0, U0Pu = 1, UDvsPu = 0.15, UGsIm0Pu = 0.1, UGsRe0Pu = 1, UMaxPu = 2, UMinPu = 0, UOverPu = 1.2, UPhase0 = 0, UPll1Pu = 999, UPll2Pu = 0.13, URef0Pu = 0, UUnderPu = 0.85, UpDipPu = 0.9, UpquMaxPu = 1.1, UqDipPu = 0.9, UqRisePu = 1.1, XDropPu = 0, XEqv = 0.4, XWT0Pu = -0, XesPu = 0.1, Zeta = 0.5, fOverPu = 1.02, fUnderPu = 0.98, i0Pu = Complex(-1, 0), tDvs = 0.05, tIcFilt = 0.01, tIpFilt = 0.01, tOmegaRef = 0.005, tOmegafiltp3 = 0.005, tPcFilt = 0.01, tPll = 0.01, tPord = 0.01, tPost = 1e-6, tPpFilt = 0.01, tQcFilt = 0.01, tQord = 1e-6, tQpFilt = 0.01, tS = 1e-6, tUcFilt = 0.01, tUpFilt = 0.01, tUss = 30, tfcFilt = 0.01, tfpFilt = 0.01, u0Pu = Complex(1, 0)) annotation(
      Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 0.2, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 999, tOmegaEvtStart = 999, tUEvtEnd = 0.25, tUEvtStart = 0.1) annotation(
      Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = -1, startTime = 999) annotation(
      Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Step xRefPu(height = 0.2, offset = 0, startTime = 999) annotation(
      Placement(visible = true, transformation(origin = {-170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Pulse omegaRefPu(amplitude = -0.01, nperiod = 1, offset = 1, period = 2, startTime = 999) annotation(
      Placement(visible = true, transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Step PRefPu(height = -0.2, offset = 1, startTime = 999) annotation(
      Placement(visible = true, transformation(origin = {-170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Electrical.Wind.IEC.WT.WT3CurrentSource_INIT init(BesPu = wt.BesPu, GesPu = wt.GesPu, IMaxDipPu = wt.IMaxDipPu, IMaxPu = wt.IMaxPu, Kpqu = wt.Kpqu, MdfsLim = wt.MdfsLim, MqG = wt.MqG, Mqpri = wt.Mqpri, P0Pu = wt.P0Pu, Q0Pu = wt.Q0Pu, QMaxPu = wt.QMaxPu, QMinPu = wt.QMinPu, QlConst = wt.QlConst, ResPu = wt.ResPu, SNom = wt.SNom, TableIpMaxUwt = wt.TableIpMaxUwt, TableIqMaxUwt = wt.TableIqMaxUwt, TableQMaxPwtcFilt = wt.TableQMaxPwtcFilt, TableQMaxUwtcFilt = wt.TableQMaxUwtcFilt, TableQMinPwtcFilt = wt.TableQMinPwtcFilt, TableQMinUwtcFilt = wt.TableQMinUwtcFilt, U0Pu = wt.U0Pu, UPhase0 = wt.UPhase0, UpquMaxPu = wt.UpquMaxPu, XesPu = wt.XesPu) annotation(
      Placement(visible = true, transformation(origin = {-14, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    wt.injector.switchOffSignal1.value = false;
    wt.injector.switchOffSignal2.value = false;
    wt.injector.switchOffSignal3.value = false;
    connect(omegaRefPu.y, wt.omegaRefPu) annotation(
      Line(points = {{-159, -60}, {-146, -60}, {-146, -6}, {-91, -6}}, color = {0, 0, 127}));
    connect(xRefPu.y, wt.xWTRefPu) annotation(
      Line(points = {{-158, -20}, {-150, -20}, {-150, -2}, {-91, -2}}, color = {0, 0, 127}));
    connect(PRefPu.y, wt.PWTRefPu) annotation(
      Line(points = {{-158, 20}, {-150, 20}, {-150, 2}, {-91, 2}}, color = {0, 0, 127}));
    connect(tanPhi.y, wt.tanPhi) annotation(
      Line(points = {{-158, 60}, {-146, 60}, {-146, 6}, {-91, 6}}, color = {0, 0, 127}));
    connect(wt.terminal, infiniteBusWithVariations.terminal) annotation(
      Line(points = {{-68, 0}, {80, 0}}, color = {0, 0, 255}));
    annotation(
      preferredView = "diagram",
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001),
      __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
      Diagram(coordinateSystem(extent = {{-140, -70}, {140, 70}})),
      __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
  end WT3ACurrentSource2020;
  
  model WT3BCurrentSource2020 "Wind Turbine Type 3A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
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
    extends Icons.Example;
    Dynawo.Electrical.Wind.IEC.WT.WT3BCurrentSource2020 wt(BesPu = 0, CdrtPu = 0.3, DPMaxPu = 999, DPOmega0Pu = 0.48, DPOmegaThetaPu = 0.028, DPRefMax4abPu = 0.3, DPRefMin4abPu = -0.3, DPThetaPu = -0.03, DTauMaxPu = 0.25, DTauUvrtMaxPu = 0, DThetaCmax = 6, DThetaCmin = -3, DThetaMax = 6, DThetaMin = -3, DThetaOmegamax = 6, DThetaOmegamin = -3, DUdb1Pu = -0.1, DUdb2Pu = 0.1, DfcMaxPu = 1, DfpMaxPu = 1, DipMaxPu = 1, DiqMaxPu = 100, GesPu = 0, Hgen = 5, Hwtr = 5, IGsIm0Pu = 0, IGsRe0Pu = 1, IMaxDipPu = 1.3, IMaxPu = 1.3, IpMax0Pu = 1.00005, IqH1Pu = 1.05, IqMax0Pu = 0.33, IqMaxPu = 1.05, IqMin0Pu = -0.33, IqMinPu = -1.05, IqPostPu = 0, KDtd = 1.5, KIcPu = 1e-9, KIomegaPu = 15, KIp = 5, KPXPu = 0.03, 
  KPcPu = 0, KPomegaPu = 15, KPp = 8, KdrtPu = 200, Kiq = 2, Kiu = 2, Kpq = 0, Kpqu = 20, Kpu = 2, Kpufrt = 1e-6, Kqv = 2, MCrb = false, MOmegaTMax = true, MOmegaTqpi = true, MPUvrt = true, MdfsLim = false, MpUScale = false, MqG = 1, Mqfrt = 2, Mqpri = true, OmegaDtdPu = 11.3, OmegaOffsetPu = 0, P0Pu = -1, PAg0Pu = 1, PAvailPu = 1, PBaseMeasurement = SystemBase.SnRef, PDtdMaxPu = 0.15, Q0Pu = 0, QMax0Pu = 0.8, QMaxPu = 0.8, QMin0Pu = -0.8, QMinPu = -0.8, QlConst = true, RDropPu = 0, ResPu = 0, SNom = 100, TTheta = 0.25, TauEMinPu = 0.001, TauUscalePu = 1, Theta0 = 0, ThetaCmax = 35, ThetaCmin = 0, ThetaMax = 35, ThetaMin = 0, ThetaOmegamax = 35, ThetaOmegamin = 0, U0Pu = 1, UDvsPu = 0.15, UGsIm0Pu = 0.1, UGsRe0Pu = 1, UMaxPu = 2, UMinPu = 0, UOverPu = 1.2, UPhase0 = 0, UPll1Pu = 999, UPll2Pu = 0.13, URef0Pu = 0, UUnderPu = 0.85, UpDipPu = 0.9, UpquMaxPu = 1.1, UqDipPu = 0.9, UqRisePu = 1.1, XDropPu = 0, XEqv = 10, XWT0Pu = -0, XesPu = 0.1, Zeta = 0.5, fOverPu = 1.02, fUnderPu = 0.98, i0Pu = Complex(-1, 0), tDvs = 0.05, tG = 0.01, tIcFilt = 0.01, tIpFilt = 0.01, tOmegaRef = 0.005, tOmegafiltp3 = 0.005, tPcFilt = 0.01, tPll = 0.01, tPord = 0.01, tPost = 1e-6, tPpFilt = 0.01, tQcFilt = 0.01, tQord = 1e-6, tQpFilt = 0.01, tS = 1e-6, tUcFilt = 0.01, tUpFilt = 0.01, tUss = 30, tWo = 0.001, tfcFilt = 0.01, tfpFilt = 0.01, u0Pu = Complex(1, 0)) annotation(
      Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 0.2, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 999, tOmegaEvtStart = 999, tUEvtEnd = 0.25, tUEvtStart = 0.1) annotation(
      Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = -1, startTime = 999) annotation(
      Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Step xRefPu(height = 0.2, offset = 0, startTime = 999) annotation(
      Placement(visible = true, transformation(origin = {-170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Pulse omegaRefPu(amplitude = -0.01, nperiod = 1, offset = 1, period = 2, startTime = 999) annotation(
      Placement(visible = true, transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Step PRefPu(height = -0.2, offset = 1, startTime = 999) annotation(
      Placement(visible = true, transformation(origin = {-170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Electrical.Wind.IEC.WT.WT3CurrentSource_INIT init(BesPu = wt.BesPu, GesPu = wt.GesPu, IMaxDipPu = wt.IMaxDipPu, IMaxPu = wt.IMaxPu, Kpqu = wt.Kpqu, MdfsLim = wt.MdfsLim, MqG = wt.MqG, Mqpri = wt.Mqpri, P0Pu = wt.P0Pu, Q0Pu = wt.Q0Pu, QMaxPu = wt.QMaxPu, QMinPu = wt.QMinPu, QlConst = wt.QlConst, ResPu = wt.ResPu, SNom = wt.SNom, TableIpMaxUwt = wt.TableIpMaxUwt, TableIqMaxUwt = wt.TableIqMaxUwt, TableQMaxPwtcFilt = wt.TableQMaxPwtcFilt, TableQMaxUwtcFilt = wt.TableQMaxUwtcFilt, TableQMinPwtcFilt = wt.TableQMinPwtcFilt, TableQMinUwtcFilt = wt.TableQMinUwtcFilt, U0Pu = wt.U0Pu, UPhase0 = wt.UPhase0, UpquMaxPu = wt.UpquMaxPu, XesPu = wt.XesPu) annotation(
      Placement(visible = true, transformation(origin = {-14, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    wt.injector.switchOffSignal1.value = false;
    wt.injector.switchOffSignal2.value = false;
    wt.injector.switchOffSignal3.value = false;
    connect(omegaRefPu.y, wt.omegaRefPu) annotation(
      Line(points = {{-159, -60}, {-146, -60}, {-146, -6}, {-91, -6}}, color = {0, 0, 127}));
    connect(xRefPu.y, wt.xWTRefPu) annotation(
      Line(points = {{-158, -20}, {-150, -20}, {-150, -2}, {-91, -2}}, color = {0, 0, 127}));
    connect(PRefPu.y, wt.PWTRefPu) annotation(
      Line(points = {{-158, 20}, {-150, 20}, {-150, 2}, {-91, 2}}, color = {0, 0, 127}));
    connect(tanPhi.y, wt.tanPhi) annotation(
      Line(points = {{-158, 60}, {-146, 60}, {-146, 6}, {-91, 6}}, color = {0, 0, 127}));
    connect(wt.terminal, infiniteBusWithVariations.terminal) annotation(
      Line(points = {{-68, 0}, {80, 0}}, color = {0, 0, 255}));
    annotation(
      preferredView = "diagram",
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001),
      __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
      Diagram(coordinateSystem(extent = {{-140, -70}, {140, 70}})),
      __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
  end WT3BCurrentSource2020;
  extends Icons.Package;
end SMIB;
