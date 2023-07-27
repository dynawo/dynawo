within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.BaseClasses_INIT;

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

model BasePss_INIT "Initialization base model for power system stabilizers"
  extends AdditionalIcons.Init;

  Types.ActivePowerPu PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end BasePss_INIT;
