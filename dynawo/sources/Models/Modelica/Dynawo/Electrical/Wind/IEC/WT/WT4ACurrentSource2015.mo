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

model WT4ACurrentSource2015 "Wind Turbine Type 4A model from IEC 61400-27-1:2015 standard : measurement, PLL, protection, PControl, QControl, limiters, electrical and generator modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWT4;

  //Uf measurement parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.UfMeasurement2015;

  //PControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT4a2015;

  //Current limiter parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.CurrentLimiter2015;

  //QControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWT2015;

  //Qlimiter parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QLimiter2015;

  Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control4A2015 control4A(DPMaxP4APu = DPMaxP4APu, Udb1Pu = Udb1Pu, Udb2Pu = Udb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kqv = Kqv, MdfsLim = MdfsLim, MqG = MqG, MqUvrt = MqUvrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt = TableIqMaxUwt, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableIqMaxUwt71 = TableIqMaxUwt71, TableIqMaxUwt72 = TableIqMaxUwt72, TableIqMaxUwt81 = TableIqMaxUwt81, TableIqMaxUwt82 = TableIqMaxUwt82, TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxPwtcFilt32 = TableQMaxPwtcFilt32, TableQMaxPwtcFilt41 = TableQMaxPwtcFilt41, TableQMaxPwtcFilt42 = TableQMaxPwtcFilt42, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinPwtcFilt11 = TableQMinPwtcFilt11, TableQMinPwtcFilt12 = TableQMinPwtcFilt12, TableQMinPwtcFilt21 = TableQMinPwtcFilt21, TableQMinPwtcFilt22 = TableQMinPwtcFilt22, TableQMinPwtcFilt31 = TableQMinPwtcFilt31, TableQMinPwtcFilt32 = TableQMinPwtcFilt32, TableQMinPwtcFilt41 = TableQMinPwtcFilt41, TableQMinPwtcFilt42 = TableQMinPwtcFilt42, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPFiltQ = tPFiltQ, tPFiltql = tPFiltql, tPOrdP4A = tPOrdP4A, tPost = tPost, tQord = tQord, tS = tS, tUFiltP4A = tUFiltP4A, tUFiltQ = tUFiltQ, tUFiltcl = tUFiltcl, tUFiltql = tUFiltql)  annotation(
    Placement(visible = true, transformation(origin = {-58, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-75, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.GridProtection2015 gridProtection( DfMaxPu = DfMaxPu, Mzc = Mzc,TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUoverUwtfilt41 = TabletUoverUwtfilt41, TabletUoverUwtfilt42 = TabletUoverUwtfilt42, TabletUoverUwtfilt51 = TabletUoverUwtfilt51, TabletUoverUwtfilt52 = TabletUoverUwtfilt52, TabletUoverUwtfilt61 = TabletUoverUwtfilt61, TabletUoverUwtfilt62 = TabletUoverUwtfilt62, TabletUoverUwtfilt71 = TabletUoverUwtfilt71, TabletUoverUwtfilt72 = TabletUoverUwtfilt72, TabletUoverUwtfilt81 = TabletUoverUwtfilt81, TabletUoverUwtfilt82 = TabletUoverUwtfilt82, TabletUunderUwtfilt = TabletUunderUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, TabletUunderUwtfilt41 = TabletUunderUwtfilt41, TabletUunderUwtfilt42 = TabletUunderUwtfilt42, TabletUunderUwtfilt51 = TabletUunderUwtfilt51, TabletUunderUwtfilt52 = TabletUunderUwtfilt52, TabletUunderUwtfilt61 = TabletUunderUwtfilt61, TabletUunderUwtfilt62 = TabletUunderUwtfilt62, TabletUunderUwtfilt71 = TabletUunderUwtfilt71, TabletUunderUwtfilt72 = TabletUunderUwtfilt72, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfoverfwtfilt41 = Tabletfoverfwtfilt41, Tabletfoverfwtfilt42 = Tabletfoverfwtfilt42, Tabletfunderfwtfilt = Tabletfunderfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, Tabletfunderfwtfilt41 = Tabletfunderfwtfilt41, Tabletfunderfwtfilt42 = Tabletfunderfwtfilt42, Tabletfunderfwtfilt51 = Tabletfunderfwtfilt51, Tabletfunderfwtfilt52 = Tabletfunderfwtfilt52, Tabletfunderfwtfilt61 = Tabletfunderfwtfilt61, Tabletfunderfwtfilt62 = Tabletfunderfwtfilt62, U0Pu = U0Pu,UOverPu = UOverPu, UPhase0 = UPhase0, UUnderPu = UUnderPu, fOverPu = fOverPu, fUnderPu = fUnderPu, tS = tS, tUFilt = tUFilt, tfFilt = tfFilt, tphiFilt = tphiFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {10, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.MeasurementsPQ measurementsPQ(P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(control4A.ipMaxPu, injector.ipMaxPu) annotation(
    Line(points = {{-36, -24}, {-2, -24}}, color = {0, 0, 127}));
  connect(control4A.ipCmdPu, injector.ipCmdPu) annotation(
    Line(points = {{-36, -32}, {-2, -32}}, color = {0, 0, 127}));
  connect(control4A.iqMaxPu, injector.iqMaxPu) annotation(
    Line(points = {{-36, -40}, {-2, -40}}, color = {0, 0, 127}));
  connect(control4A.iqCmdPu, injector.iqCmdPu) annotation(
    Line(points = {{-36, -48}, {-2, -48}}, color = {0, 0, 127}));
  connect(control4A.iqMinPu, injector.iqMinPu) annotation(
    Line(points = {{-36, -56}, {-2, -56}}, color = {0, 0, 127}));
  connect(xWTRefPu, control4A.xWTRefPu) annotation(
    Line(points = {{-130, -60}, {-100, -60}, {-100, -52}, {-80, -52}}, color = {0, 0, 127}));
  connect(tanPhi, control4A.tanPhi) annotation(
    Line(points = {{-130, -40}, {-80, -40}}, color = {0, 0, 127}));
  connect(PWTRefPu, control4A.PWTRefPu) annotation(
    Line(points = {{-130, -20}, {-100, -20}, {-100, -34}, {-80, -34}}, color = {0, 0, 127}));
  connect(const.y, control4A.omegaGenPu) annotation(
    Line(points = {{-70, 0}, {-58, 0}, {-58, -18}}, color = {0, 0, 127}));
  connect(injector.uWtPu, gridProtection.uWtPu) annotation(
    Line(points = {{42, -28}, {100, -28}, {100, 102}, {72, 102}}, color = {85, 170, 255}));
  connect(gridProtection.fOCB, injector.fOCB) annotation(
    Line(points = {{60, 58}, {60, -10}, {20, -10}, {20, -18}}, color = {255, 0, 255}));
  connect(omegaRefPu, gridProtection.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 120}, {52, 120}, {52, 102}}, color = {0, 0, 127}));
  connect(injector.uWtPu, complexToPolar.u) annotation(
    Line(points = {{42, -28}, {50, -28}, {50, 30}, {22, 30}}, color = {85, 170, 255}));
  connect(complexToPolar.len, control4A.UWTPu) annotation(
    Line(points = {{-2, 36}, {-86, 36}, {-86, -28}, {-80, -28}}, color = {0, 0, 127}));
  connect(complexToPolar.len, pll.UWTPu) annotation(
    Line(points = {{-2, 36}, {-86, 36}, {-86, 102}, {-28, 102}, {-28, 98}}, color = {0, 0, 127}));
  connect(complexToPolar.phi, pll.theta) annotation(
    Line(points = {{-2, 24}, {-60, 24}, {-60, 108}, {-12, 108}, {-12, 98}}, color = {0, 0, 127}));
  connect(measurementsPQ.PPu, control4A.PWTPu) annotation(
    Line(points = {{-13, -79}, {-12.5, -79}, {-12.5, -73}, {-92, -73}, {-92, -46}, {-80, -46}}, color = {0, 0, 127}));
  connect(measurementsPQ.QPu, control4A.QWTPu) annotation(
    Line(points = {{-7, -79}, {-6.5, -79}, {-6.5, -69}, {-88, -69}, {-88, -58.5}, {-80, -58.5}, {-80, -58}}, color = {0, 0, 127}));
  connect(injector.uWtPu, measurementsPQ.uPu) annotation(
    Line(points = {{42, -28}, {50, -28}, {50, -84}, {1, -84}}, color = {85, 170, 255}));
  connect(injector.iWtPu, measurementsPQ.iPu) annotation(
    Line(points = {{42, -24}, {70, -24}, {70, -90}, {1, -90}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69.5, -1.5}, extent = {{-40, 20}, {41, -19}}, textString = "A"), Text(origin = {3, -41}, extent = {{-53, 24}, {53, -24}}, textString = "2015")}));
end WT4ACurrentSource2015;
