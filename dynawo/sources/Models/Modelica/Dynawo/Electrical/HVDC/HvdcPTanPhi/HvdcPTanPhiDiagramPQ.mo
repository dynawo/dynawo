within Dynawo.Electrical.HVDC.HvdcPTanPhi;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPTanPhiDiagramPQ "Model for P/tan(Phi) HVDC link with a PQ diagram"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDiagramPQ;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  Connectors.ZPin tanPhi1Ref (value (start = s10Pu.im/s10Pu.re)) "tan(Phi) regulation set point at terminal 1";
  Connectors.ZPin tanPhi2Ref (value (start = s20Pu.im/s20Pu.re)) "tan(Phi) regulation set point at terminal 2";

protected

  Types.ReactivePowerPu QInj1RawPu (start = - s10Pu.im) "Raw reactive power at terminal 1 in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj2RawPu (start = - s20Pu.im) "Raw reactive power at terminal 2 in pu (base SnRef) (generator convention)";

equation

  QInj1RawPu = tanPhi1Ref.value * PInj1Pu;
  QInj2RawPu = tanPhi2Ref.value * PInj2Pu;

if (running.value) then

  if QInj1RawPu >= QInj1MaxPu then
   QInj1Pu = QInj1MaxPu;
  elseif QInj1RawPu <= QInj1MinPu then
   QInj1Pu = QInj1MinPu;
  else
   QInj1Pu = QInj1RawPu;
  end if;

  if QInj2RawPu >= QInj2MaxPu then
   QInj2Pu = QInj2MaxPu;
  elseif QInj2RawPu <= QInj2MinPu then
   QInj2Pu = QInj2MinPu;
  else
   QInj2Pu = QInj2RawPu;
  end if;

else

  terminal1.i.im = 0;
  terminal2.i.im = 0;

end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at each of its terminal. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint.</div></body></html>"));
end HvdcPTanPhiDiagramPQ;
