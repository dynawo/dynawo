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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPQPropDangling "Model of HVDC link with a proportional reactive power control. terminal1 can inject a fixed reactive power or use the proportional control, depending on the user's choice. terminal2 is connected to a switched-off bus"
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseHvdcPDanglingFixedReactiveLimits;
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseQStatusDangling;
  extends Dynawo.Electrical.HVDC.BaseClasses.BasePQPropDangling(QInj1RawModeUPu(start = - s10Pu.im), QInj1RawPu(start = - s10Pu.im));
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseVoltageRegulationDangling;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

equation
  QInj1RawModeUPu = - Q1RefPu + QPercent1 * NQ1;
  QInj1RawPu = if modeU1 then QInj1RawModeUPu else - Q1RefPu;

  //Reactive power regulation at terminal 1
  if runningSide1.value then
    if QInj1RawPu <= Q1MinPu then
      QInj1Pu = Q1MinPu;
    elseif QInj1RawPu >= Q1MaxPu then
      QInj1Pu = Q1MaxPu;
    else
      QInj1Pu = QInj1RawPu;
    end if;
  else
    terminal1.i.im = 0;
  end if;


  when QInj1RawPu <= Q1MinPu then
    q1Status = QStatus.AbsorptionMax;
    limUQDown1 = true;
    limUQUp1 = false;
  elsewhen QInj1RawPu >= Q1MaxPu then
    q1Status = QStatus.GenerationMax;
    limUQDown1 = false;
    limUQUp1 = true;
  elsewhen not modeU1 then
    q1Status = QStatus.Standard;
    limUQDown1 = true;
    limUQUp1 = true;
  elsewhen QInj1RawPu > Q1MinPu and QInj1RawPu < Q1MaxPu then
    q1Status = QStatus.Standard;
    limUQDown1 = false;
    limUQUp1 = false;
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the reactive power at terminal1 (with a fixed Q reference or a proportional regulation). The active power setpoint is given as an input and can be modified during the simulation, as well as the reactive power reference of terminal1. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPQPropDangling;
