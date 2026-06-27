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

model Circuit_RLC "EMT example: a three-phase RL line feeding a shunt capacitor, energised at t = 1.1 s by a 50 Hz balanced source"
  Dynawo.Electrical.EMT.SignalVoltage source "Three-phase voltage source";
  Dynawo.Electrical.EMT.RLBranchDisym ligne(R11 = 77, L11 = 0.070) "Three-phase RL line";
  Dynawo.Electrical.EMT.CParallel capa(C = 1e-6) "Three-phase shunt capacitor";
  Dynawo.Electrical.EMT.Ground ground "Ground";
  Dynawo.Electrical.EMT.VoltageSensor sensorC "Capacitor voltage sensor";

equation
  // Balanced three-phase source, switched on at t = 1.1 s (5 V peak per phase)
  source.v1 = if time < 1.1 then 0 else 5 * Modelica.Math.cos(2 * Modelica.Constants.pi * Dynawo.Electrical.SystemBase.fNom * time);
  source.v2 = if time < 1.1 then 0 else 5 * Modelica.Math.cos(2 * Modelica.Constants.pi * Dynawo.Electrical.SystemBase.fNom * time - 2 * Modelica.Constants.pi / 3);
  source.v3 = if time < 1.1 then 0 else 5 * Modelica.Math.cos(2 * Modelica.Constants.pi * Dynawo.Electrical.SystemBase.fNom * time + 2 * Modelica.Constants.pi / 3);

  connect(source.p, ligne.n);
  connect(ligne.p, capa.p);
  connect(source.n, ground.p);
  connect(sensorC.p, capa.p);
  connect(sensorC.n, ground.p);

  annotation(preferredView = "text");
end Circuit_RLC;
