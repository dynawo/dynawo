within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

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

model ExAc1_INIT "Initialization model of ExAc1"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  Types.CurrentModulePuConnector Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";

  annotation(preferredView = "true");
end ExAc1_INIT;
