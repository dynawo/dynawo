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
  parameter Types.Frequency kip "Integral gain" annotation(Dialog(tab="Torque control"));
  parameter Real kpp "Proportional gain" annotation(Dialog(tab="Torque control"));
  parameter Types.Time tp "Power measurement lag time constant" annotation(Dialog(tab="Torque control"));
  parameter Types.Time tOmegaRef "Speed reference time constant" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit tEMax "Maximum torque" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit tEMin "Minimum torque" annotation(Dialog(tab="Torque control"));
  parameter Real p1 "1st power point for extrapolation table" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit spd1 "1st speed point for extrapolation table" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit p2 "2nd power point for extrapolation table" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit spd2 "2nd speed point for extrapolation table" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit p3 "3rd power point for extrapolation table" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit spd3 "3rd speed point for extrapolation table" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit p4 "4th power point for extrapolation table" annotation(Dialog(tab="Torque control"));
  parameter Types.PerUnit spd4 "4th speed point for extrapolation table" annotation(Dialog(tab="Torque control"));
  parameter Boolean tFlag "Flag to specify PI controller input" annotation(Dialog(tab="Torque control"));
  parameter Real PInj0Pu "Start value of active power at injector terminal in pu (base SNom) (generator convention)" annotation(Dialog(group="Initialization"));

  annotation(preferredView = "text");
end ParamsWTGQa;
