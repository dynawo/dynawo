within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

block Min3 "Pass through the smallest of three signals, with an event generated when a switch occurs"
  extends Modelica.Blocks.Interfaces.MISO(nin = 3);

equation
  if u[1] < u[2] and u[1] < u[3] then
    y = u[1];
  elseif u[2] < u[1] and u[2] < u[3] then
    y = u[2];
  else
    y = u[3];
  end if;

  annotation(preferredView = "text");
end Min3;
