within Dynawo.Electrical.HVDC.HvdcPV;

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

model HvdcPVDanglingDiagramPQ "Model for PV HVDC link with a PQ diagram and terminal2 connected to a switched-off bus"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDanglingDiagramPQ;
  extends HVDC.BaseClasses.BaseQStatusDangling;
  extends HVDC.BaseClasses.BaseVoltageRegulationDangling;
  extends HVDC.BaseClasses.BasePVDangling(QInj1PuQNom(start = - s10Pu.im * SystemBase.SnRef / Q1Nom));

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

equation
  QInj1PuQNom = QInj1Pu * SystemBase.SnRef / Q1Nom;

  //Voltage/Reactive power regulation at terminal 1
  when QInj1Pu >= QInj1MaxPu and U1Pu + Lambda1Pu * QInj1Pu <= U1RefPu then
    q1Status = QStatus.GenerationMax;
    limUQDown1 = false;
    limUQUp1 = true;
  elsewhen QInj1Pu <= QInj1MinPu and U1Pu + Lambda1Pu * QInj1Pu >= U1RefPu then
    q1Status = QStatus.AbsorptionMax;
    limUQDown1 = true;
    limUQUp1 = false;
  elsewhen (QInj1Pu < QInj1MaxPu or U1Pu + Lambda1Pu * QInj1Pu > U1RefPu) and (QInj1Pu > QInj1MinPu or U1Pu + Lambda1Pu * QInj1Pu < U1RefPu) then
    q1Status = QStatus.Standard;
    limUQDown1 = false;
    limUQUp1 = false;
  end when;

  if runningSide1.value then
    if modeU1 then
      if q1Status == QStatus.GenerationMax then
        QInj1Pu = QInj1MaxPu;
      elseif q1Status == QStatus.AbsorptionMax then
        QInj1Pu = QInj1MinPu;
      else
        if UseLambda1 then
          U1Pu + Lambda1Pu * QInj1Pu = U1RefPu;
        else
          U1Pu = U1RefPu;
        end if;
      end if;
    else
      if - Q1RefPu <= QInj1MinPu then
        QInj1Pu = QInj1MinPu;
      elseif - Q1RefPu >= QInj1MaxPu then
        QInj1Pu = QInj1MaxPu;
      else
        Q1Pu = Q1RefPu;
      end if;
    end if;
  else
    terminal1.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This HVDC link regulates the active power flowing through itself. It also regulates the voltage or the reactive power at terminal1. The active power setpoint is given as an input and can be modified during the simulation, as well as the voltage reference and the reactive power reference. The terminal2 is connected to a switched-off bus. The Q limitations follow a PQ diagram.</div></body></html>"));
end HvdcPVDanglingDiagramPQ;
