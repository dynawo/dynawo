within Dynawo.Electrical.HVDC.HvdcPTanPhi;

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

model HvdcPTanPhiDangling "Model for P/tan(Phi) HVDC link with terminal2 connected to a switched-off bus"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDangling;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

  Connectors.ZPin tanPhi1Ref (value (start = s10Pu.im/s10Pu.re)) "tan(Phi) regulation set point at terminal 1";

protected

  Types.ReactivePowerPu Q1RawPu (start = s10Pu.im) "Raw reactive power at terminal 1 in p.u (base SnRef)";

equation

// Reactive power control of the connected side
  Q1RawPu = tanPhi1Ref.value * P1Pu;
  if Q1RawPu >= Q1MaxPu then
   Q1Pu = Q1MaxPu;
  elseif Q1RawPu <= Q1MinPu then
   Q1Pu = Q1MinPu;
  else
   Q1Pu = Q1RawPu;
  end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at terminal1. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPTanPhiDangling;
