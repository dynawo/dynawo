within Dynawo.Electrical.Controls.Protections;

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

model HVRT "High-voltage ride-through protection"
  parameter Types.VoltageModulePu UOverPu "Over voltage protection activation threshold in pu (base UNom)";
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";
  parameter String TabletUoverUfilt "Disconnection time versus over voltage lookup table for under-voltage";
  parameter String TablesFile "Disconnection time versus over voltage lookup table for under-voltage";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput UMonitoredPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-108, -20}, extent = {{-20, -20}, {20, 20}})));

  // Output variable
  Modelica.Blocks.Interfaces.BooleanOutput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the machine";
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(tableOnFile = true, tableName = TabletUoverUfilt, fileName = TablesFile) annotation(
    Placement(transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = UOverPu) annotation(
    Placement(transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tUFilt, y_start = U0Pu) annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameter
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)";

equation
  when fOCB then
    switchOffSignal.value = true;
  end when;

  connect(const.y, lessEqual.u1) annotation(
    Line(points = {{-79, 20}, {-42, 20}}, color = {0, 0, 127}));
  connect(lessEqual.y, timer.u) annotation(
    Line(points = {{-19, 20}, {-3, 20}}, color = {255, 0, 255}));
  connect(timer.y, greater.u1) annotation(
    Line(points = {{21, 20}, {39, 20}, {39, 0}, {57, 0}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], greater.u2) annotation(
    Line(points = {{21, -20}, {39, -20}, {39, -8}, {57, -8}}, color = {0, 0, 127}));
  connect(greater.y, fOCB) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {255, 0, 255}));
  connect(UMonitoredPu, firstOrder1.u) annotation(
    Line(points = {{-120, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, lessEqual.u2) annotation(
    Line(points = {{-58, -20}, {-54, -20}, {-54, 12}, {-42, 12}}, color = {0, 0, 127}));
  connect(firstOrder1.y, combiTable1D.u) annotation(
    Line(points = {{-58, -20}, {-2, -20}}, color = {0, 0, 127}));

end HVRT;
