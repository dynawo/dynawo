within Dynawo.NonElectrical.Blocks.Continuous;

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

model LeadMOrderLag "Lead-lag filter with M poles"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Real K = 1 "Gain";
  parameter Integer M = 1 "Lag Order";
  parameter Types.Time t1 "Lead time constant";
  parameter Types.Time t2 "Lag time constant";
  parameter Real Y0 = 0 "Initial or guess value of output" annotation(
  Dialog(group="Initialization"));

  Modelica.Blocks.Continuous.FirstOrder firstOrderCascade[max(0, M-1)](each T = t2, each k = 1, each y_start = Y0) if M > 1 annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadlag(a = {t2, 1}, b = {K * t1, K}) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  assert((t1 > 0 and t2 > 0) or ((not t1 > 0) and (not t2 > 0)), "Either t1 = t2 = 0 or t1 > 0 and t2 > 0");
  assert(M > 0, "minimum lag order is 1");

  connect(u, leadlag.u) annotation(
    Line(points = {{-120, 0}, {-62, 0}}, color = {0, 0, 127}));

  if M > 1 then
    connect(leadlag.y, firstOrderCascade[1].u);
    connect(firstOrderCascade[M-1].y, y);
  else
    connect(leadlag.y, y);
  end if;

  if M > 2 then
    for i in 1:M-2 loop
      connect(firstOrderCascade[i].y, firstOrderCascade[i+1].u);
    end for;
  end if;

  annotation(
  preferredView = "text",
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, -24}, extent = {{-60, 22}, {78, -36}}, textString = "(1 + sT2)"), Line(origin = {4, 0}, points = {{-64, 0}, {86, 0}}), Text(origin = {8, 28}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT1"), Text(origin = {-56, -2}, extent = {{-60, 22}, {12, -12}}, textString = "k"), Text(origin = {114, -28}, extent = {{-60, 22}, {-4, -2}}, textString = "M")}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {-139, -3}, extent = {{31, -19}, {243, -37}}, textString = "firstOrderCascade is an array of cascaded-connected
FirstOrder blocks, see text view"), Line(origin = {-21, 0}, points = {{-15, 0}, {15, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash), Line(origin = {61, 0}, points = {{-37, 0}, {37, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash)}),
  Documentation(info = "<html><head></head><body>Model to implement the following transfer function:<div><br></div><div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>y &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1 +&nbsp;s*t1</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>- = k * ---------------</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>u &nbsp; &nbsp; &nbsp; &nbsp;(1 + s*t2)^M</div></div><div><br></div><div>It is required that M &gt; 0. If t1 = 0 and t2 = 0 then the block is a static gain, otherwise it is required that t1 &gt;0, and t2 &gt; 0.</div><div><br></div></body></html>"));
end LeadMOrderLag;
