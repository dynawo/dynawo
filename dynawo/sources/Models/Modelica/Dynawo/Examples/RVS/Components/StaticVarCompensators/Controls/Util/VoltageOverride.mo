within Dynawo.Examples.RVS.Components.StaticVarCompensators.Controls.Util;

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

model VoltageOverride
  import Modelica;
  import Dynawo.Types;

  parameter Types.VoltageModulePu UovPu = 0.5;
  parameter Types.VoltageModulePu Uerr0Pu;
  parameter Types.VoltageModulePu BCommand0;
  parameter Real BMax;
  parameter Real BMin;

  Modelica.Blocks.Interfaces.RealInput UerrPu(start = Uerr0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-170, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput BVarRaw(start = if Uerr0Pu > UovPu then BMin elseif Uerr0Pu < -UovPu then BMax else 0) annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput BCommand(start =  BCommand0) annotation(
    Placement(visible = true, transformation(origin = {-170, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-170, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
// Maximum Capacitive Output
  if UerrPu > UovPu then
    BVarRaw = BMax;
// Maximum Inductive Output
  elseif UerrPu < (-UovPu) then
    BVarRaw = BMin;
  else
    BVarRaw = BCommand;
  end if;

  annotation(
    Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-150, 100}, {150, -100}}), Text(origin = {0, 40}, extent = {{-140, 20}, {140, -20}}, textString = "BMin if UerrPu > UovPu"), Text(origin = {0, -38}, extent = {{140, -20}, {-140, 20}}, textString = "BMax if UerrPu < -UovPu")}),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}})));
end VoltageOverride;
