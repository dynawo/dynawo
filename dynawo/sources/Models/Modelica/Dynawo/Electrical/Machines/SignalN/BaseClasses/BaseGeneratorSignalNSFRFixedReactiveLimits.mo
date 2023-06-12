within Dynawo.Electrical.Machines.SignalN.BaseClasses;

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

partial model BaseGeneratorSignalNSFRFixedReactiveLimits "Base dynamic model for generators based on SignalN for the frequency handling with fixed reactive limits and that participate in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGeneratorSignalNSFR;
  extends BaseClasses.BaseFixedReactiveLimits;

  annotation(preferredView = "text");
end BaseGeneratorSignalNSFRFixedReactiveLimits;
