within Dynawo.Electrical.Controls.Machines.Protections;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model LHVRT_INIT "High and low voltage ride-through initialization model"
  extends AdditionalIcons.Init;

  Types.VoltageModulePu UMonitored0Pu "Initial monitored voltage amplitude in pu (base UNom)";

  annotation(preferredView = "text");
end LHVRT_INIT;
