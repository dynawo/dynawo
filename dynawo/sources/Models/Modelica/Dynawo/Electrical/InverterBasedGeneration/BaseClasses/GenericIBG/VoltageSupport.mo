within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.GenericIBG;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model VoltageSupport
  parameter Types.CurrentModulePu IMaxPu "Maximum current of the injector in pu (base UNom, SNom)";
  parameter Real kRCA "Slope of reactive current decrease for high voltages in pu (base UNom, SNom)";
  parameter Real kRCI "Slope of reactive current increase for low voltages in pu (base UNom, SNom)";
  parameter Real m "Current injection just outside of lower deadband in pu (base IMaxPu)";
  parameter Real n "Current injection just outside of lower deadband in pu (base IMaxPu)";
  parameter Types.VoltageModulePu US1 "Lower voltage limit of deadband in pu (base UNom)";
  parameter Types.VoltageModulePu US2 "Higher voltage limit of deadband in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput Um "Measured voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput IqSupPu "Additional reactive current for voltage support in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if Um < US1 then
    IqSupPu = m * IMaxPu + kRCI * (US1 - Um);
  elseif Um < US2 then
    IqSupPu = 0;
  else
    IqSupPu = -n * IMaxPu + kRCA * (Um - US2);
  end if;

  annotation(preferredView = "text");
end VoltageSupport;
