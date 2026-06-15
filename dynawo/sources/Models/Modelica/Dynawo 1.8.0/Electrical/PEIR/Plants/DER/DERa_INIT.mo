within Dynawo.Electrical.PEIR.Plants.DER;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model DERa_INIT "Initialization model for IBGs"
  extends Electrical.Sources.InjectorIDQ_INIT;

protected
  Types.PerUnit PF0 "Start value of power factor";

equation
  PF0 = if (not(ComplexMath.'abs'(s0Pu) == 0)) then P0Pu / ComplexMath.'abs'(s0Pu) else 0;

  annotation(preferredView = "text");
end DERa_INIT;
