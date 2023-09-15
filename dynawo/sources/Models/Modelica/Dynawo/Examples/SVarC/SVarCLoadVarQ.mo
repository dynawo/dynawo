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

model SVarCLoadVarQ

  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {102, 20}, extent = {{-18, -18}, {18, 18}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.027654) annotation(
    Placement(visible = true, transformation(origin = {46, 20}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.SVarCStandard sVarCStandard(B0Pu = 0, BMaxPu = 1.0678, BMinPu = -1.0466, BShuntPu = 0, G0Pu = 0, IMaxPu = 1, IMinPu = -1, KCurrentLimiter = 8, Kp = 1.75, Lambda = 0.01, Mode0 = Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode.STANDBY, P0Pu = 0, Q0Pu = 0, SNom = 250, Ti = 0.003428, U0Pu = 1, UBlock = 5, UNom = 225, URef0 = 225, URefDown = 220, URefUp = 230, UThresholdDown = 218, UThresholdUp = 240, UUnblockDown = 180, UUnblockUp = 270, i0Pu = Complex(0, 0), s0Pu = Complex(0, 0), tThresholdDown = 0, tThresholdUp = 60, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-28, 20}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URef(height = 0, offset = 225, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-90, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant manualMode(k = 3) annotation(
    Placement(visible = true, transformation(origin = {-90, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant selectMode annotation(
    Placement(visible = true, transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ loadPQ annotation(
    Placement(visible = true, transformation(origin = {0, -22}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0, offset = 0, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefPu(height = 1.5, offset = 0, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  sVarCStandard.injector.switchOffSignal1.value = false;
  sVarCStandard.injector.switchOffSignal2.value = false;
  sVarCStandard.injector.switchOffSignal3.value = false;
  loadPQ.switchOffSignal1.value = false;
  loadPQ.switchOffSignal2.value = false;
  loadPQ.deltaP = 0;
  loadPQ.deltaQ = 0;

  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{72, 20}, {102, 20}}, color = {0, 0, 255}));
  connect(sVarCStandard.terminal, line.terminal1) annotation(
    Line(points = {{0, 20}, {20, 20}}, color = {0, 0, 255}));
  connect(loadPQ.terminal, sVarCStandard.terminal) annotation(
    Line(points = {{0, -20}, {0, 20}}, color = {0, 0, 255}));
  connect(selectMode.y, sVarCStandard.selectModeAuto) annotation(
    Line(points = {{-79, 20}, {-56, 20}}, color = {255, 0, 255}));
  connect(QRefPu.y, loadPQ.QRefPu) annotation(
    Line(points = {{-19, -90}, {12, -90}, {12, -37}}, color = {0, 0, 127}));
  connect(PRefPu.y, loadPQ.PRefPu) annotation(
    Line(points = {{-19, -50}, {-12.9, -50}, {-12.9, -39}}, color = {0, 0, 127}));
  connect(manualMode.y, sVarCStandard.setModeManual) annotation(
    Line(points = {{-79, -14}, {-76, -14}, {-76, 1}, {-56, 1}}, color = {255, 127, 0}));
  connect(URef.y, sVarCStandard.URef) annotation(
    Line(points = {{-78, 56}, {-60, 56}, {-60, 40}, {-56, 40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    uses(Dynawo(version = "1.0.1"), Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.006),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Documentation(info = "<html><head></head><body>This test case simulates a load variation.<div><br></div><div>The SVarC is initially in the standby mode.&nbsp;</div><div>A reactive load variation of Q = 150 Mvar is realised at t = 1 s.&nbsp;</div><div><br></div><div>The SVarC switches to running mode after the load variation and regulates with the reference URefDown.<div><br></div><div><br></div></div></body></html>"));
end SVarCLoadVarQ;
