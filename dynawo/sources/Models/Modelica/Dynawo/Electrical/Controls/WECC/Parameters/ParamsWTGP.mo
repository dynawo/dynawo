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

record ParamsWTGP
  parameter Types.Frequency Kiw "Pitch controller integral gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.PerUnit Kpw "Pitch controller proportional gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.Frequency Kic "Pitch compensation integral gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.PerUnit Kpc "Pitch Compensation proportional gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.PerUnit Kcc "Proportionnal cross-compensation gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.Time tTheta "Pitch time constant in s" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree ThetaMax "Maximum pitch angle limit in degree" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree ThetaMin "Minimum pitch angle limit in degree" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngularVelocityDegree ThetaRMax "Maximum pitch angle rate limit in degree/s" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngularVelocityDegree ThetaRMin "Minimum pitch angle rate limit in degree/s" annotation(
  Dialog(tab="Pitch Control"));

  // Initial parameters
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector terminal in pu (base SNom) (generator convention)";
  parameter Types.AngleDegree Theta0 "Initial pitch angle in degree";

  annotation(
  preferredView = "text");
end ParamsWTGP;
