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

model CurrentSourceIEC63406_INIT "Initialisation model for the IEC 63406 standard with current source"

  Dynawo.Electrical.Sources.ConverterCurrentSourceIEC63406_INIT converterCurrentSourceIEC63406_INIT(BesPu = 0, GesPu = 0, IMaxPu = 1.3, P0Pu = -0.5, PMaxPu = 1, PriorityFlag = true, Q0Pu = 0.289, QLimFlag = false, QMaxPu = 0.8, QMaxtoPTableName = "QMaxtoPTable", QMaxtoUTableName = "QMaxtoUTable", QMinPu = -0.8, QMintoPTableName = "QMintoPTable", QMintoUTableName = "QMintoUTable", ResPu = 0, SNom = 1000, StorageFlag = false, TableFileName = "../dynawo/examples/DynaSwing/IEC/Converter/IEC63406CurrentSourceUCPO/TableFile.txt", U0Pu = 1, UPhase0 = 0.081, XesPu = 0)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-60, -60}, {60, 60}}, rotation = 0)));

equation

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end CurrentSourceIEC63406_INIT;
