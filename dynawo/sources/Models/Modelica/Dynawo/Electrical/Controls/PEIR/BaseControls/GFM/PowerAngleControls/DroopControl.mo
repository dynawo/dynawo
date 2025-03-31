within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DroopControl "Droop control"

  parameter Types.PerUnit Mp "Active power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active filter (in rad/s)";

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Grid frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {54, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaSetPu(start = Omega0Pu) "Fix angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter and grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom, y_start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {82, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 1 / Wf, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Mp) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {54, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {16, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameter
  parameter Types.PerUnit PFilter0Pu "Start value of active power after the filter in pu (base SNom)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of the converter's frequency in pu (base omegaNom)";
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter and grid rotating frames in rad";

equation
  connect(integrator.y, theta) annotation(
    Line(points = {{93, 80}, {110, 80}}, color = {0, 0, 127}));
  connect(integrator.u, feedback2.y) annotation(
    Line(points = {{70, 80}, {63, 80}}, color = {0, 0, 127}));
  connect(feedback1.u1, PFilterRefPu) annotation(
    Line(points = {{-88, 0}, {-110, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-71, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{54, 110}, {54, 88}}, color = {0, 0, 127}));
  connect(PFilterPu, feedback1.u2) annotation(
    Line(points = {{-110, -30}, {-80, -30}, {-80, -8}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder.u) annotation(
    Line(points = {{-39, 0}, {-32, 0}}, color = {0, 0, 127}));
  connect(add1.y, omegaPu) annotation(
    Line(points = {{27, -6}, {110, -6}}, color = {0, 0, 127}));
  connect(add1.y, feedback2.u1) annotation(
    Line(points = {{27, -6}, {38.5, -6}, {38.5, 80}, {46, 80}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u1) annotation(
    Line(points = {{-9, 0}, {4, 0}}, color = {0, 0, 127}));
  connect(omegaSetPu, add1.u2) annotation(
    Line(points = {{0, -110}, {0, -12}, {4, -12}}, color = {0, 0, 127}));

annotation(preferredView = "diagram");
end DroopControl;
