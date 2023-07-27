within Dynawo.Electrical.HVDC.HvdcPTanPhi;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

  extends HVDC.BaseClasses.BaseHvdcPDanglingFixedReactiveLimits;
  extends HVDC.BaseClasses.BasePTanPhiDangling(QInj1RawPu(start = - s10Pu.im));

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

equation
  QInj1RawPu = tanPhi1Ref * PInj1Pu;

  if runningSide1.value then
    if QInj1RawPu >= Q1MaxPu then
     QInj1Pu = Q1MaxPu;
    elseif QInj1RawPu <= Q1MinPu then
     QInj1Pu = Q1MinPu;
    else
     QInj1Pu = QInj1RawPu;
    end if;
  else
    terminal1.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at terminal1. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPTanPhiDangling;
