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
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWTCurrentSource2020;
  
  // GenSystem parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem4;
  // P control parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT4b;
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT4Base;
  //Mechanical parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.Mechanical;
  
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.Mechanical mechanical(CdrtPu = CdrtPu, Hgen = Hgen, Hwtr = Hwtr, KdrtPu = KdrtPu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
  
  Dynawo.Electrical.Sources.IEC.WT4Injector injector(BesPu = BesPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kipaw = Kipaw, Kiqaw = Kiqaw, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, XesPu = XesPu, i0Pu = i0Pu, tG = tG, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {19, -41}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  
  Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control4B2020 control(DPMaxP4BPu = DPMaxP4BPu, DPRefMax4BPu = DPRefMax4BPu, DPRefMin4BPu = DPRefMin4BPu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPAero = tPAero, tPOrdP4B = tPOrdP4B, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {-63, -41}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
equation
  connect(injector.terminal, terminal) annotation(
    Line(points = {{46, -40}, {130, -40}}, color = {0, 0, 255}));
  connect(gridProtection.fOCB, injector.fOCB) annotation(
    Line(points = {{60, -2}, {60, -8}, {20, -8}, {20, -14}}, color = {255, 0, 255}));
  connect(pll.thetaPll, injector.theta) annotation(
    Line(points = {{-20, 54}, {-20, 24}, {4, 24}, {4, -14}}, color = {0, 0, 127}));
  connect(control.ipCmdPu, injector.ipCmdPu) annotation(
    Line(points = {{-28, -30}, {-8, -30}}, color = {0, 0, 127}));
  connect(control.iqMaxPu, injector.iqMaxPu) annotation(
    Line(points = {{-28, -40}, {-8, -40}}, color = {0, 0, 127}));
  connect(control.iqCmdPu, injector.iqCmdPu) annotation(
    Line(points = {{-28, -50}, {-8, -50}}, color = {0, 0, 127}));
  connect(control.iqMinPu, injector.iqMinPu) annotation(
    Line(points = {{-28, -60}, {-8, -60}}, color = {0, 0, 127}));
  connect(injector.PAgPu, mechanical.PAgPu) annotation(
    Line(points = {{46, -60}, {52, -60}, {52, -72}, {58, -72}}, color = {0, 0, 127}));
  connect(injector.iWtPu, protectionMeasurements.iPu) annotation(
    Line(points = {{46, -20}, {88, -20}, {88, 112}, {60, 112}, {60, 102}}, color = {85, 170, 255}));
  connect(injector.iWtPu, controlMeasurements.iPu) annotation(
    Line(points = {{46, -20}, {88, -20}, {88, 112}, {-80, 112}, {-80, 102}}, color = {85, 170, 255}));
  connect(injector.uWtPu, controlMeasurements.uPu) annotation(
    Line(points = {{46, -26}, {90, -26}, {90, 114}, {-92, 114}, {-92, 102}}, color = {85, 170, 255}));
  connect(injector.uWtPu, protectionMeasurements.uPu) annotation(
    Line(points = {{46, -26}, {90, -26}, {90, 114}, {72, 114}, {72, 102}}, color = {85, 170, 255}));
  connect(control.ipCmdPu, injector.ipCmdPu) annotation(
    Line(points = {{-36, -30}, {-8, -30}}, color = {0, 0, 127}));
  connect(control.iqMaxPu, injector.iqMaxPu) annotation(
    Line(points = {{-36, -40}, {-8, -40}}, color = {0, 0, 127}));
  connect(control.iqCmdPu, injector.iqCmdPu) annotation(
    Line(points = {{-36, -50}, {-8, -50}}, color = {0, 0, 127}));
  connect(control.iqMinPu, injector.iqMinPu) annotation(
    Line(points = {{-36, -60}, {-8, -60}}, color = {0, 0, 127}));
  connect(control.PAeroPu, mechanical.PAeroPu) annotation(
    Line(points = {{-62, -68}, {-62, -88}, {58, -88}}, color = {0, 0, 127}));
  connect(control.omegaGenPu, mechanical.omegaGenPu) annotation(
    Line(points = {{-62, -14}, {-64, -14}, {-64, -4}, {108, -4}, {108, -72}, {102, -72}}, color = {0, 0, 127}));
  connect(controlMeasurements.UFiltPu, control.UWTCFiltPu) annotation(
    Line(points = {{-76, 58}, {-76, -4}, {-98, -4}, {-98, -18}, {-90, -18}}, color = {0, 0, 127}));
  connect(control.UWTCPu, controlMeasurements.UPu) annotation(
    Line(points = {{-90, -26}, {-100, -26}, {-100, -2}, {-80, -2}, {-80, 58}}, color = {0, 0, 127}));
  connect(control.PWTRefPu, PWTRefPu) annotation(
    Line(points = {{-90, -34}, {-116, -34}, {-116, -20}, {-130, -20}}, color = {0, 0, 127}));
  connect(control.tanPhi, tanPhi) annotation(
    Line(points = {{-90, -40}, {-130, -40}}, color = {0, 0, 127}));
  connect(control.xWTRefPu, xWTRefPu) annotation(
    Line(points = {{-90, -56}, {-116, -56}, {-116, -60}, {-130, -60}}, color = {0, 0, 127}));
  connect(controlMeasurements.PFiltPu, control.PWTCFiltPu) annotation(
    Line(points = {{-96, 58}, {-96, 38}, {-104, 38}, {-104, -48}, {-90, -48}}, color = {0, 0, 127}));
  connect(controlMeasurements.QFiltPu, control.QWTCFiltPu) annotation(
    Line(points = {{-92, 58}, {-92, 36}, {-102, 36}, {-102, -64}, {-90, -64}}, color = {0, 0, 127}));
  connect(control.ipMaxPu, injector.ipMaxPu) annotation(
    Line(points = {{-36, -20}, {-8, -20}, {-8, -22}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69, -1}, extent = {{-40, 19}, {41, -19}}, textString = "B"), Text(origin = {3, -41}, extent = {{-53, 24}, {53, -24}}, textString = "2020")}));
end WT4BCurrentSource2020;
