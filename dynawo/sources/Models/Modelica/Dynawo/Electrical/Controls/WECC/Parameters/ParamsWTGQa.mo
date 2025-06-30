within Dynawo.Electrical.Controls.WECC.Parameters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsWTGQa
  parameter Types.Frequency Kip "Integral gain" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Kpp "Proportional gain" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit P1 "1st power point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Spd1 "1st speed point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit P2 "2nd power point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Spd2 "2nd speed point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit P3 "3rd power point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Spd3 "3rd speed point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit P4 "4th power point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Spd4 "4th speed point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit TeMaxPu "Maximum torque" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit TeMinPu "Minimum torque" annotation(
  Dialog(tab="Torque control"));
  parameter Boolean TFlag "Flag to specify PI controller input, if true : power control, if false : speed control" annotation(
  Dialog(tab="Torque control"));
  parameter Types.Time tP "Power measurement lag time constant in s" annotation(
  Dialog(tab="Torque control"));
  parameter Types.Time tOmegaRef "Speed reference time constant ins s" annotation(
  Dialog(tab="Torque control"));

  // Initial parameter
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector terminal in pu (base SNom) (generator convention)" annotation(
  Dialog(group="Initialization"));

  annotation(preferredView = "text");
end ParamsWTGQa;
