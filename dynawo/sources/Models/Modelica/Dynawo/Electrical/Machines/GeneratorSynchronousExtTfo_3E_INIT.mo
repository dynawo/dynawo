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

model GeneratorSynchronousExtTfo_3E_INIT "Synchronous machine with 3 windings - Initialization model from external parameters"

/*This model is similar to GeneratorSynchronousExt_3E_INIT but U0Pu, P0Pu, Q0Pu and UPhase0 are variables because they are calculated from the generator transformer initialization model and should be passed to the generator through an initConnect in a preassembled model or in the dyd file*/

  extends BaseClasses_INIT.BaseGeneratorSynchronousExt3E_INIT;
  extends BaseClasses_INIT.BaseGeneratorVariables_INIT;
  extends AdditionalIcons.Init;

annotation(preferredView = "text");
end GeneratorSynchronousExtTfo_3E_INIT;
