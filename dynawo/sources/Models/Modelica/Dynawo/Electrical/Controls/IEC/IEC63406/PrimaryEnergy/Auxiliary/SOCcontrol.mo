within Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy.Auxiliary;

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

model SOCcontrol "Module to limit output power depending on SOC (IEC 63406)"

  // Parameters
  parameter Types.ActivePowerPu PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "SOCcontrol"));
  parameter Types.Percent SOCMax "Maximum SOC amount for charging in %" annotation(
    Dialog(tab = "SOCcontrol"));
  parameter Types.Percent SOCMin "Minimum SOC amount for discharging in %" annotation(
    Dialog(tab = "SOCcontrol"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput soc(start = SOCInit) "State of charge of the storage system in %" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput pAvailInPu(start = -PMaxPu) "Minimum output electrical power available to the active power control module in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput pAvailOutPu(start = PMaxPu) "Maximum output electrical power available to the active power control module in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.Percent SOCInit "Initial SOC amount in %" annotation(
    Dialog(tab = "StorageSys"));

equation
// Equation de la boucle if
  if soc >= SOCMax - 0.0001 * SOCMax then
    pAvailInPu = 0;
    pAvailOutPu = PMaxPu;
  elseif soc <= SOCMin + 0.0001 * SOCMin then
    pAvailInPu = -PMaxPu;
    pAvailOutPu = 0;
  else
    pAvailInPu = -PMaxPu;
    pAvailOutPu = PMaxPu;
  end if;

  annotation(
    Icon(graphics = {Text(origin = {4, 2}, extent = {{-88, 62}, {88, -62}}, textString = "SOC\nControl"), Rectangle(fillColor = {255, 255, 255}, extent = {{-100, 100}, {100, -100}})}));
end SOCcontrol;
