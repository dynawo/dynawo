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

model LimitUpdating
  parameter Types.CurrentModulePu IMaxPu "Maximum current of the injector in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput IpCmdPu "Active current command in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IqCmdPu "Reactive current command in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput PPriority "Priority to active power (true) or reactive power (false)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput IpMaxPu annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IqMaxPu annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IqMinPu annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Types.PerUnit IpLimPu = max(min(abs(IpCmdPu), IMaxPu), 0);
  Types.PerUnit IqLimPu = max(min(abs(IqCmdPu), IMaxPu), -IMaxPu);

equation
  if PPriority then
    IpMaxPu = IMaxPu;
    IqMaxPu = noEvent(if(abs(IMaxPu) > abs(IpLimPu)) then sqrt(IMaxPu ^ 2 - IpLimPu ^ 2) else 0);
    IqMinPu = -IqMaxPu;
  else
    IpMaxPu = noEvent(if(abs(IMaxPu) > abs(IqLimPu)) then sqrt(IMaxPu ^ 2 - IqLimPu ^ 2) else 0);
    IqMaxPu = IMaxPu;
    IqMinPu = -IqMaxPu;
  end if;

  annotation(preferredView = "text");
end LimitUpdating;
