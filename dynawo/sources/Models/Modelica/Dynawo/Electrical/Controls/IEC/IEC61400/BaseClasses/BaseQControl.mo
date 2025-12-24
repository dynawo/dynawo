within Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses;

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

partial model BaseQControl "Reactive power control base module for wind turbines (IEC N°61400-27-1)"
  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //QControl parameters
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
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer MqG "General Q control mode (0-4) : Voltage control (0), Reactive power control (1), Open loop reactive power control (2), Power factor control (3), Open loop power factor control (4)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit RDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tPost "Length of time period where post-fault reactive power is injected, in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tQord "Reactive power order lag time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMaxPu "Maximum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMinPu "Minimum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqDipPu "Voltage threshold for UVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu URef0Pu "User-defined bias in voltage reference in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit XDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput QWTMaxPu(start = QMax0Pu) "Maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, 240}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 45}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWTMinPu(start = QMin0Pu) "Minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 14.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu/P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-100, 20}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {-49, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = XWT0Pu) "Reactive power loop reference : reactive power or voltage reference depending on the Q control mode (MqG), in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-320, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -14.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = iq0Pu) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {310, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFixed switch2(f = MqG, nu = 5) annotation(
    Placement(visible = true, transformation(origin = {-250, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFixed switch4(f = MqG, nu = 5) annotation(
    Placement(visible = true, transformation(origin = {270, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-210, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-180, 240}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpq) annotation(
    Placement(visible = true, transformation(origin = {-130, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-70, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = UMaxPu, uMin = UMinPu) annotation(
    Placement(visible = true, transformation(origin = {30, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {60, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {230, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpu) annotation(
    Placement(visible = true, transformation(origin = {110, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.VDrop vDrop(P0Pu = P0Pu*SystemBase.SnRef/SNom, Q0Pu = Q0Pu*SystemBase.SnRef/SNom, RDropPu = RDropPu, U0Pu = U0Pu, XDropPu = XDropPu) annotation(
    Placement(visible = true, transformation(origin = {-160, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Division division2 annotation(
    Placement(visible = true, transformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.DelayFlag delayFlag(FI0 = false, FO0 = 0, tD = tPost, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-150, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchVariable switch7(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {250, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = IqH1Pu, uMin = IqMinPu) annotation(
    Placement(visible = true, transformation(origin = {190, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = IqH1Pu, uMin = IqMinPu) annotation(
    Placement(visible = true, transformation(origin = {190, -240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {50, -260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const8(k = IqPostPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {50, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain7(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {-70, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone annotation(
    Placement(visible = true, transformation(origin = {-150, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = 0.99) annotation(
    Placement(visible = true, transformation(origin = {120, 10}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.IntegerToReal integerToReal annotation(
    Placement(visible = true, transformation(origin = {120, -30}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-280, 50}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(DyMax = 999, Y0 = U0Pu, YMax = UMaxPu, YMin = UMinPu, tI = if Kiq > 1e-5 then 1/Kiq else 1/Modelica.Constants.eps) annotation(
    Placement(visible = true, transformation(origin = {-130, 260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator1(DyMax = 999, Y0 = -iq0Pu, YMax = IqMaxPu, YMin = IqMinPu, tI = if Kiu > 1e-5 then 1/Kiu else 1/Modelica.Constants.eps) annotation(
    Placement(visible = true, transformation(origin = {150, 260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Max2 max1 annotation(
    Placement(visible = true, transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreeze absLimRateLimFirstOrderFreeze(DyMax = 999, UseLimits = true, Y0 = XWT0Pu, YMax = 999, tI = tQord) annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-70, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreeze absLimRateLimFeedthroughFreeze(DyMax = 999, U0 = -iq0Pu, Y0 = -iq0Pu, YMax = IqMaxPu, YMin = IqMinPu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {170, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = -1) annotation(
    Placement(visible = true, transformation(origin = {250, 150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain4(k = -1) annotation(
    Placement(visible = true, transformation(origin = {210, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain5(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain6(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-230, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs annotation(
    Placement(visible = true, transformation(origin = {-286, 14}, extent = {{-6, 6}, {6, -6}}, rotation = 90)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = UqDipPu) annotation(
    Placement(visible = true, transformation(origin = {-210, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFixed switch(f = MqG, nu = 5) annotation(
    Placement(visible = true, transformation(origin = {-24, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.CurrentModulePu iq0Pu "Initial reactive current component at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
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
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference communicated to WT in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(switch7.y, iqCmdPu) annotation(
    Line(points = {{262, -200}, {310, -200}}, color = {0, 0, 127}));
  connect(const8.y, add4.u2) annotation(
    Line(points = {{1, -260}, {20, -260}, {20, -266}, {38, -266}}, color = {0, 0, 127}));
  connect(switch4.y, switch7.u[1]) annotation(
    Line(points = {{282, 100}, {290, 100}, {290, -60}, {220, -60}, {220, -196}, {240, -196}}, color = {0, 0, 127}));
  connect(switch4.y, add3.u2) annotation(
    Line(points = {{282, 100}, {290, 100}, {290, -60}, {20, -60}, {20, -206}, {38, -206}}, color = {0, 0, 127}));
  connect(switch4.y, add4.u1) annotation(
    Line(points = {{282, 100}, {290, 100}, {290, -60}, {20, -60}, {20, -254}, {38, -254}}, color = {0, 0, 127}));
  connect(gain7.y, add3.u1) annotation(
    Line(points = {{-59, -180}, {30, -180}, {30, -194}, {38, -194}}, color = {0, 0, 127}));
  connect(deadZone.y, gain7.u) annotation(
    Line(points = {{-139, -180}, {-82, -180}}, color = {0, 0, 127}));
  connect(const5.y, max1.u2) annotation(
    Line(points = {{-59, -60}, {-40, -60}, {-40, -46}, {-22, -46}}, color = {0, 0, 127}));
  connect(xWTRefPu, switch2.u[1]) annotation(
    Line(points = {{-320, 80}, {-280, 80}, {-280, 82}, {-260, 82}}, color = {0, 0, 127}));
  connect(xWTRefPu, switch2.u[2]) annotation(
    Line(points = {{-320, 80}, {-260, 80}}, color = {0, 0, 127}));
  connect(xWTRefPu, switch2.u[3]) annotation(
    Line(points = {{-320, 80}, {-280, 80}, {-280, 78}, {-260, 78}}, color = {0, 0, 127}));
  connect(product.y, switch2.u[4]) annotation(
    Line(points = {{-280, 62}, {-280, 76}, {-260, 76}}, color = {0, 0, 127}));
  connect(product.y, switch2.u[5]) annotation(
    Line(points = {{-280, 62}, {-280, 74}, {-260, 74}}, color = {0, 0, 127}));
  connect(switch2.y, absLimRateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-238, 80}, {-182, 80}}, color = {0, 0, 127}));
  connect(QWTMinPu, absLimRateLimFirstOrderFreeze.yMin) annotation(
    Line(points = {{-320, 140}, {-220, 140}, {-220, 74}, {-182, 74}}, color = {0, 0, 127}));
  connect(QWTMaxPu, absLimRateLimFirstOrderFreeze.yMax) annotation(
    Line(points = {{-320, 240}, {-280, 240}, {-280, 160}, {-200, 160}, {-200, 86}, {-182, 86}}, color = {0, 0, 127}));
  connect(switch2.y, variableLimiter.u) annotation(
    Line(points = {{-238, 80}, {-230, 80}, {-230, 240}, {-222, 240}}, color = {0, 0, 127}));
  connect(QWTMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{-320, 240}, {-240, 240}, {-240, 248}, {-222, 248}}, color = {0, 0, 127}));
  connect(QWTMinPu, variableLimiter.limit2) annotation(
    Line(points = {{-320, 140}, {-240, 140}, {-240, 232}, {-222, 232}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback.u1) annotation(
    Line(points = {{-198, 240}, {-188, 240}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.y, add.u1) annotation(
    Line(points = {{-119, 260}, {-100, 260}, {-100, 246}, {-82, 246}}, color = {0, 0, 127}));
  connect(gain.y, add.u2) annotation(
    Line(points = {{-119, 220}, {-100, 220}, {-100, 234}, {-82, 234}}, color = {0, 0, 127}));
  connect(switch2.y, add2.u1) annotation(
    Line(points = {{-238, 80}, {-230, 80}, {-230, 186}, {-82, 186}}, color = {0, 0, 127}));
  connect(const1.y, add2.u2) annotation(
    Line(points = {{-119, 160}, {-100, 160}, {-100, 174}, {-82, 174}}, color = {0, 0, 127}));
  connect(limiter.y, feedback1.u1) annotation(
    Line(points = {{41, 240}, {52, 240}}, color = {0, 0, 127}));
  connect(vDrop.UDropPu, feedback1.u2) annotation(
    Line(points = {{-138, -20}, {0, -20}, {0, 220}, {60, 220}, {60, 232}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator1.y, add1.u1) annotation(
    Line(points = {{161, 260}, {200, 260}, {200, 246}, {218, 246}}, color = {0, 0, 127}));
  connect(feedback.y, antiWindupIntegrator.u) annotation(
    Line(points = {{-170, 240}, {-160, 240}, {-160, 260}, {-142, 260}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-170, 240}, {-160, 240}, {-160, 220}, {-142, 220}}, color = {0, 0, 127}));
  connect(feedback1.y, antiWindupIntegrator1.u) annotation(
    Line(points = {{70, 240}, {80, 240}, {80, 260}, {138, 260}}, color = {0, 0, 127}));
  connect(gain3.y, switch4.u[1]) annotation(
    Line(points = {{250, 238}, {250, 106}, {260, 106}}, color = {0, 0, 127}));
  connect(gain3.y, switch4.u[2]) annotation(
    Line(points = {{250, 238}, {250, 103}, {260, 103}}, color = {0, 0, 127}));
  connect(gain3.y, switch4.u[4]) annotation(
    Line(points = {{250, 238}, {250, 97}, {260, 97}}, color = {0, 0, 127}));
  connect(max1.y, division2.u2) annotation(
    Line(points = {{2, -40}, {20, -40}, {20, 94}, {38, 94}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze.y, division2.u1) annotation(
    Line(points = {{-158, 80}, {-20, 80}, {-20, 106}, {38, 106}}, color = {0, 0, 127}));
  connect(integerToReal.y, greaterEqualThreshold.u) annotation(
    Line(points = {{120, -19}, {120, -2}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, absLimRateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{120, 22}, {120, 60}, {-110, 60}, {-110, 100}, {-170, 100}, {-170, 92}}, color = {255, 0, 255}));
  connect(greaterEqualThreshold.y, antiWindupIntegrator.fMax) annotation(
    Line(points = {{120, 22}, {120, 60}, {-110, 60}, {-110, 240}, {-122, 240}, {-122, 248}}, color = {255, 0, 255}));
  connect(greaterEqualThreshold.y, antiWindupIntegrator1.fMax) annotation(
    Line(points = {{120, 22}, {120, 130}, {150, 130}, {150, 180}, {166, 180}, {166, 240}, {158, 240}, {158, 248}}, color = {255, 0, 255}));
  connect(limiter2.y, switch7.u[2]) annotation(
    Line(points = {{202, -200}, {240, -200}}, color = {0, 0, 127}));
  connect(limiter3.y, switch7.u[3]) annotation(
    Line(points = {{202, -240}, {220, -240}, {220, -204}, {240, -204}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{70, 240}, {80, 240}, {80, 200}, {98, 200}}, color = {0, 0, 127}));
  connect(tanPhi, product.u1) annotation(
    Line(points = {{-100, 20}, {-274, 20}, {-274, 38}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, absLimRateLimFeedthroughFreeze.freeze) annotation(
    Line(points = {{120, 22}, {120, 130}, {170, 130}, {170, 111}}, color = {255, 0, 255}));
  connect(division2.y, absLimRateLimFeedthroughFreeze.u) annotation(
    Line(points = {{62, 100}, {159, 100}}, color = {0, 0, 127}));
  connect(gain4.y, switch4.u[3]) annotation(
    Line(points = {{222, 100}, {260, 100}}, color = {0, 0, 127}));
  connect(gain4.y, switch4.u[5]) annotation(
    Line(points = {{222, 100}, {240, 100}, {240, 94}, {260, 94}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreeze.y, gain4.u) annotation(
    Line(points = {{182, 100}, {198, 100}}, color = {0, 0, 127}));
  connect(add1.y, gain3.u) annotation(
    Line(points = {{242, 240}, {250, 240}, {250, 162}}, color = {0, 0, 127}));
  connect(gain5.y, vDrop.PPu) annotation(
    Line(points = {{-238, 0}, {-200, 0}, {-200, -8}, {-182, -8}}, color = {0, 0, 127}));
  connect(gain6.y, vDrop.QPu) annotation(
    Line(points = {{-218, -20}, {-182, -20}}, color = {0, 0, 127}));
  connect(abs.y, product.u2) annotation(
    Line(points = {{-286, 20}, {-286, 38}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, antiWindupIntegrator1.fMin) annotation(
    Line(points = {{120, 22}, {120, 130}, {150, 130}, {150, 180}, {166, 180}, {166, 240}, {154, 240}, {154, 248}}, color = {255, 0, 255}));
  connect(greaterEqualThreshold.y, antiWindupIntegrator.fMin) annotation(
    Line(points = {{120, 22}, {120, 60}, {-110, 60}, {-110, 240}, {-126, 240}, {-126, 248}}, color = {255, 0, 255}));
  connect(lessThreshold.y, delayFlag.fI) annotation(
    Line(points = {{-199, -100}, {-162, -100}}, color = {255, 0, 255}));
  connect(switch.y, limiter.u) annotation(
    Line(points = {{-12, 240}, {18, 240}}, color = {0, 0, 127}));
  connect(add2.y, switch.u[1]) annotation(
    Line(points = {{-58, 180}, {-40, 180}, {-40, 240}, {-34, 240}}, color = {0, 0, 127}));
  connect(add.y, switch.u[2]) annotation(
    Line(points = {{-58, 240}, {-34, 240}}, color = {0, 0, 127}));
  connect(const.y, switch.u[3]) annotation(
    Line(points = {{-58, 280}, {-40, 280}, {-40, 240}, {-34, 240}}, color = {0, 0, 127}));
  connect(add.y, switch.u[4]) annotation(
    Line(points = {{-58, 240}, {-34, 240}}, color = {0, 0, 127}));
  connect(const.y, switch.u[5]) annotation(
    Line(points = {{-58, 280}, {-40, 280}, {-40, 240}, {-34, 240}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -300}, {300, 300}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-7, 35}, extent = {{-88, -25}, {100, 30}}, textString = "IEC WT"), Text(origin = {-6, -11}, extent = {{-85, -24}, {100, 30}}, textString = "QControl")}));
end BaseQControl;
