within Dynawo.Examples.Wind.WECC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4BCurrentSource "WECC Wind Type 4B Model on infinite bus"
  import Modelica;
  import Dynawo;

  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.6, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 2, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Wind.WECC.WT4BCurrentSource WT4B(DPMax = 2, DPMin = -2, Dbd1 = -0.05, Dbd2 = 0.05, HoldIpMax = 0, HoldIq = 0, IMaxPu = 1.3,Id0Pu = 0.67611, Iq0Pu = 0.26996, IqFrzPu = 0, Iqh1Pu = 1.1, Iql1Pu = -1.1, IqrMaxPu = 20, IqrMinPu = -20, KiPLL = 20, KpPLL = 3, Kqi = 0.7, Kqp = 1, Kqv = 2, Kvi = 0.7, Kvp = 1, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, PF0 = 0.92871, PFlag = true, PInj0Pu = 0.7, PMaxPu = 1, PMinPu = 0, PPriority = false, PfFlag = false, QFlag = true, QInj0Pu = 0.2795, QMaxPu = 0.4, QMinPu = -0.4, RPu = 0, RateFlag = false, Rrpwr = 10, SNom = 100, Tiq = 0.01, UInj0Pu = 1.03534, UMaxPu = 1.1, UMinPu = 0.9, UPhaseInj0 = 0.10159, VDLIp11 = 1.1, VDLIp12 = 1.1, VDLIp21 = 1.15, VDLIp22 = 1, VDLIq11 = 1.1, VDLIq12 = 1.1, VDLIq21 = 1.15, VDLIq22 = 1, VFlag = true, VMaxPu = 1.1, VMinPu = 0.9, VRef0Pu = 0, VRef1Pu = 0, XPu = 0.15, i0Pu = Complex(-0.7, 0.2), s0Pu = Complex(-0.7, -0.2), tFilterGC = 0.02, tG = 0.02, tP = 0.05, tPord = 0.01, tRv = 0.01, u0Pu = Complex(1, 0), uInj0Pu = Complex(1.03, 0.105)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PInjRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QInjRefPu(k = 0.2) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  WT4B.injector.switchOffSignal1.value = false;
  WT4B.injector.switchOffSignal2.value = false;
  WT4B.injector.switchOffSignal3.value = false;
  connect(line.terminal2, WT4B.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(PInjRefPu.y, WT4B.PInjRefPu) annotation(
    Line(points = {{70, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(QInjRefPu.y, WT4B.QInjRefPu) annotation(
    Line(points = {{70, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 4A park in response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>"),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end WT4BCurrentSource;
