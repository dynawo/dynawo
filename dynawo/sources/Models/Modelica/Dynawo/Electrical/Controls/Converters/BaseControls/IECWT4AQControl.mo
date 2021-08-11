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
  parameter Types.PerUnit Rdrop "Resistive component of voltage drop impedance" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Xdrop "Inductive component of voltage drop impedance" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uMax "Maximum voltage in voltage PI controller integral term" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uMin "Minimum voltage in voltage PI controller integral term" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uqRise "Voltage threshold for OVRT detection in Q control" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uqDip "Voltage threshold for UVRT detection in Q control" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit udbOne "Voltage change dead band lower limit (typically negative)" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit udbTwo "Voltage change dead band upper limit (typically positive)" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqMax "Maximum reactive current inyection" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqMin "Minimum reactive current inyection" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqh1 "Maximum reactive current inyection during dip" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqPost "Post fault reactive current injection" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit idfHook annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit ipfHook annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Ts "Delay flag time constant, specifies how much time F0 will keep the value 2" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Td "Delay flag exponential time constant" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Tuss "Time constant of steady volatage filter" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Tqord "Time constant in reactive injection" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiu "voltaqge PI conqtroller integration gain" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpq "Active power PI controller proportional gain" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiq "Reactive power PI controller proportional gain" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit TanPhi "Constant Tangent Phi" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer Mqfrt "Reactive current inyection for each FRT Q contorl modes (0-3)" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer MqG "General Q control mode" annotation(Dialog(group = "group", tab = "Qcontrol"));
  /*Parameters for initialization from load flow*/
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
  parameter Types.PerUnit QMax0Pu "Start value maximum reactive power (Sbase)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Start value minimum reactive power (Sbase)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  final parameter Types.PerUnit uWTC0Pu = sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im) "Initial value of the WT terminal voltage in p.u (Ubase)";
  final parameter Types.PerUnit qWTRef0Pu = -Q0Pu * SystemBase.SnRef / SNom "Initial value of the reactive power control reference in p.u (SNom)";
  final parameter Types.PerUnit iqCmd0Pu = qWTRef0Pu / uWTC0Pu "Initial value of the q-axis reference current at the generator system module terminals (converter) in p.u (Ubase,SNom) (generator convention)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = qWTRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -17.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWTCfiltPu(start = qWTRef0Pu) "Filtered WTT reactive power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {-310, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 17.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWTCfiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered WTT active power reference (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {-310, 15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = uWTC0Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWTMaxPu(start = QMax0Pu) "Maximum WTT reactive power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {-310, 255}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWTMinPu(start = QMin0Pu) "Minimum WTT reactive power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {-310, 135}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -82.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput iqBaseHook(start = iqCmd0Pu) annotation(
    Placement(visible = true, transformation(origin = {310, 145}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput Ffrt annotation(
    Placement(visible = true, transformation(origin = {310, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqvHook(start = 0) annotation(
    Placement(visible = true, transformation(origin = {310, -125}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = iqCmd0Pu) "Reactive current command to generator system (Ibase)" annotation(
    Placement(visible = true, transformation(origin = {310, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Blocks*/
  Modelica.Blocks.Sources.IntegerConstant integerConstant1(k = MqG) annotation(
    Placement(visible = true, transformation(origin = {0, 290}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  //switch5
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFive switchXref annotation(
    Placement(visible = true, transformation(origin = {-260, 195}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFive switchIqbase annotation(
    Placement(visible = true, transformation(origin = {260, 145}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFive switch1 annotation(
    Placement(visible = true, transformation(origin = {-50, 195}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  //PIq
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {-210, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-175, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator1(k = Kiq, outMax = uMax, outMin = uMin, y_start = uWTC0Pu) annotation(
    Placement(visible = true, transformation(origin = {-140, 215}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpq) annotation(
    Placement(visible = true, transformation(origin = {-140, 175}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-105, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {-105, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = uWTC0Pu) annotation(
    Placement(visible = true, transformation(origin = {-140, 253}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //PIu
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = uMax, uMin = uMin) annotation(
    Placement(visible = true, transformation(origin = {-10, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {25, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kpufrt) annotation(
    Placement(visible = true, transformation(origin = {100, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Kiu, outMax = iqMax, outMin = iqMin, y_start = iqCmd0Pu) annotation(
    Placement(visible = true, transformation(origin = {100, 225}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {165, 175}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {210, 195}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpu) annotation(
    Placement(visible = true, transformation(origin = {75, 135}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {125, 135}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {75, 105}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {75, 165}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECQcontrolVDrop iECQcontrolVDrop1(P0Pu = P0Pu, Q0Pu = Q0Pu,Rdrop = Rdrop, SNom = SNom, Xdrop = Xdrop, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, 150}, extent = {{-20, -10}, {20, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter4(limitsAtInit = true, uMax = 100, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {0, 35}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // MqG=2
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tqord, k = 1, y_start = qWTRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter2 annotation(
    Placement(visible = true, transformation(origin = {75, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Division division3 annotation(
    Placement(visible = true, transformation(origin = {125, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(limitsAtInit = true, uMax = iqMax, uMin = iqMin) annotation(
    Placement(visible = true, transformation(origin = {170, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //tan phi
  Modelica.Blocks.Math.Product product3 annotation(
    Placement(visible = true, transformation(origin = {-215, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = TanPhi) annotation(
    Placement(visible = true, transformation(origin = {-260, 35}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //FRT
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInt switch17 annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.DelayFlag delayFlag(Td = Td, Ts = Ts) annotation(
    Placement(visible = true, transformation(origin = {-50, -44}, extent = {{-20, -15}, {20, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const11(k = uqDip) annotation(
    Placement(visible = true, transformation(origin = {-160, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {-110, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {-110, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const12(k = uqRise) annotation(
    Placement(visible = true, transformation(origin = {-160, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger annotation(
    Placement(visible = true, transformation(origin = {0, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Iqcmd
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchThree switch15 annotation(
    Placement(visible = true, transformation(origin = {250, -200}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter5(limitsAtInit = true, uMax = iqh1, uMin = iqMin) annotation(
    Placement(visible = true, transformation(origin = {200, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = iqh1, uMin = iqMin) annotation(
    Placement(visible = true, transformation(origin = {200, -245}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFour switch16 annotation(
    Placement(visible = true, transformation(origin = {120, -200}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFour switch14 annotation(
    Placement(visible = true, transformation(origin = {160, -245}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = Mqfrt) annotation(
    Placement(visible = true, transformation(origin = {100, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {110, -249}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = iqPost) annotation(
    Placement(visible = true, transformation(origin = {60, -262}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = ipfHook) annotation(
    Placement(visible = true, transformation(origin = {0, -285}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = idfHook) annotation(
    Placement(visible = true, transformation(origin = {75, -227}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {75, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {0, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(deadZoneAtInit = true, uMax = udbTwo, uMin = udbOne) annotation(
    Placement(visible = true, transformation(origin = {-50, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = Tuss, k = Tuss, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-100, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Freeze
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(visible = true, transformation(origin = {125, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const10(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.IntegerToReal integerToReal annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
/*Connectors*/
  connect(switchXref.y, variableLimiter1.u) annotation(
    Line(points = {{-242, 195}, {-222, 195}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, feedback.u1) annotation(
    Line(points = {{-199, 195}, {-183, 195}}, color = {0, 0, 127}));
  connect(feedback.y, limIntegrator1.u) annotation(
    Line(points = {{-166, 195}, {-160, 195}, {-160, 215}, {-152, 215}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-166, 195}, {-160, 195}, {-160, 175}, {-152, 175}}, color = {0, 0, 127}));
  connect(limIntegrator1.y, add.u1) annotation(
    Line(points = {{-129, 215}, {-125, 215}, {-125, 201}, {-117, 201}}, color = {0, 0, 127}));
  connect(gain.y, add.u2) annotation(
    Line(points = {{-129, 175}, {-126, 175}, {-126, 189}, {-117, 189}}, color = {0, 0, 127}));
  connect(add.y, switch1.u1) annotation(
    Line(points = {{-94, 195}, {-83, 195}, {-83, 201}, {-68, 201}}, color = {0, 0, 127}));
  connect(add.y, switch1.u3) annotation(
    Line(points = {{-94, 195}, {-83, 195}, {-83, 188}, {-68, 188}}, color = {0, 0, 127}));
  connect(switchXref.y, add3.u2) annotation(
    Line(points = {{-242, 195}, {-237, 195}, {-237, 234}, {-117, 234}}, color = {0, 0, 127}));
  connect(const.y, add3.u1) annotation(
    Line(points = {{-129, 253}, {-125, 253}, {-125, 246}, {-117, 246}}, color = {0, 0, 127}));
  connect(add3.y, switch1.u0) annotation(
    Line(points = {{-94, 240}, {-84, 240}, {-84, 208}, {-68, 208}}, color = {0, 0, 127}));
  connect(qWTMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{-310, 255}, {-229, 255}, {-229, 203}, {-222, 203}}, color = {0, 0, 127}));
  connect(qWTMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{-310, 135}, {-231, 135}, {-231, 187}, {-222, 187}}, color = {0, 0, 127}));
  connect(qWTCfiltPu, feedback.u2) annotation(
    Line(points = {{-310, 75}, {-175, 75}, {-175, 187}}, color = {0, 0, 127}));
  connect(switch1.y, limiter.u) annotation(
    Line(points = {{-32, 195}, {-22, 195}}, color = {0, 0, 127}));
  connect(limiter.y, feedback2.u1) annotation(
    Line(points = {{1, 195}, {17, 195}}, color = {0, 0, 127}));
  connect(switchIqbase.y, iqBaseHook) annotation(
    Line(points = {{278, 145}, {310, 145}}, color = {0, 0, 127}));
  connect(add2.y, switchIqbase.u0) annotation(
    Line(points = {{221, 195}, {233, 195}, {233, 158}, {242, 158}}, color = {0, 0, 127}));
  connect(add2.y, switchIqbase.u1) annotation(
    Line(points = {{221, 195}, {233, 195}, {233, 151}, {242, 151}}, color = {0, 0, 127}));
  connect(add2.y, switchIqbase.u3) annotation(
    Line(points = {{221, 195}, {233, 195}, {233, 138}, {242, 138}}, color = {0, 0, 127}));
  connect(feedback2.y, gain2.u) annotation(
    Line(points = {{34, 195}, {88, 195}}, color = {0, 0, 127}));
  connect(gain2.y, switch11.u1) annotation(
    Line(points = {{111, 195}, {133, 195}, {133, 183}, {153, 183}}, color = {0, 0, 127}));
  connect(switch11.y, add2.u2) annotation(
    Line(points = {{176, 175}, {185, 175}, {185, 189}, {198, 189}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add2.u1) annotation(
    Line(points = {{111, 225}, {162, 225}, {162, 201}, {198, 201}}, color = {0, 0, 127}));
  connect(feedback2.y, limIntegrator.u) annotation(
    Line(points = {{34, 195}, {55, 195}, {55, 225}, {88, 225}}, color = {0, 0, 127}));
  connect(variableLimiter.y, switch11.u3) annotation(
    Line(points = {{136, 135}, {144, 135}, {144, 167}, {153, 167}}, color = {0, 0, 127}));
  connect(gain1.y, variableLimiter.u) annotation(
    Line(points = {{86, 135}, {113, 135}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter.limit1) annotation(
    Line(points = {{86, 165}, {98, 165}, {98, 143}, {113, 143}}, color = {0, 0, 127}));
  connect(division.y, variableLimiter.limit2) annotation(
    Line(points = {{86, 105}, {95, 105}, {95, 127}, {113, 127}}, color = {0, 0, 127}));
  connect(feedback2.y, gain1.u) annotation(
    Line(points = {{34, 195}, {35, 195}, {35, 135}, {63, 135}}, color = {0, 0, 127}));
  connect(qWTCfiltPu, iECQcontrolVDrop1.qWTCfiltPu) annotation(
    Line(points = {{-310, 75}, {-175, 75}, {-175, 157}, {-72, 157}}, color = {0, 0, 127}));
  connect(iECQcontrolVDrop1.uWTCfiltDropPu, feedback2.u2) annotation(
    Line(points = {{-28, 150}, {25, 150}, {25, 187}}, color = {0, 0, 127}));
  connect(pWTCfiltPu, iECQcontrolVDrop1.pWTCfiltPu) annotation(
    Line(points = {{-310, 15}, {-87, 15}, {-87, 150}, {-72, 150}}, color = {0, 0, 127}));
  connect(limiter4.y, division1.u2) annotation(
    Line(points = {{11, 35}, {52, 35}, {52, 159}, {63, 159}}, color = {0, 0, 127}));
  connect(qWTMinPu, division.u1) annotation(
    Line(points = {{-310, 135}, {-137, 135}, {-137, 111}, {63, 111}}, color = {0, 0, 127}));
  connect(limiter4.y, division.u2) annotation(
    Line(points = {{11, 35}, {52, 35}, {52, 99}, {63, 99}}, color = {0, 0, 127}));
  connect(qWTMaxPu, division1.u1) annotation(
    Line(points = {{-310, 255}, {-229, 255}, {-229, 274}, {44, 274}, {44, 171}, {63, 171}}, color = {0, 0, 127}));
  connect(limiter4.y, division3.u2) annotation(
    Line(points = {{11, 35}, {96, 35}, {96, 48}, {113, 48}}, color = {0, 0, 127}));
  connect(limiter2.y, switchIqbase.u2) annotation(
    Line(points = {{181, 55}, {203, 55}, {203, 146}, {223, 146}, {223, 145}, {242, 145}}, color = {0, 0, 127}));
  connect(division3.y, limiter2.u) annotation(
    Line(points = {{136, 54}, {147, 54}, {147, 55}, {158, 55}}, color = {0, 0, 127}));
  connect(pWTCfiltPu, product3.u2) annotation(
    Line(points = {{-310, 15}, {-235, 15}, {-235, 23}, {-227, 23}}, color = {0, 0, 127}));
  connect(product3.y, switchXref.u3) annotation(
    Line(points = {{-204, 29}, {-190, 29}, {-190, 53}, {-290, 53}, {-290, 188}, {-278, 188}}, color = {0, 0, 127}));
  connect(product3.y, switchXref.u4) annotation(
    Line(points = {{-204, 29}, {-190, 29}, {-190, 53}, {-290, 53}, {-290, 182}, {-278, 182}}, color = {0, 0, 127}));
  connect(integerConstant1.y, switch1.M) annotation(
    Line(points = {{0, 279}, {0, 279}, {0, 276}, {-50, 276}, {-50, 213}, {-50, 213}}, color = {255, 127, 0}));
  connect(integerConstant1.y, switchIqbase.M) annotation(
    Line(points = {{0, 279}, {1, 279}, {1, 276}, {259, 276}, {259, 163}, {260, 163}}, color = {255, 127, 0}));
  connect(integerConstant1.y, switchXref.M) annotation(
    Line(points = {{0, 279}, {1, 279}, {1, 276}, {-259, 276}, {-259, 213}, {-260, 213}}, color = {255, 127, 0}));
  connect(switch17.y, Ffrt) annotation(
    Line(points = {{61, -50}, {310, -50}}, color = {255, 127, 0}));
  connect(delayFlag.y, switch17.u0) annotation(
    Line(points = {{-28, -44}, {39, -44}}, color = {255, 127, 0}));
  connect(less.y, delayFlag.u) annotation(
    Line(points = {{-99, -44}, {-72, -44}}, color = {255, 0, 255}));
  connect(const11.y, less.u2) annotation(
    Line(points = {{-149, -52}, {-122, -52}}, color = {0, 0, 127}));
  connect(const12.y, greater.u2) annotation(
    Line(points = {{-149, -96}, {-123, -96}, {-123, -96}, {-122, -96}}, color = {0, 0, 127}));
  connect(greater.y, switch17.M) annotation(
    Line(points = {{-99, -88}, {-22, -88}, {-22, -51}, {39, -51}, {39, -50}}, color = {255, 0, 255}));
  connect(greater.y, booleanToInteger.u) annotation(
    Line(points = {{-99, -88}, {-22, -88}, {-22, -74}, {-12, -74}, {-12, -75}}, color = {255, 0, 255}));
  connect(booleanToInteger.y, switch17.u1) annotation(
    Line(points = {{11, -75}, {21, -75}, {21, -56}, {39, -56}, {39, -56}}, color = {255, 127, 0}));
  connect(uWTCfiltPu, limiter4.u) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, 5}, {-80, 5}, {-80, 36}, {-12, 36}, {-12, 35}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, less.u1) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, -34}, {-134, -34}, {-134, -44}, {-122, -44}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, greater.u1) annotation(
    Line(points = {{-310, -75}, {-132, -75}, {-132, -89}, {-122, -89}, {-122, -88}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, iECQcontrolVDrop1.uWTCfiltPu) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, 5}, {-80, 5}, {-80, 143}, {-72, 143}}, color = {0, 0, 127}));
  connect(switch15.y, iqCmdPu) annotation(
    Line(points = {{263, -200}, {304, -200}, {304, -200}, {310, -200}}, color = {0, 0, 127}));
  connect(limiter1.y, switch15.u2) annotation(
    Line(points = {{211, -245}, {228, -245}, {228, -208}, {235, -208}, {235, -207}, {237, -207}}, color = {0, 0, 127}));
  connect(limiter5.y, switch15.u1) annotation(
    Line(points = {{211, -200}, {237, -200}, {237, -200}, {237, -200}}, color = {0, 0, 127}));
  connect(switch14.y, limiter1.u) annotation(
    Line(points = {{175, -245}, {188, -245}}, color = {0, 0, 127}));
  connect(switch16.y, limiter5.u) annotation(
    Line(points = {{135, -200}, {188, -200}}, color = {0, 0, 127}));
  connect(integerConstant.y, switch16.M) annotation(
    Line(points = {{111, -150}, {120, -150}, {120, -185}}, color = {255, 127, 0}));
  connect(integerConstant.y, switch14.M) annotation(
    Line(points = {{111, -150}, {161, -150}, {161, -230}, {160, -230}}, color = {255, 127, 0}));
  connect(switch16.y, switch14.u0) annotation(
    Line(points = {{135, -200}, {140, -200}, {140, -234}, {145, -234}}, color = {0, 0, 127}));
  connect(const5.y, add4.u2) annotation(
    Line(points = {{71, -262}, {84.5, -262}, {84.5, -255}, {98, -255}}, color = {0, 0, 127}));
  connect(switchIqbase.y, add4.u1) annotation(
    Line(points = {{278, 145}, {279, 145}, {279, -87}, {50, -87}, {50, -243}, {98, -243}}, color = {0, 0, 127}));
  connect(add4.y, switch14.u2) annotation(
    Line(points = {{121, -249}, {145, -249}}, color = {0, 0, 127}));
  connect(const2.y, switch14.u3) annotation(
    Line(points = {{11, -285}, {130, -285}, {130, -255}, {145, -255}, {145, -256}}, color = {0, 0, 127}));
  connect(switch16.y, switch14.u1) annotation(
    Line(points = {{135, -200}, {140, -200}, {140, -241}, {145, -241}, {145, -241}}, color = {0, 0, 127}));
  connect(const1.y, switch16.u3) annotation(
    Line(points = {{86, -227}, {94, -227}, {94, -212}, {105, -212}, {105, -211}}, color = {0, 0, 127}));
  connect(add5.y, switch16.u2) annotation(
    Line(points = {{86, -200}, {98, -200}, {98, -204}, {105, -204}}, color = {0, 0, 127}));
  connect(add5.y, switch16.u1) annotation(
    Line(points = {{86, -200}, {98, -200}, {98, -197}, {105, -197}, {105, -196}}, color = {0, 0, 127}));
  connect(switchIqbase.y, add5.u2) annotation(
    Line(points = {{278, 145}, {279, 145}, {279, -87}, {50, -87}, {50, -207}, {63, -207}, {63, -206}}, color = {0, 0, 127}));
  connect(gain3.y, add5.u1) annotation(
    Line(points = {{11, -180}, {33, -180}, {33, -194}, {63, -194}}, color = {0, 0, 127}));
  connect(gain3.y, switch16.u0) annotation(
    Line(points = {{11, -180}, {89, -180}, {89, -189}, {105, -189}}, color = {0, 0, 127}));
  connect(deadZone.y, gain3.u) annotation(
    Line(points = {{-39, -180}, {-11, -180}, {-11, -180}, {-12, -180}}, color = {0, 0, 127}));
  connect(uWTCfiltPu, derivative.u) annotation(
    Line(points = {{-310, -75}, {-243, -75}, {-243, -180}, {-112, -180}, {-112, -180}}, color = {0, 0, 127}));
  connect(derivative.y, deadZone.u) annotation(
    Line(points = {{-89, -180}, {-59, -180}, {-59, -181}, {-62, -181}, {-62, -180}}, color = {0, 0, 127}));
  connect(const3.y, product3.u1) annotation(
    Line(points = {{-249, 35}, {-227, 35}}, color = {0, 0, 127}));
  connect(limiter2.y, switchIqbase.u4) annotation(
    Line(points = {{181, 55}, {203, 55}, {203, 131}, {242, 131}, {242, 132}}, color = {0, 0, 127}));
  connect(switchIqbase.y, switch15.u0) annotation(
    Line(points = {{278, 145}, {279, 145}, {279, -87}, {227, -87}, {227, -193}, {237, -193}}, color = {0, 0, 127}));
  connect(switch17.y, switch15.M) annotation(
    Line(points = {{61, -50}, {293, -50}, {293, -165}, {251, -165}, {251, -187}, {250, -187}}, color = {255, 127, 0}));
  connect(gain3.y, iqvHook) annotation(
    Line(points = {{11, -180}, {33, -180}, {33, -126}, {310, -126}, {310, -125}}, color = {0, 0, 127}));
  connect(iECQcontrolVDrop1.uWTCfiltDropPu, switch1.u2) annotation(
    Line(points = {{-28, 150}, {-23, 150}, {-23, 172}, {-76, 172}, {-76, 195}, {-68, 195}, {-68, 195}}, color = {0, 0, 127}));
  connect(iECQcontrolVDrop1.uWTCfiltDropPu, switch1.u4) annotation(
    Line(points = {{-28, 150}, {-23, 150}, {-23, 172}, {-76, 172}, {-76, 181}, {-68, 181}, {-68, 182}}, color = {0, 0, 127}));
  connect(switch17.y, integerToReal.u) annotation(
    Line(points = {{61, -50}, {68, -50}, {68, 0}, {78, 0}, {78, 0}}, color = {255, 127, 0}));
  connect(integerToReal.y, greater1.u1) annotation(
    Line(points = {{101, 0}, {105, 0}, {105, -15}, {113, -15}, {113, -15}}, color = {0, 0, 127}));
  connect(const10.y, greater1.u2) annotation(
    Line(points = {{101, -30}, {103, -30}, {103, -23}, {113, -23}, {113, -23}}, color = {0, 0, 127}));
  connect(greater1.y, switch11.u2) annotation(
    Line(points = {{136, -15}, {140, -15}, {140, 175}, {153, 175}, {153, 175}}, color = {255, 0, 255}));
  connect(xWTRefPu, switchXref.u2) annotation(
    Line(points = {{-310, 195}, {-278, 195}, {-278, 195}, {-278, 195}}, color = {0, 0, 127}));
  connect(xWTRefPu, switchXref.u1) annotation(
    Line(points = {{-310, 195}, {-289, 195}, {-289, 201}, {-278, 201}, {-278, 201}}, color = {0, 0, 127}));
  connect(xWTRefPu, switchXref.u0) annotation(
    Line(points = {{-310, 195}, {-289, 195}, {-289, 207}, {-278, 207}, {-278, 208}}, color = {0, 0, 127}));
  connect(switchXref.y, firstOrder.u) annotation(
    Line(points = {{-242, 195}, {-237, 195}, {-237, 60}, {-12, 60}, {-12, 60}}, color = {0, 0, 127}));
  connect(firstOrder.y, variableLimiter2.u) annotation(
    Line(points = {{11, 60}, {64, 60}, {64, 60}, {63, 60}}, color = {0, 0, 127}));
  connect(variableLimiter2.y, division3.u1) annotation(
    Line(points = {{86, 60}, {114, 60}, {114, 60}, {113, 60}}, color = {0, 0, 127}));
  connect(qWTMaxPu, variableLimiter2.limit1) annotation(
    Line(points = {{-310, 255}, {-229, 255}, {-229, 274}, {44, 274}, {44, 68}, {63, 68}, {63, 68}}, color = {0, 0, 127}));
  connect(qWTMinPu, variableLimiter2.limit2) annotation(
    Line(points = {{-310, 135}, {-137, 135}, {-137, 111}, {39, 111}, {39, 52}, {63, 52}, {63, 52}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-300, -300}, {300, 300}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, -100}, {100, 100}}), Text(origin = {0, 30}, extent = {{-100, -30}, {100, 30}}, textString = "IEC WT 4A"), Text(origin = {0, -30}, extent = {{-100, -30}, {100, 30}}, textString = "QControl")}));
end IECWT4AQControl;
