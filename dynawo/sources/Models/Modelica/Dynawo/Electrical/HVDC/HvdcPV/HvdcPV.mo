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
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HvdcPV "Model of PV HVDC link"
  extends AdditionalIcons.Line;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  import Modelica;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  extends SwitchOff.SwitchOffLine;

  Connectors.ACPower terminal1 (V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im)));
  Connectors.ACPower terminal2 (V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im)));
  Connectors.ZPin U1RefPu (value (start = ComplexMath.'abs'(u10Pu))) "Voltage regulation set point in p.u (base UNom) at terminal 1";
  Connectors.ZPin U2RefPu (value (start = ComplexMath.'abs'(u20Pu))) "Voltage regulation set point in p.u (base UNom) at terminal 2";

  parameter Types.ReactivePowerPu Q1MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 1";
  parameter Types.ReactivePowerPu Q1MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 1";
  parameter Types.ReactivePowerPu Q2MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 2";
  parameter Types.ReactivePowerPu Q2MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 2";
  parameter Real KLosses "Coefficient between 0 and 1 (no loss) modelling the losses in the HVDC";

  input Types.ActivePowerPu P1RefPu (start = s10Pu.re) "Active power regulation set point in p.u (base SnRef) at terminal 1";
  output Types.Angle Theta1(start = UPhase10) "Angle of the voltage at terminal 1 in rad";
  output Types.Angle Theta2(start = UPhase20) "Angle of the voltage at terminal 2 in rad";

protected

  parameter Types.ComplexVoltagePu u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
  parameter Types.ComplexCurrentPu i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.Angle UPhase10 "Start value of voltage angle and filtered voltage angle at terminal 1 in rad";
  parameter Types.ComplexVoltagePu u20Pu  "Start value of complex voltage at terminal 2 in p.u (base UNom)";
  parameter Types.ComplexCurrentPu i20Pu  "Start value of complex current at terminal 2 in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";
  parameter Types.Angle UPhase20 "Start value of voltage angle and filtered voltage angle at terminal 2 in rad";

  Types.VoltageModulePu U1Pu (start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in p.u (base UNom)";
  Types.ComplexApparentPowerPu s1Pu(re (start = s10Pu.re), im (start = s10Pu.im)) "Complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
  Types.ActivePowerPu P1Pu (start = s10Pu.re) "Active power at terminal 1 in p.u (base SnRef)";
  Types.ReactivePowerPu Q1Pu (start = s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef)";

  Types.VoltageModulePu U2Pu (start = ComplexMath.'abs'(u20Pu)) "Voltage amplitude at terminal 2 in p.u (base UNom)";
  Types.ComplexApparentPowerPu s2Pu(re (start = s20Pu.re), im (start = s20Pu.im)) "Complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";
  Types.ActivePowerPu P2Pu (start = s20Pu.re) "Active power at terminal 2 in p.u (base SnRef)";
  Types.ReactivePowerPu Q2Pu (start = s20Pu.im) "Reactive power at terminal 2 in p.u (base SnRef)";

equation

if (running.value) then

  U1Pu = ComplexMath.'abs'(terminal1.V);
  s1Pu = Complex(P1Pu, Q1Pu);
  s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);
  Theta1 = Modelica.Math.atan2(terminal1.V.im,terminal1.V.re);
  P1Pu = P1RefPu;
  if Q1Pu >= Q1MaxPu then
   Q1Pu = Q1MaxPu;
  elseif Q1Pu <= Q1MinPu then
   Q1Pu = Q1MinPu;
  else
   U1Pu = U1RefPu.value;
  end if;

  U2Pu = ComplexMath.'abs'(terminal2.V);
  s2Pu = Complex(P2Pu, Q2Pu);
  s2Pu = terminal2.V * ComplexMath.conj(terminal2.i);
  Theta2 = Modelica.Math.atan2(terminal2.V.im,terminal2.V.re);
  P2Pu = - KLosses * P1Pu;
  if Q2Pu >= Q2MaxPu then
   Q2Pu = Q2MaxPu;
  elseif Q2Pu <= Q2MinPu then
   Q2Pu = Q2MinPu;
  else
   U2Pu = U2RefPu.value;
  end if;

else

  U1Pu = 0;
  s1Pu.re = 0;
  s1Pu.im = 0;
  P1Pu = 0;
  Q1Pu = 0;
  Theta1 = 0;
  terminal1.i.re = 0;
  terminal1.i.im = 0;

  U2Pu = 0;
  s2Pu.re = 0;
  s2Pu.im = 0;
  P2Pu = 0;
  Q2Pu = 0;
  Theta2 = 0;
  terminal2.i.re = 0;
  terminal2.i.im = 0;

end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the voltage at each of its terminals.</div></body></html>"));
end HvdcPV;
