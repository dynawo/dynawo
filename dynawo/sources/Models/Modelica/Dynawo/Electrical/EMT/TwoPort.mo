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

partial model TwoPort "Component with two EMT ports (left port p1/n1, right port p2/n2); the current entering p1 equals the current leaving n1, idem for the right port"
  Dynawo.Electrical.EMT.PwPin p1 "Positive pin of the left port";
  Dynawo.Electrical.EMT.PwPin n1 "Negative pin of the left port";
  Dynawo.Electrical.EMT.PwPin p2 "Positive pin of the right port";
  Dynawo.Electrical.EMT.PwPin n2 "Negative pin of the right port";

  Modelica.SIunits.Voltage v1[3] "Voltage drop over the left port (= p1.v - n1.v)";
  Modelica.SIunits.Voltage v2[3] "Voltage drop over the right port (= p2.v - n2.v)";
  Modelica.SIunits.Current i1[3] "Current flowing from p1 to n1";
  Modelica.SIunits.Current i2[3] "Current flowing from p2 to n2";

equation
  v1 = p1.v - n1.v;
  v2 = p2.v - n2.v;
  i1 = p1.i;
  i2 = p2.i;

  annotation(preferredView = "text");
end TwoPort;
