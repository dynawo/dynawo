within Dynawo.Electrical.Controls.Voltage.SecondaryVoltageControl.Simplified;

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

model SecondaryVoltageControl "Model for simplified secondary voltage control"
  import Modelica;
  import Dynawo.Types;

  //Regulation parameters
  parameter Types.PerUnit Alpha "PI integral gain";
  parameter Types.PerUnit Beta "PI proportional gain";
  parameter Types.PerUnit DerLevelMaxPu "Level slope limitation in pu/min (base QNomAlt)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UpPu(start = Up0Pu) "Voltage of pilot point in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UpRefPu(start = UpRef0Pu) "Reference voltage of pilot point in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput level(start = Level0) "Level demand (between -1 and 1)" annotation(
    Placement(visible = true, transformation(origin = {150, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Blocks
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1) annotation(
    Placement(visible = true, transformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {70, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = 1, y_start = Level0) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = DerLevelMaxPu / 60) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Alpha) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Beta) annotation(
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit Level0 "Initial level demand (between -1 and 1)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu Up0Pu "Initial pilot point voltage in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UpRef0Pu "Initial reference voltage of pilot point in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));

equation
  connect(limiter.y, level) annotation(
    Line(points = {{121, 6}, {150, 6}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add.u2) annotation(
    Line(points = {{21, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{-59, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(UpRefPu, feedback1.u1) annotation(
    Line(points = {{-160, 0}, {-128, 0}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{81, 6}, {98, 6}}, color = {0, 0, 127}));
  connect(limiter1.y, limIntegrator.u) annotation(
    Line(points = {{-19, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-111, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(UpPu, feedback1.u2) annotation(
    Line(points = {{-160, -60}, {-120, -60}, {-120, -8}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{-110, 0}, {-100, 0}, {-100, 40}, {-82, 40}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{-58, 40}, {40, 40}, {40, 12}, {58, 12}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end SecondaryVoltageControl;
