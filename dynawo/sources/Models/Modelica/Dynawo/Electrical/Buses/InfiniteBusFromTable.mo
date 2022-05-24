within Dynawo.Electrical.Buses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model InfiniteBusFromTable "Infinite bus with UPu, UPhase and omegaRefPu given by tables as functions of time"
  import Modelica;
  import Dynawo.Connectors;

  extends AdditionalIcons.Bus;

  Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {-1.42109e-14, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-1.42109e-14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter String TableFile "Text file that contains the tables to get UPu, UPhase and omegaRefPu from time";
  parameter String OmegaRefPuTableName "Name of the table in the text file to get omegaRefPu from time";
  parameter String UPuTableName "Name of the table in the text file to get UPu from time";
  parameter String UPhaseTableName "Name of the table in the text file to get UPhase from time";

  Types.AngularVelocityPu omegaRefPu "Infinite bus frequency in pu (base omegaNom)";
  Types.PerUnit UPu "Infinite bus voltage module in pu (base UNom)";
  Types.Angle UPhase "Infinite bus voltage angle in rad";

  Modelica.Blocks.Tables.CombiTable1D tableOmegaRefPu(tableOnFile = true, tableName = OmegaRefPuTableName, fileName = TableFile) "Table to get omegaRefPu from time";
  Modelica.Blocks.Tables.CombiTable1D tableUPu(tableOnFile = true, tableName = UPuTableName, fileName = TableFile) "Table to get UPu from time";
  Modelica.Blocks.Tables.CombiTable1D tableUPhase(tableOnFile = true, tableName = UPhaseTableName, fileName = TableFile) "Table to get UPhase from time";

equation
  tableOmegaRefPu.u[1] = time;
  tableUPu.u[1] = time;
  tableUPhase.u[1] = time;
  omegaRefPu = tableOmegaRefPu.y[1];
  UPu = tableUPu.y[1];
  UPhase = tableUPhase.y[1];
  terminal.V = UPu * ComplexMath.exp(ComplexMath.j * UPhase);

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The InfiniteBusFromTable model imposes a complex voltage value: the bus voltage magnitude, angle and frequency are given by tables as functions of time.</body></html>"));
end InfiniteBusFromTable;
