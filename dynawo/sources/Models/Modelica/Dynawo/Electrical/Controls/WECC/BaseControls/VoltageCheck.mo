within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model VoltageCheck "This block generates a signal to freeze the control when the voltage is too low or too high"

  parameter Types.PerUnit UMinPu "Lower voltage limit for freeze in pu (base UNom)";
  parameter Types.PerUnit UMaxPu "Upper voltage limit for freeze in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput UPu "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput freeze "Boolean to freeze the regulation" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  freeze = UPu < UMinPu or UPu > UMaxPu;

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {18, -4}, extent = {{-98, 84}, {62, -76}}, textString = "Voltage Check"), Text(origin = {-121.5, 18}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "UPu"), Text(origin = {112.5, 20}, extent = {{-10.5, 7}, {31.5, -20}}, textString = "freeze")}, coordinateSystem(initialScale = 0.1)));
end VoltageCheck;
