within Dynawo.Electrical.Buses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model Bus_INIT
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);

  annotation(preferredView = "text");
end Bus_INIT;
