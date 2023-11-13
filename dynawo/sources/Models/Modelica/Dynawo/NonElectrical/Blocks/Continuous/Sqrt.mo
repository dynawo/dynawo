within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

block Sqrt "Outputs the square root of the input"
  extends Modelica.Blocks.Interfaces.SISO;

equation
  y = noEvent(if u > 0 then sqrt(u) else 0);

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{-90,-80},{68,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-80},{-79.2,-68.7},{-78.4,-64},{-76.8,-57.3},{-73.6,-47.9},
              {-67.9,-36.1},{-59.1,-22.2},{-46.2,-6.49},{-28.5,10.7},{-4.42,
              30},{27.7,51.3},{69.5,74.7},{80,80}},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-88},{-80,68}}, color={192,192,192}),
        Text(
          extent={{-8,-4},{64,-52}},
          lineColor={192,192,192},
          textString="sqrt")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-92,-80},{84,-80}}, color={
          192,192,192}),Polygon(
            points={{100,-80},{84,-74},{84,-86},{100,-80}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,-80},{-79.2,-68.7},
          {-78.4,-64},{-76.8,-57.3},{-73.6,-47.9},{-67.9,-36.1},{-59.1,-22.2},
          {-46.2,-6.49},{-28.5,10.7},{-4.42,30},{27.7,51.3},{69.5,74.7},{80,
          80}}),Polygon(
            points={{-80,98},{-86,82},{-74,82},{-80,98}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-80,-90},{-80,84}},
          color={192,192,192}),Text(
            extent={{-71,98},{-44,78}},
            lineColor={160,160,164},
            textString="y"),Text(
            extent={{60,-52},{84,-72}},
            lineColor={160,160,164},
            textString="u")}),
    Documentation(info="<html>
    <p>
    This blocks computes the output <strong>y</strong> as <em>square root</em> of the input <strong>u</strong>:
    </p>
    <pre>
      y = <strong>sqrt</strong>( u );
    </pre>
    <p>
    If the input is negative, the output shall be zero.
    </p></html>"));
end Sqrt;
