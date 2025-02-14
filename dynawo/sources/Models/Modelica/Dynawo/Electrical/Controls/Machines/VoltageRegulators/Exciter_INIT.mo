within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

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

model Exciter_INIT "Initialization model for exciter"
  extends AdditionalIcons.Init;

  Types.VoltageModulePuConnector Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  Types.VoltageModulePuConnector Us0Pu "Initial stator voltage in pu (base UNom)";

  annotation(preferredView = "text");
end Exciter_INIT;
