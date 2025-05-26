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
  parameter Types.Frequency kiw "Pitch controller integral gain" annotation(Dialog(tab="Pitch Control"));
  parameter Real kpw "Pitch controller proportional gain" annotation(Dialog(tab="Pitch Control"));
  parameter Types.Frequency kic "Pitch compensation integral gain" annotation(Dialog(tab="Pitch Control"));
  parameter Real kpc "Pitch Compensation proportional gain" annotation(Dialog(tab="Pitch Control"));
  parameter Real kcc "Proportionnal cross-compensation gain" annotation(Dialog(tab="Pitch Control"));
  parameter Types.Time tTheta "Pitch time constant" annotation(Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree thetaMax "Maximum pitch angle limit" annotation(Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree thetaMin "Minimum pitch angle limit" annotation(Dialog(tab="Pitch Control"));
  parameter Types.AngularVelocityDegree thetaRMax "Maximum pitch angle rate limit" annotation(Dialog(tab="Pitch Control"));
  parameter Types.AngularVelocityDegree thetaRMin "Minimum pitch angle rate limit" annotation(Dialog(tab="Pitch Control"));
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (base SNom) (generator convention)";
  parameter Types.AngleDegree theta0 "Initial pitch angle" annotation(Dialog(group="Initialization"));

  annotation(preferredView = "text");
end ParamsWTGP;
