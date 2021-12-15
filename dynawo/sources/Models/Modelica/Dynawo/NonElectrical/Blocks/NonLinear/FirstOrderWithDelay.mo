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

block FirstOrderWithDelay "Delay with a first order filter smoothing the input signal"

  import Modelica;
  import Dynawo;

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Dynawo.Types.Time tDelay "Delay time of output with respect to input signal, in s";
  parameter Real Y0 = 0 "Initial or guess value of output" annotation(
    Dialog(group="Initialization"));

  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = tDelay) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tDelay / 20, y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(firstOrder.y, fixedDelay.u) annotation(
    Line(points = {{-19, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(u, firstOrder.u) annotation(
    Line(points = {{-120, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(fixedDelay.y, y) annotation(
    Line(points = {{42, 0}, {110, 0}}, color = {0, 0, 127}));

  annotation(
  preferredView = "diagram",
  Documentation(info= "<html><head></head><body><p>
The input signal is delayed by a given time instant, or more precisely:
</p>
<pre> y = u(time - tDelay) for time &gt; time.start + tDelay
   = u(time.start)       for time ≤ time.start + tDelay
</pre>
<p>
The FirstOrder block defines the transfer function between the input u
and the input of the delay block as <em>first order</em> system:
</p>
<pre>                        k
   fixedDelay.u = ------------ * u
                    T * s + 1
</pre>
<p>where T = tDelay / 20 as in the equivalent Eurostag component.</p>
</body></html>"),
  Icon(
    coordinateSystem(initialScale = 0.1),
      graphics={Text(extent = {{8, -142}, {8, -102}}, textString = "tDelay=%tDelay"), Line(points = {{-92, 0}, {-80.7, 34.2}, {-73.5, 53.1}, {-67.1, 66.4}, {-61.4, 74.6}, {-55.8, 79.1}, {-50.2, 79.8}, {-44.6, 76.6}, {-38.9, 69.7}, {-33.3, 59.4}, {-26.9, 44.1}, {-18.83, 21.2}, {-1.9, -30.8}, {5.3, -50.2}, {11.7, -64.2}, {17.3, -73.1}, {23, -78.4}, {28.6, -80}, {34.2, -77.6}, {39.9, -71.5}, {45.5, -61.9}, {51.9, -47.2}, {60, -24.8}, {68, 0}}, color = {0, 0, 127}, smooth = Smooth.Bezier), Line(points = {{-62, 0}, {-50.7, 34.2}, {-43.5, 53.1}, {-37.1, 66.4}, {-31.4, 74.6}, {-25.8, 79.1}, {-20.2, 79.8}, {-14.6, 76.6}, {-8.9, 69.7}, {-3.3, 59.4}, {3.1, 44.1}, {11.17, 21.2}, {28.1, -30.8}, {35.3, -50.2}, {41.7, -64.2}, {47.3, -73.1}, {53, -78.4}, {58.6, -80}, {64.2, -77.6}, {69.9, -71.5}, {75.5, -61.9}, {81.9, -47.2}, {90, -24.8}, {98, 0}}, color = {160, 160, 164}, smooth = Smooth.Bezier)}),
  Diagram(coordinateSystem(initialScale = 0.1)));
end FirstOrderWithDelay;
