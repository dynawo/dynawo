within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls;

model VSM "Virtual Synchronous Machine control"
  /*
  * Copyright (c) 2026, RTE (http://www.rte-france.com)
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
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";
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
    Placement(visible = true, transformation(origin = {78, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Initial parameters
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
    Line(points = {{40, 60}, {66, 60}}, color = {0, 0, 127}));
  connect(integrator1.y, theta) annotation(
    Line(points = {{90, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(integrator.y, omegaPu) annotation(
    Line(points = {{-14, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(add3.y, integrator.u) annotation(
    Line(points = {{-52, 0}, {-38, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>
<p>This model represents a Virtual Synchronous Machine (VSM) aiming at emulating the behaviour of a synchronous machine with the same general \"swing\" equation, where a change in requested active power induces a variation of (angular) frequency. As modelled in this block:</p>
<p>2H · dω/dt = P<sub>FilterRef</sub> − P<sub>Filter</sub> − k<sub>VSM</sub> · (ω − ω<sub>Set</sub>)</p>
<p>dθ/dt = ω<sub>Nom</sub> · (ω − ω<sub>Ref</sub>)</p>
<p>where ω is the converter angular frequency (in pu, base ω<sub>Nom</sub>) and θ the corresponding converter angle (in rad), i.e. the phase shift between the converter rotating frame and the reference rotating frame.</p>

<h4>Frequency inputs</h4>
<ul>
<li><b>omegaRefPu</b> (ω<sub>Ref</sub>): frequency of the reference rotating frame in which the angle θ is expressed. It is typically set to 1 pu and serves as a reference only: it has no influence on the active power / frequency dynamics, it only defines the frame in which θ is computed.</li>
<li><b>omegaSetPu</b> (ω<sub>Set</sub>): grid frequency, directly measured with a PLL. The damping term k<sub>VSM</sub> · (ω − ω<sub>Set</sub>) acts only on the deviation between the converter and the grid frequencies, so that it damps the power oscillations without opposing a change of the grid frequency itself (no steady-state droop is introduced by this term).</li>
</ul>

<h4>Small-signal analysis</h4>
<p>Assumptions:</p>
<ul>
<li>the converter is connected through a total reactance X (filter, transformer and grid, in pu) to a stiff grid of voltage magnitude V, whose frequency is constant and equal to the reference one (ω<sub>Set</sub> = ω<sub>Ref</sub> = 1 pu, perfect PLL tracking);</li>
<li>the internal voltage magnitude E of the converter is constant and the inner (voltage and current) control loops are much faster than the VSM dynamics;</li>
<li>the active power filter is neglected (P<sub>Filter</sub> = P) and resistances are neglected;</li>
<li>small variations around an operating point (E, V, θ<sub>0</sub>).</li>
<li>the reference active power is constant dP<sub>FilterRef</sub>/dt = 0</li>
</ul>
<p>Under these assumptions θ is the load angle between the converter and the grid, P = E · V · sin(θ) / X and, after linearization:</p>
<p>ΔP = K<sub>S</sub> · Δθ, with K<sub>S</sub> = E · V · cos(θ<sub>0</sub>) / X the synchronizing power coefficient (in pu).</p>
<p>Differentiating the swing equation with respect to time and using dΔθ/dt = ω<sub>Nom</sub> · Δω gives a second order differential equation in Δω = ω − 1:</p>
<p>2H · d<sup>2</sup>Δω/dt<sup>2</sup> + k<sub>VSM</sub> · dΔω/dt + K<sub>S</sub> · ω<sub>Nom</sub> · Δω = dP<sub>FilterRef</sub>/dt =0</p>
<p>which can be written in the canonical form:</p>
<p>d<sup>2</sup>Δω/dt<sup>2</sup> + 2 ζ ω<sub>n</sub> · dΔω/dt + ω<sub>n</sub><sup>2</sup> · Δω = (1 / 2H) · dP<sub>FilterRef</sub>/dt = 0</p>
<p>with:</p>
<ul>
<li>natural angular frequency (in rad/s): ω<sub>n</sub> = √(K<sub>S</sub> · ω<sub>Nom</sub> / 2H)</li>
<li>damping ratio: ζ = k<sub>VSM</sub> / (4H · ω<sub>n</sub>) = k<sub>VSM</sub> / (2 · √(2H · K<sub>S</sub> · ω<sub>Nom</sub>))</li>
</ul>
<p>Characteristic times analysis:</p>
<ul>
<li>natural period of the power oscillations: T<sub>n</sub> = 2π / ω<sub>n</sub> (damped period 2π / (ω<sub>n</sub> · √(1 − ζ<sup>2</sup>)) when ζ &lt; 1);</li>
<li>decay time constant of the oscillation envelope: τ = 1 / (ζ ω<sub>n</sub>) = 4H / k<sub>VSM</sub>;</li>
<li>when the synchronizing effect is negligible (K<sub>S</sub> → 0, weak coupling to the grid), the frequency follows a first order response with time constant T<sub>VSM</sub> = 2H / k<sub>VSM</sub>.</li>
</ul>
<p>Increasing H decreases ω<sub>n</sub> and ζ (slower and less damped oscillations), increasing k<sub>VSM</sub> increases ζ, while a stronger grid (lower X, higher K<sub>S</sub>) increases ω<sub>n</sub> and decreases ζ.&nbsp;</p>
</body></html>"));
end VSM;
