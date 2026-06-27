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

model Ideal "Ideal three-phase transformer (lossless, fixed ratio) in EMT"
  extends Dynawo.Electrical.EMT.TwoPort;

  parameter Modelica.SIunits.Voltage V1n "Primary voltage rating (V)";
  parameter Modelica.SIunits.Voltage V2n "Secondary voltage rating (V)";
  final parameter Real m = V2n / V1n "Transformer ratio";

equation
  v2 = m * v1;
  i1 = -m * i2;
  zeros(3) = p1.i + n1.i;
  zeros(3) = p2.i + n2.i;

  annotation(preferredView = "text");
end Ideal;
