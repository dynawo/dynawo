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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPTanPhiDiagramPQ "Model for P/tan(Phi) HVDC link with a PQ diagram"
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseHvdcPDiagramPQ;
  extends Dynawo.Electrical.HVDC.BaseClasses.BasePTanPhi(QInj1RawPu(start = - s10Pu.im), QInj2RawPu(start = - s20Pu.im));

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

equation
  QInj1RawPu = tanPhi1Ref * PInj1Pu;
  QInj2RawPu = tanPhi2Ref * PInj2Pu;

  if running.value then
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
    QInj1Pu = 0;
    QInj2Pu = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at each of its terminal. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint. The reactive power limits are given by a PQ diagram.</div></body></html>"));
end HvdcPTanPhiDiagramPQ;
