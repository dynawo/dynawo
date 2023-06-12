within Dynawo.Electrical.HVDC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseHvdc "Base dynamic model for HVDC links"
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends SwitchOff.SwitchOffDCLine;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  parameter Real KLosses "Losses coefficient between 0 and 1 : 1 if no loss in the HVDC link, < 1 otherwise";
  parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef) flowing through the HVDC link";

  type PStatus = enumeration(Standard, LimitPMax);

  input Types.ActivePowerPu P1RefPu(start = P1Ref0Pu) "Active power regulation set point in pu (base SnRef) at terminal 1 (receptor convention)";

  Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.ActivePowerPu P1Pu(start = s10Pu.re) "Active power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P2Pu(start = 0) "Active power at terminal 2 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu PInj1Pu(start = - s10Pu.re) "Active power at terminal 1 in pu (base SnRef) (generator convention)";
  Types.ActivePowerPu PInj2Pu(start = 0) "Active power at terminal 2 in pu (base SnRef) (generator convention)";
  PStatus pStatus(start = PStatus.Standard) "Status of the active power function";
  Types.ReactivePowerPu Q1Pu(start = s10Pu.im) "Reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu(start = 0) "Reactive power at terminal 2 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QInj1Pu(start = - s10Pu.im) "Reactive power at terminal 1 in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj2Pu(start = 0) "Reactive power at terminal 2 in pu (base SnRef) (generator convention)";
  Types.ComplexApparentPowerPu s1Pu(re(start = s10Pu.re), im(start = s10Pu.im)) "Complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.VoltageModulePu U1Pu(start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in pu (base UNom)";

  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ActivePowerPu P1Ref0Pu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";

equation
  when (P1RefPu >= PMaxPu or P1RefPu <= -PMaxPu) and pre(pStatus) <> PStatus.LimitPMax then
    pStatus = PStatus.LimitPMax;
    Timeline.logEvent1(TimelineKeys.HVDCMaxP);
  elsewhen (P1RefPu < PMaxPu and P1RefPu > -PMaxPu) and pre(pStatus) == PStatus.LimitPMax then
    pStatus = PStatus.Standard;
    Timeline.logEvent1(TimelineKeys.HVDCDeactivateMaxP);
  end when;

  s1Pu = Complex(P1Pu, Q1Pu);
  s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);

  //Sign convention change
  PInj1Pu = - P1Pu;
  PInj2Pu = - P2Pu;
  QInj1Pu = - Q1Pu;
  QInj2Pu = - Q2Pu;

  annotation(preferredView = "text");
end BaseHvdc;
