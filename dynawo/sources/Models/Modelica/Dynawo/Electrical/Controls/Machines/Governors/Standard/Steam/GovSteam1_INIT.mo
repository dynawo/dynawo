within Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model GovSteam1_INIT "Initialization model for GovSteam1"
  import Modelica;

  extends AdditionalIcons.Init;

  //Regulation parameter
  parameter Boolean ValveOn "Nonlinear valve characteristic. true = nonlinear valve characteristic is used. false = nonlinear valve characteristic is not used. Typical value = true";

  //Table parameters
  parameter String PgvInvTableName "Name of inverse table in text file for the characteristic of the rectifier regulator";
  parameter String TablesFile "Text file that contains the characteristic of the rectifier regulator";

  //Input parameter
  Modelica.Blocks.Interfaces.RealInput Pm0Pu "Initial mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  //Output parameter
  Modelica.Blocks.Interfaces.RealOutput PmRef0Pu "Initial reference mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  Modelica.Blocks.Sources.BooleanConstant booleanConstantInit(k = ValveOn) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds pgvInvInit(fileName = TablesFile, tableName = PgvInvTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchInit annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(pgvInvInit.y[1], switchInit.u1) annotation(
    Line(points = {{1, 40}, {20, 40}, {20, 8}, {37, 8}}, color = {0, 0, 127}));
  connect(booleanConstantInit.y, switchInit.u2) annotation(
    Line(points = {{1, 0}, {37, 0}}, color = {255, 0, 255}));
  connect(switchInit.y, PmRef0Pu) annotation(
    Line(points = {{61, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(Pm0Pu, pgvInvInit.u) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, 40}, {-22, 40}}, color = {0, 0, 127}));
  connect(Pm0Pu, switchInit.u3) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, -40}, {20, -40}, {20, -8}, {38, -8}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end GovSteam1_INIT;
