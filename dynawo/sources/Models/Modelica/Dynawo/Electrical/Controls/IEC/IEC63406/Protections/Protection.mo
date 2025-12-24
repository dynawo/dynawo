within Dynawo.Electrical.Controls.IEC.IEC63406.Protections;

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

model Protection "Protection module (IEC63406)"

  // Voltage protection parameters
  parameter Types.Time TLVP3 "Disconnection time for high voltage level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time TLVP2 "Disconnection time for high voltage level 2" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time TLVP1 "Disconnection time for high voltage level 1" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time THVP1 "Disconnection time for low voltage level 1" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time THVP2 "Disconnection time for low voltage level 2" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time THVP3 "Disconnection time for low voltage level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Types.VoltageModulePu ULVP3 "Low voltage level 3 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.VoltageModulePu ULVP2 "Low voltage level 2 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.VoltageModulePu ULVP1 "Low voltage level 1 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.VoltageModulePu UHVP1 "High voltage level 1 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.VoltageModulePu UHVP2 "High voltage level 2 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.VoltageModulePu UHVP3 "High voltage level 3 in pu (base UNom)" annotation(
    Dialog(tab = "Protection"));

  // Frequency protection parameters
  parameter Types.Frequency fLfP3 "Low frequency level 3 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Frequency fLfP2 "Low frequency level 2 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Frequency fLfP1 "Low frequency level 1 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Frequency fHfP1 "High frequency level 1 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Frequency fHfP2 "High frequency level 2 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Frequency fHfP3 "High frequency level 3 in pu (base nominal frequency)" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time TLfP3 "Disconnection time for low frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time TLfP2 "Disconnection time for low frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time TLfP1 "Disconnection time for low frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time THfP1 "Disconnection time for high frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time THfP2 "Disconnection time for high frequency level 3" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time THfP3 "Disconnection time for high frequency level 3" annotation(
    Dialog(tab = "Protection"));

  // Other protection parameters
  parameter Real DerfMaxPu "Maximum level of frequency variation in pu (base nominal frequency per second)" annotation(
    Dialog(tab = "Protection"));
  parameter Real DerThetaMax "Maximum level of angle variation in rad/s" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time TDerfMax "Disconnection time for high level of frequency variation" annotation(
    Dialog(tab = "Protection"));
  parameter Types.Time TDerThetaMax "Disconnection time for high level of angle variation" annotation(
    Dialog(tab = "Protection"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput fMeasPu(start = 1) "Measured frequency outputted by the phase-locked loop in pu (base fNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-239, -1}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = UPhase0) "Phase angle outputted by phase-locked loop (in rad)" annotation(
    Placement(visible = true, transformation(origin = {-220, -320}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-239, -159}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-239, 161}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.BooleanOutput tripFlag(start = false) "Disconnection flag (0 if unit is connected to the network, else 1)" annotation(
    Placement(visible = true, transformation(origin = {220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {240, 0}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));

  //Initial parameters
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.Angle UPhase0 "Initial Phase angle outputted by phase-locked loop (in rad)" annotation(
    Dialog(group = "Operating point"));

  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-10, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {110, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(visible = true, transformation(origin = {-70, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual2 annotation(
    Placement(visible = true, transformation(origin = {-70, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer2 annotation(
    Placement(visible = true, transformation(origin = {-10, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual3 annotation(
    Placement(visible = true, transformation(origin = {-70, 320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer3 annotation(
    Placement(visible = true, transformation(origin = {-10, 320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(visible = true, transformation(origin = {110, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater2 annotation(
    Placement(visible = true, transformation(origin = {110, 320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or or1(nu = 14) annotation(
    Placement(visible = true, transformation(origin = {170, 1.77636e-15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual1 annotation(
    Placement(visible = true, transformation(origin = {-70, 168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual4 annotation(
    Placement(visible = true, transformation(origin = {-70, 128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual5 annotation(
    Placement(visible = true, transformation(origin = {-70, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(visible = true, transformation(origin = {-10, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer4 annotation(
    Placement(visible = true, transformation(origin = {-10, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer5 annotation(
    Placement(visible = true, transformation(origin = {-10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual6 annotation(
    Placement(visible = true, transformation(origin = {110, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual7 annotation(
    Placement(visible = true, transformation(origin = {112, 128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual8 annotation(
    Placement(visible = true, transformation(origin = {110, 168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Modelica.Blocks.Logical.LessEqual lessEqual13 annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater3 annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer7 annotation(
    Placement(visible = true, transformation(origin = {-10, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual14 annotation(
    Placement(visible = true, transformation(origin = {-70, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual15 annotation(
    Placement(visible = true, transformation(origin = {110, -132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer8 annotation(
    Placement(visible = true, transformation(origin = {-10, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer9 annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer10 annotation(
    Placement(visible = true, transformation(origin = {-10, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater4 annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater5 annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual16 annotation(
    Placement(visible = true, transformation(origin = {-70, -132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Modelica.Blocks.Sources.RealExpression realExpression(y = THVP1)  annotation(
    Placement(visible = true, transformation(origin = {50, 232}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = THVP2) annotation(
    Placement(visible = true, transformation(origin = {50, 272}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = THVP3) annotation(
    Placement(visible = true, transformation(origin = {50, 312}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = TLVP1) annotation(
    Placement(visible = true, transformation(origin = {50, 168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression4(y = TLVP2) annotation(
    Placement(visible = true, transformation(origin = {50, 128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression5(y = TLVP3) annotation(
    Placement(visible = true, transformation(origin = {50, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression6(y = UHVP3) annotation(
    Placement(visible = true, transformation(origin = {-130, 320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression7(y = UHVP2) annotation(
    Placement(visible = true, transformation(origin = {-130, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression8(y = UHVP1) annotation(
    Placement(visible = true, transformation(origin = {-130, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression9(y = ULVP1) annotation(
    Placement(visible = true, transformation(origin = {-130, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression10(y = ULVP2) annotation(
    Placement(visible = true, transformation(origin = {-130, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression11(y = ULVP3) annotation(
    Placement(visible = true, transformation(origin = {-130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression12(y = fHfP2) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression13(y = fHfP3) annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression14(y = fHfP1) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression15(y = fLfP1) annotation(
    Placement(visible = true, transformation(origin = {-130, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression16(y = fLfP2) annotation(
    Placement(visible = true, transformation(origin = {-130, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression17(y = fLfP3) annotation(
    Placement(visible = true, transformation(origin = {-130, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression18(y = THfP3) annotation(
    Placement(visible = true, transformation(origin = {50, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression19(y = THfP2) annotation(
    Placement(visible = true, transformation(origin = {50, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression20(y = THfP1) annotation(
    Placement(visible = true, transformation(origin = {50, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression21(y = TLfP1) annotation(
    Placement(visible = true, transformation(origin = {50, -132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression22(y = TLfP2) annotation(
    Placement(visible = true, transformation(origin = {50, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression23(y = TLfP3) annotation(
    Placement(visible = true, transformation(origin = {50, -212}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
//  when or1.y == true then
//    tripFlag = true;
//  end when;

  connect(lessEqual.y, timer.u) annotation(
    Line(points = {{-59, 240}, {-22, 240}}, color = {255, 0, 255}));
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
  connect(timer6.y, greater5.u1) annotation(
    Line(points = {{1, 20}, {98, 20}}, color = {0, 0, 127}));
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
  connect(lessEqual16.y, timer10.u) annotation(
    Line(points = {{-59, -132}, {-40.5, -132}, {-40.5, -140}, {-22, -140}}, color = {255, 0, 255}));
  connect(lessEqual13.y, timer6.u) annotation(
    Line(points = {{-59, 20}, {-22, 20}}, color = {255, 0, 255}));
  connect(timer10.y, lessEqual15.u2) annotation(
    Line(points = {{1, -140}, {98, -140}}, color = {0, 0, 127}));
  connect(timer1.y, lessEqual8.u2) annotation(
    Line(points = {{1, 160}, {98, 160}}, color = {0, 0, 127}));
  connect(timer4.y, lessEqual7.u2) annotation(
    Line(points = {{1, 120}, {100, 120}}, color = {0, 0, 127}));
  connect(timer5.y, lessEqual6.u2) annotation(
    Line(points = {{1, 80}, {98, 80}}, color = {0, 0, 127}));
  connect(lessEqual4.y, timer4.u) annotation(
    Line(points = {{-59, 128}, {-41, 128}, {-41, 120}, {-23, 120}}, color = {255, 0, 255}));
  connect(lessEqual1.y, timer1.u) annotation(
    Line(points = {{-59, 168}, {-40, 168}, {-40, 160}, {-22, 160}}, color = {255, 0, 255}));
  connect(lessEqual5.y, timer5.u) annotation(
    Line(points = {{-59, 88}, {-41, 88}, {-41, 80}, {-23, 80}}, color = {255, 0, 255}));
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
  connect(realExpression.y, greater.u2) annotation(
    Line(points = {{61, 232}, {98, 232}}, color = {0, 0, 127}));
  connect(realExpression1.y, greater1.u2) annotation(
    Line(points = {{62, 272}, {98, 272}}, color = {0, 0, 127}));
  connect(realExpression2.y, greater2.u2) annotation(
    Line(points = {{62, 312}, {98, 312}}, color = {0, 0, 127}));
  connect(realExpression3.y, lessEqual8.u1) annotation(
    Line(points = {{62, 168}, {98, 168}}, color = {0, 0, 127}));
  connect(realExpression4.y, lessEqual7.u1) annotation(
    Line(points = {{62, 128}, {100, 128}}, color = {0, 0, 127}));
  connect(realExpression5.y, lessEqual6.u1) annotation(
    Line(points = {{62, 88}, {98, 88}}, color = {0, 0, 127}));
  connect(realExpression6.y, lessEqual3.u1) annotation(
    Line(points = {{-118, 320}, {-82, 320}}, color = {0, 0, 127}));
  connect(realExpression7.y, lessEqual2.u1) annotation(
    Line(points = {{-118, 280}, {-82, 280}}, color = {0, 0, 127}));
  connect(realExpression8.y, lessEqual.u1) annotation(
    Line(points = {{-118, 240}, {-82, 240}}, color = {0, 0, 127}));
  connect(realExpression9.y, lessEqual1.u2) annotation(
    Line(points = {{-118, 160}, {-82, 160}}, color = {0, 0, 127}));
  connect(realExpression10.y, lessEqual4.u2) annotation(
    Line(points = {{-118, 120}, {-82, 120}}, color = {0, 0, 127}));
  connect(realExpression11.y, lessEqual5.u2) annotation(
    Line(points = {{-118, 80}, {-82, 80}}, color = {0, 0, 127}));
  connect(realExpression13.y, lessEqual13.u1) annotation(
    Line(points = {{-118, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(realExpression12.y, lessEqual17.u1) annotation(
    Line(points = {{-118, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(realExpression14.y, lessEqual12.u1) annotation(
    Line(points = {{-118, -60}, {-82, -60}}, color = {0, 0, 127}));
  connect(realExpression15.y, lessEqual16.u2) annotation(
    Line(points = {{-118, -140}, {-82, -140}}, color = {0, 0, 127}));
  connect(realExpression16.y, lessEqual14.u2) annotation(
    Line(points = {{-118, -180}, {-82, -180}}, color = {0, 0, 127}));
  connect(realExpression17.y, lessEqual10.u2) annotation(
    Line(points = {{-118, -220}, {-82, -220}}, color = {0, 0, 127}));
  connect(realExpression21.y, lessEqual15.u1) annotation(
    Line(points = {{62, -132}, {98, -132}}, color = {0, 0, 127}));
  connect(realExpression22.y, lessEqual9.u1) annotation(
    Line(points = {{62, -172}, {98, -172}}, color = {0, 0, 127}));
  connect(realExpression23.y, lessEqual11.u1) annotation(
    Line(points = {{62, -212}, {98, -212}}, color = {0, 0, 127}));
  connect(realExpression18.y, greater5.u2) annotation(
    Line(points = {{62, 12}, {98, 12}}, color = {0, 0, 127}));
  connect(realExpression19.y, greater3.u2) annotation(
    Line(points = {{62, -28}, {98, -28}}, color = {0, 0, 127}));
  connect(realExpression20.y, greater4.u2) annotation(
    Line(points = {{62, -68}, {98, -68}}, color = {0, 0, 127}));
  connect(or1.y, tripFlag) annotation(
    Line(points = {{182, 0}, {220, 0}}, color = {255, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -340}, {200, 340}})),
    Icon(graphics = {Rectangle(extent = {{-200, 340}, {200, -340}}), Text(origin = {-1, 0}, extent = {{-197, 340}, {197, -340}}, textString = "Protection")}, coordinateSystem(extent = {{-200, -340}, {200, 340}})));
end Protection;
