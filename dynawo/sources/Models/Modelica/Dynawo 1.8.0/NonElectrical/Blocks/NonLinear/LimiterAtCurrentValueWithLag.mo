within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

block LimiterAtCurrentValueWithLag "Limiter that enforces saturations only after they were violated without interruption during a given amount of time, the lower saturation value being its current value"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseLimiterWithLag;

equation
  if (time - tUMinReached >= LagMin) then
    der(y) = 0;
  elseif (time - tUMaxReached >= LagMax) then
    y= UMax;
  else
    y = u;
  end if;

  annotation(preferredView = "text");
end LimiterAtCurrentValueWithLag;
