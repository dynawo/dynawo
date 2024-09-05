within Dynawo.Electrical.Wind.IEC.WT;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4ACurrentSource2020 "Wind Turbine Type 4A model from IEC 61400-27-1:2020 standard : measurement, PLL, protection, PControl, QControl, limiters, electrical and generator modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWT4;

  //PControl parameters
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

  Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control4A2020 control4A(DPMaxP4APu = DPMaxP4APu, DPRefMax4APu = DPRefMax4APu, DPRefMin4APu = DPRefMin4APu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPOrdP4A = tPOrdP4A, tPWTRef4A = tPWTRef4A, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.Measurements protectionMeasurements(DfMaxPu = DfpMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIpFilt, tPFilt = tPpFilt, tQFilt = tQpFilt, tS = tS, tUFilt = tUpFilt, tfFilt = tfpFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, 80}, extent = {{20, 20}, {-20, -20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.Measurements controlMeasurements(DfMaxPu = DfcMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIcFilt, tPFilt = tPcFilt, tQFilt = tQcFilt, tS = tS, tUFilt = tUcFilt, tfFilt = tfcFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.GridProtection2020 gridProtection(U0Pu = U0Pu, UOverPu = UOverPu, UUnderPu = UUnderPu, fOverPu = fOverPu, fUnderPu = fUnderPu, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, TabletUunderUwtfilt = TabletUunderUwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, Tabletfunderfwtfilt = Tabletfunderfwtfilt) annotation(
    Placement(visible = true, transformation(origin = {60, 20}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-75, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

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
  connect(control4A.ipMaxPu, wT4Injector.ipMaxPu) annotation(
    Line(points = {{-38, -24}, {-2, -24}}, color = {0, 0, 127}));
  connect(control4A.ipCmdPu, wT4Injector.ipCmdPu) annotation(
    Line(points = {{-38, -32}, {-2, -32}}, color = {0, 0, 127}));
  connect(control4A.iqMaxPu, wT4Injector.iqMaxPu) annotation(
    Line(points = {{-38, -40}, {-2, -40}}, color = {0, 0, 127}));
  connect(control4A.iqCmdPu, wT4Injector.iqCmdPu) annotation(
    Line(points = {{-38, -48}, {-2, -48}}, color = {0, 0, 127}));
  connect(control4A.iqMinPu, wT4Injector.iqMinPu) annotation(
    Line(points = {{-38, -56}, {-2, -56}}, color = {0, 0, 127}));
  connect(xWTRefPu, control4A.xWTRefPu) annotation(
    Line(points = {{-130, -60}, {-100, -60}, {-100, -52}, {-82, -52}}, color = {0, 0, 127}));
  connect(tanPhi, control4A.tanPhi) annotation(
    Line(points = {{-130, -40}, {-82, -40}}, color = {0, 0, 127}));
  connect(PWTRefPu, control4A.PWTRefPu) annotation(
    Line(points = {{-130, -20}, {-100, -20}, {-100, -34}, {-82, -34}}, color = {0, 0, 127}));
  connect(controlMeasurements.UFiltPu, control4A.UWTCFiltPu) annotation(
    Line(points = {{-76, 58}, {-76, 20}, {-86, 20}, {-86, -22}, {-82, -22}}, color = {0, 0, 127}));
  connect(controlMeasurements.UPu, control4A.UWTCPu) annotation(
    Line(points = {{-80, 58}, {-80, 24}, {-90, 24}, {-90, -28}, {-82, -28}}, color = {0, 0, 127}));
  connect(controlMeasurements.QFiltPu, control4A.QWTCFiltPu) annotation(
    Line(points = {{-92, 58}, {-92, -58}, {-82, -58}}, color = {0, 0, 127}));
  connect(const.y, control4A.omegaGenPu) annotation(
    Line(points = {{-70, 0}, {-60, 0}, {-60, -18}}, color = {0, 0, 127}));
  connect(controlMeasurements.PFiltPu, control4A.PWTCFiltPu) annotation(
    Line(points = {{-96, 58}, {-96, -46}, {-82, -46}}, color = {0, 0, 127}));
  connect(controlMeasurements.theta, pll.theta) annotation(
    Line(points = {{-68, 58}, {-68, 54}, {-50, 54}, {-50, 104}, {-12, 104}, {-12, 98}}, color = {0, 0, 127}));
  connect(controlMeasurements.UPu, pll.UWTPu) annotation(
    Line(points = {{-80, 58}, {-80, 50}, {-46, 50}, {-46, 98}, {-28, 98}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69.5, -1.5}, extent = {{-40, 20}, {41, -19}}, textString = "A"), Text(origin = {3, -41}, extent = {{-53, 24}, {53, -24}}, textString = "2020")}));
end WT4ACurrentSource2020;
