within Dynawo.Electrical.HVDC.HvdcPQProp;

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

model HvdcPQPropDanglingDiagramPQ "Model for HVDC link with a reactive power proportional control and a PQ diagram, and with terminal2 connected to a switched-off bus"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDanglingDiagramPQ;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

  Connectors.ZPin Q1RefPu (value (start = s10Pu.im)) "Reactive power regulation set point in p.u (base SnRef) (receptor convention) at terminal 1";
  Connectors.BPin modeU1 (value (start = modeU10)) "Boolean assessing the mode of the control of converter 1: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
  Connectors.ImPin NQ1 "Signal to change the reactive power of converter 1 depending on the centralized voltage regulation";

  parameter Boolean modeU10 "Start value of the boolean assessing the mode of the control of converter 1";
  parameter Real QPercent1 "Percentage of the coordinated reactive control that comes from converter 1";

protected

  Types.ReactivePowerPu QInj1RawPu (start = - s10Pu.im) "Reactive power generation of converter 1 without taking limits into account in p.u (base SnRef) (generator convention)";

equation

  QInj1RawPu = - Q1RefPu.value + QPercent1 * NQ1.value;

if running.value then

// Reactive power regulation at terminal 1
  if modeU1.value then
    if QInj1RawPu <= QInj1MinPu then
      QInj1Pu = QInj1MinPu;
    elseif QInj1RawPu >= QInj1MaxPu then
      QInj1Pu = QInj1MaxPu;
    else
      QInj1Pu = QInj1RawPu;
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

  Q1Pu = 0;

end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the reactive power at terminal1 (with a fixed Q reference or a proportional regulation). The active power setpoint is given as an input and can be modified during the simulation, as well as the reactive power reference of terminal1. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPQPropDanglingDiagramPQ;
