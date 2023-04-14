within Dynawo.Electrical.HVDC.HvdcPV;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPVDangling "Model for PV HVDC link with terminal2 connected to a switched-off bus"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDangling;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  parameter Types.ReactivePowerPu Q1MaxPu "Maximum reactive power in pu (base SnRef) at terminal 1 (receptor convention)";
  parameter Types.ReactivePowerPu Q1MinPu "Minimum reactive power in pu (base SnRef) at terminal 1 (receptor convention)";

  input Boolean modeU1(start = modeU10) "Boolean assessing the mode of the control: true if U mode, false if Q mode";
  input Types.ReactivePowerPu Q1RefPu(start = Q1Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";
  input Types.VoltageModulePu U1RefPu(start = U1Ref0Pu) "Voltage regulation set point in pu (base UNom) at terminal 1";

  parameter Boolean modeU10 "Start value of the boolean assessing the mode of the control at terminal 1: true if U mode, false if Q mode";
  parameter Types.ReactivePowerPu Q1Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";
  parameter Types.VoltageModulePu U1Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

protected
  QStatus q1Status(start = QStatus.Standard) "Voltage regulation status of terminal 1: standard, absorptionMax or generationMax";

equation
  //Voltage/Reactive power regulation at terminal 1
  when Q1Pu >= Q1MaxPu and U1Pu >= U1RefPu then
    q1Status = QStatus.AbsorptionMax;
  elsewhen Q1Pu <= Q1MinPu and U1Pu <= U1RefPu then
    q1Status = QStatus.GenerationMax;
  elsewhen (Q1Pu < Q1MaxPu or U1Pu < U1RefPu) and (Q1Pu > Q1MinPu or U1Pu > U1RefPu) then
    q1Status = QStatus.Standard;
  end when;

  if runningSide1.value then
    if modeU1 then
      if q1Status == QStatus.GenerationMax then
        Q1Pu = Q1MinPu;
      elseif q1Status == QStatus.AbsorptionMax then
        Q1Pu = Q1MaxPu;
      else
        U1Pu = U1RefPu;
      end if;
    else
      if Q1RefPu <= Q1MinPu then
        Q1Pu = Q1MinPu;
      elseif Q1RefPu >= Q1MaxPu then
        Q1Pu = Q1MaxPu;
      else
        Q1Pu = Q1RefPu;
      end if;
    end if;
  else
    terminal1.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This HVDC link regulates the active power flowing through itself. It also regulates the voltage or the reactive power at terminal1. The active power setpoint is given as an input and can be modified during the simulation, as well as the voltage reference and the reactive power reference. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPVDangling;
