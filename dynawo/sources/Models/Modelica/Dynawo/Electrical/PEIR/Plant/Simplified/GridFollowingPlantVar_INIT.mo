within Dynawo.Electrical.PEIR.Plant.Simplified;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GridFollowingPlantVar_INIT
  extends AdditionalIcons.Init;

  Modelica.Blocks.Interfaces.RealInput P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  Modelica.Blocks.Interfaces.RealInput Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  Modelica.Blocks.Interfaces.RealInput U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  Modelica.Blocks.Interfaces.RealInput UPhase0 "Start value of voltage angle at terminal in rad";

  Modelica.Blocks.Interfaces.RealInput QReg0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SNom)";
  Modelica.Blocks.Interfaces.RealInput UReg0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";

end GridFollowingPlantVar_INIT;
