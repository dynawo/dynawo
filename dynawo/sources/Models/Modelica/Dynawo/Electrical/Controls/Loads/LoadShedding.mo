within Dynawo.Electrical.Controls.Loads;

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

model LoadShedding "Load shedding model using a CombiTimeTable"

  parameter String LoadSheddingProfileFileName = "NoName" "Name of the file where the table describing the load shedding profile over time is stored";
  parameter String LoadSheddingProfileTableName = "NoName" "Name of the table describing the load shedding profile over time";

  Modelica.Blocks.Interfaces.RealInput deltaPNom(start = 0) "Nominal active power variation required by the load shedding" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput deltaQNom(start = 0) "Nominal reactive power variation required by the load shedding" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput deltaP(start = 0) "Active power variation applied to the load after applying the load shedding profile" annotation(
    Placement(visible = true, transformation(origin = {110, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput deltaQ(start = 0) "Reactive power variation applied to the load after applying the load shedding profile" annotation(
    Placement(visible = true, transformation(origin = {110, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.CombiTimeTable loadSheddingProfileP(fileName = LoadSheddingProfileFileName, tableName = LoadSheddingProfileTableName, tableOnFile = true) "CombiTimeTable describing the load shedding profile for the active power. The values are normalized as the output is multiplied by deltaPNom." annotation(
    Placement(visible = true, transformation(origin = {-110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable loadSheddingProfileQ(fileName = LoadSheddingProfileFileName, tableName = LoadSheddingProfileTableName, tableOnFile = true) "CombiTimeTable describing the load shedding profile for the reactive power. The values are normalized as the output is multiplied by deltaQNom." annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {0, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {0, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(deltaPNom, product.u1) annotation(
    Line(points = {{-120, 80}, {-12, 80}}, color = {0, 0, 127}));
  connect(loadSheddingProfileP.y[1], product.u2) annotation(
    Line(points = {{-99, 34}, {-41, 34}, {-41, 68}, {-13, 68}}, color = {0, 0, 127}));
  connect(product.y, deltaP) annotation(
    Line(points = {{11, 74}, {109, 74}}, color = {0, 0, 127}));
  connect(product1.y, deltaQ) annotation(
    Line(points = {{11, -46}, {110, -46}}, color = {0, 0, 127}));
  connect(loadSheddingProfileQ.y[1], product1.u2) annotation(
    Line(points = {{-99, -80}, {-41, -80}, {-41, -52}, {-12, -52}}, color = {0, 0, 127}));
  connect(deltaQNom, product1.u1) annotation(
    Line(points = {{-120, -40}, {-12, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "text");
end LoadShedding;
