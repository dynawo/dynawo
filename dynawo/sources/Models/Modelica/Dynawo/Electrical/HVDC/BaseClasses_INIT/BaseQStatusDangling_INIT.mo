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

partial model BaseQStatusDangling_INIT "Base initialization model for QStatus at terminal 1"

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  Boolean limUQDown10 "Whether the minimum reactive power limits are reached or not at terminal 1, start value";
  Boolean limUQUp10 "Whether the maximum reactive power limits are reached or not at terminal 1, start value";
  QStatus q1Status0 "Start voltage regulation status of terminal 1: Standard, AbsorptionMax, GenerationMax";

equation
  limUQDown10 = q1Status0 == QStatus.AbsorptionMax;
  limUQUp10 = q1Status0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseQStatusDangling_INIT;
