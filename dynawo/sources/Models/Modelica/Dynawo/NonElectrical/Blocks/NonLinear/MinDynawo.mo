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
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block MinDynawo "Implement a min"
  extends Modelica.Blocks.Interfaces.SI2SO;

equation
  if u1 < u2 then
    y = u1;
  else
    y = u2;
  end if;

  annotation(preferredView = "text");
end MinDynawo;
