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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ACEmulationVariableK "AC Emulation for HVDC with a variable KACEmulation"

  parameter Types.Time tFilter "Time constant of the angle measurement filter";

  Modelica.Blocks.Interfaces.RealInput KACEmulation(start = KACEmulation0) "Inverse of the emulated AC reactance (base SnRef or SNom) (receptor or generator convention). If in generator convention, KACEmulation should be < 0." annotation(
    Placement(visible = true, transformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefSetPu(start = PRefSet0Pu) "Raw reference active power in pu (base SnRef or SNom) (receptor or generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Theta1(start = Theta10) "Angle of the voltage at terminal 1 in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Theta2(start = Theta20) "Angle of the voltage at terminal 2 in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput PRefPu(start = PRef0Pu) "Reference active power in pu (base SnRef or SNom) (receptor or generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilter, y_start = DeltaThetaFiltered0) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {30, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Pref0Pu(k = PRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant Enabled(k = Enabled0) annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.Angle DeltaThetaFiltered0 "Start value of filtered angle difference in rad";
  parameter Boolean Enabled0 = true "Whether the AC emulation is enabled or not";
  parameter Types.PerUnit KACEmulation0 "Start value of inverse of the emulated AC reactance (base SnRef or SNom) (receptor or generator convention). If in generator convention, KACEmulation should be < 0.";
  parameter Types.ActivePowerPu PRef0Pu "Start value of reference active power in pu (base SnRef or SNom) (receptor or generator convention)";
  parameter Types.ActivePowerPu PRefSet0Pu "Raw reference active power in pu (base SnRef or SNom) (receptor or generator convention)";
  parameter Types.Angle Theta10 "Start value of angle of the voltage at terminal 1 in rad";
  parameter Types.Angle Theta20 "Start value of angle of the voltage at terminal 2 in rad";

equation
  connect(add.y, switch1.u1) annotation(
    Line(points = {{41, 8}, {68, 8}}, color = {0, 0, 127}));
  connect(switch1.y, PRefPu) annotation(
    Line(points = {{91, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(KACEmulation, product.u1) annotation(
    Line(points = {{-110, 90}, {-30, 90}, {-30, 46}, {-22, 46}}, color = {0, 0, 127}));
  connect(product.y, add.u1) annotation(
    Line(points = {{1, 40}, {10, 40}, {10, 14}, {18, 14}}, color = {0, 0, 127}));
  connect(PRefSetPu, add.u2) annotation(
    Line(points = {{-110, -30}, {10, -30}, {10, 2}, {18, 2}}, color = {0, 0, 127}));
  connect(Enabled.y, switch1.u2) annotation(
    Line(points = {{-99, -60}, {50, -60}, {50, 0}, {68, 0}}, color = {255, 0, 255}));
  connect(Pref0Pu.y, switch1.u3) annotation(
    Line(points = {{-99, -90}, {60, -90}, {60, -8}, {68, -8}}, color = {0, 0, 127}));
  connect(firstOrder.y, product.u2) annotation(
    Line(points = {{-39, 40}, {-30, 40}, {-30, 34}, {-22, 34}}, color = {0, 0, 127}));
  connect(Theta1, feedback.u1) annotation(
    Line(points = {{-110, 40}, {-88, 40}}, color = {0, 0, 127}));
  connect(feedback.y, firstOrder.u) annotation(
    Line(points = {{-71, 40}, {-62, 40}}, color = {0, 0, 127}));
  connect(Theta2, feedback.u2) annotation(
    Line(points = {{-110, 0}, {-80, 0}, {-80, 32}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body> In this model, KACEmulation is a variable and not a parameter. It can be given by an outer control like a power transfer control between two HVDC links for example. </div></body></html>"),
  Diagram(coordinateSystem(grid = {1, 1})));
end ACEmulationVariableK;
