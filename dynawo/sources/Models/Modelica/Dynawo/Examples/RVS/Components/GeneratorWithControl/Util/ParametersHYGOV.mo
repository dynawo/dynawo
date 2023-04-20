within Dynawo.Examples.RVS.Components.GeneratorWithControl.Util;

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

record ParametersHYGOV

  type genFramePreset = enumeration(g10122, g20122, g30122, g40122, g50122, g60122) "Generator Names";
  type exciterParamNames = enumeration(R, r, Tr, Tf, Tg, Velm, GMax, GMin, Tw, At, DTurb, qNL) "Parameter Names";

  // R, r, Tr, Tf, Tg, VElm, GMax, GMin, Tw, At, Dturb, qNL
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08}
  };

end ParametersHYGOV;
