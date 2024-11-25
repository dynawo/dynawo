within Dynawo.Electrical.Controls.IEC.IEC63406.Protections;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Protection

  // Voltage protection table parameters
  parameter Real TLVP3 = 0.3 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TLVP2 = 0.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TLVP1 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real THVP1 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real THVP2 = 0.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real THVP3 = 0.3 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real ULVP3 = 0.80 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real ULVP2 = 0.85 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real ULVP1 = 0.90 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real UHVP1 = 1.1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real UHVP2 = 1.15 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real UHVP3 = 1.2 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUProtection[:, :] = [0, TLVP3; ULVP3 - 0.001, TLVP3; ULVP3, TLVP2; ULVP2 - 0.001, TLVP2; ULVP2, TLVP1; ULVP1 - 0.001, TLVP1; ULVP1, Modelica.Constants.inf; UHVP1, Modelica.Constants.inf; UHVP1 + 0.001, THVP1; UHVP2, THVP1; UHVP2 + 0.001, THVP2; UHVP3, THVP2; UHVP3 + 0.001, THVP3; 1000, THVP3] "Disconnection time versus over voltage lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  // Frequency protection table parameters
  parameter Real TLfP3 = 0.25 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TLfP2 = 0.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TLfP1 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real THfP1 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real THfP2 = 0.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real THfP3 = 0.25 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real fLfP3 = 0.98 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real fLfP2 = 0.99 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real fLfP1 = 0.996 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real fHfP1 = 1.004 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real fHfP2 = 1.01 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real fHfP3 = 1.02 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletfProtection[:, :] = [0, TLfP3; fLfP3 - 0.001, TLfP3; fLfP3, TLfP2; fLfP2 - 0.001, TLfP2; fLfP2, TLfP1; fLfP1 - 0.001, TLfP1; fLfP1, Modelica.Constants.inf; fHfP1, Modelica.Constants.inf; fHfP1 + 0.001, THfP1; fHfP2, THfP1; fHfP2 + 0.001, THfP2; fHfP3, THfP2; fHfP3 + 0.001, THfP3; 1000, THfP3] "Disconnection time versus over voltage lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  // Derivatives parameters
  parameter Real DerfMaxPu = 0.02 annotation(
    Dialog(tab = "Protection"));
  parameter Real TDerfMax = 0.5 annotation(
    Dialog(tab = "Protection"));
  parameter Real DerThetaMax = 1 annotation(
    Dialog(tab = "Protection"));
  parameter Real TDerThetaMax = 0.5 annotation(
    Dialog(tab = "Protection"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Measured (and filtered) voltage component" annotation(
    Placement(visible = true, transformation(origin = {-220, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-239, 161}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput fMeasPu(start = 1) "Measured frequency outputted by the phase-locked loop" annotation(
    Placement(visible = true, transformation(origin = {-220, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-239, -1}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = UPhase0) "Phase angle outputted by phase-locked loop" annotation(
    Placement(visible = true, transformation(origin = {-220, -320}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-239, -159}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.BooleanOutput tripFlag(start = false) annotation(
    Placement(visible = true, transformation(origin = {220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {240, 0}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));

  //Initial parameters
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.Angle UPhase0 "Initial Phase angle outputted by phase-locked loop" annotation(
    Dialog(group = "Operating point"));

  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-10, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {110, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(visible = true, transformation(origin = {-70, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = UHVP1) annotation(
    Placement(visible = true, transformation(origin = {-130, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = UHVP2) annotation(
    Placement(visible = true, transformation(origin = {-130, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual2 annotation(
    Placement(visible = true, transformation(origin = {-70, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer2 annotation(
    Placement(visible = true, transformation(origin = {-10, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = UHVP3) annotation(
    Placement(visible = true, transformation(origin = {-130, 320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual3 annotation(
    Placement(visible = true, transformation(origin = {-70, 320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer3 annotation(
    Placement(visible = true, transformation(origin = {-10, 320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(visible = true, transformation(origin = {110, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater2 annotation(
    Placement(visible = true, transformation(origin = {110, 320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = THVP2) annotation(
    Placement(visible = true, transformation(origin = {50, 260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = THVP1) annotation(
    Placement(visible = true, transformation(origin = {50, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or or1(nu = 14) annotation(
    Placement(visible = true, transformation(origin = {170, 1.77636e-15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = ULVP1) annotation(
    Placement(visible = true, transformation(origin = {-130, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual1 annotation(
    Placement(visible = true, transformation(origin = {-70, 168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual4 annotation(
    Placement(visible = true, transformation(origin = {-70, 128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = ULVP2) annotation(
    Placement(visible = true, transformation(origin = {-130, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = ULVP3) annotation(
    Placement(visible = true, transformation(origin = {-130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual5 annotation(
    Placement(visible = true, transformation(origin = {-70, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(visible = true, transformation(origin = {-10, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer4 annotation(
    Placement(visible = true, transformation(origin = {-10, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer5 annotation(
    Placement(visible = true, transformation(origin = {-10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(limitsAtInit = true, uMax = TLVP1) annotation(
    Placement(visible = true, transformation(origin = {50, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(limitsAtInit = true, uMax = TLVP2) annotation(
    Placement(visible = true, transformation(origin = {50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual6 annotation(
    Placement(visible = true, transformation(origin = {110, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual7 annotation(
    Placement(visible = true, transformation(origin = {112, 128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual8 annotation(
    Placement(visible = true, transformation(origin = {110, 168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TabletUProtection) annotation(
    Placement(visible = true, transformation(origin = {-40, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual9 annotation(
    Placement(visible = true, transformation(origin = {110, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer6 annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual10 annotation(
    Placement(visible = true, transformation(origin = {-70, -212}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual11 annotation(
    Placement(visible = true, transformation(origin = {110, -212}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual12 annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = TabletfProtection) annotation(
    Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual13 annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = fLfP2) annotation(
    Placement(visible = true, transformation(origin = {-130, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater3 annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = fLfP1) annotation(
    Placement(visible = true, transformation(origin = {-130, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer7 annotation(
    Placement(visible = true, transformation(origin = {-10, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k = fHfP1) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual14 annotation(
    Placement(visible = true, transformation(origin = {-70, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant4(k = fHfP3) annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual15 annotation(
    Placement(visible = true, transformation(origin = {110, -132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer8 annotation(
    Placement(visible = true, transformation(origin = {-10, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter4(limitsAtInit = true, uMax = THfP1) annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer9 annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant5(k = fLfP3) annotation(
    Placement(visible = true, transformation(origin = {-130, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer10 annotation(
    Placement(visible = true, transformation(origin = {-10, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant6(k = fHfP2) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater4 annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater5 annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter5(limitsAtInit = true, uMax = TLfP1) annotation(
    Placement(visible = true, transformation(origin = {50, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual16 annotation(
    Placement(visible = true, transformation(origin = {-70, -132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter6(limitsAtInit = true, uMax = TLfP2) annotation(
    Placement(visible = true, transformation(origin = {50, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter7(limitsAtInit = true, uMax = THfP2) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual17 annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer11 annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer12 annotation(
    Placement(visible = true, transformation(origin = {-10, -280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual18 annotation(
    Placement(visible = true, transformation(origin = {-70, -272}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant7(k = DerfMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-130, -260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual19 annotation(
    Placement(visible = true, transformation(origin = {110, -272}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const6(k = TDerfMax) annotation(
    Placement(visible = true, transformation(origin = {50, -260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant8(k = DerThetaMax) annotation(
    Placement(visible = true, transformation(origin = {-130, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual20 annotation(
    Placement(visible = true, transformation(origin = {110, -312}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual21 annotation(
    Placement(visible = true, transformation(origin = {-70, -312}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant9(k = TDerThetaMax) annotation(
    Placement(visible = true, transformation(origin = {50, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer13 annotation(
    Placement(visible = true, transformation(origin = {-10, -320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative1 annotation(
    Placement(visible = true, transformation(origin = {-160, -320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative annotation(
    Placement(visible = true, transformation(origin = {-160, -280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  when or1.y == true then
    tripFlag = true;
  end when;

  connect(lessEqual.y, timer.u) annotation(
    Line(points = {{-59, 240}, {-22, 240}}, color = {255, 0, 255}));
  connect(const.y, lessEqual.u1) annotation(
    Line(points = {{-119, 240}, {-82, 240}}, color = {0, 0, 127}));
  connect(const3.y, lessEqual3.u1) annotation(
    Line(points = {{-119, 320}, {-82, 320}}, color = {0, 0, 127}));
  connect(const2.y, lessEqual2.u1) annotation(
    Line(points = {{-119, 280}, {-82, 280}}, color = {0, 0, 127}));
  connect(lessEqual3.y, timer3.u) annotation(
    Line(points = {{-59, 320}, {-22, 320}}, color = {255, 0, 255}));
  connect(lessEqual2.y, timer2.u) annotation(
    Line(points = {{-59, 280}, {-22, 280}}, color = {255, 0, 255}));
  connect(timer3.y, greater2.u1) annotation(
    Line(points = {{1, 320}, {98, 320}}, color = {0, 0, 127}));
  connect(timer2.y, greater1.u1) annotation(
    Line(points = {{1, 280}, {98, 280}}, color = {0, 0, 127}));
  connect(timer.y, greater.u1) annotation(
    Line(points = {{1, 240}, {98, 240}}, color = {0, 0, 127}));
  connect(limiter.y, greater1.u2) annotation(
    Line(points = {{61, 260}, {79.5, 260}, {79.5, 272}, {98, 272}}, color = {0, 0, 127}));
  connect(limiter1.y, greater.u2) annotation(
    Line(points = {{61, 220}, {79.5, 220}, {79.5, 232}, {98, 232}}, color = {0, 0, 127}));
  connect(const5.y, lessEqual5.u2) annotation(
    Line(points = {{-119, 80}, {-82, 80}}, color = {0, 0, 127}));
  connect(limiter2.y, lessEqual8.u1) annotation(
    Line(points = {{61, 180}, {79.5, 180}, {79.5, 168}, {98, 168}}, color = {0, 0, 127}));
  connect(limiter3.y, lessEqual7.u1) annotation(
    Line(points = {{61, 140}, {79.5, 140}, {79.5, 128}, {100, 128}}, color = {0, 0, 127}));
  connect(constant1.y, lessEqual14.u2) annotation(
    Line(points = {{-119, -180}, {-82, -180}}, color = {0, 0, 127}));
  connect(limiter7.y, greater3.u2) annotation(
    Line(points = {{61, -40}, {77.5, -40}, {77.5, -28}, {98, -28}}, color = {0, 0, 127}));
  connect(constant5.y, lessEqual10.u2) annotation(
    Line(points = {{-119, -220}, {-82, -220}}, color = {0, 0, 127}));
  connect(timer6.y, greater5.u1) annotation(
    Line(points = {{1, 20}, {98, 20}}, color = {0, 0, 127}));
  connect(constant6.y, lessEqual17.u1) annotation(
    Line(points = {{-119, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(timer7.y, lessEqual9.u2) annotation(
    Line(points = {{1, -180}, {98, -180}}, color = {0, 0, 127}));
  connect(lessEqual10.y, timer8.u) annotation(
    Line(points = {{-59, -212}, {-40.5, -212}, {-40.5, -220}, {-22, -220}}, color = {255, 0, 255}));
  connect(lessEqual12.y, timer11.u) annotation(
    Line(points = {{-59, -60}, {-22, -60}}, color = {255, 0, 255}));
  connect(lessEqual14.y, timer7.u) annotation(
    Line(points = {{-59, -172}, {-40.5, -172}, {-40.5, -180}, {-22, -180}}, color = {255, 0, 255}));
  connect(timer8.y, lessEqual11.u2) annotation(
    Line(points = {{1, -220}, {98, -220}}, color = {0, 0, 127}));
  connect(timer11.y, greater4.u1) annotation(
    Line(points = {{1, -60}, {98, -60}}, color = {0, 0, 127}));
  connect(timer9.y, greater3.u1) annotation(
    Line(points = {{1, -20}, {98, -20}}, color = {0, 0, 127}));
  connect(lessEqual17.y, timer9.u) annotation(
    Line(points = {{-59, -20}, {-22, -20}}, color = {255, 0, 255}));
  connect(constant3.y, lessEqual12.u1) annotation(
    Line(points = {{-119, -60}, {-82, -60}}, color = {0, 0, 127}));
  connect(limiter6.y, lessEqual9.u1) annotation(
    Line(points = {{61, -160}, {77.5, -160}, {77.5, -172}, {98, -172}}, color = {0, 0, 127}));
  connect(constant2.y, lessEqual16.u2) annotation(
    Line(points = {{-119, -140}, {-82, -140}}, color = {0, 0, 127}));
  connect(limiter4.y, greater4.u2) annotation(
    Line(points = {{61, -80}, {79.5, -80}, {79.5, -68}, {98, -68}}, color = {0, 0, 127}));
  connect(limiter5.y, lessEqual15.u1) annotation(
    Line(points = {{61, -120}, {76.5, -120}, {76.5, -132}, {98, -132}}, color = {0, 0, 127}));
  connect(lessEqual16.y, timer10.u) annotation(
    Line(points = {{-59, -132}, {-40.5, -132}, {-40.5, -140}, {-22, -140}}, color = {255, 0, 255}));
  connect(lessEqual13.y, timer6.u) annotation(
    Line(points = {{-59, 20}, {-22, 20}}, color = {255, 0, 255}));
  connect(constant4.y, lessEqual13.u1) annotation(
    Line(points = {{-119, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(timer10.y, lessEqual15.u2) annotation(
    Line(points = {{1, -140}, {98, -140}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], greater2.u2) annotation(
    Line(points = {{-29, 200}, {20, 200}, {20, 312}, {98, 312}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], limiter.u) annotation(
    Line(points = {{-29, 200}, {20, 200}, {20, 260}, {38, 260}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], limiter1.u) annotation(
    Line(points = {{-29, 200}, {20, 200}, {20, 220}, {38, 220}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], limiter2.u) annotation(
    Line(points = {{-29, 200}, {20, 200}, {20, 180}, {38, 180}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], limiter3.u) annotation(
    Line(points = {{-29, 200}, {20, 200}, {20, 140}, {38, 140}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], lessEqual6.u1) annotation(
    Line(points = {{-29, 200}, {20, 200}, {20, 88}, {98, 88}}, color = {0, 0, 127}));
  connect(timer1.y, lessEqual8.u2) annotation(
    Line(points = {{1, 160}, {98, 160}}, color = {0, 0, 127}));
  connect(timer4.y, lessEqual7.u2) annotation(
    Line(points = {{1, 120}, {100, 120}}, color = {0, 0, 127}));
  connect(timer5.y, lessEqual6.u2) annotation(
    Line(points = {{1, 80}, {98, 80}}, color = {0, 0, 127}));
  connect(uMeasPu, combiTable1Ds.u) annotation(
    Line(points = {{-220, 200}, {-52, 200}}, color = {0, 0, 127}));
  connect(fMeasPu, combiTable1Ds1.u) annotation(
    Line(points = {{-220, -100}, {-52, -100}}, color = {0, 0, 127}));
  connect(const1.y, lessEqual1.u2) annotation(
    Line(points = {{-119, 160}, {-83, 160}}, color = {0, 0, 127}));
  connect(lessEqual4.y, timer4.u) annotation(
    Line(points = {{-59, 128}, {-41, 128}, {-41, 120}, {-23, 120}}, color = {255, 0, 255}));
  connect(lessEqual1.y, timer1.u) annotation(
    Line(points = {{-59, 168}, {-40, 168}, {-40, 160}, {-22, 160}}, color = {255, 0, 255}));
  connect(lessEqual5.y, timer5.u) annotation(
    Line(points = {{-59, 88}, {-41, 88}, {-41, 80}, {-23, 80}}, color = {255, 0, 255}));
  connect(const4.y, lessEqual4.u2) annotation(
    Line(points = {{-119, 120}, {-83, 120}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], limiter7.u) annotation(
    Line(points = {{-29, -100}, {19, -100}, {19, -40}, {37, -40}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], limiter4.u) annotation(
    Line(points = {{-29, -100}, {19, -100}, {19, -80}, {37, -80}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], limiter5.u) annotation(
    Line(points = {{-29, -100}, {19, -100}, {19, -120}, {37, -120}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], limiter6.u) annotation(
    Line(points = {{-29, -100}, {19, -100}, {19, -160}, {37, -160}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], greater5.u2) annotation(
    Line(points = {{-29, -100}, {19, -100}, {19, 12}, {97, 12}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], lessEqual11.u1) annotation(
    Line(points = {{-29, -100}, {19, -100}, {19, -212}, {97, -212}}, color = {0, 0, 127}));
  connect(thetaPLL, derivative1.u) annotation(
    Line(points = {{-220, -320}, {-172, -320}}, color = {0, 0, 127}));
  connect(derivative1.y, lessEqual21.u2) annotation(
    Line(points = {{-149, -320}, {-82, -320}}, color = {0, 0, 127}));
  connect(lessEqual21.y, timer13.u) annotation(
    Line(points = {{-59, -312}, {-41, -312}, {-41, -320}, {-23, -320}}, color = {255, 0, 255}));
  connect(timer13.y, lessEqual20.u2) annotation(
    Line(points = {{1, -320}, {97, -320}}, color = {0, 0, 127}));
  connect(derivative.y, lessEqual18.u2) annotation(
    Line(points = {{-149, -280}, {-82, -280}}, color = {0, 0, 127}));
  connect(timer12.y, lessEqual19.u2) annotation(
    Line(points = {{1, -280}, {97, -280}}, color = {0, 0, 127}));
  connect(const6.y, lessEqual19.u1) annotation(
    Line(points = {{61, -260}, {79, -260}, {79, -272}, {97, -272}}, color = {0, 0, 127}));
  connect(constant9.y, lessEqual20.u1) annotation(
    Line(points = {{61, -300}, {79, -300}, {79, -312}, {97, -312}}, color = {0, 0, 127}));
  connect(constant8.y, lessEqual21.u1) annotation(
    Line(points = {{-119, -300}, {-101, -300}, {-101, -312}, {-83, -312}}, color = {0, 0, 127}));
  connect(constant7.y, lessEqual18.u1) annotation(
    Line(points = {{-119, -260}, {-101, -260}, {-101, -272}, {-83, -272}}, color = {0, 0, 127}));
  connect(fMeasPu, derivative.u) annotation(
    Line(points = {{-220, -100}, {-180, -100}, {-180, -280}, {-172, -280}}, color = {0, 0, 127}));
  connect(lessEqual18.y, timer12.u) annotation(
    Line(points = {{-59, -272}, {-41, -272}, {-41, -280}, {-23, -280}}, color = {255, 0, 255}));
  connect(greater2.y, or1.u[1]) annotation(
    Line(points = {{122, 320}, {140, 320}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(greater5.y, or1.u[2]) annotation(
    Line(points = {{122, 20}, {140, 20}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(greater3.y, or1.u[3]) annotation(
    Line(points = {{122, -20}, {140, -20}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(greater4.y, or1.u[4]) annotation(
    Line(points = {{122, -60}, {140, -60}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(lessEqual15.y, or1.u[5]) annotation(
    Line(points = {{122, -132}, {140, -132}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(lessEqual9.y, or1.u[6]) annotation(
    Line(points = {{122, -172}, {140, -172}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(lessEqual11.y, or1.u[7]) annotation(
    Line(points = {{122, -212}, {140, -212}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(lessEqual19.y, or1.u[8]) annotation(
    Line(points = {{122, -272}, {140, -272}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(lessEqual20.y, or1.u[9]) annotation(
    Line(points = {{122, -312}, {140, -312}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(greater1.y, or1.u[10]) annotation(
    Line(points = {{122, 280}, {140, 280}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(greater.y, or1.u[11]) annotation(
    Line(points = {{122, 240}, {140, 240}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(lessEqual8.y, or1.u[12]) annotation(
    Line(points = {{122, 168}, {140, 168}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(lessEqual7.y, or1.u[13]) annotation(
    Line(points = {{124, 128}, {140, 128}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(lessEqual6.y, or1.u[14]) annotation(
    Line(points = {{122, 88}, {140, 88}, {140, 0}, {160, 0}}, color = {255, 0, 255}));
  connect(fMeasPu, lessEqual13.u2) annotation(
    Line(points = {{-220, -100}, {-100, -100}, {-100, 12}, {-82, 12}}, color = {0, 0, 127}));
  connect(fMeasPu, lessEqual17.u2) annotation(
    Line(points = {{-220, -100}, {-100, -100}, {-100, -28}, {-82, -28}}, color = {0, 0, 127}));
  connect(fMeasPu, lessEqual12.u2) annotation(
    Line(points = {{-220, -100}, {-100, -100}, {-100, -68}, {-82, -68}}, color = {0, 0, 127}));
  connect(fMeasPu, lessEqual16.u1) annotation(
    Line(points = {{-220, -100}, {-100, -100}, {-100, -132}, {-82, -132}}, color = {0, 0, 127}));
  connect(fMeasPu, lessEqual14.u1) annotation(
    Line(points = {{-220, -100}, {-100, -100}, {-100, -172}, {-82, -172}}, color = {0, 0, 127}));
  connect(fMeasPu, lessEqual10.u1) annotation(
    Line(points = {{-220, -100}, {-100, -100}, {-100, -212}, {-82, -212}}, color = {0, 0, 127}));
  connect(uMeasPu, lessEqual3.u2) annotation(
    Line(points = {{-220, 200}, {-100, 200}, {-100, 312}, {-82, 312}}, color = {0, 0, 127}));
  connect(uMeasPu, lessEqual2.u2) annotation(
    Line(points = {{-220, 200}, {-100, 200}, {-100, 272}, {-82, 272}}, color = {0, 0, 127}));
  connect(uMeasPu, lessEqual.u2) annotation(
    Line(points = {{-220, 200}, {-100, 200}, {-100, 232}, {-82, 232}}, color = {0, 0, 127}));
  connect(uMeasPu, lessEqual1.u1) annotation(
    Line(points = {{-220, 200}, {-100, 200}, {-100, 168}, {-82, 168}}, color = {0, 0, 127}));
  connect(uMeasPu, lessEqual4.u1) annotation(
    Line(points = {{-220, 200}, {-100, 200}, {-100, 128}, {-82, 128}}, color = {0, 0, 127}));
  connect(uMeasPu, lessEqual5.u1) annotation(
    Line(points = {{-220, 200}, {-100, 200}, {-100, 88}, {-82, 88}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-200, -340}, {200, 340}})),
    Icon(graphics = {Rectangle(extent = {{-200, 340}, {200, -340}}), Text(origin = {-1, 0}, extent = {{-197, 340}, {197, -340}}, textString = "Protection")}, coordinateSystem(extent = {{-200, -340}, {200, 340}})));
end Protection;
