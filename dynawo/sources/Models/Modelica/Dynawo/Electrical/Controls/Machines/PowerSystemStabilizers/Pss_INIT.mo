within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers;

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

model Pss_INIT "Initialization model for power system stabilizer"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end Pss_INIT;
