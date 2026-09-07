within Dynawo.Electrical.Controls.Transformers;

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

model TapChangerWithTransformer_INIT "Initialisation model for tap-changer used with a transformer"
  extends BaseClasses_INIT.BaseTapChanger_INIT;
  extends AdditionalIcons.Init;

  Integer tap0 "Initial tap";
  Types.VoltageModule U0 "Initial absolute voltage";

equation
  valueToMonitor0 = U0; // It is better to use an equation in case the transformer U0 changes, (otherwise the updated value would not be propagated)

  annotation(preferredView = "text");
end TapChangerWithTransformer_INIT;
