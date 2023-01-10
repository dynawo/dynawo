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

model HvdcPQPropDiagramPQ "Model of HVDC link with a proportional reactive power control and a PQ diagram. Each terminal can inject a fixed reactive power or use the proportional control, depending on the user's choice."
  import Modelica;
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcPDiagramPQ;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  parameter Real QPercent1 "Percentage of the coordinated reactive control that comes from converter 1";
  parameter Real QPercent2 "Percentage of the coordinated reactive control that comes from converter 2";

  input Types.ReactivePowerPu Q1RefPu(start = Q1Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";
  input Types.ReactivePowerPu Q2RefPu(start = Q2Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 2";
  input Boolean modeU1(start = modeU10) "Boolean assessing the mode of the control of converter 1: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
  input Boolean modeU2(start = modeU20) "Boolean assessing the mode of the control of converter 2: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
  input Types.PerUnit NQ1 "Signal to change the reactive power generation of converter 1 depending on the centralized voltage regulation (generator convention)";
  input Types.PerUnit NQ2 "Signal to change the reactive power generation of converter 2 depending on the centralized voltage regulation (generator convention)";

  Types.Angle Theta1(start = UPhase10) "Angle of the voltage at terminal 1 in rad";
  Types.Angle Theta2(start = UPhase20) "Angle of the voltage at terminal 2 in rad";

  parameter Types.ReactivePowerPu Q1Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";
  parameter Types.ReactivePowerPu Q2Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 2";
  parameter Boolean modeU10 "Start value of the boolean assessing the mode of the control of converter 1";
  parameter Boolean modeU20 "Start value of the boolean assessing the mode of the control of converter 2";
  parameter Types.Angle UPhase10 "Start value of voltage angle and filtered voltage angle at terminal 1 in rad";
  parameter Types.Angle UPhase20 "Start value of voltage angle and filtered voltage angle at terminal 2 in rad";

protected
  Types.ReactivePowerPu QInj1RawModeUPu(start = - s10Pu.im) "Reactive power generation of converter 1 without taking limits into account in pu and for mode U activated (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj2RawModeUPu(start = - s20Pu.im) "Reactive power generation of converter 2 without taking limits into account in pu and for mode U activated (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj1RawPu(start = - s10Pu.im) "Reactive power generation of converter 1 without taking limits into account in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj2RawPu(start = - s20Pu.im) "Reactive power generation of converter 2 without taking limits into account in pu (base SnRef) (generator convention)";

equation
  Theta1 = Modelica.Math.atan2(terminal1.V.im, terminal1.V.re);
  Theta2 = Modelica.Math.atan2(terminal2.V.im, terminal2.V.re);

  QInj1RawModeUPu = - Q1RefPu + QPercent1 * NQ1;
  QInj2RawModeUPu = - Q2RefPu + QPercent2 * NQ2;
  QInj1RawPu = if modeU1 then QInj1RawModeUPu else - Q1RefPu;
  QInj2RawPu = if modeU2 then QInj2RawModeUPu else - Q2RefPu;

  // Reactive power regulation at terminal 1
  if runningSide1.value then
    if QInj1RawPu <= QInj1MinPu then
      QInj1Pu = QInj1MinPu;
    elseif QInj1RawPu >= QInj1MaxPu then
      QInj1Pu = QInj1MaxPu;
    else
      QInj1Pu = QInj1RawPu;
    end if;
  else
    QInj1Pu = 0;
  end if;

  // Reactive power regulation at terminal 2
  if runningSide2.value then
    if QInj2RawPu <= QInj2MinPu then
      QInj2Pu = QInj2MinPu;
    elseif QInj2RawPu >= QInj2MaxPu then
      QInj2Pu = QInj2MaxPu;
    else
      QInj2Pu = QInj2RawPu;
    end if;
  else
    QInj2Pu = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the reactive power at each of its terminals (with a fixed Q reference or a proportional regulation). The active power setpoint is given as an input and can be modified during the simulation, as well as the reactive power references. The reactive power limits are given by a PQ diagram.</div></body></html>"));
end HvdcPQPropDiagramPQ;
