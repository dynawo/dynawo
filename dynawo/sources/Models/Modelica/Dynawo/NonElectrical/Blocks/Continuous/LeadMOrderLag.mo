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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model LeadMOrderLag "Lead-lag filter with M poles"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Real K = 1 "Gain";
  parameter Integer M "Lag order";
  parameter Types.Time t1 "Lead time constant in s";
  parameter Types.Time t2 "Lag time constant in s";

  final parameter Integer MMax = 6 "Maximum lag order (>= 3)";

  Real z[MMax-1] "Intermediate vector whose sum equals firstOrderCascade[M-1].y";

  Modelica.Blocks.Continuous.FirstOrder firstOrderCascade[MMax-1](each T = t2, each y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction leadlag(a = {t2, 1}, b = K * {t1, 1}) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Real Y0 = 0 "Initial or guess value of output";

equation
  assert((t1 > 0 and t2 > 0) or ((not t1 > 0) and (not t2 > 0)), "Either t1 = t2 = 0 or t1 > 0 and t2 > 0");
  assert(M > 0, "Minimum lag order is 1");
  assert(M <= MMax, "Maximum lag order is MMax = 6");

  connect(u, leadlag.u) annotation(
    Line(points = {{-120, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(leadlag.y, firstOrderCascade[1].u);

  for i in 1:MMax-2 loop
    connect(firstOrderCascade[i].y, firstOrderCascade[i+1].u);
  end for;

  for m in 2:MMax loop
    if m == M then
      z[m-1] = firstOrderCascade[m-1].y;
    else
      z[m-1] = 0;
    end if;
  end for;

  if M == 1 then
    y = leadlag.y;
  else
    y = sum(z);
  end if;

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-2, -24}, extent = {{-60, 22}, {78, -36}}, textString = "(1 + sT2)"), Line(origin = {4, 0}, points = {{-64, 0}, {86, 0}}), Text(origin = {8, 28}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT1"), Text(origin = {-56, -2}, extent = {{-60, 22}, {12, -12}}, textString = "k"), Text(origin = {114, -28}, extent = {{-60, 22}, {-4, -2}}, textString = "M")}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {-139, -3}, extent = {{31, -19}, {243, -37}}, textString = "firstOrderCascade is an array of cascaded-connected
FirstOrder blocks, see text view"), Line(origin = {-21, 0}, points = {{-15, 0}, {15, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash), Line(origin = {61, 0}, points = {{-37, 0}, {37, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash)}),
    Documentation(info = "<html><head></head><body>Model to implement the following transfer function:<div><br></div><div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>y &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1 +&nbsp;s*t1</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>- = k * ---------------</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>u &nbsp; &nbsp; &nbsp; &nbsp;(1 + s*t2)^M</div></div><div><br></div><div>It is required that M &gt; 0. If t1 = 0 and t2 = 0 then the block is a static gain, otherwise it is required that t1 &gt; 0 and t2 &gt; 0.</div><div><br></div><div>If M &gt; 1, y = firstOrderCascade[M-1].y but for such an equation to be compiled, the value of M has to be known during the compilation, thus making it impossible to change M before the simulation.</div><div><br></div><div>A workaround has been found with a vector z of the same size as firstOrderCascade, whose components are either 0 or (for the M-1th) firstOrderCascade[M-1].y. The sum of z is therefore firstOrderCascade[M-1].y.</div></body></html>"));
end LeadMOrderLag;
