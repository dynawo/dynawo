within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model DynRLTransformerRI2 "Dynamic RL element in RI frame (pu) between two AC terminals"
  /*
   Equivalent circuit and conventions:

   uFiltPu,iPccPu                              -iPccPu,uPccPu
   (terminal1) -->-------(RLV+RHV)+j(XLV+XHV)-------<-- (terminal2)

    */

  // Parameters
  parameter Types.PerUnit RPu "Series resistance in pu (base UNom, SnRef)";
  parameter Types.PerUnit LPu "Series inductance in pu (base UNom, SnRef)";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Electrical frequency in pu (base SystemBase.omegaNom)" annotation(
    Placement(transformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Connectors.ACPower terminal1 "Terminal1 (e.g. Filter side)" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  Connectors.ACPower terminal2 "Terminal2 (e.g. HV/PCC side)" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}})));

  Types.PerUnit irPccPu(start = IrPcc0Pu) "Real-axis branch current from terminal1 to terminal2 in pu (base UNom, SnRef)";
  Types.PerUnit iiPccPu(start = IiPcc0Pu) "Imag-axis branch current from terminal1 to terminal2 in pu (base UNom, SnRef)";

  // Initial parameters
  parameter Types.AngularVelocityPu Omega0Pu "Initial electrical frequency in pu (base omegaNom)";
  parameter Types.PerUnit IrPcc0Pu "Initial real-axis branch current from terminal1 to terminal2 in pu (base UNom, SnRef) (generator convention)";
  parameter Types.PerUnit IiPcc0Pu "Initial imag-axis branch current from terminal1 to terminal2 in pu (base UNom, SnRef) (generator convention)";

equation
  terminal1.i.re = irPccPu;
  terminal1.i.im = iiPccPu;
  terminal2.i.re = -irPccPu;
  terminal2.i.im = -iiPccPu;
  LPu/SystemBase.omegaNom*der(irPccPu) = terminal1.V.re - RPu*irPccPu + omegaPu*LPu*iiPccPu - terminal2.V.re;
  LPu/SystemBase.omegaNom*der(iiPccPu) = terminal1.V.im - RPu*iiPccPu - omegaPu*LPu*irPccPu - terminal2.V.im;

  annotation(
    preferredView = "text",
    Icon(graphics = {Line(origin = {0.292174, 0}, points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}), Line(origin = {0.4243, 0.292221}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {30, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {60, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {60, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {90, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {160.466, 0.26087}, points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.01)),
    Documentation(info = "<html>
    <pre>
  terminal1.V, iPccPu                          -iPccPu, terminal2.V
  (terminal1) --&gt;----- RPu + j*omegaPu*LPu -----&lt;-- (terminal2)
  (filter side)                                     (HV / PCC side)
</pre>
<p>All quantities in pu (base UNom, SnRef): <code>terminal1.i = iPccPu</code>, <code>terminal2.i = -iPccPu</code>.</p>
<h4>Dynamic RL branch (RI coordinates, per-unit) &ndash; GFL plant</h4>

<p>Dynamic model of a series RL element between two AC terminals, written in real/imaginary (RI) coordinates.
It is typically used to model:</p>
<ul>
  <li>a transformer leakage impedance (LV and/or HV winding);</li>
  <li>an equivalent line / grid impedance.</li>
</ul>

<p>The branch impedance is:</p>
<pre>
  Z = RPu + j * omegaPu * LPu
</pre>
<ul>
  <li><code>RPu</code>: series resistance in pu (base UNom, SnRef);</li>
  <li><code>LPu</code>: series inductance in pu (base UNom, SnRef);</li>
  <li><code>omegaPu</code>: electrical frequency in pu (base <code>SystemBase.omegaNom</code>), given as an input.</li>
</ul>

<h4>Connectors</h4>
<ul>
  <li><code>terminal1</code>: first AC terminal (e.g. filter side);</li>
  <li><code>terminal2</code>: second AC terminal (e.g. HV / PCC side);</li>
  <li><code>omegaPu</code>: frequency input (e.g. from the PLL).</li>
</ul>

<h4>State variables</h4>
<ul>
  <li><code>irPccPu</code>, <code>iiPccPu</code>: branch current, real and imaginary parts, flowing from
      <code>terminal1</code> to <code>terminal2</code>, in pu (base UNom, SnRef).</li>
</ul>

<h4>Equations</h4>
<p>Connector currents:</p>
<pre>
  terminal1.i =  (irPccPu + j*iiPccPu)
  terminal2.i = -(irPccPu + j*iiPccPu)
</pre>
<p>RL branch dynamics:</p>
<pre>
  LPu/omegaNom * der(irPccPu) = terminal1.V.re - RPu*irPccPu + omegaPu*LPu*iiPccPu - terminal2.V.re
  LPu/omegaNom * der(iiPccPu) = terminal1.V.im - RPu*iiPccPu - omegaPu*LPu*irPccPu - terminal2.V.im
</pre>
<p>where <code>omegaNom = SystemBase.omegaNom</code> (rad/s).</p>

<h4>Sign conventions</h4>
<ul>
  <li>Connector currents follow the Dynawo <code>ACPower</code> convention: <code>terminal.i</code> is positive when entering the device.</li>
  <li>Seen from the grid at <code>terminal2</code>, <code>irPccPu</code>, <code>iiPccPu</code> are the current injected
      into the grid (generator convention), as set by the upper-level model through <code>IrPcc0Pu</code>, <code>IiPcc0Pu</code>.</li>
  <li>Hence the current enters the device at <code>terminal1</code> (<code>terminal1.i = +iPcc</code>) and leaves it at
      <code>terminal2</code> (<code>terminal2.i = -iPcc</code>).</li>
</ul>

<h4>Units and base</h4>
<ul>
  <li>All electrical quantities are in per-unit on the system base (<code>UNom</code>, <code>SystemBase.SnRef</code>).
      No base conversion is applied in the equations, so <code>RPu</code> and <code>LPu</code> must be on the same base
      as the terminal quantities.</li>
  <li>Dynamics use <code>SystemBase.omegaNom</code> as the time base.</li>
</ul>

<h4>Initialization</h4>
<p>Start values are set by the parameters <code>IrPcc0Pu</code>, <code>IiPcc0Pu</code> (branch current in pu, base UNom, SnRef,
generator convention) and <code>Omega0Pu</code> (frequency in pu, base omegaNom).</p>
</html>"));
end DynRLTransformerRI2;
