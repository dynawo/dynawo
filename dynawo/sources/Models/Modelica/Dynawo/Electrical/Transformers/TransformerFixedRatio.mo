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

model TransformerFixedRatio "Two winding transformer with a fixed ratio"

/* This model works without initialization model*/

  import Dynawo.Connectors;

  extends BaseClasses.TransformerParameters;
  extends BaseClasses.BaseTransformer;
  extends AdditionalIcons.Transformer;

  Connectors.ACPower terminal1;
  Connectors.ACPower terminal2;

  parameter Types.PerUnit rTfoPu "Transformation ratio in p.u: U2/U1 in no load conditions";

annotation(preferredView = "text");
end TransformerFixedRatio;
