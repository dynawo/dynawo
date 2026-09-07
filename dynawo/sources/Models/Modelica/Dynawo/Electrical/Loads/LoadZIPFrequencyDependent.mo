within Dynawo.Electrical.Loads;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tool for power systems.
*/

model LoadZIPFrequencyDependent "ZIP Load with frequency dependence (see Kundur p.273)"
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;

  // Active power coefficents
  parameter Real Zp "Impedance coefficient for active power";
  parameter Real Ip "Current coefficient for active power";
  parameter Real Pp "Power coefficient for active power";

  // Reactive power coefficients
  parameter Real Zq "Impedance coefficient for reactive power";
  parameter Real Iq "Current coefficient for reactive power";
  parameter Real Pq "Power coefficient for reactive power";
  parameter Real Kpf "Active load sensitivity to frequency";
  parameter Real Kqf "Reactive load sensitivity to frequency";
  parameter Real omegaRef0Pu = 1.0 "Reference frequency in p.u.";

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency of the system in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-104, -4}, extent = {{-4, -4}, {4, 4}}), iconTransformation(origin = {-105, -39}, extent = {{-5, -5}, {5, 5}})));

  Dynawo.Electrical.Controls.PLL.PLL PLL(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(transformation(origin = {-30, 6}, extent = {{-16, -16}, {16, 16}})));

equation
  PLL.uPu.re = terminal.V.re;
  PLL.uPu.im = terminal.V.im;
  if (running) then
    PPu = PRefPu*(1 + deltaP)*(Zp*(ComplexMath.'abs'(terminal.V)/ComplexMath.'abs'(u0Pu))^2 + Ip*(ComplexMath.'abs'(terminal.V)/ComplexMath.'abs'(u0Pu)) + Pp)*(1 + Kpf*(PLL.omegaPLLPu - omegaRef0Pu));
    QPu = QRefPu*(1 + deltaQ)*(Zq*(ComplexMath.'abs'(terminal.V)/ComplexMath.'abs'(u0Pu))^2 + Iq*(ComplexMath.'abs'(terminal.V)/ComplexMath.'abs'(u0Pu)) + Pq)*(1 + Kqf*(PLL.omegaPLLPu - omegaRef0Pu));
  else
    terminal.i = Complex(0);
  end if;
  connect(omegaRefPu, PLL.omegaRefPu) annotation(
    Line(points = {{-104, -4}, {-48, -4}}, color = {0, 0, 127}));

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The ZIP coefficient load model, also known as the polynomial model, represents the variation with voltage of a load composed of a constant impedance part Z, a constant current part I and a constant power part P.&nbsp;<div><br></div><div>The coefficients Zp, Ip and Pp are the ZIP coefficients for active power and the coefficients Zq, Iq and Pq the ZIP coefficients for reactive power.&nbsp;</div><div><br></div><div>By taking Zp = Ip = Zq = Iq = 0 and Pp = Pq = 1, one will have a constant PQ load: P = PRefPu and Q = QRefPu.</div><div>By taking Zp = Pp = Zq = Pq = 0 and Ip = Iq = 1, one will get a constant current load: P = PRefPu * (U/U0) and Q = QRefPu * (U/U0).</div><div>By taking Ip = Pp = Iq = Pq = 0 and Zp = Zq = 1, one will end up with a constant impedance load: P = PRefPu * (U/U0)² and Q = QRefPu * (U/U0)²&nbsp;</div></body></html>"));
end LoadZIPFrequencyDependent;
