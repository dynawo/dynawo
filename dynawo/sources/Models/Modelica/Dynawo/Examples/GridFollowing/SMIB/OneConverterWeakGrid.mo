within Dynawo.Examples.GridFollowing.SMIB;

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

model OneConverterWeakGrid "GFL converter with plant control on a weak grid"
  final parameter Real U0Pu = 1.03713742957;
  final parameter Real Uphase = 0.203890124;
  final parameter Real URef0Pu = U0Pu - gFLmodelnodyn.LambdaPu*gFLmodelnodyn.Q0Pu*Electrical.SystemBase.SnRef/gFLmodelnodyn.SNom;

  Dynawo.Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFLmodelnodyn(
   // Initial conditions — PCC node
  SNom = 1000,
  U0Pu = U0Pu,
  UPhase0 = Uphase,
  P0Pu = -7,
  Q0Pu = -2,
  Omega0Pu = 1.0,
  // VSC Pade delay
  tVSC = 1e-5,
  // LC filter realistic values
  RFilterPu = 0.00003,
  LFilterPu = 0.01,
  CFilterPu = 1e-5,
  omegaNom = 2*Modelica.Constants.pi*50,
  // LV transformer (filter → LV node)
  RTransformerLVPu = 0.0005,
  LTransformerLVPu = 0.008,
  // HV transformer (LV node → PCC)
  RTransformerHVPu = 0.0002,
  LTransformerHVPu = 0.005,
  // Measurement filter
  KFilter = 1,
  tFilter = 1e-2,
  // Inner current loop
  Kpc = 100.0,
  Kic = 200000.0,
  // Voltage feedforward
  Kfd = 1,
  Kfq = 1,
  // Outer loop
  KpdOuter = 0.1,
  KidOuter = 20.0,
  KpqOuter = 0.01,
  KiqOuter = 20.0,
  PControlFlag = false,
  QControlFlag = false,
  tBoost = 1e-3,
  // Current limiter
  UBoostHighPu = 1.1,
  UBoostLowPu = 0.9,
  Kqv = 2,
  IMaxPu = 1.2,
  PQFlag = false,
  IqBoostMaxPu = 0.5,
  IqBoostMinPu = -0.5,
  // Plant controller
  KpqPlant = 0.1,
  KiqPlant = 1.0,
  KppPlant = 0.8,
  KipPlant = 5.0,
  LambdaPu = 0.417,
  KDroop = 15,
  QMaxPu = 0.5,
  QMinPu = -0.5,
  PMaxPu = 2,
  PMinPu = 0,
  FEMaxPu = 999,
  FEMinPu = -999,
  FDbd1Pu = 0.005,
  FDbd2Pu = 0.1,
  DbdPu = 0.0001,
  // PLL
  KpPLL = 0.32,
  KiPLL = 8,
  OmegaMaxPu = 1.5,
  // tight clamp — prevents runaway
  OmegaMinPu = 0.5,
  // Rate limiters and delays
  DidMax = 10.0,
  DidMin = -10.0,
  tSid = 1e-4,
  tPlant = 1e-3) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.1, offset = 0.7, startTime = 10) annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.03, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step URefPu(offset = URef0Pu, startTime = 20, height = URef0Pu*0.1) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 0.6, omega0Pu = 1, omegaEvtPu = 1.05, UPhase = 0, tUEvtStart = 30, tUEvtEnd = 30.2, tOmegaEvtStart = 100, tOmegaEvtEnd = 105) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

equation
  gFLmodelnodyn.switchOffSignal1 = false;
  gFLmodelnodyn.switchOffSignal2 = false;
  gFLmodelnodyn.switchOffSignal3 = false;
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;

  connect(omegaRef.y, gFLmodelnodyn.omegaRefPu) annotation(
    Line(points = {{-59, -40}, {-40.5, -40}, {-40.5, -12}, {-22, -12}, {-22, -12}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.PRefPu, PRefPu.y) annotation(
    Line(points = {{-22, 12}, {-40.6, 12}, {-40.6, 40}, {-59, 40}}, color = {0, 0, 127}));
  connect(URefPu.y, gFLmodelnodyn.URefPu) annotation(
    Line(points = {{-59, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(infiniteBusWithVariations.terminal, line.terminal2) annotation(
    Line(points = {{100, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(gFLmodelnodyn.terminal, line.terminal1) annotation(
    Line(points = {{20, 0.4}, {40, 0.4}, {40, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 40, Tolerance = 1e-05, Interval = 0.0005),
    Diagram,
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Documentation(info = "<html><head></head><body>
<h4>SMIB test: grid-following converter on a weak grid</h4>

<p>One grid-following converter with plant control (<code>DynGFLPlantQCtrl</code>) is connected to an infinite bus
through a purely inductive line. The parameters were tuned from the time response of <code>PVVoltageSource4Example</code>.
Run with the IDA solver.</p>

<h4>Network</h4>
<pre>
  gFLmodelnodyn (PCC) ---- line: XPu = 0.03 (base SnRef) ---- infiniteBusWithVariations (U = 1 pu, UPhase = 0)
</pre>
<p>On the converter base (SNom = 1000 MVA), the line reactance is 0.3 pu, so the short-circuit ratio at the PCC is
about 3.3 (weak grid).</p>

<h4>Initial operating point (PCC)</h4>
<ul>
  <li><code>P0Pu = -7</code>, <code>Q0Pu = -2</code> (receptor convention, base SnRef): the converter injects
      P = 0.7 pu and Q = 0.2 pu (base SNom);</li>
  <li><code>U0Pu = 1.0371 pu</code>, <code>UPhase0 = 0.2039 rad</code>;</li>
  <li><code>URef0Pu = U0Pu + LambdaPu*QPcc0Pu = 1.1205 pu</code>, so the plant controller starts with no error.</li>
</ul>

<h4>Scenarios</h4>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tr><th>Event</th><th>Block</th><th>Settings</th><th>Time</th></tr>
  <tr><td>Active power reference step, 0.7 pu to 0.8 pu</td><td><code>PRefPu</code></td>
      <td><code>offset = 0.7</code>, <code>height = 0.1</code></td><td>t = 10 s</td></tr>
  <tr><td>Voltage reference step, +10 %</td><td><code>URefPu</code></td>
      <td><code>offset = URef0Pu</code>, <code>height = 0.1*URef0Pu</code></td><td>t = 20 s</td></tr>
  <tr><td>Grid voltage dip, 1 pu to 0.6 pu</td><td><code>infiniteBusWithVariations</code></td>
      <td><code>UEvtPu = 0.6</code></td><td>30 s to 30.2 s</td></tr>
  <tr><td>Grid frequency step, 1 pu to 1.05 pu</td><td><code>infiniteBusWithVariations</code></td>
      <td><code>omegaEvtPu = 1.05</code></td><td>100 s to 105 s (outside the 40 s window, inactive)</td></tr>
</table>
<p>To study one event alone, move the start times of the other events beyond <code>StopTime</code>.</p>
</body></html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica --daeMode");
end OneConverterWeakGrid;
