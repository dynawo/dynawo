within Dynawo.Electrical.Machines.OmegaRef.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseGeneratorSynchronousExt3W_INIT "Base initialization model for synchronous machine from external parameters with three windings"
  extends BaseGeneratorSynchronousExt_INIT;

  parameter Types.PerUnit XppqPu "Quadrature axis sub-transient reactance in pu";
  parameter Types.Time Tppq0 "Open circuit quadrature axis sub-transient time constant";

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

  annotation(preferredView = "text");
end BaseGeneratorSynchronousExt3W_INIT;
