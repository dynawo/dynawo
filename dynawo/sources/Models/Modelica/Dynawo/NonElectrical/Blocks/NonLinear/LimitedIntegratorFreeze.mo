within Dynawo.NonElectrical.Blocks.NonLinear;

block LimitedIntegratorFreeze "Integrator with limited value of the output and a freeze port"
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
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));
  parameter Types.PerUnit K = 1 "Integrator gain";
  parameter Real Y0 = 0 "Initial or guess value of output (must be in the limits YMin .. YMax)" annotation(
    Dialog(group = "Initialization"));
  parameter Real YMax "Upper limit of output";
  parameter Real YMin "Lower limit of output";
  Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(transformation(origin = {-120, 58}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-82, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
equation
  if y <= YMin and K*u < 0 then
    der(y) = 0;
  elseif y >= YMax and K*u > 0 then
    der(y) = 0;
  elseif freeze == true then
    der(y) = 0;
  else
    der(y) = K*u;
  end if;
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Line(origin = {0, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {42, 118.943}, {80, 118.943}})}));
end LimitedIntegratorFreeze;
