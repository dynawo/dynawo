within Dynawo.Electrical.PEIR.Plants.Simplified;

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

model GenericInverter_INIT "Injector model with regulation, used in the modified Nordic32 test system"
  extends Dynawo.AdditionalIcons.Init;

  Dynawo.Connectors.ActivePowerPuInput P0Pu "Initial active power in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ReactivePowerPuInput Q0Pu "Initial reactive power in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.VoltageModulePuInput U0Pu "Initial voltage amplitude at the terminal in pu (base UNom)";
  Dynawo.Connectors.AngleInput UPhase0 "Initial voltage angle at the terminal in rad";
  Dynawo.Connectors.VoltageModulePuInput VReg0Pu "Initial voltage amplitude at the PCC in pu (base UNom)";

  annotation(preferredView = "text");
end GenericInverter_INIT;
