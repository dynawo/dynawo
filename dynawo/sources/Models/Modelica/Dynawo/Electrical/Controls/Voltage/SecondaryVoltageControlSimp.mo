within Dynawo.Electrical.Controls.Voltage;

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

model SecondaryVoltageControlSimp "Model for simplified secondary voltage control"
  import Modelica;
  import Dynawo.Types;

  //Regulation parameters
  parameter Types.PerUnit Ck "Sensitivity of voltage to level variations in pu (base UNom)";
  parameter Types.PerUnit DnsDtm "Level slope limitation in pu/min (base QNomAlt)";
  parameter Types.Time tau "PI time constant in s";
  parameter Types.Time tI "Closed loop target time constant in s";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UpRefPu(start = UpRef0Pu) "Reference voltage of pilot point in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -60}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UpPu(start = Up0Pu) "Voltage of pilot point in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput level(start = Level0) "Level demand" annotation(
    Placement(visible = true, transformation(origin = {230, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1) annotation(
    Placement(visible = true, transformation(origin = {190, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {150, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = 1, y_start = Level0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = DnsDtm / 60) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / (Ck * tI)) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = tau) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit Level0 "Initial level demand" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu Up0Pu "Initial pilot point voltage in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UpRef0Pu "Initial reference voltage of pilot point in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));

equation
  connect(limiter.y, level) annotation(
    Line(points = {{201, 6}, {230, 6}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add.u2) annotation(
    Line(points = {{101, 0}, {138, 0}}, color = {0, 0, 127}));
  connect(gain.y, gain1.u) annotation(
    Line(points = {{1, 0}, {20, 0}, {20, 60}, {38, 60}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{1, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(UpRefPu, feedback1.u1) annotation(
    Line(points = {{-220, 0}, {-68, 0}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{161, 6}, {178, 6}}, color = {0, 0, 127}));
  connect(limiter1.y, limIntegrator.u) annotation(
    Line(points = {{61, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-51, 0}, {-23, 0}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{62, 60}, {120, 60}, {120, 12}, {138, 12}}, color = {0, 0, 127}));
  connect(UpPu, feedback1.u2) annotation(
    Line(points = {{-220, -60}, {-60, -60}, {-60, -8}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -200}, {220, 200}})));
end SecondaryVoltageControlSimp;
