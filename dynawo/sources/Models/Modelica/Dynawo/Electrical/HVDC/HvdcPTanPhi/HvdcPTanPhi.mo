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
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HvdcPTanPhi "Model for P/tan(Phi) HVDC link"
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  import Dynawo.Electrical.HVDC;
  extends HVDC.BaseClasses.BaseHvdcP;

  Connectors.ZPin tanPhi1Ref (value (start = s10Pu.im/s10Pu.re)) "tan(Phi) regulation set point at terminal 1";
  Connectors.ZPin tanPhi2Ref (value (start = s20Pu.im/s20Pu.re)) "tan(Phi) regulation set point at terminal 2";

protected

  Types.ReactivePowerPu Q1RawPu (start = s10Pu.im) "Raw reactive power at terminal 1 in p.u (base SnRef)";
  Types.ReactivePowerPu Q2RawPu (start = s20Pu.im) "Raw reactive power at terminal 2 in p.u (base SnRef)";

equation

  Q1RawPu = tanPhi1Ref.value * P1Pu;
  Q2RawPu = tanPhi2Ref.value * P2Pu;

if (running.value) then

  if Q1RawPu >= Q1MaxPu then
   Q1Pu = Q1MaxPu;
  elseif Q1RawPu <= Q1MinPu then
   Q1Pu = Q1MinPu;
  else
   Q1Pu = Q1RawPu;
  end if;

  if Q2RawPu >= Q2MaxPu then
   Q2Pu = Q2MaxPu;
  elseif Q2RawPu <= Q2MinPu then
   Q2Pu = Q2MinPu;
  else
   Q2Pu = Q2RawPu;
  end if;

else

  Q1Pu = 0;
  Q2Pu = 0;

end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at each of its terminal. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint.</div></body></html>"));
end HvdcPTanPhi;
