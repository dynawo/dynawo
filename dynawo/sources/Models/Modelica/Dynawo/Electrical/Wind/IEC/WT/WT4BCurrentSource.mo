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

model WT4BCurrentSource "Wind Turbine Type 4B model from IEC 61400-27-1 standard : measurement, PLL, protection, PControl, QControl, limiters, electrical, generator and mechanical modules"
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWT4;

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

  Dynawo.Electrical.Controls.IEC.WT.Control4B control4B(DPMaxP4BPu = DPMaxP4BPu, DPRefMax4BPu = DPRefMax4BPu, DPRefMin4BPu = DPRefMin4BPu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPAero = tPAero, tPOrdP4B = tPOrdP4B, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.Mechanical mechanical(CdrtPu = CdrtPu, Hgen = Hgen, Hwtr = Hwtr, KdrtPu = KdrtPu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));

equation
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

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69, -1}, extent = {{-40, 19}, {41, -19}}, textString = "B")}));
end WT4BCurrentSource;
