within Dynawo.Examples.PEIR.Plants.Simplified;

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

model GFLPlant "Grid Following Plant in Neplan test case"
  extends Modelica.Icons.Example;
  extends Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan(infiniteBusWithVariations(UEvtPu = 1, tUEvtStart = 2, tUEvtEnd = 4));

  // Inputs
  Modelica.Blocks.Sources.Constant deltaPmRef(k = 0) annotation(
    Placement(transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step URefStep(offset = gflPlant.URef0Pu, height = 0.1, startTime = 10) annotation(
    Placement(transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.PEIR.Plants.Simplified.GFLPlant gflPlant(SNom = 150, Ki = 10, Kp = 0.5, LambdaPuSNom = 0.21, PMax = 200, PNom = 150, QMaxPu = 0.549333333, QMaxRegPu = 0.4, QMinPu = -0.549333333, QMinRegPu = -0.32, P0Pu = -0.2, Q0Pu = 0.0439939, U0Pu = 1.06437, UPhase0 = 0.00808331, QReg0Pu = 0.0458447, UReg0Pu = 1.06648, VRegFlag = true, DbdPu = 0.04) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  gflPlant.switchOffSignal1 = false;
  gflPlant.switchOffSignal2 = false;
  gflPlant.switchOffSignal3 = false;

  connect(gflPlant.URegPu, transformer.U2Pu);
  connect(gflPlant.QRegPu, transformer.Q2Pu);
  connect(gflPlant.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{-121, -8}, {-126, -8}, {-126, -60}, {-139, -60}}, color = {0, 0, 127}));
  connect(deltaPmRef.y, gflPlant.deltaPmRefPu) annotation(
    Line(points = {{-139, -20}, {-131, -20}, {-131, -4}, {-121, -4}}, color = {0, 0, 127}));
  connect(gflPlant.URefPu, URefStep.y) annotation(
    Line(points = {{-120, 0}, {-130, 0}, {-130, 20}, {-138, 20}}, color = {0, 0, 127}));
  connect(gflPlant.terminal, transformer.terminal1) annotation(
    Line(points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}));

  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {160, 60}})),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica --allowNonStandardModelica=",
  __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", nls = "kinsol", s = "dassl", variableFilter = ".*"),
  Documentation(info = "<html><head></head><body>In this test case inspired by Neplan system, a grid following plant is connected and is regulating at transformer high voltage bus.<br><br>From t= 2s to t=4s, the voltage decreases from 1.0678 pu to 1 pu and then go back to initial value.<div>At t=10s, the voltage reference URef decreases by 0.1pu.</div><div><br></div><div>with deadband = 0.04 and limits [-0.32,0.4] pu in SnRef base at PCC.</div><div><br></div><div><br><br><div><br><div><br><div><br></div></div></div></div></body></html>"));
end GFLPlant;
