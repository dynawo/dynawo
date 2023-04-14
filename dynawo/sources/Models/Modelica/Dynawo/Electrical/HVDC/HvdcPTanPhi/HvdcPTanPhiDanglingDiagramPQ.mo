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

model HvdcPTanPhiDanglingDiagramPQ "Model for P/tan(Phi) HVDC link with a PQ diagram and with terminal2 connected to a switched-off bus"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDanglingDiagramPQ;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

  input Real tanPhi1Ref(start = TanPhi1Ref0) "tan(Phi) regulation set point at terminal 1";

  parameter Real TanPhi1Ref0 "Start value of tan(Phi) regulation set point at terminal 1";

protected
  Types.ReactivePowerPu QInj1RawPu(start = - s10Pu.im) "Raw reactive power at terminal 1 in pu (base SnRef) (generator convention)";

equation
  //Reactive power control of the connected side
  QInj1RawPu = tanPhi1Ref * PInj1Pu;
  if runningSide1.value then
    if QInj1RawPu >= QInj1MaxPu then
     QInj1Pu = QInj1MaxPu;
    elseif QInj1RawPu <= QInj1MinPu then
     QInj1Pu = QInj1MinPu;
    else
     QInj1Pu = QInj1RawPu;
    end if;
  else
    terminal1.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at terminal1. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPTanPhiDanglingDiagramPQ;
