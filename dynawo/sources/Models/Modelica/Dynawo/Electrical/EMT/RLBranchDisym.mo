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

model RLBranchDisym "Three-phase dissymmetric RL branch in EMT (semi-explicit form on the phase currents)"
  extends Dynawo.Electrical.EMT.TwoPin;

  parameter Modelica.SIunits.Inductance L11 "Self inductance of each phase";
  parameter Modelica.SIunits.Inductance L12 = L11 / 2 "Mutual inductance between phases";
  parameter Modelica.SIunits.Resistance R11 "Resistance of each phase";

  // Coefficients of the inverse of the (symmetric) inductance matrix
  final parameter Real LLinv = (L11 + L12) / (L11 * L11 + L11 * L12 - 2 * L12 * L12) "Diagonal term of the inverse inductance matrix";
  final parameter Real MLinv = -L12 / (L11 * L11 + L11 * L12 - 2 * L12 * L12) "Off-diagonal term of the inverse inductance matrix";

equation
  // Semi-explicit model: der(i) = LInv * (v - R * i)
  der(i[1]) = LLinv * (v[1] - R11 * i[1]) + MLinv * (v[2] - R11 * i[2]) + MLinv * (v[3] - R11 * i[3]);
  der(i[2]) = MLinv * (v[1] - R11 * i[1]) + LLinv * (v[2] - R11 * i[2]) + MLinv * (v[3] - R11 * i[3]);
  der(i[3]) = MLinv * (v[1] - R11 * i[1]) + MLinv * (v[2] - R11 * i[2]) + LLinv * (v[3] - R11 * i[3]);

  annotation(preferredView = "text");
end RLBranchDisym;
