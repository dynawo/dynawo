within Dynawo.Electrical.StaticVarCompensators.BaseControls;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ModeHandling "Static Var Compensator mode calculation"
  import Modelica;
  import Dynawo.Types;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends Parameters.Params_ModeHandling;
  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";
  final parameter Types.VoltageModule UThresholdUpPu =  UThresholdUp / UNom;
  final parameter Types.VoltageModule UThresholdDownPu =  UThresholdDown / UNom;

  Modelica.Blocks.Interfaces.RealInput URef(start = URef0) "Voltage reference for the regulation in kV" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu "Voltage at the static var compensator terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput URefPu(start = URef0 / UNom) "Voltage reference for the regulation in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  ModeConnector mode(value(start = Mode0)) "Current mode of the static var compensator" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ModeConnector modeAuto(value(start = Mode0)) "Mode of the static var compensator when in automatic configuration";
  ModeConnector modeManual(value(start = Mode0)) "Mode of the static var compensator when in manual configuration";

  Modelica.Blocks.Interfaces.IntegerInput setModeManual "Mode selected when in manual configuration" annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput selectModeAuto "Whether the static var compensator is in automatic configuration" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Types.Time timerModeChangeUp(start = Modelica.Constants.inf) "Timer for the transition from standby to running mode for high voltage values";
  Types.Time timerModeChangeDown(start = Modelica.Constants.inf) "Timer for the transition from standby to running mode for low voltage values";
  Types.VoltageModule URefAuto(start = URef0) "Voltage reference for the regulation if the static var compensator switches from standy to running mode automatically in kV";

  parameter Types.VoltageModule URef0 "Start value of voltage reference in kV";
  parameter Mode Mode0 "Start value for mode";

equation
  // Timer for the transition from standby to running mode for high voltage values
  when UPu > UThresholdUpPu then
    timerModeChangeUp = time;
  elsewhen UPu < UThresholdUpPu then
    timerModeChangeUp = Modelica.Constants.inf;
  end when;
  // Timer for the transition from standby to running mode for low voltage values
  when UPu < UThresholdDownPu then
    timerModeChangeDown = time;
  elsewhen UPu > UThresholdDownPu then
    timerModeChangeDown = Modelica.Constants.inf;
  end when;
  // Transition from standby mode to running mode
  when (time - timerModeChangeUp  >= tThresholdUp or time - timerModeChangeDown  >= tThresholdDown) and pre(modeAuto.value) == Mode.STANDBY then
    modeAuto.value = Mode.RUNNING_V;
    Timeline.logEvent1(TimelineKeys.SVarCRunning);
  end when;
  // URefAuto evaluation
  when modeAuto.value == Mode.RUNNING_V and pre(modeAuto.value) == Mode.STANDBY and UPu > UThresholdUpPu then
    URefAuto = URefUp;
  elsewhen modeAuto.value == Mode.RUNNING_V and pre(modeAuto.value) == Mode.STANDBY and UPu < UThresholdDownPu then
    URefAuto = URefDown;
  end when;
  // Manual mode setting
  if setModeManual == 1 then
    modeManual.value = Mode.OFF;
  elseif setModeManual == 2 then
    modeManual.value = Mode.STANDBY;
  elseif setModeManual == 3 then
    modeManual.value = Mode.RUNNING_V;
  else
    assert(false, "Failed to convert setModeManual value into mode (enum: 1:OFF, 2:STANDBY, 3:RUNNING_V)");
    modeManual.value = Mode.OFF;
  end if;
  // Evaluation of current mode and setpoint
  if selectModeAuto == true then
    mode.value = modeAuto.value;
    URefPu = URefAuto / UNom;
  else
    mode.value = modeManual.value;
    URefPu = URef /UNom;
  end if;

  annotation(preferredView = "text",
    Diagram(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 8}, extent = {{-57, 10}, {123, -22}}, textString = "ModeHandling")}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {0, -1}, extent = {{-100, 101}, {100, -99}}), Text(origin = {-61, 18}, extent = {{-30, 20}, {156, -54}}, textString = "ModeHandling"), Text(origin = {142, -42}, extent = {{-26, 10}, {52, -22}}, textString = "URefPu"), Text(origin = {127, 14}, extent = {{-21, 12}, {57, -14}}, textString = "mode"), Text(origin = {-170, -15}, extent = {{-34, 13}, {34, -11}}, textString = "URef"), Text(origin = {-170, -62}, extent = {{-26, 10}, {32, -14}}, textString = "UPu"), Text(origin = {-193, 87}, extent = {{-125, 45}, {49, -27}}, textString = "setModeManual"), Text(origin = {-168, 36}, extent = {{-152, 46}, {22, -34}}, textString = "selectModeAuto")}, coordinateSystem(initialScale = 0.1)));
end ModeHandling;
