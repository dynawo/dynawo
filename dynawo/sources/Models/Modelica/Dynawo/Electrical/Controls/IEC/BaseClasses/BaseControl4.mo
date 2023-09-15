within Dynawo.Electrical.Controls.IEC.BaseClasses;

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

partial model BaseControl4 "Whole generator base control module for type 4 wind turbines (IEC N°61400-27-1)"

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //PControl parameters
  parameter Types.PerUnit Kpaw "Anti-windup gain for active power in pu/s (base SNom)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.VoltageModulePu UpDipPu "Voltage dip threshold for power control in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));

  //Current limiter parameters
  parameter Types.CurrentModulePu IMaxDipPu "Maximum current during voltage dip at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.CurrentModulePu IMaxPu "Maximum continuous current at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limit against voltage in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean MdfsLim "Limitation of type 3 stator current (false: total current limitation, true: stator current limitation)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean Mqpri "Prioritization of reactive power during FRT (false: active power priority, true: reactive power priority)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.VoltageModulePu UpquMaxPu "WT voltage in the operation point where zero reactive power can be delivered, in pu (base UNom)" annotation(
    Dialog(tab = "CurrentLimiter"));

  //QControl parameters
  parameter Types.VoltageModulePu DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqH1Pu "Maximum reactive current injection during dip in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqMaxPu "Maximum reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqMinPu "Minimum reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqPostPu "Post-fault reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kiq "Reactive power PI controller integration gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kiu "Voltage PI controller integration gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer Mqfrt "FRT Q control modes (0-3) (see Table 29, section 7.7.5, page 60 of the IEC norm N°61400-27-1)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer MqG "General Q control mode (0-4) : Voltage control (0), Reactive power control (1), Open loop reactive power control (2), Power factor control (3), Open loop power factor control (4)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit RDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tPost "Length of time period where post-fault reactive power is injected, in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tQord "Reactive power order lag time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUss "Steady-state voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMaxPu "Maximum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMinPu "Minimum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqDipPu "Voltage threshold for UVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqRisePu "Voltage threshold for OVRT detection in Q control in pu (base UNom) (typically equal to UpquMaxPu)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu URef0Pu "User-defined bias in voltage reference in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit XDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));

  //QLimiter parameters
  parameter Boolean QlConst "True if limits are constant" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMaxPu "Constant maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMinPu "Constant minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omega0Pu) "Generator angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PWTCFiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWTCFiltPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -89.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-180, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTCPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = XWT0Pu) "Reactive power loop reference : reactive power or voltage reference depending on the Q control mode (MqG), in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -59.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.BaseControls.WT.CurrentLimiter currentLimiter(IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, MdfsLim = MdfsLim, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, UpquMaxPu = UpquMaxPu) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.QControl qControl(DUdb1Pu = DUdb1Pu, DUdb2Pu = DUdb2Pu, IqH1Pu = IqH1Pu, IqMaxPu = IqMaxPu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MqG = MqG, Mqfrt = Mqfrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, RDropPu = RDropPu, SNom = SNom, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, URef0Pu = URef0Pu, UqDipPu = UqDipPu, UqRisePu = UqRisePu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPost = tPost, tQord = tQord, tS = tS, tUss = tUss) annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WT.QLimiter qLimiter(P0Pu = P0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, SNom = SNom, U0Pu = U0Pu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation
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
  connect(PWTCFiltPu, qControl.PWTCFiltPu) annotation(
    Line(points = {{-180, -60}, {-140, -60}, {-140, -84}, {-2, -84}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, qControl.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-120, 20}, {-120, -76}, {-2, -76}}, color = {0, 0, 127}));
  connect(xWTRefPu, qControl.xWTRefPu) annotation(
    Line(points = {{-180, -100}, {-80, -100}, {-80, -90}, {-2, -90}}, color = {0, 0, 127}));
  connect(QWTCFiltPu, qControl.QWTCFiltPu) annotation(
    Line(points = {{-180, -140}, {-60, -140}, {-60, -96}, {-2, -96}}, color = {0, 0, 127}));
  connect(PWTCFiltPu, qLimiter.PWTCFiltPu) annotation(
    Line(points = {{-180, -60}, {-140, -60}, {-140, -52}, {-102, -52}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, qLimiter.UWTCFiltPu) annotation(
    Line(points = {{-180, 20}, {-120, 20}, {-120, -40}, {-102, -40}}, color = {0, 0, 127}));
  connect(qControl.fFrt, qLimiter.fFrt) annotation(
    Line(points = {{42, -76}, {52, -76}, {52, -8}, {-112, -8}, {-112, -28}, {-102, -28}}, color = {255, 127, 0}));
  connect(tanPhi, qControl.tanPhi) annotation(
    Line(points = {{-180, -20}, {10, -20}, {10, -58}}, color = {0, 0, 127}));
  connect(qLimiter.QWTMinPu, qControl.QWTMinPu) annotation(
    Line(points = {{-58, -48}, {-40, -48}, {-40, -70}, {-2, -70}}, color = {0, 0, 127}));
  connect(qLimiter.QWTMaxPu, qControl.QWTMaxPu) annotation(
    Line(points = {{-58, -32}, {-20, -32}, {-20, -64}, {-2, -64}}, color = {0, 0, 127}));
  connect(qControl.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{42, -84}, {60, -84}, {60, -80}, {170, -80}}, color = {0, 0, 127}));
  connect(omegaGenPu, currentLimiter.omegaGenPu) annotation(
    Line(points = {{-180, 100}, {-100, 100}, {-100, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(const.y, qControl.idfHookPu) annotation(
    Line(points = {{2, 40}, {20, 40}, {20, -58}}, color = {0, 0, 127}));
  connect(const.y, qControl.ipfHookPu) annotation(
    Line(points = {{2, 40}, {30, 40}, {30, -58}}, color = {0, 0, 127}));
  connect(const.y, currentLimiter.iqMaxHookPu) annotation(
    Line(points = {{2, 40}, {94, 40}, {94, 22}}, color = {0, 0, 127}));
  connect(const.y, currentLimiter.iMaxHookPu) annotation(
    Line(points = {{2, 40}, {106, 40}, {106, 22}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-16, 31}, extent = {{-76, -18}, {92, 28}}, textString = "IEC WT 4"), Text(origin = {-11, -34}, extent = {{-77, -16}, {100, 30}}, textString = "Generator Control")}),
    Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
end BaseControl4;
