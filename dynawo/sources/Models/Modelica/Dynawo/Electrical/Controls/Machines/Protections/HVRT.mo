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

model HVRT "High-voltage ride-through protection"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.VoltageModulePu UOverPu "Over voltage protection activation threshold in pu (base UNom)";
  parameter Types.Time tLagAction "Time-lag due to the actual tripping action in s";

  // Tables parameter
  parameter String TablesFile "Disconnection time versus over voltage lookup table for under-voltage";
  parameter String TabletUoverUfilt "Disconnection time versus over voltage lookup table for under-voltage";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput UMonitoredPu "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-160, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-108, -20}, extent = {{-20, -20}, {20, 20}})));

  // Output variable
  Modelica.Blocks.Interfaces.BooleanOutput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the machine";
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(tableOnFile = true, tableName = TabletUoverUfilt, fileName = TablesFile, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = UOverPu) annotation(
    Placement(transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = tLagAction) annotation(
    Placement(transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}})));

equation
  when lessEqual.y and not (pre(switchOffSignal.value)) then
    Timeline.logEvent1(TimelineKeys.HVRTArming);
  elsewhen (not lessEqual.y) and pre(timer.entryTime) <> 0 and not (pre(switchOffSignal.value)) then //illegal access to entryTime variable since protected -> to be changed
    Timeline.logEvent1(TimelineKeys.HVRTDisarming);
  end when;

  when fOCB then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.HVRTTripped);
  end when;

  connect(const.y, lessEqual.u1) annotation(
    Line(points = {{-119, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(lessEqual.y, timer.u) annotation(
    Line(points = {{-59, 20}, {-43, 20}}, color = {255, 0, 255}));
  connect(timer.y, greater.u1) annotation(
    Line(points = {{-19, 20}, {-1, 20}, {-1, 0}, {17, 0}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], greater.u2) annotation(
    Line(points = {{-19, -20}, {-1, -20}, {-1, -8}, {17, -8}}, color = {0, 0, 127}));
  connect(UMonitoredPu, combiTable1D.u) annotation(
    Line(points = {{-160, -20}, {-42, -20}}, color = {0, 0, 127}));
  connect(UMonitoredPu, lessEqual.u2) annotation(
    Line(points = {{-160, -20}, {-100, -20}, {-100, 12}, {-82, 12}}, color = {0, 0, 127}));
  connect(greater.y, timer1.u) annotation(
    Line(points = {{41, 0}, {57, 0}}, color = {255, 0, 255}));
  connect(timer1.y, greater1.u1) annotation(
    Line(points = {{81, 0}, {97, 0}}, color = {0, 0, 127}));
  connect(const1.y, greater1.u2) annotation(
    Line(points = {{61, -40}, {85, -40}, {85, -8}, {97, -8}}, color = {0, 0, 127}));
  connect(greater1.y, fOCB) annotation(
    Line(points = {{121, 0}, {149, 0}}, color = {255, 0, 255}));

annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end HVRT;
