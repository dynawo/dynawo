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

  parameter Types.ReactivePowerPu Q1MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 1 (receptor convention)";
  parameter Types.ReactivePowerPu Q1MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 1 (receptor convention)";

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

protected

  QStatus q1Status (start = QStatus.Standard) "Voltage regulation status of terminal 1: standard, absorptionMax or generationMax";

equation

  s1Pu = Complex(P1Pu, Q1Pu);
  s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);

// Voltage/Reactive power regulation at terminal 1
  when Q1Pu >= Q1MaxPu and U1Pu >= U1RefPu.value then
    q1Status = QStatus.AbsorptionMax;
  elsewhen Q1Pu <= Q1MinPu and U1Pu <= U1RefPu.value then
    q1Status = QStatus.GenerationMax;
  elsewhen (Q1Pu < Q1MaxPu or U1Pu < U1RefPu.value) and (Q1Pu > Q1MinPu or U1Pu > U1RefPu.value) then
    q1Status = QStatus.Standard;
  end when;

  if running.value then
    if modeU1.value then
      if q1Status == QStatus.GenerationMax then
        Q1Pu = Q1MinPu;
      elseif q1Status == QStatus.AbsorptionMax then
        Q1Pu = Q1MaxPu;
      else
        U1Pu = U1RefPu.value;
      end if;
    else
      if Q1RefPu.value <= Q1MinPu then
        Q1Pu = Q1MinPu;
      elseif Q1RefPu.value >= Q1MaxPu then
        Q1Pu = Q1MaxPu;
      else
        Q1Pu = Q1RefPu.value;
      end if;
    end if;
  else
    terminal1.i.im = 0;
  end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This HVDC link regulates the active power flowing through itself. It also regulates the voltage or the reactive power at terminal1. The active power setpoint is given as an input and can be modified during the simulation, as well as the voltage reference and the reactive power reference. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPVDangling;
