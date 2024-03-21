within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;

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

model Pss2a "IEEE power system stabilizer type 2A"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.Pss2c(
    PPssOffPu = -1000,
    PPssOnPu = -999,
    t10 = 0,
    t11 = 0,
    t12 = 0,
    t13 = 0);

  annotation(preferredView = "diagram");
end Pss2a;
