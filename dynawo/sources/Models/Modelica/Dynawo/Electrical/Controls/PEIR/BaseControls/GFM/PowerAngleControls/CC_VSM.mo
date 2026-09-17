within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls;

model CC_VSM "Virtual Synchronous Machine control"
  /*
  * Copyright (c) 2026, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
  */
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";
  // CHANGE: new parameter for the angle damping (SEDF - Swing Equation with Differential Feedback) term,
  // ported from the validated reference model's VirtualSynchroMachineFeedForward.DampingAngleFactor.
  // Unlike kVSM (applied to the power-balance equation, affecting omega and providing a permanent droop/FCR
  // contribution), this gain is applied directly and only to theta, as an instantaneous proportional term
  // added on top of the usual integral. It adds electromechanical damping to the omega<->theta coupling
  // without altering the steady-state droop behavior of the power loop, and without freezing or gating
  // anything: it is always active, exactly like every other term in this block.
  parameter Types.PerUnit KDampingAngle "Gain of the proportional angle-damping term added to theta (SEDF term)";
  // Inputs
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power after the filter in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference after the filter in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "System frequency response in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {30, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaSetPu(start = Omega0Pu) "Fix angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-22, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Outputs
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter and grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = 1, k2 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1/(2*H), y_start = Omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-26, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-22, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gain(k = kVSM) annotation(
    Placement(visible = true, transformation(origin = {-63, -60}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = SystemBase.omegaNom, y_start = Theta0) annotation(
    Placement(transformation(origin = {64, 72}, extent = {{-10, -10}, {10, 10}})));
  // CHANGE: SEDF term. feedback1.y already computes (omegaPu - omegaRefPu), the same error that
  // integrator1 integrates into theta's classic term -- reused here rather than introducing a second,
  // redundant error signal. gainDampingAngle turns that same error into an instantaneous, proportional
  // (never integrated, never frozen) contribution to theta.
  Modelica.Blocks.Math.Gain gainDampingAngle(k = KDampingAngle) annotation(
    Placement(transformation(origin = {64, 30}, extent = {{-8, -8}, {8, 8}})));
  // CHANGE: theta is now the sum of the classic integral term and the SEDF proportional term, instead of
  // being integrator1.y directly.
  Modelica.Blocks.Math.Add addTheta(k1 = 1, k2 = 1) annotation(
    Placement(transformation(origin = {90, 58}, extent = {{-8, -8}, {8, 8}})));
  // Initial parameter
  parameter Types.PerUnit PFilter0Pu "Start value of active power after the filter in pu (base SNom) (generator convention)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of the converter's frequency in pu (base omegaNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter and grid rotating frames in rad (generator convention)";
equation
  connect(PFilterRefPu, add3.u1) annotation(
    Line(points = {{-120, 60}, {-88, 60}, {-88, 8}, {-76, 8}}, color = {0, 0, 127}));
  connect(PFilterPu, add3.u2) annotation(
    Line(points = {{-120, 0}, {-76, 0}}, color = {0, 0, 127}));
  connect(omegaSetPu, feedback.u2) annotation(
    Line(points = {{-22, -120}, {-22, -68}}, color = {0, 0, 127}));
  connect(integrator.y, feedback.u1) annotation(
    Line(points = {{-14, 0}, {0, 0}, {0, -60}, {-14, -60}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-30, -60}, {-52, -60}}, color = {0, 0, 127}));
  connect(gain.y, add3.u3) annotation(
    Line(points = {{-72, -60}, {-88, -60}, {-88, -8}, {-76, -8}}, color = {0, 0, 127}));
  connect(feedback1.u1, integrator.y) annotation(
    Line(points = {{22, 60}, {0, 60}, {0, 0}, {-14, 0}}, color = {0, 0, 127}));
  connect(feedback1.u2, omegaRefPu) annotation(
    Line(points = {{30, 68}, {30, 120}}, color = {0, 0, 127}));
  connect(feedback1.y, integrator1.u) annotation(
    Line(points = {{40, 60}, {45, 60}, {45, 72}, {52, 72}}, color = {0, 0, 127}));
  // CHANGE: feedback1.y also feeds the new SEDF gain block.
  connect(feedback1.y, gainDampingAngle.u) annotation(
    Line(points = {{40, 60}, {40, 40}, {54, 40}, {54, 30}}, color = {0, 0, 127}));
  // CHANGE: theta is now produced by addTheta (integrator1.y + gainDampingAngle.y) instead of being
  // integrator1.y directly.
  connect(integrator1.y, addTheta.u1) annotation(
    Line(points = {{75, 72}, {92, 72}, {92, 63}, {80, 63}}, color = {0, 0, 127}));
  connect(gainDampingAngle.y, addTheta.u2) annotation(
    Line(points = {{73, 30}, {86, 30}, {86, 53}, {80, 53}}, color = {0, 0, 127}));
  connect(addTheta.y, theta) annotation(
    Line(points = {{99, 58}, {103.5, 58}, {103.5, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(integrator.y, omegaPu) annotation(
    Line(points = {{-14, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(add3.y, integrator.u) annotation(
    Line(points = {{-52, 0}, {-38, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram");
end CC_VSM;
