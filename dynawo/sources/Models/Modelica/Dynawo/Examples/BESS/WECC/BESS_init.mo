within Dynawo.Examples.BESS.WECC;

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

model BESS_init
  Electrical.BESS.WECC.BESS_INIT bess_init(P0Pu = -0.03, Q0Pu = 0,RPu = 0, SNom = 6, U0Pu = 1, UPhase0 = 0.00000144621, XPu = 1e-10) annotation(
    Placement(visible = true, transformation(origin = {-38, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

end BESS_init;
