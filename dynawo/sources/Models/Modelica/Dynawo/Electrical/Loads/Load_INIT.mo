within Dynawo.Electrical.Loads;

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

model Load_INIT "Initialization for load from load-flow outputs"

  extends BaseClasses_INIT.BaseLoadInterfaceParameters_INIT;
  extends BaseClasses_INIT.BaseLoadInterfaceVariables_INIT;

  public
    parameter Types.AC.VoltageModule U0Pu  "Start value of voltage amplitude at load terminal in p.u (base UNom)";
    parameter SIunits.Angle UPhase0  "Start value of voltage angle at load terminal (in rad)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

end Load_INIT;
