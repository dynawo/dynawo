within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PSS2A_INIT "IEEE Power System Stabilizer type PSS2A initialization model"

  extends AdditionalIcons.Init;

  Types.ActivePowerPu PGen0Pu "Initial active power input in p.u (base SnRef) - generator convention";

  annotation(
    preferredView = "text",
    uses(Modelica(version = "3.2.3")));

end PSS2A_INIT;
