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

  parameter Real QPercent1 "Percentage of the coordinated reactive control that comes from converter 1";

  input Types.ReactivePowerPu Q1RefPu(start = Q1Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";
  input Boolean modeU1(start = modeU10) "Boolean assessing the mode of the control of converter 1: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
  input Types.PerUnit NQ1 "Signal to change the reactive power of converter 1 depending on the centralized voltage regulation (generator convention)";

  parameter Types.ReactivePowerPu Q1Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";
  parameter Boolean modeU10 "Start value of the boolean assessing the mode of the control of converter 1";

protected
  Types.ReactivePowerPu QInj1RawModeUPu(start = - s10Pu.im) "Reactive power generation of converter 1 without taking limits into account in pu and for mode U activated (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj1RawPu(start = - s10Pu.im) "Reactive power generation of converter 1 without taking limits into account in pu (base SnRef) (generator convention)";

equation
  s1Pu = Complex(P1Pu, Q1Pu);
  s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);
  QInj1RawModeUPu = - Q1RefPu + QPercent1 * NQ1;
  QInj1RawPu = if modeU1 then QInj1RawModeUPu else - Q1RefPu;

  if runningSide1.value then
    //Reactive power regulation at terminal 1
    if QInj1RawPu <= QInj1MinPu then
      QInj1Pu = QInj1MinPu;
    elseif QInj1RawPu >= QInj1MaxPu then
      QInj1Pu = QInj1MaxPu;
    else
      QInj1Pu = QInj1RawPu;
    end if;
  else
    terminal1.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the reactive power at terminal1 (with a fixed Q reference or a proportional regulation). The active power setpoint is given as an input and can be modified during the simulation, as well as the reactive power reference of terminal1. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPQPropDanglingDiagramPQ;
