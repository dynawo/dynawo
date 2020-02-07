within Dynawo.Electrical.Machines;

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

model GeneratorSynchronousInt_INIT "Synchronous machine - Initialization model from internal parameters"

  extends BaseClasses_INIT.BaseGeneratorSynchronousInt_INIT;
  extends AdditionalIcons.Init;

    // Start values given as inputs of the initialization process
    parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in p.u (base UNom)";
    parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in p.u (base SnRef) (receptor convention)";
    parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in p.u (base SnRef) (receptor convention)";
    parameter Types.Angle UPhase0 "Start value of voltage angle in rad";

annotation(preferredView = "text");
end GeneratorSynchronousInt_INIT;
