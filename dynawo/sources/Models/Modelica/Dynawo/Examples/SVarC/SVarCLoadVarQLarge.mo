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

model SVarCLoadVarQLarge
  extends Icons.Example;
  extends Dynawo.Examples.SVarC.BaseClasses.BaseSVarCTestCase(sVarCStandard(
    Mode0 = Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode.STANDBY,
    URefDown = 225));

  // SVarC inputs
  Modelica.Blocks.Sources.Constant URef(k = 225) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant selectMode(k = true) annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant manualMode(k = 3) annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Load
  Dynawo.Electrical.Loads.LoadPQ loadPQ annotation(
    Placement(visible = true, transformation(origin = {0, -22}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefPu(height = 3, offset = 0, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  loadPQ.switchOffSignal1.value = false;
  loadPQ.switchOffSignal2.value = false;
  loadPQ.deltaP = 0;
  loadPQ.deltaQ = 0;

  connect(URef.y, sVarCStandard.URef) annotation(
    Line(points = {{-99, 60}, {-80, 60}, {-80, 40}, {-56, 40}}, color = {0, 0, 127}));
  connect(selectMode.y, sVarCStandard.selectModeAuto) annotation(
    Line(points = {{-99, 20}, {-55.8, 20}}, color = {255, 0, 255}));
  connect(manualMode.y, sVarCStandard.setModeManual) annotation(
    Line(points = {{-99, -20}, {-80, -20}, {-80, 0}, {-60, 0}}, color = {255, 127, 0}));
  connect(PRefPu.y, loadPQ.PRefPu) annotation(
    Line(points = {{-39, -80}, {-12, -80}, {-12, -37}}, color = {0, 0, 127}));
  connect(QRefPu.y, loadPQ.QRefPu) annotation(
    Line(points = {{39, -80}, {12, -80}, {12, -37}}, color = {0, 0, 127}));
  connect(loadPQ.terminal, sVarCStandard.terminal) annotation(
    Line(points = {{0, -20}, {0, -20}, {0, 20}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.006),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>This test case simulates a load variation.&nbsp;<div><br></div><div>The SVarC is initially in the standby mode.&nbsp;</div><div>A large reactive load variation of Q = 300 Mvar is realised at t = 1 s.&nbsp;</div><div><br></div><div>The SVarC switches to running mode after the load variation and regulates with the reference URefDown.&nbsp;</div><div>The provided current reaches its limitation and the current limiter is activated in order to bring the current back to an acceptable value.<div><br></div></div></body></html>"));
end SVarCLoadVarQLarge;
