within Dynawo.Electrical.Wind.IEC.WPP;

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

model WPP3ACurrentSource2020 "Wind Power Plant Type 3A model from IEC 61400-27-1:2020 standard : WT3A, communication modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWPP;

  //Parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableQControl2020;
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWPP2020;
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWPP2020;
  extends Dynawo.Electrical.Wind.IEC.Parameters.GridMeasurementWPP;
  extends Dynawo.Electrical.Wind.IEC.Parameters.LinearCommunication;
  extends Dynawo.Electrical.Wind.IEC.Parameters.GridMeasurementControl;
  extends Dynawo.Electrical.Wind.IEC.Parameters.GridMeasurementProtection;
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT3;
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWT2020;
  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem3a;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.MechanicalParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.Aerodynamic2DParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.PitchAngleControlParameters;

  Dynawo.Electrical.Wind.IEC.WT.WT3ACurrentSource2020 wT3ACurrentSource(BesPu = BesPu, CdrtPu = CdrtPu, DPMaxPu = DPMaxPu, DPOmega0Pu = DPOmega0Pu, DPOmegaThetaPu = DPOmegaThetaPu, DPRefMax4abPu = DPRefMax4abPu, DPRefMin4abPu = DPRefMin4abPu, DPThetaPu = DPThetaPu, DTauMaxPu = DTauMaxPu, DTauUvrtMaxPu = DTauUvrtMaxPu, DThetaCMax = DThetaCMax, DThetaCMin = DThetaCMin, DThetaMax = DThetaMax, DThetaMin = DThetaMin, DThetaOmegaMax = DThetaOmegaMax, DThetaOmegaMin = DThetaOmegaMin, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, DfcMaxPu = DfcMaxPu, DfpMaxPu = DfpMaxPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, GesPu = GesPu, Hgen = Hgen, Hwtr = Hwtr, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, KDtd = KDtd, KIcPu = KIcPu, KIomegaPu = KIomegaPu, KIp = KIp, KPXPu = KPXPu, KPc = KPc, KPcPu = KPcPu, KPomegaPu = KPomegaPu, KPp = KPp, KdrtPu = KdrtPu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MOmegaTMax = MOmegaTMax, MOmegaTqpi = MOmegaTqpi, MPUvrt = MPUvrt, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, OmegaDtdPu = OmegaDtdPu, OmegaOffsetPu = OmegaOffsetPu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, PAvailPu = PAvailPu, PDtdMaxPu = PDtdMaxPu, PWTRef0Pu = PWTRef0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, ResPu = ResPu, SNom = SNom, TIc = TIc, TTheta = TTheta, TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt = TableIqMaxUwt, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableIqMaxUwt71 = TableIqMaxUwt71, TableIqMaxUwt72 = TableIqMaxUwt72, TableIqMaxUwt81 = TableIqMaxUwt81, TableIqMaxUwt82 = TableIqMaxUwt82, TableOmegaPPu = TableOmegaPPu, TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxPwtcFilt32 = TableQMaxPwtcFilt32, TableQMaxPwtcFilt41 = TableQMaxPwtcFilt41, TableQMaxPwtcFilt42 = TableQMaxPwtcFilt42, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinPwtcFilt11 = TableQMinPwtcFilt11, TableQMinPwtcFilt12 = TableQMinPwtcFilt12, TableQMinPwtcFilt21 = TableQMinPwtcFilt21, TableQMinPwtcFilt22 = TableQMinPwtcFilt22, TableQMinPwtcFilt31 = TableQMinPwtcFilt31, TableQMinPwtcFilt32 = TableQMinPwtcFilt32, TableQMinPwtcFilt41 = TableQMinPwtcFilt41, TableQMinPwtcFilt42 = TableQMinPwtcFilt42, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUoverUwtfilt41 = TabletUoverUwtfilt41, TabletUoverUwtfilt42 = TabletUoverUwtfilt42, TabletUoverUwtfilt51 = TabletUoverUwtfilt51, TabletUoverUwtfilt52 = TabletUoverUwtfilt52, TabletUoverUwtfilt61 = TabletUoverUwtfilt61, TabletUoverUwtfilt62 = TabletUoverUwtfilt62, TabletUoverUwtfilt71 = TabletUoverUwtfilt71, TabletUoverUwtfilt72 = TabletUoverUwtfilt72, TabletUoverUwtfilt81 = TabletUoverUwtfilt81, TabletUoverUwtfilt82 = TabletUoverUwtfilt82, TabletUunderUwtfilt = TabletUunderUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, TabletUunderUwtfilt41 = TabletUunderUwtfilt41, TabletUunderUwtfilt42 = TabletUunderUwtfilt42, TabletUunderUwtfilt51 = TabletUunderUwtfilt51, TabletUunderUwtfilt52 = TabletUunderUwtfilt52, TabletUunderUwtfilt61 = TabletUunderUwtfilt61, TabletUunderUwtfilt62 = TabletUunderUwtfilt62, TabletUunderUwtfilt71 = TabletUunderUwtfilt71, TabletUunderUwtfilt72 = TabletUunderUwtfilt72, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfoverfwtfilt41 = Tabletfoverfwtfilt41, Tabletfoverfwtfilt42 = Tabletfoverfwtfilt42, Tabletfunderfwtfilt = Tabletfunderfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, Tabletfunderfwtfilt41 = Tabletfunderfwtfilt41, Tabletfunderfwtfilt42 = Tabletfunderfwtfilt42, Tabletfunderfwtfilt51 = Tabletfunderfwtfilt51, Tabletfunderfwtfilt52 = Tabletfunderfwtfilt52, Tabletfunderfwtfilt61 = Tabletfunderfwtfilt61, Tabletfunderfwtfilt62 = Tabletfunderfwtfilt62, TauEMinPu = TauEMinPu, TauUscalePu = TauUscalePu, Theta0 = Theta0, ThetaCMax = ThetaCMax, ThetaCMin = ThetaCMin, ThetaMax = ThetaMax, ThetaMin = ThetaMin, ThetaOmegaMax = ThetaOmegaMax, ThetaOmegaMin = ThetaOmegaMin, U0Pu = U0Pu, UDvsPu = UDvsPu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UOverPu = UOverPu, UPhase0 = UPhase0, UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, URef0Pu = URef0Pu, UUnderPu = UUnderPu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XEqv = XEqv, XWT0Pu = XWT0Pu, XesPu = XesPu, Zeta = Zeta, fOverPu = fOverPu, fUnderPu = fUnderPu, i0Pu = i0Pu, tDvs = tDvs, tIcFilt = tIcFilt, tIpFilt = tIpFilt, tOmegaRef = tOmegaRef, tOmegafiltp3 = tOmegafiltp3, tPcFilt = tPcFilt, tPll = tPll, tPord = tPord, tPost = tPost, tPpFilt = tPpFilt, tQcFilt = tQcFilt, tQord = tQord, tQpFilt = tQpFilt, tS = tS, tUcFilt = tUcFilt, tUpFilt = tUpFilt, tUss = tUss, tfcFilt = tfcFilt, tfpFilt = tfpFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.WPP.WPPControl2020 wPPControl(
    // Init changes for Type 3 WT
    pControl.absLimRateLimFeedthroughFreezeLimDetection.Y0 = PWTRef0Pu,
    pControl.absLimRateLimFeedthroughFreezeLimDetection.U0 = PWTRef0Pu,
    pControl.rampLimiter.Y0 = PWTRef0Pu,
    pControl.antiWindupIntegrator.Y0 = (1 - KwppRef) * PWTRef0Pu,
    // passing parameters down
    DPRefMaxPu = DPRefMaxPu, DPRefMinPu = DPRefMinPu, DPwpRefMaxPu = DPwpRefMaxPu, DPwpRefMinPu = DPwpRefMinPu, DXRefMaxPu = DXRefMaxPu, DXRefMinPu = DXRefMinPu, DfMaxPu = DfMaxPu, Kiwpp = Kiwpp, Kiwpx = Kiwpx, Kpwpp = Kpwpp, Kpwpx = Kpwpx, KwppRef = KwppRef, KwpqRef = KwpqRef, Kwpqu = Kwpqu, MwpqMode = MwpqMode, P0Pu = P0Pu, PErrMaxPu = PErrMaxPu, PErrMinPu = PErrMinPu, PKiwppMaxPu = PKiwppMaxPu, PKiwppMinPu = PKiwppMinPu, PRefMaxPu = PRefMaxPu, PRefMinPu = PRefMinPu, Q0Pu = Q0Pu, RwpDropPu = RwpDropPu, SNom = SNom, TablePwpBiasfwpFiltCom = TablePwpBiasfwpFiltCom, TablePwpBiasfwpFiltCom11 = TablePwpBiasfwpFiltCom11, TablePwpBiasfwpFiltCom12 = TablePwpBiasfwpFiltCom12, TablePwpBiasfwpFiltCom21 = TablePwpBiasfwpFiltCom21, TablePwpBiasfwpFiltCom22 = TablePwpBiasfwpFiltCom22, TablePwpBiasfwpFiltCom31 = TablePwpBiasfwpFiltCom31, TablePwpBiasfwpFiltCom32 = TablePwpBiasfwpFiltCom32, TablePwpBiasfwpFiltCom41 = TablePwpBiasfwpFiltCom41, TablePwpBiasfwpFiltCom42 = TablePwpBiasfwpFiltCom42, TablePwpBiasfwpFiltCom51 = TablePwpBiasfwpFiltCom51, TablePwpBiasfwpFiltCom52 = TablePwpBiasfwpFiltCom52, TablePwpBiasfwpFiltCom61 = TablePwpBiasfwpFiltCom61, TablePwpBiasfwpFiltCom62 = TablePwpBiasfwpFiltCom62, TablePwpBiasfwpFiltCom71 = TablePwpBiasfwpFiltCom71, TablePwpBiasfwpFiltCom72 = TablePwpBiasfwpFiltCom72, TableQwpMaxPwpFiltCom = TableQwpMaxPwpFiltCom, TableQwpMaxPwpFiltCom11 = TableQwpMaxPwpFiltCom11, TableQwpMaxPwpFiltCom12 = TableQwpMaxPwpFiltCom12, TableQwpMaxPwpFiltCom21 = TableQwpMaxPwpFiltCom21, TableQwpMaxPwpFiltCom22 = TableQwpMaxPwpFiltCom22, TableQwpMaxPwpFiltCom31 = TableQwpMaxPwpFiltCom31, TableQwpMaxPwpFiltCom32 = TableQwpMaxPwpFiltCom32, TableQwpMinPwpFiltCom = TableQwpMinPwpFiltCom, TableQwpMinPwpFiltCom11 = TableQwpMinPwpFiltCom11, TableQwpMinPwpFiltCom12 = TableQwpMinPwpFiltCom12, TableQwpMinPwpFiltCom21 = TableQwpMinPwpFiltCom21, TableQwpMinPwpFiltCom22 = TableQwpMinPwpFiltCom22, TableQwpMinPwpFiltCom31 = TableQwpMinPwpFiltCom31, TableQwpMinPwpFiltCom32 = TableQwpMinPwpFiltCom32, TableQwpUErr = TableQwpUErr, TableQwpUErr11 = TableQwpUErr11, TableQwpUErr12 = TableQwpUErr12, TableQwpUErr21 = TableQwpUErr21, TableQwpUErr22 = TableQwpUErr22, TableQwpUErr31 = TableQwpUErr31, TableQwpUErr32 = TableQwpUErr32, U0Pu = U0Pu, UPhase0 = UPhase0, UwpqDipPu = UwpqDipPu, UwpqRisePu = UwpqRisePu, X0Pu = X0Pu, XErrMaxPu = XErrMaxPu, XErrMinPu = XErrMinPu, XKiwpxMaxPu = XKiwpxMaxPu, XKiwpxMinPu = XKiwpxMinPu, XRefMaxPu = XRefMaxPu, XRefMinPu = XRefMinPu, XWT0Pu = XWT0Pu, XwpDropPu = XwpDropPu, i0Pu = i0Pu, tIFilt = tIFilt, tLag = tLag, tLead = tLead, tPFilt = tPFilt, tQFilt = tQFilt, tS = tS, tUFilt = tUFilt, tUqFilt = tUqFilt, tfFilt = tfFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput xWPRefPu(start = X0Pu) "Reference reactive power or voltage in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -19.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(wT3ACurrentSource.terminal, elecMeasurements.terminal1) annotation(
    Line(points = {{42, 0}, {58, 0}}, color = {0, 0, 255}));
  connect(tanPhi, wT3ACurrentSource.tanPhi) annotation(
    Line(points = {{-20, 120}, {-20, 12}, {-2, 12}}, color = {0, 0, 127}));
  connect(omegaRefPu, wT3ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-140, -40}, {-20, -40}, {-20, -12}, {-2, -12}}, color = {0, 0, 127}));
  connect(omegaRefPu, wPPControl.omegaRefPu) annotation(
    Line(points = {{-140, -40}, {-100, -40}, {-100, -16}, {-82, -16}}, color = {0, 0, 127}));
  connect(xWPRefPu, wPPControl.xWPRefPu) annotation(
    Line(points = {{-140, 0}, {-100, 0}, {-100, 8}, {-82, 8}}, color = {0, 0, 127}));
  connect(PWPRefPu, wPPControl.PWPRefPu) annotation(
    Line(points = {{-140, 40}, {-100, 40}, {-100, 18}, {-82, 18}}, color = {0, 0, 127}));
  connect(elecMeasurements.iPu, wPPControl.iPu) annotation(
    Line(points = {{72, -22}, {72, -30}, {-90, -30}, {-90, -8}, {-82, -8}}, color = {85, 170, 255}));
  connect(elecMeasurements.uPu, wPPControl.uPu) annotation(
    Line(points = {{88, -22}, {88, -34}, {-94, -34}, {-94, 0}, {-82, 0}}, color = {85, 170, 255}));
  connect(wPPControl.PPDRefComPu, wT3ACurrentSource.PWTRefPu) annotation(
    Line(points = {{-38, 8}, {-26, 8}, {-26, 4}, {-2, 4}}, color = {0, 0, 127}));
  connect(wPPControl.xPDRefComPu, wT3ACurrentSource.xWTRefPu) annotation(
    Line(points = {{-38, -8}, {-26, -8}, {-26, -4}, {-2, -4}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {1, -30}, extent = {{-73, 35}, {73, -35}}, textString = "Type 3A
2020")}));
end WPP3ACurrentSource2020;
