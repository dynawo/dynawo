within Dynawo.Electrical.Controls.IEC.WT;

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

model Control4A2020 "Whole generator control module for type 4A wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.BaseClasses.BaseControl4;

  //PControl parameters
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
  parameter Types.VoltageModulePu UpDipPu "Voltage threshold to activate voltage scaling for power reference during voltage dip in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));

  //QControl parameters
  parameter Types.VoltageModulePu DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer Mqfrt "FRT Q control modes (0-3) (see Table 29, section 7.7.5, page 60 of the IEC norm N°61400-27-1)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUss "Steady-state voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqRisePu "Voltage threshold for OVRT detection in Q control in pu (base UNom) (typically equal to UpquMaxPu)" annotation(
    Dialog(tab = "QControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PWTCFiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWTCFiltPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -89.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.QLimiter2020 qLimiter(P0Pu = P0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, SNom = SNom, U0Pu = U0Pu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.PControl4A2020 pControl4A(DPMaxP4APu = DPMaxP4APu, DPRefMax4APu = DPRefMax4APu, DPRefMin4APu = DPRefMin4APu, IpMax0Pu = IpMax0Pu, Kpaw = Kpaw, MpUScale = MpUScale, P0Pu = P0Pu, SNom = SNom, U0Pu = U0Pu, UpDipPu = UpDipPu, tPOrdP4A = tPOrdP4A, tPWTRef4A = tPWTRef4A) annotation(
    Placement(visible = true, transformation(origin = {20, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.QControl2020 qControl(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IqH1Pu = IqH1Pu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MqG = MqG, Mqfrt = Mqfrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, URef0Pu = URef0Pu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.CurrentLimiter2020 currentLimiter(IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, MdfsLim = MdfsLim, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, UpquMaxPu = UpquMaxPu) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(PWTCFiltPu, qLimiter.PWTCFiltPu) annotation(
    Line(points = {{-180, -60}, {-140, -60}, {-140, -52}, {-102, -52}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, qLimiter.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-120, 20}, {-120, -40}, {-102, -40}}, color = {0, 0, 127}));
  connect(currentLimiter.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{122, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(currentLimiter.iqMinPu, iqMinPu) annotation(
    Line(points = {{122, -12}, {140, -12}, {140, -20}, {170, -20}}, color = {0, 0, 127}));
  connect(currentLimiter.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{122, 12}, {140, 12}, {140, 20}, {170, 20}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, currentLimiter.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-120, 20}, {-120, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(qControl.fFrt, currentLimiter.fFrt) annotation(
    Line(points = {{42, -76}, {52, -76}, {52, -8}, {78, -8}}, color = {255, 127, 0}));
  connect(qControl.iqCmdPu, currentLimiter.iqCmdPu) annotation(
    Line(points = {{42, -84}, {60, -84}, {60, -16}, {78, -16}}, color = {0, 0, 127}));
  connect(omegaGenPu, currentLimiter.omegaGenPu) annotation(
    Line(points = {{-180, 100}, {-100, 100}, {-100, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(const.y, currentLimiter.iqMaxHookPu) annotation(
    Line(points = {{2, 40}, {94, 40}, {94, 22}}, color = {0, 0, 127}));
  connect(const.y, currentLimiter.iMaxHookPu) annotation(
    Line(points = {{2, 40}, {106, 40}, {106, 22}}, color = {0, 0, 127}));
  connect(PWTCFiltPu, qControl.PWTCFiltPu) annotation(
    Line(points = {{-180, -60}, {-140, -60}, {-140, -84}, {-2, -84}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, qControl.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-120, 20}, {-120, -76}, {-2, -76}}, color = {0, 0, 127}));
  connect(xWTRefPu, qControl.xWTRefPu) annotation(
    Line(points = {{-180, -100}, {-80, -100}, {-80, -90}, {-2, -90}}, color = {0, 0, 127}));
  connect(QWTCFiltPu, qControl.QWTCFiltPu) annotation(
    Line(points = {{-180, -140}, {-60, -140}, {-60, -96}, {-2, -96}}, color = {0, 0, 127}));
  connect(qControl.fFrt, qLimiter.fFrt) annotation(
    Line(points = {{42, -76}, {52, -76}, {52, -8}, {-112, -8}, {-112, -28}, {-102, -28}}, color = {255, 127, 0}));
  connect(tanPhi, qControl.tanPhi) annotation(
    Line(points = {{-180, -20}, {10, -20}, {10, -58}}, color = {0, 0, 127}));
  connect(qLimiter.QWTMinPu, qControl.QWTMinPu) annotation(
    Line(points = {{-58, -48}, {-40, -48}, {-40, -70}, {-2, -70}}, color = {0, 0, 127}));
  connect(qLimiter.QWTMaxPu, qControl.QWTMaxPu) annotation(
    Line(points = {{-58, -32}, {-20, -32}, {-20, -64}, {-2, -64}}, color = {0, 0, 127}));
  connect(const.y, qControl.idfHookPu) annotation(
    Line(points = {{2, 40}, {20, 40}, {20, -58}}, color = {0, 0, 127}));
  connect(const.y, qControl.ipfHookPu) annotation(
    Line(points = {{2, 40}, {30, 40}, {30, -58}}, color = {0, 0, 127}));
  connect(PWTRefPu, pControl4A.PWTRefPu) annotation(
    Line(points = {{-180, 140}, {-100, 140}, {-100, 112}, {-2, 112}}, color = {0, 0, 127}));
  connect(UWTCPu, pControl4A.UWTCPu) annotation(
    Line(points = {{-180, 60}, {-80, 60}, {-80, 104}, {-2, 104}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, pControl4A.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-60, 20}, {-60, 96}, {-2, 96}}, color = {0, 0, 127}));
  connect(pControl4A.ipCmdPu, currentLimiter.ipCmdPu) annotation(
    Line(points = {{42, 100}, {60, 100}, {60, 16}, {78, 16}}, color = {0, 0, 127}));
  connect(currentLimiter.ipMaxPu, pControl4A.ipMaxPu) annotation(
    Line(points = {{122, 12}, {140, 12}, {140, 60}, {-20, 60}, {-20, 88}, {-2, 88}}, color = {0, 0, 127}));
  connect(pControl4A.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{42, 100}, {170, 100}}, color = {0, 0, 127}));
  connect(qControl.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{42, -84}, {170, -84}}, color = {0, 0, 127}));  protected

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-16, 31}, extent = {{-76, -18}, {92, 28}}, textString = "IEC WT 4A"), Text(origin = {-11, -34}, extent = {{-77, -16}, {100, 30}}, textString = "Generator Control"), Text(origin = {-12, -4}, extent = {{-58, -10}, {75, 20}}, textString = "2020")}),
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
end Control4A2020;
