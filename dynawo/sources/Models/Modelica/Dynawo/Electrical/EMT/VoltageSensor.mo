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

model VoltageSensor "Three-phase ideal voltage sensor (no current drawn) in EMT"
  extends Dynawo.Electrical.EMT.TwoPin;

  output Modelica.SIunits.Voltage V[3] "Measured three-phase voltage at pin p";

equation
  n.i = zeros(3);
  V = p.v;

  annotation(preferredView = "text");
end VoltageSensor;
