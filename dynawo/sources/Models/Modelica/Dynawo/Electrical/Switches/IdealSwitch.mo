within Dynawo.Electrical.Switches;

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

model IdealSwitch "Ideal switch"
  /*
    When the switch is closed, the voltage on both terminals are equal and the current is going through the switch.
    When the switch is open, the current going through the switch is equal to zero.

    Equivalent circuit and conventions:

               I1                  I2
    (terminal1) -->-------/ -------<-- (terminal2)

  */

  import Dynawo.Connectors;

  Connectors.ACPower terminal1 "Switch side 1";
  Connectors.ACPower terminal2 "Switch side 2";
  Connectors.BPin closed (value(start = true)) "True when the switch is closed, false otherwise";

equation

  // When the switch is closed, V and i are equal on both sides. Otherwise, the currents are zero.
  if (closed.value) then
    terminal1.V = terminal2.V;
    terminal1.i = - terminal2.i;
  else
    terminal1.i = Complex(0);
    terminal2.i = Complex(0);
  end if;

end IdealSwitch;
