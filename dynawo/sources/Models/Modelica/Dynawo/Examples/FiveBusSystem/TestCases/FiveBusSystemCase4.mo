within Dynawo.Examples.FiveBusSystem.TestCases;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model FiveBusSystemCase4 "Test case 4 : solid fault on line 1-3"
  extends Icons.Example;
  extends Dynawo.Examples.FiveBusSystem.BaseClasses.FiveBusSystemOpt1(infiniteBusWithVariations.tUEvtStart = 0, infiniteBusWithVariations.tUEvtEnd = 0, infiniteBusWithVariations.UEvtPu = 1.02);

  Modelica.Blocks.Sources.Constant UsRefPu(k = gen.Efd0Pu / 70 + gen.UStator0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.0001, tBegin = 61, tEnd = 61.12)  annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  line1_3.switchOffSignal1.value = if time < 61.12 then false else true;
  line1_3.switchOffSignal2.value = false;

  connect(UsRefPu.y, voltageRegulatorPssOel.UsRefPu) annotation(
    Line(points = {{2, -50}, {18, -50}, {18, -52}, {38, -52}}, color = {0, 0, 127}));
  connect(nodeFault.terminal, bus_3.terminal) annotation(
    Line(points = {{-80, 20}, {-48, 20}, {-48, 60}, {-40, 60}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 120, Tolerance = 1e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_NLS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    Documentation(info = "<html><head></head><body><div>Test Case 4 :</div><div><div>Solid fault on line 1-3, cleared after 4 cycles (0.08 s) by opening the faulted</div><div>circuit.</div></div></body></html>"));
end FiveBusSystemCase4;
