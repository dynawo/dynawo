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

model WT3ACurrentSource2020 "Wind Turbine Type 4A model from IEC 61400-27-1:2020 standard"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWTCurrentSource2020(
  
  redeclare Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control3AB2020 controlSubstructure(DPMaxPu=DPMaxPu, DPRefMax4abPu=DPRefMax4abPu, DPRefMin4abPu=DPRefMin4abPu, KDtd=KDtd, MOmegaTMax=MOmegaTMax, MOmegaTqpi=MOmegaTqpi, MPUscale=MPUscale, OmegaDtdPu=OmegaDtdPu, OmegaOffsetPu=OmegaOffsetPu, PDtdMaxPu=PDtdMaxPu, TableOmegaPPu=TableOmegaPPu, tOmegafiltp3=tOmegafiltp3, tOmegaRef=tOmegaRef, tPord=tPord, Zeta=Zeta, DTauMaxPu=DTauMaxPu, DTauUvrtMaxPu=DTauUvrtMaxPu, KIp=KIp, KPp=KPp, MPUvrt=MPUvrt, TauEMinPu=TauEMinPu, TauUscalePu=TauUscalePu, tDvs=tDvs, UDvsPu=UDvsPu, UPdipPu=UPdipPu, PBaseTurb=PBaseTurb, PBaseMeasurement=PBaseMeasurement, POrd0Pu=POrd0Pu, PWtcFilt0Pu=PWtcFilt0Pu, UWtc0Pu=UWtc0Pu,
      DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss),
  
  redeclare Dynawo.Electrical.Sources.IEC.WT3aInjector injector(KPc=KPc,TIc=TIc,XEqv=XEqv,BesPu = BesPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, XesPu = XesPu, i0Pu = i0Pu, u0Pu = u0Pu)
  
  );

// GenSystem parameters
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.Parameters.GenSystem3a;
  // P control parameters
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.TorquePi;
  //Mechanical parameters
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical;
 
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.Mechanical mechanical(CdrtPu = CdrtPu, Hgen = Hgen, Hwtr = Hwtr, KdrtPu = KdrtPu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
 Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control3AB2020 control annotation(
    Placement(visible = true, transformation(origin = {-58, -38}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
 Dynawo.Electrical.Sources.IEC.WT3aInjector injector annotation(
    Placement(visible = true, transformation(origin = {14, -38}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
equation
 connect(control.ipMaxPu, injector.ipMaxPu) annotation(
    Line(points = {{-34, -30}, {-28, -30}, {-28, -21}, {-10, -21}}, color = {0, 0, 127}));
 connect(control.ipCmdPu, injector.ipCmdPu) annotation(
    Line(points = {{-34, -34}, {-24, -34}, {-24, -30}, {-10, -30}}, color = {0, 0, 127}));
 connect(control.iqMaxPu, injector.iqMaxPu) annotation(
    Line(points = {{-34, -42}, {-22, -42}, {-22, -38}, {-10, -38}}, color = {0, 0, 127}));
 connect(control.iqCmdPu, injector.iqCmdPu) annotation(
    Line(points = {{-34, -46}, {-10, -46}}, color = {0, 0, 127}));
 connect(control.iqMinPu, injector.iqMinPu) annotation(
    Line(points = {{-34, -50}, {-22, -50}, {-22, -56}, {-10, -56}}, color = {0, 0, 127}));
 connect(control.PWTRefPu, PWTRefPu) annotation(
    Line(points = {{-82, -20}, {-130, -20}}, color = {0, 0, 127}));
 connect(control.PWTCFiltPu, controlMeasurements.PFiltPu) annotation(
    Line(points = {{-82, -24}, {-96, -24}, {-96, 58}}, color = {0, 0, 127}));
 connect(control.QWTCFiltPu, controlMeasurements.QFiltPu) annotation(
    Line(points = {{-82, -56}, {-92, -56}, {-92, 58}}, color = {0, 0, 127}));
 connect(control.UWTCPu, controlMeasurements.UPu) annotation(
    Line(points = {{-82, -32}, {-90, -32}, {-90, 44}, {-80, 44}, {-80, 58}}, color = {0, 0, 127}));
 connect(control.UWTCFiltPu, controlMeasurements.UFiltPu) annotation(
    Line(points = {{-82, -36}, {-88, -36}, {-88, 42}, {-76, 42}, {-76, 58}}, color = {0, 0, 127}));
 connect(control.tanPhi, tanPhi) annotation(
    Line(points = {{-82, -44}, {-112, -44}, {-112, -40}, {-130, -40}}, color = {0, 0, 127}));
 connect(control.xWTRefPu, xWTRefPu) annotation(
    Line(points = {{-82, -50}, {-104, -50}, {-104, -60}, {-130, -60}}, color = {0, 0, 127}));
 connect(mechanical.omegaGenPu, control.omegaGenPu) annotation(
    Line(points = {{102, -72}, {106, -72}, {106, -6}, {-58, -6}, {-58, -14}}, color = {0, 0, 127}));
 connect(gridProtection.fOCB, injector.fOCB) annotation(
    Line(points = {{60, -2}, {60, -8}, {14, -8}, {14, -14}}, color = {255, 0, 255}));
 connect(pll.thetaPll, injector.theta) annotation(
    Line(points = {{-20, 54}, {-20, 24}, {0, 24}, {0, -14}}, color = {0, 0, 127}));
 connect(injector.terminal, terminal) annotation(
    Line(points = {{38, -38}, {83, -38}, {83, -40}, {130, -40}}, color = {0, 0, 255}));
 connect(injector.iWtPu, protectionMeasurements.iPu) annotation(
    Line(points = {{38, -20}, {86, -20}, {86, 110}, {60, 110}, {60, 102}}, color = {85, 170, 255}));
 connect(injector.iWtPu, controlMeasurements.iPu) annotation(
    Line(points = {{38, -20}, {86, -20}, {86, 110}, {-80, 110}, {-80, 102}}, color = {85, 170, 255}));
 connect(injector.uWtPu, controlMeasurements.uPu) annotation(
    Line(points = {{38, -24}, {88, -24}, {88, 114}, {-92, 114}, {-92, 102}}, color = {85, 170, 255}));
 connect(injector.uWtPu, protectionMeasurements.uPu) annotation(
    Line(points = {{38, -24}, {88, -24}, {88, 114}, {72, 114}, {72, 102}}, color = {85, 170, 255}));
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69, -1}, extent = {{-40, 19}, {41, -19}}, textString = "B"), Text(origin = {3, -41}, extent = {{-53, 24}, {53, -24}}, textString = "2020")}));
end WT3ACurrentSource2020;
