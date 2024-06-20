within Dynawo.Electrical.Controls.IEC.IEC61400.WT;

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

model Control4B2020 "Whole generator control module for type 4B wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseControl4;

  //PControl parameters
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4BPu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4BPu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPAero "Aerodynamic power response time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4B "Power order lag time constant in s" annotation(
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

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PAeroPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Aerodynamic power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.QLimiter2020 qLimiter(P0Pu = P0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, SNom = SNom, U0Pu = U0Pu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.PControl4B2020 pControl4B(DPMaxP4BPu = DPMaxP4BPu, DPRefMax4BPu = DPRefMax4BPu, DPRefMin4BPu = DPRefMin4BPu, IpMax0Pu = IpMax0Pu, Kpaw = Kpaw, MpUScale = MpUScale, P0Pu = P0Pu, SNom = SNom, U0Pu = U0Pu, UpDipPu = UpDipPu, tPAero = tPAero, tPOrdP4B = tPOrdP4B, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {20, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.QControl2020 qControl(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IqH1Pu = IqH1Pu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MqG = MqG, Mqfrt = Mqfrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, URef0Pu = URef0Pu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.CurrentLimiter2020 currentLimiter(IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, MdfsLim = MdfsLim, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, UpquMaxPu = UpquMaxPu) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(PWTCFiltPu, qLimiter.PWTCFiltPu) annotation(
    Line(points = {{-180, -60}, {-140, -60}, {-140, -52}, {-102, -52}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, qLimiter.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-120, 20}, {-120, -40}, {-102, -40}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, currentLimiter.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-120, 20}, {-120, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(omegaGenPu, currentLimiter.omegaGenPu) annotation(
    Line(points = {{-180, 100}, {-100, 100}, {-100, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(currentLimiter.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{122, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(currentLimiter.iqMinPu, iqMinPu) annotation(
    Line(points = {{122, -12}, {140, -12}, {140, -20}, {170, -20}}, color = {0, 0, 127}));
  connect(currentLimiter.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{122, 12}, {140, 12}, {140, 20}, {170, 20}}, color = {0, 0, 127}));
  connect(const.y, currentLimiter.iqMaxHookPu) annotation(
    Line(points = {{2, 40}, {94, 40}, {94, 22}}, color = {0, 0, 127}));
  connect(const.y, currentLimiter.iMaxHookPu) annotation(
    Line(points = {{2, 40}, {106, 40}, {106, 22}}, color = {0, 0, 127}));
  connect(qControl.fFrt, currentLimiter.fFrt) annotation(
    Line(points = {{42, -76}, {52, -76}, {52, -8}, {78, -8}}, color = {255, 127, 0}));
  connect(qControl.iqCmdPu, currentLimiter.iqCmdPu) annotation(
    Line(points = {{42, -84}, {60, -84}, {60, -16}, {78, -16}}, color = {0, 0, 127}));
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
  connect(PWTRefPu, pControl4B.PWTRefPu) annotation(
    Line(points = {{-180, 140}, {-100, 140}, {-100, 112}, {-2, 112}}, color = {0, 0, 127}));
  connect(UWTCPu, pControl4B.UWTCPu) annotation(
    Line(points = {{-180, 60}, {-80, 60}, {-80, 104}, {-2, 104}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, pControl4B.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-60, 20}, {-60, 96}, {-2, 96}}, color = {0, 0, 127}));
  connect(currentLimiter.ipMaxPu, pControl4B.ipMaxPu) annotation(
    Line(points = {{122, 12}, {140, 12}, {140, 60}, {-20, 60}, {-20, 88}, {-2, 88}}, color = {0, 0, 127}));
  connect(pControl4B.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{42, 100}, {170, 100}}, color = {0, 0, 127}));
  connect(pControl4B.ipCmdPu, currentLimiter.ipCmdPu) annotation(
    Line(points = {{42, 100}, {60, 100}, {60, 16}, {78, 16}}, color = {0, 0, 127}));
  connect(pControl4B.PAeroPu, PAeroPu) annotation(
    Line(points = {{42, 112}, {60, 112}, {60, 140}, {170, 140}}, color = {0, 0, 127}));
  connect(omegaGenPu, pControl4B.omegaGenPu) annotation(
    Line(points = {{-180, 100}, {-100, 100}, {-100, 108}, {-2, 108}}, color = {0, 0, 127}));
  connect(qControl.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{42, -84}, {170, -84}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})),
    Icon(graphics = {Text(origin = {75, 31}, extent = {{-76, -18}, {92, 28}}, textString = "B"), Text(origin = {-9, -70}, extent = {{-68, -11}, {88, 22}}, textString = "2020")}));
end Control4B2020;
