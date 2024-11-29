within Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model GovSteam1 "Steam turbine governor, based on the GovSteamIEEE1 (with optional deadband and nonlinear valve gain added)"

  //Regulation parameters
  parameter Types.AngularVelocityPu Db1 "Intentional deadband width in pu (base omegaNom). Typical value = 0";
  parameter Types.ActivePowerPu Db2 "Unintentional deadband width in pu (base PNom). Typical value = 0";
  parameter Types.AngularVelocityPu Eps "Intentional db hysteresis in pu (base omegaNom). Typical value = 0";
  parameter Boolean H0 = false "Start value of backlash hysteresis output. Typical value = false";
  parameter Types.PerUnit K "Governor gain (reciprocal of droop) (> 0). Typical value = 25";
  parameter Types.PerUnit K1 "Fraction of HP shaft power after first boiler pass. Typical value = 0.2";
  parameter Types.PerUnit K2 "Fraction of LP shaft power after first boiler pass. Typical value = 0";
  parameter Types.PerUnit K3 "Fraction of HP shaft power after second boiler pass. Typical value = 0.3";
  parameter Types.PerUnit K4 "Fraction of LP shaft power after second boiler pass. Typical value = 0";
  parameter Types.PerUnit K5 "Fraction of HP shaft power after third boiler pass. Typical value = 0.5";
  parameter Types.PerUnit K6 "Fraction of LP shaft power after third boiler pass. Typical value = 0";
  parameter Types.PerUnit K7 "Fraction of HP shaft power after fourth boiler pass. Typical value = 0";
  parameter Types.PerUnit K8 "Fraction of LP shaft power after fourth boiler pass. Typical value = 0";
  parameter Types.ActivePowerPu PMaxPu "Maximum valve opening (> PMinPu). Typical value = 1";
  parameter Types.ActivePowerPu PMinPu "Minimum valve opening (>= 0 and < PMaxPu). Typical value = 0";
  parameter Boolean Sdb1 "Intentional deadband indicator. true = intentional deadband is applied. false = intentional deadband is not applied. Typical value = true";
  parameter Boolean Sdb2 "Unintentional deadband location. true = intentional deadband is applied before add3. false = intentional deadband is applied after add3. Typical value = true.";
  parameter Types.Time t1 "Governor lag time constant in s (>= 0). Typical value = 0";
  parameter Types.Time t2 "Governor lead time constant in s (>= 0). Typical value = 0";
  parameter Types.Time t3 "Valve positioner time constant in s (> 0). Typical value = 0.1";
  parameter Types.Time t4 "Inlet piping/steam bowl time constant in s (>= 0). Typical value = 0.3";
  parameter Types.Time t5 "Time constant of second boiler pass in s (>= 0). Typical value = 5";
  parameter Types.Time t6 "Time constant of third boiler pass in s (>= 0). Typical value = 0.5.";
  parameter Types.Time t7 "Time constant of fourth boiler pass in s (>= 0). Typical value = 0";
  parameter Types.PerUnit Uc "Minimum valve closing velocity in pu / s (< 0). Typical value = -10.";
  parameter Types.PerUnit Uo "Maximum valve opening velocity in pu / s (> 0). Typical value = 1";
  parameter Boolean ValveOn "Nonlinear valve characteristic. true = nonlinear valve characteristic is used. false = nonlinear valve characteristic is not used. Typical value = true";

  //Table parameters
  parameter String PgvTableName "Name of table in text file for the characteristic of the rectifier regulator" annotation(
  Dialog(group="Table"));
  parameter String TablesFile "Text file that contains the characteristic of the rectifier regulator" annotation(
  Dialog(group="Table", loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)", caption="Open file in which table is present")));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-514, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = PmRef0Pu) "Reference mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {-514, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput Pm1Pu(start = Pm0Pu) "Mechanical power of the first turbine shaft in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {510, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Pm2Pu(start = 0) "Mechanical power of the second turbine shaft in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {510, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {330, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {390, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {450, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {330, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {390, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add6 annotation(
    Placement(visible = true, transformation(origin = {450, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.BacklashHysteresis backlashHysteresis(H0 = H0, U0 = PmRef0Pu, UHigh = Db2) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sdb2) annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = Sdb1) annotation(
    Placement(visible = true, transformation(origin = {-390, -50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant2(k = ValveOn) annotation(
    Placement(visible = true, transformation(origin = {90, -50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant const(k = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-510, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.DeadBand deadBand(EpsMax = Eps, UMax = Db1) annotation(
    Placement(visible = true, transformation(origin = {-390, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-450, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t4, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = t5, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = t6, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {330, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = t7, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {390, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / t3) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = K1) annotation(
    Placement(visible = true, transformation(origin = {240, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain2(k = K2) annotation(
    Placement(visible = true, transformation(origin = {240, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain3(k = K3) annotation(
    Placement(visible = true, transformation(origin = {300, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain4(k = K5) annotation(
    Placement(visible = true, transformation(origin = {360, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain5(k = K7) annotation(
    Placement(visible = true, transformation(origin = {420, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain6(k = K4) annotation(
    Placement(visible = true, transformation(origin = {300, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain7(k = K6) annotation(
    Placement(visible = true, transformation(origin = {360, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain8(k = K8) annotation(
    Placement(visible = true, transformation(origin = {420, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.LimIntegrator limitedIntegrator(outMax = PMaxPu, outMin = PMinPu, y_start = PmRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = Uo, uMin = Uc) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds pgv(fileName = TablesFile, tableName = PgvTableName, tableOnFile = true) annotation(
Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-330, -50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {150, -50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {t1, 1}, b = K * {t2, 1}) annotation(
    Placement(visible = true, transformation(origin = {-270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNom)" annotation(
  Dialog(group="Initialization"));
  parameter Types.ActivePowerPu PmRef0Pu "Initial reference mechanical power in pu (base PNom)" annotation(
  Dialog(group="Initialization"));

equation
  connect(transferFunction.y, add3.u2) annotation(
    Line(points = {{-259, 0}, {-222, 0}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-199, 0}, {-163, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-139, 0}, {-103, 0}}, color = {0, 0, 127}));
  connect(limiter.y, limitedIntegrator.u) annotation(
    Line(points = {{-79, 0}, {-43, 0}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, backlashHysteresis.u) annotation(
    Line(points = {{-19, 0}, {17, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, gain2.u) annotation(
    Line(points = {{221, 0}, {240, 0}, {240, -38}}, color = {0, 0, 127}));
  connect(firstOrder.y, firstOrder1.u) annotation(
    Line(points = {{221, 0}, {257, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, firstOrder2.u) annotation(
    Line(points = {{281, 0}, {317, 0}}, color = {0, 0, 127}));
  connect(firstOrder2.y, firstOrder3.u) annotation(
    Line(points = {{341, 0}, {377, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain6.u) annotation(
    Line(points = {{281, 0}, {300, 0}, {300, -38}}, color = {0, 0, 127}));
  connect(firstOrder2.y, gain7.u) annotation(
    Line(points = {{341, 0}, {360, 0}, {360, -38}}, color = {0, 0, 127}));
  connect(firstOrder3.y, gain8.u) annotation(
    Line(points = {{401, 0}, {420, 0}, {420, -38}}, color = {0, 0, 127}));
  connect(gain6.y, add.u1) annotation(
    Line(points = {{300, -61}, {300, -106}, {318, -106}}, color = {0, 0, 127}));
  connect(gain2.y, add.u2) annotation(
    Line(points = {{240, -61}, {240, -118}, {318, -118}}, color = {0, 0, 127}));
  connect(gain1.y, add4.u1) annotation(
    Line(points = {{240, 61}, {240, 118}, {318, 118}}, color = {0, 0, 127}));
  connect(gain3.y, add4.u2) annotation(
    Line(points = {{300, 61}, {300, 106}, {318, 106}}, color = {0, 0, 127}));
  connect(gain4.y, add5.u2) annotation(
    Line(points = {{360, 61}, {360, 100}, {378, 100}}, color = {0, 0, 127}));
  connect(add4.y, add5.u1) annotation(
    Line(points = {{341, 112}, {378, 112}}, color = {0, 0, 127}));
  connect(add5.y, add6.u1) annotation(
    Line(points = {{401, 106}, {437, 106}}, color = {0, 0, 127}));
  connect(gain5.y, add6.u2) annotation(
    Line(points = {{420, 61}, {420, 94}, {438, 94}}, color = {0, 0, 127}));
  connect(add.y, add1.u2) annotation(
    Line(points = {{341, -112}, {378, -112}}, color = {0, 0, 127}));
  connect(gain7.y, add1.u1) annotation(
    Line(points = {{360, -61}, {360, -100}, {378, -100}}, color = {0, 0, 127}));
  connect(add1.y, add2.u2) annotation(
    Line(points = {{401, -106}, {438, -106}}, color = {0, 0, 127}));
  connect(gain8.y, add2.u1) annotation(
    Line(points = {{420, -61}, {420, -94}, {438, -94}}, color = {0, 0, 127}));
  connect(add6.y, Pm1Pu) annotation(
    Line(points = {{461, 100}, {510, 100}}, color = {0, 0, 127}));
  connect(add2.y, Pm2Pu) annotation(
    Line(points = {{461, -100}, {510, -100}}, color = {0, 0, 127}));
  connect(switch1.y, add3.u3) annotation(
    Line(points = {{-81, -50}, {-240, -50}, {-240, -8}, {-222, -8}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{19, -50}, {-58, -50}}, color = {255, 0, 255}));
  connect(backlashHysteresis.y, pgv.u) annotation(
    Line(points = {{41, 0}, {77, 0}}, color = {0, 0, 127}));
  connect(booleanConstant1.y, switch.u2) annotation(
    Line(points = {{-379, -50}, {-342, -50}}, color = {255, 0, 255}));
  connect(deadBand.y, switch.u1) annotation(
    Line(points = {{-379, 0}, {-360, 0}, {-360, -42}, {-342, -42}}, color = {0, 0, 127}));
  connect(switch.y, transferFunction.u) annotation(
    Line(points = {{-319, -50}, {-300, -50}, {-300, 0}, {-282, 0}}, color = {0, 0, 127}));
  connect(booleanConstant2.y, switch2.u2) annotation(
    Line(points = {{101, -50}, {138, -50}}, color = {255, 0, 255}));
  connect(backlashHysteresis.y, switch2.u3) annotation(
    Line(points = {{41, 0}, {60, 0}, {60, -80}, {120, -80}, {120, -58}, {138, -58}}, color = {0, 0, 127}));
  connect(switch2.y, firstOrder.u) annotation(
    Line(points = {{161, -50}, {180, -50}, {180, 0}, {198, 0}}, color = {0, 0, 127}));
  connect(omegaPu, feedback.u1) annotation(
    Line(points = {{-514, 0}, {-458, 0}}, color = {0, 0, 127}));
  connect(feedback.y, deadBand.u) annotation(
    Line(points = {{-441, 0}, {-403, 0}}, color = {0, 0, 127}));
  connect(feedback.y, switch.u3) annotation(
    Line(points = {{-441, 0}, {-420, 0}, {-420, -80}, {-360, -80}, {-360, -58}, {-342, -58}}, color = {0, 0, 127}));
  connect(pgv.y[1], switch2.u1) annotation(
    Line(points = {{101, 0}, {120, 0}, {120, -42}, {137, -42}}, color = {0, 0, 127}));
  connect(firstOrder.y, gain1.u) annotation(
    Line(points = {{222, 0}, {240, 0}, {240, 38}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain3.u) annotation(
    Line(points = {{282, 0}, {300, 0}, {300, 38}}, color = {0, 0, 127}));
  connect(firstOrder2.y, gain4.u) annotation(
    Line(points = {{342, 0}, {360, 0}, {360, 38}}, color = {0, 0, 127}));
  connect(firstOrder3.y, gain5.u) annotation(
    Line(points = {{402, 0}, {420, 0}, {420, 38}}, color = {0, 0, 127}));
  connect(const.y, feedback.u2) annotation(
    Line(points = {{-499, -50}, {-450, -50}, {-450, -8}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, switch1.u3) annotation(
    Line(points = {{-18, 0}, {0, 0}, {0, -42}, {-58, -42}}, color = {0, 0, 127}));
  connect(backlashHysteresis.y, switch1.u1) annotation(
    Line(points = {{42, 0}, {60, 0}, {60, -80}, {0, -80}, {0, -58}, {-58, -58}}, color = {0, 0, 127}));
  connect(PmRefPu, add3.u1) annotation(
    Line(points = {{-514, 40}, {-240, 40}, {-240, 8}, {-222, 8}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-500, -200}, {500, 200}})));
end GovSteam1;
