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
 extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWTCurrentSource2020;

  // GenSystem parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem4;

  // PControl parameters
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
  parameter Types.PerUnit Kpaw "Anti-windup gain for active power in pu/s (base SNom)" annotation(Dialog(tab = "PControl", group = "WT"));

  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-75, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control4A2020 control(DPMaxP4APu = DPMaxP4APu, DPRefMax4APu = DPRefMax4APu, DPRefMin4APu = DPRefMin4APu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom,TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt = TableIqMaxUwt, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableIqMaxUwt71 = TableIqMaxUwt71, TableIqMaxUwt72 = TableIqMaxUwt72, TableIqMaxUwt81 = TableIqMaxUwt81, TableIqMaxUwt82 = TableIqMaxUwt82, TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxPwtcFilt32 = TableQMaxPwtcFilt32, TableQMaxPwtcFilt41 = TableQMaxPwtcFilt41, TableQMaxPwtcFilt42 = TableQMaxPwtcFilt42, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinPwtcFilt11 = TableQMinPwtcFilt11, TableQMinPwtcFilt12 = TableQMinPwtcFilt12, TableQMinPwtcFilt21 = TableQMinPwtcFilt21, TableQMinPwtcFilt22 = TableQMinPwtcFilt22, TableQMinPwtcFilt31 = TableQMinPwtcFilt31, TableQMinPwtcFilt32 = TableQMinPwtcFilt32, TableQMinPwtcFilt41 = TableQMinPwtcFilt41, TableQMinPwtcFilt42 = TableQMinPwtcFilt42, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPOrdP4A = tPOrdP4A, tPWTRef4A = tPWTRef4A, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {-47, -37}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));

 Dynawo.Electrical.Sources.IEC.WT4Injector injector(BesPu = BesPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kipaw = Kipaw, Kiqaw = Kiqaw, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, XesPu = XesPu, i0Pu = i0Pu, tG = tG, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {31, -37}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
equation
 connect(const.y, control.omegaGenPu) annotation(
    Line(points = {{-70, 0}, {-46, 0}, {-46, -12}}, color = {0, 0, 127}));
 connect(control.ipMaxPu, injector.ipMaxPu) annotation(
    Line(points = {{-22, -18}, {6, -18}}, color = {0, 0, 127}));
 connect(control.ipCmdPu, injector.ipCmdPu) annotation(
    Line(points = {{-22, -28}, {6, -28}}, color = {0, 0, 127}));
 connect(control.iqMaxPu, injector.iqMaxPu) annotation(
    Line(points = {{-22, -36}, {-8, -36}, {-8, -38}, {6, -38}}, color = {0, 0, 127}));
 connect(control.iqCmdPu, injector.iqCmdPu) annotation(
    Line(points = {{-22, -46}, {6, -46}}, color = {0, 0, 127}));
 connect(control.iqMinPu, injector.iqMinPu) annotation(
    Line(points = {{-22, -56}, {6, -56}}, color = {0, 0, 127}));
 connect(injector.terminal, terminal) annotation(
    Line(points = {{56, -38}, {92, -38}, {92, -40}, {130, -40}}, color = {0, 0, 255}));
 connect(controlMeasurements.iPu, injector.iWtPu) annotation(
    Line(points = {{-80, 102}, {-80, 112}, {92, 112}, {92, -18}, {56, -18}}, color = {85, 170, 255}));
 connect(injector.iWtPu, protectionMeasurements.iPu) annotation(
    Line(points = {{56, -18}, {92, -18}, {92, 112}, {60, 112}, {60, 102}}, color = {85, 170, 255}));
 connect(controlMeasurements.uPu, injector.uWtPu) annotation(
    Line(points = {{-92, 102}, {-92, 114}, {94, 114}, {94, -24}, {56, -24}}, color = {85, 170, 255}));
 connect(injector.uWtPu, protectionMeasurements.uPu) annotation(
    Line(points = {{56, -24}, {94, -24}, {94, 114}, {72, 114}, {72, 102}}, color = {85, 170, 255}));
 connect(control.UWTCFiltPu, controlMeasurements.UFiltPu) annotation(
    Line(points = {{-72, -16}, {-88, -16}, {-88, 46}, {-76, 46}, {-76, 58}}, color = {0, 0, 127}));
 connect(control.UWTCPu, controlMeasurements.UPu) annotation(
    Line(points = {{-72, -24}, {-92, -24}, {-92, 48}, {-80, 48}, {-80, 58}}, color = {0, 0, 127}));
 connect(control.PWTRefPu, PWTRefPu) annotation(
    Line(points = {{-72, -30}, {-100, -30}, {-100, -20}, {-130, -20}}, color = {0, 0, 127}));
 connect(control.tanPhi, tanPhi) annotation(
    Line(points = {{-72, -36}, {-112, -36}, {-112, -40}, {-130, -40}}, color = {0, 0, 127}));
 connect(control.xWTRefPu, xWTRefPu) annotation(
    Line(points = {{-72, -50}, {-110, -50}, {-110, -60}, {-130, -60}}, color = {0, 0, 127}));
 connect(control.PWTCFiltPu, controlMeasurements.PFiltPu) annotation(
    Line(points = {{-72, -44}, {-96, -44}, {-96, 58}}, color = {0, 0, 127}));
 connect(controlMeasurements.QFiltPu, control.QWTCFiltPu) annotation(
    Line(points = {{-92, 58}, {-92, 53.5}, {-94, 53.5}, {-94, -58}, {-72, -58}}, color = {0, 0, 127}));
 connect(gridProtection.fOCB, injector.fOCB) annotation(
    Line(points = {{60, -2}, {60, -8}, {32, -8}, {32, -12}}, color = {255, 0, 255}));
 connect(pll.thetaPll, injector.theta) annotation(
    Line(points = {{-20, 54}, {-20, 20}, {18, 20}, {18, -12}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {2, -5}, extent = {{-63, 25}, {64, -25}}, textString = "Type 4A")}),
 Diagram);

end WT4ACurrentSource2020;
