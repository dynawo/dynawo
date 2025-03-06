within Dynawo.Electrical.Controls.IEC.IEC63406.Controls.BaseControls;

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

model QControl "Reactive power control (IEC 63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Parameters
  parameter Types.PerUnit DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KPqu "Proportional gain in the reactive power PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KIqu "Integral gain in the reactive power PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KPuq "Proportional gain in the outer voltage PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KIuq "Integral gain in the outer voltage PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KPui "Proportional gain in the inner voltage PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KIui "Integral gain in the inner voltage PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KPqi "Proportional gain in the inner reactive power PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KIqi "Integral gain in the inner reactive power PI controller" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit KDroop "Q/U droop gain" annotation(
    Dialog(tab = "QControl"));
  parameter Integer LFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Integer PFFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Real TanPhi "Power factor used in the power factor control" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time Tiq "Time constant in reactive power order lag" annotation(
    Dialog(tab = "QControl"));
  parameter Boolean UFlag "One of the 3 reactive control flags" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMaxPu "Maximum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit UMinPu "Minimum voltage defined by users at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput FFlag(start = false) "Flag indicating the generating unit operating condition" annotation(
    Placement(visible = true, transformation(origin = {-170, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iQMinPu(start = IQMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {100, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {239, 115}, extent = {{15, -15}, {-15, 15}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iQMaxPu(start = IQMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {160, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {281, 115}, extent = {{15, -15}, {-15, 15}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-330, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-332, -80}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMaxPu(start = QMax0Pu) "Maximum reactive power at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-101, 115}, extent = {{15, -15}, {-15, 15}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput qMinPu(start = QMin0Pu) "Minimum reactive power at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-141, 115}, extent = {{15, -15}, {-15, 15}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput qMeasPu(start =- Q0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) reactive power component at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-330, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-332, -40}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference provided by the plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-330, 1.42109e-14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-332, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Measured (and filtered) voltage component in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-330, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-331, 41}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uRefPu(start = U0Pu) "Voltage reference provided by the plant controller in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-330, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-331, 81}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iQcmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {330, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {340, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {76, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-290, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(deadZoneAtInit = true, uMax = DUdb2Pu, uMin = DUdb1Pu) annotation(
    Placement(visible = true, transformation(origin = {-260, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KDroop) annotation(
    Placement(visible = true, transformation(origin = {-230, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-200, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {-160, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIFreeze pIFreeze(Gain = KPqu, Y0 = U0Pu, tIntegral = 1 / KIqu) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = FFlag) annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -8}, {10, 8}}, rotation = 90)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter2 annotation(
    Placement(visible = true, transformation(origin = {42, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone1(deadZoneAtInit = true, uMax = DUdb2Pu, uMin = DUdb1Pu) annotation(
    Placement(visible = true, transformation(origin = {138, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIFreeze pIFreeze1(Gain = KPui, Y0 = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu), tIntegral = 1 / KIui) annotation(
    Placement(visible = true, transformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter3 annotation(
    Placement(visible = true, transformation(origin = {200, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y = LFlag) annotation(
    Placement(visible = true, transformation(origin = {260, 33}, extent = {{-13, -14}, {13, 14}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter4 annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression2(y = FFlag) annotation(
    Placement(visible = true, transformation(origin = {130, -42}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1(y = PFFlag) annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Add add4(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-290, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone2(deadZoneAtInit = true, uMax = DUdb2Pu, uMin = DUdb1Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression4(y = FFlag) annotation(
    Placement(visible = true, transformation(origin = {-210, -111}, extent = {{-10, -9}, {10, 9}}, rotation = 90)));
  Dynawo.NonElectrical.Blocks.Continuous.PIFreeze pIFreeze5(Gain = KPuq, Y0 = -Q0Pu * SystemBase.SnRef / SNom, tIntegral = 1 / KIuq) annotation(
    Placement(visible = true, transformation(origin = {-210, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIFreeze pIFreeze2(Gain = KPqi, Y0 = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu), tIntegral = 1 / KIqi) annotation(
    Placement(visible = true, transformation(origin = {30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = -1) annotation(
    Placement(visible = true, transformation(origin = {300, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression12(y = qMinPu) annotation(
    Placement(visible = true, transformation(origin = {-82, -30}, extent = {{-10, -8}, {10, 8}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression13(y = qMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-230, 64}, extent = {{-10, -8}, {10, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression14(y = qMinPu) annotation(
    Placement(visible = true, transformation(origin = {-230, 16}, extent = {{-10, -8}, {10, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression15(y = UMaxPu) annotation(
    Placement(visible = true, transformation(origin = {10, 65}, extent = {{-10, -9}, {10, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression16(y = UMinPu) annotation(
    Placement(visible = true, transformation(origin = {24, 10}, extent = {{-10, -8}, {10, 8}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression17(y = iQMaxPu) annotation(
    Placement(visible = true, transformation(origin = {170, 64}, extent = {{-10, -8}, {10, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression18(y = iQMinPu) annotation(
    Placement(visible = true, transformation(origin = {187, 9}, extent = {{10, -8}, {-10, 8}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression20(y = iQMinPu) annotation(
    Placement(visible = true, transformation(origin = {58, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression11(y = UFlag) annotation(
    Placement(visible = true, transformation(origin = {59, 89}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression19(y = iQMaxPu) annotation(
    Placement(visible = true, transformation(origin = {58, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression21(y = iQMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression22(y = iQMaxPu) annotation(
    Placement(visible = true, transformation(origin = {90, -69}, extent = {{-10, -9}, {10, 9}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreeze absLimRateLimFirstOrderFreeze(DyMax = 1000, UseLimits = true, Y0 = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu), YMax = 999, tI = Tiq) annotation(
    Placement(visible = true, transformation(origin = {130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = Modelica.Constants.inf, uMin = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = TanPhi) annotation(
    Placement(visible = true, transformation(origin = {-250, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = uRefPu) annotation(
    Placement(visible = true, transformation(origin = {-330, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = uMeasPu) annotation(
    Placement(visible = true, transformation(origin = {-330, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = uMeasPu) annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = uRefPu) annotation(
    Placement(visible = true, transformation(origin = {40, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y = FFlag) annotation(
    Placement(visible = true, transformation(origin = {170, 9}, extent = {{-10, -9}, {10, 9}}, rotation = 90)));

  //Initial parameters
  parameter Types.PerUnit IQMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IQMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Operating point"));

  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4)  annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch1(nu = 3)  annotation(
    Placement(visible = true, transformation(origin = {260, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(deadZone.u, add1.y) annotation(
    Line(points = {{-272, 40}, {-279, 40}}, color = {0, 0, 127}));
  connect(deadZone.y, gain.u) annotation(
    Line(points = {{-249, 40}, {-242, 40}}, color = {0, 0, 127}));
  connect(gain.y, variableLimiter.u) annotation(
    Line(points = {{-219, 40}, {-212, 40}}, color = {0, 0, 127}));
  connect(add2.y, pIFreeze.u) annotation(
    Line(points = {{-29, 40}, {-12, 40}}, color = {0, 0, 127}));
  connect(pIFreeze.y, variableLimiter2.u) annotation(
    Line(points = {{11, 40}, {30, 40}}, color = {0, 0, 127}));
  connect(add.y, deadZone1.u) annotation(
    Line(points = {{121, 40}, {126, 40}}, color = {0, 0, 127}));
  connect(deadZone1.y, pIFreeze1.u) annotation(
    Line(points = {{149, 40}, {158, 40}}, color = {0, 0, 127}));
  connect(pIFreeze1.y, variableLimiter3.u) annotation(
    Line(points = {{181, 40}, {188, 40}}, color = {0, 0, 127}));
  connect(add4.y, deadZone2.u) annotation(
    Line(points = {{-279, -60}, {-262, -60}}, color = {0, 0, 127}));
  connect(pIFreeze2.y, variableLimiter4.u) annotation(
    Line(points = {{41, -20}, {78, -20}}, color = {0, 0, 127}));
  connect(deadZone2.y, pIFreeze5.u) annotation(
    Line(points = {{-239, -60}, {-222, -60}}, color = {0, 0, 127}));
  connect(booleanExpression4.y, pIFreeze5.freeze) annotation(
    Line(points = {{-210, -100}, {-210, -72}}, color = {255, 0, 255}));
  connect(realExpression15.y, variableLimiter2.limit1) annotation(
    Line(points = {{21, 65}, {30, 65}, {30, 48}}, color = {0, 0, 127}));
  connect(realExpression17.y, variableLimiter3.limit1) annotation(
    Line(points = {{181, 64}, {188, 64}, {188, 48}}, color = {0, 0, 127}));
  connect(realExpression18.y, variableLimiter3.limit2) annotation(
    Line(points = {{187, 20}, {187, 32}, {188, 32}}, color = {0, 0, 127}));
  connect(division.y, absLimRateLimFirstOrderFreeze.u) annotation(
    Line(points = {{41, -80}, {118, -80}}, color = {0, 0, 127}));
  connect(booleanExpression2.y, absLimRateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{130, -51.9}, {130, -67.9}}, color = {255, 0, 255}));
  connect(uRefPu, add1.u1) annotation(
    Line(points = {{-330, 60}, {-310, 60}, {-310, 46}, {-302, 46}}, color = {0, 0, 127}));
  connect(uMeasPu, add1.u2) annotation(
    Line(points = {{-330, 20}, {-310, 20}, {-310, 34}, {-302, 34}}, color = {0, 0, 127}));
  connect(realExpression13.y, variableLimiter.limit1) annotation(
    Line(points = {{-219, 64}, {-212, 64}, {-212, 48}}, color = {0, 0, 127}));
  connect(realExpression14.y, variableLimiter.limit2) annotation(
    Line(points = {{-219, 16}, {-212, 16}, {-212, 32}}, color = {0, 0, 127}));
  connect(variableLimiter.y, add3.u1) annotation(
    Line(points = {{-189, 40}, {-181, 40}, {-181, 46}, {-172, 46}}, color = {0, 0, 127}));
  connect(pMeasPu, gain1.u) annotation(
    Line(points = {{-330, -20}, {-262, -20}}, color = {0, 0, 127}));
  connect(qRefPu, add3.u2) annotation(
    Line(points = {{-330, 1.42109e-14}, {-180, 1.42109e-14}, {-180, 34}, {-172, 34}}, color = {0, 0, 127}));
  connect(realExpression.y, add4.u1) annotation(
    Line(points = {{-319, -40}, {-311, -40}, {-311, -54}, {-303, -54}}, color = {0, 0, 127}));
  connect(realExpression1.y, add4.u2) annotation(
    Line(points = {{-319, -80}, {-311, -80}, {-311, -66}, {-303, -66}}, color = {0, 0, 127}));
  connect(qMeasPu, add2.u1) annotation(
    Line(points = {{-330, 80}, {-52, 80}, {-52, 46}}, color = {0, 0, 127}));
  connect(booleanExpression.y, pIFreeze.freeze) annotation(
    Line(points = {{0, 21}, {0, 28}}, color = {255, 0, 255}));
  connect(realExpression16.y, variableLimiter2.limit2) annotation(
    Line(points = {{24, 21}, {24, 32}, {30, 32}}, color = {0, 0, 127}));
  connect(variableLimiter2.y, switch1.u1) annotation(
    Line(points = {{53, 40}, {55, 40}, {55, 32}, {64, 32}}, color = {0, 0, 127}));
  connect(switch1.y, add.u1) annotation(
    Line(points = {{87, 40}, {93, 40}, {93, 46}, {98, 46}}, color = {0, 0, 127}));
  connect(realExpression2.y, add.u2) annotation(
    Line(points = {{90, 79}, {90, 34}, {98, 34}}, color = {0, 0, 127}));
  connect(booleanExpression11.y, switch1.u2) annotation(
    Line(points = {{59, 78}, {59, 40}, {64, 40}}, color = {255, 0, 255}));
  connect(realExpression3.y, switch1.u3) annotation(
    Line(points = {{40, 79}, {40, 59}, {56, 59}, {56, 48}, {64, 48}}, color = {0, 0, 127}));
  connect(booleanExpression1.y, pIFreeze1.freeze) annotation(
    Line(points = {{170, 20}, {170, 28}}, color = {255, 0, 255}));
  connect(realExpression1.y, limiter1.u) annotation(
    Line(points = {{-319, -80}, {-72, -80}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, add2.u2) annotation(
    Line(points = {{-59, 20}, {-52, 20}, {-52, 34}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, division.u1) annotation(
    Line(points = {{-59, 20}, {-40, 20}, {-40, -74}, {18, -74}}, color = {0, 0, 127}));
  connect(realExpression22.y, absLimRateLimFirstOrderFreeze.yMax) annotation(
    Line(points = {{101, -69}, {113, -69}, {113, -75}, {117, -75}}, color = {0, 0, 127}));
  connect(realExpression21.y, absLimRateLimFirstOrderFreeze.yMin) annotation(
    Line(points = {{101, -92}, {113, -92}, {113, -86}, {117, -86}}, color = {0, 0, 127}));
  connect(add2.y, pIFreeze2.u) annotation(
    Line(points = {{-29, 40}, {-21, 40}, {-21, -20}, {18, -20}}, color = {0, 0, 127}));
  connect(realExpression20.y, variableLimiter4.limit2) annotation(
    Line(points = {{69, -32}, {73.5, -32}, {73.5, -28}, {78, -28}}, color = {0, 0, 127}));
  connect(realExpression19.y, variableLimiter4.limit1) annotation(
    Line(points = {{69, -12}, {78, -12}}, color = {0, 0, 127}));
  connect(gain2.y, iQcmdPu) annotation(
    Line(points = {{311, -20}, {329, -20}}, color = {0, 0, 127}));
  connect(limiter1.y, division.u2) annotation(
    Line(points = {{-48, -80}, {0, -80}, {0, -86}, {18, -86}}, color = {0, 0, 127}));
  connect(booleanExpression2.y, pIFreeze2.freeze) annotation(
    Line(points = {{130, -52}, {130, -60}, {30, -60}, {30, -32}}, color = {255, 0, 255}));
  connect(realExpression13.y, variableLimiter1.limit1) annotation(
    Line(points = {{-218, 64}, {-82, 64}, {-82, 28}}, color = {0, 0, 127}));
  connect(realExpression12.y, variableLimiter1.limit2) annotation(
    Line(points = {{-82, -19}, {-82, 12}}, color = {0, 0, 127}));
  connect(add3.y, multiSwitch.u[1]) annotation(
    Line(points = {{-148, 40}, {-140, 40}, {-140, 20}, {-130, 20}}, color = {0, 0, 127}));
  connect(qRefPu, multiSwitch.u[2]) annotation(
    Line(points = {{-330, 0}, {-180, 0}, {-180, 20}, {-130, 20}}, color = {0, 0, 127}));
  connect(gain1.y, multiSwitch.u[3]) annotation(
    Line(points = {{-238, -20}, {-140, -20}, {-140, 20}, {-130, 20}}, color = {0, 0, 127}));
  connect(pIFreeze5.y, multiSwitch.u[4]) annotation(
    Line(points = {{-198, -60}, {-140, -60}, {-140, 20}, {-130, 20}}, color = {0, 0, 127}));
  connect(integerExpression1.y, multiSwitch.f) annotation(
    Line(points = {{-120, 39}, {-120, 32}}, color = {255, 127, 0}));
  connect(multiSwitch.y, variableLimiter1.u) annotation(
    Line(points = {{-108, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(variableLimiter3.y, multiSwitch1.u[1]) annotation(
    Line(points = {{212, 40}, {240, 40}, {240, -20}, {250, -20}}, color = {0, 0, 127}));
  connect(variableLimiter4.y, multiSwitch1.u[2]) annotation(
    Line(points = {{102, -20}, {250, -20}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze.y, multiSwitch1.u[3]) annotation(
    Line(points = {{142, -80}, {240, -80}, {240, -20}, {250, -20}}, color = {0, 0, 127}));
  connect(integerExpression.y, multiSwitch1.f) annotation(
    Line(points = {{260, 18}, {260, -8}}, color = {255, 127, 0}));
  connect(multiSwitch1.y, gain2.u) annotation(
    Line(points = {{272, -20}, {288, -20}}, color = {0, 0, 127}));
protected

  annotation(
    Icon(graphics = {Rectangle(extent = {{-320, 100}, {320, -100}}), Text(extent = {{-320, 98}, {320, -98}}, textString = "QControl")}, coordinateSystem(extent = {{-320, -100}, {320, 100}})),
    Diagram(coordinateSystem(extent = {{-320, -100}, {320, 100}})));
end QControl;
