within Dynawo.Electrical.Controls.Machines.Protections;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model LHVRT "High and low voltage ride-through protection"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.Time tLagAction "Time lag due to the actual tripping action in s";
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";
  parameter Types.VoltageModulePu UOverPu "Overvoltage protection activation threshold in pu (base UNom)";
  parameter Types.VoltageModulePu UUnderPu "Undervoltage protection activation threshold in pu (base UNom)";

  // Table parameters
  parameter String TablesFile "Text file that contains the tables for the functions";
  parameter Boolean TablesOnFile "If true, tables are defined on file or in function usertab";
  parameter String TabletUoverUfilt "Name of the lookup table of disconnection time versus voltage for overvoltage";
  parameter String TabletUunderUfilt "Name of the lookup table of disconnection time versus voltage for undervoltage";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput UMonitoredPu(start = UMonitored0Pu) "Monitored voltage amplitude in pu (base UNom)" annotation(
    Placement(transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));

  // Output variable
  Modelica.Blocks.Interfaces.BooleanOutput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(tableName = TabletUoverUfilt, tableOnFile = TablesOnFile, fileName = TablesFile, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqual(threshold = UOverPu) annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D1(tableName = TabletUunderUfilt, tableOnFile = TablesOnFile, fileName = TablesFile, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqual(threshold = UUnderPu) annotation(
    Placement(transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.MathBoolean.Or or1(nu = 3) annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder filter(T = tUFilt, y_start = UMonitored0Pu) annotation(
    Placement(transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Pre pre1 annotation(
    Placement(transformation(origin = {150, -40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Logical.Timer timer2 annotation(
    Placement(transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer3 annotation(
    Placement(transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold greater2(threshold = tLagAction) annotation(
    Placement(transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold greater3(threshold = tLagAction) annotation(
    Placement(transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));

  // Initial parameter
  parameter Types.VoltageModulePu UMonitored0Pu "Initial monitored voltage amplitude in pu (base UNom)";

protected
  // Table objects used in the tripping conditions (same data as combiTable1D and combiTable1D1, whose table objects are protected)
  parameter Modelica.Blocks.Types.ExternalCombiTable1D tableIDHvrt = Modelica.Blocks.Types.ExternalCombiTable1D(
    if combiTable1D.tableOnFile then combiTable1D.tableName else "NoName",
    if combiTable1D.tableOnFile and combiTable1D.fileName <> "NoName" and not Modelica.Utilities.Strings.isEmpty(combiTable1D.fileName) then combiTable1D.fileName else "NoName",
    combiTable1D.table, combiTable1D.columns, combiTable1D.smoothness, combiTable1D.extrapolation, false) "External table object for HVRT";
  parameter Modelica.Blocks.Types.ExternalCombiTable1D tableIDLvrt = Modelica.Blocks.Types.ExternalCombiTable1D(
    if combiTable1D1.tableOnFile then combiTable1D1.tableName else "NoName",
    if combiTable1D1.tableOnFile and combiTable1D1.fileName <> "NoName" and not Modelica.Utilities.Strings.isEmpty(combiTable1D1.fileName) then combiTable1D1.fileName else "NoName",
    combiTable1D1.table, combiTable1D1.columns, combiTable1D1.smoothness, combiTable1D1.extrapolation, false) "External table object for LVRT";

  Types.Time tThresholdReachedHvrt(start = Modelica.Constants.inf) "Time when the HVRT threshold is reached in s";
  Types.Time tThresholdReachedLvrt(start = Modelica.Constants.inf) "Time when the LVRT threshold is reached in s";

equation
  when greaterEqual.y and not(pre1.y) then
    Timeline.logEvent1(TimelineKeys.HVRTArming);
    tThresholdReachedHvrt = time;
    timer.u = true;
  elsewhen not(greaterEqual.y) and pre(tThresholdReachedHvrt) <> Modelica.Constants.inf and not(pre1.y) and not(timer2.u) then
    Timeline.logEvent1(TimelineKeys.HVRTDisarming);
    tThresholdReachedHvrt = Modelica.Constants.inf;
    timer.u = false;
  end when;

  when lessEqual.y and not(pre1.y) then
    Timeline.logEvent1(TimelineKeys.LVRTArming);
    tThresholdReachedLvrt = time;
    timer1.u = true;
  elsewhen not(lessEqual.y) and pre(tThresholdReachedLvrt) <> Modelica.Constants.inf and not(pre1.y) and not(timer3.u) then
    Timeline.logEvent1(TimelineKeys.LVRTDisarming);
    tThresholdReachedLvrt = Modelica.Constants.inf;
    timer1.u = false;
  end when;

  // The tables are evaluated directly on the filtered voltage (state variable) in the conditions:
  // the tables outputs are steep algebraic variables, that may be inconsistent at a root returned by the solver
  when Modelica.Blocks.Tables.Internal.getTable1DValue(tableIDHvrt, 1, filter.y) < timer.y then
    timer2.u = true;
  end when;

  when Modelica.Blocks.Tables.Internal.getTable1DValue(tableIDLvrt, 1, filter.y) < timer1.y then
    timer3.u = true;
  end when;

  when greater2.y and not(pre(fOCB)) then
    Timeline.logEvent1(TimelineKeys.HVRTTripped);
  end when;

  when greater3.y and not(pre(fOCB)) then
    Timeline.logEvent1(TimelineKeys.LVRTTripped);
  end when;

  connect(or1.y, fOCB) annotation(
    Line(points = {{161.5, 0}, {210, 0}}, color = {255, 0, 255}));
  connect(filter.y, greaterEqual.u) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, 60}, {-122, 60}}, color = {0, 0, 127}));
  connect(filter.y, combiTable1D.u) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(filter.y, combiTable1D1.u) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(filter.y, lessEqual.u) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, -60}, {-122, -60}}, color = {0, 0, 127}));
  connect(UMonitoredPu, filter.u) annotation(
    Line(points = {{-220, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(or1.y, pre1.u) annotation(
    Line(points = {{161, 0}, {180, 0}, {180, -40}, {161, -40}}, color = {255, 0, 255}));
  connect(pre1.y, or1.u[3]) annotation(
    Line(points = {{139, -40}, {120, -40}, {120, 0}, {139, 0}}, color = {255, 0, 255}));
  connect(timer2.y, greater2.u) annotation(
    Line(points = {{41, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(timer3.y, greater3.u) annotation(
    Line(points = {{41, -40}, {58, -40}}, color = {0, 0, 127}));
  connect(greater2.y, or1.u[1]) annotation(
    Line(points = {{81, 40}, {100, 40}, {100, 0}, {140, 0}}, color = {255, 0, 255}));
  connect(greater3.y, or1.u[2]) annotation(
    Line(points = {{81, -40}, {100, -40}, {100, 0}, {140, 0}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end LHVRT;
