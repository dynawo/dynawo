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

model LHVRT "High and low voltage ride-through"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.VoltageModulePu UOverPu "Overvoltage protection activation threshold in pu (base UNom)";
  parameter Types.VoltageModulePu UUnderPu "Undervoltage protection activation threshold in pu (base UNom)";
  parameter Types.Time tLagAction "Time lag due to the actual tripping action in s";
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s";

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
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Sources.Constant const(k = UOverPu) annotation(
    Placement(transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D1(tableName = TabletUunderUfilt, tableOnFile = TablesOnFile, fileName = TablesFile, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = UUnderPu) annotation(
    Placement(transformation(origin = {-170, -80}, extent = {{-10, -10}, {10, 10}})));
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
  Modelica.Blocks.Logical.Greater greater2 annotation(
    Placement(transformation(origin = {90, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Greater greater3 annotation(
    Placement(transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Sources.Constant const2(k = tLagAction) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameter
  parameter Types.VoltageModulePu UMonitored0Pu "Initial monitored voltage amplitude in pu (base UNom)";

protected
  Types.Time tThresholdReachedHvrt(start = Modelica.Constants.inf) "Time when the HVRT threshold is reached in s";
  Types.Time tThresholdReachedLvrt(start = Modelica.Constants.inf) "Time when the LVRT threshold is reached in s";

equation
  when greaterEqual.y and not(pre1.y) then
    Timeline.logEvent1(TimelineKeys.HVRTArming);
    tThresholdReachedHvrt = time;
  elsewhen not(greaterEqual.y) and pre(tThresholdReachedHvrt) <> Modelica.Constants.inf and not(pre1.y) and not(timer2.u) then
    Timeline.logEvent1(TimelineKeys.HVRTDisarming);
    tThresholdReachedHvrt = Modelica.Constants.inf;
  end when;

  when lessEqual.y and not(pre1.y) then
    Timeline.logEvent1(TimelineKeys.LVRTArming);
    tThresholdReachedLvrt = time;
  elsewhen not(lessEqual.y) and pre(tThresholdReachedLvrt) <> Modelica.Constants.inf and not(pre1.y) and not(timer3.u) then
    Timeline.logEvent1(TimelineKeys.LVRTDisarming);
    tThresholdReachedLvrt = Modelica.Constants.inf;
  end when;

  when greaterEqual.y then
    timer.u = true;
  end when;

  when lessEqual.y then
    timer1.u = true;
  end when;

  when greater.y then
    timer2.u = true;
  end when;

  when less.y then
    timer3.u = true;
  end when;

  when greater2.y and not(pre(fOCB)) then
    Timeline.logEvent1(TimelineKeys.HVRTTripped);
  end when;

  when greater3.y and not(pre(fOCB)) then
    Timeline.logEvent1(TimelineKeys.LVRTTripped);
  end when;

  connect(const.y, greaterEqual.u2) annotation(
    Line(points = {{-159, 80}, {-140, 80}, {-140, 68}, {-122, 68}}, color = {0, 0, 127}));
  connect(const1.y, lessEqual.u2) annotation(
    Line(points = {{-159, -80}, {-140, -80}, {-140, -68}, {-122, -68}}, color = {0, 0, 127}));
  connect(timer.y, greater.u1) annotation(
    Line(points = {{-59, 60}, {-40, 60}, {-40, 40}, {-22, 40}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], greater.u2) annotation(
    Line(points = {{-59, 20}, {-40, 20}, {-40, 32}, {-22, 32}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], less.u1) annotation(
    Line(points = {{-59, -20}, {-40, -20}, {-40, -40}, {-22, -40}}, color = {0, 0, 127}));
  connect(timer1.y, less.u2) annotation(
    Line(points = {{-59, -60}, {-40, -60}, {-40, -48}, {-22, -48}}, color = {0, 0, 127}));
  connect(or1.y, fOCB) annotation(
    Line(points = {{161.5, 0}, {210, 0}}, color = {255, 0, 255}));
  connect(filter.y, greaterEqual.u1) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, 60}, {-122, 60}}, color = {0, 0, 127}));
  connect(filter.y, combiTable1D.u) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(filter.y, combiTable1D1.u) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(filter.y, lessEqual.u1) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, -60}, {-122, -60}}, color = {0, 0, 127}));
  connect(UMonitoredPu, filter.u) annotation(
    Line(points = {{-220, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(or1.y, pre1.u) annotation(
    Line(points = {{161.5, 0}, {179.5, 0}, {179.5, -40}, {161.5, -40}}, color = {255, 0, 255}));
  connect(pre1.y, or1.u[3]) annotation(
    Line(points = {{139, -40}, {130, -40}, {130, 0}, {139, 0}}, color = {255, 0, 255}));
  connect(timer2.y, greater2.u1) annotation(
    Line(points = {{41, 40}, {77, 40}}, color = {0, 0, 127}));
  connect(const2.y, greater2.u2) annotation(
    Line(points = {{41, 0}, {60, 0}, {60, 32}, {77, 32}}, color = {0, 0, 127}));
  connect(timer3.y, greater3.u1) annotation(
    Line(points = {{41, -40}, {77, -40}}, color = {0, 0, 127}));
  connect(const2.y, greater3.u2) annotation(
    Line(points = {{41, 0}, {60, 0}, {60, -32}, {77, -32}}, color = {0, 0, 127}));
  connect(greater2.y, or1.u[1]) annotation(
    Line(points = {{102, 40}, {120, 40}, {120, 0}, {140, 0}}, color = {255, 0, 255}));
  connect(greater3.y, or1.u[2]) annotation(
    Line(points = {{102, -40}, {120, -40}, {120, 0}, {140, 0}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end LHVRT;
