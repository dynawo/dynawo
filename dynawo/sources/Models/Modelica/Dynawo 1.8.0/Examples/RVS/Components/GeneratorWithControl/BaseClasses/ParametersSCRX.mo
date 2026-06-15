within Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses;

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

record ParametersSCRX "Parameter sets for the SCRX regulations of the RVS test system"

  type genFramePreset = enumeration(g10107, g20107, g30107, g10113, g20113, g30113, g10115, g20115, g30115, g40115, g50115, g60115, g10116, g10122, g20122, g30122, g40122, g50122, g60122, g10123, g20123, g30123) "Generator names";
  type exciterParamNames = enumeration(tA, tB, K, tE, VrMinPu, VrMaxPu) "Parameter names";

  // tA, tB, K, tE, VrMinPu, VrMaxPu
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4}
  } "Matrix of SCRX parameters";

  annotation(preferredView = "text");
end ParametersSCRX;
