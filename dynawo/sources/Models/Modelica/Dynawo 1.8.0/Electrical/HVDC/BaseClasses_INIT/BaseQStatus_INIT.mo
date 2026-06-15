within Dynawo.Electrical.HVDC.BaseClasses_INIT;

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

partial model BaseQStatus_INIT "Base initialization model for QStatus"
  extends BaseClasses_INIT.BaseQStatusDangling_INIT;

  Boolean limUQDown20 "Whether the minimum reactive power limits are reached or not at terminal 2, start value";
  Boolean limUQUp20 "Whether the maximum reactive power limits are reached or not at terminal 2, start value";
  QStatus q2Status0 "Start voltage regulation status of terminal 2: Standard, AbsorptionMax, GenerationMax";

equation
  limUQDown20 = q2Status0 == QStatus.AbsorptionMax;
  limUQUp20 = q2Status0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseQStatus_INIT;
