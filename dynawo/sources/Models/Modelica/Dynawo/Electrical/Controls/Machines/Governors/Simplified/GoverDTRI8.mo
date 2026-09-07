within Dynawo.Electrical.Controls.Machines.Governors.Simplified;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GoverDTRI8 "Simplified governor model used for the setup of the DTR I8 fiche (proportional with no saturations)"
  parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
  parameter Types.Time tFirstOrderGover "First order time constant of governor (in seconds)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base PNom)" annotation(
    Placement(transformation(origin = {-120, 26}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNom)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant OmegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = KGover) annotation(
    Placement(transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFirstOrderGover, y_start = Pm0Pu) annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}})));

  //Initial parameter
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNom)";

equation
  connect(OmegaRefPu.y, feedback.u1) annotation(
    Line(points = {{-99, -40}, {-58, -40}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-41, -40}, {-22, -40}}, color = {0, 0, 127}));
  connect(add1.y, firstOrder.u) annotation(
    Line(points = {{41, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, PmPu) annotation(
    Line(points = {{81, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(PmRefPu, division.u1) annotation(
    Line(points = {{-120, 26}, {-42, 26}}, color = {0, 0, 127}));
  connect(omegaPu, division.u2) annotation(
    Line(points = {{-120, -80}, {-80, -80}, {-80, 14}, {-42, 14}}, color = {0, 0, 127}));
  connect(division.y, add1.u1) annotation(
    Line(points = {{-19, 20}, {9.5, 20}, {9.5, 6}, {18, 6}}, color = {0, 0, 127}));
  connect(omegaPu, feedback.u2) annotation(
    Line(points = {{-120, -80}, {-50, -80}, {-50, -48}}, color = {0, 0, 127}));
  connect(gain.y, add1.u2) annotation(
    Line(points = {{1, -40}, {9.5, -40}, {9.5, -6}, {18, -6}, {18, -6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>
    Reference documentation :&nbsp;<div>Documentation Technique de Référence (DTR)&nbsp;</div><div>Chapitre 8 – Trames Types
<br>Article 8.3.3 – Trame de procédure de contrôle de conformité pour le
raccordement d’une installation de production ou de stockage, page 57 (fiche I8).</div></body></html>"));
end GoverDTRI8;
