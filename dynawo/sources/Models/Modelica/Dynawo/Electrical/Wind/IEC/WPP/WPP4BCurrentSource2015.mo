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

model WPP4BCurrentSource2015
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWPP;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QControlParameters2015;
  import Dynawo.NonElectrical.ReverseCombiTable;

  //Uf measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Boolean Mzc "Zero crossing measurement mode (true = 1 if the wind turbine protection system uses zero crossings to detect the frequency - otherwise false = 0)" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tphiFilt "Filter time constant for voltage angle measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));

  //WT PControl parameters
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit Kpaw "Anti-windup gain for the integrator of the ramp-limited first order in pu/s (base SNom)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPAero "Aerodynamic power response time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4B "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tUFiltP4B "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "PControl"));

  //Current limiter parameters
  parameter Types.Time tUFiltcl "Voltage filter time constant in s" annotation(
    Dialog(tab = "CurrentLimiter"));

  //Mechanical parameters
  parameter Types.PerUnit CdrtPu "Drive train damping in pu (base SNom, omegaNom)" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.Time Hgen "Generator inertia time constant in s" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.Time Hwtr "WT rotor inertia time constant in s" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.PerUnit KdrtPu "Drive train stiffness in pu (base SNom, omegaNom)" annotation(
    Dialog(tab = "Mechanical"));

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
  Modelica.Blocks.Interfaces.RealInput QWPRefPu(start = -Q0Pu*SystemBase.SnRef/SNom) "Reference reactive power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-140, 26}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput UWPRefPu(start = X0Pu) "Reference voltage in pu (base UNom) (generator convention)" annotation(
    Placement(transformation(origin = {-140, 52}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Wind.IEC.WT.WT4BCurrentSource2015 wT4BCurrentSource(BesPu = BesPu, CdrtPu = CdrtPu, DPMaxP4BPu = DPMaxP4BPu, DfMaxPu = DfMaxPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, Hgen = Hgen, Hwtr = Hwtr, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IqH1Pu = IqH1Pu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, KdrtPu = KdrtPu, Kipaw = Kipaw, Kiq = Kiq, Kiqaw = Kiqaw, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kqv = Kqv, MdfsLim = MdfsLim, MqG = MqG, MqUvrt = MqUvrt, Mqpri = Mqpri, Mzc = Mzc, P0Pu = Modelica.ComplexMath.real(Modelica.ComplexMath.conj(iWt0Pu)*uWt0Pu), Q0Pu = Modelica.ComplexMath.imag(Modelica.ComplexMath.conj(iWt0Pu)*uWt0Pu), QMaxPu = QMaxPu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, ResPu = ResPu, SNom = SNom, TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt = TableIqMaxUwt, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableIqMaxUwt71 = TableIqMaxUwt71, TableIqMaxUwt72 = TableIqMaxUwt72, TableIqMaxUwt81 = TableIqMaxUwt81, TableIqMaxUwt82 = TableIqMaxUwt82, TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxPwtcFilt32 = TableQMaxPwtcFilt32, TableQMaxPwtcFilt41 = TableQMaxPwtcFilt41, TableQMaxPwtcFilt42 = TableQMaxPwtcFilt42, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinPwtcFilt11 = TableQMinPwtcFilt11, TableQMinPwtcFilt12 = TableQMinPwtcFilt12, TableQMinPwtcFilt21 = TableQMinPwtcFilt21, TableQMinPwtcFilt22 = TableQMinPwtcFilt22, TableQMinPwtcFilt31 = TableQMinPwtcFilt31, TableQMinPwtcFilt32 = TableQMinPwtcFilt32, TableQMinPwtcFilt41 = TableQMinPwtcFilt41, TableQMinPwtcFilt42 = TableQMinPwtcFilt42, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUoverUwtfilt41 = TabletUoverUwtfilt41, TabletUoverUwtfilt42 = TabletUoverUwtfilt42, TabletUoverUwtfilt51 = TabletUoverUwtfilt51, TabletUoverUwtfilt52 = TabletUoverUwtfilt52, TabletUoverUwtfilt61 = TabletUoverUwtfilt61, TabletUoverUwtfilt62 = TabletUoverUwtfilt62, TabletUoverUwtfilt71 = TabletUoverUwtfilt71, TabletUoverUwtfilt72 = TabletUoverUwtfilt72, TabletUoverUwtfilt81 = TabletUoverUwtfilt81, TabletUoverUwtfilt82 = TabletUoverUwtfilt82, TabletUunderUwtfilt = TabletUunderUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, TabletUunderUwtfilt41 = TabletUunderUwtfilt41, TabletUunderUwtfilt42 = TabletUunderUwtfilt42, TabletUunderUwtfilt51 = TabletUunderUwtfilt51, TabletUunderUwtfilt52 = TabletUunderUwtfilt52, TabletUunderUwtfilt61 = TabletUunderUwtfilt61, TabletUunderUwtfilt62 = TabletUunderUwtfilt62, TabletUunderUwtfilt71 = TabletUunderUwtfilt71, TabletUunderUwtfilt72 = TabletUunderUwtfilt72, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfoverfwtfilt41 = Tabletfoverfwtfilt41, Tabletfoverfwtfilt42 = Tabletfoverfwtfilt42, Tabletfunderfwtfilt = Tabletfunderfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, Tabletfunderfwtfilt41 = Tabletfunderfwtfilt41, Tabletfunderfwtfilt42 = Tabletfunderfwtfilt42, Tabletfunderfwtfilt51 = Tabletfunderfwtfilt51, Tabletfunderfwtfilt52 = Tabletfunderfwtfilt52, Tabletfunderfwtfilt61 = Tabletfunderfwtfilt61, Tabletfunderfwtfilt62 = Tabletfunderfwtfilt62, U0Pu = Modelica.ComplexMath.'abs'(uWt0Pu), UMaxPu = UMaxPu, UMinPu = UMinPu, UOverPu = UOverPu, UPhase0 = Modelica.ComplexMath.arg(uWt0Pu), UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, URef0Pu = URef0Pu, UUnderPu = UUnderPu, Udb1Pu = Udb1Pu, Udb2Pu = Udb2Pu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, XDropPu = XDropPu, XesPu = XesPu, fOverPu = fOverPu, fUnderPu = fUnderPu, tG = tG, tPAero = tPAero, tPFiltQ = tPFiltQ, tPFiltql = tPFiltql, tPOrdP4B = tPOrdP4B, tPll = tPll, tPost = tPost, tQord = tQord, tS = tS, tUFilt = tUFilt, tUFiltP4B = tUFiltP4B, tUFiltQ = tUFiltQ, tUFiltcl = tUFiltcl, tUFiltql = tUFiltql, tfFilt = tfFilt, tphiFilt = tphiFilt, ConverterLVControl = ConverterLVControl) annotation(
    Placement(transformation(origin = {20, 40}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.IEC.IEC61400.WPP.WPPControl2015 wPPControl2015(DPRefMaxPu = DPRefMaxPu, DPRefMinPu = DPRefMinPu, DPwpRefMaxPu = DPwpRefMaxPu, DPwpRefMinPu = DPwpRefMinPu, DXRefMaxPu = DXRefMaxPu, DXRefMinPu = DXRefMinPu, Kiwpp = Kiwpp, Kiwpx = Kiwpx, XKiwpxMaxPu = XKiwpxMaxPu, XKiwpxMinPu = XKiwpxMinPu, Kpwpp = Kpwpp, Kpwpx = Kpwpx, KwppRef = KwppRef, KwpqRef = KwpqRef, Kwpqu = Kwpqu, MwpqMode = MwpqMode, P0Pu = -PControl0Pu*SNom/SystemBase.SnRef, PKiwppMaxPu = PKiwppMaxPu, PKiwppMinPu = PKiwppMinPu, PRefMaxPu = PRefMaxPu, PRefMinPu = PRefMinPu, Q0Pu = -QControl0Pu*SNom/SystemBase.SnRef, SNom = SNom, TablePwpBiasfwpFiltCom = TablePwpBiasfwpFiltCom, TablePwpBiasfwpFiltCom11 = TablePwpBiasfwpFiltCom11, TablePwpBiasfwpFiltCom12 = TablePwpBiasfwpFiltCom12, TablePwpBiasfwpFiltCom21 = TablePwpBiasfwpFiltCom21, TablePwpBiasfwpFiltCom22 = TablePwpBiasfwpFiltCom22, TablePwpBiasfwpFiltCom31 = TablePwpBiasfwpFiltCom31, TablePwpBiasfwpFiltCom32 = TablePwpBiasfwpFiltCom32, TablePwpBiasfwpFiltCom41 = TablePwpBiasfwpFiltCom41, TablePwpBiasfwpFiltCom42 = TablePwpBiasfwpFiltCom42, TablePwpBiasfwpFiltCom51 = TablePwpBiasfwpFiltCom51, TablePwpBiasfwpFiltCom52 = TablePwpBiasfwpFiltCom52, TablePwpBiasfwpFiltCom61 = TablePwpBiasfwpFiltCom61, TablePwpBiasfwpFiltCom62 = TablePwpBiasfwpFiltCom62, TablePwpBiasfwpFiltCom71 = TablePwpBiasfwpFiltCom71, TablePwpBiasfwpFiltCom72 = TablePwpBiasfwpFiltCom72, TableQwpUErr = TableQwpUErr, TableQwpUErr11 = TableQwpUErr11, TableQwpUErr12 = TableQwpUErr12, TableQwpUErr21 = TableQwpUErr21, TableQwpUErr22 = TableQwpUErr22, TableQwpUErr31 = TableQwpUErr31, TableQwpUErr32 = TableQwpUErr32, TableQwpUErr41 = TableQwpUErr41, TableQwpUErr42 = TableQwpUErr42, TableQwpUErr51 = TableQwpUErr51, TableQwpUErr52 = TableQwpUErr52, TableQwpUErr61 = TableQwpUErr61, TableQwpUErr62 = TableQwpUErr62, U0Pu = Modelica.ComplexMath.'abs'(uControl0Pu), UPhase0 = Modelica.ComplexMath.arg(uControl0Pu), UwpqDipPu = UwpqDipPu, X0Pu = X0Pu, XRefMaxPu = XRefMaxPu, XRefMinPu = XRefMinPu, XWT0Pu = wT4BCurrentSource.XWT0Pu, i0Pu = iControl0Pu, tS = tS, tUqFilt = tUqFilt, tWPPFiltP = tWPPFiltP, tWPPFiltQ = tWPPFiltQ, tWPQFiltQ = tWPQFiltQ, tWPUFiltQ = tWPUFiltQ, tWPfFiltP = tWPfFiltP, tpft = tpft, tpfv = tpft, txft = txft, txfv = txfv, u0Pu = uControl0Pu, PPDRefCom0Pu = wT4BCurrentSource.U0Pu*wT4BCurrentSource.ip0Pu, DfMaxPu = DfMaxPu, tfFilt = tfFilt) annotation(
    Placement(transformation(origin = {-60, 40}, extent = {{-20, -20}, {20, 20}})));

  //Initial parameters
  final parameter Types.VoltageModulePu UErr0 = ReverseCombiTable(TableQwpUErr, QControl0Pu);
  final parameter Types.PerUnit X0Pu = if MwpqMode == 0 then QControl0Pu else if MwpqMode == 1 then QControl0Pu/PControl0Pu else if MwpqMode == 2 then Modelica.ComplexMath.'abs'(uControl0Pu) + UErr0 else if MwpqMode == 3 then Modelica.ComplexMath.'abs'(uControl0Pu) + Kwpqu*QControl0Pu else 0;

equation
  connect(tanPhi, wT4BCurrentSource.tanPhi) annotation(
    Line(points = {{-20, 120}, {-20, 52}, {-2, 52}}, color = {0, 0, 127}));
  connect(wPPControl2015.PWPRefPu, PWPRefPu) annotation(
    Line(points = {{-82, 58}, {-100, 58}, {-100, 80}, {-140, 80}}, color = {0, 0, 127}));
  connect(wPPControl2015.UWPRefPu, UWPRefPu) annotation(
    Line(points = {{-82, 52}, {-140, 52}}, color = {0, 0, 127}));
  connect(wPPControl2015.QWPRefPu, QWPRefPu) annotation(
    Line(points = {{-82, 46}, {-111, 46}, {-111, 26}, {-140, 26}}, color = {0, 0, 127}));
  connect(wPPControl2015.omegaRefPu, omegaRefPu) annotation(
    Line(points = {{-82, 22}, {-111, 22}, {-111, 0}, {-140, 0}}, color = {0, 0, 127}));
  connect(wPPControl2015.PWTRefPu, wT4BCurrentSource.PWTRefPu) annotation(
    Line(points = {{-38, 48}, {-20, 48}, {-20, 44}, {-2, 44}}, color = {0, 0, 127}));
  connect(wPPControl2015.xWTRefPu, wT4BCurrentSource.xWTRefPu) annotation(
    Line(points = {{-38, 32}, {-20, 32}, {-20, 36}, {-2, 36}}, color = {0, 0, 127}));
  connect(omegaRefPu, wT4BCurrentSource.omegaRefPu) annotation(
    Line(points = {{-140, 0}, {-21, 0}, {-21, 28}, {-2, 28}}, color = {0, 0, 127}));
  connect(wT4BCurrentSource.terminal, PCS.terminal1) annotation(
    Line(points = {{42, 40}, {58, 40}}, color = {0, 0, 255}));
  connect(realToComplex.y, wPPControl2015.iPu) annotation(
    Line(points = {{2, -4}, {-88, -4}, {-88, 30}, {-82, 30}}, color = {85, 170, 255}));
  connect(realToComplex1.y, wPPControl2015.uPu) annotation(
    Line(points = {{2, -64}, {-92, -64}, {-92, 38}, {-82, 38}}, color = {85, 170, 255}));
  connect(tanPhi, wPPControl2015.tanPhi) annotation(
    Line(points = {{-20, 120}, {-20, 70}, {-70, 70}, {-70, 62}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram");
end WPP4BCurrentSource2015;
