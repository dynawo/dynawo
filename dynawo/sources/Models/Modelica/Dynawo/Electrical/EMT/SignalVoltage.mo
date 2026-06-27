within Dynawo.Electrical.EMT;

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

model SignalVoltage "Three-phase voltage source driven by three input signals (one per phase)"
  extends Dynawo.Electrical.EMT.TwoPin;

  Modelica.Blocks.Interfaces.RealInput v1(unit = "V") "Voltage between pins p and n for phase a";
  Modelica.Blocks.Interfaces.RealInput v2(unit = "V") "Voltage between pins p and n for phase b";
  Modelica.Blocks.Interfaces.RealInput v3(unit = "V") "Voltage between pins p and n for phase c";

equation
  v = {v1, v2, v3};

  annotation(preferredView = "text");
end SignalVoltage;
