within Dynawo.Electrical.Controls.Converters.BaseControls;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model PLLGF "Phase-locked loop"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit KpPll "Proportional gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit KiPll "Integral gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians";

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-120.5, 40.5}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-119.5, -29.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-110, -51}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {120.5, -18.5}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 0), iconTransformation(origin = {109, -60}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {120, 31}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {109.5, 50.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(k = Dynawo.Electrical.SystemBase.omegaNom, y_start = Theta0)  annotation(
    Placement(visible = true, transformation(origin = {47.5, -18.5}, extent = {{-15.5, -15.5}, {15.5, 15.5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {45, 32}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-5.5, -18.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KpPll)  annotation(
    Placement(visible = true, transformation(origin = {-50.5, -0.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = KiPll, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-53, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(gain.y, add1.u1) annotation(
    Line(points = {{-42, -0.5}, {-18, -0.5}, {-18, -12}}, color = {0, 0, 127}));
  connect(integrator1.y, add1.u2) annotation(
    Line(points = {{-42, -40}, {-18, -40}, {-18, -25}}, color = {0, 0, 127}));
  connect(uqFilterPu, integrator1.u) annotation(
    Line(points = {{-119.5, -29.5}, {-89, -29.5}, {-89, -40}, {-65, -40}}, color = {0, 0, 127}));
  connect(uqFilterPu, gain.u) annotation(
    Line(points = {{-119.5, -29.5}, {-89, -29.5}, {-89, -0.5}, {-59.5, -0.5}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u1) annotation(
    Line(points = {{-120.5, 40.5}, {-102, 40.5}, {-102, 41}, {27, 41}}, color = {0, 0, 127}));
  connect(add.y, omegaPu) annotation(
    Line(points = {{62, 32}, {106, 32}, {106, 31}, {120, 31}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{65, -18.5}, {120.5, -18.5}}, color = {0, 0, 127}));
  connect(add1.y, add.u2) annotation(
    Line(points = {{6, -18.5}, {16, -18.5}, {16, 23}, {27, 23}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{6, -18.5}, {28, -18.5}, {28, -18}, {29, -18}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {-88, 90.5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-12, 9.5}, {188, -190.5}}), Text(origin = {2, 0.5}, extent = {{-53, 37.5}, {53, -37.5}}, textString = "PLL")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, initialScale = 0.1)));

end PLLGF;
