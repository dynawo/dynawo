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

model HvdcPVDiagramPQ "Model of PV HVDC link with a PQ diagram. Each terminal can regulate the voltage or the reactive power, depending on the user's choice."
  import Modelica;
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDiagramPQ;
  extends HVDC.BaseClasses.BaseQStatus;
  extends HVDC.BaseClasses.BaseVoltageRegulation;
  extends HVDC.BaseClasses.BasePV(QInj1PuQNom(start = - s10Pu.im * SystemBase.SnRef / Q1Nom), QInj2PuQNom(start = - s20Pu.im * SystemBase.SnRef / Q2Nom));

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

equation
  QInj1PuQNom = QInj1Pu * SystemBase.SnRef / Q1Nom;
  QInj2PuQNom = QInj2Pu * SystemBase.SnRef / Q2Nom;

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

  when QInj2Pu >= QInj2MaxPu and U2Pu + Lambda2Pu * QInj2Pu <= U2RefPu then
    q2Status = QStatus.GenerationMax;
    limUQDown2 = false;
    limUQUp2 = true;
  elsewhen QInj2Pu <= QInj2MinPu and U2Pu + Lambda2Pu * QInj2Pu >= U2RefPu then
    q2Status = QStatus.AbsorptionMax;
    limUQDown2 = true;
    limUQUp2 = false;
  elsewhen (QInj2Pu < QInj2MaxPu or U2Pu + Lambda2Pu * QInj2Pu > U2RefPu) and (QInj2Pu > QInj2MinPu or U2Pu + Lambda2Pu * QInj2Pu < U2RefPu) then
    q2Status = QStatus.Standard;
    limUQDown2 = false;
    limUQUp2 = false;
  end when;

  //Voltage/Reactive power regulation at terminal 1
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
    QInj1Pu = 0;
  end if;

  //Voltage/Reactive power regulation at terminal 2
  if runningSide2.value then
    if modeU2 then
      if q2Status == QStatus.GenerationMax then
        QInj2Pu = QInj2MaxPu;
      elseif q2Status == QStatus.AbsorptionMax then
        QInj2Pu = QInj2MinPu;
      else
        if UseLambda2 then
          U2Pu + Lambda2Pu * QInj2Pu = U2RefPu;
        else
          U2Pu = U2RefPu;
        end if;
      end if;
    else
      if - Q2RefPu <= QInj2MinPu then
        QInj2Pu = QInj2MinPu;
      elseif - Q2RefPu >= QInj2MaxPu then
        QInj2Pu = QInj2MaxPu;
      else
        Q2Pu = Q2RefPu;
      end if;
    end if;
  else
    QInj2Pu = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the voltage or the reactive power at each of its terminals. The active power setpoint is given as an input and can be modified during the simulation, as well as the voltage references and the reactive power references. The Q limitations follow a PQ diagram.</div></body></html>"));
end HvdcPVDiagramPQ;
