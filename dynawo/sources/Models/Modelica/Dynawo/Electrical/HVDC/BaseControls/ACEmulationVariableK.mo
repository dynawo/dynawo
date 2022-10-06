within Dynawo.Electrical.HVDC.BaseControls;

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

model ACEmulationVariableK "AC Emulation for HVDC with a variable KACEmulation"
  import Modelica;
  import Dynawo.Types;

  parameter Types.Time tFilter "Time constant of the angle measurement filter";

  Modelica.Blocks.Interfaces.RealInput KACEmulation "Inverse of the emulated AC reactance" annotation(
    Placement(visible = true, transformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Theta1(start = Theta10) "Angle of the voltage at terminal 1 in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Theta2(start = Theta20) "Angle of the voltage at terminal 2 in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefSetPu "Raw reference active power in pu (base SnRef)"  annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput PRefPu(start = PRef0Pu) "Reference active power in pu (base SnRef)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilter, y_start = Theta10)  annotation(
    Placement(visible = true, transformation(origin = {-36, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tFilter, y_start = Theta20)  annotation(
    Placement(visible = true, transformation(origin = {-36, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {46, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.Angle Theta10 "Start value of angle of the voltage at terminal 1 in rad";
  parameter Types.Angle Theta20 "Start value of angle of the voltage at terminal 2 in rad";
  parameter Types.ActivePowerPu PRef0Pu "Start value of reference active power in pu (base SnRef)";

equation
  connect(firstOrder.y, feedback.u1) annotation(
    Line(points = {{-25, 50}, {0, 50}, {0, 0}, {6, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u2) annotation(
    Line(points = {{-25, -20}, {14, -20}, {14, -8}}, color = {0, 0, 127}));
  connect(add.y, PRefPu) annotation(
    Line(points = {{91, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(PRefSetPu, add.u2) annotation(
    Line(points = {{-110, -70}, {60, -70}, {60, -6}, {68, -6}}, color = {0, 0, 127}));
  connect(Theta1, firstOrder.u) annotation(
    Line(points = {{-110, 50}, {-50, 50}, {-50, 50}, {-48, 50}}, color = {0, 0, 127}));
  connect(Theta2, firstOrder1.u) annotation(
    Line(points = {{-110, -20}, {-49, -20}, {-49, -20}, {-48, -20}}, color = {0, 0, 127}));
  connect(product.y, add.u1) annotation(
    Line(points = {{57, 6}, {68, 6}}, color = {0, 0, 127}));
  connect(feedback.y, product.u2) annotation(
    Line(points = {{23, 0}, {34, 0}}, color = {0, 0, 127}));
  connect(KACEmulation, product.u1) annotation(
    Line(points = {{-110, 90}, {20, 90}, {20, 12}, {34, 12}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> In this model, KACEmulation is a variable and not a parameter. It can be given by an outer control like a power transfer control between two HVDC links for example. </div></body></html>"));
end ACEmulationVariableK;
