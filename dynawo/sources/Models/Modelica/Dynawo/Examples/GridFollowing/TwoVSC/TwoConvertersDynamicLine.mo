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

model TwoConvertersDynamicLine "Two grid-following converters connected through dynamic lines"
  // Bandwidth tuning parameters (only tFilter and the plant controller gains are used, the other gains are hard-coded below)
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
  Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFL1(SNom = 1000, U0Pu = 1.091230, UPhase0 = 0.063246, P0Pu = -4.99, Q0Pu = -0.21, Omega0Pu = 1.0, tVSC = 1e-3, RFilterPu = 0.003, LFilterPu = 0.1, CFilterPu = 1e-5, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 0.001, LTransformerLVPu = 0.025, RTransformerHVPu = 0.001, LTransformerHVPu = 0.025, KFilter = 1, tFilter = tFilter, Kpc = 0.3819, Kic = 3.60, KpdOuter = 0.033, KidOuter = 10, KpqOuter = 0.033, KiqOuter = 10, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 1/300, IMaxPu = 10, PQFlag = true, IqBoostMaxPu = 0.5, IqBoostMinPu = -0.5, KpqPlant = KpPlant1, KiqPlant = KiPlant1, KppPlant = KpPlant1, KipPlant = KiPlant1, LambdaPu = 0.417, KDroop = 15, QMaxPu = 0.3, QMinPu = -0.3, PMaxPu = 2, PMinPu = 0, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, KpPLL = 0.318, KiPLL = 7.95, OmegaMaxPu = 10, OmegaMinPu = 0, DidMax = 10.0, DidMin = -10.0, tSid = 1e-4, tPlant = tPlant, Kfd = 1, Kfq = 1, tBoost = 1e-4, PControlFlag = false, QControlFlag = false) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
  // GFL2
  Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFL2(SNom = 1000, U0Pu = 1.086638, UPhase0 = -0.063421, P0Pu = 4.989324, Q0Pu = -0.21, Omega0Pu = 1.0, tVSC = 1e-3, RFilterPu = 0.003, LFilterPu = 0.1, CFilterPu = 1e-5, omegaNom = 2*Modelica.Constants.pi*50, RTransformerLVPu = 0.001, LTransformerLVPu = 0.025, RTransformerHVPu = 0.001, LTransformerHVPu = 0.025, KFilter = 1, tFilter = tFilter, Kpc = 0.3819, Kic = 3.60, KpdOuter = 0.033, KidOuter = 10, KpqOuter = 0.033, KiqOuter = 10, UBoostHighPu = 1.1, UBoostLowPu = 0.9, Kqv = 1/300, IMaxPu = 10, PQFlag = true, IqBoostMaxPu = 0.5, IqBoostMinPu = -0.5, KpqPlant = KpPlant2, KiqPlant = KiPlant2, KppPlant = KpPlant2, KipPlant = KiPlant2, LambdaPu = 0.417, KDroop = 15, QMaxPu = 0.3, QMinPu = -0.3, PMaxPu = 0, PMinPu = -2, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, KpPLL = 0.318, KiPLL = 7.95, OmegaMaxPu = 10, OmegaMinPu = 0, DidMax = 10.0, DidMin = -10.0, tSid = 1e-4, tPlant = tPlant, Kfd = 1, Kfq = 1, tBoost = 1e-4, PControlFlag = false, QControlFlag = false) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // Network elements (dynamic lines, buses and switch)
  Electrical.Buses.Bus bus annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.100000, UPhase = -0.001082, omega0Pu = 1.0, UEvtPu = 0.5, tUEvtStart = 15.1, tUEvtEnd = 15.1, omegaEvtPu = 1.0, tOmegaEvtStart = 1e6, tOmegaEvtEnd = 1e6) annotation(
    Placement(transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.DynLineRL dynLine(RPu = 0.00144, LPu = 0.0144, U01Pu = 1.01925978, UPhase01 = -11.490041*3.14/180, P01Pu = -5, Q01Pu = 0.21, U02Pu = 1.03733331, UPhase02 = -2.278818*3.14/180, P02Pu = 5.05725313, Q02Pu = 0.60359717) annotation(
    Placement(transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.DynLineRL dynLine1(RPu = 0.00144, LPu = 0.0144, U01Pu = 1.03733331, UPhase01 = -2.278818*3.14/180, P01Pu = -4.94531238, Q01Pu = 0.56713991, U02Pu = 1.04289359, UPhase02 = 6.668423*3.14/180, P02Pu = 5, Q02Pu = 0.21) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.DynLineRL dynLine2(RPu = 0.007, LPu = 0.07, U01Pu = 1.03733331, UPhase01 = -2.278818*3.14/180, P01Pu = -0.11194076, Q01Pu = -1.17073708, U02Pu = 1.1, UPhase02 = -0.04, P02Pu = 0.11901040, Q02Pu = 1.24143346) annotation(
    Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.DynLineRL dynLine3(RPu = 0.00388, LPu = 0.0388, U01Pu = 1.1, UPhase01 = -0.04, P01Pu = 0.11901040, Q01Pu = 1.24143346, U02Pu = 1.03733331, UPhase02 = -2.278818*3.14/180, P02Pu = -0.11194076, Q02Pu = -1.17073708) annotation(
    Placement(transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Switches.IdealSwitch2 idealSwitch annotation(
    Placement(transformation(origin = {-20, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanTable booleanTable(table = {0, 51.5}, startValue = true) annotation(
    Placement(transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu1(k = 1.0) annotation(
    Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu2(k = 1.0) annotation(
    Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step PRefPu1(offset = gFL1.PPcc0Pu, height = 0.1, startTime = 500) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step URefPu1(height = 0.1*URef0Pu1, offset = URef0Pu1, startTime = 480) annotation(
    Placement(transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PRefPu2(height = -0.1, offset = gFL2.PPcc0Pu, startTime = 500) annotation(
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
    Line(points = {{-40, -20}, {-40, -21}, {-30, -21}}, color = {0, 0, 255}));
  connect(idealSwitch.terminal2, dynLine2.terminal1) annotation(
    Line(points = {{-10, -21}, {-10, -20}, {0, -20}}, color = {0, 0, 255}));
  connect(idealSwitch.control, booleanTable.y) annotation(
    Line(points = {{-20, -12}, {13.5, -12}, {13.5, -40}, {19, -40}}, color = {255, 0, 255}));
  connect(omegaRefPu1.y, gFL1.omegaRefPu) annotation(
    Line(points = {{-139, -40}, {-121, -40}, {-121,  -12}, {-102, -12}}, color = {0, 0, 127}));
  connect(omegaRefPu2.y, gFL2.omegaRefPu) annotation(
    Line(points = {{139, 40}, {120.5, 40}, {120.5, 12}, {102, 12}}, color = {0, 0, 127}));
  connect(PRefPu1.y, gFL1.PRefPu) annotation(
    Line(points = {{-139, 40}, {-120.5, 40}, {-120.5, 12}, {-102, 12}}, color = {0, 0, 127}));
  connect(PRefPu2.y, gFL2.PRefPu) annotation(
    Line(points = {{139, -40}, {119.5, -40}, {119.5, -12}, {102, -12}}, color = {0, 0, 127}));
  connect(URefPu1.y, gFL1.URefPu) annotation(
    Line(points = {{-139, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(URefPu2.y, gFL2.URefPu) annotation(
    Line(points = {{139, 0}, {102, 0}}, color = {0, 0, 127}));

  annotation(
    experiment(StartTime = 0, StopTime = 70, Tolerance = 1e-05, Interval = 0.0005),
    preferredView = "diagram",
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Documentation(info = "<html><head></head><body>
<h4>Two grid-following converters connected through dynamic lines</h4>

<p>Two grid-following converters with plant control (<code>DynGFLPlantQCtrl</code>) are connected to a common bus through
dynamic RL lines (<code>DynLineRL</code>). The common bus is connected to an infinite bus through two parallel lines.
The case reproduces a reference two-converter EMT simulation, to compare the average model with the EMT results and to
study small-signal stability.</p>

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
  <tr><td><code>dynLine2</code></td><td>0.007</td><td>0.07</td><td>bus and infinite bus</td></tr>
  <tr><td><code>dynLine3</code></td><td>0.00388</td><td>0.0388</td><td>bus and infinite bus, through <code>idealSwitch</code></td></tr>
</tbody></table>
<p>Impedances in pu on the system base (SnRef = 100 MVA). The lines are dynamic, with <code>omegaPu = 1</code>.</p>

<h4>Converters</h4>
<ul>
  <li>Both converters: <code>SNom = 1000 MVA</code>, <code>tVSC = 1 ms</code>, full voltage feedforward
      (<code>Kfd = Kfq = 1</code>), active power priority (<code>PQFlag = true</code>), reactive current boost
      <code>Kqv = 1/300</code>, <code>IMaxPu = 10</code>;</li>
  <li><code>gFL1</code> injects P = 0.499 pu (<code>P0Pu = -4.99</code>, base SnRef, receptor convention);</li>
  <li><code>gFL2</code> absorbs P = 0.499 pu (<code>P0Pu = 4.989324</code>), so most of the power flows from one
      converter to the other through the common bus;</li>
  <li>both inject Q = 0.021 pu (<code>Q0Pu = -0.21</code>).</li>
</ul>

<h4>Controller tuning</h4>
<p>The current loop, outer loop and PLL gains are set directly in the two converters, to match the EMT reference
(<code>Kpc = 0.3819</code>, <code>Kic = 3.6</code>, <code>Kp = 0.033</code> and <code>Ki = 10</code> on both outer loop axes,
<code>KpPLL = 0.318</code>, <code>KiPLL = 7.95</code>). The bandwidth parameters at the top of the model are only used for
<code>tFilter = 1/OmegaLPF</code> and the plant controller gains (<code>KpPlant = OmegaCCPlant/OmegaCCOuter = 0.2</code>,
<code>KiPlant = OmegaCCPlant = 2</code>).</p>
<p>The current loop, outer loop and PLL gains computed from the bandwidths (<code>KpCC1</code>, <code>KpOuter1</code>,
<code>KpPLL1</code>, ...) are not used. Assign them to the converters to use the bandwidth-based tuning instead, or use the
model <code>DynGFLPlantQCtrlBandWidth</code>.</p>

<h4>Scenario</h4>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tbody><tr><th>Event</th><th>Block</th><th>Time</th></tr>
  <tr><td>Opening of the parallel line <code>dynLine3</code></td>
      <td><code>idealSwitch</code>, <code>booleanTable</code>, <code>dynLine3.switchOffSignal1</code></td><td>t = 51.5 s</td></tr>
  <tr><td>Active power reference steps, +0.1 pu (gFL1) and -0.1 pu (gFL2)</td><td><code>PRefPu1</code>,
      <code>PRefPu2</code></td><td>t = 500 s (inactive)</td></tr>
  <tr><td>Voltage reference step, +10 % (gFL1)</td><td><code>URefPu1</code></td><td>t = 480 s (inactive)</td></tr>
  <tr><td>Grid voltage dip</td><td><code>infiniteBusWithVariations</code></td>
      <td>zero duration at t = 15.1 s (inactive)</td></tr>
</tbody></table>
<p>The voltage references start at <code>URef0Pu = U0Pu + LambdaPu*QPcc0Pu</code>, and the active power references start at
<code>PPcc0Pu</code>. The power reference steps were disabled for the comparison with the EMT simulation. Set their start
times below <code>StopTime</code> to activate them.</p>

<h4>Notes</h4>
<ul>
  <li>The line start values come from the EMT load flow and do not exactly match the converter operating points, so the
      simulation starts with a short transient.</li>
  <li>To reproduce the EMT results, set <code>tVSC = 0</code> and use the line reactances of the EMT case. If the VSC delay
      is kept (<code>tVSC = 1 ms</code>), keep the control unchanged and adjust the line reactance.</li>
</ul>
</body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica ");
end TwoConvertersDynamicLine;
