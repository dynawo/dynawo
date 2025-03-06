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

model FFR "Fast frequency response (IEC 63406)"

  //Parameters
  parameter String InertialTableName "Name given to the inertial table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit f0Pu "Frequency setpoint for FFR control in pu (base nominal frequency)" annotation(
    Dialog(tab = "FFR"));
  parameter String FFRTableName "Name given to the FFR table in the table file" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit fThresholdPu "Deadband threshold for FFR response in pu (base nominal frequency)" annotation(
    Dialog(tab = "FFR"));
  parameter Boolean FFRflag "1 to enable the fast frequency response, 0 to disable the fast frequency response" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit PffrMaxPu "Maximum active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter Types.PerUnit PffrMinPu "Maximum absorbing active power utilized for FFR control in pu (base SNom)" annotation(
    Dialog(tab = "FFR"));
  parameter String TableFileName "Name given to the general file containing all tables" annotation(
    Dialog(tab = "General"));
  parameter Types.Time Trocof "Time constant for frequency differential operation" annotation(
    Dialog(tab = "FFR"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput fMeasPu(start = 1) "Measured frequency outputted by the phase-locked loop  in pu (base nominal frequency in Hz)" annotation(
    Placement(visible = true, transformation(origin = {-140, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput pFFRPu(start = 0) "Active power in pu (base SNom) added to the main order due to the Fast Frequency Response" annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.DeadZone deadZone(deadZoneAtInit = true, uMax = fThresholdPu, uMin = -fThresholdPu) annotation(
    Placement(visible = true, transformation(origin = {-66, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = false, uMax = PffrMaxPu, uMin = PffrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-6, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {30, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression annotation(
    Placement(visible = true, transformation(origin = {62, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanEntry(y = FFRflag) annotation(
    Placement(visible = true, transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = PffrMaxPu, uMin = PffrMinPu) annotation(
    Placement(visible = true, transformation(origin = {62, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-98, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = f0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone1(deadZoneAtInit = true, uMax = fThresholdPu, uMin = -fThresholdPu) annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(limitsAtInit = true, uMax = PffrMaxPu, uMin = PffrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-14, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds inertialCombiTable(fileName = TableFileName, tableName = InertialTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-36, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds FFRCombiTable(fileName = TableFileName, tableName = FFRTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-42, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = Trocof, initType = Modelica.Blocks.Types.Init.NoInit, k = Trocof, x_start = 0, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-96, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(booleanEntry.y, switch1.u2) annotation(
    Line(points = {{73, 0}, {90, 0}}, color = {255, 0, 255}));
  connect(limiter.y, add.u1) annotation(
    Line(points = {{5, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(switch1.y, pFFRPu) annotation(
    Line(points = {{113, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(fMeasPu, add1.u1) annotation(
    Line(points = {{-140, 40}, {-114, 40}, {-114, -14}, {-110, -14}}, color = {0, 0, 127}));
  connect(realExpression1.y, add1.u2) annotation(
    Line(points = {{-119, -26}, {-110, -26}}, color = {0, 0, 127}));
  connect(add1.y, deadZone1.u) annotation(
    Line(points = {{-87, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(deadZone.y, inertialCombiTable.u) annotation(
    Line(points = {{-55, 40}, {-48, 40}}, color = {0, 0, 127}));
  connect(inertialCombiTable.y[1], limiter.u) annotation(
    Line(points = {{-25, 40}, {-18, 40}}, color = {0, 0, 127}));
  connect(deadZone1.y, FFRCombiTable.u) annotation(
    Line(points = {{-59, -20}, {-54, -20}}, color = {0, 0, 127}));
  connect(FFRCombiTable.y[1], limiter2.u) annotation(
    Line(points = {{-31, -20}, {-26, -20}}, color = {0, 0, 127}));
  connect(realExpression.y, switch1.u3) annotation(
    Line(points = {{74, -20}, {80, -20}, {80, -8}, {90, -8}}, color = {0, 0, 127}));
  connect(limiter1.y, switch1.u1) annotation(
    Line(points = {{74, 34}, {80, 34}, {80, 8}, {90, 8}}, color = {0, 0, 127}));
  connect(limiter2.y, add.u2) annotation(
    Line(points = {{-2, -20}, {12, -20}, {12, 28}, {18, 28}}, color = {0, 0, 127}));
  connect(add.y, limiter1.u) annotation(
    Line(points = {{41, 34}, {50, 34}}, color = {0, 0, 127}));
  connect(derivative.y, deadZone.u) annotation(
    Line(points = {{-85, 40}, {-78, 40}}, color = {0, 0, 127}));
  connect(fMeasPu, derivative.u) annotation(
    Line(points = {{-140, 40}, {-108, 40}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(extent = {{-92, 52}, {92, -52}}, textString = "FFR"), Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(extent = {{-120, -100}, {120, 100}})),
    Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})));
end FFR;
