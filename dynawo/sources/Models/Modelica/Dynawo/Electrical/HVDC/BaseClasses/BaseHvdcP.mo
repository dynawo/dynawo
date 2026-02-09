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

partial model BaseHvdcP "Base dynamic model for HVDC links with a regulation of the active power"
  extends BaseHvdc(P2Pu(start = s20Pu.re), PInj2Pu(start = -s20Pu.re), Q2Pu(start = s20Pu.im), QInj2Pu(start = -s20Pu.im), terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))));

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  Types.ComplexApparentPowerPu s2Pu(re(start = s20Pu.re), im(start = s20Pu.im)) "Complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.AngleConnector Theta1(start = UPhase10) "Angle of the voltage at terminal 1 in rad";
  Dynawo.Connectors.AngleConnector Theta2(start = UPhase20) "Angle of the voltage at terminal 2 in rad";
  Types.VoltageModulePu U2Pu(start = ComplexMath.'abs'(u20Pu)) "Voltage amplitude at terminal 2 in pu (base UNom)";

  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar1;
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar2;

  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base UNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle and filtered voltage angle at terminal 1 in rad";
  parameter Types.Angle UPhase20 "Start value of voltage angle and filtered voltage angle at terminal 2 in rad";

equation
  s2Pu = Complex(P2Pu, Q2Pu);
  s2Pu = terminal2.V * ComplexMath.conj(terminal2.i);
  complexToPolar1.u = terminal1.V;
  complexToPolar2.u = terminal2.V;
  U1Pu = complexToPolar1.len;
  U2Pu = complexToPolar2.len;
  Theta1 = complexToPolar1.phi;
  Theta2 = complexToPolar2.phi;

  if running.value then
    P1Pu = if P1RefPu > PMaxPu then PMaxPu elseif P1RefPu < -PMaxPu then -PMaxPu else P1RefPu;
    P2Pu = if P1Pu > 0 then -KLosses * P1Pu else -P1Pu / KLosses;
  else
    P1Pu = 0;
    P2Pu = 0;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation.</div></body></html>"));
end BaseHvdcP;
