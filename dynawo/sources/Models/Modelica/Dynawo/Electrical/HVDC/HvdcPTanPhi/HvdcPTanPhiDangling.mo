within Dynawo.Electrical.HVDC.HvdcPTanPhi;

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

model HvdcPTanPhiDangling "Model for P/tan(Phi) HVDC link with terminal2 connected to a switched-off bus"
  extends AdditionalIcons.Hvdc;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  extends SwitchOff.SwitchOffDCLine;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/
    import Modelica;
    import Dynawo.Connectors;

    Connectors.ACPower terminal1 (V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2 annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ZPin tanPhi1Ref (value (start = s10Pu.im/s10Pu.re)) "tan(Phi) regulation set point at terminal 1";
    input Types.ActivePowerPu P1RefPu (start = s10Pu.re) "Active power regulation set point in p.u (base SnRef) at terminal 1";

    parameter Types.ReactivePowerPu Q1MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 1";
    parameter Types.ReactivePowerPu Q1MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 1";
    parameter Types.ReactivePowerPu Q2MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 2";
    parameter Types.ReactivePowerPu Q2MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 2";
    parameter Real KLosses "Coefficient between 0 and 1 (no loss) modelling the losses in the HVDC";

protected

    parameter Types.ComplexVoltagePu u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    parameter Types.ComplexCurrentPu i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";

    Types.ActivePowerPu P1Pu (start = s10Pu.re) "Active power at terminal 1 in p.u (base SnRef)";
    Types.ActivePowerPu P2Pu (start = 0) "Active power at terminal 2 in p.u (base SnRef)";
    Types.VoltageModulePu U1Pu (start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in p.u (base UNom)";
    Types.ComplexApparentPowerPu s1Pu(re (start = s10Pu.re), im (start = s10Pu.im)) "Complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q1Pu (start = s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef)";
    Types.ReactivePowerPu Q2Pu (start = 0) "Reactive power at terminal 2 in p.u (base SnRef)";

    Types.ReactivePowerPu Q1RawPu (start = s10Pu.im) "Raw reactive power at terminal 1 in p.u (base SnRef)";

equation

  Q1RawPu = tanPhi1Ref.value * P1Pu;

  if Q1RawPu >= Q1MaxPu then
   Q1Pu = Q1MaxPu;
  elseif Q1RawPu <= Q1MinPu then
   Q1Pu = Q1MinPu;
  else
   Q1Pu = Q1RawPu;
  end if;

   U1Pu = ComplexMath.'abs'(terminal1.V);
   s1Pu = Complex(P1Pu, Q1Pu);
   s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);
   P1Pu = P1RefPu;

   P2Pu = 0;
   Q2Pu = 0;
   terminal2.i.re = 0;
   terminal2.i.im = 0;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at terminal1. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint. The terminal2 is connected to a switched-off bus. As a consequence, this HVDC link can be considered as a load seen from terminal1.</div></body></html>"));
end HvdcPTanPhiDangling;
