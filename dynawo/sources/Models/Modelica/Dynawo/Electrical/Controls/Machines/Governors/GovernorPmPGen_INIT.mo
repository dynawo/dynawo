within Dynawo.Electrical.Controls.Machines.Governors;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GovernorPmPGen_INIT "Initialisation model for governors with generated electric active power input PGenPu"
  extends AdditionalIcons.Init;

  Types.ActivePowerPuConnector PGen0Pu "Initial generated electric active power in pu (base SnRef (system base)) (generator convention)";
  Types.ActivePowerPuConnector Pm0Pu "Initial mechanical power in pu (base PNomTurb)";

  annotation(preferredView = "text");
end GovernorPmPGen_INIT;
