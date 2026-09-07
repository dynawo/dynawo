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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model SclOelActivation "IOelBias calculation for SCL2C"

  //Regulation parameters
  parameter Types.CurrentModulePu IInstPu "SCL instantaneous stator current limit in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IResetPu "SCL reset-reference, if inactive, in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IThOffPu "SCL reset threshold value in pu (base SnRef, UNom)";
  parameter Types.Time tEnOel "Overexcited activation delay time in s";
  parameter Types.Time tOff "SCL reset delay time in s";
  parameter Types.VoltageModulePu VtMinPu "SCL OEL minimum voltage reference value in pu (base UNom)";
  parameter Types.VoltageModulePu VtResetPu "SCL OEL voltage reset value in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IOelActPu(start = IOelRef0Pu) "SCL OEL actual current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IOelRefPu(start = IOelRef0Pu) "SCL OEL reference current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tErr(start = 0) "SCL timer error in s" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput VtFiltPu(start = Vt0Pu) "Filtered stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {120, 60}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput IOelBiasPu(start = 0) "Output current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Timer timer;
  Modelica.Blocks.Logical.Timer timer1;

  //Initial parameters
  parameter Types.CurrentModulePu IOelRef0Pu "Initial reference current in pu (base SnRef, UNom)";
  parameter Types.Time tErr0 "Initial SCL timer error in s";
  parameter Types.VoltageModulePu Vt0Pu "Initial stator voltage in pu (base UNom)";

equation
  if (VtFiltPu > VtMinPu and (tErr <= 0 or timer.y >= tEnOel)) or tEnOel == 0 then
    IOelBiasPu = 0;
  elseif (IOelRefPu == IInstPu and timer1.y > tOff) or VtFiltPu < VtResetPu then
    IOelBiasPu = IResetPu;
  else
    IOelBiasPu = 0;
  end if;

  timer.u = IOelActPu > IOelRefPu;
  timer1.u = IOelRefPu > IOelActPu + IThOffPu;

  annotation(preferredView = "text");
end SclOelActivation;
