within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.AcVoltageControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model QRefLim "Function that applies the limitations to QRef"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsQRefLim;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefUQPu(start = Q0Pu) "Raw reference reactive power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput QRefLimPu(start = Q0Pu) "Limited reference reactive power in pu (base SNom) (DC to AC) after applying the diagrams" annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = QOpMaxPu, uMin = QOpMinPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds QPMax(fileName = TablesFile, tableName = QPMaxTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds QPMin(fileName = TablesFile, tableName = QPMinTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds QUMax(fileName = TablesFile, tableName = QUMaxTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds QUMin(fileName = TablesFile, tableName = QUMinTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (DC to AC)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SNom) (DC to AC)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";

equation
  connect(QRefUQPu, limiter.u) annotation(
    Line(points = {{-140, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, QRefLimPu) annotation(
    Line(points = {{101, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(QPMax.y[1], variableLimiter.limit1) annotation(
    Line(points = {{-59, -40}, {-40, -40}, {-40, 8}, {-3, 8}}, color = {0, 0, 127}));
  connect(QPMin.y[1], variableLimiter.limit2) annotation(
    Line(points = {{-59, -80}, {-20, -80}, {-20, -8}, {-3, -8}}, color = {0, 0, 127}));
  connect(QUMax.y[1], variableLimiter1.limit1) annotation(
    Line(points = {{-59, 80}, {60, 80}, {60, 8}, {77, 8}}, color = {0, 0, 127}));
  connect(QUMin.y[1], variableLimiter1.limit2) annotation(
    Line(points = {{-59, 40}, {40, 40}, {40, -8}, {77, -8}}, color = {0, 0, 127}));
  connect(limiter.y, variableLimiter.u) annotation(
    Line(points = {{-59, 0}, {-2, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(variableLimiter.y, variableLimiter1.u) annotation(
    Line(points = {{21, 0}, {77, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(PPu, QPMax.u) annotation(
    Line(points = {{-140, -60}, {-100, -60}, {-100, -40}, {-82, -40}}, color = {0, 0, 127}));
  connect(PPu, QPMin.u) annotation(
    Line(points = {{-140, -60}, {-100, -60}, {-100, -80}, {-82, -80}}, color = {0, 0, 127}));
  connect(UPu, QUMax.u) annotation(
    Line(points = {{-140, 60}, {-100, 60}, {-100, 80}, {-82, 80}}, color = {0, 0, 127}));
  connect(UPu, QUMin.u) annotation(
    Line(points = {{-140, 60}, {-100, 60}, {-100, 40}, {-82, 40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})));
end QRefLim;
