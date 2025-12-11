within Dynawo.Electrical.Loads;

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

model LoadZIP "ZIP coefficients load model"
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  // Active power coefficents
  parameter Real Zp "Impedance coefficient for active power";
  parameter Real Ip "Current coefficient for active power";
  parameter Real Pp "Power coefficient for active power";

  // Reactive power coefficients
  parameter Real Zq "Impedance coefficient for reactive power";
  parameter Real Iq "Current coefficient for reactive power";
  parameter Real Pq "Power coefficient for reactive power";

equation
  if running.value then
    PPu = PRefPu * (1 + deltaP) * (Zp * (ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ 2 + Ip * (ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) + Pp);
    QPu = QRefPu * (1 + deltaQ) * (Zq * (ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ 2 + Iq * (ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) + Pq);
  else
    terminal.i = Complex(0);
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The ZIP coefficient load model, also known as the polynomial model, represents the variation with voltage of a load composed of a constant impedance part Z, a constant current part I and a constant power part P.&nbsp;<div><br></div><div>The coefficients Zp, Ip and Pp are the ZIP coefficients for active power and the coefficients Zq, Iq and Pq the ZIP coefficients for reactive power.&nbsp;</div><div><br></div><div>By taking Zp = Ip = Zq = Iq = 0 and Pp = Pq = 1, one will have a constant PQ load: P = PRefPu and Q = QRefPu.</div><div>By taking Zp = Pp = Zq = Pq = 0 and Ip = Iq = 1, one will get a constant current load: P = PRefPu * (U/U0) and Q = QRefPu * (U/U0).</div><div>By taking Ip = Pp = Iq = Pq = 0 and Zp = Zq = 1, one will end up with a constant impedance load: P = PRefPu * (U/U0)² and Q = QRefPu * (U/U0)²&nbsp;</div></body></html>"));
end LoadZIP;
