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

model HvdcPTanPhiDanglingDiagramPQ "Model for P/tan(Phi) HVDC link with a PQ diagram and with terminal2 connected to a switched-off bus"
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseHvdcPDanglingDiagramPQ;
  extends Dynawo.Electrical.HVDC.BaseClasses.BasePTanPhiDangling(QInj1RawPu(start = - s10Pu.im));

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

equation
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
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at terminal1. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint. The terminal2 is connected to a switched-off bus. The reactive power limits are given by a PQ diagram.</div></body></html>"));
end HvdcPTanPhiDanglingDiagramPQ;
