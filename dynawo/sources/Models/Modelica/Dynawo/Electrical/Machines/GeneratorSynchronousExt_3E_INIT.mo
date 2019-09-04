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

model GeneratorSynchronousExt_3E_INIT "Synchronous machine with 3 windings - Initialization model from external parameters"

  extends BaseClasses_INIT.BaseGeneratorSynchronousExt_INIT;

    parameter Types.PerUnit XppqPu "Quadrature axis sub-transient reactance in p.u.";
    parameter Types.Time Tppq0 "Open circuit quadrature axis sub-transient time constant";

  protected

    Types.Time Tppq;

    Types.PerUnit T3qPu;
    Types.PerUnit T6qPu;

equation

  Tppq = Tppq0 * XppqPu / XqPu;

  T3qPu = Tppq0 * SystemBase.omegaNom;
  T6qPu = Tppq  * SystemBase.omegaNom;

  LQ1Pu * (MqPu + LqPu) * (T3qPu - T6qPu) = (MqPu + LqPu) * MqPu * T6qPu - MqPu * LqPu * T3qPu;
  RQ1Pu * T3qPu = MqPu + LQ1Pu;

  RQ2Pu = 0;
  LQ2Pu = 100000;

end GeneratorSynchronousExt_3E_INIT;
