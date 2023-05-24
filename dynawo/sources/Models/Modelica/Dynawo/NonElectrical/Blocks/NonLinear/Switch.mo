within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block Switch "Forces a steady state if an ACMC cannot be improved upon."
  import Modelica.Blocks.Interfaces;

  parameter Real defaultValue "A value landing in the deadband of an ACMC model, forcing it to rest.";

  discrete Interfaces.RealInput u1 "The true value of the current voltage state" annotation(Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  discrete Interfaces.RealInput u2 "The predicted value of the voltage state if one were to add the (positive) contribution of a shunt or a capacitor" annotation(Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Interfaces.RealOutput y "Output signal connector" annotation(Placement(
        transformation(extent={{100,-10},{120,10}})));

equation
  if (u1 > 0) or (u2 <= 0) then
    y = u1;
  else
    y = defaultValue;
  end if;

  annotation(preferredView = "diagram");
end Switch;
