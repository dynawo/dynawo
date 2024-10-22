within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model Ac8b_INIT "IEEE exciter types AC8B initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Ac16c_INIT;

  //Regulation parameters
  parameter Types.PerUnit Kp "Potential source gain";

  Types.VoltageModulePu Vb0Pu "Initial available exciter field voltage in pu (base UNom)";

equation
  Vb0Pu = Kp;

  annotation(preferredView = "text");
end Ac8b_INIT;
