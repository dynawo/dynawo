within Dynawo.Electrical.Transformers;

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

model TransformerVariableTapI_INIT "Initialization for transformer based on the network voltage and current"
  extends BaseClasses_INIT.BaseTransformerVariableTap_INIT;
  extends BaseClasses_INIT.BaseTransformerVariables_INIT;
  extends AdditionalIcons.Init;

equation
  // Initial tap estimation
  Tap0 = BaseClasses_INIT.TapEstimation(ZPu, rTfoMinPu, rTfoMaxPu, NbTap, terminal1.V, terminal1.i, Uc20Pu);

  // Transformer equations
  terminal1.i = rTfo0Pu * (YPu * terminal2.V - terminal2.i);
  rTfo0Pu * rTfo0Pu * terminal1.V = rTfo0Pu * terminal2.V + ZPu * terminal1.i;

  annotation(preferredView = "text");
end TransformerVariableTapI_INIT;
