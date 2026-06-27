within Dynawo.Electrical.EMT;

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

model ISGT "EMT example (ISGT 2018 'Simple Electrical Grid'): three balanced sources, five mutually-coupled RL lines, one variable resistive load with a step at t = 1 s"
  Dynawo.Electrical.EMT.SignalVoltage G1 "Source 1";
  Dynawo.Electrical.EMT.SignalVoltage G2 "Source 2";
  Dynawo.Electrical.EMT.SignalVoltage G3 "Source 3";

  Dynawo.Electrical.EMT.Ground N1 "Source 1 ground";
  Dynawo.Electrical.EMT.Ground N2 "Source 2 ground";
  Dynawo.Electrical.EMT.Ground N3 "Source 3 ground";

  Dynawo.Electrical.EMT.RLBranchDisym Line12(R11 = 3.749e-3, L11 = 1.989e-4) "Line between source 1 and source 2 nodes";
  Dynawo.Electrical.EMT.RLBranchDisym Line13(R11 = 5.624e-3, L11 = 2.984e-4) "Line between source 1 and source 3 nodes";
  Dynawo.Electrical.EMT.RLBranchDisym Line14(R11 = 1.125e-2, L11 = 5.968e-4) "Line between source 1 node and the load";
  Dynawo.Electrical.EMT.RLBranchDisym Line24(R11 = 7.499e-3, L11 = 3.979e-4) "Line between source 2 node and the load";
  Dynawo.Electrical.EMT.RLBranchDisym Line34(R11 = 9.374e-3, L11 = 4.974e-4) "Line between source 3 node and the load";

  Dynawo.Electrical.EMT.RVariable Rc "Variable resistive load";

  Real sigV1a, sigV1b, sigV1c "Source 1 three-phase voltages";
  Real sigV2a, sigV2b, sigV2c "Source 2 three-phase voltages";
  Real sigV3a, sigV3b, sigV3c "Source 3 three-phase voltages";
  Real rct "Load resistance set point";

equation
  // Balanced three-phase sources at the reference frequency (different amplitudes per source)
  sigV1a = 1.00 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time);
  sigV1b = 1.00 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time - 2 * Modelica.Constants.pi / 3);
  sigV1c = 1.00 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time + 2 * Modelica.Constants.pi / 3);

  sigV2a = 0.75 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time);
  sigV2b = 0.75 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time - 2 * Modelica.Constants.pi / 3);
  sigV2c = 0.75 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time + 2 * Modelica.Constants.pi / 3);

  sigV3a = 0.95 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time);
  sigV3b = 0.95 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time - 2 * Modelica.Constants.pi / 3);
  sigV3c = 0.95 * Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom * time + 2 * Modelica.Constants.pi / 3);

  G1.v1 = sigV1a;
  G1.v2 = sigV1b;
  G1.v3 = sigV1c;
  G2.v1 = sigV2a;
  G2.v2 = sigV2b;
  G2.v3 = sigV2c;
  G3.v1 = sigV3a;
  G3.v2 = sigV3b;
  G3.v3 = sigV3c;

  connect(G1.n, N1.p);
  connect(G2.n, N2.p);
  connect(G3.n, N3.p);

  connect(G1.p, Line12.n);
  connect(G2.p, Line12.p);

  connect(G1.p, Line13.n);
  connect(G3.p, Line13.p);

  connect(G1.p, Line14.n);
  connect(Rc.p, Line14.p);

  connect(G2.p, Line24.n);
  connect(Rc.p, Line24.p);

  connect(G3.p, Line34.n);
  connect(Rc.p, Line34.p);

  // Load step at t = 1 s (resistance drops from 1.0 to 0.5 ohm with a 1 ms time constant)
  rct = if time < 1 then 1.0 else 0.5 + 0.5 * Modelica.Math.exp(-1000 * (time - 1));
  Rc.R = rct;

  annotation(preferredView = "text");
end ISGT;
