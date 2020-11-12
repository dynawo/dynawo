within Dynawo.Electrical.HVDC.HvdcPV;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPVDangling "Model for PV HVDC link with terminal2 connected to a switched-off bus"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDangling;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

  Connectors.ZPin U1RefPu (value (start = ComplexMath.'abs'(u10Pu))) "Voltage regulation set point in p.u (base UNom) at terminal 1";

equation

// Voltage control of the connected side
  if Q1Pu >= Q1MaxPu then
   Q1Pu = Q1MaxPu;
  elseif Q1Pu <= Q1MinPu then
   Q1Pu = Q1MinPu;
  else
   U1Pu = U1RefPu.value;
  end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This HVDC link regulates the active power flowing through itself. It also regulates the voltage at terminal1. The active power setpoint is given as an input and can be modified during the simulation, as well as the voltage reference. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPVDangling;
