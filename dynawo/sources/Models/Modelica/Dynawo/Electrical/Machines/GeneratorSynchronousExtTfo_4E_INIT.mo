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

model GeneratorSynchronousExtTfo_4E_INIT "Synchronous machine with 4 windings - Initialization model from external parameters"

  extends BaseClasses_INIT.BaseGeneratorSynchronousExt_INIT;

  public

    // Start values from transformer
    Types.VoltageModulePu U0Pu "Start value of voltage amplitude in p.u (base UNom)";
    Types.ActivePowerPu P0Pu "Start value of active power at terminal in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in p.u (base SnRef) (receptor convention)";
    Types.Angle UPhase0 "Start value of voltage angle in rad";

    parameter Types.PerUnit XpqPu "Quadrature axis transient reactance in p.u.";
    parameter Types.Time Tpq0 "Open circuit quadrature axis transient time constant";
    parameter Types.PerUnit XppqPu "Quadrature axis sub-transient reactance in p.u.";
    parameter Types.Time Tppq0 "Open circuit quadrature axis sub-transient time constant";

  protected

    // Auxiliary parameters: quadrature axis
    Types.Time Tpq;
    Types.Time Tppq;

    Types.PerUnit T1qPu;
    Types.PerUnit T4qPu;
    Types.PerUnit T3qPu;
    Types.PerUnit T6qPu;

equation

  Tpq = Tpq0 * XpqPu / XqPu;
  Tppq = Tppq0 * XppqPu / XpqPu;

  T1qPu = Tpq0  * SystemBase.omegaNom;
  T4qPu = Tpq   * SystemBase.omegaNom;
  T3qPu = Tppq0 * SystemBase.omegaNom;
  T6qPu = Tppq  * SystemBase.omegaNom;

  LQ1Pu * (MqPu + LqPu) * (T1qPu - T4qPu) = (MqPu + LqPu) * MqPu * T4qPu - MqPu * LqPu * T1qPu;
  RQ1Pu * T1qPu = MqPu + LQ1Pu;

  LQ2Pu * (MqPu + LQ1Pu) * (T3qPu - T6qPu) = MqPu * LQ1Pu * (T6qPu - T3qPu * (MqPu + LQ1Pu) * LqPu / (MqPu * LqPu + MqPu * LQ1Pu + LqPu * LQ1Pu));
  RQ2Pu * T3qPu = LQ2Pu + MqPu * LQ1Pu / (MqPu + LQ1Pu);

end GeneratorSynchronousExtTfo_4E_INIT;
