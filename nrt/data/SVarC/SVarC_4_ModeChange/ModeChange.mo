/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ModeChange

  Integer setModeManual(start = 3);
  Boolean selectModeAuto(start = true);

equation

  when time >= 0.5 then
    selectModeAuto = false;
  elsewhen time >= 5 then
    selectModeAuto = true;
  end when;

  when time >= 3 then
    setModeManual = 1;
  elsewhen time >= 4 then
    setModeManual = 3;
  end when;

end ModeChange;
