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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems
*/

model TwoConvertersDynamicLine7Hz "Two grid-following converters connected through dynamic lines, with a 7 Hz oscillation"
  // Target bandwidths — edit only these high-level settings
  parameter Real OmegaCC = 1200 "Inner current loop bandwidth in rad/s";
  parameter Real OmegaCCOuter = 4.5 "Outer P/Q loop bandwidth in rad/s";
  parameter Real OmegaCCPlant = 1.3 "Plant (power) controller bandwidth in rad/s";
  parameter Real OmegaPLL = 10 "PLL bandwidth in rad/s";
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
  Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFL1(SNom = 1000, U0Pu = 1.045333, UPhase0 = 0.0665, P0Pu = -5.03, Q0Pu = -0.21, Omega0Pu = 1.0, tVSC = 2e-3, RFilterPu = 0.003, LFilterPu = 0.1, CFilterPu = 1e-5, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 0.001, LTransformerLVPu = 0.025, RTransformerHVPu = 0.001, LTransformerHVPu = 0.025, KFilter = 1, tFilter = tFilter, Kpc = KpCC1, Kic = KiCC1, KpdOuter = KpOuter1, KidOuter = KiOuter1, KpqOuter = KpOuter1, KiqOuter = KiOuter1, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 2, IMaxPu = 20, PQFlag = false, IqBoostMaxPu = 0.5, IqBoostMinPu = -0.5, KpqPlant = KpPlant1, KiqPlant = KiPlant1, KppPlant = KpPlant1, KipPlant = KiPlant1, LambdaPu = 0.417, KDroop = 15, QMaxPu = 0.3, QMinPu = -0.3, PMaxPu = 2, PMinPu = 0, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, KpPLL = KpPLL1, KiPLL = KiPLL1, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, DidMax = 10.0, DidMin = -10.0, tSid = 1e-4, tPlant = tPlant, Kfd = 1, Kfq = 1, tBoost = 1e-4, PControlFlag = false, QControlFlag = false) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
  // GFL2
  Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFL2(SNom = 1000, U0Pu = 1.029, UPhase0 = -0.06721, P0Pu = 4.989324, Q0Pu = -0.21, Omega0Pu = 1.0, tVSC = 2e-3, RFilterPu = 0.003, LFilterPu = 0.1, CFilterPu = 1e-5, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 0.001, LTransformerLVPu = 0.025, RTransformerHVPu = 0.001, LTransformerHVPu = 0.025, KFilter = 1, tFilter = tFilter, Kpc = KpCC2, Kic = KiCC2, KpdOuter = KpOuter2, KidOuter = KiOuter2, KpqOuter = KpOuter2, KiqOuter = KiOuter2, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 2, IMaxPu = 2, PQFlag = false, IqBoostMaxPu = 0.5, IqBoostMinPu = -0.5, KpqPlant = KpPlant2, KiqPlant = KiPlant2, KppPlant = KpPlant2, KipPlant = KiPlant2, LambdaPu = 0.417, KDroop = 15, QMaxPu = 0.3, QMinPu = -0.3, PMaxPu = 0, PMinPu = -2, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, KpPLL = KpPLL2, KiPLL = KiPLL2, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, DidMax = 100000.0, DidMin = -10000.0, tSid = 1e-4, tPlant = tPlant, Kfd = 1, Kfq = 1, tBoost = 1e-4, PControlFlag = false, QControlFlag = false) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // Network elements (dynamic lines, buses and switch)
  Electrical.Buses.Bus bus annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.100000, UPhase = -0.001082, omega0Pu = 1.0, UEvtPu = 0.5, tUEvtStart = 15.1, tUEvtEnd = 15.1, omegaEvtPu = 1.0, tOmegaEvtStart = 1e6, tOmegaEvtEnd = 1e6) annotation(
    Placement(transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.DynLineRL dynLine(RPu = 0.00144, LPu = 0.0144, U01Pu = gFL1.U0Pu, UPhase01 = gFL1.UPhase0, P01Pu = gFL1.P0Pu, Q01Pu = gFL1.Q0Pu, U02Pu = 1.036053, UPhase02 = 0, P02Pu = -0.50, Q02Pu = -0.012) annotation(
    Placement(transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.DynLineRL dynLine1(RPu = 0.00144, LPu = 0.0144, U01Pu = 1.036, UPhase01 = 0, P01Pu = 0.499, Q01Pu = 0.0125, U02Pu = gFL2.U0Pu, UPhase02 = gFL2.UPhase0, P02Pu = -gFL2.P0Pu, Q02Pu = -gFL2.Q0Pu) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.DynLineRL dynLine2(RPu = 0.01, LPu = 0.1, U01Pu = 1.036, UPhase01 = 0, P01Pu = 0.0005, Q01Pu = -0.013, U02Pu = infiniteBusWithVariations.U0Pu, UPhase02 = infiniteBusWithVariations.UPhase, P02Pu = -0.0005, Q02Pu = 0.013) annotation(
    Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.DynLineRL dynLine3(RPu = 0.0077775, LPu = 0.077775, U01Pu = dynLine2.U02Pu, UPhase01 = dynLine2.UPhase02, P01Pu = dynLine2.P02Pu, Q01Pu = dynLine2.Q02Pu, U02Pu = dynLine2.U01Pu, UPhase02 = dynLine2.UPhase01, P02Pu = dynLine2.P01Pu, Q02Pu = dynLine2.Q01Pu) annotation(
    Placement(transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Switches.IdealSwitch2 idealSwitch annotation(
    Placement(transformation(origin = {-20, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanTable booleanTable(table = {0, 51.5}, startValue = true) annotation(
    Placement(transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
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
  dynLine.switchOffSignal1 = false;
  dynLine.switchOffSignal2 = false;
  dynLine1.switchOffSignal1 = false;
  dynLine1.switchOffSignal2 = false;
  dynLine2.switchOffSignal1 = false;
  dynLine2.switchOffSignal2 = false;
  dynLine3.switchOffSignal1 = if time >= 51.5 then true else false;
  dynLine3.switchOffSignal2 = false;
  gFL1.switchOffSignal1 = false;
  gFL1.switchOffSignal2 = false;
  gFL1.switchOffSignal3 = false;
  gFL2.switchOffSignal1 = false;
  gFL2.switchOffSignal2 = false;
  gFL2.switchOffSignal3 = false;
  dynLine.omegaPu = 1;
  dynLine1.omegaPu = 1;
  dynLine2.omegaPu = 1;
  dynLine3.omegaPu = 1;

  connect(gFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{-60, 0}, {-40, 0}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, bus.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(bus.terminal, dynLine1.terminal1) annotation(
    Line(points = {{0, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(dynLine1.terminal2, gFL2.terminal) annotation(
    Line(points = {{40, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(dynLine2.terminal1, bus.terminal) annotation(
    Line(points = {{0, -20}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, dynLine2.terminal2) annotation(
    Line(points = {{0, -60}, {0, -40}}, color = {0, 0, 255}));
  connect(dynLine3.terminal1, dynLine2.terminal2) annotation(
    Line(points = {{-40, -40}, {0, -40}}, color = {0, 0, 255}));
  connect(dynLine3.terminal2, idealSwitch.terminal1) annotation(
    Line(points = {{-40, -20}, {-40, -20.5}, {-30, -20.5}, {-30,  -21}}, color = {0, 0, 255}));
  connect(idealSwitch.terminal2, dynLine2.terminal1) annotation(
    Line(points = {{-10, -21}, {-10, -20}, {0, -20}}, color = {0, 0, 255}));
  connect(idealSwitch.control, booleanTable.y) annotation(
    Line(points = {{-20, -12}, {11.5, -12}, {11.5, -40}, {19, -40}}, color = {255, 0, 255}));
  connect(omegaRefPu1.y, gFL1.omegaRefPu) annotation(
    Line(points = {{-139, -40}, {-119, -40}, {-119,  -12}, {-102, -12}}, color = {0, 0, 127}));
  connect(omegaRefPu2.y, gFL2.omegaRefPu) annotation(
    Line(points = {{139, 40}, {120.5, 40}, {120.5, 12}, {102, 12}}, color = {0, 0, 127}));
  connect(PRefPu1.y, gFL1.PRefPu) annotation(
    Line(points = {{-139, 40}, {-120.5, 40}, {-120.5, 12}, {-102, 12}}, color = {0, 0, 127}));
  connect(PRefPu2.y, gFL2.PRefPu) annotation(
    Line(points = {{139, -40}, {119.5, -40}, {119.5,  -12}, {102, -12}}, color = {0, 0, 127}));
  connect(URefPu1.y, gFL1.URefPu) annotation(
    Line(points = {{-139, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(URefPu2.y, gFL2.URefPu) annotation(
    Line(points = {{139, 0}, {102, 0}}, color = {0, 0, 127}));

  annotation(
    experiment(StartTime = 0, StopTime = 70, Tolerance = 1e-05, Interval = 0.0005),
    preferredView = "diagram",
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Documentation(info = "<html><head></head><body>
<h4>Two grid-following converters connected through dynamic lines: 7 Hz oscillation</h4>

<p>Two grid-following converters with plant control (<code>DynGFLPlantQCtrl</code>) are connected to a common bus through
dynamic RL lines (<code>DynLineRL</code>). The common bus is connected to an infinite bus through two parallel lines.
With the tuning below, a poorly damped oscillation at about 7 Hz appears after the events. Sweeping the current loop
bandwidth <code>OmegaCC</code> shows a linear relationship between the current loop bandwidth and the frequency of this
oscillation.</p>

<h4>Network</h4>
<pre>  gFL1 ---- dynLine ---- bus ---- dynLine1 ---- gFL2
                              |
                 +------------+-------------+
                 |                          |
             dynLine2               idealSwitch + dynLine3
                 |                          |
                 +------------+-------------+
                              |
                  infiniteBusWithVariations (U = 1.1 pu)
</pre>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Line</th><th>RPu</th><th>LPu</th><th>Between</th></tr>
  <tr><td><code>dynLine</code></td><td>0.00144</td><td>0.0144</td><td>gFL1 and bus</td></tr>
  <tr><td><code>dynLine1</code></td><td>0.00144</td><td>0.0144</td><td>bus and gFL2</td></tr>
  <tr><td><code>dynLine2</code></td><td>0.01</td><td>0.1</td><td>bus and infinite bus</td></tr>
  <tr><td><code>dynLine3</code></td><td>0.0077775</td><td>0.077775</td><td>bus and infinite bus, through <code>idealSwitch</code></td></tr>
</tbody></table>
<p>Impedances in pu on the system base (SnRef = 100 MVA). The lines are dynamic, with <code>omegaPu = 1</code>.</p>

<h4>Converters</h4>
<ul>
  <li>Both converters: <code>SNom = 1000 MVA</code>, <code>tVSC = 2 ms</code>, full voltage feedforward
      (<code>Kfd = Kfq = 1</code>), reactive power priority (<code>PQFlag = false</code>), reactive current boost
      <code>Kqv = 2</code>;</li>
  <li><code>gFL1</code> injects P = 0.503 pu (<code>P0Pu = -5.03</code>, base SnRef, receptor convention), with
      <code>IMaxPu = 20</code>;</li>
  <li><code>gFL2</code> absorbs P = 0.499 pu (<code>P0Pu = 4.989324</code>), with <code>IMaxPu = 2</code>, so most of
      the power flows from one converter to the other through the common bus;</li>
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
  <tr><td>Outer loop (both axes)</td><td><code>OmegaCCOuter = 4.5 rad/s</code></td>
      <td><code>KpOuter = OmegaCCOuter/OmegaLPF = 0.015</code>, <code>KiOuter = OmegaCCOuter = 4.5</code></td></tr>
  <tr><td>PLL</td><td><code>OmegaPLL = 10 rad/s</code>, <code>KsiPLL = 1</code></td>
      <td><code>KpPLL = 2*KsiPLL*OmegaPLL/omegaNom = 0.0637</code>, <code>KiPLL = OmegaPLL^2/omegaNom = 0.318</code></td></tr>
  <tr><td>Plant controller (P and U/Q)</td><td><code>OmegaCCPlant = 1.3 rad/s</code></td>
      <td><code>KpPlant = OmegaCCPlant/OmegaCCOuter = 0.289</code>, <code>KiPlant = OmegaCCPlant = 1.3</code></td></tr>
</tbody></table>
<p>With <code>LgPu = LFilterPu + LTransformerLVPu = 0.125 pu</code> and <code>RgPu = RFilterPu + RTransformerLVPu = 0.004 pu</code>.
The gains are computed separately for each converter (suffix 1 for <code>gFL1</code>, 2 for <code>gFL2</code>).
To study the oscillation frequency, change <code>OmegaCC</code> only. The current loop gains of both converters follow.</p>

<h4>Scenario</h4>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Event</th><th>Block</th><th>Time</th></tr>
  <tr><td>Active power reference steps, +0.1 pu on both converters</td><td><code>PRefPu1</code>, <code>PRefPu2</code></td>
      <td>t = 50 s</td></tr>
  <tr><td>Opening of the parallel line <code>dynLine3</code></td>
      <td><code>idealSwitch</code>, <code>booleanTable</code>, <code>dynLine3.switchOffSignal1</code></td><td>t = 51.5 s</td></tr>
  <tr><td>Voltage reference step, +10 % (gFL1)</td><td><code>URefPu1</code></td><td>t = 480 s (inactive)</td></tr>
  <tr><td>Grid voltage dip</td><td><code>infiniteBusWithVariations</code></td>
      <td>zero duration at t = 15.1 s (inactive)</td></tr>
</tbody></table>
<p>The voltage references start at <code>URef0Pu = U0Pu + LambdaPu*QPcc0Pu</code>, and the active power references start at
<code>PPcc0Pu</code>.</p>

<h4>Notes</h4>
<ul>
  <li>The start values of the lines on the bus side are approximate load-flow values and do not exactly match the converter
      operating points, so the simulation may start with a short transient.</li>
  <li>A similar case with static lines, but a different tuning and operating point, is <code>TwoConvertersStaticLine7Hz</code>.</li>
</ul>
</body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica ");
end TwoConvertersDynamicLine7Hz;
