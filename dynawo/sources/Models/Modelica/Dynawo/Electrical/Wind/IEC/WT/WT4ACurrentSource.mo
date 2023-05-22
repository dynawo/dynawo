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

model WT4ACurrentSource "Wind Turbine Type 4A model from IEC 61400-27-1 standard : measurement, PLL, protection, PControl, QControl, limiters, electrical and generator modules"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWT4;

  //PControl parameters
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4APu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4APu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPWTRef4A "Reference power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));

  Dynawo.Electrical.Controls.IEC.WT.Control4A control4A(DPMaxP4APu = DPMaxP4APu, DPRefMax4APu = DPRefMax4APu, DPRefMin4APu = DPRefMin4APu, DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MdfsLim = MdfsLim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpDipPu = UpDipPu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPOrdP4A = tPOrdP4A, tPWTRef4A = tPWTRef4A, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-75, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

equation
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

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69.5, -1.5}, extent = {{-40, 20}, {41, -19}}, textString = "A")}));
end WT4ACurrentSource;
