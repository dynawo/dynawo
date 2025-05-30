within Dynawo.Electrical.Wind.IEC.WT;

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

model WT3ACurrentSource2020 "Wind Turbine Type 4A model from IEC 61400-27-1:2020 standard"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWTCurrentSource2020(pll.tS = tS, pll.tPll = tPll);

  // Parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem3a;
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT3;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.MechanicalParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.Aerodynamic2DParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.PitchAngleControlParameters;

  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.Mechanical mechanical(CdrtPu = CdrtPu, Hgen = Hgen, Hwtr = Hwtr, KdrtPu = KdrtPu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control3A2020 control(
    //adapt init for WT Type 3A
    pControl3AB2020.lagPOrd.Y0 = -P0Pu * SystemBase.SnRef / SNom,
    pControl3AB2020.torquePi.integratorKIpKPp.Y0 = control.pControl3AB2020.torquePi.PiIntegrator0Type3aPu,
    pControl3AB2020.torquePi.ratelimResetvalue.Y0 = control.pControl3AB2020.torquePi.ratelimResetvalue0Type3a,
    qControl.antiWindupIntegrator1.Y0 = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu),
    // pass other parameters
    DPMaxPu = DPMaxPu, DPRefMax4abPu = DPRefMax4abPu, DPRefMin4abPu = DPRefMin4abPu, DTauMaxPu = DTauMaxPu, DTauUvrtMaxPu = DTauUvrtMaxPu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, KDtd = KDtd, KIp = KIp, KPp = KPp, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MOmegaTMax = MOmegaTMax, MOmegaTqpi = MOmegaTqpi, MPUvrt = MPUvrt, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, OmegaDtdPu = OmegaDtdPu, OmegaOffsetPu = OmegaOffsetPu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, PDtdMaxPu = PDtdMaxPu, PWTRef0Pu = PWTRef0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableIqMaxUwt71 = TableIqMaxUwt71, TableIqMaxUwt72 = TableIqMaxUwt72, TableIqMaxUwt81 = TableIqMaxUwt81, TableIqMaxUwt82 = TableIqMaxUwt82, TableOmegaPPu = TableOmegaPPu, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxPwtcFilt32 = TableQMaxPwtcFilt32, TableQMaxPwtcFilt41 = TableQMaxPwtcFilt41, TableQMaxPwtcFilt42 = TableQMaxPwtcFilt42, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinPwtcFilt11 = TableQMinPwtcFilt11, TableQMinPwtcFilt12 = TableQMinPwtcFilt12, TableQMinPwtcFilt21 = TableQMinPwtcFilt21, TableQMinPwtcFilt22 = TableQMinPwtcFilt22, TableQMinPwtcFilt31 = TableQMinPwtcFilt31, TableQMinPwtcFilt32 = TableQMinPwtcFilt32, TableQMinPwtcFilt41 = TableQMinPwtcFilt41, TableQMinPwtcFilt42 = TableQMinPwtcFilt42, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, TauEMinPu = TauEMinPu, TauUscalePu = TauUscalePu, U0Pu = U0Pu, UDvsPu = UDvsPu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XEqv = XEqv, XWT0Pu = XWT0Pu, Zeta = Zeta, tDvs = tDvs, tOmegaRef = tOmegaRef, tOmegafiltp3 = tOmegafiltp3, tPord = tPord, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {-58, -38}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.WT3AInjector injector(KPc = KPc, TIc = TIc, XEqv = XEqv, BesPu = BesPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, XesPu = XesPu, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {14, -38}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Controls.IEC.IEC61400.BaseControls.WT.Aerodynamic2D aerodynamic2d(DPOmega0Pu = DPOmega0Pu, DPOmegaThetaPu = DPOmegaThetaPu, DPThetaPu = DPThetaPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, PAvailPu = PAvailPu, Theta0 = Theta0, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu) annotation(
    Placement(visible = true, transformation(origin = {-34, -94}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Controls.IEC.IEC61400.BaseControls.WT.PitchAngleControl pitchAngleControl(
    //initial theta
    firstOrderTheta(Y0 = Theta0 + (PAg0Pu - PAvailPu) / DPThetaPu), integratorPiOmega(Y0 = Theta0 + (PAg0Pu - PAvailPu) / DPThetaPu), thetaOmegaRateLim(y_start = Theta0 + (PAg0Pu - PAvailPu) / DPThetaPu),
    //pass other parameters
    DThetaCMax = DThetaCMax, DThetaCMin = DThetaCMin, DThetaMax = DThetaMax, DThetaMin = DThetaMin, DThetaOmegaMax = DThetaOmegaMax, DThetaOmegaMin = DThetaOmegaMin, KIcPu = KIcPu, KIomegaPu = KIomegaPu, KPXPu = KPXPu, KPcPu = KPcPu, KPomegaPu = KPomegaPu, P0Pu = P0Pu, PWTRef0Pu = PWTRef0Pu, SNom = SNom, TTheta = TTheta, ThetaCMax = ThetaCMax, ThetaCMin = ThetaCMin, ThetaMax = ThetaMax, ThetaMin = ThetaMin, ThetaOmegaMax = ThetaOmegaMax, ThetaOmegaMin = ThetaOmegaMin) annotation(
    Placement(visible = true, transformation(origin = {-78, -96}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));

  //Initial parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPAg;

equation
  connect(control.ipMaxPu, injector.ipMaxPu) annotation(
    Line(points = {{-34, -30}, {-28, -30}, {-28, -21}, {-10, -21}}, color = {0, 0, 127}));
  connect(control.ipCmdPu, injector.ipCmdPu) annotation(
    Line(points = {{-34, -34}, {-24, -34}, {-24, -30}, {-10, -30}}, color = {0, 0, 127}));
  connect(control.iqMaxPu, injector.iqMaxPu) annotation(
    Line(points = {{-34, -42}, {-22, -42}, {-22, -38}, {-10, -38}}, color = {0, 0, 127}));
  connect(control.iqCmdPu, injector.iqCmdPu) annotation(
    Line(points = {{-34, -46}, {-10, -46}}, color = {0, 0, 127}));
  connect(control.iqMinPu, injector.iqMinPu) annotation(
    Line(points = {{-34, -50}, {-22, -50}, {-22, -56}, {-10, -56}}, color = {0, 0, 127}));
  connect(control.PWTRefPu, PWTRefPu) annotation(
    Line(points = {{-82, -20}, {-130, -20}}, color = {0, 0, 127}));
  connect(control.PWTCFiltPu, controlMeasurements.PFiltPu) annotation(
    Line(points = {{-82, -24}, {-96, -24}, {-96, 58}}, color = {0, 0, 127}));
  connect(control.QWTCFiltPu, controlMeasurements.QFiltPu) annotation(
    Line(points = {{-82, -56}, {-92, -56}, {-92, 58}}, color = {0, 0, 127}));
  connect(control.UWTCPu, controlMeasurements.UPu) annotation(
    Line(points = {{-82, -32}, {-90, -32}, {-90, 44}, {-80, 44}, {-80, 58}}, color = {0, 0, 127}));
  connect(control.UWTCFiltPu, controlMeasurements.UFiltPu) annotation(
    Line(points = {{-82, -36}, {-88, -36}, {-88, 42}, {-76, 42}, {-76, 58}}, color = {0, 0, 127}));
  connect(control.tanPhi, tanPhi) annotation(
    Line(points = {{-82, -44}, {-112, -44}, {-112, -40}, {-130, -40}}, color = {0, 0, 127}));
  connect(control.xWTRefPu, xWTRefPu) annotation(
    Line(points = {{-82, -50}, {-104, -50}, {-104, -60}, {-130, -60}}, color = {0, 0, 127}));
  connect(mechanical.omegaGenPu, control.omegaGenPu) annotation(
    Line(points = {{102, -72}, {106, -72}, {106, -6}, {-58, -6}, {-58, -14}}, color = {0, 0, 127}));
  connect(gridProtection.fOCB, injector.fOCB) annotation(
    Line(points = {{60, -2}, {60, -8}, {14, -8}, {14, -14}}, color = {255, 0, 255}));
  connect(pll.thetaPll, injector.theta) annotation(
    Line(points = {{-20, 54}, {-20, 24}, {0, 24}, {0, -14}}, color = {0, 0, 127}));
  connect(injector.terminal, terminal) annotation(
    Line(points = {{38, -38}, {83, -38}, {83, -40}, {130, -40}}, color = {0, 0, 255}));
  connect(injector.iWtPu, protectionMeasurements.iPu) annotation(
    Line(points = {{38, -20}, {86, -20}, {86, 110}, {60, 110}, {60, 102}}, color = {85, 170, 255}));
  connect(injector.iWtPu, controlMeasurements.iPu) annotation(
    Line(points = {{38, -20}, {86, -20}, {86, 110}, {-80, 110}, {-80, 102}}, color = {85, 170, 255}));
  connect(injector.uWtPu, controlMeasurements.uPu) annotation(
    Line(points = {{38, -24}, {88, -24}, {88, 114}, {-92, 114}, {-92, 102}}, color = {85, 170, 255}));
  connect(injector.uWtPu, protectionMeasurements.uPu) annotation(
    Line(points = {{38, -24}, {88, -24}, {88, 114}, {72, 114}, {72, 102}}, color = {85, 170, 255}));
  connect(mechanical.omegaWTRPu, control.omegaWTRPu) annotation(
    Line(points = {{102, -88}, {108, -88}, {108, -4}, {-64, -4}, {-64, -14}}, color = {0, 0, 127}));
  connect(mechanical.omegaWTRPu, aerodynamic2d.omegaWTRPu) annotation(
    Line(points = {{102, -88}, {108, -88}, {108, -118}, {-58, -118}, {-58, -102}, {-48, -102}}, color = {0, 0, 127}));
  connect(PWTRefPu, pitchAngleControl.pWTrefPu) annotation(
    Line(points = {{-130, -20}, {-116, -20}, {-116, -78}, {-118, -78}, {-118, -106}, {-92, -106}}, color = {0, 0, 127}));
  connect(control.POrdPu, pitchAngleControl.POrdPu) annotation(
    Line(points = {{-50, -62}, {-50, -74}, {-112, -74}, {-112, -100}, {-92, -100}}, color = {0, 0, 127}));
  connect(control.omegaRefPu, pitchAngleControl.omegaRefPu) annotation(
    Line(points = {{-34, -22}, {-32, -22}, {-32, -14}, {-18, -14}, {-18, -76}, {-110, -76}, {-110, -92}, {-92, -92}}, color = {0, 0, 127}));
  connect(mechanical.omegaWTRPu, pitchAngleControl.omegaWTRPu) annotation(
    Line(points = {{102, -88}, {108, -88}, {108, -118}, {-116, -118}, {-116, -86}, {-92, -86}}, color = {0, 0, 127}));
  connect(pitchAngleControl.theta, aerodynamic2d.theta) annotation(
    Line(points = {{-64.8, -95.76}, {-53.8, -95.76}, {-53.8, -86.76}, {-47.8, -86.76}}, color = {0, 0, 127}));
  connect(injector.PAgPu, mechanical.PAgPu) annotation(
    Line(points = {{38, -56}, {44, -56}, {44, -72}, {58, -72}}, color = {0, 0, 127}));
  connect(aerodynamic2d.pAeroPu, mechanical.PAeroPu) annotation(
    Line(points = {{-20, -94}, {40, -94}, {40, -88}, {58, -88}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {-4, -21}, extent = {{-51, 41}, {56, -41}}, textString = "Type 3A")}));
end WT3ACurrentSource2020;
