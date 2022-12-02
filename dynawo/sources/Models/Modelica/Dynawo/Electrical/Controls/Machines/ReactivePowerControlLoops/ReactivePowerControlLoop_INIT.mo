within Dynawo.Electrical.Controls.Machines.ReactivePowerControlLoops;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ReactivePowerControlLoop_INIT "Initialisation model for the Reactive Power Control Loop (RPCL)"
  import Dynawo.Types;

  extends AdditionalIcons.Init;

  Types.VoltageModulePu UStatorRef0Pu "Start value of the generator stator voltage reference in pu (base UNom)";
  Types.ReactivePowerPu QStator0Pu "Start value of the generator stator reactive power in pu (base QNomAlt) (generator convention)";
  Boolean limUQUp0 "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  Boolean limUQDown0 "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";

  annotation(preferredView = "text");
end ReactivePowerControlLoop_INIT;
