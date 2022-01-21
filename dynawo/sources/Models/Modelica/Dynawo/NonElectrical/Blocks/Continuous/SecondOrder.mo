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

block SecondOrder
  import Modelica;
  import Dynawo.Types;

  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit D "Damping";
  parameter Types.PerUnit K = 1 "Gain";
  parameter Types.Frequency w "Angular frequency in Hz";

  Modelica.Blocks.Interfaces.RealInput u "Connector of Real input signal" annotation (Placement(
        visible = true, transformation(extent = {{-240, -20}, {-200, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(
        visible = true, transformation(extent = {{200, -10}, {220, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain(k = K) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = w) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = w) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = DerY0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = 2 * D) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  parameter Real DerY0 = 0 "Initial derivative of filter output"
    annotation (Dialog(group="Initialization"));
  parameter Real Y0 = 0 "Initial filter output"
    annotation (Dialog(group="Initialization"));

equation
  connect(gain.y, feedback.u1) annotation(
    Line(points = {{-139, 0}, {-108, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{-90, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(gain1.y, feedback1.u1) annotation(
    Line(points = {{-38, 0}, {-8, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, gain2.u) annotation(
    Line(points = {{10, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(gain2.y, integrator.u) annotation(
    Line(points = {{62, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(integrator.y, integrator1.u) annotation(
    Line(points = {{102, 0}, {138, 0}}, color = {0, 0, 127}));
  connect(integrator.y, gain3.u) annotation(
    Line(points = {{102, 0}, {120, 0}, {120, -40}, {62, -40}}, color = {0, 0, 127}));
  connect(gain3.y, feedback1.u2) annotation(
    Line(points = {{39, -40}, {0, -40}, {0, -8}}, color = {0, 0, 127}));
  connect(integrator1.y, feedback.u2) annotation(
    Line(points = {{162, 0}, {180, 0}, {180, -80}, {-100, -80}, {-100, -8}}, color = {0, 0, 127}));
  connect(integrator1.y, y) annotation(
    Line(points = {{162, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(u, gain.u) annotation(
    Line(points = {{-220, 0}, {-162, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Documentation(info="<html>
<p>
This blocks defines the transfer function between the input u and
the output y as <em>second order</em> system:
</p>
<pre>
                           K
   y = ---------------------------------------- * u
          ( s / w )^2 + 2*D*( s / w ) + 1
</pre>
</html>"), Icon(
      coordinateSystem(preserveAspectRatio=true,
            extent={{-100.0,-100.0},{100.0,100.0}}),
          graphics={
      Line(points={{-80.0,78.0},{-80.0,-90.0}},
          color={192,192,192}),
    Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
    Line(points={{-90.0,-80.0},{82.0,-80.0}},
        color={192,192,192}),
    Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
    Line(origin = {-1.939,-1.816},
        points = {{81.939,36.056},{65.362,36.056},{14.39,-26.199},{-29.966,113.485},{-65.374,-61.217},{-78.061,-78.184}},
        color = {0,0,127},
        smooth = Smooth.Bezier),
    Text(lineColor={192,192,192},
        extent={{0.0,-70.0},{60.0,-10.0}},
        textString="PT2"),
    Text(extent={{-150.0,-150.0},{150.0,-110.0}},
        textString="W=%W")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-200,-100},{200,100}})));
end SecondOrder;
