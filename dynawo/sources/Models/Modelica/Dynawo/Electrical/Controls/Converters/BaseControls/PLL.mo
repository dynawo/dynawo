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

model PLL "Phase-locked loop"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit KpPll "Proportional gain of the phase-locked loop (PLL)";
  parameter Types.PerUnit KiPll "Integral gain of the phase-locked loop (PLL)";
  parameter Types.Angle Theta0  "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians";

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-120.5, 39.5}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 0), iconTransformation(origin = {-109.5, 51.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120.5, -40.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-109, -59}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {120.5, -30.5}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 0), iconTransformation(origin = {109, 50}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {120, 31}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {109.5, -50.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(k = Dynawo.Electrical.SystemBase.omegaNom, y_start = Theta0)  annotation(
    Placement(visible = true, transformation(origin = {45.5, -29.5}, extent = {{-15.5, -15.5}, {15.5, 15.5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {45, 31}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-14.5, -29.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KpPll)  annotation(
    Placement(visible = true, transformation(origin = {-55.5, -7.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = KiPll, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-57, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(gain.y, add1.u1) annotation(
    Line(points = {{-47, -7.5}, {-27, -7.5}, {-27, -23}}, color = {0, 0, 127}));
  connect(integrator1.y, add1.u2) annotation(
    Line(points = {{-46, -50}, {-28, -50}, {-28, -36}, {-27, -36}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{63, -29}, {107, -29}, {107, -30.5}, {120.5, -30.5}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{-3, -29.5}, {25, -29.5}, {25, -29}, {27, -29}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u1) annotation(
    Line(points = {{-120, 40}, {26, 40}, {26, 40}, {27, 40}}, color = {0, 0, 127}));
  connect(add.y, omegaPu) annotation(
    Line(points = {{62, 31}, {120, 31}}, color = {0, 0, 127}));
  connect(add1.y, add.u2) annotation(
    Line(points = {{-3, -29.5}, {13, -29.5}, {13, 22}, {27, 22}}, color = {0, 0, 127}));
  connect(uqFilterPu, integrator1.u) annotation(
    Line(points = {{-120, -40}, {-89, -40}, {-89, -50}, {-69, -50}, {-69, -50}}, color = {0, 0, 127}));
  connect(uqFilterPu, gain.u) annotation(
    Line(points = {{-120, -40}, {-89, -40}, {-89, -8}, {-64, -8}, {-64, -7}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {-88, 90.5}, extent = {{-12, 9.5}, {188, -190.5}}), Text(origin = {2, 0.5}, extent = {{-53, 37.5}, {53, -37.5}}, textString = "PLL")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})));

end PLL;
