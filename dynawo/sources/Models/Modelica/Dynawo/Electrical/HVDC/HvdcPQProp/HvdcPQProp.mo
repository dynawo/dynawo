within Dynawo.Electrical.HVDC.HvdcPQProp;

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

model HvdcPQProp "Model of HVDC link with a proportional reactive power control. Each terminal can inject a fixed reactive power or use the proportional control, depending on the user's choice."
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseHvdcPFixedReactiveLimits;
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseQStatus;
  extends Dynawo.Electrical.HVDC.BaseClasses.BasePQProp(QInj1RawModeUPu(start = - s10Pu.im), QInj2RawModeUPu(start = - s20Pu.im), QInj1RawPu(start = - s10Pu.im), QInj2RawPu(start = - s20Pu.im));
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseVoltageRegulation;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

equation
  QInj1RawModeUPu = - Q1RefPu + QPercent1 * NQ1;
  QInj2RawModeUPu = - Q2RefPu + QPercent2 * NQ2;
  QInj1RawPu = if modeU1 then QInj1RawModeUPu else - Q1RefPu;
  QInj2RawPu = if modeU2 then QInj2RawModeUPu else - Q2RefPu;

  // Reactive power regulation at terminal 1
  if runningSide1.value then
    if QInj1RawPu <= Q1MinPu then
      QInj1Pu = Q1MinPu;
    elseif QInj1RawPu >= Q1MaxPu then
      QInj1Pu = Q1MaxPu;
    else
      QInj1Pu = QInj1RawPu;
    end if;
  else
    QInj1Pu = 0;
  end if;

  when QInj1RawPu <= Q1MinPu then
    q1Status = QStatus.AbsorptionMax;
    limUQDown1 = true;
    limUQUp1 = false;
  elsewhen QInj1RawPu >= Q1MaxPu then
    q1Status = QStatus.GenerationMax;
    limUQDown1 = false;
    limUQUp1 = true;
  elsewhen QInj1RawPu > Q1MinPu and QInj1RawPu < Q1MaxPu then
    q1Status = QStatus.Standard;
    limUQDown1 = false;
    limUQUp1 = false;
  end when;

  // Reactive power regulation at terminal 2
  if runningSide2.value then
    if QInj2RawPu <= Q2MinPu then
      QInj2Pu = Q2MinPu;
    elseif QInj2RawPu >= Q2MaxPu then
      QInj2Pu = Q2MaxPu;
    else
      QInj2Pu = QInj2RawPu;
    end if;
  else
    QInj2Pu = 0;
  end if;

  when QInj2RawPu <= Q2MinPu then
    q2Status = QStatus.AbsorptionMax;
    limUQDown2 = true;
    limUQUp2 = false;
  elsewhen QInj2RawPu >= Q2MaxPu then
    q2Status = QStatus.GenerationMax;
    limUQDown2 = false;
    limUQUp2 = true;
  elsewhen QInj2RawPu > Q2MinPu and QInj2RawPu < Q2MaxPu then
    q2Status = QStatus.Standard;
    limUQDown2 = false;
    limUQUp2 = false;
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the reactive power at each of its terminals (with a fixed Q reference or a proportional regulation). The active power setpoint is given as an input and can be modified during the simulation, as well as the reactive power references.</div></body></html>"));
end HvdcPQProp;
