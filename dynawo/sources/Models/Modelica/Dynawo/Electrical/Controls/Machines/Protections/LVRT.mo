within Dynawo.Electrical.Controls.Machines.Protections;

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

model LVRT "Low-voltage ride-through protection"
  parameter Types.VoltageModulePu UUnderPu "Under voltage protection activation threshold in pu (base UNom)";
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";

  // Tables parameter
  parameter String TablesFile "Disconnection time versus over voltage lookup table for under-voltage";
  parameter String TabletUunderUfilt "Disconnection time versus over voltage lookup table for under-voltage";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput UMonitoredPu "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-108, -20}, extent = {{-20, -20}, {20, 20}})));

  // Output variable
  Modelica.Blocks.Interfaces.BooleanOutput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the machine";
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(tableOnFile = true, tableName = TabletUunderUfilt, fileName = TablesFile, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = UUnderPu) annotation(
    Placement(transformation(origin = {-90, -28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}})));

equation
  when fOCB then
    switchOffSignal.value = true;
  end when;

  connect(lessEqual.y, timer.u) annotation(
    Line(points = {{-19, -20}, {-3, -20}}, color = {255, 0, 255}));
  connect(combiTable1D.y[1], less.u1) annotation(
    Line(points = {{21, 20}, {39, 20}, {39, 0}, {57, 0}}, color = {0, 0, 127}));
  connect(timer.y, less.u2) annotation(
    Line(points = {{21, -20}, {39, -20}, {39, -8}, {57, -8}}, color = {0, 0, 127}));
  connect(const.y, lessEqual.u2) annotation(
    Line(points = {{-79, -28}, {-42, -28}}, color = {0, 0, 127}));
  connect(less.y, fOCB) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {255, 0, 255}));
  connect(UMonitoredPu, combiTable1D.u) annotation(
    Line(points = {{-120, 20}, {-2, 20}}, color = {0, 0, 127}));
  connect(UMonitoredPu, lessEqual.u1) annotation(
    Line(points = {{-120, 20}, {-60, 20}, {-60, -20}, {-42, -20}}, color = {0, 0, 127}));

end LVRT;
