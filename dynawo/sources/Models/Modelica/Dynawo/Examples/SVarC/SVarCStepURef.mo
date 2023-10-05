within Dynawo.Examples.SVarC;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SVarCStepURef

 Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {102, 20}, extent = {{-18, -18}, {18, 18}}, rotation = -90)));
 Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.027654) annotation(
    Placement(visible = true, transformation(origin = {46, 20}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.SVarCStandard sVarCStandard(B0Pu = 0, BMaxPu = 1.0678, BMinPu = -1.0466, BShuntPu = 0, G0Pu = 0, IMaxPu = 1, IMinPu = -1, KCurrentLimiter = 8, Kp = 1.75, Lambda = 0.01, Mode0 = Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode.RUNNING_V, P0Pu = 0, Q0Pu = 0, SNom = 250, Ti = 0.003428, U0Pu = 1, UBlock = 5, UNom = 225, URef0 = 225, URefDown = 220, URefUp = 230, UThresholdDown = 218, UThresholdUp = 240, UUnblockDown = 180, UUnblockUp = 270, i0Pu = Complex(0, 0), s0Pu = Complex(0, 0), tThresholdDown = 0, tThresholdUp = 60, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-28, 20}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URef(height = 5, offset = 225, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-90, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant manualMode(k = 3) annotation(
    Placement(visible = true, transformation(origin = {-90, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant selectMode(k = false) annotation(
    Placement(visible = true, transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  sVarCStandard.injector.switchOffSignal1.value = false;
  sVarCStandard.injector.switchOffSignal2.value = false;
  sVarCStandard.injector.switchOffSignal3.value = false;

  connect(selectMode.y, sVarCStandard.selectModeAuto) annotation(
    Line(points = {{-79, 20}, {-54, 20}}, color = {255, 0, 255}));
  connect(manualMode.y, sVarCStandard.setModeManual) annotation(
    Line(points = {{-79, -14}, {-76, -14}, {-76, 1}, {-54, 1}}, color = {255, 127, 0}));
  connect(URef.y, sVarCStandard.URef) annotation(
    Line(points = {{-78, 56}, {-60, 56}, {-60, 40}, {-54, 40}}, color = {0, 0, 127}));
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{72, 20}, {102, 20}}, color = {0, 0, 255}));
  connect(sVarCStandard.terminal, line.terminal1) annotation(
    Line(points = {{2, 20}, {20, 20}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    uses(Dynawo(version = "1.0.1"), Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.006),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Documentation(info = "<html><head></head><body>This test case simulates a step voltage variation.&nbsp;<div><br></div><div>The SVarC is initially running.&nbsp;</div><div>A step on URef from 225 kV to 230 kV is realised at t = 1 s.&nbsp;</div><div><br></div><div><div>The SVarC starts providing reactive power to follow the voltage reference change.</div><div><br></div><div><br></div><div><br></div><div><br><div><br></div><div><br></div><div><br></div></div></div></body></html>"));
end SVarCStepURef;
