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

within Dynawo.Electrical.Transformers;

model GeneratorTransformer_INIT

  import Dynawo.Electrical.SystemBase;
  extends BaseClasses_INIT.BaseGeneratorTransformer_INIT;

  public

    // Transformer internal parameters
    parameter Types.PerUnit rTfoPu "Transformation ratio in p.u: U2/U1 in no load conditions";
    parameter Types.PerUnit RPu "Resistance of the generator transformer in p.u (base U2Nom, SnRef)";
    parameter Types.PerUnit BPu "Susceptance of the generator transformer in p.u (base U2Nom, SnRef)";
    parameter Types.PerUnit XPu "Reactance of the generator transformer in p.u (base U2Nom, SnRef)";
    parameter Types.PerUnit GPu "Conductance of the generator transformer in p.u (base U2Nom, SnRef)";

end GeneratorTransformer_INIT;
