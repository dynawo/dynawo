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
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model InfiniteBus "Infinite bus"
  extends AdditionalIcons.Bus;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit UPu "Infinite bus constant voltage module";
  parameter Types.Angle UPhase "Infinite bus constant voltage angle";
  parameter Types.VoltageModule UNom = 1.0 "Nominal voltage in kV";

  Types.VoltageModulePu UPuVar "Voltage amplitude at terminal in pu (base UNom)";
  Types.Angle UPhaseVar "Voltage angle at terminal in rad";
  Types.VoltageModule U "Voltage amplitude at terminal in kV";

equation
  terminal.V = UPu * ComplexMath.exp(ComplexMath.j * UPhase);
  UPuVar = UPu;
  UPhaseVar = UPhase;
  U = UPu * UNom;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The InfiniteBus model imposes a complex voltage value: the bus voltage magnitude and angle will remain constant throughout the simulation.</body></html>"));
end InfiniteBus;
