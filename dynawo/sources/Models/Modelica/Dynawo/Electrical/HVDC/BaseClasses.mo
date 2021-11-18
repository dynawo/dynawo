within Dynawo.Electrical.HVDC;

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

package BaseClasses
  extends Icons.BasesPackage;

  partial model BaseHvdcP "Base dynamic model for HVDC links with a regulation of the active power"

  /*
    Equivalent circuit and conventions:

                 I1                  I2
     (terminal1) -->-------HVDC-------<-- (terminal2)

  */

    import Modelica;
    import Dynawo.Connectors;
    import Dynawo.Electrical.Controls.Basics.SwitchOff;
    extends SwitchOff.SwitchOffDCLine;

    Connectors.ACPower terminal1 (V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2 (V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

    parameter Types.ReactivePowerPu Q1MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 1";
    parameter Types.ReactivePowerPu Q1MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 1";
    parameter Types.ReactivePowerPu Q2MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 2";
    parameter Types.ReactivePowerPu Q2MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 2";
    parameter Real KLosses "Coefficient between 0 and 1 (no loss) modelling the losses in the HVDC";

    input Types.ActivePowerPu P1RefPu (start = s10Pu.re) "Active power regulation set point in p.u (base SnRef) at terminal 1";

  protected

    parameter Types.ComplexVoltagePu u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    parameter Types.ComplexCurrentPu i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    parameter Types.ComplexVoltagePu u20Pu  "Start value of complex voltage at terminal 2 in p.u (base UNom)";
    parameter Types.ComplexCurrentPu i20Pu  "Start value of complex current at terminal 2 in p.u (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";

    Types.ActivePowerPu P1Pu (start = s10Pu.re) "Active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ActivePowerPu P2Pu (start = s20Pu.re) "Active power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ActivePowerPu PInj1Pu (start = - s10Pu.re) "Active power at terminal 1 in p.u (base SnRef) (generator convention)";
    Types.ActivePowerPu PInj2Pu (start = - s20Pu.re) "Active power at terminal 2 in p.u (base SnRef) (generator convention)";
    Types.VoltageModulePu U1Pu (start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in p.u (base UNom)";
    Types.VoltageModulePu U2Pu (start = ComplexMath.'abs'(u20Pu)) "Voltage amplitude at terminal 2 in p.u (base UNom)";
    Types.ComplexApparentPowerPu s1Pu(re (start = s10Pu.re), im (start = s10Pu.im)) "Complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ComplexApparentPowerPu s2Pu(re (start = s20Pu.re), im (start = s20Pu.im)) "Complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q1Pu (start = s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2Pu (start = s20Pu.im) "Reactive power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu QInj1Pu (start = - s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2Pu (start = - s20Pu.im) "Reactive power at terminal 2 in p.u (base SnRef) (generator convention)";

  equation

    U1Pu = ComplexMath.'abs'(terminal1.V);
    U2Pu = ComplexMath.'abs'(terminal2.V);
    s1Pu = Complex(P1Pu, Q1Pu);
    s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);
    s2Pu = Complex(P2Pu, Q2Pu);
    s2Pu = terminal2.V * ComplexMath.conj(terminal2.i);

    PInj1Pu = - P1Pu;
    PInj2Pu = - P2Pu;
    QInj1Pu = - Q1Pu;
    QInj2Pu = - Q2Pu;

    if (running.value) then
      P1Pu = P1RefPu;
      P2Pu = - KLosses * P1Pu;
    else
      P1Pu = 0;
      P2Pu = 0;
    end if;

annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation.</div></body></html>"));
  end BaseHvdcP;

  partial model BaseHvdcPDangling "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus"
    import Dynawo.Connectors;
    import Dynawo.Electrical.Controls.Basics.SwitchOff;

    extends SwitchOff.SwitchOffDCLine;

  /*
    Equivalent circuit and conventions:
                 I1                  I2 = 0
     (terminal1) -->-------HVDC-------<-- (switched-off terminal2)
  */

    Connectors.ACPower terminal1 (V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2 annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

    parameter Types.ReactivePowerPu Q1MinPu "Minimum reactive power in p.u (base SnRef) at terminal 1";
    parameter Types.ReactivePowerPu Q1MaxPu "Maximum reactive power in p.u (base SnRef) at terminal 1";

    input Types.ActivePowerPu P1RefPu(start = s10Pu.re) "Active power regulation set point in p.u (base SnRef) at terminal 1";

  protected
    parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";

    Types.ActivePowerPu P1Pu(start = s10Pu.re) "Active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ActivePowerPu P2Pu(start = 0) "Active power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ActivePowerPu PInj1Pu(start = - s10Pu.re) "Active power at terminal 1 in p.u (base SnRef) (generator convention)";
    Types.ActivePowerPu PInj2Pu(start = 0) "Active power at terminal 2 in p.u (base SnRef) (generator convention)";
    Types.VoltageModulePu U1Pu(start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in p.u (base UNom)";
    Types.ComplexApparentPowerPu s1Pu(re(start = s10Pu.re), im(start = s10Pu.im)) "Complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q1Pu(start = s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2Pu(start = 0) "Reactive power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu QInj1Pu(start = - s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2Pu(start = 0) "Reactive power at terminal 2 in p.u (base SnRef) (generator convention)";

  equation

  // Connected side
    if (running.value) then
      P1Pu = P1RefPu;
      U1Pu = ComplexMath.'abs'(terminal1.V);
    else
      P1Pu = 0;
      U1Pu = 0;
    end if;

  // Disconnected side
    P2Pu = 0;
    Q2Pu = 0;
    terminal2.i.re = 0;
    terminal2.i.im = 0;

  // Sign convention change
    PInj1Pu = - P1Pu;
    PInj2Pu = - P2Pu;
    QInj1Pu = - Q1Pu;
    QInj2Pu = - Q2Pu;

  annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus.</div></body></html>"));
  end BaseHvdcPDangling;

  annotation(preferredView = "text");
end BaseClasses;
