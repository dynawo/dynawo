within Dynawo.Electrical.HVDC.BaseClasses;

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

partial model BaseHvdcPDangling "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus"
  extends BaseHvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

equation
  //Connected side
  if runningSide1.value then
    P1Pu = max(min(PMaxPu, P1RefPu), - PMaxPu);
    U1Pu = ComplexMath.abs(terminal1.V);
  else
    P1Pu = 0;
    U1Pu = 0;
  end if;

  //Disconnected side
  P2Pu = 0;
  Q2Pu = 0;
  terminal2.i.re = 0;
  terminal2.i.im = 0;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end BaseHvdcPDangling;
