within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;

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

model LvrtFrz "Low voltage ride through freeze function of EPRI Grid Forming model"

  parameter Types.PerUnit UDipPu "Freeze voltage in pu (base UNom), example value = 0.85" annotation(
  Dialog(tab = "VoltageControl"));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput UPu(start = sqrt(UdFilter0Pu^2 + UqFilter0Pu^2)) "Voltage magnitude in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.BooleanOutput Frz(start = false) "Boolean low voltage freeze signal" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));

equation
  Frz = if UPu < UDipPu then true else false;

  annotation(
  preferredView = "text");
end LvrtFrz;
