within Dynawo.Electrical.Wind.IEC.WT;

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

model WT4BCurrentSource2020 "Wind Turbine Type 4B model from IEC 61400-27-1:2020 standard : measurement, PLL, protection, PControl, QControl, limiters, electrical, generator and mechanical modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWT4;

  //PControl parameters
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4BPu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4BPu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPAero "Reference power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4B "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.VoltageModulePu UpDipPu "Voltage dip threshold for power control in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));

  //Mechanical parameters
  parameter Types.PerUnit CdrtPu "Drive train damping in pu (base SNom, omegaNom)" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.Time Hgen "Generator inertia time constant in s" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.Time Hwtr "WT rotor inertia time constant in s" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.PerUnit KdrtPu "Drive train stiffness in pu (base SNom, omegaNom)" annotation(
    Dialog(tab = "Mechanical"));

  //QControl parameters
  parameter Types.VoltageModulePu DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer Mqfrt "FRT Q control modes (0-3) (see Table 29, section 7.7.5, page 60 of the IEC norm N°61400-27-1:2020)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUss "Steady-state voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqRisePu "Voltage threshold for OVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

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

  Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control4B2020 control4B(DPMaxP4BPu = DPMaxP4BPu, DPRefMax4BPu = DPRefMax4BPu, DPRefMin4BPu = DPRefMin4BPu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPAero = tPAero, tPOrdP4B = tPOrdP4B, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.Mechanical mechanical(CdrtPu = CdrtPu, Hgen = Hgen, Hwtr = Hwtr, KdrtPu = KdrtPu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.Measurements protectionMeasurements(DfMaxPu = DfpMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIpFilt, tPFilt = tPpFilt, tQFilt = tQpFilt, tS = tS, tUFilt = tUpFilt, tfFilt = tfpFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, 80}, extent = {{20, 20}, {-20, -20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.Measurements controlMeasurements(DfMaxPu = DfcMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIcFilt, tPFilt = tPcFilt, tQFilt = tQcFilt, tS = tS, tUFilt = tUcFilt, tfFilt = tfcFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.GridProtection2020 gridProtection(U0Pu = U0Pu, UOverPu = UOverPu, UUnderPu = UUnderPu, fOverPu = fOverPu, fUnderPu = fUnderPu, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUoverUwtfilt41 = TabletUoverUwtfilt41, TabletUoverUwtfilt42 = TabletUoverUwtfilt42, TabletUoverUwtfilt51 = TabletUoverUwtfilt51, TabletUoverUwtfilt52 = TabletUoverUwtfilt52, TabletUoverUwtfilt61 = TabletUoverUwtfilt61, TabletUoverUwtfilt62 = TabletUoverUwtfilt62, TabletUoverUwtfilt71 = TabletUoverUwtfilt71, TabletUoverUwtfilt72 = TabletUoverUwtfilt72, TabletUoverUwtfilt81 = TabletUoverUwtfilt81, TabletUoverUwtfilt82 = TabletUoverUwtfilt82, TabletUunderUwtfilt = TabletUunderUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, TabletUunderUwtfilt41 = TabletUunderUwtfilt41, TabletUunderUwtfilt42 = TabletUunderUwtfilt42, TabletUunderUwtfilt51 = TabletUunderUwtfilt51, TabletUunderUwtfilt52 = TabletUunderUwtfilt52, TabletUunderUwtfilt61 = TabletUunderUwtfilt61, TabletUunderUwtfilt62 = TabletUunderUwtfilt62, TabletUunderUwtfilt71 = TabletUunderUwtfilt71, TabletUunderUwtfilt72 = TabletUunderUwtfilt72, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfoverfwtfilt41 = Tabletfoverfwtfilt41, Tabletfoverfwtfilt42 = Tabletfoverfwtfilt42, Tabletfunderfwtfilt = Tabletfunderfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, Tabletfunderfwtfilt41 = Tabletfunderfwtfilt41, Tabletfunderfwtfilt42 = Tabletfunderfwtfilt42, Tabletfunderfwtfilt51 = Tabletfunderfwtfilt51, Tabletfunderfwtfilt52 = Tabletfunderfwtfilt52, Tabletfunderfwtfilt61 = Tabletfunderfwtfilt61, Tabletfunderfwtfilt62 = Tabletfunderfwtfilt62) annotation(
    Placement(visible = true, transformation(origin = {60, 20}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

equation
  connect(gridProtection.fOCB, wT4Injector.fOCB) annotation(
    Line(points = {{60, -2}, {60, -10}, {20, -10}, {20, -18}}, color = {255, 0, 255}));
  connect(omegaRefPu, protectionMeasurements.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 116}, {48, 116}, {48, 102}}, color = {0, 0, 127}));
  connect(omegaRefPu, controlMeasurements.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 116}, {-68, 116}, {-68, 102}}, color = {0, 0, 127}));
  connect(protectionMeasurements.omegaFiltPu, gridProtection.omegaFiltPu) annotation(
    Line(points = {{44, 58}, {44, 50}, {52, 50}, {52, 42}}, color = {0, 0, 127}));
  connect(protectionMeasurements.UFiltPu, gridProtection.UWTPFiltPu) annotation(
    Line(points = {{56, 58}, {56, 50}, {68, 50}, {68, 42}}, color = {0, 0, 127}));
  connect(wT4Injector.iWtPu, controlMeasurements.iPu) annotation(
    Line(points = {{42, -24}, {100, -24}, {100, 106}, {-80, 106}, {-80, 102}}, color = {85, 170, 255}));
  connect(wT4Injector.iWtPu, protectionMeasurements.iPu) annotation(
    Line(points = {{42, -24}, {100, -24}, {100, 106}, {60, 106}, {60, 102}}, color = {85, 170, 255}));
  connect(wT4Injector.uWtPu, controlMeasurements.uPu) annotation(
    Line(points = {{42, -28}, {104, -28}, {104, 110}, {-92, 110}, {-92, 102}}, color = {85, 170, 255}));
  connect(wT4Injector.uWtPu, protectionMeasurements.uPu) annotation(
    Line(points = {{42, -28}, {104, -28}, {104, 110}, {72, 110}, {72, 102}}, color = {85, 170, 255}));
  connect(wT4Injector.PAgPu, mechanical.PAgPu) annotation(
    Line(points = {{42, -56}, {50, -56}, {50, -72}, {58, -72}}, color = {0, 0, 127}));
  connect(control4B.PAeroPu, mechanical.PAeroPu) annotation(
    Line(points = {{-60, -62}, {-60, -88}, {58, -88}}, color = {0, 0, 127}));
  connect(mechanical.omegaGenPu, control4B.omegaGenPu) annotation(
    Line(points = {{102, -72}, {110, -72}, {110, -14}, {-60, -14}, {-60, -18}}, color = {0, 0, 127}));
  connect(control4B.ipMaxPu, wT4Injector.ipMaxPu) annotation(
    Line(points = {{-38, -24}, {-2, -24}}, color = {0, 0, 127}));
  connect(control4B.ipCmdPu, wT4Injector.ipCmdPu) annotation(
    Line(points = {{-38, -32}, {-2, -32}}, color = {0, 0, 127}));
  connect(control4B.iqMaxPu, wT4Injector.iqMaxPu) annotation(
    Line(points = {{-38, -40}, {-2, -40}}, color = {0, 0, 127}));
  connect(control4B.iqCmdPu, wT4Injector.iqCmdPu) annotation(
    Line(points = {{-38, -48}, {-2, -48}}, color = {0, 0, 127}));
  connect(control4B.iqMinPu, wT4Injector.iqMinPu) annotation(
    Line(points = {{-38, -56}, {-2, -56}}, color = {0, 0, 127}));
  connect(xWTRefPu, control4B.xWTRefPu) annotation(
    Line(points = {{-130, -60}, {-100, -60}, {-100, -52}, {-82, -52}}, color = {0, 0, 127}));
  connect(tanPhi, control4B.tanPhi) annotation(
    Line(points = {{-130, -40}, {-82, -40}}, color = {0, 0, 127}));
  connect(PWTRefPu, control4B.PWTRefPu) annotation(
    Line(points = {{-130, -20}, {-100, -20}, {-100, -34}, {-82, -34}}, color = {0, 0, 127}));
  connect(controlMeasurements.UFiltPu, control4B.UWTCFiltPu) annotation(
    Line(points = {{-76, 58}, {-76, 20}, {-86, 20}, {-86, -22}, {-82, -22}}, color = {0, 0, 127}));
  connect(controlMeasurements.UPu, control4B.UWTCPu) annotation(
    Line(points = {{-80, 58}, {-80, 24}, {-90, 24}, {-90, -28}, {-82, -28}}, color = {0, 0, 127}));
  connect(controlMeasurements.PFiltPu, control4B.PWTCFiltPu) annotation(
    Line(points = {{-96, 58}, {-96, -46}, {-82, -46}}, color = {0, 0, 127}));
  connect(controlMeasurements.QFiltPu, control4B.QWTCFiltPu) annotation(
    Line(points = {{-92, 58}, {-92, -58}, {-82, -58}}, color = {0, 0, 127}));
  connect(controlMeasurements.UPu, pll.UWTPu) annotation(
    Line(points = {{-80, 58}, {-80, 52}, {-52, 52}, {-52, 102}, {-28, 102}, {-28, 98}}, color = {0, 0, 127}));
  connect(controlMeasurements.theta, pll.theta) annotation(
    Line(points = {{-68, 58}, {-68, 54}, {-54, 54}, {-54, 104}, {-12, 104}, {-12, 98}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69, -1}, extent = {{-40, 19}, {41, -19}}, textString = "B"), Text(origin = {3, -41}, extent = {{-53, 24}, {53, -24}}, textString = "2020")}));
end WT4BCurrentSource2020;
