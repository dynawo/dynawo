within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model VRDTRI8_INIT "Simple proportional voltage regulator initialization model for DTR I8 fiche"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  parameter Types.PerUnit Gain "Control gain";

  Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  Efd0Pu = (UsRef0Pu - Us0Pu)*Gain;

  annotation(preferredView = "text");
end VRDTRI8_INIT;
