within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls;
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
model CCVSM "Virtual Synchronous Machine control with PI control on Theta"

  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";
  parameter Types.PerUnit KDampingAngle "Proportional gain of the PI action on theta (angle-damping term) in s";
  // Initial parameters
  parameter Types.PerUnit PFilter0Pu "Start value of active power after the filter in pu (base SNom) (generator convention)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of the converter's frequency in pu (base omegaNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter and grid rotating frames in rad (generator convention)";

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
  // Proportional part of the PI action on theta (remains active if the integral part integrator1 is frozen)
  Modelica.Blocks.Math.Gain gainDampingAngle(k = KDampingAngle*SystemBase.omegaNom) annotation(
    Placement(transformation(origin = {64, 30}, extent = {{-8, -8}, {8, 8}})));
  // theta = integral part + proportional part
  Modelica.Blocks.Math.Add addTheta(k1 = 1, k2 = 1) annotation(
    Placement(transformation(origin = {90, 58}, extent = {{-8, -8}, {8, 8}})));


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
  connect(feedback1.y, gainDampingAngle.u) annotation(
    Line(points = {{40, 60}, {40, 40}, {54, 40}, {54, 30}}, color = {0, 0, 127}));
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
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>
<p>This model is a Virtual Synchronous Machine (VSM) control, identical to the <b>VSM</b> block (cf. documentation of Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.VSM), except for an additional <b>proportional angle-damping term</b> of gain KDampingAngle:</p>
<p>2H · dω/dt = P<sub>FilterRef</sub> − P<sub>Filter</sub> − k<sub>VSM</sub> · (ω − ω<sub>Set</sub>)</p>
<p>θ = ω<sub>Nom</sub> · [∫(ω − ω<sub>Ref</sub>) dt + K<sub>DampingAngle</sub> · (ω − ω<sub>Ref</sub>)]</p>
<p>where K<sub>DampingAngle</sub> is expressed in s. With KDampingAngle = 0, this block is strictly equivalent to the VSM block.</p>

<h4>Role of KDampingAngle</h4>
<p>In the vanilla VSM block, the angle θ is a pure integral of the frequency error ω − ω<sub>Ref</sub>. Here the same error also feeds a proportional path, so that the angle is obtained through a <b>PI action</b> on the frequency error:</p>
<p>Δθ(s) = ω<sub>Nom</sub> · (1 / s + K<sub>DampingAngle</sub>) · Δω(s) = ω<sub>Nom</sub> · (1 + K<sub>DampingAngle</sub> · s) / s · Δω(s)</p>
<p>K<sub>DampingAngle</sub> is thus the time constant of the phase lead (zero at s = −1 / K<sub>DampingAngle</sub>) added to the pure integral of the VSM block.</p>
<ul>
<li>The proportional term is not integrated: it vanishes in steady state (ω = ω<sub>Ref</sub>), so it does not change the operating point nor the steady-state active power / frequency behaviour set by H and k<sub>VSM</sub>.</li>
<li>It acts instantaneously on θ, hence on the active power exchanged with the grid, and therefore brings an additional damping of the electromechanical oscillations.</li>
<li>This block is meant to be used together with a current saturation (CurrentSaturation block), see below (such changes have not been implemented yet).</li>
</ul>

<h4>Behaviour under current saturation</h4>
<p>While the converter current is limited, the active power no longer follows the angle (ΔP = K<sub>S</sub> · Δθ does not hold anymore) and stays close to a saturated value P<sub>Sat</sub>:</p>
<ul>
<li>the swing equation integrator (ω) does not wind up thanks to the damping term k<sub>VSM</sub>: ω converges towards ω<sub>Set</sub> + (P<sub>FilterRef</sub> − P<sub>Sat</sub>) / k<sub>VSM</sub>, i.e. a permanent frequency deviation as long as the saturation lasts;</li>
<li>the integral part of the angle (integrator1) integrates this deviation, so that θ drifts without bound, which may lead to a loss of synchronism.</li>
</ul>
<p>The intended anti-windup strategy is therefore to freeze the <b>integral part of θ</b> (integrator1) while the current is saturated (BlocCurrentSaturationEnable signal of the CurrentSaturation block). The proportional term then remains the only active path acting on θ:</p>
<p>θ = θ<sub>Frozen</sub> + ω<sub>Nom</sub> · K<sub>DampingAngle</sub> · (ω − ω<sub>Ref</sub>)</p>
<p>so that the angle stays controlled and damped during the saturation, with a bounded drift of about ω<sub>Nom</sub> · K<sub>DampingAngle</sub> · (P<sub>FilterRef</sub> − P<sub>Sat</sub>) / k<sub>VSM</sub> (for ω<sub>Set</sub> = ω<sub>Ref</sub>). Without the proportional term, freezing the integral part would freeze θ completely.</p>
<p><b>Note:</b> this freezing is not implemented yet in this block: integrator1 is currently never frozen. When implemented, attention should be paid to a grid frequency deviation during the saturation (a frozen integral part no longer tracks the grid phase if ω<sub>Set</sub> ≠ ω<sub>Ref</sub>) and to the transient at the release of the saturation.</p>

<h4>Small-signal analysis</h4>
<p>With the same assumptions as for the VSM block (stiff grid with ω<sub>Set</sub> = ω<sub>Ref</sub> = 1 pu, constant E and V, fast inner loops, filter and resistances neglected, constant P<sub>FilterRef</sub>, small variations around θ<sub>0</sub>) and ΔP = K<sub>S</sub> · Δθ with K<sub>S</sub> = E · V · cos(θ<sub>0</sub>) / X:</p>
<p>2H · dΔω/dt = − K<sub>S</sub> · Δθ − k<sub>VSM</sub> · Δω, with dΔθ/dt = ω<sub>Nom</sub> · (Δω + K<sub>DampingAngle</sub> · dΔω/dt)</p>
<p>Differentiating with respect to time gives:</p>
<p>2H · d<sup>2</sup>Δω/dt<sup>2</sup> + (k<sub>VSM</sub> + K<sub>S</sub> · ω<sub>Nom</sub> · K<sub>DampingAngle</sub>) · dΔω/dt + K<sub>S</sub> · ω<sub>Nom</sub> · Δω = 0</p>
<p>The angle-damping term therefore simply adds K<sub>S</sub> · ω<sub>Nom</sub> · K<sub>DampingAngle</sub> to the damping coefficient k<sub>VSM</sub>:</p>
<ul>
<li>natural angular frequency (unchanged): ω<sub>n</sub> = √(K<sub>S</sub> · ω<sub>Nom</sub> / 2H)</li>
<li>damping ratio: ζ = (k<sub>VSM</sub> + K<sub>S</sub> · ω<sub>Nom</sub> · K<sub>DampingAngle</sub>) / (4H · ω<sub>n</sub>)</li>
<li>decay time constant of the oscillation envelope: τ = 4H / (k<sub>VSM</sub> + K<sub>S</sub> · ω<sub>Nom</sub> · K<sub>DampingAngle</sub>)</li>
</ul>
<p>Unlike k<sub>VSM</sub>, the damping brought by KDampingAngle is proportional to K<sub>S</sub>: it is the most effective on strong grids (low X), precisely where the damping ratio of the plain VSM (ζ proportional to 1/√K<sub>S</sub>) is the lowest.</p>
</body></html>"));
end CCVSM;
