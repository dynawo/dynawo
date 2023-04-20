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

record ParametersEXAC

  type genFramePreset = enumeration(g10101, g20101, g30101, g40101, g10102, g20102, g30102, g40102) "Generator Names";
  type exciterParamNames = enumeration(Tr, Tb, Tc, Ka, Ta, VrMax, VrMin, Te, Kf, Tf, Kc, Kd, Ke, e1, s1, e2, s2) "Parameter Names";

  // Tr, Tb, Tc, Ka, Ta, VrMax, VrMin, Te, Kf, Tf, Kc, Kd, Ke, e1, s1, e2, s2
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1}
  };

end ParametersEXAC;
