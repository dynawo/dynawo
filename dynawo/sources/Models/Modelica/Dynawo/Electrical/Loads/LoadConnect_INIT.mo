within Dynawo.Electrical.Loads;

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

model LoadConnect_INIT "Initialization for load where u0Pu and i0Pu need to be connected"
  extends AdditionalIcons.Init;

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

  Dynawo.Connectors.ACPower terminal0 "Connector at initialization";

equation
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);
  u0Pu = terminal0.V;
  i0Pu = terminal0.i;

  annotation(preferredView = "text");
end LoadConnect_INIT;
