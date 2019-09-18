within Dynawo.Electrical.Controls.Voltage.StaticVarCompensator;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ModeHandling "Static Var Compensator mode calculation and blocking"
  import Modelica;
  import Dynawo.Electrical.Controls.Voltage.StaticVarCompensator.Parameters;

  extends Parameters.Params_ModeHandling;

  Modelica.Blocks.Interfaces.RealInput URef(start = URef0) "Voltage reference for the regulation in kV" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu "Voltage at the static var compensator terminal in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput URefPu(start = URef0 / UNom) "Voltage reference for the regulation in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput blocked "Wheter the static var compensator is blocked due to very low voltages" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  ModeConnector mode(value(start = Mode0)) "Current mode of the static var compensator" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ModeConnector mode_auto(value(start = Mode0)) "Mode of the static var compensator when in automatic configuration";
  ModeConnector mode_manual(value(start = Mode0)) "Mode of the static var compensator when in manual configuration";

  Modelica.Blocks.Interfaces.IntegerInput setMode "Mode selected when in manual configuration" annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput selectModeAuto "Wheter the static var compensator is in automatic configuration" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Types.Time timerModeChangeUp(start = Modelica.Constants.inf) "Timer for the transition from standby to running mode for high voltage values";
  Types.Time timerModeChangeDown(start = Modelica.Constants.inf) "Timer for the transition from standby to running mode for low voltage values";
  Types.VoltageModule URef_auto(start = URef0) "Voltage reference for the regulation if the static var compensator switches from standy to running mode automatically in kV";

protected
  parameter Types.VoltageModule URef0  "Start value of voltage reference in kV";
  parameter Mode Mode0 "Start value for mode";

equation
  // Timer for the transition from standby to running mode for high voltage values
  when UPu*UNom > UThresholdUp then
    timerModeChangeUp = time;
  elsewhen UPu*UNom < UThresholdUp then
    timerModeChangeUp = Modelica.Constants.inf;
  end when;
  // Timer for the transition from standby to running mode for low voltage values
  when UPu*UNom < UThresholdDown then
    timerModeChangeDown = time;
  elsewhen UPu*UNom > UThresholdDown then
    timerModeChangeDown = Modelica.Constants.inf;
  end when;
  // Transition from standby mode to running mode
  when (time - timerModeChangeUp  >= tThresholdUp or time - timerModeChangeDown  >= tThresholdDown) and pre(mode_auto.value) == Mode.STANDBY then
    mode_auto.value = Mode.RUNNING_V;
  end when;
  // Blocking and deblocking conditions
  when UPu*UNom <= UBlock then
    blocked = true;
  elsewhen UPu*UNom < UDeblockUp and UPu*UNom > UDeblockDown then
    blocked = false;
  end when;
  // URefPu evaluation
  when mode_auto.value == Mode.RUNNING_V and pre(mode_auto.value) == Mode.STANDBY and UPu*UNom > UThresholdUp then
    URef_auto = URefUp;
  elsewhen mode_auto.value == Mode.RUNNING_V and pre(mode_auto.value) == Mode.STANDBY and UPu*UNom < UThresholdDown then
    URef_auto = URefDown;
  end when;
  if Mode0 == Mode.STANDBY then
    URefPu = URef_auto / UNom;
  else
    URefPu = URef /UNom;
  end if;
  // Manual mode setting
  if setMode == 1 then
    mode_manual.value = Mode.OFF;
  elseif setMode == 2 then
    mode_manual.value = Mode.STANDBY;
  elseif setMode == 3 then
    mode_manual.value = Mode.RUNNING_V;
  else
    assert(false, "Failed to convert setMode value into mode (enum: 1:OFF, 2:STANDBY, 3:RUNNING_V");
    mode_manual.value = Mode.OFF;
  end if;
  // Evaluation of current mode
  if selectModeAuto == true then
    mode.value = mode_auto.value;
  else
    mode.value = mode_manual.value;
  end if;
  annotation(
    Diagram(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 8}, extent = {{-57, 10}, {123, -22}}, textString = "ModeHandling")}),
    Icon(graphics = {Rectangle(origin = {0, -1}, extent = {{-100, 101}, {100, -99}}), Text(origin = {-61, 18}, extent = {{-30, 20}, {156, -54}}, textString = "ModeHandling"), Text(origin = {138, 80}, extent = {{-26, 12}, {64, -24}}, textString = "blocked"),  Text(origin = {142, -42}, extent = {{-26, 10}, {52, -22}}, textString = "URefPu"), Text(origin = {127, 14}, extent = {{-21, 12}, {57, -14}}, textString = "mode"), Text(origin = {-170, -15}, extent = {{-34, 13}, {34, -11}}, textString = "URef"), Text(origin = {-170, -62}, extent = {{-26, 10}, {32, -14}}, textString = "UPu"), Text(origin = {-195, 103}, extent = {{-39, 11}, {49, -27}}, textString = "setMode"), Text(origin = {-168, 36}, extent = {{-152, 46}, {22, -34}}, textString = "selectModeAuto")}, coordinateSystem(initialScale = 0.1)));


end ModeHandling;
