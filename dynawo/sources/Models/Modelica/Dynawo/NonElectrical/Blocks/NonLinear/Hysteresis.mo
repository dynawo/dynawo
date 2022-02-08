within Dynawo.NonElectrical.Blocks.NonLinear;

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

block Hysteresis "Transforms Real to Boolean signal with hysteresis"
  import Modelica;
  import Modelica.Blocks.Interfaces;

  extends Modelica.Blocks.Icons.PartialBooleanBlock;

  parameter Real UHigh "Upper threshold of hysteresis";
  parameter Real ULow "Lower threshold of hysteresis";

  Interfaces.RealInput u annotation(
      Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y(start = Y0) annotation(
      Placement(transformation(extent={{100,-10},{120,10}})));

  parameter Boolean Y0 = false "Initial value of hysteresis output if u within the thresholds";

equation
  y = not pre(y) and u > UHigh or pre(y) and u >= ULow;

  annotation(
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Polygon(
            points={{-65,89},{-73,67},{-57,67},{-65,89}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Line(points={{-65,67},{-65,-81}},
          color={192,192,192}),Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
          Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),Text(
            extent={{70,-80},{94,-100}},
            lineColor={160,160,164},
            textString="u"),Text(
            extent={{-65,93},{-12,75}},
            lineColor={160,160,164},
            textString="y"),Line(
            points={{-80,-70},{30,-70}},
            thickness=0.5),Line(
            points={{-50,10},{80,10}},
            thickness=0.5),Line(
            points={{-50,10},{-50,-70}},
            thickness=0.5),Line(
            points={{30,10},{30,-70}},
            thickness=0.5),Line(
            points={{-10,-65},{0,-70},{-10,-75}},
            thickness=0.5),Line(
            points={{-10,15},{-20,10},{-10,5}},
            thickness=0.5),Line(
            points={{-55,-20},{-50,-30},{-44,-20}},
            thickness=0.5),Line(
            points={{25,-30},{30,-19},{35,-30}},
            thickness=0.5),Text(
            extent={{-99,2},{-70,18}},
            lineColor={160,160,164},
            textString="true"),Text(
            extent={{-98,-87},{-66,-73}},
            lineColor={160,160,164},
            textString="false"),Text(
            extent={{19,-87},{44,-70}},
            textString="UHigh"),Text(
            extent={{-63,-88},{-38,-71}},
            textString="ULow"),Line(points={{-69,10},{-60,10}}, color={160,
          160,164})}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-29}}, color={192,192,192}),
        Polygon(
          points={{92,-29},{70,-21},{70,-37},{92,-29}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-79,-29},{84,-29}}, color={192,192,192}),
        Line(points={{-79,-29},{41,-29}}),
        Line(points={{-15,-21},{1,-29},{-15,-36}}),
        Line(points={{41,51},{41,-29}}),
        Line(points={{33,3},{41,22},{50,3}}),
        Line(points={{-49,51},{81,51}}),
        Line(points={{-4,59},{-19,51},{-4,43}}),
        Line(points={{-59,29},{-49,11},{-39,29}}),
        Line(points={{-49,51},{-49,-29}}),
        Text(
          extent={{-92,-49},{-9,-92}},
          lineColor={192,192,192},
          textString="%ULow"),
        Text(
          extent={{2,-49},{91,-92}},
          lineColor={192,192,192},
          textString="%UHigh"),
        Rectangle(extent={{-91,-49},{-8,-92}}, lineColor={192,192,192}),
        Line(points={{-49,-29},{-49,-49}}, color={192,192,192}),
        Rectangle(extent={{2,-49},{91,-92}}, lineColor={192,192,192}),
        Line(points={{41,-29},{41,-49}}, color={192,192,192})}),
    Documentation(info= "<html>
<p>
This block transforms a <strong>Real</strong> input signal into a <strong>Boolean</strong>
output signal:
</p>
<ul>
<li> When the output is <strong>false</strong> and the input becomes
   <strong>greater</strong> than parameter <strong>UHigh</strong>, the output
   switches to <strong>true</strong>.</li>
<li> When the output is <strong>true</strong> and the input becomes
   <strong>less</strong> than parameter <strong>ULow</strong>, the output
   switches to <strong>false</strong>.</li>
</ul>
<p>At initialization, if the input is within [<b>ULow</b>, <b>UHigh</b>], the start value of the output is defined via parameter
<strong>Y0</strong> (= value of pre(y) at initial time).
The default value of this parameter is <strong>false</strong>.</p>
</body></html>"));
end Hysteresis;
