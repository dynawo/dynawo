within Dynawo.Electrical.Controls.IEC.WT;

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

model Control4B2015 "Whole generator control module for type 4B wind turbines (IEC N°61400-27-1:2015)"
  extends Dynawo.Electrical.Controls.IEC.BaseClasses.BaseControl4;

  //PControl parameters
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
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

  //Q control parameters
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

  //Input parameters
  Modelica.Blocks.Interfaces.RealInput PWTPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWTPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -89.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PAeroPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Aerodynamic power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.Controls.IEC.BaseControls.WT.CurrentLimiter2015 currentLimiter(IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, MdfsLim = MdfsLim, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, UpquMaxPu = UpquMaxPu, tUFiltcl = tUFiltcl) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.PControl4B2015 pControl4B(DPMaxP4BPu = DPMaxP4BPu, IpMax0Pu = IpMax0Pu, Kpaw = Kpaw, P0Pu = P0Pu, SNom = SNom, U0Pu = U0Pu, tPAero = tPAero, tPOrdP4B = tPOrdP4B, tUFiltP4B = tUFiltP4B) annotation(
    Placement(visible = true, transformation(origin = {20, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.QControl2015 qControl(Udb1Pu = Udb1Pu, Udb2Pu = Udb2Pu, IqH1Pu = IqH1Pu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kqv = Kqv, MqG = MqG, MqUvrt = MqUvrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, URef0Pu = URef0Pu, UqDipPu = UqDipPu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPFiltQ = tPFiltQ, tPost = tPost, tQord = tQord, tS = tS, tUFiltQ = tUFiltQ) annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.QLimiter2015 qLimiter(P0Pu = P0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, SNom = SNom, U0Pu = U0Pu, tPFiltql = tPFiltql, tS = tS, tUFiltql = tUFiltql) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(currentLimiter.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{122, 12}, {140, 12}, {140, 20}, {170, 20}}, color = {0, 0, 127}));
  connect(currentLimiter.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{122, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(currentLimiter.iqMinPu, iqMinPu) annotation(
    Line(points = {{122, -12}, {140, -12}, {140, -20}, {170, -20}}, color = {0, 0, 127}));
  connect(currentLimiter.ipMaxPu, pControl4B.ipMaxPu) annotation(
    Line(points = {{122, 12}, {130, 12}, {130, 60}, {-20, 60}, {-20, 88}, {-2, 88}}, color = {0, 0, 127}));
  connect(PWTRefPu, pControl4B.PWTRefPu) annotation(
    Line(points = {{-180, 140}, {-20, 140}, {-20, 112}, {-2, 112}}, color = {0, 0, 127}));
  connect(pControl4B.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{42, 100}, {170, 100}}, color = {0, 0, 127}));
  connect(qControl.fUvrt, currentLimiter.fUvrt) annotation(
    Line(points = {{42, -76}, {60, -76}, {60, -8}, {78, -8}}, color = {255, 127, 0}));
  connect(qControl.iqCmdPu, currentLimiter.iqCmdPu) annotation(
    Line(points = {{42, -84}, {68, -84}, {68, -16}, {78, -16}}, color = {0, 0, 127}));
  connect(qControl.QWTMaxPu, qLimiter.QWTMaxPu) annotation(
    Line(points = {{-2, -70}, {-40, -70}, {-40, -32}, {-58, -32}}, color = {0, 0, 127}));
  connect(qControl.QWTMinPu, qLimiter.QWTMinPu) annotation(
    Line(points = {{-2, -78}, {-48, -78}, {-48, -48}, {-58, -48}}, color = {0, 0, 127}));
  connect(qControl.xWTRefPu, xWTRefPu) annotation(
    Line(points = {{-2, -82}, {-40, -82}, {-40, -100}, {-180, -100}}, color = {0, 0, 127}));
  connect(qControl.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{42, -84}, {170, -84}}, color = {0, 0, 127}));
  connect(tanPhi, qControl.tanPhi) annotation(
    Line(points = {{-180, -20}, {10, -20}, {10, -58}}, color = {0, 0, 127}));
  connect(omegaGenPu, currentLimiter.omegaGenPu) annotation(
    Line(points = {{-180, 100}, {-40, 100}, {-40, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(pControl4B.ipCmdPu, currentLimiter.ipCmdPu) annotation(
    Line(points = {{42, 100}, {60, 100}, {60, 16}, {78, 16}}, color = {0, 0, 127}));
  connect(UWTPu, currentLimiter.UWTPu) annotation(
    Line(points = {{-180, 60}, {-60, 60}, {-60, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(qControl.PWTPu, PWTPu) annotation(
    Line(points = {{-2, -88}, {-140, -88}, {-140, -60}, {-180, -60}}, color = {0, 0, 127}));
  connect(QWTPu, qControl.QWTPu) annotation(
    Line(points = {{-180, -140}, {-20, -140}, {-20, -64}, {-2, -64}}, color = {0, 0, 127}));
  connect(UWTPu, qControl.UWTPu) annotation(
    Line(points = {{-180, 60}, {-130, 60}, {-130, -94}, {-2, -94}}, color = {0, 0, 127}));
  connect(qControl.fUvrt, qLimiter.fUvrt) annotation(
    Line(points = {{42, -76}, {60, -76}, {60, -8}, {-120, -8}, {-120, -28}, {-102, -28}}, color = {255, 127, 0}));
  connect(qLimiter.UWTPu, UWTPu) annotation(
    Line(points = {{-102, -40}, {-130, -40}, {-130, 60}, {-180, 60}}, color = {0, 0, 127}));
  connect(qLimiter.PWTPu, PWTPu) annotation(
    Line(points = {{-102, -52}, {-140, -52}, {-140, -60}, {-180, -60}}, color = {0, 0, 127}));
  connect(omegaGenPu, pControl4B.omegaGenPu) annotation(
    Line(points = {{-180, 100}, {-20, 100}, {-20, 96}, {-2, 96}}, color = {0, 0, 127}));
  connect(UWTPu, pControl4B.UWTPu) annotation(
    Line(points = {{-180, 60}, {-60, 60}, {-60, 104}, {-2, 104}}, color = {0, 0, 127}));
  connect(pControl4B.PAeroPu, PAeroPu) annotation(
    Line(points = {{42, 112}, {60, 112}, {60, 140}, {170, 140}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(origin = {74, 29}, extent = {{-52, -13}, {67, 27}}, textString = "B"), Text(origin = {-9, -70}, extent = {{-68, -11}, {88, 22}}, textString = "2015")}));
end Control4B2015;
