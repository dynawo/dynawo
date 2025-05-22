within Dynawo.Electrical.Controls.IEC.IEC61400.WT;

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
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseControl4;
  
  //PControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT4a;
  
  //QControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWT2020;
  
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
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.QLimiter2020 qLimiter(P0Pu = P0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, SNom = SNom,TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxPwtcFilt32 = TableQMaxPwtcFilt32, TableQMaxPwtcFilt41 = TableQMaxPwtcFilt41, TableQMaxPwtcFilt42 = TableQMaxPwtcFilt42, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinPwtcFilt11 = TableQMinPwtcFilt11, TableQMinPwtcFilt12 = TableQMinPwtcFilt12, TableQMinPwtcFilt21 = TableQMinPwtcFilt21, TableQMinPwtcFilt22 = TableQMinPwtcFilt22, TableQMinPwtcFilt31 = TableQMinPwtcFilt31, TableQMinPwtcFilt32 = TableQMinPwtcFilt32, TableQMinPwtcFilt41 = TableQMinPwtcFilt41, TableQMinPwtcFilt42 = TableQMinPwtcFilt42, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, U0Pu = U0Pu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.PControl4A2020 pControl4A(DPMaxP4APu = DPMaxP4APu, DPRefMax4APu = DPRefMax4APu, DPRefMin4APu = DPRefMin4APu, IpMax0Pu = IpMax0Pu, Kpaw = Kpaw, MpUScale = MpUScale, P0Pu = P0Pu, SNom = SNom, U0Pu = U0Pu, UpDipPu = UpDipPu, tPOrdP4A = tPOrdP4A, tPWTRef4A = tPWTRef4A) annotation(
    Placement(visible = true, transformation(origin = {20, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.QControl2020 qControl(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IqH1Pu = IqH1Pu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MqG = MqG, Mqfrt = Mqfrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, URef0Pu = URef0Pu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.CurrentLimiter2020 currentLimiter(TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt = TableIqMaxUwt, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableIqMaxUwt71 = TableIqMaxUwt71, TableIqMaxUwt72 = TableIqMaxUwt72, TableIqMaxUwt81 = TableIqMaxUwt81, TableIqMaxUwt82 = TableIqMaxUwt82, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, MdfsLim = MdfsLim, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, UpquMaxPu = UpquMaxPu) annotation(
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
