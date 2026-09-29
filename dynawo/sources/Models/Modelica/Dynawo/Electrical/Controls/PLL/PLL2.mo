within Dynawo.Electrical.Controls.PLL;

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

model PLL2 "Phase-Locked Loop"
  // Parameters
  parameter Types.PerUnit Kp "PLL proportional gain in pu/pu (frequency pu per voltage pu)";
  parameter Types.PerUnit Ki "PLL integral gain in pu/(pu.s)";
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)";
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Reference frequency of the system (pu, base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis filter voltage in the PLL frame in pu (base UNom), PLL error signal" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = Omega0Pu) "Estimated grid frequency in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Estimated grid voltage phase angle in rad" annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Ki, outMax = OmegaMaxPu - Omega0Pu, outMin = OmegaMinPu - Omega0Pu, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Theta0, k = SystemBase.omegaNom, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.AngularVelocityPu Omega0Pu "Start value of grid frequency in pu (base OmegaNom)";
  parameter Types.Angle Theta0 "Start value of phase angle between converter frame and grid frame in rad";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis grid voltage in converter frame in pu (base UNom) — should be 0 at lock";

equation
  connect(uqFilterPu, gain.u) annotation(
    Line(points = {{-150, 0}, {-60, 0}, {-60, 20}, {-12, 20}}, color = {0, 0, 127}));
  connect(uqFilterPu, limIntegrator.u) annotation(
    Line(points = {{-150, 0}, {-60, 0}, {-60, -20}, {-12, -20}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{11, 20}, {20, 20}, {20, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add1.u2) annotation(
    Line(points = {{11, -20}, {20, -20}, {20, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{61, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(add1.y, add2.u1) annotation(
    Line(points = {{61, 0}, {80, 0}, {80, -54}, {98, -54}}, color = {0, 0, 127}));
  connect(omegaRefPu, add2.u2) annotation(
    Line(points = {{-150, -80}, {80, -80}, {80, -66}, {98, -66}}, color = {0, 0, 127}));
  connect(add2.y, omegaPLLPu) annotation(
    Line(points = {{121, -60}, {150, -60}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{121, 0}, {150, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<h4>Phase-Locked Loop (PLL) &ndash; GFL control</h4>

<p>Synchronization unit of the grid-following converter. It estimates the angle <code>theta</code> of the filter
capacitor voltage and the frequency <code>omegaPLLPu</code> by driving the q-axis component of that voltage,
<code>uqFilterPu</code>, to zero in the PLL dq frame. When <code>uqFilterPu = 0</code>, the d-axis is aligned with
the filter voltage phasor.</p>

<h4>Inputs</h4>
<p>In this model we give directly the <code>uqFilterPu</code> instead of calculating it in the model as in the PLL.mo model. <code>omegaRefPu</code> the reference frequency of the grid is also given as an input.</p>

<h4>Equations</h4>
<pre>
  dOmegaPu   = Kp*uqFilterPu + xIPu
  der(xIPu)  = Ki*uqFilterPu,   OmegaMinPu - Omega0Pu &lt;= xIPu &lt;= OmegaMaxPu - Omega0Pu
  omegaPLLPu = omegaRefPu + dOmegaPu
  der(theta) = omegaNom * dOmegaPu = omegaNom * (omegaPLLPu - omegaRefPu)
</pre>
<p>The network RI frame already rotates at <code>omegaRefPu</code>, so only the frequency deviation
<code>dOmegaPu</code> is integrated: <code>theta</code> is the PLL angle relative to that frame, which is the angle used
by the dq/RI transformations.</p>
<p>With <code>uqFilterPu = -uFilt.re*sin(theta) + uFilt.im*cos(theta) = UFilt*sin(phi - theta)</code>, where
<code>phi</code> is the angle of the filter voltage, a positive <code>uqFilterPu</code> means that the PLL lags the voltage.
The PLL then increases its frequency. The loop gain is proportional to the voltage magnitude <code>UFilt</code>.</p>

<h4>Frequency limits</h4>
<p>Only the integral branch is limited, to <code>[OmegaMinPu - Omega0Pu, OmegaMaxPu - Omega0Pu]</code>. The proportional
branch is not limited, so <code>omegaPLLPu</code> can go briefly outside <code>[OmegaMinPu, OmegaMaxPu]</code> during
transients. The limits are also relative to <code>Omega0Pu</code>, not to the current <code>omegaRefPu</code>.</p>

<h4>Units and base</h4>
<ul>
  <li>Frequencies in pu (base <code>omegaNom = SystemBase.omegaNom</code>, rad/s); <code>theta</code> in rad.</li>
  <li><code>uqFilterPu</code> in pu (base UNom).</li>
</ul>

<h4>Initialization</h4>
<ul>
  <li><code>theta</code> starts at <code>Theta0</code>, the angle of the initial filter voltage, so that
      <code>UqFilter0Pu = 0</code>;</li>
  <li>The integral branch starts at 0, so <code>omegaPLLPu</code> starts at <code>omegaRefPu</code> = <code>Omega0Pu</code>.</li>
</ul>

<h4>Tuning note</h4>
<p>The PLL bandwidth is set by <code>Kp</code>, <code>Ki</code> and the voltage magnitude. The PLL can interact with
the outer loops and cause low-frequency oscillations (Cheng et al. 2023).</p>
</html>"),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-31, 8}, extent = {{-49, 72}, {111, -88}}, textString = "PLL")}));
end PLL2;
