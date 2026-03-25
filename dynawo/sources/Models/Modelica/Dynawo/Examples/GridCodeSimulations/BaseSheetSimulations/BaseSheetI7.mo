within Dynawo.Examples.GridCodeSimulations.BaseSheetSimulations;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseSheetI7
  extends BaseParameters;

  Electrical.Buses.InfiniteBusFromTable infiniteBusFromTable(TableFile = "../dynawo/dynawo/sources/Models/Modelica/Dynawo/Examples/GridCodeSimulations/BaseSheetSimulations/TableVoltageSurge.txt", OmegaRefPuTableName = "OmegaTable", UPuTableName = "VoltageTable", UPhaseTableName = "PhaseTable", U0Pu = 1, UPhase0 = 0, OmegaRef0Pu = 1)  annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

equation

end BaseSheetI7;
