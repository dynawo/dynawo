within Dynawo.Electrical.Controls.Machines.Governors;

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

model Governor_INIT "Initialisation model for governor"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ActivePowerPuConnector Pm0Pu(start = 1) "Initial mechanical power in pu (base PNomTurb)";

  annotation(preferredView = "text");
end Governor_INIT;
