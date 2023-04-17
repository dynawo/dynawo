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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseGeneratorSynchronousExt_4E_INIT "Base initialization model for synchronous machine from external parameters with four windings"
  extends BaseGeneratorSynchronousExt_INIT;

  parameter Types.PerUnit XpqPu "Quadrature axis transient reactance in pu";
  parameter Types.Time Tpq0 "Open circuit quadrature axis transient time constant";
  parameter Types.PerUnit XppqPu "Quadrature axis sub-transient reactance in pu";
  parameter Types.Time Tppq0 "Open circuit quadrature axis sub-transient time constant";

  // Auxiliary parameters: quadrature axis
  Types.Time Tpq;
  Types.Time Tppq;
  Types.PerUnit T1qPu;
  Types.PerUnit T4qPu;
  Types.PerUnit T3qPu;
  Types.PerUnit T6qPu;

  // Auxiliary parameters for precise calculation of internal parameters
  Real xq, B1q, B2q, C1q, C2q, Pq, Qq, Bq, RADq, V1q, V2q, U1q, U2q, Z1q, Z2q, E1q, E2q, Eq, Fq, Vq, Uq, RQ11, RQ12, RQ1PuApprox, RQ1PuPrecise, LQ1PuApprox, LQ1PuPrecise, RQ2PuPrecise, LQ2PuPrecise;

equation
  Tpq = Tpq0 * XpqPu / XqPu;
  Tppq = Tppq0 * XppqPu / XpqPu;
  T1qPu = Tpq0  * SystemBase.omegaNom;
  T4qPu = Tpq   * SystemBase.omegaNom;
  T3qPu = Tppq0 * SystemBase.omegaNom;
  T6qPu = Tppq  * SystemBase.omegaNom;

  // Precise calculation of quadrature axis
  B1q = T1qPu + T3qPu;
  B2q = T4qPu + T6qPu;
  C1q = T1qPu * T3qPu;
  C2q = T4qPu * T6qPu;
  xq = MqPu * LqPu / XqPu;
  Pq = (B1q / MqPu) - (B2q / xq);
  Qq = (1 / xq) - (1 / MqPu);
  Bq = C2q - C1q * LqPu / XqPu;
  RADq = sqrt(1 - 4 * Bq * LqPu * Qq * Qq / (xq * Pq * Pq));
  V1q = - 0.5 * Pq * (1 + RADq) / Qq;
  V2q = - 0.5 * Pq * (1 - RADq) / Qq;
  U1q = Bq * LqPu / (xq * V1q);
  U2q = Bq * LqPu / (xq * V2q);
  Z1q = Bq * LqPu + MqPu * (B2q + Pq / Qq) * V1q;
  Z2q = Bq * LqPu + MqPu * (B2q + Pq / Qq) * V2q;
  E1q = (C1q - Z1q / xq) / ((U1q - V1q) * MqPu);
  E2q = (C1q - Z2q / xq) / ((U2q - V2q) * MqPu);
  RQ11 = 1 / E1q;
  RQ12 = 1 / E2q;
  LQ1PuApprox = (Tpq * MqPu - Tpq0 * xq) / (Tpq0 - Tpq);
  RQ1PuApprox = (MqPu + LQ1PuApprox) / T1qPu;
  RQ1PuPrecise = if abs(RQ11 - RQ1PuApprox) < abs(RQ12 - RQ1PuApprox) then RQ11 else RQ12;
  Eq = if abs(RQ11 - RQ1PuApprox) < abs(RQ12 - RQ1PuApprox) then E1q else E2q;
  Vq = if abs(RQ11 - RQ1PuApprox) < abs(RQ12 - RQ1PuApprox) then V1q else V2q;
  Uq = if abs(RQ11 - RQ1PuApprox) < abs(RQ12 - RQ1PuApprox) then U1q else U2q;
  Fq = (B2q + Pq / Qq) / xq - Eq;
  RQ2PuPrecise = 1 / Fq;
  LQ2PuPrecise = Uq * RQ2PuPrecise;
  LQ1PuPrecise = Vq * RQ1PuPrecise;

  // Calculation of quadrature axis
  if UseApproximation then
    LQ1Pu * (MqPu + LqPu) * (T1qPu - T4qPu) = (MqPu + LqPu) * MqPu * T4qPu - MqPu * LqPu * T1qPu;
    RQ1Pu * T1qPu = MqPu + LQ1Pu;
    LQ2Pu * (MqPu + LQ1Pu) * (T3qPu - T6qPu) = MqPu * LQ1Pu * (T6qPu - T3qPu * (MqPu + LQ1Pu) * LqPu / (MqPu * LqPu + MqPu * LQ1Pu + LqPu * LQ1Pu));
    RQ2Pu * T3qPu = LQ2Pu + MqPu * LQ1Pu / (MqPu + LQ1Pu);
  else
    LQ1Pu = LQ1PuPrecise;
    RQ1Pu = RQ1PuPrecise;
    LQ2Pu = LQ2PuPrecise;
    RQ2Pu = RQ2PuPrecise;
  end if;

  annotation(preferredView = "text");
end BaseGeneratorSynchronousExt_4E_INIT;
