within Dynawo.Electrical.Wind.IEC.WPP;

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

model WPP4ACurrentSource2015 "Wind Power Plant Type 4A model from IEC 61400-27-1:2015 standard : WT4A, communication modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWPP;

  //Uf measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));

  //WT PControl parameters
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tUFiltP4A "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "PControl"));

  //Current limiter parameters
  parameter Types.Time tUFiltcl "Voltage filter time constant in s" annotation(
    Dialog(tab = "CurrentLimiter"));

  //WT QControl parameters
  parameter Integer MqUvrt "UVRT Q control modes (0-2) (see Table 23, section 5.6.5.7, page 51 of the IEC norm N°61400-27-1:2015)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tPFiltQ "Active power filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUFiltQ "Voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu Udb1Pu "Voltage dead band lower limit in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu Udb2Pu "Voltage dead band upper limit in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //Qlimiter parameters
  parameter Types.Time tPFiltql "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.Time tUFiltql "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "QLimiter"));

  //WPP PControl parameters
  parameter Types.Time tpft "Lead time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tpfv "Lag time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tWPfFiltP "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tWPPFiltP "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "PControlWP"));

  //WPP QControl parameters
  parameter Types.Time tWPPFiltQ "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tWPQFiltQ "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tWPUFiltQ "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time txft "Lead time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time txfv "Lag time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "QControlWP"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput QWPRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reference reactive power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWPRefPu(start = U0Pu) "Reference voltage in pu (base UNom) (generator convention)" annotation(

    Placement(visible = true, transformation(origin = {-140, 12}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Wind.IEC.WT.WT4ACurrentSource2015 wT4ACurrentSource(BesPu = BesPu, DPMaxP4APu = DPMaxP4APu, DfMaxPu = DfMaxPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kipaw = Kipaw, Kiq = Kiq, Kiqaw = Kiqaw, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kqv = Kqv, MdfsLim = MdfsLim, MqG = MqG, MqUvrt = MqUvrt, Mqpri = Mqpri, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, ResPu = ResPu, SNom = SNom, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUoverUwtfilt11= TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUunderUwtfilt = TabletUunderUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfunderfwtfilt = Tabletfunderfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UOverPu = UOverPu, UPhase0 = UPhase0, UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, URef0Pu = URef0Pu, UUnderPu = UUnderPu, Udb1Pu = Udb1Pu, Udb2Pu = Udb2Pu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, XesPu = XesPu, fOverPu = fOverPu, fUnderPu = fUnderPu, i0Pu = i0Pu, tG = tG, tPFiltQ = tPFiltQ, tPFiltql = tPFiltql, tPOrdP4A = tPOrdP4A, tPll = tPll, tPost = tPost, tQord = tQord, tS = tS, tUFilt = tUFilt, tUFiltP4A = tUFiltP4A, tUFiltQ = tUFiltQ, tUFiltcl = tUFiltcl, tUFiltql = tUFiltql, tfFilt = tfFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.WPP.WPPControl2015 wPPControl2015(DPRefMaxPu = DPRefMaxPu, DPRefMinPu = DPRefMinPu, DPwpRefMaxPu = DPwpRefMaxPu, DPwpRefMinPu = DPwpRefMinPu, DXRefMaxPu = DXRefMaxPu, DXRefMinPu = DXRefMinPu, Kiwpp = Kiwpp, Kiwpx = Kiwpx, XKiwpxMaxPu = XKiwpxMaxPu, XKiwpxMinPu = XKiwpxMinPu, Kpwpp = Kpwpp, Kpwpx = Kpwpx, KwppRef = KwppRef, KwpqRef = KwpqRef, Kwpqu = Kwpqu, MwpqMode = MwpqMode, P0Pu = P0Pu, PKiwppMaxPu = PKiwppMaxPu, PKiwppMinPu = PKiwppMinPu, PRefMaxPu = PRefMaxPu, PRefMinPu = PRefMinPu, Q0Pu = Q0Pu,SNom = SNom, TablePwpBiasfwpFiltCom = TablePwpBiasfwpFiltCom, TablePwpBiasfwpFiltCom11 = TablePwpBiasfwpFiltCom11, TablePwpBiasfwpFiltCom12 = TablePwpBiasfwpFiltCom12, TablePwpBiasfwpFiltCom21 = TablePwpBiasfwpFiltCom21, TablePwpBiasfwpFiltCom22 = TablePwpBiasfwpFiltCom22, TablePwpBiasfwpFiltCom31 = TablePwpBiasfwpFiltCom31, TablePwpBiasfwpFiltCom32 = TablePwpBiasfwpFiltCom32, TableQwpMaxPwpFiltCom = TableQwpMaxPwpFiltCom, TableQwpMaxPwpFiltCom11 = TableQwpMaxPwpFiltCom11, TableQwpMaxPwpFiltCom12 = TableQwpMaxPwpFiltCom12, TableQwpMaxPwpFiltCom21 = TableQwpMaxPwpFiltCom21, TableQwpMaxPwpFiltCom22 = TableQwpMaxPwpFiltCom22, TableQwpMaxPwpFiltCom31 = TableQwpMaxPwpFiltCom31, TableQwpMaxPwpFiltCom32 = TableQwpMaxPwpFiltCom32, TableQwpMinPwpFiltCom = TableQwpMinPwpFiltCom, TableQwpMinPwpFiltCom11 = TableQwpMinPwpFiltCom11, TableQwpMinPwpFiltCom12 = TableQwpMinPwpFiltCom12, TableQwpMinPwpFiltCom21 = TableQwpMinPwpFiltCom21, TableQwpMinPwpFiltCom22 = TableQwpMinPwpFiltCom22, TableQwpMinPwpFiltCom31 = TableQwpMinPwpFiltCom31, TableQwpMinPwpFiltCom32 = TableQwpMinPwpFiltCom32, TableQwpUErr = TableQwpUErr, TableQwpUErr11 = TableQwpUErr11, TableQwpUErr12 = TableQwpUErr12, TableQwpUErr21 = TableQwpUErr21, TableQwpUErr22 = TableQwpUErr22, TableQwpUErr31 = TableQwpUErr31, TableQwpUErr32 = TableQwpUErr32, U0Pu = U0Pu, UPhase0 = UPhase0, UwpqDipPu = UwpqDipPu, X0Pu = X0Pu, XRefMaxPu = XRefMaxPu, XRefMinPu = XRefMinPu, XWT0Pu = XWT0Pu, i0Pu = i0Pu, tS = tS, tUqFilt = tUqFilt, tWPPFiltP = tWPPFiltP, tWPPFiltQ = tWPPFiltQ, tWPQFiltQ = tWPQFiltQ, tWPUFiltQ = tWPUFiltQ, tWPfFiltP = tWPfFiltP, tpft = tpft, tpfv = tpfv, txft = txft, txfv = txfv, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-60, 4.44089e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(wT4ACurrentSource.terminal, elecMeasurements.terminal1) annotation(
    Line(points = {{42, 0}, {58, 0}}, color = {0, 0, 255}));
  connect(tanPhi, wT4ACurrentSource.tanPhi) annotation(
    Line(points = {{-20, 120}, {-20, 12}, {-2, 12}}, color = {0, 0, 127}));
  connect(omegaRefPu, wT4ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-140, -40}, {-20, -40}, {-20, -12}, {-2, -12}}, color = {0, 0, 127}));
  connect(wPPControl2015.PWPRefPu, PWPRefPu) annotation(
    Line(points = {{-82, 18}, {-100, 18}, {-100, 40}, {-140, 40}}, color = {0, 0, 127}));
  connect(UWPRefPu, wPPControl2015.UWPRefPu) annotation(
    Line(points = {{-140, 12}, {-82, 12}}, color = {0, 0, 127}));
  connect(QWPRefPu, wPPControl2015.QWPRefPu) annotation(
    Line(points = {{-140, -14}, {-100, -14}, {-100, 6}, {-82, 6}}, color = {0, 0, 127}));
  connect(omegaRefPu, wPPControl2015.omegaRefPu) annotation(
    Line(points = {{-140, -40}, {-88, -40}, {-88, -18}, {-82, -18}}, color = {0, 0, 127}));
  connect(tanPhi, wPPControl2015.tanPhi) annotation(
    Line(points = {{-20, 120}, {-20, 60}, {-70, 60}, {-70, 22}}, color = {0, 0, 127}));
  connect(wPPControl2015.xWTRefPu, wT4ACurrentSource.xWTRefPu) annotation(
    Line(points = {{-38, -8}, {-8, -8}, {-8, -4}, {-2, -4}}, color = {0, 0, 127}));
  connect(elecMeasurements.iPu, wPPControl2015.iPu) annotation(
    Line(points = {{72, -22}, {72, -30}, {-92, -30}, {-92, -10}, {-82, -10}}, color = {85, 170, 255}));
  connect(elecMeasurements.uPu, wPPControl2015.uPu) annotation(
    Line(points = {{88, -22}, {88, -36}, {-96, -36}, {-96, -2}, {-82, -2}}, color = {85, 170, 255}));
  connect(wPPControl2015.PWTRefPu, wT4ACurrentSource.PWTRefPu) annotation(
    Line(points = {{-38, 8}, {-20, 8}, {-20, 4}, {-2, 4}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {70, -1}, extent = {{-36, 16}, {36, -16}}, textString = "A")}));
end WPP4ACurrentSource2015;
