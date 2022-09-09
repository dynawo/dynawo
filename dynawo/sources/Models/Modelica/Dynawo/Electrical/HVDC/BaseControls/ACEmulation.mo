within Dynawo.Electrical.HVDC.BaseControls;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ACEmulation "AC Emulation for HVDC"
  import Modelica;
  import Dynawo.Types;

  parameter Types.Time tFilter "Time constant of the angle measurement filter";
  parameter Types.PerUnit KACEmulation "Inverse of the emulated AC reactance (base SnRef or SNom) (receptor or generator convention). If in generator convention, KACEmulation should be < 0.";

  Modelica.Blocks.Interfaces.RealInput Theta1(start = Theta10) "Angle of the voltage at terminal 1 in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Theta2(start = Theta20) "Angle of the voltage at terminal 2 in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefSetPu(k = PRefSet0Pu) "Raw reference active power in pu (base SnRef or SNom) (receptor or generator convention)"  annotation(
    Placement(visible = true, transformation(origin = {-110, -71}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput PRefPu(start = PRef0Pu) "Reference active power in pu (base SnRef or SNom) (receptor or generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilter, y_start = Theta10)  annotation(
    Placement(visible = true, transformation(origin = {-36, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tFilter, y_start = Theta20)  annotation(
    Placement(visible = true, transformation(origin = {-36, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {14, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KACEmulation)  annotation(
    Placement(visible = true, transformation(origin = {43, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.Angle Theta10 "Start value of angle of the voltage at terminal 1 in rad";
  parameter Types.Angle Theta20 "Start value of angle of the voltage at terminal 2 in rad";
  parameter Types.ActivePowerPu PRef0Pu "Start value of reference active power in pu (base SnRef or SNom) (receptor or generator convention)";
  parameter Types.ActivePowerPu PRefSet0Pu "Raw reference active power in pu (base SnRef or SNom) (receptor or generator convention)";

equation
  connect(firstOrder.y, feedback.u1) annotation(
    Line(points = {{-25, 50}, {0, 50}, {0, 6}, {6, 6}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u2) annotation(
    Line(points = {{-25, -20}, {14, -20}, {14, -2}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{23, 6}, {31, 6}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{54, 6}, {66, 6}, {66, 6}, {68, 6}}, color = {0, 0, 127}));
  connect(add.y, PRefPu) annotation(
    Line(points = {{91, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(PRefSetPu.y, add.u2) annotation(
    Line(points = {{-99, -71}, {60, -71}, {60, -6}, {68, -6}, {68, -6}}, color = {0, 0, 127}));
  connect(Theta1, firstOrder.u) annotation(
    Line(points = {{-110, 50}, {-50, 50}, {-50, 50}, {-48, 50}}, color = {0, 0, 127}));
  connect(Theta2, firstOrder1.u) annotation(
    Line(points = {{-110, -20}, {-49, -20}, {-49, -20}, {-48, -20}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end ACEmulation;
