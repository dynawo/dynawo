within Dynawo.Electrical.Wind.IEC.WT;

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

model WT4BCurrentSource2015 "Wind Turbine Type 4B model from IEC 61400-27-1:2015 standard : measurement, PLL, protection, PControl, QControl, limiters, electrical and generator modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWT4;

  //Uf measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));

  //PControl parameters
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

  //QControl parameters
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

  Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control4B2015 control4B(DPMaxP4BPu = DPMaxP4BPu, Udb1Pu = Udb1Pu, Udb2Pu = Udb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kqv = Kqv, MdfsLim = MdfsLim, MqG = MqG, MqUvrt = MqUvrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPAero = tPAero, tPFiltQ = tPFiltQ, tPFiltql = tPFiltql, tPOrdP4B = tPOrdP4B, tPost = tPost, tQord = tQord, tS = tS, tUFiltP4B = tUFiltP4B, tUFiltQ = tUFiltQ, tUFiltcl = tUFiltcl, tUFiltql = tUFiltql)  annotation(
    Placement(visible = true, transformation(origin = {-58, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.GridProtection2015 gridProtection( DfMaxPu = DfMaxPu, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUunderUwtfilt = TabletUunderUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfunderfwtfilt = Tabletfunderfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, U0Pu = U0Pu,UOverPu = UOverPu, UPhase0 = UPhase0, UUnderPu = UUnderPu, fOverPu = fOverPu, fUnderPu = fUnderPu, tS = tS, tUFilt = tUFilt, tfFilt = tfFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {10, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.Mechanical mechanical(CdrtPu = CdrtPu, Hgen = Hgen, Hwtr = Hwtr, KdrtPu = KdrtPu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, SNom = SNom)  annotation(
    Placement(visible = true, transformation(origin = {63, -101}, extent = {{-11, 11}, {11, -11}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.PQCalculus pQCalculus annotation(
    Placement(visible = true, transformation(origin = {10, -84}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(control4B.ipMaxPu, wT4Injector.ipMaxPu) annotation(
    Line(points = {{-36, -24}, {-2, -24}}, color = {0, 0, 127}));
  connect(control4B.ipCmdPu, wT4Injector.ipCmdPu) annotation(
    Line(points = {{-36, -32}, {-2, -32}}, color = {0, 0, 127}));
  connect(control4B.iqMaxPu, wT4Injector.iqMaxPu) annotation(
    Line(points = {{-36, -40}, {-2, -40}}, color = {0, 0, 127}));
  connect(control4B.iqCmdPu, wT4Injector.iqCmdPu) annotation(
    Line(points = {{-36, -48}, {-2, -48}}, color = {0, 0, 127}));
  connect(control4B.iqMinPu, wT4Injector.iqMinPu) annotation(
    Line(points = {{-36, -56}, {-2, -56}}, color = {0, 0, 127}));
  connect(xWTRefPu, control4B.xWTRefPu) annotation(
    Line(points = {{-130, -60}, {-100, -60}, {-100, -52}, {-80, -52}}, color = {0, 0, 127}));
  connect(tanPhi, control4B.tanPhi) annotation(
    Line(points = {{-130, -40}, {-80, -40}}, color = {0, 0, 127}));
  connect(PWTRefPu, control4B.PWTRefPu) annotation(
    Line(points = {{-130, -20}, {-100, -20}, {-100, -34}, {-80, -34}}, color = {0, 0, 127}));
  connect(wT4Injector.uWtPu, gridProtection.uWtPu) annotation(
    Line(points = {{42, -28}, {100, -28}, {100, 102}, {72, 102}}, color = {85, 170, 255}));
  connect(gridProtection.fOCB, wT4Injector.fOCB) annotation(
    Line(points = {{60, 58}, {60, -10}, {20, -10}, {20, -18}}, color = {255, 0, 255}));
  connect(omegaRefPu, gridProtection.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 120}, {52, 120}, {52, 102}}, color = {0, 0, 127}));
  connect(wT4Injector.uWtPu, complexToPolar.u) annotation(
    Line(points = {{42, -28}, {50, -28}, {50, 30}, {22, 30}}, color = {85, 170, 255}));
  connect(complexToPolar.len, control4B.UWTPu) annotation(
    Line(points = {{-2, 36}, {-86, 36}, {-86, -28}, {-80, -28}}, color = {0, 0, 127}));
  connect(complexToPolar.len, pll.UWTPu) annotation(
    Line(points = {{-2, 36}, {-86, 36}, {-86, 102}, {-28, 102}, {-28, 98}}, color = {0, 0, 127}));
  connect(complexToPolar.phi, pll.theta) annotation(
    Line(points = {{-2, 24}, {-60, 24}, {-60, 108}, {-12, 108}, {-12, 98}}, color = {0, 0, 127}));
  connect(mechanical.PAeroPu, control4B.PAeroPu) annotation(
    Line(points = {{51, -105}, {-58, -105}, {-58, -62}}, color = {0, 0, 127}));
  connect(wT4Injector.PAgPu, mechanical.PAgPu) annotation(
    Line(points = {{42, -56}, {46, -56}, {46, -97}, {51, -97}}, color = {0, 0, 127}));
  connect(mechanical.omegaGenPu, control4B.omegaGenPu) annotation(
    Line(points = {{75, -97}, {76, -97}, {76, -14}, {-58, -14}, {-58, -18}}, color = {0, 0, 127}));
  connect(wT4Injector.uWtPu, pQCalculus.uWtPu) annotation(
    Line(points = {{42, -28}, {50, -28}, {50, -82}, {22, -82}}, color = {85, 170, 255}));
  connect(wT4Injector.iWtPu, pQCalculus.iWtPu) annotation(
    Line(points = {{42, -24}, {58, -24}, {58, -86}, {22, -86}}, color = {85, 170, 255}));
  connect(pQCalculus.QWtPu, control4B.QWTPu) annotation(
    Line(points = {{0, -82}, {-86, -82}, {-86, -58}, {-80, -58}}, color = {0, 0, 127}));
  connect(pQCalculus.PWtPu, control4B.PWTPu) annotation(
    Line(points = {{0, -86}, {-90, -86}, {-90, -46}, {-80, -46}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69.5, -1.5}, extent = {{-40, 20}, {41, -19}}, textString = "B"), Text(origin = {3, -41}, extent = {{-53, 24}, {53, -24}}, textString = "2015")}),
  Diagram(coordinateSystem(extent = {{-100, -130}, {100, 100}})));
end WT4BCurrentSource2015;
