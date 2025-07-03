within Dynawo.Electrical.Controls.WECC.Parameters.Mechanical;

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

record ParamsWTGAa
  parameter Types.PerUnit Ka "Aero-dynamic gain factor" annotation(
  Dialog(tab="Aero-dynamic model"));

  // Initial parameters
  parameter Types.AngleDegree Theta0 "Initial pitch angle in degree";
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base SNom)";

  annotation(
  preferredView = "text");
end ParamsWTGAa;
