within Dynawo.Electrical.Wind.IEC.WPP;

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

model WPP4BCurrentSource "Wind Power Plant Type 4B model from IEC 61400-27-1 standard : WT4B, communication modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWPP;

  //PControl parameters
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4BPu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4BPu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4B "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPAero "Reference power order lag time constant in s" annotation(
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

  Dynawo.Electrical.Wind.IEC.WT.WT4BCurrentSource wT4BCurrentSource(BesPu = BesPu, CdrtPu = CdrtPu, DPMaxP4BPu = DPMaxP4BPu, DPRefMax4BPu = DPRefMax4BPu, DPRefMin4BPu = DPRefMin4BPu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, DfcMaxPu = DfcMaxPu, DfpMaxPu = DfpMaxPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, Hgen = Hgen, Hwtr = Hwtr, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, KdrtPu = KdrtPu, Kipaw = Kipaw, Kiq = Kiq, Kiqaw = Kiqaw, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, ResPu = ResPu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UOverPu = UOverPu, UPhase0 = UPhase0, UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, URef0Pu = URef0Pu, UUnderPu = UUnderPu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, XesPu = XesPu, fOverPu = fOverPu, fUnderPu = fUnderPu, i0Pu = i0Pu, tG = tG, tIcFilt = tIcFilt, tIpFilt = tIpFilt, tPAero = tPAero, tPOrdP4B = tPOrdP4B, tPcFilt = tPcFilt, tPll = tPll, tPost = tPost, tPpFilt = tPpFilt, tQcFilt = tQcFilt, tQord = tQord, tQpFilt = tQpFilt, tS = tS, tUcFilt = tUcFilt, tUpFilt = tUpFilt, tUss = tUss, tfcFilt = tfcFilt, tfpFilt = tfpFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(wT4BCurrentSource.terminal, elecMeasurements.terminal1) annotation(
    Line(points = {{42, 0}, {58, 0}}, color = {0, 0, 255}));
  connect(tanPhi, wT4BCurrentSource.tanPhi) annotation(
    Line(points = {{-20, 120}, {-20, 12}, {-2, 12}}, color = {0, 0, 127}));
  connect(wPPControl.PPDRefComPu, wT4BCurrentSource.PWTRefPu) annotation(
    Line(points = {{-38, 8}, {-20, 8}, {-20, 4}, {-2, 4}}, color = {0, 0, 127}));
  connect(wPPControl.xPDRefComPu, wT4BCurrentSource.xWTRefPu) annotation(
    Line(points = {{-38, -8}, {-20, -8}, {-20, -4}, {-2, -4}}, color = {0, 0, 127}));
  connect(omegaRefPu, wT4BCurrentSource.omegaRefPu) annotation(
    Line(points = {{-140, -40}, {-20, -40}, {-20, -12}, {-2, -12}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {70, -1}, extent = {{-36, 16}, {36, -16}}, textString = "B")}));
end WPP4BCurrentSource;
