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

record ParametersIEEET1

  type genFramePreset = enumeration(g10118, g10121) "Generator Names";
  type exciterParamNames = enumeration(Tr, Ka, Ta, URegMaxPu, URegMinPu, Ke, Te, Kf, Tf, e1, s1, e2, s2) "Parameter Names";

  // Tr, Ka, Ta, URegMax, URegMin, Ke, Te, Kf, Tf, e1, s1, e2, s2
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {1e-5, 400, 0.04, 7.3, -7.3, 1, 0.8, 0.03, 1, 3.375, 0.035, 4.5, 0.47},
    {1e-5, 400, 0.04, 7.3, -7.3, 1, 0.8, 0.03, 1, 3.375, 0.035, 4.5, 0.47}
  };

end ParametersIEEET1;
