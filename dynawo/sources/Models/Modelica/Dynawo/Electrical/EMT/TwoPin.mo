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

partial model TwoPin "Component with two EMT pins p and n; current i flows from p to n, voltage v = p.v - n.v"
  Dynawo.Electrical.EMT.PwPin p "Positive pin";
  Dynawo.Electrical.EMT.PwPin n "Negative pin";

  Modelica.SIunits.Voltage v[3] "Voltage drop between the two pins (= p.v - n.v)";
  Modelica.SIunits.Current i[3] "Current flowing from pin p to pin n";

equation
  v = p.v - n.v;
  zeros(3) = p.i + n.i;
  i = p.i;

  annotation(preferredView = "text");
end TwoPin;
