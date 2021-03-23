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

  parameter Types.PerUnit KpPll "Proportional gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit KiPll "Integral gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen" annotation(
    Dialog(group = "group", tab = "PLL"));

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0  "Start value of voltage angle at plan terminal (PCC) in rad" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsq0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-120.5, 69.5}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-119.5, -0.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-110, 1.33227e-15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWTCPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput theta(start = UPhase0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {120.5, 10.5}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 0), iconTransformation(origin = {109, -60}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {120, 71}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {109.5, 50.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(k = Dynawo.Electrical.SystemBase.omegaNom, y_start = UPhase0)  annotation(
    Placement(visible = true, transformation(origin = {46.5, 10.5}, extent = {{-15.5, -15.5}, {15.5, 15.5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {45, 61}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-38.5, 10.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KpPll)  annotation(
    Placement(visible = true, transformation(origin = {-69.5, 30.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = KiPll, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-1, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {-40, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant constant1(k = Upll2) annotation(
    Placement(visible = true, transformation(origin = {-70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
 connect(gain.y, add1.u1) annotation(
    Line(points = {{-61, 30.5}, {-51, 30.5}, {-51, 17}}, color = {0, 0, 127}));
  connect(integrator1.y, add1.u2) annotation(
    Line(points = {{-59, -10}, {-51, -10}, {-51, 4}}, color = {0, 0, 127}));
  connect(add.y, omegaPu) annotation(
    Line(points = {{61.5, 61}, {84.75, 61}, {84.75, 71}, {120, 71}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{64, 11}, {109, 11}, {109, 11}, {121, 11}}, color = {0, 0, 127}));
  connect(uqFilterPu, integrator1.u) annotation(
    Line(points = {{-119, 0}, {-89, 0}, {-89, -10}, {-82, -10}}, color = {0, 0, 127}));
 connect(uqFilterPu, gain.u) annotation(
    Line(points = {{-119, 0}, {-89, 0}, {-89, 30.5}, {-78.5, 30.5}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u1) annotation(
    Line(points = {{-120, 70}, {26, 70}, {26, 70}, {27, 70}}, color = {0, 0, 127}));
  connect(uWTCPu, less1.u1) annotation(
    Line(points = {{-120, -70}, {-80, -70}, {-80, -50}, {-52, -50}}, color = {0, 0, 127}));
  connect(constant1.y, less1.u2) annotation(
    Line(points = {{-59, -90}, {-52, -90}, {-52, -58}, {-52, -58}}, color = {0, 0, 127}));
  connect(add1.y, switch1.u3) annotation(
    Line(points = {{-27, 11}, {-24, 11}, {-24, 2}, {-13, 2}, {-13, 2}}, color = {0, 0, 127}));
  connect(const1.y, switch1.u1) annotation(
    Line(points = {{-29, 50}, {-20, 50}, {-20, 18}, {-13, 18}, {-13, 18}}, color = {0, 0, 127}));
  connect(switch1.y, integrator.u) annotation(
    Line(points = {{10, 10}, {29, 10}, {29, 11}, {28, 11}}, color = {0, 0, 127}));
  connect(switch1.y, add.u2) annotation(
    Line(points = {{10, 10}, {15, 10}, {15, 52}, {27, 52}, {27, 52}}, color = {0, 0, 127}));
 connect(less1.y, switch1.u2) annotation(
    Line(points = {{-29, -50}, {-18, -50}, {-18, 10}, {-13, 10}, {-13, 10}}, color = {255, 0, 255}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {-88, 90.5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-12, 9.5}, {188, -190.5}}), Text(origin = {2, 0.5}, extent = {{-53, 37.5}, {53, -37.5}}, textString = "PLL")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, initialScale = 0.1)));

end PLL;
