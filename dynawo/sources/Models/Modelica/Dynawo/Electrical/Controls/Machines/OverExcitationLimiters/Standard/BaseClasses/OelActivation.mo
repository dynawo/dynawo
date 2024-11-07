within Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard.BaseClasses;

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

model OelActivation "IBias calculation for OEL2C"

  //Regulation parameters
  parameter Types.CurrentModulePu IInstPu "OEL instantaneous field current limit";
  parameter Types.CurrentModulePu IResetPu "OEL reset-reference, if inactive";
  parameter Types.CurrentModulePu IThOffPu "OEL reset threshold value";
  parameter Types.Time tEn "OEL activation delay time in s";
  parameter Types.Time tOff "OEL reset delay time in s";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IActPu(start = IRef0Pu) "Actual field current in pu" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IRefPu(start = IRef0Pu) "Reference field current in pu" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tErr(start = tErr0) "OEL timer error in s" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput IBiasPu(start = 0) "Output current in pu" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Timer timer;
  Modelica.Blocks.Logical.Timer timer1;

  //Initial parameters
  parameter Types.CurrentModulePu IRef0Pu "Initial reference field current in pu";
  parameter Types.Time tErr0 "Initial OEL timer error in s";

equation
  if tErr <= 0 or timer.y >= tEn or tEn == 0 then
    IBiasPu = 0;
  elseif IRefPu == IInstPu and timer1.y > tOff then
    IBiasPu = IResetPu;
  else
    IBiasPu = 0;
  end if;

  timer.u = IActPu > IRefPu;
  timer1.u = IRefPu > IActPu + IThOffPu;

  annotation(preferredView = "text");
end OelActivation;
