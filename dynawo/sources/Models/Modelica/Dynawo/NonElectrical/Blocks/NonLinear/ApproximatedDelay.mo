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

block ApproximatedDelay "Delay block with fixed delay time, using a first-order approximation"

  import Modelica;

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Modelica.SIunits.Time tDelay "Delay time of output with respect to input signal, in s";

equation
  y = u - tDelay * der(u);

  annotation(
  preferredView = "text",
  Documentation(info= "<html><head></head><body><p>
The input signal is delayed by a given duration. Ideally :</p>
<pre> y = u(time - tDelay)
</pre>The Laplace transform of a delay is :
<pre> Y = exp(-tDelay * s) * U
</pre>With a first-order Taylor expansion at s=0, this expression becomes :
<pre> Y = (1 - tDelay * s) * U
</pre> In the time domain, this is :
<pre> y = u - tDelay * der(u)
</pre></body></html>"), Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Text(
      extent={{8.0,-142.0},{8.0,-102.0}},
      textString="tDelay=%tDelay"),
    Line(
      points={{-92.0,0.0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},{-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{23.0,-78.4},{28.6,-80.0},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,-47.2},{60.0,-24.8},{68.0,0.0}},
      color={0,0,127},
      smooth=Smooth.Bezier),
    Line(
      points={{-62.0,0.0},{-50.7,34.2},{-43.5,53.1},{-37.1,66.4},{-31.4,74.6},{-25.8,79.1},{-20.2,79.8},{-14.6,76.6},{-8.9,69.7},{-3.3,59.4},{3.1,44.1},{11.17,21.2},{28.1,-30.8},{35.3,-50.2},{41.7,-64.2},{47.3,-73.1},{53.0,-78.4},{58.6,-80.0},{64.2,-77.6},{69.9,-71.5},{75.5,-61.9},{81.9,-47.2},{90.0,-24.8},{98.0,0.0}},
      color={160,160,164},
      smooth=Smooth.Bezier)}),
  Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,80},{-88,80}}, color={192,192,192}),
        Line(points={{-80,-80},{-88,-80}}, color={192,192,192}),
        Line(points={{-80,-88},{-80,86}}, color={192,192,192}),
        Text(
          extent={{-75,98},{-46,78}},
          lineColor={0,0,255},
          textString="output"),
        Polygon(
          points={{-80,96},{-86,80},{-74,80},{-80,96}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{84,0}}, color={192,192,192}),
        Polygon(
          points={{100,0},{84,6},{84,-6},{100,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,
              74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,
              59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,
              -64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},
              {57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,127},
              smooth=Smooth.Bezier),
        Text(
          extent={{-24,98},{-2,78}},
          textString="input"),
        Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,
              74.6},{-27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,
              59.4},{1.1,44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},
              {45.3,-73.1},{51,-78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{
              73.5,-61.9},{79.9,-47.2},{88,-24.8},{96,0}}, smooth=Smooth.Bezier),
        Text(
          extent={{67,22},{96,6}},
          lineColor={160,160,164},
          textString="time"),
        Line(points={{-64,-30},{-64,0}}, color={192,192,192}),
        Text(
          extent={{-58,-42},{-58,-32}},
          textString="tDelay",
          lineColor={0,0,255}),
        Line(points={{-94,-26},{-80,-26}}, color={192,192,192}),
        Line(points={{-64,-26},{-50,-26}}, color={192,192,192}),
        Polygon(
          points={{-80,-26},{-88,-24},{-88,-28},{-80,-26}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-56,-24},{-64,-26},{-56,-28},{-56,-24}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}));
end ApproximatedDelay;
