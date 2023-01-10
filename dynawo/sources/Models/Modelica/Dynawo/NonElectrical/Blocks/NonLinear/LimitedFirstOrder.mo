within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block LimitedFirstOrder "First-order filter with non-windup limiter"
  import Modelica;
  import Dynawo.Types;

  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Types.PerUnit K = 1 "Gain";
  parameter Types.Time tFilter "Time constant in s";
  parameter Real YMax "Upper limits of output signal";
  parameter Real YMin = -YMax "Lower limits of output signal";

  Modelica.Blocks.Nonlinear.Limiter lim(uMax = YMax, uMin = YMin) annotation(
    Placement(visible = true, transformation(origin = {52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain G(k = 1 / tFilter) annotation(
    Placement(visible = true, transformation(origin = {-24, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator I(k = 1, y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Gk(k = K) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Real Y0 = 0 "Initial or guess value of output";

equation
  connect(Gk.u, u) annotation(
    Line(points = {{-94, 0}, {-108, 0}, {-108, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(Gk.y, feedback.u1) annotation(
    Line(points = {{-70, 0}, {-66, 0}, {-66, 0}, {-64, 0}}, color = {0, 0, 127}));
  connect(lim.y, feedback.u2) annotation(
    Line(points = {{63, 0}, {74, 0}, {74, -32}, {-56, -32}, {-56, -8}}, color = {0, 0, 127}));
  connect(feedback.y, G.u) annotation(
    Line(points = {{-47, 0}, {-36, 0}}, color = {0, 0, 127}));
  connect(lim.y, y) annotation(
    Line(points = {{64, 0}, {104, 0}, {104, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(I.y, lim.u) annotation(
    Line(points = {{27, 0}, {40, 0}}, color = {0, 0, 127}));

  // The simplified model has no saturation, to make the controller equations linear
  I.u = if G.y >= 0 and lim.u > lim.uMax or G.y <= 0 and lim.u < lim.uMin then 0 else G.y;

  annotation(
  preferredView = "diagram",
  Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {0, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {42, 118.943}, {80, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {12, 28}, extent = {{-44, 34}, {26, -16}}, textString = "k"), Text(origin = {2, -44}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT"), Line(origin = {4, 0}, points = {{-86, 0}, {86, 0}})}),
  Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Line(origin = {-12.32, -0.16}, points = {{-12, 0}, {12, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash), Text(origin = {-27, 34}, extent = {{-87, 34}, {137, -28}}, textString = "I.u = if (G.y >= 0 and lim.u > lim.uMax) or (G.y <= 0 and lim.u < lim.uMin) then 0 else G.y

(see text view)"), Line(origin = {85, -61}, points = {{75, 25}}), Line(origin = {-4.62687, 9.80597}, points = {{0, 14}, {0, -8}}, arrow = {Arrow.None, Arrow.Open}, arrowSize = 5), Text(origin = {-22, 53}, extent = {{-96, 11}, {16, -3}}, textString = "Integrator charging
 upper limiter engaged"), Text(origin = {78, 53}, extent = {{-94, 11}, {16, -3}}, textString = "Integrator discharging
 lower limiter engaged")}),
  Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">Block to implement a first order filter:</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>y &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;k</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>- = ------------------</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>u&nbsp; &nbsp; &nbsp; 1 + s*tFilter</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">It is required that tFilter &gt; 0.</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Output limiter with anti-windup is also implemented.</div></body></html>"));
end LimitedFirstOrder;
