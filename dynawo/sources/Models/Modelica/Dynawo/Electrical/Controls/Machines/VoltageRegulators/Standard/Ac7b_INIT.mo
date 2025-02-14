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

model Ac7b_INIT "IEEE excitation system type AC7B initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Ac168_INIT;

  //Regulation parameter
  parameter Types.PerUnit Kp "Potential source gain";

  //Input parameters
  Types.ComplexCurrentPuConnector it0Pu "Initial complex stator current in pu (base SNom, UNom)";
  Types.ComplexVoltagePuConnector ut0Pu "Initial complex voltage in pu (base UNom)";

  //Output parameter
  Types.VoltageModulePu Vb0Pu "Initial available exciter field voltage in pu (base UNom)";

equation
  Vb0Pu = Kp * Modelica.ComplexMath.'abs'(ut0Pu);

  annotation(preferredView = "text");
end Ac7b_INIT;
