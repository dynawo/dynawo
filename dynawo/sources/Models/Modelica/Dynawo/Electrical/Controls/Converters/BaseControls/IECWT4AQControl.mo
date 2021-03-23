within Dynawo.Electrical.Controls.Converters.BaseControls;

model IECWT4AQControl "IEC Wind Turbine type 4A Reactive power Control"
  /*
      * Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
      * See AUTHORS.txt
      * All rights reserved.
      * This Source Code Form is subject to the terms of the Mozilla Public
      * License, v. 2.0. If a copy of the MPL was not distributed with this
      * file, you can obtain one at http://mozilla.org/MPL/2.0/.
      * SPDX-License-Identifier: MPL-2.0
      *
      * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
      */
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  /*Control parameters*/
  parameter Types.Time Ts "Integration time step";
  parameter Types.PerUnit RWTDrop "Resistive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit XWTDrop "Reactive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UMax "Maximum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UMin "Minimum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UqRise "Voltage threshold for OVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UqDip "Voltage threshold for UVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UdbOne "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UdbTwo "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IqMax "Maximum reactive current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IqMin "Minimum reactive current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IqH1 "Maximum reactive current injection during voltage dip in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IqPost "Post fault reactive current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IdfHook "User defined fault current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IpfHook "User defined post fault current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.Time Td "Delay flag time constant, specifies the duration F0 will keep the value 2" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.Time Tuss "Time constant of steady state volatage filter" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.Time TqOrd "Time constant in reactive power order lag" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiu "Voltage PI controller integration gain in p.u/s (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpq "Active power PI controller proportional gain  in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiq "Reactive power PI controller integration gain in p.u/s (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
/*  parameter Types.PerUnit TanPhi "Constant Tangent Phi" annotation(
    Dialog(group = "group", tab = "Qcontrol"));*/
  parameter Integer Mqfrt "FRT Q control modes (0-3): Normal operation controller (0), Fault current injection (1)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer MqG "General Q control mode (0-4): Voltage control (0), Reactive power control (1), Power factor control (3)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
  parameter Types.PerUnit QMax0Pu "Start value maximum reactive power in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Start value minimum reactive power in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = XWT0Pu) "Reactive power loop reference: reactive power or voltage reference depending on the Q control mode (MqG)" annotation(
    Placement(visible = true, transformation(origin = {-310, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -17.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWTCfiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-310, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWTCfiltPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-310, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 17.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWTMaxPu(start = QMax0Pu) "Maximum WTT reactive power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-310, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWTMinPu(start = QMin0Pu) "Minimum WTT reactive power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-310, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = U0Pu) "Filtered voltage amplitude at wind turbine terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput iqBaseHook(start = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current commmand in normal operation in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, 145}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput Ffrt(start = 0) "Function of FRT state (0-2): Normal operation (0), Fault (1), Post fault (2)" annotation(
    Placement(visible = true, transformation(origin = {310, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqvHook(start = 0) "Output of the fault current injection function in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, -125}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command to generator system in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {310, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Sources.IntegerConstant integerConstantMqG(k = MqG) annotation(
    Placement(visible = true, transformation(origin = {-283, 283}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //switchInputs
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFive switchXref annotation(
    Placement(visible = true, transformation(origin = {-246, 194}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFive switchIqBaseHook annotation(
    Placement(visible = true, transformation(origin = {260, 145}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFive switch1 annotation(
    Placement(visible = true, transformation(origin = {-23, 195}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  //PIq
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1(limitsAtInit = true) annotation(
    Placement(visible = true, transformation(origin = {-204, 194}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-175, 194}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchIntqFreeze annotation(
    Placement(visible = true, transformation(origin = {-142, 215}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpq) annotation(
    Placement(visible = true, transformation(origin = {-130, 175}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-77, 188}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {-110, 251}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-144, 261}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //PIu
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = UMax, uMin = UMin) annotation(
    Placement(visible = true, transformation(origin = {15, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbacku annotation(
    Placement(visible = true, transformation(origin = {45, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKpufrt(k = Kpufrt) annotation(
    Placement(visible = true, transformation(origin = {100, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchIntuFreeze annotation(
    Placement(visible = true, transformation(origin = {130, 225}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constantZerou(k = 0) annotation(
    Placement(visible = true, transformation(origin = {80, 234}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchKpu annotation(
    Placement(visible = true, transformation(origin = {165, 175}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPIu annotation(
    Placement(visible = true, transformation(origin = {210, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpu) annotation(
    Placement(visible = true, transformation(origin = {77, 135}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(limitsAtInit = true) annotation(
    Placement(visible = true, transformation(origin = {123, 135}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {75, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {77, 165}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECQcontrolVDrop iECQcontrolVDrop1(P0Pu = P0Pu, Q0Pu = Q0Pu, RDrop = RWTDrop, SNom = SNom, U0Pu = U0Pu, XDrop = XWTDrop) annotation(
    Placement(visible = true, transformation(origin = {-84, 143}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter4(limitsAtInit = true, uMax = 999, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // MqG=2
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter2 annotation(
    Placement(visible = true, transformation(origin = {80, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division3 annotation(
    Placement(visible = true, transformation(origin = {120, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(limitsAtInit = true, uMax = IqMax, uMin = IqMin) annotation(
    Placement(visible = true, transformation(origin = {171, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //tan phi
  //FRT
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInt switchFfrt annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.DelayFlag delayFlag(Td = Td, Ts = Ts) annotation(
    Placement(visible = true, transformation(origin = {-50, -44}, extent = {{-20, -15}, {20, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constUqDip(k = UqDip) annotation(
    Placement(visible = true, transformation(origin = {-160, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {-110, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {-110, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constUqRise(k = UqRise) annotation(
    Placement(visible = true, transformation(origin = {-160, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger annotation(
    Placement(visible = true, transformation(origin = {2, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Iqcmd
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchThree switchIqCmdPu annotation(
    Placement(visible = true, transformation(origin = {250, -200}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterFfrt1(limitsAtInit = true, uMax = IqH1, uMin = IqMin) annotation(
    Placement(visible = true, transformation(origin = {190, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterFfrt2(limitsAtInit = true, uMax = IqH1, uMin = IqMin) annotation(
    Placement(visible = true, transformation(origin = {209, -245}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFour switchFfrt1 annotation(
    Placement(visible = true, transformation(origin = {120, -200}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFour switchFfrt2 annotation(
    Placement(visible = true, transformation(origin = {165, -245}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = Mqfrt) annotation(
    Placement(visible = true, transformation(origin = {100, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addIqPost annotation(
    Placement(visible = true, transformation(origin = {110, -249}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constIqPost(k = IqPost) annotation(
    Placement(visible = true, transformation(origin = {61, -265}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constIpfHook(k = IpfHook) annotation(
    Placement(visible = true, transformation(origin = {0, -285}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constIdfHook(k = IdfHook) annotation(
    Placement(visible = true, transformation(origin = {75, -227}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addIqv annotation(
    Placement(visible = true, transformation(origin = {75, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKqv(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {-9, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(deadZoneAtInit = true, uMax = UdbTwo, uMin = UdbOne) annotation(
    Placement(visible = true, transformation(origin = {-65, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Freeze
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(visible = true, transformation(origin = {125, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.IntegerToReal integerToReal annotation(
    Placement(visible = true, transformation(origin = {90, -3}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-182, 224}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1, y_start = XWT0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-77, 83}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-41, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = 1 / TqOrd) annotation(
    Placement(visible = true, transformation(origin = {-101, 67}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-137, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-116, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tuss, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-187, -186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-285, 180}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorFixLimits integratorFixLimits(GainAW = 1000, k = Kiq, uMax = UMax, uMin = UMin, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 215}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorFixLimits integratorFixLimits1(GainAW = 1000, k = Kiu, uMax = IqMax, uMin = IqMin, y_start = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {170, 225}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
/*Connectors*/
  connect(switchXref.y, variableLimiter1.u) annotation(
    Line(points = {{-228, 194}, {-216, 194}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, feedback.u1) annotation(
    Line(points = {{-193, 194}, {-183, 194}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-166, 194}, {-160, 194}, {-160, 175}, {-142, 175}}, color = {0, 0, 127}));
  connect(gain.y, add.u2) annotation(
    Line(points = {{-119, 175}, {-106, 175}, {-106, 182}, {-89, 182}}, color = {0, 0, 127}));
  connect(add.y, switch1.u1) annotation(
    Line(points = {{-66, 188}, {-62, 188}, {-62, 201}, {-41, 201}}, color = {0, 0, 127}));
  connect(add.y, switch1.u3) annotation(
    Line(points = {{-66, 188}, {-41, 188}}, color = {0, 0, 127}));
  connect(switchXref.y, add3.u2) annotation(
    Line(points = {{-228, 194}, {-224, 194}, {-224, 245}, {-122, 245}}, color = {0, 0, 127}));
  connect(const.y, add3.u1) annotation(
    Line(points = {{-133, 261}, {-128, 261}, {-128, 257}, {-122, 257}}, color = {0, 0, 127}));
  connect(add3.y, switch1.u0) annotation(
    Line(points = {{-99, 251}, {-51, 251}, {-51, 208}, {-41, 208}}, color = {0, 0, 127}));
  connect(switch1.y, limiter.u) annotation(
    Line(points = {{-5, 195}, {3, 195}}, color = {0, 0, 127}));
  connect(limiter.y, feedbacku.u1) annotation(
    Line(points = {{26, 195}, {37, 195}}, color = {0, 0, 127}));
  connect(switchIqBaseHook.y, iqBaseHook) annotation(
    Line(points = {{278, 145}, {310, 145}}, color = {0, 0, 127}));
  connect(addPIu.y, switchIqBaseHook.u0) annotation(
    Line(points = {{221, 195}, {233, 195}, {233, 158}, {242, 158}}, color = {0, 0, 127}));
  connect(addPIu.y, switchIqBaseHook.u1) annotation(
    Line(points = {{221, 195}, {233, 195}, {233, 151}, {242, 151}}, color = {0, 0, 127}));
  connect(addPIu.y, switchIqBaseHook.u3) annotation(
    Line(points = {{221, 195}, {233, 195}, {233, 138}, {242, 138}}, color = {0, 0, 127}));
  connect(feedbacku.y, gainKpufrt.u) annotation(
    Line(points = {{54, 195}, {88, 195}}, color = {0, 0, 127}));
  connect(gainKpufrt.y, switchKpu.u1) annotation(
    Line(points = {{111, 195}, {133, 195}, {133, 183}, {153, 183}}, color = {0, 0, 127}));
  connect(switchKpu.y, addPIu.u2) annotation(
    Line(points = {{176, 175}, {185, 175}, {185, 189}, {198, 189}}, color = {0, 0, 127}));
  connect(variableLimiter.y, switchKpu.u3) annotation(
    Line(points = {{134, 135}, {144, 135}, {144, 167}, {153, 167}}, color = {0, 0, 127}));
  connect(gain1.y, variableLimiter.u) annotation(
    Line(points = {{88, 135}, {111, 135}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter.limit1) annotation(
    Line(points = {{88, 165}, {98, 165}, {98, 143}, {111, 143}}, color = {0, 0, 127}));
  connect(division.y, variableLimiter.limit2) annotation(
    Line(points = {{86, 100}, {95, 100}, {95, 127}, {111, 127}}, color = {0, 0, 127}));
  connect(feedbacku.y, gain1.u) annotation(
    Line(points = {{54, 195}, {57, 195}, {57, 135}, {65, 135}}, color = {0, 0, 127}));
  connect(iECQcontrolVDrop1.uWTCfiltDropPu, feedbacku.u2) annotation(
    Line(points = {{-62, 143}, {45, 143}, {45, 187}}, color = {0, 0, 127}));
  connect(limiter4.y, division1.u2) annotation(
    Line(points = {{11, 30}, {52, 30}, {52, 159}, {65, 159}}, color = {0, 0, 127}));
  connect(limiter4.y, division.u2) annotation(
    Line(points = {{11, 30}, {52, 30}, {52, 94}, {63, 94}}, color = {0, 0, 127}));
  connect(limiter4.y, division3.u2) annotation(
    Line(points = {{11, 30}, {96, 30}, {96, 54}, {108, 54}}, color = {0, 0, 127}));
  connect(limiter2.y, switchIqBaseHook.u2) annotation(
    Line(points = {{182, 60}, {203, 60}, {203, 145}, {242, 145}}, color = {0, 0, 127}));
  connect(division3.y, limiter2.u) annotation(
    Line(points = {{131, 60}, {159, 60}}, color = {0, 0, 127}));
  connect(integerConstantMqG.y, switchIqBaseHook.M) annotation(
    Line(points = {{-272, 283}, {260, 283}, {260, 163}}, color = {255, 127, 0}));
  connect(switchFfrt.y, Ffrt) annotation(
    Line(points = {{61, -50}, {310, -50}}, color = {255, 127, 0}));
  connect(delayFlag.y, switchFfrt.u0) annotation(
    Line(points = {{-28, -44}, {39, -44}}, color = {255, 127, 0}));
  connect(less.y, delayFlag.u) annotation(
    Line(points = {{-99, -44}, {-72, -44}}, color = {255, 0, 255}));
  connect(constUqDip.y, less.u2) annotation(
    Line(points = {{-149, -52}, {-122, -52}}, color = {0, 0, 127}));
  connect(constUqRise.y, greater.u2) annotation(
    Line(points = {{-149, -96}, {-123, -96}, {-123, -96}, {-122, -96}}, color = {0, 0, 127}));
  connect(greater.y, switchFfrt.M) annotation(
    Line(points = {{-99, -88}, {-22, -88}, {-22, -51}, {39, -51}, {39, -50}}, color = {255, 0, 255}));
  connect(greater.y, booleanToInteger.u) annotation(
    Line(points = {{-99, -88}, {-22, -88}, {-22, -74}, {-10, -74}, {-10, -75}}, color = {255, 0, 255}));
  connect(booleanToInteger.y, switchFfrt.u1) annotation(
    Line(points = {{13, -75}, {25, -75}, {25, -56}, {39, -56}}, color = {255, 127, 0}));
  connect(uWTCfiltPu, less.u1) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, -34}, {-134, -34}, {-134, -44}, {-122, -44}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, greater.u1) annotation(
    Line(points = {{-310, -75}, {-132, -75}, {-132, -89}, {-122, -89}, {-122, -88}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, iECQcontrolVDrop1.uWTCfiltPu) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, 30}, {-156, 30}, {-156, 136}, {-106, 136}}, color = {0, 0, 127}));
  connect(switchIqCmdPu.y, iqCmdPu) annotation(
    Line(points = {{263, -200}, {304, -200}, {304, -200}, {310, -200}}, color = {0, 0, 127}));
  connect(limiterFfrt2.y, switchIqCmdPu.u2) annotation(
    Line(points = {{220, -245}, {228, -245}, {228, -208}, {235, -208}, {235, -207}, {237, -207}}, color = {0, 0, 127}));
  connect(switchFfrt2.y, limiterFfrt2.u) annotation(
    Line(points = {{180, -245}, {197, -245}}, color = {0, 0, 127}));
  connect(integerConstant.y, switchFfrt1.M) annotation(
    Line(points = {{111, -150}, {120, -150}, {120, -185}}, color = {255, 127, 0}));
  connect(integerConstant.y, switchFfrt2.M) annotation(
    Line(points = {{111, -150}, {165, -150}, {165, -230}}, color = {255, 127, 0}));
  connect(switchFfrt1.y, switchFfrt2.u0) annotation(
    Line(points = {{135, -200}, {140, -200}, {140, -234}, {150, -234}}, color = {0, 0, 127}));
  connect(constIqPost.y, addIqPost.u2) annotation(
    Line(points = {{72, -265}, {84.5, -265}, {84.5, -255}, {98, -255}}, color = {0, 0, 127}));
  connect(switchIqBaseHook.y, addIqPost.u1) annotation(
    Line(points = {{278, 145}, {279, 145}, {279, -87}, {50, -87}, {50, -243}, {98, -243}}, color = {0, 0, 127}));
  connect(addIqPost.y, switchFfrt2.u2) annotation(
    Line(points = {{121, -249}, {150, -249}}, color = {0, 0, 127}));
  connect(constIpfHook.y, switchFfrt2.u3) annotation(
    Line(points = {{11, -285}, {130, -285}, {130, -256}, {150, -256}}, color = {0, 0, 127}));
  connect(switchFfrt1.y, switchFfrt2.u1) annotation(
    Line(points = {{135, -200}, {140, -200}, {140, -241}, {150, -241}}, color = {0, 0, 127}));
  connect(constIdfHook.y, switchFfrt1.u3) annotation(
    Line(points = {{86, -227}, {94, -227}, {94, -212}, {105, -212}, {105, -211}}, color = {0, 0, 127}));
  connect(addIqv.y, switchFfrt1.u2) annotation(
    Line(points = {{86, -200}, {98, -200}, {98, -204}, {105, -204}}, color = {0, 0, 127}));
  connect(addIqv.y, switchFfrt1.u1) annotation(
    Line(points = {{86, -200}, {98, -200}, {98, -197}, {105, -197}, {105, -196}}, color = {0, 0, 127}));
  connect(switchIqBaseHook.y, addIqv.u2) annotation(
    Line(points = {{278, 145}, {279, 145}, {279, -87}, {50, -87}, {50, -207}, {63, -207}, {63, -206}}, color = {0, 0, 127}));
  connect(gainKqv.y, addIqv.u1) annotation(
    Line(points = {{2, -180}, {33, -180}, {33, -194}, {63, -194}}, color = {0, 0, 127}));
  connect(gainKqv.y, switchFfrt1.u0) annotation(
    Line(points = {{2, -180}, {92, -180}, {92, -189}, {105, -189}}, color = {0, 0, 127}));
  connect(deadZone.y, gainKqv.u) annotation(
    Line(points = {{-54, -180}, {-21, -180}}, color = {0, 0, 127}));
  connect(limiter2.y, switchIqBaseHook.u4) annotation(
    Line(points = {{182, 60}, {203, 60}, {203, 131}, {242, 131}, {242, 132}}, color = {0, 0, 127}));
  connect(switchIqBaseHook.y, switchIqCmdPu.u0) annotation(
    Line(points = {{278, 145}, {279, 145}, {279, -87}, {227, -87}, {227, -193}, {237, -193}}, color = {0, 0, 127}));
  connect(switchFfrt.y, switchIqCmdPu.M) annotation(
    Line(points = {{61, -50}, {251, -50}, {251, -187}, {250, -187}}, color = {255, 127, 0}));
  connect(gainKqv.y, iqvHook) annotation(
    Line(points = {{2, -180}, {62, -180}, {62, -127}, {310, -127}, {310, -125}}, color = {0, 0, 127}));
  connect(iECQcontrolVDrop1.uWTCfiltDropPu, switch1.u2) annotation(
    Line(points = {{-62, 143}, {-48, 143}, {-48, 195}, {-41, 195}}, color = {0, 0, 127}));
  connect(iECQcontrolVDrop1.uWTCfiltDropPu, switch1.u4) annotation(
    Line(points = {{-62, 143}, {-48, 143}, {-48, 182}, {-41, 182}}, color = {0, 0, 127}));
  connect(switchFfrt.y, integerToReal.u) annotation(
    Line(points = {{61, -50}, {68, -50}, {68, -3}, {78, -3}}, color = {255, 127, 0}));
  connect(integerToReal.y, greater1.u1) annotation(
    Line(points = {{101, -3}, {105, -3}, {105, -15}, {113, -15}}, color = {0, 0, 127}));
  connect(constOne.y, greater1.u2) annotation(
    Line(points = {{101, -30}, {103, -30}, {103, -23}, {113, -23}, {113, -23}}, color = {0, 0, 127}));
  connect(greater1.y, switchKpu.u2) annotation(
    Line(points = {{136, -15}, {140, -15}, {140, 175}, {153, 175}, {153, 175}}, color = {255, 0, 255}));
  connect(xWTRefPu, switchXref.u2) annotation(
    Line(points = {{-310, 200}, {-294, 200}, {-294, 194}, {-264, 194}}, color = {0, 0, 127}));
  connect(xWTRefPu, switchXref.u1) annotation(
    Line(points = {{-310, 200}, {-264, 200}}, color = {0, 0, 127}));
  connect(xWTRefPu, switchXref.u0) annotation(
    Line(points = {{-310, 200}, {-294, 200}, {-294, 207}, {-264, 207}}, color = {0, 0, 127}));
  connect(variableLimiter2.y, division3.u1) annotation(
    Line(points = {{91, 66}, {108, 66}}, color = {0, 0, 127}));
  connect(switch1.M, integerConstantMqG.y) annotation(
    Line(points = {{-23, 213}, {-23, 283}, {-272, 283}}, color = {255, 127, 0}));
  connect(switchXref.M, integerConstantMqG.y) annotation(
    Line(points = {{-246, 212}, {-246, 283}, {-272, 283}}, color = {255, 127, 0}));
  connect(greater1.y, switchIntuFreeze.u2) annotation(
    Line(points = {{136, -15}, {140, -15}, {140, 212}, {107, 212}, {107, 224}, {118, 224}, {118, 225}}, color = {255, 0, 255}));
  connect(feedbacku.y, switchIntuFreeze.u3) annotation(
    Line(points = {{54, 195}, {70, 195}, {70, 217}, {118, 217}}, color = {0, 0, 127}));
  connect(constantZerou.y, switchIntuFreeze.u1) annotation(
    Line(points = {{91, 234}, {117, 234}, {117, 233}, {118, 233}}, color = {0, 0, 127}));
  connect(feedback.y, switchIntqFreeze.u3) annotation(
    Line(points = {{-166, 194}, {-160, 194}, {-160, 207}, {-154, 207}}, color = {0, 0, 127}));
  connect(greater1.y, switchIntqFreeze.u2) annotation(
    Line(points = {{136, -15}, {140, -15}, {140, 13}, {-165, 13}, {-165, 214}, {-154, 214}, {-154, 215}}, color = {255, 0, 255}));
  connect(constant1.y, switchIntqFreeze.u1) annotation(
    Line(points = {{-171, 224}, {-154, 224}, {-154, 223}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, limiter4.u) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, 30}, {-12, 30}}, color = {0, 0, 127}));
  connect(pWTCfiltPu, iECQcontrolVDrop1.pWTCfiltPu) annotation(
    Line(points = {{-310, 150}, {-106, 150}}, color = {0, 0, 127}));
  connect(qWTCfiltPu, feedback.u2) annotation(
    Line(points = {{-310, 110}, {-175, 110}, {-175, 186}, {-175, 186}}, color = {0, 0, 127}));
  connect(qWTCfiltPu, iECQcontrolVDrop1.qWTCfiltPu) annotation(
    Line(points = {{-310, 110}, {-175, 110}, {-175, 143}, {-106, 143}}, color = {0, 0, 127}));
  connect(qWTMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{-310, 50}, {-220, 50}, {-220, 185}, {-216, 185}, {-216, 186}}, color = {0, 0, 127}));
  connect(qWTMinPu, division.u1) annotation(
    Line(points = {{-310, 50}, {-220, 50}, {-220, 106}, {63, 106}}, color = {0, 0, 127}));
  connect(qWTMinPu, variableLimiter2.limit2) annotation(
    Line(points = {{-310, 50}, {41, 50}, {41, 58}, {68, 58}}, color = {0, 0, 127}));
  connect(greater1.y, switch.u2) annotation(
    Line(points = {{136, -15}, {140, -15}, {140, 13}, {-60, 13}, {-60, 75}, {-53, 75}}, color = {255, 0, 255}));
  connect(switch.y, integrator.u) annotation(
    Line(points = {{-30, 75}, {-12, 75}}, color = {0, 0, 127}));
  connect(integrator.y, variableLimiter2.u) annotation(
    Line(points = {{11, 75}, {36.5, 75}, {36.5, 66}, {68, 66}}, color = {0, 0, 127}));
  connect(constant2.y, switch.u1) annotation(
    Line(points = {{-66, 83}, {-53, 83}}, color = {0, 0, 127}));
  connect(qWTMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{-310, 80}, {-222, 80}, {-222, 203}, {-216, 203}, {-216, 202}}, color = {0, 0, 127}));
  connect(qWTMaxPu, division1.u1) annotation(
    Line(points = {{-310, 80}, {-222, 80}, {-222, 99}, {49, 99}, {49, 171}, {65, 171}}, color = {0, 0, 127}));
  connect(qWTMaxPu, variableLimiter2.limit1) annotation(
    Line(points = {{-310, 80}, {-222, 80}, {-222, 99}, {49, 99}, {49, 74}, {68, 74}}, color = {0, 0, 127}));
  connect(integrator.y, feedback1.u2) annotation(
    Line(points = {{11, 75}, {26, 75}, {26, 52}, {-137, 52}, {-137, 60}}, color = {0, 0, 127}));
  connect(feedback1.y, gain2.u) annotation(
    Line(points = {{-128, 68}, {-114, 68}, {-114, 67}, {-113, 67}}, color = {0, 0, 127}));
  connect(gain2.y, switch.u3) annotation(
    Line(points = {{-90, 67}, {-54, 67}, {-54, 67}, {-53, 67}}, color = {0, 0, 127}));
  connect(switchXref.y, feedback1.u1) annotation(
    Line(points = {{-228, 194}, {-224, 194}, {-224, 68}, {-145, 68}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, add1.u1) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, -150}, {-150, -150}, {-150, -174}, {-128, -174}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u2) annotation(
    Line(points = {{-176, -186}, {-128, -186}}, color = {0, 0, 127}));
  connect(add1.y, deadZone.u) annotation(
    Line(points = {{-105, -180}, {-77, -180}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, firstOrder.u) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, -186}, {-199, -186}}, color = {0, 0, 127}));
  connect(switchFfrt1.y, limiterFfrt1.u) annotation(
    Line(points = {{135, -200}, {179, -200}, {179, -200}, {178, -200}}, color = {0, 0, 127}));
  connect(limiterFfrt1.y, switchIqCmdPu.u1) annotation(
    Line(points = {{201, -200}, {235, -200}, {235, -200}, {237, -200}}, color = {0, 0, 127}));
  connect(xWTRefPu, product.u1) annotation(
    Line(points = {{-310, 200}, {-294, 200}, {-294, 183}, {-291, 183}}, color = {0, 0, 127}));
  connect(pWTCfiltPu, product.u2) annotation(
    Line(points = {{-310, 150}, {-300, 150}, {-300, 177}, {-291, 177}}, color = {0, 0, 127}));
  connect(product.y, switchXref.u4) annotation(
    Line(points = {{-279.5, 180}, {-264, 180}, {-264, 181}}, color = {0, 0, 127}));
  connect(switchIntqFreeze.y, integratorFixLimits.u) annotation(
    Line(points = {{-131, 215}, {-121, 215}, {-121, 215}, {-121, 215}}, color = {0, 0, 127}));
  connect(integratorFixLimits.y, add.u1) annotation(
    Line(points = {{-99, 215}, {-90, 215}, {-90, 194}, {-89, 194}}, color = {0, 0, 127}));
  connect(switchIntuFreeze.y, integratorFixLimits1.u) annotation(
    Line(points = {{141, 225}, {158, 225}, {158, 225}, {159, 225}}, color = {0, 0, 127}));
  connect(integratorFixLimits1.y, addPIu.u1) annotation(
    Line(points = {{181, 225}, {196, 225}, {196, 201}, {198, 201}}, color = {0, 0, 127}));
  connect(product.y, switchXref.u3) annotation(
    Line(points = {{-279, 180}, {-270, 180}, {-270, 188}, {-264, 188}, {-264, 187}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-300, -300}, {300, 300}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 99}}), Text(origin = {-7, 35}, extent = {{-88, -25}, {100, 30}}, textString = "IEC WT 4A"), Text(origin = {-6, -41}, extent = {{-85, -24}, {100, 30}}, textString = "QControl")}));
end IECWT4AQControl;
