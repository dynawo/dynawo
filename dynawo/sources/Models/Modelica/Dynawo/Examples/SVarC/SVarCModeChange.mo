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

model SVarCModeChange
  extends Icons.Example;
  extends Dynawo.Examples.SVarC.BaseClasses.BaseSVarCTestCase(sVarCStandard(
    Mode0 = Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode.RUNNING_V));

  // SVarC inputs
  Modelica.Blocks.Sources.Step URef(height = 5, offset = 225, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanPulse selectMode(period = 9, startTime = 0.5, width = 50) annotation(
    Placement(visible = true, transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerStep integerStep(height = -2, offset = 0, startTime = 3) annotation(
    Placement(visible = true, transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerStep integerStep1(height = 2, offset = 0, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant1(k = 3) annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathInteger.Sum manualMode(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(URef.y, sVarCStandard.URef) annotation(
    Line(points = {{-99, 60}, {-80, 60}, {-80, 40}, {-56, 40}}, color = {0, 0, 127}));
  connect(selectMode.y, not1.u) annotation(
    Line(points = {{-139, 20}, {-124, 20}}, color = {255, 0, 255}));
  connect(not1.y, sVarCStandard.selectModeAuto) annotation(
    Line(points = {{-99, 20}, {-56, 20}}, color = {255, 0, 255}));
  connect(integerStep.y, manualMode.u[1]) annotation(
    Line(points = {{-139, -20}, {-120, -20}}, color = {255, 127, 0}));
  connect(integerStep1.y, manualMode.u[2]) annotation(
    Line(points = {{-139, -90}, {-130, -90}, {-130, -20}, {-120, -20}}, color = {255, 127, 0}));
  connect(integerConstant1.y, manualMode.u[3]) annotation(
    Line(points = {{-139, -60}, {-130, -60}, {-130, -20}, {-120, -20}}, color = {255, 127, 0}));
  connect(manualMode.y, sVarCStandard.setModeManual) annotation(
    Line(points = {{-98.5, -20}, {-80, -20}, {-80, 0}, {-60, 0}}, color = {255, 127, 0}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 7, Tolerance = 1e-06, Interval = 0.018),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=BFSBExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>This test case simulates variations of modes.&nbsp;<div><br></div><div>The SVarC is initially running.&nbsp;</div><div>A step on URef from 225 kV to 230 kV is realised at t = 1 s.&nbsp;</div><div>The SVarC is then turned in manual mode from t = 0.5 s to t = 5 s, switched off from t = 3 s to t = 4 s and switched back on from t = 4 s.&nbsp;
</div><div>The user variables enabling to simulate this scenario are selectModeAuto and setMode.</div></body></html>"));
end SVarCModeChange;
