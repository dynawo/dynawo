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
  
  redeclare Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control3AB2020 controlSubstructure(DPMaxPu=DPMaxPu, DPRefMaxPu=DPRefMaxPu, DPRefMinPu=DPRefMinPu, KDtd=KDtd, MOmegaTMax=MOmegaTMax, MOmegaTqpi=MOmegaTqpi, MPUscale=MPUscale, OmegaDtdPu=OmegaDtdPu, OmegaOffsetPu=OmegaOffsetPu, PDtdMaxPu=PDtdMaxPu, TableOmegaPPu=TableOmegaPPu, tOmegafiltp3=tOmegafiltp3, tOmegaRef=tOmegaRef, tPord=tPord, Zeta=Zeta, DTauMaxPu=DTauMaxPu, DTauUvrtMaxPu=DTauUvrtMaxPu, KIp=KIp, KPp=KPp, MPUvrt=MPUvrt, TauEMinPu=TauEMinPu, TauUscalePu=TauUscalePu, tDvs=tDvs, UDvsPu=UDvsPu, UPdipPu=UPdipPu, PBaseTurb=PBaseTurb, PBaseMeasurement=PBaseMeasurement, POrd0Pu=POrd0Pu, PWtcFilt0Pu=PWtcFilt0Pu, UWtc0Pu=UWtc0Pu,
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
equation
  connect(controlSubstructure.omegaGenPu, mechanical.omegaGenPu) annotation(
    Line(points = {{-60, -18}, {-60, -14}, {110, -14}, {110, -72}, {102, -72}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69, -1}, extent = {{-40, 19}, {41, -19}}, textString = "B"), Text(origin = {3, -41}, extent = {{-53, 24}, {53, -24}}, textString = "2020")}));
end WT3ACurrentSource2020;
