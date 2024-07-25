within Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model SclOelActivation

  //Regulation parameters
  parameter Types.PerUnit IInst "OEL instantaneous field current limit";
  parameter Types.PerUnit IReset "OEL reset-reference, if OEL is inactive";
  parameter Types.PerUnit IThOff "OEL reset threshold value";
  parameter Types.Time tEnOel "OEL activation delay time in s";
  parameter Types.Time tOff "OEL reset delay time in s";
  parameter Types.VoltageModulePu VtMinPu "SCL OEL minimum voltage reference value";
  parameter Types.VoltageModulePu VtResetPu "SCL OEL voltage reset value";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IOelAct(start = 0) "Input signal" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IOelRef(start = IOelRef0Pu) "Input signal" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tErr(start = 0) "Input signal" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput VtFiltPu(start = Vt0Pu) "Input voltage" annotation(
    Placement(visible = true, transformation(origin = {120, -60}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput IOelBias(start = 0) "Output signal" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Timer timer;
  Modelica.Blocks.Logical.Timer timer1;

  //Initial parameters
  parameter Types.CurrentModulePu IOelRef0Pu "Initial reference current";
  parameter Types.Time tErr0;
  parameter Types.VoltageModulePu Vt0Pu "Initial input voltage";

equation
  when VtFiltPu > VtMinPu and (tErr <= 0 or timer.y >= tEnOel) then
    IOelBias = 0;
  elsewhen (IOelRef >= IInst and timer1.y > tOff) or VtFiltPu < VtResetPu then
    IOelBias = if tEnOel == 0 then 0 else IReset;
  end when;

  timer.u = IOelAct > IOelRef;
  timer1.u = IOelRef > IOelAct + IThOff;

  annotation(preferredView = "text");
end SclOelActivation;
