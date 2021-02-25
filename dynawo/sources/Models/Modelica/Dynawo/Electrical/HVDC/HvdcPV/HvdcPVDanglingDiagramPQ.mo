within Dynawo.Electrical.HVDC.HvdcPV;

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

model HvdcPVDanglingDiagramPQ "Model for PV HVDC link with a PQ diagram and terminal2 connected to a switched-off bus"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDanglingDiagramPQ;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

  Connectors.ZPin U1RefPu (value (start = ComplexMath.'abs'(u10Pu))) "Voltage regulation set point in p.u (base UNom) at terminal 1";
  Connectors.ZPin Q1RefPu (value (start = s10Pu.im)) "Reactive power regulation set point in p.u (base SnRef) (receptor convention) at terminal 1";
  Connectors.BPin modeU1 (value (start = modeU10)) "Boolean assessing the mode of the control: true if U mode, false if Q mode";

  parameter Boolean modeU10 "Start value of the boolean assessing the mode of the control at terminal 1: true if U mode, false if Q mode";

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

protected

  QStatus q1Status (start = QStatus.Standard) "Voltage regulation status of terminal 1: standard, absorptionMax or generationMax";

equation

// Voltage/Reactive power regulation at terminal 1
  when QInj1Pu >= QInj1MaxPu and U1Pu <= U1RefPu.value then
    q1Status = QStatus.GenerationMax;
  elsewhen QInj1Pu <= QInj1MinPu and U1Pu >= U1RefPu.value then
    q1Status = QStatus.AbsorptionMax;
  elsewhen (QInj1Pu < QInj1MaxPu or U1Pu > U1RefPu.value) and (QInj1Pu > QInj1MinPu or U1Pu < U1RefPu.value) then
    q1Status = QStatus.Standard;
  end when;

  if running.value then
    if modeU1.value then
      if q1Status == QStatus.GenerationMax then
        QInj1Pu = QInj1MaxPu;
      elseif q1Status == QStatus.AbsorptionMax then
        QInj1Pu = QInj1MinPu;
      else
        U1Pu = U1RefPu.value;
      end if;
    else
      if - Q1RefPu.value <= QInj1MinPu then
        QInj1Pu = QInj1MinPu;
      elseif - Q1RefPu.value >= QInj1MaxPu then
        QInj1Pu = QInj1MaxPu;
      else
        Q1Pu = Q1RefPu.value;
      end if;
    end if;
  else
    terminal1.i.im = 0;
  end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This HVDC link regulates the active power flowing through itself. It also regulates the voltage or the reactive power at terminal1. The active power setpoint is given as an input and can be modified during the simulation, as well as the voltage reference and the reactive power reference. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPVDanglingDiagramPQ;
