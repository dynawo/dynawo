within Dynawo.Electrical.Loads;

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

model LoadPQ "Load with constant reactive/active power"
  extends BaseClasses.BaseLoad;

  // in order to change the load set-point, connect an event to PRefPu or QRefPu
  Connectors.ZPin PRefPu (value (start = s0Pu.re)) "Active power request";
  Connectors.ZPin QRefPu (value (start = s0Pu.im)) "Reactive power request";

equation
 
  if (running.value) then
    PPu = PRefPu.value;
    QPu = QRefPu.value;
  else
    PPu = 0;
    QPu = 0;
  end if;

end LoadPQ;
