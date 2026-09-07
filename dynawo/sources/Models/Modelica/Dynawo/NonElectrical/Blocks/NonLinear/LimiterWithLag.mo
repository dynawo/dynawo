within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block LimiterWithLag "Limiter that enforces saturations only after they were violated without interruption during a given amount of time"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseLimiterWithLag;

equation
  y = if (time - tUMinReached >= LagMin) then UMin elseif (time - tUMaxReached >= LagMax) then UMax else u;

  annotation(preferredView = "text");
end LimiterWithLag;
