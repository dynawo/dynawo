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

  extends Modelica.Blocks.Icons.Block;

  parameter Real k = 1 "Gain";
  parameter Real w "Angular frequency";
  parameter Real D "Damping";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(
    Placement(visible = true, transformation(origin = {-180, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain(k = k)  annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = w)  annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Yd0)  annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(y_start = Y0)  annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = w)  annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = 2 * D)  annotation(
    Placement(visible = true, transformation(origin = {40, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  parameter Real Yd0 = 0 "Initial value of derivative of output signal";
  parameter Real Y0 = 0 "Initial value of output signal";

equation
  connect(u, gain.u) annotation(
    Line(points = {{-180, 0}, {-132, 0}}, color = {0, 0, 127}));
  connect(gain.y, feedback.u1) annotation(
    Line(points = {{-109, 0}, {-88, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{-71, 0}, {-52, 0}}, color = {0, 0, 127}));
  connect(gain1.y, feedback1.u1) annotation(
    Line(points = {{-29, 0}, {-8, 0}}, color = {0, 0, 127}));
  connect(integrator1.y, y) annotation(
    Line(points = {{131, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, gain2.u) annotation(
    Line(points = {{9, 0}, {28, 0}}, color = {0, 0, 127}));
  connect(gain2.y, integrator.u) annotation(
    Line(points = {{51, 0}, {68, 0}}, color = {0, 0, 127}));
  connect(feedback.u2, integrator1.y) annotation(
    Line(points = {{-80, -8}, {-80, -60}, {140, -60}, {140, 0}, {131, 0}}, color = {0, 0, 127}));
  connect(integrator.y, gain3.u) annotation(
    Line(points = {{91, 0}, {100, 0}, {100, -40}, {52, -40}}, color = {0, 0, 127}));
  connect(integrator.y, integrator1.u) annotation(
    Line(points = {{91, 0}, {108, 0}}, color = {0, 0, 127}));
  connect(gain3.y, feedback1.u2) annotation(
    Line(points = {{29, -40}, {0, -40}, {0, -8}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
            extent={{-100, -100},{100, 100}}),
          graphics={Line(points = {{-80, 78}, {-80, -90}}, color = {192, 192, 192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}),
    Line(points = {{-90, -80}, {82, -80}}, color = {192, 192, 192}),
    Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}),
    Line(origin = {-1.939,-1.816},
        points = {{81.939,36.056},{65.362,36.056},{14.39,-26.199},{-29.966,113.485},{-65.374,-61.217},{-78.061,-78.184}},
        color = {0,0,127},
        smooth = Smooth.Bezier),
    Text(lineColor = {192, 192, 192}, extent = {{0, -70}, {60, -10}}, textString = "PT2"),
    Text(extent = {{-150, -150}, {150, -110}}, textString = "w=%w")}),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})));
end SecondOrder;
