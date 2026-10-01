within Dynawo.Electrical.StaticVarCompensators.BaseControls.Parameters;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsLimitations

  parameter Types.PerUnit BMaxPu "Maximum value for the variable susceptance in pu (base UNom, SNom)";
  parameter Types.PerUnit BMinPu "Minimum value for the variable susceptance in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMaxPu "Maximum value for the current in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMinPu "Minimum value for the current in pu (base UNom, SNom)";
  parameter Types.PerUnit KCurrentLimiter "Integral gain of current limiter";

  annotation(preferredView = "text");
end ParamsLimitations;
