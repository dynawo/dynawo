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

model InfiniteBus "Infinite bus"

/*
  The bus voltage and angle will remain constant throughout the simulation.
*/

  import Dynawo.Connectors;

  Connectors.ACPower terminal;

  parameter Types.AC.VoltageModule U "Infinite bus constant voltage module";
  parameter SIunits.Angle UPhase "Infinite bus constant voltage angle";

equation

  terminal.V = U * ComplexMath.exp(ComplexMath.j * UPhase);

end InfiniteBus;
