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

  Dynawo.Electrical.Wind.IEC.WT.WT4BCurrentSource2015 wT4BCurrentSource(BesPu = BesPu, CdrtPu = CdrtPu, DPMaxP4BPu = DPMaxP4BPu, DfMaxPu = DfMaxPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, Hgen = Hgen, Hwtr = Hwtr, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, KdrtPu = KdrtPu, Kipaw = Kipaw, Kiq = Kiq, Kiqaw = Kiqaw, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kqv = Kqv, MdfsLim = MdfsLim, MqG = MqG, MqUvrt = MqUvrt, Mqpri = Mqpri, Mzc = Mzc, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, ResPu = ResPu, SNom = SNom, TableIpMaxUwt = TableIpMaxUwt, TableIqMaxUwt = TableIqMaxUwt, TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinUwtcFilt = TableQMinUwtcFilt, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUunderUwtfilt = TabletUunderUwtfilt, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfunderfwtfilt = Tabletfunderfwtfilt, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UOverPu = UOverPu, UPhase0 = UPhase0, UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, URef0Pu = URef0Pu, UUnderPu = UUnderPu, Udb1Pu = Udb1Pu, Udb2Pu = Udb2Pu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, XesPu = XesPu, fOverPu = fOverPu, fUnderPu = fUnderPu, i0Pu = i0Pu, tG = tG, tPAero = tPAero, tPFiltQ = tPFiltQ, tPFiltql = tPFiltql, tPOrdP4B = tPOrdP4B, tPll = tPll, tPost = tPost, tQord = tQord, tS = tS, tUFilt = tUFilt, tUFiltP4B = tUFiltP4B, tUFiltQ = tUFiltQ, tUFiltcl = tUFiltcl, tUFiltql = tUFiltql, tfFilt = tfFilt, tphiFilt = tphiFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.WPP.WPPControl2015 wPPControl2015(DPRefMaxPu = DPRefMaxPu, DPRefMinPu = DPRefMinPu, DPwpRefMaxPu = DPwpRefMaxPu, DPwpRefMinPu = DPwpRefMinPu, DXRefMaxPu = DXRefMaxPu, DXRefMinPu = DXRefMinPu, Kiwpp = Kiwpp, Kiwpx = Kiwpx, XKiwpxMaxPu = XKiwpxMaxPu, XKiwpxMinPu = XKiwpxMinPu, Kpwpp = Kpwpp, Kpwpx = Kpwpx, KwppRef = KwppRef, KwpqRef = KwpqRef, Kwpqu = Kwpqu, MwpqMode = MwpqMode, P0Pu = P0Pu, PKiwppMaxPu = PKiwppMaxPu, PKiwppMinPu = PKiwppMinPu, PRefMaxPu = PRefMaxPu, PRefMinPu = PRefMinPu, Q0Pu = Q0Pu, SNom = SNom, TablePwpBiasfwpFiltCom = TablePwpBiasfwpFiltCom, TableQwpUErr = TableQwpUErr, U0Pu = U0Pu, UPhase0 = UPhase0, UwpqDipPu = UwpqDipPu, X0Pu = X0Pu, XRefMaxPu = XRefMaxPu, XRefMinPu = XRefMinPu, XWT0Pu = XWT0Pu, i0Pu = i0Pu, tS = tS, tUqFilt = tUqFilt, tWPPFiltP = tWPPFiltP, tWPPFiltQ = tWPPFiltQ, tWPQFiltQ = tWPQFiltQ, tWPUFiltQ = tWPUFiltQ, tWPfFiltP = tWPfFiltP, tpft = tpft, tpfv = tpft, txft = txft, txfv = txfv, u0Pu = u0Pu, tfFilt = tfFilt, DfMaxPu = DfMaxPu, tfFilt = tfFilt) annotation(
    Placement(visible = true, transformation(origin = {-60, 4.44089e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  PCS.switchOffSignal1 = wT4BCurrentSource.wT4Injector.switchOffSignal1;
  PCS.switchOffSignal2 = wT4BCurrentSource.wT4Injector.switchOffSignal2;

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
    Line(points = {{-140, 0}, {-20, 0}, {-20, 28}, {-2, 28}}, color = {0, 0, 127}));
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
