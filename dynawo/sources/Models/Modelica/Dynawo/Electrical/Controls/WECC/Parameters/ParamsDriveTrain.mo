within Dynawo.Electrical.Controls.WECC.Parameters;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsDriveTrain
  parameter Types.Time Ht "Turbine Inertia in s (typical: 5 s)" annotation(
  Dialog(tab="Mechanical"));
  parameter Types.Time Hg "Generator Inertia in s (typical: 1 s)" annotation(
  Dialog(tab="Mechanical"));
  parameter Types.PerUnit Dshaft "Damping coefficient in pu (typical: 1.5 pu, base SNom, omegaNom)" annotation(
  Dialog(tab="Mechanical"));
  parameter Types.PerUnit Kshaft "Spring constant in pu (typical: 200 pu, base SNom, omegaNom)" annotation(
  Dialog(tab="Mechanical"));

  annotation(preferredView = text);
end ParamsDriveTrain;
