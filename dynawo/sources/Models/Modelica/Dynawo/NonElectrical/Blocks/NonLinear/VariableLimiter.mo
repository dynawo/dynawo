within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model VariableLimiter "Limit the range of a signal with variable limits"
  import Modelica;
  extends Modelica.Blocks.Interfaces.SISO;

  Modelica.Blocks.Interfaces.RealInput limit1
 "Connector of Real input signal used as maximum of input u"
    annotation(Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput limit2
 "Connector of Real input signal used as minimum of input u"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}})));

equation

  y = if u > limit1 then limit1 else if u < limit2 then limit2 else u;

  annotation(
    Documentation(info="<html>
<p>
The Limiter block passes its input signal as output signal
as long as the input is within the upper and lower
limits specified by the two additional inputs limit1 and
limit2. If this is not the case, the corresponding limit
is passed as output.
</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{0,-90},{0,68}}, color={192,192,192}),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,-8},{68,8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-50,-70},{50,70},{80,70}}),
        Line(points={{-100,80},{66,80},{66,70}}, color={0,0,127}),
        Line(points={{-100,-80},{-64,-80},{-64,-70}}, color={0,0,127}),
        Polygon(points={{-64,-70},{-66,-74},{-62,-74},{-64,-70}}, lineColor={
              0,0,127}),
        Polygon(points={{66,70},{64,74},{68,74},{66,70}}, lineColor={0,0,127}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{50,70},{80,70}},
          color={255,0,0}),
        Line(
          points={{-80,-70},{-50,-70}},
          color={255,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(points={{0,-60},{0,50}}, color={192,192,192}),
        Polygon(
          points={{0,60},{-5,50},{5,50},{0,60}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,0},{50,0}}, color={192,192,192}),
        Polygon(
          points={{60,0},{50,-5},{50,5},{60,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-50,-40},{-30,-40},{30,40},{50,40}}),
        Text(
          extent={{46,-6},{68,-18}},
          lineColor={128,128,128},
          textString="input"),
        Text(
          extent={{-30,70},{-5,50}},
          lineColor={128,128,128},
          textString="output"),
        Text(
          extent={{-66,-40},{-26,-20}},
          lineColor={128,128,128},
          textString="uMin"),
        Text(
          extent={{30,20},{70,40}},
          lineColor={128,128,128},
          textString="uMax"),
        Line(points={{-100,80},{40,80},{40,40}}, color={0,0,127}),
        Line(points={{-100,-80},{-40,-80},{-40,-40}}, color={0,0,127}),
        Polygon(points={{40,40},{35,50},{45,50},{40,40}}, lineColor={0,0,127}),
        Polygon(points={{-40,-40},{-45,-50},{-35,-50},{-40,-40}}, lineColor={
              0,0,127})}));
end VariableLimiter;
