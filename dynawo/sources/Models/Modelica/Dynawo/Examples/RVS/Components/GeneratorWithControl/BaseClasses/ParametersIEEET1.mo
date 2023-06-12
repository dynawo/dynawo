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

record ParametersIEEET1 "Parameter sets for the IEEET1 regulations of the RVS test system"

  type genFramePreset = enumeration(g10118, g10121) "Generator names";
  type exciterParamNames = enumeration(tR, Ka, tA, EfdRawMaxPu, EfdRawMinPu, Ke, tE, Kf, tF,EfdLowPu, EfdSatLowPu, EfdHighPu, EfdSatHighPu) "Parameter names";

  // tR, Ka, tA, EfdRawMaxPu, EfdRawMinPu, Ke, tE, Kf, tF, EfdLowPu, EfdSatLowPu, EfdHighPu, EfdSatHighPu
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {1e-5, 400, 0.04, 7.3, -7.3, 1, 0.8, 0.03, 1, 3.375, 0.035, 4.5, 0.47},
    {1e-5, 400, 0.04, 7.3, -7.3, 1, 0.8, 0.03, 1, 3.375, 0.035, 4.5, 0.47}
  } "Matrix of IEEET1 parameters";

  annotation(preferredView = "text");
end ParametersIEEET1;
