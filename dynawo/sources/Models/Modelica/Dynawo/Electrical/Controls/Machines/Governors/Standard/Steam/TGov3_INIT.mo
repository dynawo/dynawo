within Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model TGov3_INIT "IEEE governor type TGOV3 initialization model"
  extends AdditionalIcons.Init;

  //Table parameters
  parameter String FValveInvTableName "Name of table in text file for pressure as a function of flow rate";
  parameter String TablesFile "Text file that contains the table for the function";

  //Input parameter
  Modelica.Blocks.Interfaces.RealInput Pm0Pu "Initial mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  //Output parameter
  Modelica.Blocks.Interfaces.RealOutput Pr0Pu "Initial pressure in reheater in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1DsInit(fileName = TablesFile, tableName = FValveInvTableName, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(Pm0Pu, combiTable1DsInit.u) annotation(
    Line(points = {{-120, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(combiTable1DsInit.y[1], Pr0Pu) annotation(
    Line(points = {{12, 0}, {110, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end TGov3_INIT;
