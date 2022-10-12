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

block Switch "Switches two discrete inputs based on an xor of two booleans, one of which may change during the simulation"
  import Modelica.Blocks.Interfaces;

  parameter Real cutOffValue = 1.5 "Value under which the switch defaults to False, and True if above";
  parameter Boolean invertBehaviour "In case the expected behaviour should be inverted from the default one.";

  discrete Interfaces.RealInput doSwitch "Whether a switch should occur or not. The filtering is done based on a comparison with the cutOffValue" annotation(Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  discrete Interfaces.RealInput u1 "One of the discrete inputs" annotation(Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  discrete Interfaces.RealInput u2 "The other discrete input" annotation(Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Interfaces.RealOutput y "Output signal connector" annotation(Placement(
        transformation(extent={{100,-10},{120,10}})));

equation
  y = if doSwitch >= cutOffValue and not invertBehaviour or invertBehaviour and doSwitch < cutOffValue then u2 else u1;

  annotation(preferredView = "diagram");
end Switch;
