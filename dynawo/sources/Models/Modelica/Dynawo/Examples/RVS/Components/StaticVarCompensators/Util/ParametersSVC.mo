within Dynawo.Examples.RVS.Components.StaticVarCompensators.Util;

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

record ParametersSVC
  import Dynawo.Electrical.SystemBase.SnRef;

  type svcFramePreset = enumeration(sVarC_10106, sVarC_10114) "SVarC Names";
  type svcParamNames = enumeration(SBase, UNom, UovPu, BShuntPu, BMin, BMax, VMin, VMax, K, T1, T2, T3, T4, T5) "Generator parameters";

  // SBase, UNom, UovPu, BShuntPu, BMin, BMax, VMin, VMax, K, T1, T2, T3, T4, T5
  final constant Real[svcFramePreset, svcParamNames] svcParamValues = {
    {1, 18, 0.5, 0, -50, 100, -50, 100, 150 * 150, 0, 0, 3.45, 0, 0.3}, //K needs to be multiplied by susceptance range
    {1, 18, 0.5, 0, -50, 200, -50, 200, 150 * 250, 0, 0, 3.55, 0, 0.3}  //K needs to be multiplied by susceptance range
  };

end ParametersSVC;
