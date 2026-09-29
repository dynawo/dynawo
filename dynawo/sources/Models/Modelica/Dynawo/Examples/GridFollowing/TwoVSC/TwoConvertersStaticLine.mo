within Dynawo.Examples.GridFollowing.TwoVSC;

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
* of simulation tools for power systems
*/

model TwoConvertersStaticLine "Two grid-following converters connected through static lines"
  // Target bandwidths — edit only these high-level settings
  parameter Real OmegaCC = 1200 "Inner current loop bandwidth in rad/s";
  parameter Real OmegaCCOuter = 10 "Outer P/Q loop bandwidth in rad/s";
  parameter Real OmegaCCPlant = 2 "Plant (power) controller bandwidth in rad/s";
  parameter Real OmegaPLL = 100 "PLL bandwidth in rad/s";
  parameter Real KsiPLL = 1 "PLL damping ratio";
  parameter Real OmegaLPF = 300 "Measurement low-pass filter cutoff in rad/s";
  parameter Real tPlant = 0.02 "Equivalent delay from plant to outer loop in s";
  final parameter Real tFilter = 1.0/OmegaLPF "Measurement filter time constant in s";
  // Effective impedances (filters + LV transformers)
  final parameter Real Rf1Pu = gFL1.RFilterPu + gFL1.RTransformerLVPu "Resistance seen by the current loop of GFL1 in pu (base UNom, SNom)";
  final parameter Real Lf1Pu = gFL1.LFilterPu + gFL1.LTransformerLVPu "Inductance seen by the current loop of GFL1 in pu (base UNom, SNom)";
  final parameter Real Rf2Pu = gFL2.RFilterPu + gFL2.RTransformerLVPu "Resistance seen by the current loop of GFL2 in pu (base UNom, SNom)";
  final parameter Real Lf2Pu = gFL2.LFilterPu + gFL2.LTransformerLVPu "Inductance seen by the current loop of GFL2 in pu (base UNom, SNom)";
  // Controller gains for Converter 1 (GFL1)
  final parameter Real KpCC1 = Lf1Pu*OmegaCC/Electrical.SystemBase.omegaNom "Current loop proportional gain of GFL1";
  final parameter Real KiCC1 = Rf1Pu*OmegaCC "Current loop integral gain of GFL1";
  final parameter Real KpOuter1 = OmegaCCOuter/OmegaLPF "Outer loop proportional gain of GFL1";
  final parameter Real KiOuter1 = OmegaCCOuter "Outer loop integral gain of GFL1";
  final parameter Real KpPLL1 = 2.0*KsiPLL*OmegaPLL/Electrical.SystemBase.omegaNom "PLL proportional gain of GFL1";
  final parameter Real KiPLL1 = OmegaPLL*OmegaPLL/Electrical.SystemBase.omegaNom "PLL integral gain of GFL1";
  final parameter Real KpPlant1 = OmegaCCPlant/OmegaCCOuter "Plant controller proportional gain of GFL1";
  final parameter Real KiPlant1 = OmegaCCPlant "Plant controller integral gain of GFL1";
  // Controller gains for Converter 2 (GFL2)
  final parameter Real KpCC2 = Lf2Pu*OmegaCC/Electrical.SystemBase.omegaNom "Current loop proportional gain of GFL2";
  final parameter Real KiCC2 = Rf2Pu*OmegaCC "Current loop integral gain of GFL2";
  final parameter Real KpOuter2 = OmegaCCOuter/OmegaLPF "Outer loop proportional gain of GFL2";
  final parameter Real KiOuter2 = OmegaCCOuter "Outer loop integral gain of GFL2";
  final parameter Real KpPLL2 = 2.0*KsiPLL*OmegaPLL/Electrical.SystemBase.omegaNom "PLL proportional gain of GFL2";
  final parameter Real KiPLL2 = OmegaPLL*OmegaPLL/Electrical.SystemBase.omegaNom "PLL integral gain of GFL2";
  final parameter Real KpPlant2 = OmegaCCPlant/OmegaCCOuter "Plant controller proportional gain of GFL2";
  final parameter Real KiPlant2 = OmegaCCPlant "Plant controller integral gain of GFL2";
  // Steady-state voltage reference values based on LambdaPu and Q0
  final parameter Real URef0Pu1 = gFL1.U0Pu + gFL1.LambdaPu*gFL1.QPcc0Pu "Initial voltage reference of GFL1 in pu (base UNom)";
  final parameter Real URef0Pu2 = gFL2.U0Pu + gFL2.LambdaPu*gFL2.QPcc0Pu "Initial voltage reference of GFL2 in pu (base UNom)";

  // GFL1
  Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFL1(SNom = 1000, U0Pu = 1.091230, UPhase0 = 0.063246, P0Pu = -5.010676, Q0Pu = -0.21, Omega0Pu = 1.0, tVSC = 0.00001, RFilterPu = 0.003, LFilterPu = 0.1, CFilterPu = 1e-5, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 0.001, LTransformerLVPu = 0.025, RTransformerHVPu = 0.001, LTransformerHVPu = 0.025, KFilter = 1, tFilter = tFilter, Kpc = KpCC1, Kic = KiCC1, KpdOuter = KpOuter1, KidOuter = KiOuter1, KpqOuter = KpOuter1, KiqOuter = KiOuter1, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 0, IMaxPu = 10, PQFlag = false, IqBoostMaxPu = 0.5, IqBoostMinPu = -0.5, KpqPlant = KpPlant1, KiqPlant = KiPlant1, KppPlant = KpPlant1, KipPlant = KiPlant1, LambdaPu = 0.417, KDroop = 15, QMaxPu = 0.3, QMinPu = -0.3, PMaxPu = 2, PMinPu = 0, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, KpPLL = KpPLL1, KiPLL = KiPLL1, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, DidMax = 10.0, DidMin = -10.0, tSid = 1e-4, tPlant = tPlant, Kfd = 1, Kfq = 0, tBoost = 1e-4, PControlFlag = false, QControlFlag = false) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
  // GFL2
  Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFL2(SNom = 1000, U0Pu = 1.086638, UPhase0 = -0.063421, P0Pu = 4.989324, Q0Pu = -0.21, Omega0Pu = 1.0, tVSC = 0.00001, RFilterPu = 0.003, LFilterPu = 0.1, CFilterPu = 1e-5, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 0.001, LTransformerLVPu = 0.025, RTransformerHVPu = 0.001, LTransformerHVPu = 0.025, KFilter = 1, tFilter = tFilter, Kpc = KpCC2, Kic = KiCC2, KpdOuter = KpOuter2, KidOuter = KiOuter2, KpqOuter = KpOuter2, KiqOuter = KiOuter2, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 0, IMaxPu = 10, PQFlag = false, IqBoostMaxPu = 0.5, IqBoostMinPu = -0.5, KpqPlant = KpPlant2, KiqPlant = KiPlant2, KppPlant = KpPlant2, KipPlant = KiPlant2, LambdaPu = 0.417, KDroop = 15, QMaxPu = 0.3, QMinPu = -0.3, PMaxPu = 0, PMinPu = -2, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, KpPLL = KpPLL2, KiPLL = KiPLL2, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, DidMax = 100000.0, DidMin = -10000.0, tSid = 1e-4, tPlant = tPlant, Kfd = 1, Kfq = 0, tBoost = 1e-4, PControlFlag = false, QControlFlag = false) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // Network elements (transmission lines and buses)
  Electrical.Lines.Line line(RPu = 0.00144, XPu = 0.0144, BPu = 0, GPu = 0) annotation(
    Placement(transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line1(RPu = 0.00144, XPu = 0.0144, BPu = 0, GPu = 0) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line2(RPu = 0.02, XPu = 0.2, BPu = 0, GPu = 0) annotation(
    Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.Line line3(RPu = 0.0077775, XPu = 0.077775, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Buses.Bus bus annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.100000, UPhase = -0.001082, omega0Pu = 1.0, UEvtPu = 0.5, tUEvtStart = 15.1, tUEvtEnd = 15.1, omegaEvtPu = 1.0, tOmegaEvtStart = 1e6, tOmegaEvtEnd = 1e6) annotation(
    Placement(transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu1(k = 1.0) annotation(
    Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu2(k = 1.0) annotation(
    Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step PRefPu1(offset = gFL1.PPcc0Pu, height = 0.1, startTime = 50) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step URefPu1(height = 0.1*URef0Pu1, offset = URef0Pu1, startTime = 480) annotation(
    Placement(transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PRefPu2(height = 0.1, offset = gFL2.PPcc0Pu, startTime = 50) annotation(
    Placement(transformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu2(k = URef0Pu2) annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;
  line2.switchOffSignal1 = false;
  line2.switchOffSignal2 = false;
  line3.switchOffSignal1 = if time >= 51.5 then true else false;
  line3.switchOffSignal2 = false;
  gFL1.switchOffSignal1 = false;
  gFL1.switchOffSignal2 = false;
  gFL1.switchOffSignal3 = false;
  gFL2.switchOffSignal1 = false;
  gFL2.switchOffSignal2 = false;
  gFL2.switchOffSignal3 = false;

  connect(gFL1.terminal, line.terminal1) annotation(
    Line(points = {{-60, 0}, {-40, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, bus.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(bus.terminal, line1.terminal1) annotation(
    Line(points = {{0, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, gFL2.terminal) annotation(
    Line(points = {{40, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(bus.terminal, line2.terminal1) annotation(
    Line(points = {{0, 0}, {0, -20}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{0, -40}, {0, -60}}, color = {0, 0, 255}));
  connect(line3.terminal2, line2.terminal2) annotation(
    Line(points = {{-40, -40}, {0, -40}}, color = {0, 0, 255}));
  connect(line3.terminal1, line2.terminal1) annotation(
    Line(points = {{-40, -20}, {0, -20}}, color = {0, 0, 255}));
  connect(omegaRefPu1.y, gFL1.omegaRefPu) annotation(
    Line(points = {{-139, -40}, {-121, -40}, {-121,  -12}, {-102, -12}}, color = {0, 0, 127}));
  connect(omegaRefPu2.y, gFL2.omegaRefPu) annotation(
    Line(points = {{139, 40}, {120.5, 40}, {120.5, 12}, {102, 12}}, color = {0, 0, 127}));
  connect(PRefPu1.y, gFL1.PRefPu) annotation(
    Line(points = {{-139, 40}, {-120.5, 40}, {-120.5, 12}, {-102, 12}}, color = {0, 0, 127}));
  connect(PRefPu2.y, gFL2.PRefPu) annotation(
    Line(points = {{139, -40}, {120.5, -40}, {120.5, -12}, {102, -12}}, color = {0, 0, 127}));
  connect(URefPu1.y, gFL1.URefPu) annotation(
    Line(points = {{-139, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(URefPu2.y, gFL2.URefPu) annotation(
    Line(points = {{139, 0}, {102, 0}}, color = {0, 0, 127}));

  annotation(
    experiment(StartTime = 0, StopTime = 70, Tolerance = 1e-05, Interval = 0.0005),
    preferredView = "diagram",
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Documentation(info = "<html><head></head><body>
<h4>Two grid-following converters connected through static lines</h4>

<p>Two grid-following converters with plant control (<code>DynGFLPlantQCtrl</code>) are connected to a common bus through
static lines (<code>Line</code>). The common bus is connected to an infinite bus through two parallel lines. The case
reproduces a reference two-converter EMT simulation with static lines, to compare the average model with the EMT results
and to study small-signal stability.</p>

<h4>Network</h4>
<pre>  gFL1 ---- line ---- bus ---- line1 ---- gFL2
                           |
              +------------+-------------+
              |                          |
            line2                      line3
              |                          |
              +------------+-------------+
                           |
               infiniteBusWithVariations (U = 1.1 pu)
</pre>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Line</th><th>RPu</th><th>XPu</th><th>Between</th></tr>
  <tr><td><code>line</code></td><td>0.00144</td><td>0.0144</td><td>gFL1 and bus</td></tr>
  <tr><td><code>line1</code></td><td>0.00144</td><td>0.0144</td><td>bus and gFL2</td></tr>
  <tr><td><code>line2</code></td><td>0.02</td><td>0.2</td><td>bus and infinite bus</td></tr>
  <tr><td><code>line3</code></td><td>0.0077775</td><td>0.077775</td><td>bus and infinite bus (opened during the simulation)</td></tr>
</tbody></table>
<p>Impedances in pu on the system base (SnRef = 100 MVA). The lines are static (no shunt, <code>BPu = GPu = 0</code>).</p>

<h4>Converters</h4>
<ul>
  <li>Both converters: <code>SNom = 1000 MVA</code>, no VSC delay (<code>tVSC = 1e-5 s</code>), voltage feedforward on the
      d-axis only (<code>Kfd = 1</code>, <code>Kfq = 0</code>), reactive power priority (<code>PQFlag = false</code>),
      no reactive current boost (<code>Kqv = 0</code>), <code>IMaxPu = 10</code>;</li>
  <li><code>gFL1</code> injects P = 0.501 pu (<code>P0Pu = -5.010676</code>, base SnRef, receptor convention);</li>
  <li><code>gFL2</code> absorbs P = 0.499 pu (<code>P0Pu = 4.989324</code>), so most of the power flows from one
      converter to the other through the common bus;</li>
  <li>both inject Q = 0.021 pu (<code>Q0Pu = -0.21</code>).</li>
</ul>

<h4>Controller tuning</h4>
<p>All controller gains are derived from the target bandwidths at the top of the model, with the same rules as in
<code>DynGFLPlantQCtrlBandWidth</code>:</p>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Loop</th><th>Bandwidth</th><th>Gains</th></tr>
  <tr><td>Measurement filter</td><td><code>OmegaLPF = 300 rad/s</code></td><td><code>tFilter = 1/OmegaLPF = 3.33 ms</code></td></tr>
  <tr><td>Current loop</td><td><code>OmegaCC = 1200 rad/s</code></td>
      <td><code>KpCC = LgPu*OmegaCC/omegaNom = 0.477</code>, <code>KiCC = RgPu*OmegaCC = 4.8</code></td></tr>
  <tr><td>Outer loop (both axes)</td><td><code>OmegaCCOuter = 10 rad/s</code></td>
      <td><code>KpOuter = OmegaCCOuter/OmegaLPF = 0.0333</code>, <code>KiOuter = OmegaCCOuter = 10</code></td></tr>
  <tr><td>PLL</td><td><code>OmegaPLL = 100 rad/s</code>, <code>KsiPLL = 1</code></td>
      <td><code>KpPLL = 2*KsiPLL*OmegaPLL/omegaNom = 0.637</code>, <code>KiPLL = OmegaPLL^2/omegaNom = 31.8</code></td></tr>
  <tr><td>Plant controller (P and U/Q)</td><td><code>OmegaCCPlant = 2 rad/s</code></td>
      <td><code>KpPlant = OmegaCCPlant/OmegaCCOuter = 0.2</code>, <code>KiPlant = OmegaCCPlant = 2</code></td></tr>
</tbody></table>
<p>With <code>LgPu = LFilterPu + LTransformerLVPu = 0.125 pu</code> and <code>RgPu = RFilterPu + RTransformerLVPu = 0.004 pu</code>.
The gains are computed separately for each converter (suffix 1 for <code>gFL1</code>, 2 for <code>gFL2</code>).</p>

<h4>Scenario</h4>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Event</th><th>Block</th><th>Time</th></tr>
  <tr><td>Active power reference steps, +0.1 pu on both converters</td><td><code>PRefPu1</code>, <code>PRefPu2</code></td>
      <td>t = 50 s</td></tr>
  <tr><td>Opening of the parallel line <code>line3</code> (bus side)</td><td><code>line3.switchOffSignal1</code></td>
      <td>t = 51.5 s</td></tr>
  <tr><td>Voltage reference step, +10 % (gFL1)</td><td><code>URefPu1</code></td><td>t = 480 s (inactive)</td></tr>
  <tr><td>Grid voltage dip</td><td><code>infiniteBusWithVariations</code></td>
      <td>zero duration at t = 15.1 s (inactive)</td></tr>
</tbody></table>
<p>The voltage references start at <code>URef0Pu = U0Pu + LambdaPu*QPcc0Pu</code>, and the active power references start at
<code>PPcc0Pu</code>.</p>

<h4>Notes</h4>
<ul>
  <li>To reproduce the EMT results, the VSC delay is removed and the line reactances of the EMT case are used. If the VSC
      delay is kept (<code>tVSC = 1 ms</code>), keep the control unchanged and adjust the line reactance.</li>
  <li>After the opening of <code>line3</code>, the converters are connected to the infinite bus through <code>line2</code>
      only. The stability limit depends on its reactance <code>line2.XPu</code> and on the voltage feedforward gains
      <code>Kfd</code>, <code>Kfq</code>.</li>
</ul>
</body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica ");
end TwoConvertersStaticLine;
