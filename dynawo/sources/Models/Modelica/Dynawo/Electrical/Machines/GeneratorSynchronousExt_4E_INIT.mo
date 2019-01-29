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

model GeneratorSynchronousExt_4E_INIT "Synchronous machine with 4 windings - Initialization model from external parameters"

  extends BaseClasses_INIT.BaseGeneratorSynchronousExt_INIT;

  public

    parameter SIunits.PerUnit XppqPu "Quadrature axis sub-transient reactance in p.u.";
    parameter SIunits.Time Tppq0 "Open circuit quadrature axis sub-transient time constant";

  protected

    // Auxiliary parameters: quadrature axis
    SIunits.Time Tppq;

    SIunits.PerUnit T3qPu;
    SIunits.PerUnit T6qPu;

equation

  Tppq = Tppq0 * XppqPu / XpqPu;

  T3qPu = Tppq0 * SystemBase.omegaNom;
  T6qPu = Tppq  * SystemBase.omegaNom;

  LQ2Pu * (MqPu + LQ1Pu) * (T3qPu - T6qPu) = MqPu * LQ1Pu * (T6qPu - T3qPu * (MqPu + LQ1Pu) * LqPu / (MqPu * LqPu + MqPu * LQ1Pu + LqPu * LQ1Pu));
  RQ2Pu * T3qPu = LQ2Pu + MqPu * LQ1Pu / (MqPu + LQ1Pu);

end GeneratorSynchronousExt_4E_INIT;

