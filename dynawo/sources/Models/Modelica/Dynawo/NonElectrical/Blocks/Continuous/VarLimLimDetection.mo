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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block VarLimLimDetection "Variable limit with limitation detection flags"
  
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {-54, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {-50, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy, limitsAtInit = true)  annotation(
    Placement(visible = true, transformation(origin = {-34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  // inputs
  Modelica.Blocks.Interfaces.RealInput u "Unlimited signal" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput yMax "Upper limit" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput yMin "Lower limit" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  
  // outputs
  Modelica.Blocks.Interfaces.BooleanOutput fMax "Signal turns true if upper limit is active" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput fMin "Signal turns true if lower limit is active" annotation(
    Placement(visible = true, transformation(origin = {110, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y "Limited signal" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(yMax, less.u1) annotation(
    Line(points = {{-120, 60}, {-66, 60}}, color = {0, 0, 127}));
  connect(u, less.u2) annotation(
    Line(points = {{-120, 0}, {-80, 0}, {-80, 52}, {-66, 52}}, color = {0, 0, 127}));
  connect(yMin, less1.u2) annotation(
    Line(points = {{-120, -60}, {-62, -60}}, color = {0, 0, 127}));
  connect(u, less1.u1) annotation(
    Line(points = {{-120, 0}, {-80, 0}, {-80, -52}, {-62, -52}}, color = {0, 0, 127}));
  connect(u, variableLimiter.u) annotation(
    Line(points = {{-120, 0}, {-46, 0}}, color = {0, 0, 127}));
  connect(yMax, variableLimiter.limit1) annotation(
    Line(points = {{-120, 60}, {-90, 60}, {-90, 8}, {-46, 8}}, color = {0, 0, 127}));
  connect(yMin, variableLimiter.limit2) annotation(
    Line(points = {{-120, -60}, {-90, -60}, {-90, -8}, {-46, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, y) annotation(
    Line(points = {{-22, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(less.y, fMax) annotation(
    Line(points = {{-42, 60}, {110, 60}}, color = {255, 0, 255}));
  connect(less1.y, fMin) annotation(
    Line(points = {{-38, -52}, {110, -52}}, color = {255, 0, 255}));
  
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Polygon(lineColor = {0, 0, 127}, points = {{-64, -70}, {-66, -74}, {-62, -74}, {-64, -70}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Line(points = {{-90, 0}, {68, 0}}, color = {192, 192, 192}), Line(points = {{0, -90}, {0, 68}}, color = {192, 192, 192}), Line(visible = false, points = {{-80, -70}, {-50, -70}}, color = {255, 0, 0}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 90}, {-8, 68}, {8, 68}, {0, 90}}), Line(points = {{-100, 80}, {66, 80}, {66, 70}}, color = {0, 0, 127}), Polygon(lineColor = {0, 0, 127}, points = {{66, 70}, {64, 74}, {68, 74}, {66, 70}}), Line(visible = false, points = {{50, 70}, {80, 70}}, color = {255, 0, 0}), Line(points = {{-80, -70}, {-50, -70}, {50, 70}, {80, 70}}), Line(points = {{-100, -80}, {-64, -80}, {-64, -70}}, color = {0, 0, 127}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, 0}, {68, -8}, {68, 8}, {90, 0}}), Polygon(lineColor = {0, 0, 127}, points = {{-64, -70}, {-66, -74}, {-62, -74}, {-64, -70}})}));
end VarLimLimDetection;
