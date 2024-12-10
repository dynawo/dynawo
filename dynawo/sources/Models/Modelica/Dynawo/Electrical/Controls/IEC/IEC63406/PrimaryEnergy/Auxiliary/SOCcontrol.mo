within Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy.Auxiliary;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SOCcontrol "Module to limit output power depending on SOC (IEC N°61400-27-1)"

  // Parameters
  parameter Types.Percent SOCMax "Maximum SOC amount for charging" annotation(
    Dialog(tab = "SOCcontrol"));
  parameter Types.Percent SOCMin "Minimum SOC amount for discharging" annotation(
    Dialog(tab = "SOCcontrol"));
  parameter Types.PerUnit PMaxPu "EMaximum capacity of the CBGU" annotation(
    Dialog(tab = "SOCcontrol"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput soc annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput pAvailInPu annotation(
    Placement(visible = true, transformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput pAvailOutPu annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
