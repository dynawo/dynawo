within Dynawo.Electrical.Buses;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model Bus "Bus"

  import Dynawo.Connectors;

  extends AdditionalIcons.Bus;

  Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {-1.42109e-14, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-1.42109e-14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.VoltageModulePu UPu "Voltage amplitude at terminal in pu (base UNom)";
  Types.Angle UPhase "Voltage angle at terminal in rad";

equation

  terminal.i = Complex(0);
  UPu = ComplexMath.'abs'(terminal.V);
  UPhase = ComplexMath.arg(terminal.V);

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The bus model doesn't provide any new equation to the system. It is present into the library for convenience purpose to build network tests.</body></html>"));
end Bus;
