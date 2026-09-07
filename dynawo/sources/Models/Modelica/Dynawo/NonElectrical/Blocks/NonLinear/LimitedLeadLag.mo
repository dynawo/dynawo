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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block LimitedLeadLag "Simple lead-lag filter, with output limitation"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Types.PerUnit K = 1 "Gain";
  parameter Types.Time t1 "Lead time constant in s";
  parameter Types.Time t2 "Lag time constant in s";
  parameter Real Y0 = 0 "Initial or guess value of output" annotation(
    Dialog(group="Initialization"));
  parameter Real YMax "Upper limit of output signal";
  parameter Real YMin = -YMax "Lower limit of output signal";

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = K * t1 / t2) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T = t1,
    k = (t1 - t2) / (K * t1), y_start = Y0 * (t1 - t2) / (K * t1)) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = YMax, uMin = YMin) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(firstOrder.y, feedback.u2) annotation(
    Line(points = {{-21, -60}, {-60, -60}, {-60, -8}}, color = {0, 0, 127}));
  connect(u, feedback.u1) annotation(
    Line(points = {{-120, 0}, {-68, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-51, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(limiter.y, y) annotation(
    Line(points = {{42, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(limiter.y, firstOrder.u) annotation(
    Line(points = {{42, 0}, {60, 0}, {60, -60}, {2, -60}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{0, 0}, {20, 0}}, color = {0, 0, 127}));

  annotation(
  preferredView = "diagram",
  Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {0, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {42, 118.943}, {80, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {14, -36}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT2"), Line(origin = {4, 0}, points = {{-64, 0}, {86, 0}}), Text(origin = {12, 32}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT1"), Text(origin = {-56, -4}, extent = {{-60, 22}, {12, -12}}, textString = "k")}),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}}, initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>Lead-lag filter (no output limitations):<div><br></div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\">  </span>y<span class=\"Apple-tab-span\" style=\"white-space:pre\">  </span>&nbsp; &nbsp; &nbsp; &nbsp;1 + s*t1</div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\">  </span>- = K * ----------------</div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\">  </span>u<span class=\"Apple-tab-span\" style=\"white-space:pre\">  </span>&nbsp; &nbsp; &nbsp; &nbsp;1 + s*t2</div><div><br></div><div>Neither output limitation nor anti-windup are implemented.</div><div><br></div><div>Both t1 and t2 need to be strictly positive.</div><div><br></div><div>By default, t1 and t2 are structural parameters, so they cannot be changed at runtime without recompiling the model.</div></body></html>"));
end LimitedLeadLag;
