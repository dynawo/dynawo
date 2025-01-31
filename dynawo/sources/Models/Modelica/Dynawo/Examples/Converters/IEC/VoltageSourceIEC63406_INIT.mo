within Dynawo.Examples.Converters.IEC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model VoltageSourceIEC63406_INIT "Initialisation model for the IEC 63406 standard with current source"

  Dynawo.Electrical.Sources.ConverterVoltageSourceIEC63406_INIT converterVoltageSourceIEC63406_INIT(BesPu = 0, GesPu = 0, IMaxPu = 1.3, P0Pu = 0.5, PMaxPu = 1, PriorityFlag = true, Q0Pu = 0.118, QLimFlag = true, QMaxPu = 0.8, QMinPu = -0.8, ResPu = 0.015, SNom = 100, StorageFlag = false, U0Pu = 1, UPhase0 = -0.237, XesPu = 0.15)  annotation(
    Placement(visible = true, transformation(origin = {3.55271e-15, 3.55271e-15}, extent = {{-60, -60}, {60, 60}}, rotation = 0)));

equation

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end VoltageSourceIEC63406_INIT;
