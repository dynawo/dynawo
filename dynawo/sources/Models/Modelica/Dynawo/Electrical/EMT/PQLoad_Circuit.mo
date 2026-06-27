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
*
* Modular EMT test assembled entirely from ported library components, to validate
* the ported PQLoad and demonstrate re-modularising the GFf_Load_InfBus network
* half from components (see recovered_cases/decomposition.md): a 50 Hz balanced
* source feeds a constant-PQ load through a three-phase RL line.
*/

model PQLoad_Circuit "EMT test: 50 Hz source -> RL line -> constant-PQ load (validates the ported PQLoad)"
  Dynawo.Electrical.EMT.SignalVoltage source "Three-phase voltage source (infinite bus)";
  Dynawo.Electrical.EMT.RLBranchDisym line(R11 = 3, L11 = 0.0955, L12 = 0) "Three-phase RL line";
  Dynawo.Electrical.EMT.PQLoad load(P = 600e6, Q = 120e6, V = 320e3) "Constant-PQ load";
  Dynawo.Electrical.EMT.Ground ground "Ground";
  Dynawo.Electrical.EMT.VoltageSensor sensorLoad "Load-node voltage sensor";

  final parameter Real Vpeak = sqrt(2.0 / 3.0) * 320e3 "Phase-to-ground peak voltage from 320 kV RMS line-to-line";

equation
  // Balanced three-phase 50 Hz source whose amplitude rises smoothly from zero
  // (event-free soft energisation, time constant 20 ms): the system starts from a
  // consistent rest state and no step discontinuity is imposed on the solver.
  source.v1 = Vpeak * (1 - exp(-time / 0.02)) * Modelica.Math.cos(2 * Modelica.Constants.pi * Dynawo.Electrical.SystemBase.fNom * time);
  source.v2 = Vpeak * (1 - exp(-time / 0.02)) * Modelica.Math.cos(2 * Modelica.Constants.pi * Dynawo.Electrical.SystemBase.fNom * time - 2 * Modelica.Constants.pi / 3);
  source.v3 = Vpeak * (1 - exp(-time / 0.02)) * Modelica.Math.cos(2 * Modelica.Constants.pi * Dynawo.Electrical.SystemBase.fNom * time + 2 * Modelica.Constants.pi / 3);

  connect(source.p, line.p);
  connect(line.n, load.p);
  connect(sensorLoad.p, load.p);
  connect(sensorLoad.n, ground.p);
  connect(source.n, ground.p);

  annotation(preferredView = "text");
end PQLoad_Circuit;
