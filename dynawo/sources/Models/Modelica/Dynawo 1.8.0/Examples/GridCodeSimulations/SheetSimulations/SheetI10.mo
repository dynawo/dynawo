within Dynawo.Examples.GridCodeSimulations.SheetSimulations;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SheetI10
  extends Icons.Example;
  extends Examples.GridCodeSimulations.BaseSheetSimulations.BaseSheetI10(XccPu = 0);
  extends Examples.GridCodeSimulations.BaseUnitModel(Unit(P0Pu = -0.8*SNom/Electrical.SystemBase.SnRef), XccPu = 0);

equation
  connect(bus.terminal, Unit.terminal) annotation(
    Line(points = {{-80, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(inertialGrid1.omegaPu, Unit.omegaRefPu) annotation(
    Line(points = {{-158, 16}, {-140, 16}, {-140, 40}, {50, 40}, {50, -12}, {42, -12}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I10")}),
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"),
    Documentation(info = "<html><head></head><body><h2 data-section-id=\"1kaiu74\" data-start=\"131\" data-end=\"158\"><span role=\"text\">Test Case: Islanding</span></h2>
<h3 data-section-id=\"sbgp86\" data-start=\"160\" data-end=\"180\"><span role=\"text\">1. Objective</span></h3>
<p data-start=\"181\" data-end=\"381\">This test evaluates the behavior of a production unit operating in islanded conditions following a sudden load variation. It verifies frequency stability, voltage stability, and protection robustness.</p>
<hr data-start=\"383\" data-end=\"386\">
<h3 data-section-id=\"18dsud0\" data-start=\"388\" data-end=\"420\"><span role=\"text\">2. Network Configuration</span></h3>
<p data-start=\"422\" data-end=\"479\">The test is performed on an isolated network composed of:</p>
<ul data-start=\"481\" data-end=\"555\">
<li data-section-id=\"3q1dyh\" data-start=\"481\" data-end=\"506\">
One <strong data-start=\"487\" data-end=\"506\">production unit</strong>
</li>
<li data-section-id=\"zoxt4o\" data-start=\"507\" data-end=\"540\">
One <strong data-start=\"513\" data-end=\"540\">synchronous compensator</strong>
</li>
<li data-section-id=\"vpro6i\" data-start=\"541\" data-end=\"555\">
One <strong data-start=\"547\" data-end=\"555\">load</strong>
</li>
</ul>
<hr data-start=\"557\" data-end=\"560\">
<h3 data-section-id=\"m8svw8\" data-start=\"562\" data-end=\"601\"><span role=\"text\">3. Initial Operating Conditions</span></h3>
<h4 data-start=\"603\" data-end=\"631\"><span role=\"text\">3.1 Production Unit</span></h4>
<ul data-start=\"632\" data-end=\"881\">
<li data-section-id=\"1qahhw9\" data-start=\"632\" data-end=\"686\">
Active power at PCC:<br data-start=\"654\" data-end=\"657\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>P</mi><mo>=</mo><mn>0.8</mn><mo>⋅</mo><msub><mi>P</mi><mrow><mi>m</mi><mi>a</mi><mi>x</mi></mrow></msub></mrow></semantics></math></span></span></li>
<li data-section-id=\"1vai7ms\" data-start=\"687\" data-end=\"727\">
Reactive power at PCC:<br data-start=\"711\" data-end=\"714\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>Q</mi><mo>=</mo><mn>0</mn></mrow><annotation encoding=\"application/x-tex\">Q = 0</annotation></semantics></math></span>
</span></li>
<li data-section-id=\"15ooc42\" data-start=\"728\" data-end=\"763\">
Voltage at PCC:<br data-start=\"745\" data-end=\"748\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>U</mi><mo>=</mo><msub><mi>Un</mi></msub></mrow></semantics></math></span></span></li>
</ul>
<hr data-start=\"883\" data-end=\"886\">
<h4 data-start=\"888\" data-end=\"924\"><span role=\"text\">3.2 Synchronous Compensator</span></h4>
<ul data-start=\"925\" data-end=\"1155\">
<li data-section-id=\"c5619j\" data-start=\"925\" data-end=\"1005\">
Model: classical model with internal voltage source behind reactance <span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><msub><mi>X</mi><mi>d</mi></msub></mrow><annotation encoding=\"application/x-tex\">X_d</annotation></semantics></math></span>
</span></li>
<li data-section-id=\"miv2v0\" data-start=\"1006\" data-end=\"1056\">
Rated apparent power:<br data-start=\"1029\" data-end=\"1032\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><msub><mi>S</mi><mi>n</mi></msub><mo>=</mo><msub><mi>S</mi><mrow><mi>n</mi><mo separator=\"true\">,</mo><mi>u</mi><mi>n</mi><mi>i</mi><mi>t</mi></mrow></msub></mrow><annotation encoding=\"application/x-tex\">S_n = S_{n,unit}</annotation></semantics></math></span>
</span></li>
<li data-section-id=\"1fskpyc\" data-start=\"1058\" data-end=\"1134\">
Reactance:<br data-start=\"1070\" data-end=\"1073\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><msub><mi>X</mi><mi>d</mi></msub><mo>=</mo><msub><mi>X</mi><mrow><mi>m</mi><mi>a</mi><mi>x</mi></mrow></msub><mo>=</mo><mn>0.3</mn><mtext> </mtext><mi>p</mi><mi mathvariant=\"normal\">.</mi><mi>u</mi><mi mathvariant=\"normal\">.</mi></mrow><annotation encoding=\"application/x-tex\">X_d = X_{max} = 0.3 \\, p.u.</annotation></semantics></math></span>
</span></li>
<li data-section-id=\"1wpbv1c\" data-start=\"1136\" data-end=\"1155\">
Inertia constant:
</li>
</ul>
<p data-start=\"1157\" data-end=\"1194\"><span class=\"inline-block align-middle\"><span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>H</mi><mo>=</mo><mfrac><mrow><msub><mi>f</mi><mn>0</mn></msub><mo>⋅</mo><mi mathvariant=\"normal\">Δ</mi><mi>P</mi></mrow><mrow><mn>2</mn><mo>⋅</mo><mi>R</mi><mi>O</mi><mi>C</mi><mi>O</mi><mi>F</mi><mo>⋅</mo><msub><mi>S</mi><mi>n</mi></msub></mrow></mfrac></mrow><annotation encoding=\"application/x-tex\">H = \\frac{f_0 \\cdot \\Delta P}{2 \\cdot ROCOF \\cdot S_n}</annotation></semantics></math></span>
</span></span></p>
<p data-start=\"1196\" data-end=\"1202\">Where:</p>
<ul data-start=\"1203\" data-end=\"1288\">
<li data-section-id=\"1ik13p6\" data-start=\"1203\" data-end=\"1225\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><msub><mi>f</mi><mn>0</mn></msub><mo>=</mo><mn>50</mn><mtext> </mtext><mi>H</mi><mi>z</mi></mrow><annotation encoding=\"application/x-tex\">f_0 = 50 \\, Hz</annotation></semantics></math></span>
</span></li>
<li data-section-id=\"we5xyq\" data-start=\"1226\" data-end=\"1262\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi mathvariant=\"normal\">Δ</mi><mi>P</mi><mo>=</mo><mn>0.1</mn><mo>⋅</mo><msub><mi>P</mi><mrow><mi>m</mi><mi>a</mi><mi>x</mi></mrow></msub></mrow></semantics></math></span></span></li>
<li data-section-id=\"18q5rtb\" data-start=\"1263\" data-end=\"1288\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>R</mi><mi>O</mi><mi>C</mi><mi>O</mi><mi>F</mi><mo>=</mo><mn>2</mn><mtext> </mtext><mi>H</mi><mi>z</mi><mi mathvariant=\"normal\">/</mi><mi>s</mi></mrow><annotation encoding=\"application/x-tex\">ROCOF = 2 \\, Hz/s</annotation></semantics></math></span>
</span></li>
</ul>
<p data-start=\"1290\" data-end=\"1318\"><strong data-start=\"1290\" data-end=\"1318\">Alternative formulation:</strong></p>
<p data-start=\"1320\" data-end=\"1357\"><span class=\"inline-block align-middle\"><span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>H</mi><mo>=</mo><mn>1.25</mn><mo>⋅</mo><mfrac><msub><mi>P</mi><mrow><mi>m</mi><mi>a</mi><mi>x</mi></mrow></msub><msub><mi>S</mi><mi>n</mi></msub></mfrac></mrow><annotation encoding=\"application/x-tex\">H = 1.25 \\cdot \\frac{P_{max}}{S_n}</annotation></semantics></math></span>
</span></span></p>
<hr data-start=\"1359\" data-end=\"1362\">
<h4 data-start=\"1364\" data-end=\"1381\"><span role=\"text\">3.3 Load</span></h4>
<ul data-start=\"1382\" data-end=\"1562\">
<li data-section-id=\"1mqwiex\" data-start=\"1382\" data-end=\"1441\">
Active power consumption:<br data-start=\"1409\" data-end=\"1412\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>P</mi><mo>=</mo><mn>0.8</mn><mo>⋅</mo><msub><mi>P</mi><mrow><mi>m</mi><mi>a</mi><mi>x</mi></mrow></msub></mrow></semantics></math></span></span></li>
<li data-section-id=\"132nvi9\" data-start=\"1442\" data-end=\"1475\">
Reactive power:<br data-start=\"1459\" data-end=\"1462\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>Q</mi><mo>=</mo><mn>0</mn></mrow><annotation encoding=\"application/x-tex\">Q = 0</annotation></semantics></math></span>
</span></li>
<li data-section-id=\"w3bqap\" data-start=\"1477\" data-end=\"1562\">
Model:
<ul data-start=\"1488\" data-end=\"1562\">

<li data-section-id=\"ih4x1c\" data-start=\"1488\" data-end=\"1520\">
Constant power load (PQ model)
</li>
<li data-section-id=\"we7tzw\" data-start=\"1523\" data-end=\"1562\">
No dependency on voltage or frequency
</li>
</ul>
</li>
</ul>
<hr data-start=\"1564\" data-end=\"1567\">
<h3 data-section-id=\"1jixth8\" data-start=\"1569\" data-end=\"1603\"><span role=\"text\">4. Disturbance Description</span></h3>
<p data-start=\"1605\" data-end=\"1653\">At <span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi>t</mi><mo>=</mo><msub><mi>t</mi><mn>0</mn></msub></mrow><annotation encoding=\"application/x-tex\">t = t_0</annotation></semantics></math></span><span class=\"katex-html\" aria-hidden=\"true\"><span class=\"base\"><span class=\"mord\"><span class=\"msupsub\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist-s\"></span></span><span class=\"vlist-r\"><span class=\"vlist\"></span></span></span></span></span></span></span></span>, the following step is applied:</p>
<ul data-start=\"1655\" data-end=\"1789\">
<li data-section-id=\"dru1ry\" data-start=\"1655\" data-end=\"1719\">
Active power increase:<br data-start=\"1679\" data-end=\"1682\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi mathvariant=\"normal\">Δ</mi><mi>P</mi><mo>=</mo><mo>+</mo><mn>0.1</mn><mo>⋅</mo><msub><mi>P</mi><mrow><mi>m</mi><mi>a</mi><mi>x</mi></mrow></msub></mrow><annotation encoding=\"application/x-tex\">\\Delta P = +0.1 \\cdot P_{max}</annotation></semantics></math></span>
</span></li>
<li data-section-id=\"1409p6w\" data-start=\"1721\" data-end=\"1789\">
Reactive power variation:<br data-start=\"1748\" data-end=\"1751\">
<span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><semantics><mrow><mi mathvariant=\"normal\">Δ</mi><mi>Q</mi><mo>=</mo><mo>+</mo><mn>0.04</mn><mo>⋅</mo><msub><mi>P</mi><mrow><mi>m</mi><mi>a</mi><mi>x</mi></mrow></msub></mrow><annotation encoding=\"application/x-tex\">\\Delta Q = +0.04 \\cdot P_{max}</annotation></semantics></math></span>
</span></li>
</ul>
<hr data-start=\"1791\" data-end=\"1794\">
<h3 data-section-id=\"p4owjf\" data-start=\"1796\" data-end=\"1847\"><span role=\"text\">5. Expected Behaviour / Compliance Criteria</span></h3>
<p data-start=\"1849\" data-end=\"1920\">The system is considered compliant if the following conditions are met:</p>
<h4 data-start=\"1922\" data-end=\"1945\"><span role=\"text\">5.1 Protection</span></h4>
<ul data-start=\"1946\" data-end=\"2013\">
<li data-section-id=\"ksno1l\" data-start=\"1946\" data-end=\"2013\">
The production unit <strong data-start=\"1968\" data-end=\"1985\">must not trip</strong> due to internal protections
</li>
</ul>
<h4 data-start=\"2015\" data-end=\"2037\"><span role=\"text\">5.2 Stability</span></h4>
<ul data-start=\"2038\" data-end=\"2152\">
<li data-section-id=\"mxrkcr\" data-start=\"2038\" data-end=\"2090\">
The system must reach a <strong data-start=\"2064\" data-end=\"2090\">stable operating point</strong>
</li>
<li data-section-id=\"17hc2a4\" data-start=\"2091\" data-end=\"2152\">
No <strong data-start=\"2096\" data-end=\"2122\">sustained oscillations</strong> in:
<ul data-start=\"2129\" data-end=\"2152\">
<li data-section-id=\"1b77bik\" data-start=\"2129\" data-end=\"2140\">
Frequency
</li>
<li data-section-id=\"kq999m\" data-start=\"2143\" data-end=\"2152\">
Voltage
</li>
</ul>
</li>
</ul>
<h4 data-start=\"2154\" data-end=\"2183\"><span role=\"text\">5.3 Frequency Limits</span></h4>
<ul data-start=\"2184\" data-end=\"2257\">
<li data-section-id=\"fbjn7\" data-start=\"2184\" data-end=\"2257\">
<p data-start=\"2186\" data-end=\"2215\">Frequency must remain within:</p>
<span class=\"katex-display\"><span class=\"katex\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><semantics><mrow><mn>49</mn><mtext> </mtext><mi>H</mi><mi>z</mi><mo>≤</mo><mi>f</mi><mo>≤</mo><mn>51</mn><mtext> </mtext><mi>H</mi><mi>z</mi></mrow></semantics></math></span></span></span></li></ul></body></html>"));
end SheetI10;
