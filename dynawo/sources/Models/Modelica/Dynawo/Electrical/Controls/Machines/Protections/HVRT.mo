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
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";

  // Tables parameter
  parameter String TablesFile "Disconnection time versus over voltage lookup table for under-voltage";
  parameter String TabletUoverUfilt "Disconnection time versus over voltage lookup table for under-voltage";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput UMonitoredPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-160, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-108, -20}, extent = {{-20, -20}, {20, 20}})));

  // Output variable
  Modelica.Blocks.Interfaces.BooleanOutput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Types.Time tThresholdReached(start = Modelica.Constants.inf) "Time when the threshold is reached in s";

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the machine";
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(tableOnFile = true, tableName = TabletUoverUfilt, fileName = TablesFile, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = tLagAction) annotation(
    Placement(transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder filter(T = tUFilt, y_start = U0Pu)  annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameter
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)";

equation
  when filter.u >= UOverPu and not (pre(switchOffSignal.value)) then
    Timeline.logEvent1(TimelineKeys.HVRTArming);
    tThresholdReached = time;
  elsewhen (not (filter.u >= UOverPu)) and pre(tThresholdReached) <> Modelica.Constants.inf and not (pre(switchOffSignal.value)) then
//illegal access to entryTime variable since protected -> to be changed
    Timeline.logEvent1(TimelineKeys.HVRTDisarming);
    tThresholdReached = Modelica.Constants.inf;
  end when;

  when fOCB then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.HVRTTripped);
  end when;

  when filter.u >= UOverPu then
    timer.u = true;
  end when;

  when combiTable1D.y[1] < timer.y then
    timer1.u = true;
  end when;

  connect(timer1.y, greater1.u1) annotation(
    Line(points = {{81, 0}, {97, 0}}, color = {0, 0, 127}));
  connect(const1.y, greater1.u2) annotation(
    Line(points = {{61, -40}, {85, -40}, {85, -8}, {97, -8}}, color = {0, 0, 127}));
  connect(greater1.y, fOCB) annotation(
    Line(points = {{121, 0}, {149, 0}}, color = {255, 0, 255}));
  connect(UMonitoredPu, filter.u) annotation(
    Line(points = {{-160, -20}, {-122, -20}}, color = {0, 0, 127}));
  connect(filter.y, combiTable1D.u) annotation(
    Line(points = {{-98, -20}, {-42, -20}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end HVRT;
