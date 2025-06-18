within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model VRDTRI8 "Simplified voltage regulator for I8 fiche of DTR"

  parameter Types.PerUnit Gain "Control gain";
  parameter Types.Time tFirstOrderVR "First order time constant of voltage regulator (in seconds)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 6}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Exciter field voltage in pu (user-selected base voltage)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFirstOrderVR, k = Gain) annotation(
    Placement(visible = true, transformation(origin = {14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Efd0Pu "Initial exciter field voltage, i.e. Efd0PuLF if compliant with saturations, in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  connect(UsRefPu, add.u1) annotation(
    Line(points = {{-120, 6}, {-66, 6}}, color = {0, 0, 127}));
  connect(UsPu, add.u2) annotation(
    Line(points = {{-120, -20}, {-76, -20}, {-76, -6}, {-66, -6}}, color = {0, 0, 127}));
  connect(add.y, firstOrder.u) annotation(
    Line(points = {{-42, 0}, {2, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, EfdPu) annotation(
    Line(points = {{26, 0}, {110, 0}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.0.1")));
end VRDTRI8;
