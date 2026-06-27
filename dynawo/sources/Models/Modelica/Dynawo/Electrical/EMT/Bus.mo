within Dynawo.Electrical.EMT;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model Bus "Three-phase EMT bus (open node that draws no current; provides a start value for the node voltage)"
  Dynawo.Electrical.EMT.PwPin p(v(start = V0)) "Bus pin";

  parameter Real V_0 = 1 "Voltage magnitude start value";
  parameter Real angle_0 = 0 "Voltage angle start value (deg)";
  parameter Modelica.SIunits.Angle angle_0_rad = angle_0 / 180 * Modelica.Constants.pi "Voltage angle start value (rad)";
  parameter Real V0[3] = V_0 * sqrt(2.0 / 3.0) * {Modelica.Math.cos(angle_0_rad),
                                                  Modelica.Math.cos(angle_0_rad - 2.0 / 3.0 * Modelica.Constants.pi),
                                                  Modelica.Math.cos(angle_0_rad + 2.0 / 3.0 * Modelica.Constants.pi)} "Three-phase node voltage start value";

equation
  p.i = zeros(3);

  annotation(preferredView = "text");
end Bus;
