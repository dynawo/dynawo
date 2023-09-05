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
  extends AdditionalIcons.Bus;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter String TableFile "Text file that contains the tables to get UPu, UPhase and omegaRefPu from time";
  parameter String OmegaRefPuTableName "Name of the table in the text file to get omegaRefPu from time";
  parameter String UPuTableName "Name of the table in the text file to get UPu from time";
  parameter String UPhaseTableName "Name of the table in the text file to get UPhase from time";

  Types.AngularVelocityPu omegaRefPu(start = OmegaRef0Pu) "Infinite bus frequency in pu (base omegaNom)";
  Types.ActivePower P "Active power in MW (receptor convention)";
  Types.ActivePower PInj "Active power in MW (generator convention)";
  Types.ActivePowerPu PInjPu "Active power in pu (base SnRef) (generator convention)";
  Types.ActivePowerPu PPu "Active power in pu (base SnRef) (receptor convention)";
  Types.ReactivePower Q "Reactive power in Mvar (receptor convention)";
  Types.ReactivePower QInj "Reactive power in Mvar (generator convention)";
  Types.ReactivePowerPu QInjPu "Reactive power in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QPu "Reactive power in pu (base SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu sPu "Apparent power in pu (base SnRef) (receptor convention)";
  Types.Angle UPhase(start = UPhase0) "Infinite bus voltage angle in rad";
  Types.PerUnit UPu(start = U0Pu) "Infinite bus voltage module in pu (base UNom)";

  Modelica.Blocks.Sources.CombiTimeTable tableOmegaRefPu(tableOnFile = true, tableName = OmegaRefPuTableName, fileName = TableFile) "Table to get omegaRefPu from time";
  Modelica.Blocks.Sources.CombiTimeTable tableUPu(tableOnFile = true, tableName = UPuTableName, fileName = TableFile) "Table to get UPu from time";
  Modelica.Blocks.Sources.CombiTimeTable tableUPhase(tableOnFile = true, tableName = UPhaseTableName, fileName = TableFile) "Table to get UPhase from time";

  parameter Types.PerUnit U0Pu "Initial infinite bus voltage module in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial infinite bus voltage angle in rad";
  parameter Types.AngularVelocityPu OmegaRef0Pu "Initial infinite bus frequency in pu (base omegaNom)";

equation
  omegaRefPu = tableOmegaRefPu.y[1];
  UPu = tableUPu.y[1];
  UPhase = tableUPhase.y[1];
  terminal.V = UPu * ComplexMath.exp(ComplexMath.j * UPhase);

  sPu = Complex(PPu, QPu);
  sPu = terminal.V * ComplexMath.conj(terminal.i);
  P = SystemBase.SnRef * PPu;
  Q = SystemBase.SnRef * QPu;
  PInjPu = - PPu;
  QInjPu = - QPu;
  PInj = - P;
  QInj = - Q;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The InfiniteBusFromTable model imposes a complex voltage value: the bus voltage magnitude, angle and frequency are given by tables as functions of time.</body></html>"));
end InfiniteBusFromTable;
