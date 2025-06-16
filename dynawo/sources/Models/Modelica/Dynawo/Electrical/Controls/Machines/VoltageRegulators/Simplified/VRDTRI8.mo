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

model VRDTRI8 "Simplified voltage regulator model for I8 fiche of DTR"
  parameter Types.PerUnit Gain "Control gain";
  parameter Types.Time tFirstOrderVR "First order time constant of voltage regulator (in seconds)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Exciter field voltage in pu (user-selected base voltage)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFirstOrderVR, k = Gain, y_start = Efd0Pu) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));

  //Initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial exciter field voltage, i.e. Efd0PuLF if compliant with saturations, in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  connect(UsRefPu, feedback.u1) annotation(
    Line(points = {{-120, 0}, {-58, 0}}, color = {0, 0, 127}));
  connect(UsPu, feedback.u2) annotation(
    Line(points = {{-120, -40}, {-50, -40}, {-50, -8}}, color = {0, 0, 127}));
  connect(feedback.y, firstOrder.u) annotation(
    Line(points = {{-40, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, EfdPu) annotation(
    Line(points = {{21, 0}, {110, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>Reference documentation :&nbsp;<div>Documentation Technique de Référence (DTR)&nbsp;</div><div>Chapitre 8 – Trames Types
<br>Article 8.3.3 – Trame de procédure de contrôle de conformité pour le
raccordement d’une installation de production ou de stockage, page 57 (fiche I8).</div></div></body></html>"));
end VRDTRI8;
