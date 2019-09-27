within Dynawo.NonElectrical.Blocks.NonLinear;

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

block LeadLag

  import Modelica.Blocks;
  import Modelica.Blocks.Interfaces;
  import Modelica.Blocks.Icons.Block;

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends Block;

public

  parameter Real K = 1 "Gain";
  parameter Types.Time T1 "Lead time constant";
  parameter Types.Time T2 "Lag time constant";
  annotation(Evaluate=true,
      Dialog(group="Initialization"));
  Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain gain(k = K * T1 / T2)  annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder firstOrder(
    T = T1,
    k = (T1 - T2) / (K * T1), y_start = y0 * (T1 - T2) / (K * T1))
    annotation(
    Placement(visible = true, transformation(origin = {2, -46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Interfaces.RealInput u (start = u0) "Input signal connector" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y (start = y0) "Output signal connector" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

protected

  parameter Real u0 "Initial input";
  parameter Real y0 "Initial output";

equation

  connect(firstOrder.y, feedback.u2) annotation(
    Line(points = {{-8, -46}, {-40, -46}, {-40, -8}}, color = {0, 0, 127}));
  connect(u, feedback.u1) annotation(
    Line(points = {{-120, 0}, {-48, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-31, 0}, {-10, 0}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder.u) annotation(
    Line(points = {{14, 0}, {60, 0}, {60, -46}, {14, -46}, {14, -46}, {14, -46}}, color = {0, 0, 127}));
  connect(gain.y, y) annotation(
    Line(points = {{14, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {14, -36}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT2"), Line(origin = {4, 0}, points = {{-64, 0}, {86, 0}}), Text(origin = {12, 32}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT1"), Text(origin = {-56, -4}, extent = {{-60, 22}, {12, -12}}, textString = "k")}),
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2),
  Documentation(info = "<html><head></head><body>Lead-lag filter (no output limitations):<div><br></div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\"> </span>y<span class=\"Apple-tab-span\" style=\"white-space:pre\"> </span>&nbsp; &nbsp;&nbsp;1 + s*T1</div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\"> </span>- = k * ----------------</div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\"> </span>u<span class=\"Apple-tab-span\" style=\"white-space:pre\"> </span>&nbsp; &nbsp;&nbsp;1 + s*T2</div><div><br></div><div>Neither output limitation nor anti-windup are implemented.</div><div><br></div><div>The dynamic parts are removed if T1=0 and T2=0. Otherwise, both T1 and T2 need to be positive.</div><div><br></div><div>By default, T1 and T2 are structural parameters, so they cannot be changed at runtime without recompiling the model. In order to do so, set the noDynamics parameter explicitly to false (note that you can't change T1 and T2 to zero at runtime in this case).</div></body></html>"));

end LeadLag;
