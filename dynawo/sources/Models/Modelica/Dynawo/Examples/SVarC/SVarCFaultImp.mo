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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SVarCFaultImp
  extends Icons.Example;
  extends Dynawo.Examples.SVarC.BaseClasses.BaseSVarCTestCase(sVarCStandard(
    Mode0 = Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode.RUNNING_V));

  // SVarC inputs
  Modelica.Blocks.Sources.Step URef(height = 5, offset = 225, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant selectMode(k = true) annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant manualMode(k = 3) annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Fault
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.02, XPu = 0, tBegin = 1, tEnd = 1.1) annotation(
    Placement(visible = true, transformation(origin = {0, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(URef.y, sVarCStandard.URef) annotation(
    Line(points = {{-99, 60}, {-80, 60}, {-80, 40}, {-56, 40}}, color = {0, 0, 127}));
  connect(selectMode.y, sVarCStandard.selectModeAuto) annotation(
    Line(points = {{-99, 20}, {-56, 20}}, color = {255, 0, 255}));
  connect(manualMode.y, sVarCStandard.setModeManual) annotation(
    Line(points = {{-99, -20}, {-80, -20}, {-80, 0}, {-60, 0}}, color = {255, 127, 0}));
  connect(nodeFault.terminal, sVarCStandard.terminal) annotation(
    Line(points = {{0, 42}, {0, 42}, {0, 20}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.006),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>This test case simulates a three phase fault.&nbsp;<div><br></div><div>The SVarC is initially running.&nbsp;</div><div>An impedent 100 ms three-phase short circuit is simulated from t = 1 s to t = 1.1 s.
</div><div><br></div><div><div>The SVarC provides the maximum available reactive power in order to support the voltage.</div></div><div><br></div><div><br></div></body></html>"));
end SVarCFaultImp;
