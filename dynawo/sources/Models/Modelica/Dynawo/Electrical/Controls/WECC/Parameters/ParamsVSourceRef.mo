within Dynawo.Electrical.Controls.WECC.Parameters;

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

record ParamsVSourceRef
  parameter Types.Time tE "Emulated delay in converter controls in s (cannot be zero, typical: 0.02..0.05)";
  parameter Types.PerUnit RSourcePu "Source resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XSourcePu "Source reactance in pu (base UNom, SNom)";

  annotation(preferredView = "text");
end ParamsVSourceRef;
