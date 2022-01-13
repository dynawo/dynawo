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

model HvdcPQProp "Model of HVDC link with a proportional reactive power control. Each terminal can inject a fixed reactive power or use the proportional control, depending on the user's choice."
  import Modelica;
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcP;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  Connectors.ZPin Q1RefPu(value(start = Q1Ref0Pu)) "Reactive power regulation set point in p.u (base SnRef) (receptor convention) at terminal 1";
  Connectors.ZPin Q2RefPu(value(start = Q2Ref0Pu)) "Reactive power regulation set point in p.u (base SnRef) (receptor convention) at terminal 2";
  Connectors.BPin modeU1(value(start = modeU10)) "Boolean assessing the mode of the control of converter 1: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
  Connectors.BPin modeU2(value(start = modeU20)) "Boolean assessing the mode of the control of converter 2: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
  Connectors.ImPin NQ1 "Signal to change the reactive power of converter 1 depending on the centralized voltage regulation (generator convention)";
  Connectors.ImPin NQ2 "Signal to change the reactive power of converter 2 depending on the centralized voltage regulation (generator convention)";

  parameter Types.ReactivePowerPu Q1Ref0Pu "Start value of reactive power regulation set point in p.u (base SnRef) (receptor convention) at terminal 1";
  parameter Types.ReactivePowerPu Q2Ref0Pu "Start value of reactive power regulation set point in p.u (base SnRef) (receptor convention) at terminal 2";
  parameter Boolean modeU10 "Start value of the boolean assessing the mode of the control of converter 1";
  parameter Boolean modeU20 "Start value of the boolean assessing the mode of the control of converter 2";
  parameter Real QPercent1 "Percentage of the coordinated reactive control that comes from converter 1";
  parameter Real QPercent2 "Percentage of the coordinated reactive control that comes from converter 2";

  parameter Types.ReactivePowerPu Q1MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 1 (receptor convention)";
  parameter Types.ReactivePowerPu Q1MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 1 (receptor convention)";
  parameter Types.ReactivePowerPu Q2MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 2 (receptor convention)";
  parameter Types.ReactivePowerPu Q2MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 2 (receptor convention)";

  Types.Angle Theta1(start = UPhase10) "Angle of the voltage at terminal 1 in rad";
  Types.Angle Theta2(start = UPhase20) "Angle of the voltage at terminal 2 in rad";

protected

  parameter Types.Angle UPhase10 "Start value of voltage angle and filtered voltage angle at terminal 1 in rad";
  parameter Types.Angle UPhase20 "Start value of voltage angle and filtered voltage angle at terminal 2 in rad";
  Types.ReactivePowerPu Q1RawModeUPu (start = s10Pu.im) "Reactive power of converter 1 without taking limits into account in p.u and for mode U activated (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2RawModeUPu (start = s20Pu.im) "Reactive power of converter 2 without taking limits into account in p.u and for mode U activated (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1RawPu (start = s10Pu.im) "Reactive power of converter 1 without taking limits into account in p.u (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2RawPu (start = s20Pu.im) "Reactive power of converter 2 without taking limits into account in p.u (base SnRef) (receptor convention)";

equation

  Theta1 = Modelica.Math.atan2(terminal1.V.im,terminal1.V.re);
  Theta2 = Modelica.Math.atan2(terminal2.V.im,terminal2.V.re);

  Q1RawModeUPu = Q1RefPu.value - QPercent1 * NQ1.value;
  Q2RawModeUPu = Q2RefPu.value - QPercent2 * NQ2.value;
  Q1RawPu = if modeU1.value then Q1RawModeUPu else Q1RefPu.value;
  Q2RawPu = if modeU2.value then Q2RawModeUPu else Q2RefPu.value;

if running.value then

// Reactive power regulation at terminal 1
  if Q1RawPu <= Q1MinPu then
    Q1Pu = Q1MinPu;
  elseif Q1RawPu >= Q1MaxPu then
    Q1Pu = Q1MaxPu;
  else
    Q1Pu = Q1RawPu;
  end if;

// Reactive power regulation at terminal 2
  if Q2RawPu <= Q2MinPu then
    Q2Pu = Q2MinPu;
  elseif Q2RawPu >= Q2MaxPu then
    Q2Pu = Q2MaxPu;
  else
    Q2Pu = Q2RawPu;
  end if;

else

  terminal1.i.im = 0;
  terminal2.i.im = 0;

end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the reactive power at each of its terminals (with a fixed Q reference or a proportional regulation). The active power setpoint is given as an input and can be modified during the simulation, as well as the reactive power references.</div></body></html>"));
end HvdcPQProp;
