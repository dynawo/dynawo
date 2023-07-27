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

model BlockingFunction "Blocking function for the SVarC model"
  import Modelica;

  extends Parameters.ParamsBlockingFunction;

  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";

  final parameter Types.VoltageModule UBlockPu = UBlock / UNom;
  final parameter Types.VoltageModule UUnblockUpPu = UUnblockUp / UNom;
  final parameter Types.VoltageModule UUnblockDownPu = UUnblockDown / UNom;

  Modelica.Blocks.Interfaces.RealInput UPu "Voltage at the static var compensator terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput blocked "Whether the static var compensator is blocked due to very low voltages" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  // Blocking and deblocking conditions
  when UPu <= UBlockPu then
    blocked = true;
  elsewhen UPu < UUnblockUpPu and UPu > UUnblockDownPu then
    blocked = false;
  end when;

  annotation(
    preferredView = "text",
    Diagram(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 8}, extent = {{-57, 10}, {123, -22}}, textString = "BlockingFunction")}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {0, -1}, extent = {{-100, 101}, {100, -99}}), Text(origin = {-61, 18}, extent = {{-30, 20}, {156, -54}}, textString = "BlockingFunction"), Text(origin = {138, 28}, extent = {{-26, 12}, {64, -24}}, textString = "blocked"), Text(origin = {-170, 30}, extent = {{-26, 10}, {32, -14}}, textString = "UPu")}, coordinateSystem(initialScale = 0.1)));
end BlockingFunction;
