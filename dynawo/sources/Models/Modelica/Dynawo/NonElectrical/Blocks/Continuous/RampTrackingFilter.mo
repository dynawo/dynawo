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

model RampTrackingFilter "Ramp tracking filter"
  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Real K = 1 "Gain";
  parameter Integer M "Lag order";
  parameter Integer N "Order";
  parameter Types.Time t1 "Lead time constant in s";
  parameter Types.Time t2 "Lag time constant in s";

  final parameter Integer NMax = 4 "Maximum order (>= 2)";

  Real z[NMax] "Intermediate vector whose sum equals leadMOrderLagCascade[N].y";

  Modelica.Blocks.Math.Gain gain(k = K) annotation(
    Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LeadMOrderLag leadMOrderLagCascade[NMax](each M = M, each t1 = t1, each t2 = t2, each Y0 = Y0) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  parameter Real Y0 = 0 "Initial or guess value of output";

equation
  assert(N <= NMax, "Maximum order is NMax = 4");
  assert((N > 0 and M > 0) or N == 0, "If N > 0 then also M must be positive");
  assert((t1 > 0 and t2 > 0) or ((not t1 > 0) and (not t2 > 0)), "Either t1 = t2 = 0 or t1 > 0 and t2 > 0");

  connect(u, gain.u) annotation(
    Line(points = {{-120, 0}, {-76, 0}, {-76, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(gain.y, leadMOrderLagCascade[1].u) annotation(
    Line(points = {{-50, 0}, {-26, 0}, {-26, 0}, {-24, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  for i in 1:NMax-1 loop
    connect(leadMOrderLagCascade[i].y, leadMOrderLagCascade[i+1].u);
  end for;

  for n in 1:NMax loop
    if n == N then
      z[n] = leadMOrderLagCascade[n].y;
    else
      z[n] = 0;
    end if;
  end for;

  if N == 0 then
    y = gain.y;
  else
    y = sum(z);
  end if;

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-16, -20}, extent = {{-60, 22}, {78, -36}}, textString = "(1 + sT2)"), Line(origin = {-16.2294, -0.321101}, points = {{-56, 0}, {86, 0}}), Text(origin = {-18, 42}, extent = {{-60, 22}, {78, -34}}, textString = "(1 + sT1)"), Text(origin = {-66, -4}, extent = {{-60, 22}, {12, -12}}, textString = "k"), Text(origin = {100, -26}, extent = {{-60, 22}, {-4, -2}}, textString = "M"), Text(origin = {122, 48}, extent = {{-60, 22}, {-4, -2}}, textString = "N"), Line(origin = {-75.3211, 0.3211}, points = {{5, 60}, {-5, 60}, {-5, -60}, {5, -60}}), Line(origin = {75, -1.3211}, points = {{-5, 61.3211}, {5, 61.3211}, {5, -58.6789}, {-5, -58.6789}}), Line(points = {{110, 0}, {20, 0}, {20, 0}, {22, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash)}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {-75, -23}, extent = {{-15, 7}, {175, -41}}, textString = "leadMOrderLagCascade is an array of cascaded-connected
LeadMOrderLag blocks, see text view"), Line(origin = {-38.5, 0}, points = {{-11.5, 0}, {12.5, 0}, {10.5, 0}}, color = {0, 0, 177}, pattern = LinePattern.Dash), Line(origin = {61.5, 0}, points = {{-39.5, 0}, {40.5, 0}, {36.5, 0}}, color = {0, 0, 158}, pattern = LinePattern.Dash)}),
    Documentation(info = "<html><head></head><body>Model to implement the following transfer function:<div><font face=\"Courier New\"><span class=\"Apple-tab-span\" style=\"font-size: 12px; white-space: pre;\">  </span>&nbsp; &nbsp; &nbsp; &nbsp;<span style=\"font-size: 12px;\">&nbsp;_ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;_</span></font></div><div style=\"font-size: 12px;\"><font face=\"Courier New\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">  </span>&nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|^N</font></div><div style=\"font-size: 12px;\"><div style=\"font-size: medium;\"><div style=\"font-size: 12px;\"><font face=\"Courier New\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>y &nbsp; &nbsp; &nbsp; | &nbsp;(1 +&nbsp;s*t1) &nbsp;|</font></div><div style=\"font-size: 12px;\"><font face=\"Courier New\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>- = k * |--------------|</font></div><div style=\"font-size: 12px;\"><font face=\"Courier New\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\"> </span>u &nbsp; &nbsp; &nbsp; | (1 + s*t2)^M |</font></div><div style=\"font-size: 12px;\"><font face=\"Courier New\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">  </span>&nbsp; &nbsp; &nbsp; &nbsp;|_ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;_|</font></div><div style=\"font-size: 12px;\"><br></div></div></div><div>If N = 0 then the block implements a static gain, otherwise both M and N must be greater than 0. If t1 = 0 and t2 = 0, the block also implements a static gain.</div><div><br></div><div>Neither output limitation nor anti-windup are implemented.</div><div><br></div><div><div>If N &gt; 0, y = leadMOrderLagCascade[N].y but for such an equation to be compiled, the value of N has to be known during the compilation, thus making it impossible to change N before the simulation.</div><div><br></div><div>A workaround has been found with a vector z of the same size as leadMOrderLagCascade, whose components are either 0 or (for the Nth) leadMOrderLagCascade[N].y. The sum of z is therefore leadMOrderLagCascade[N].y.</div></div></body></html>"));
end RampTrackingFilter;
