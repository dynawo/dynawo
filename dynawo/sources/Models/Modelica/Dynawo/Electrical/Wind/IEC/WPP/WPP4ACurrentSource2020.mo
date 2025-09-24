within Dynawo.Electrical.Wind.IEC.WPP;

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

model WPP4ACurrentSource2020 "Wind Power Plant Type 4A model from IEC 61400-27-1:2020 standard : WT4A, communication modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWPP;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QControlParameters2020;
  import Dynawo.NonElectrical.ReverseCombiTable;

  //WPP Qcontrol parameters
  parameter Types.PerUnit RwpDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqRisePu "Voltage threshold for OVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMaxPu "Maximum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMinPu "Minimum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XwpDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));

  //WPP PControl parameters
  parameter Types.ActivePowerPu PErrMaxPu "Maximum control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PErrMinPu "Minimum negative control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));

  //WP Measurement parameters
  parameter Types.PerUnit DfMaxPu "Maximum frequency ramp rate in pu/s (base fNom)" annotation(
    Dialog(tab = "MeasurementWP"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "MeasurementWP"));
  parameter Types.Time tIFilt "Filter time constant for current measurement in s" annotation(
    Dialog(tab = "MeasurementWP"));
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "MeasurementWP"));
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "MeasurementWP"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "MeasurementWP"));

  //Linear communication parameters
  parameter Types.Time tLag "Communication lag time constant in s" annotation(
    Dialog(tab = "LinearCommunication"));
  parameter Types.Time tLead "Communication lead time constant in s" annotation(
    Dialog(tab = "LinearCommunication"));

  //Measurement parameters for control
  parameter Types.PerUnit DfcMaxPu "Maximum frequency control ramp rate in pu/s (base fNom)" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tfcFilt "Filter time constant for frequency control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tIcFilt "Filter time constant for current control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tPcFilt "Filter time constant for active power control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tQcFilt "Filter time constant for reactive power control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tUcFilt "Filter time constant for voltage control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));

  //Measurement parameters for protection
  parameter Types.PerUnit DfpMaxPu "Maximum frequency protection ramp rate in pu/s (base fNom)" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tfpFilt "Filter time constant for frequency protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tIpFilt "Filter time constant for current protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tPpFilt "Filter time constant for active power protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tQpFilt "Filter time constant for reactive power protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tUpFilt "Filter time constant for voltage protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));

  //WT PControl parameters
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4APu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4APu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPWTRef4A "Reference power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.VoltageModulePu UpDipPu "Voltage dip threshold for power control in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));

  //WT QControl parameters
  parameter Types.VoltageModulePu DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer Mqfrt "FRT Q control modes (0-3) (see Table 29, section 7.7.5, page 60 of the IEC norm N°61400-27-1)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUss "Steady-state voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqRisePu "Voltage threshold for OVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput xWPRefPu(start = X0Pu) "Reference reactive power or voltage in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(transformation(origin = {-140, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -19.5}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Wind.IEC.WT.WT4ACurrentSource2020 wT4ACurrentSource(BesPu = BesPu, DPMaxP4APu = DPMaxP4APu, DPRefMax4APu = DPRefMax4APu, DPRefMin4APu = DPRefMin4APu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, DfcMaxPu = DfcMaxPu, DfpMaxPu = DfpMaxPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IqH1Pu = IqH1Pu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kipaw = Kipaw, Kiq = Kiq, Kiqaw = Kiqaw, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = Modelica.ComplexMath.real(Modelica.ComplexMath.conj(iWt0Pu)*uWt0Pu), Q0Pu = Modelica.ComplexMath.imag(Modelica.ComplexMath.conj(iWt0Pu)*uWt0Pu), QMaxPu = QMaxPu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, ResPu = ResPu, SNom = SNom, U0Pu = Modelica.ComplexMath.'abs'(uWt0Pu), UMaxPu = UMaxPu, UMinPu = UMinPu, UOverPu = UOverPu, UPhase0 = Modelica.ComplexMath.arg(uWt0Pu), UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, URef0Pu = URef0Pu, UUnderPu = UUnderPu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XesPu = XesPu, fOverPu = fOverPu, fUnderPu = fUnderPu, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUoverUwtfilt41 = TabletUoverUwtfilt41, TabletUoverUwtfilt42 = TabletUoverUwtfilt42, TabletUoverUwtfilt51 = TabletUoverUwtfilt51, TabletUoverUwtfilt52 = TabletUoverUwtfilt52, TabletUoverUwtfilt61 = TabletUoverUwtfilt61, TabletUoverUwtfilt62 = TabletUoverUwtfilt62, TabletUoverUwtfilt71 = TabletUoverUwtfilt71, TabletUoverUwtfilt72 = TabletUoverUwtfilt72, TabletUoverUwtfilt81 = TabletUoverUwtfilt81, TabletUoverUwtfilt82 = TabletUoverUwtfilt82, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, TabletUunderUwtfilt41 = TabletUunderUwtfilt41, TabletUunderUwtfilt42 = TabletUunderUwtfilt42, TabletUunderUwtfilt51 = TabletUunderUwtfilt51, TabletUunderUwtfilt52 = TabletUunderUwtfilt52, TabletUunderUwtfilt61 = TabletUunderUwtfilt61, TabletUunderUwtfilt62 = TabletUunderUwtfilt62, TabletUunderUwtfilt71 = TabletUunderUwtfilt71, TabletUunderUwtfilt72 = TabletUunderUwtfilt72, TabletUunderUwtfilt = TabletUunderUwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfoverfwtfilt41 = Tabletfoverfwtfilt41, Tabletfoverfwtfilt42 = Tabletfoverfwtfilt42, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, Tabletfunderfwtfilt41 = Tabletfunderfwtfilt41, Tabletfunderfwtfilt42 = Tabletfunderfwtfilt42, Tabletfunderfwtfilt51 = Tabletfunderfwtfilt51, Tabletfunderfwtfilt52 = Tabletfunderfwtfilt52, Tabletfunderfwtfilt61 = Tabletfunderfwtfilt61, Tabletfunderfwtfilt62 = Tabletfunderfwtfilt62, Tabletfunderfwtfilt = Tabletfunderfwtfilt, TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt = TableIqMaxUwt, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableIqMaxUwt71 = TableIqMaxUwt71, TableIqMaxUwt72 = TableIqMaxUwt72, TableIqMaxUwt81 = TableIqMaxUwt81, TableIqMaxUwt82 = TableIqMaxUwt82, TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxPwtcFilt32 = TableQMaxPwtcFilt32, TableQMaxPwtcFilt41 = TableQMaxPwtcFilt41, TableQMaxPwtcFilt42 = TableQMaxPwtcFilt42, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinPwtcFilt11 = TableQMinPwtcFilt11, TableQMinPwtcFilt12 = TableQMinPwtcFilt12, TableQMinPwtcFilt21 = TableQMinPwtcFilt21, TableQMinPwtcFilt22 = TableQMinPwtcFilt22, TableQMinPwtcFilt31 = TableQMinPwtcFilt31, TableQMinPwtcFilt32 = TableQMinPwtcFilt32, TableQMinPwtcFilt41 = TableQMinPwtcFilt41, TableQMinPwtcFilt42 = TableQMinPwtcFilt42, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, tG = tG, tIcFilt = tIcFilt, tIpFilt = tIpFilt, tPOrdP4A = tPOrdP4A, tPWTRef4A = tPWTRef4A, tPcFilt = tPcFilt, tPll = tPll, tPost = tPost, tPpFilt = tPpFilt, tQcFilt = tQcFilt, tQord = tQord, tQpFilt = tQpFilt, tS = tS, tUcFilt = tUcFilt, tUpFilt = tUpFilt, tUss = tUss, tfcFilt = tfcFilt, tfpFilt = tfpFilt, ConverterLVControl = ConverterLVControl) annotation(
    Placement(transformation(origin = {20, 40}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.IEC.IEC61400.WPP.WPPControl2020 wPPControl(DPRefMaxPu = DPRefMaxPu, DPRefMinPu = DPRefMinPu, DPwpRefMaxPu = DPwpRefMaxPu, DPwpRefMinPu = DPwpRefMinPu, DXRefMaxPu = DXRefMaxPu, DXRefMinPu = DXRefMinPu, DfMaxPu = DfMaxPu, Kiwpp = Kiwpp, Kiwpx = Kiwpx, Kpwpp = Kpwpp, Kpwpx = Kpwpx, KwppRef = KwppRef, KwpqRef = KwpqRef, Kwpqu = Kwpqu, MwpqMode = MwpqMode, P0Pu = -PControl0Pu*SNom/SystemBase.SnRef, PErrMaxPu = PErrMaxPu, PErrMinPu = PErrMinPu, PKiwppMaxPu = PKiwppMaxPu, PKiwppMinPu = PKiwppMinPu, PRefMaxPu = PRefMaxPu, PRefMinPu = PRefMinPu, Q0Pu = -QControl0Pu*SNom/SystemBase.SnRef, RwpDropPu = RwpDropPu, SNom = SNom, TablePwpBiasfwpFiltCom = TablePwpBiasfwpFiltCom, TablePwpBiasfwpFiltCom11 = TablePwpBiasfwpFiltCom11, TablePwpBiasfwpFiltCom12 = TablePwpBiasfwpFiltCom12, TablePwpBiasfwpFiltCom21 = TablePwpBiasfwpFiltCom21, TablePwpBiasfwpFiltCom22 = TablePwpBiasfwpFiltCom22, TablePwpBiasfwpFiltCom31 = TablePwpBiasfwpFiltCom31, TablePwpBiasfwpFiltCom32 = TablePwpBiasfwpFiltCom32, TablePwpBiasfwpFiltCom41 = TablePwpBiasfwpFiltCom41, TablePwpBiasfwpFiltCom42 = TablePwpBiasfwpFiltCom42, TablePwpBiasfwpFiltCom51 = TablePwpBiasfwpFiltCom51, TablePwpBiasfwpFiltCom52 = TablePwpBiasfwpFiltCom52, TablePwpBiasfwpFiltCom61 = TablePwpBiasfwpFiltCom61, TablePwpBiasfwpFiltCom62 = TablePwpBiasfwpFiltCom62, TablePwpBiasfwpFiltCom71 = TablePwpBiasfwpFiltCom71, TablePwpBiasfwpFiltCom72 = TablePwpBiasfwpFiltCom72, TableQwpMaxPwpFiltCom = TableQwpMaxPwpFiltCom, TableQwpMaxPwpFiltCom11 = TableQwpMaxPwpFiltCom11, TableQwpMaxPwpFiltCom12 = TableQwpMaxPwpFiltCom12, TableQwpMaxPwpFiltCom21 = TableQwpMaxPwpFiltCom21, TableQwpMaxPwpFiltCom22 = TableQwpMaxPwpFiltCom22, TableQwpMaxPwpFiltCom31 = TableQwpMaxPwpFiltCom31, TableQwpMaxPwpFiltCom32 = TableQwpMaxPwpFiltCom32, TableQwpMinPwpFiltCom = TableQwpMinPwpFiltCom, TableQwpMinPwpFiltCom11 = TableQwpMinPwpFiltCom11, TableQwpMinPwpFiltCom12 = TableQwpMinPwpFiltCom12, TableQwpMinPwpFiltCom21 = TableQwpMinPwpFiltCom21, TableQwpMinPwpFiltCom22 = TableQwpMinPwpFiltCom22, TableQwpMinPwpFiltCom31 = TableQwpMinPwpFiltCom31, TableQwpMinPwpFiltCom32 = TableQwpMinPwpFiltCom32, TableQwpUErr = TableQwpUErr, TableQwpUErr11 = TableQwpUErr11, TableQwpUErr12 = TableQwpUErr12, TableQwpUErr21 = TableQwpUErr21, TableQwpUErr22 = TableQwpUErr22, TableQwpUErr31 = TableQwpUErr31, TableQwpUErr32 = TableQwpUErr32, U0Pu = Modelica.ComplexMath.'abs'(uControl0Pu), UPhase0 = Modelica.ComplexMath.arg(uControl0Pu), UwpqDipPu = UwpqDipPu, UwpqRisePu = UwpqRisePu, X0Pu = X0Pu, XErrMaxPu = XErrMaxPu, XErrMinPu = XErrMinPu, XKiwpxMaxPu = XKiwpxMaxPu, XKiwpxMinPu = XKiwpxMinPu, XRefMaxPu = XRefMaxPu, XRefMinPu = XRefMinPu, XWT0Pu = wT4ACurrentSource.XWT0Pu, XwpDropPu = XwpDropPu, i0Pu = iControl0Pu, tIFilt = tIFilt, tLag = tLag, tLead = tLead, tPFilt = tPFilt, tQFilt = tQFilt, tS = tS, tUFilt = tUFilt, tUqFilt = tUqFilt, tfFilt = tfFilt, u0Pu = uControl0Pu, PPDRefCom0Pu = wT4ACurrentSource.U0Pu*wT4ACurrentSource.ip0Pu) annotation(
    Placement(transformation(origin = {-60, 40}, extent = {{-20, -20}, {20, 20}})));

  //Initial parameters
  final parameter Types.VoltageModulePu UErr0 = ReverseCombiTable(TableQwpUErr, QControl0Pu);
  final parameter Types.VoltageModulePu UWpp0DroppedPu = ((Modelica.ComplexMath.'abs'(uControl0Pu) - RwpDropPu*PControl0Pu/U0Pu - XwpDropPu*QControl0Pu/U0Pu)^2 + (XwpDropPu*PControl0Pu/U0Pu - RwpDropPu*QControl0Pu/U0Pu)^2)^0.5 "Initial voltage module at the output of the voltage drop block (This voltage is the one that is controlled in WPPQControl)";
  final parameter Types.PerUnit X0Pu = if MwpqMode == 0 then QControl0Pu else if MwpqMode == 1 then QControl0Pu/PControl0Pu else if MwpqMode == 2 then UWpp0DroppedPu + UErr0 else if MwpqMode == 3 then UWpp0DroppedPu + Kwpqu*QControl0Pu else 0;

equation
  connect(wPPControl.PPDRefComPu, wT4ACurrentSource.PWTRefPu) annotation(
    Line(points = {{-38, 48}, {-20, 48}, {-20, 44}, {-2, 44}}, color = {0, 0, 127}));
  connect(wPPControl.xPDRefComPu, wT4ACurrentSource.xWTRefPu) annotation(
    Line(points = {{-38, 32}, {-20, 32}, {-20, 36}, {-2, 36}}, color = {0, 0, 127}));
  connect(xWPRefPu, wPPControl.xWPRefPu) annotation(
    Line(points = {{-140, 40}, {-111, 40}, {-111, 48}, {-82, 48}}, color = {0, 0, 127}));
  connect(PWPRefPu, wPPControl.PWPRefPu) annotation(
    Line(points = {{-140, 80}, {-100, 80}, {-100, 58}, {-82, 58}}, color = {0, 0, 127}));
  connect(omegaRefPu, wPPControl.omegaRefPu) annotation(
    Line(points = {{-140, 0}, {-111, 0}, {-111, 22}, {-82, 22}}, color = {0, 0, 127}));
  connect(omegaRefPu, wT4ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-140, 0}, {-19, 0}, {-19, 28}, {-2, 28}}, color = {0, 0, 127}));
  connect(tanPhi, wT4ACurrentSource.tanPhi) annotation(
    Line(points = {{-20, 120}, {-20, 52}, {-2, 52}}, color = {0, 0, 127}));
  connect(wT4ACurrentSource.terminal, PCS.terminal1) annotation(
    Line(points = {{42, 40}, {58, 40}}, color = {0, 0, 255}));
  connect(realToComplex.y, wPPControl.iPu) annotation(
    Line(points = {{2, -4}, {-90, -4}, {-90, 30}, {-82, 30}}, color = {85, 170, 255}));
  connect(realToComplex1.y, wPPControl.uPu) annotation(
    Line(points = {{2, -64}, {-94, -64}, {-94, 38}, {-82, 38}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {70, -1}, extent = {{-36, 16}, {36, -16}}, textString = "A")}));
end WPP4ACurrentSource2020;
