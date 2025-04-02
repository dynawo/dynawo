within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block PowerExp "Output the power to a base of the input with no Evaluate annotation"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real base = Modelica.Constants.e "Base of power";
  parameter Boolean useExp = true "Use exp function in implementation";
equation
  y = if useExp then Modelica.Math.exp(u*Modelica.Math.log(base)) else base ^ u;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{0,-80},{0,68}}, color={192,192,192}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-86,50},{-14,2}},
          lineColor={192,192,192},
          textString="^"),
        Line(points={{-80,-80},{-31,-77.9},{-6.03,-74},{10.9,-68.4},{23.7,-61},
              {34.2,-51.6},{43,-40.3},{50.3,-27.8},{56.7,-13.5},{62.3,2.23},{
              67.1,18.6},{72,38.2},{76,57.6},{80,80}}),
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192},
          smooth=Smooth.Bezier),
        Polygon(
          points={{90,-80.3976},{68,-72.3976},{68,-88.3976},{90,-80.3976}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{0,80},{-8,80}}, color={192,192,192}),
          Line(points={{0,-80},{-8,-80}}, color={192,192,192}),Line(
          points={{0,-90},{0,84}}, color={192,192,192}),Text(
            extent={{9,100},{40,80}},
            lineColor={160,160,164},
            textString="y"),Polygon(
            points={{0,100},{-6,84},{6,84},{0,100}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-100,-80.3976},{84,-80.3976}},
          color={192,192,192}),Polygon(
            points={{100,-80.3976},{84,-74.3976},{84,-86.3976},{100,-80.3976}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,-80},{-31,-77.9},
          {-6.03,-74},{10.9,-68.4},{23.7,-61},{34.2,-51.6},{43,-40.3},{50.3,-27.8},
          {56.7,-13.5},{62.3,2.23},{67.1,18.6},{72,38.2},{76,57.6},{80,80}}),
                                 Text(
            extent={{66,-52},{96,-72}},
            lineColor={160,160,164},
            textString="u")}),
    Documentation(info="<html>
<p>
This blocks computes the output <strong>y</strong> as the
power to the parameter <em>base</em> of the input <strong>u</strong>.
If the boolean parameter <strong>useExp</strong> is true, the output is determined by:
</p>
<pre>
  y = <strong>exp</strong> ( u * <strong>log</strong> (base) )
</pre>
<p>
otherwise:
</p>
<pre>
  y = base <strong>^</strong> u;
</pre>


</html>"));
end PowerExp;
