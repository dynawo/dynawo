within Dynawo.Electrical.Controls.IEC.IEC61400.WT;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Control3A2020 "Whole generator control module for type 3A and 3B wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableCurrentLimit;
  extends Dynawo.Electrical.Wind.IEC.Parameters.CurrentLimiter;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialQLimits;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialQSetpoint;
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWTBase;
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWT2020;
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT3;
  extends Dynawo.Electrical.Wind.IEC.Parameters.QLimiter;
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableQLimit;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPqGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialGenSystem;
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.XEqv_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.IntegrationTimeStep;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGs;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omega0Pu) "Angular velocity of generator in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaWTRPu(start = SystemBase.omega0Pu) "Angular velocity of Wind Turbine Rotor (WTR) in pu (base OmegaNom)"  annotation(
    Placement(visible = true, transformation(origin = {-180, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Wind Turbine (WT) active power reference in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 85}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTCFiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWTCFiltPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -130}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage for Wind Turbine Control (WTC) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start=XWT0Pu) "Reactive power loop reference : reactive power or voltage reference depending on the Q control mode (MqG), in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -55.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start=pControl3AB2020.lagPOrd.Y0/U0Pu) "Active current command for generator system model in pu (base SNom/sqrt(3)/UNom)"  annotation(
    Placement(visible = true, transformation(origin = {170, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaRefPu(start=OmegaRef0Pu) "Angular velocity reference value in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {170, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput POrdPu(start=pControl3AB2020.lagPOrd.Y0) "Active power order from wind turbine controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {32, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.QLimiter2020 qLimiter(P0Pu = P0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, SNom = SNom, TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxPwtcFilt11 = TableQMaxPwtcFilt11, TableQMaxPwtcFilt12 = TableQMaxPwtcFilt12, TableQMaxPwtcFilt21 = TableQMaxPwtcFilt21, TableQMaxPwtcFilt22 = TableQMaxPwtcFilt22, TableQMaxPwtcFilt31 = TableQMaxPwtcFilt31, TableQMaxPwtcFilt32 = TableQMaxPwtcFilt32, TableQMaxPwtcFilt41 = TableQMaxPwtcFilt41, TableQMaxPwtcFilt42 = TableQMaxPwtcFilt42, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMaxUwtcFilt11 = TableQMaxUwtcFilt11, TableQMaxUwtcFilt12 = TableQMaxUwtcFilt12, TableQMaxUwtcFilt21 = TableQMaxUwtcFilt21, TableQMaxUwtcFilt22 = TableQMaxUwtcFilt22, TableQMaxUwtcFilt31 = TableQMaxUwtcFilt31, TableQMaxUwtcFilt32 = TableQMaxUwtcFilt32, TableQMaxUwtcFilt41 = TableQMaxUwtcFilt41, TableQMaxUwtcFilt42 = TableQMaxUwtcFilt42, TableQMaxUwtcFilt51 = TableQMaxUwtcFilt51, TableQMaxUwtcFilt52 = TableQMaxUwtcFilt52, TableQMaxUwtcFilt61 = TableQMaxUwtcFilt61, TableQMaxUwtcFilt62 = TableQMaxUwtcFilt62, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinPwtcFilt11 = TableQMinPwtcFilt11, TableQMinPwtcFilt12 = TableQMinPwtcFilt12, TableQMinPwtcFilt21 = TableQMinPwtcFilt21, TableQMinPwtcFilt22 = TableQMinPwtcFilt22, TableQMinPwtcFilt31 = TableQMinPwtcFilt31, TableQMinPwtcFilt32 = TableQMinPwtcFilt32, TableQMinPwtcFilt41 = TableQMinPwtcFilt41, TableQMinPwtcFilt42 = TableQMinPwtcFilt42, TableQMinUwtcFilt = TableQMinUwtcFilt, TableQMinUwtcFilt11 = TableQMinUwtcFilt11, TableQMinUwtcFilt12 = TableQMinUwtcFilt12, TableQMinUwtcFilt21 = TableQMinUwtcFilt21, TableQMinUwtcFilt22 = TableQMinUwtcFilt22, TableQMinUwtcFilt31 = TableQMinUwtcFilt31, TableQMinUwtcFilt32 = TableQMinUwtcFilt32, TableQMinUwtcFilt41 = TableQMinUwtcFilt41, TableQMinUwtcFilt42 = TableQMinUwtcFilt42, U0Pu = U0Pu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.QControl2020 qControl(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IqH1Pu = IqH1Pu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MqG = MqG, Mqfrt = Mqfrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, URef0Pu = URef0Pu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT.CurrentLimiter2020 currentLimiter( IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, MdfsLim = MdfsLim, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom,TableIpMaxUwt = TableIpMaxUwt, TableIpMaxUwt11 = TableIpMaxUwt11, TableIpMaxUwt12 = TableIpMaxUwt12, TableIpMaxUwt21 = TableIpMaxUwt21, TableIpMaxUwt22 = TableIpMaxUwt22, TableIpMaxUwt31 = TableIpMaxUwt31, TableIpMaxUwt32 = TableIpMaxUwt32, TableIpMaxUwt41 = TableIpMaxUwt41, TableIpMaxUwt42 = TableIpMaxUwt42, TableIpMaxUwt51 = TableIpMaxUwt51, TableIpMaxUwt52 = TableIpMaxUwt52, TableIpMaxUwt61 = TableIpMaxUwt61, TableIpMaxUwt62 = TableIpMaxUwt62, TableIpMaxUwt71 = TableIpMaxUwt71, TableIpMaxUwt72 = TableIpMaxUwt72, TableIqMaxUwt = TableIqMaxUwt, TableIqMaxUwt11 = TableIqMaxUwt11, TableIqMaxUwt12 = TableIqMaxUwt12, TableIqMaxUwt21 = TableIqMaxUwt21, TableIqMaxUwt22 = TableIqMaxUwt22, TableIqMaxUwt31 = TableIqMaxUwt31, TableIqMaxUwt32 = TableIqMaxUwt32, TableIqMaxUwt41 = TableIqMaxUwt41, TableIqMaxUwt42 = TableIqMaxUwt42, TableIqMaxUwt51 = TableIqMaxUwt51, TableIqMaxUwt52 = TableIqMaxUwt52, TableIqMaxUwt61 = TableIqMaxUwt61, TableIqMaxUwt62 = TableIqMaxUwt62, TableIqMaxUwt71 = TableIqMaxUwt71, TableIqMaxUwt72 = TableIqMaxUwt72, TableIqMaxUwt81 = TableIqMaxUwt81, TableIqMaxUwt82 = TableIqMaxUwt82, U0Pu = U0Pu, UPhase0 = UPhase0, UpquMaxPu = UpquMaxPu) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  BaseControls.WT.PControl3AB2020 pControl3AB2020(DPMaxPu=DPMaxPu, DPRefMax4abPu=DPRefMax4abPu, DPRefMin4abPu=DPRefMin4abPu, DTauMaxPu=DTauMaxPu, DTauUvrtMaxPu=DTauUvrtMaxPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, KDtd=KDtd, KIp=KIp, KPp=KPp, MOmegaTMax=MOmegaTMax, MOmegaTqpi=MOmegaTqpi, MPUvrt=MPUvrt, MpUScale=MpUScale, OmegaDtdPu=OmegaDtdPu, OmegaOffsetPu=OmegaOffsetPu, P0Pu = P0Pu,  PDtdMaxPu=PDtdMaxPu, PWTRef0Pu = PWTRef0Pu, SNom=SNom, TableOmegaPPu=TableOmegaPPu, TauEMinPu=TauEMinPu, TauUscalePu=TauUscalePu, U0Pu=U0Pu, UDvsPu=UDvsPu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, UpDipPu=UpDipPu, XEqv = XEqv, Zeta=Zeta, tDvs=tDvs, tOmegaRef=tOmegaRef, tOmegafiltp3=tOmegafiltp3, tPord=tPord, tS=tS) annotation(
    Placement(visible = true, transformation(origin = {0, 108}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  
  equation
  connect(const.y, currentLimiter.iqMaxHookPu) annotation(
    Line(points = {{2, 40}, {94, 40}, {94, 22}}, color = {0, 0, 127}));
  connect(const.y, currentLimiter.iMaxHookPu) annotation(
    Line(points = {{2, 40}, {106, 40}, {106, 22}}, color = {0, 0, 127}));
  connect(qControl.fFrt, currentLimiter.fFrt) annotation(
    Line(points = {{42, -76}, {52, -76}, {52, -8}, {78, -8}}, color = {255, 127, 0}));
  connect(qControl.iqCmdPu, currentLimiter.iqCmdPu) annotation(
    Line(points = {{42, -84}, {60, -84}, {60, -16}, {78, -16}}, color = {0, 0, 127}));
  connect(qControl.fFrt, qLimiter.fFrt) annotation(
    Line(points = {{42, -76}, {52, -76}, {52, -8}, {-112, -8}, {-112, -28}, {-102, -28}}, color = {255, 127, 0}));
  connect(const.y, qControl.idfHookPu) annotation(
    Line(points = {{2, 40}, {20, 40}, {20, -58}}, color = {0, 0, 127}));
  connect(const.y, qControl.ipfHookPu) annotation(
    Line(points = {{2, 40}, {30, 40}, {30, -58}}, color = {0, 0, 127}));
  connect(qLimiter.UWTCFiltPu, UWTCFiltPu) annotation(
    Line(points = {{-102, -40}, {-146, -40}, {-146, -30}, {-180, -30}}, color = {0, 0, 127}));
  connect(qLimiter.PWTCFiltPu, PWTCFiltPu) annotation(
    Line(points = {{-102, -52}, {-138, -52}, {-138, 40}, {-180, 40}}, color = {0, 0, 127}));
  connect(qLimiter.QWTMaxPu, qControl.QWTMaxPu) annotation(
    Line(points = {{-58, -32}, {-16, -32}, {-16, -70}, {-2, -70}}, color = {0, 0, 127}));
  connect(qLimiter.QWTMinPu, qControl.QWTMinPu) annotation(
    Line(points = {{-58, -48}, {-20, -48}, {-20, -78}, {-2, -78}}, color = {0, 0, 127}));
  connect(qControl.xWTRefPu, xWTRefPu) annotation(
    Line(points = {{-2, -82}, {-124, -82}, {-124, -100}, {-180, -100}}, color = {0, 0, 127}));
  connect(qControl.PWTCFiltPu, PWTCFiltPu) annotation(
    Line(points = {{-2, -88}, {-138, -88}, {-138, 40}, {-180, 40}}, color = {0, 0, 127}));
  connect(qControl.UWTCFiltPu, UWTCFiltPu) annotation(
    Line(points = {{-2, -94}, {-146, -94}, {-146, -30}, {-180, -30}}, color = {0, 0, 127}));
  connect(QWTCFiltPu, qControl.QWTCFiltPu) annotation(
    Line(points = {{-180, -130}, {-10, -130}, {-10, -66}, {-2, -66}}, color = {0, 0, 127}));
  connect(currentLimiter.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{122, 12}, {140, 12}, {140, 20}, {170, 20}}, color = {0, 0, 127}));
  connect(currentLimiter.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{122, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(currentLimiter.iqMinPu, iqMinPu) annotation(
    Line(points = {{122, -12}, {140, -12}, {140, -20}, {170, -20}}, color = {0, 0, 127}));
  connect(pControl3AB2020.UWTCFiltPu, UWTCFiltPu) annotation(
    Line(points = {{-32, 134}, {-146, 134}, {-146, -30}, {-180, -30}}, color = {0, 0, 127}));
  connect(pControl3AB2020.UWTCPu, UWTCPu) annotation(
    Line(points = {{-32, 130}, {-144, 130}, {-144, 0}, {-180, 0}}, color = {0, 0, 127}));
  connect(pControl3AB2020.ipMaxPu, currentLimiter.ipMaxPu) annotation(
    Line(points = {{-32, 124}, {-44, 124}, {-44, 66}, {128, 66}, {128, 12}, {122, 12}}, color = {0, 0, 127}));
  connect(pControl3AB2020.omegaWTRPu, omegaWTRPu) annotation(
    Line(points = {{-32, 112}, {-136, 112}, {-136, 70}, {-180, 70}}, color = {0, 0, 127}));
  connect(pControl3AB2020.PWTRefPu, PWTRefPu) annotation(
    Line(points = {{-32, 102}, {-128, 102}, {-128, 140}, {-180, 140}}, color = {0, 0, 127}));
  connect(pControl3AB2020.PWTCFiltPu, PWTCFiltPu) annotation(
    Line(points = {{-32, 92}, {-120, 92}, {-120, 40}, {-180, 40}}, color = {0, 0, 127}));
  connect(const.y, pControl3AB2020.UTCHookPu) annotation(
    Line(points = {{2, 40}, {8, 40}, {8, 72}, {-38, 72}, {-38, 82}, {-32, 82}}, color = {0, 0, 127}));
  connect(pControl3AB2020.ipCmdPu, currentLimiter.ipCmdPu) annotation(
    Line(points = {{32, 132}, {64, 132}, {64, 16}, {78, 16}}, color = {0, 0, 127}));
  connect(pControl3AB2020.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{32, 132}, {64, 132}, {64, 70}, {170, 70}}, color = {0, 0, 127}));
  connect(pControl3AB2020.POrdPu, POrdPu) annotation(
    Line(points = {{32, 108}, {48, 108}, {48, 120}, {170, 120}}, color = {0, 0, 127}));
  connect(pControl3AB2020.omegaRefPu, omegaRefPu) annotation(
    Line(points = {{32, 84}, {48, 84}, {48, 100}, {170, 100}}, color = {0, 0, 127}));
  connect(currentLimiter.UWTCFiltPu, UWTCFiltPu) annotation(
    Line(points = {{78, 8}, {-130, 8}, {-130, -30}, {-180, -30}}, color = {0, 0, 127}));
  connect(pControl3AB2020.omegaGenPu, omegaGenPu) annotation(
    Line(points = {{-32, 120}, {-66, 120}, {-66, 82}, {-154, 82}, {-154, 100}, {-180, 100}}, color = {0, 0, 127}));
  connect(currentLimiter.omegaGenPu, omegaGenPu) annotation(
    Line(points = {{78, 0}, {-66, 0}, {-66, 82}, {-154, 82}, {-154, 100}, {-180, 100}}, color = {0, 0, 127}));
  connect(qControl.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{42, -84}, {86, -84}, {86, -80}, {170, -80}}, color = {0, 0, 127}));
  connect(tanPhi, qControl.tanPhi) annotation(
    Line(points = {{-180, -60}, {-116, -60}, {-116, -64}, {-40, -64}, {-40, -54}, {10, -54}, {10, -58}}, color = {0, 0, 127}));
  
  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-4, 61}, extent = {{-76, -18}, {92, 28}}, textString = "IEC WT 3"), Text(origin = {-10, -17}, extent = {{-72, -16}, {88, 26}}, textString = "Generator Control\n2020")}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end Control3A2020;
