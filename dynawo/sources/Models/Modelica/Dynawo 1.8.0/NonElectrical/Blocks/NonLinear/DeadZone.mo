within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

block DeadZone "Dead zone, bypassed if the limits are equal"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real uMax(start = 1) "Upper limit of dead zone";
  parameter Real uMin = -uMax "Lower limit of dead zone";

equation
  assert(uMax >= uMin, "DeadZone: limits must be consistent. However, uMax (=" + String(uMax) + ") < uMin (=" + String(uMin) + ")");

  if uMax == uMin then
    y = u;
  else
    y = homotopy(actual = smooth(0, if u > uMax then u - uMax else if u < uMin then u - uMin else 0), simplified = u);
  end if;

  annotation(
    preferredView = "text",
    Documentation(info= "<html><head></head><body><p>
The DeadZone block defines a region of zero output.
</p>
<p>
If the input is within uMin ... uMax, the output
is zero. Outside of this zone, the output is a linear
function of the input with a slope of 1.
</p><p>If uMax = uMin, the block is bypassed i.e. the output is equal to the input.</p>
</body></html>"), Icon(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-80,-60},{-20,0},{20,0},{80,60}}),
    Text(
      extent={{-150,-150},{150,-110}},
      lineColor={160,160,164},
      textString="uMax=%uMax")}),
    Diagram(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(points={{0,-60},{0,50}}, color={192,192,192}),
    Polygon(
      points={{0,60},{-5,50},{5,50},{0,60}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-76,0},{74,0}}, color={192,192,192}),
    Polygon(
      points={{84,0},{74,-5},{74,5},{84,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-81,-40},{-38,0},{40,0},{80,40}}),
    Text(
      extent={{62,-7},{88,-25}},
      lineColor={128,128,128},
      textString="u"),
    Text(
      extent={{-36,72},{-5,50}},
      lineColor={128,128,128},
      textString="y"),
    Text(
      extent={{-51,1},{-28,19}},
      lineColor={128,128,128},
      textString="uMin"),
    Text(
      extent={{27,21},{52,5}},
      lineColor={128,128,128},
      textString="uMax")}));
end DeadZone;
