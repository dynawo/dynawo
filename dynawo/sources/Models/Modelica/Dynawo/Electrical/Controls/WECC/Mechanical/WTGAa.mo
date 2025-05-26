within Dynawo.Electrical.Controls.WECC.Mechanical;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model WTGAa "WECC Aero-Dynamic model"
  extends Electrical.Controls.WECC.Parameters.ParamsWTGAa;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput Theta(start = theta0) "Pitch angle in degrees" annotation(
    Placement(transformation(origin = {-130, -4}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base SNom)" annotation(
    Placement(transformation(origin = {52, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {49, -109}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base SNom)" annotation(
    Placement(transformation(origin = {130, -11}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-50, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant Theta0(k = theta0) annotation(
    Placement(transformation(origin = {-50, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-14, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = Ka) annotation(
    Placement(transformation(origin = {22, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(transformation(origin = {52, 2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation
  connect(Theta0.y, feedback.u2) annotation(
    Line(points = {{-50, -47}, {-50, -12}}, color = {0, 0, 127}));
  connect(Theta, feedback.u1) annotation(
    Line(points = {{-130, -4}, {-58, -4}}, color = {0, 0, 127}));
  connect(feedback.y, product.u2) annotation(
    Line(points = {{-40, -4}, {-26, -4}}, color = {0, 0, 127}));
  connect(Theta, product.u1) annotation(
    Line(points = {{-130, -4}, {-70, -4}, {-70, 8}, {-26, 8}}, color = {0, 0, 127}));
  connect(product.y, gain.u) annotation(
    Line(points = {{-2, 2}, {10, 2}}, color = {0, 0, 127}));
  connect(feedback1.y, PmPu) annotation(
    Line(points = {{52, -7}, {52.625, -7}, {52.625, -11}, {131, -11}}, color = {0, 0, 127}));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{33, 2}, {44, 2}}, color = {0, 0, 127}));
  connect(PmRefPu, feedback1.u1) annotation(
    Line(points = {{52, 90}, {52, 10}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> This block contains the Aero-Dynamic Model for a WindTurbineGenerator Type 3 according to <br><a href=\"3002027129_Model%20User%20Guide%20for%20Generic%20Renewable%20Energy%20Systems.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p><p>This simple model will give you a value for the mechaniquel power developed by the wind turbine depending on the blade pitch angle.</p>
<p>
 </p><p></p></body></html>"),
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-120, 80}, {120, -80}})),
    Icon(graphics = {Text(origin = {77, -109}, extent = {{-17, 9}, {17, -9}}, textString = "PmRef"), Text(origin = {-111, 23}, extent = {{-15, 7}, {15, -7}}, textString = "theta"), Text(origin = {108, 21}, extent = {{-14, 9}, {14, -9}}, textString = "Pm"), Text(origin = {2, 3}, extent = {{-64, 41}, {64, -41}}, textString = "WTGA A"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTGAa;
