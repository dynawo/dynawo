within Dynawo.Electrical.Buses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model BusWithInit "Bus with init"
  extends AdditionalIcons.Bus;
  import Modelica.Constants;

  parameter Types.VoltageModule UNom = 1.0 "Nominal voltage in kV";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = 0.), im(start = 0.)));

  Types.VoltageModulePu UPu(start = ComplexMath.abs(u0Pu)) "Voltage amplitude at terminal in pu (base UNom)";
  Types.VoltageModule U "Voltage amplitude at terminal in kV";
  Types.Angle UPhase(start = ComplexMath.arg(u0Pu)) "Voltage angle at terminal in rad";
  Types.Angle UPhaseDeg(start = ComplexMath.arg(u0Pu) * 180.0 / Constants.pi) "Voltage angle at terminal in degree";

  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal (base UNom)";

equation
  terminal.i = Complex(0);
  UPu = ComplexMath.abs(terminal.V);
  UPhase = ComplexMath.arg(terminal.V);
  UPhaseDeg = UPhase * 180.0 / Constants.pi;
  U = UPu * UNom;

  annotation(preferredView = "text");

end BusWithInit;
