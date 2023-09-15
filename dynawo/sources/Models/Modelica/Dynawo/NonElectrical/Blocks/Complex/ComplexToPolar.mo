within Dynawo.NonElectrical.Blocks.Complex;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block ComplexToPolar "Converts complex to polar representation. An eps is added to cope with the cases where the input is equal to 0."
  extends Modelica.Blocks.Icons.Block;

  Modelica.ComplexBlocks.Interfaces.ComplexInput u annotation(
    Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput len annotation(
    Placement(transformation(extent={{100,40},{140,80}}), iconTransformation(extent={{100,40}, {140,80}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit="rad") annotation(
    Placement(transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent={{100,-80}, {140,-40}})));

equation
  len = sqrt(u.re^2 + u.im^2 + Modelica.Constants.eps);
  phi = Modelica.Math.atan2(u.im, u.re + Modelica.Constants.eps);

  annotation(
    preferredView = "text",
    Icon(graphics={Text(
              extent={{20,80},{100,40}},
              lineColor={0,0,127},
              textString="len"),Text(
              extent={{20,-40},{100,-80}},
              lineColor={0,0,127},
              textString="phi"),Polygon(
              points={{40,0},{20,20},{20,10},{-10,10},{-10,-10},{20,-10},{
            20,-20},{40,0}},
              lineColor={0,128,255},
              fillColor={85,170,255},
              fillPattern=FillPattern.Solid),Text(
              extent={{-100,60},{-20,-60}},
              lineColor={85,170,255},
          textString="C")}),     Documentation(info="<html>
<p>Converts the Complex input <em>u</em> to the Real outputs <em>len</em> (length, absolute) and <em>phi</em> (angle, argument).</p>
</html>"));
end ComplexToPolar;
