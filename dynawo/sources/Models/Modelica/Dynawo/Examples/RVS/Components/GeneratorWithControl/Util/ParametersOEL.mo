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

record ParametersOEL

  type oelFramePreset = enumeration(all) "OEL Preset Names";
  type oelParamNames = enumeration(Kmx, ULowPu, T1, T2, T3, E1, E2, E3) "Parameter Names";

  // Kmx, ULowPu, T1, T2, T3, E1, E2, E3
  final constant Real[oelFramePreset, oelParamNames] oelParamValues = {
    {0.2, -0.05, 60, 30, 15, 1.1, 1.2, 1.5}
  };

end ParametersOEL;
