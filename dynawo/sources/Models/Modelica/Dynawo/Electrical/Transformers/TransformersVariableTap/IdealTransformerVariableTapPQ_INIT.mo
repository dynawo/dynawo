within Dynawo.Electrical.Transformers.TransformersVariableTap;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model IdealTransformerVariableTapPQ_INIT "Initialization for ideal transformer based on the network voltage, active and reactive power"
  extends BaseClasses_INIT.BaseTransformerVariableTapCommon_INIT;
  extends BaseClasses_INIT.BaseTransformerParameters_INIT;
  extends AdditionalIcons.Init;

equation
  // Initial tap estimation
  Tap0 = BaseClasses_INIT.IdealTransformerTapEstimation(rTfoMinPu, rTfoMaxPu, NbTap, u10Pu, Uc20Pu);

  // Transformer equations
  i10Pu = - rTfo0Pu * i20Pu;
  rTfo0Pu * u10Pu = u20Pu;

  annotation(preferredView = "text");
end IdealTransformerVariableTapPQ_INIT;
