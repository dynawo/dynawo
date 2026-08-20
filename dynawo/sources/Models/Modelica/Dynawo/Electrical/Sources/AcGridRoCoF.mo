within Dynawo.Electrical.Sources;

model AcGridRoCoF "AC Grid emulating a RoCoF disturbance, without governor/turbine/inertia dynamics, and without any precompiled sub-component"
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

  parameter Real SNom;
  parameter Real U0pu;
  parameter Real UPhase0;
  parameter Real Upu(start = U0pu);
  parameter Real UPhase(start = UPhase0);

  parameter Real RoCoFValue "Value Rate of Change of Frequency (pu/s, base omegaNom)";

  // ----- Voltage source terminal (equations written explicitly, no PhaseurGrid sub-component) -----
  Dynawo.Connectors.ACPower aCPower annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 74}, extent = {{-20, -20}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PPu annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QPu annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // ----- Inputs / outputs -----
  Modelica.Blocks.Interfaces.RealInput OmegaRef annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 52}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(extent = {{99, -73}, {129, -43}}, rotation = 0)));

  // ----- First RoCoF event: ramp from t=5s to t=8s, then holds -----
  Modelica.Blocks.Sources.Step RoCof(height = RoCoFValue, offset = 0, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = -RoCoFValue, offset = 0, startTime = 8) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add6 annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator3(k = 1, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}})));

  // ----- Second RoCoF event: ramp back from t=15s to t=18s -----
  Modelica.Blocks.Sources.Step step1(height = -RoCoFValue, offset = 0, startTime = 15) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step2(height = RoCoFValue, offset = 0, startTime = 18) annotation(
    Placement(visible = true, transformation(origin = {-80, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add8 annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator2(k = 1, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));

  // ----- Combination of the two ramps with the frequency reference -----
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {40, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add7 annotation(
    Placement(visible = true, transformation(origin = {70, 45}, extent = {{-10, -10}, {10, 10}})));

  // ----- Phase integration driven by the frequency deviation (RoCoF) -----
  Modelica.Blocks.Math.Add add4(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {40, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k = SystemBase.omegaNom, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {80, -10}, extent = {{-10, -10}, {10, 10}})));

equation
  // ----- Explicit voltage source equations (replaces PhaseurGrid sub-component) -----
  aCPower.V.re = Upu * cos(UPhase + integrator1.y);
  aCPower.V.im = Upu * sin(UPhase + integrator1.y);
  PPu = -(aCPower.V.re * aCPower.i.re + aCPower.V.im * aCPower.i.im) * SystemBase.SnRef / SNom;
  QPu = -(aCPower.V.im * aCPower.i.re - aCPower.V.re * aCPower.i.im) * SystemBase.SnRef / SNom;

  // First ramp: RoCof (start) + step (cancels it at t=8) -> integrator3 gives a ramp 5->8s then a held plateau
  connect(RoCof.y, add6.u1) annotation(
    Line(points = {{-69, 80}, {-52, 80}, {-52, 66}}, color = {0, 0, 127}));
  connect(step.y, add6.u2) annotation(
    Line(points = {{-69, 40}, {-52, 40}, {-52, 54}}, color = {0, 0, 127}));
  connect(add6.y, integrator3.u) annotation(
    Line(points = {{-29, 60}, {-12, 60}}, color = {0, 0, 127}));

  // Second ramp: step1 (start) + step2 (cancels it at t=18) -> integrator2 gives a ramp 15->18s then a held plateau
  connect(step1.y, add8.u1) annotation(
    Line(points = {{-69, -40}, {-52, -40}, {-52, -54}}, color = {0, 0, 127}));
  connect(step2.y, add8.u2) annotation(
    Line(points = {{-69, -80}, {-52, -80}, {-52, -66}}, color = {0, 0, 127}));
  connect(add8.y, integrator2.u) annotation(
    Line(points = {{-29, -60}, {-12, -60}}, color = {0, 0, 127}));

  // omegaPu = OmegaRef + ramp1 + ramp2 (no governor/inertia contribution anymore)
  connect(integrator3.y, add5.u1) annotation(
    Line(points = {{11, 60}, {20, 60}, {20, 36}, {28, 36}}, color = {0, 0, 127}));
  connect(OmegaRef, add5.u2) annotation(
    Line(points = {{-110, 0}, {20, 0}, {20, 24}, {28, 24}}, color = {0, 0, 127}));
  connect(add5.y, add7.u2) annotation(
    Line(points = {{51, 30}, {58, 30}, {58, 39}}, color = {0, 0, 127}));
  connect(integrator2.y, add7.u1) annotation(
    Line(points = {{11, -60}, {58, -60}, {58, 51}}, color = {0, 0, 127}));
  connect(add7.y, omegaPu) annotation(
    Line(points = {{81, 45}, {90, 45}, {90, 60}, {110, 60}}, color = {0, 0, 127}));

  // Phase integration: dTheta/dt = omegaNom * (omegaPu - OmegaRef)
  connect(omegaPu, add4.u1) annotation(
    Line(points = {{110, 60}, {20, 60}, {20, -4}, {28, -4}}, color = {0, 0, 127}));
  connect(OmegaRef, add4.u2) annotation(
    Line(points = {{-110, 0}, {20, 0}, {20, -16}, {28, -16}}, color = {0, 0, 127}));
  connect(add4.y, integrator1.u) annotation(
    Line(points = {{51, -10}, {68, -10}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>AC Grid model imposing a RoCoF disturbance on the frequency seen at the connected terminal, with no synchronous machine dynamics (no governor, turbine, or inertia), and no precompiled sub-component (voltage source equations written explicitly to avoid any nested-precompiled-model issue). Two successive frequency ramps are applied: a rise of RoCoFValue (pu/s) between t=5s and t=8s, held afterwards, then a symmetric fall between t=15s and t=18s bringing the frequency back to its reference value.</body></html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {175, -38}, extent = {{-45, 40}, {45, -40}}, textString = "OmegaPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 8}, extent = {{-74, 50}, {74, -50}}, textString = "ACGrid")}));
end AcGridRoCoF;
