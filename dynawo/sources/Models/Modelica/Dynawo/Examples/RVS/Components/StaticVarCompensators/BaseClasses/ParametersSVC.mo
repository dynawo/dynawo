within Dynawo.Examples.RVS.Components.StaticVarCompensators.BaseClasses;

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

record ParametersSVC "Parameter sets for the static VAR compensators of the RVS test system"

  type svcFramePreset = enumeration(sVarC_10106, sVarC_10114) "SVarC names";
  type svcParamNames = enumeration(UOvPu, BShuntPu, BMin, BMax, VMin, VMax, K, t3, t5) "Generator parameters";

  // UOvPu, BShuntPu, BMin, BMax, VMin, VMax, K, t3, t5
  final constant Real[svcFramePreset, svcParamNames] svcParamValues = {
    {0.5, 0, -50, 100, -50, 100, 150 * 150, 3.45, 0.3}, //K is multiplied by susceptance range
    {0.5, 0, -50, 200, -50, 200, 150 * 250, 3.55, 0.3}  //K is multiplied by susceptance range
  } "Matrix of static var compensator parameters";

end ParametersSVC;
