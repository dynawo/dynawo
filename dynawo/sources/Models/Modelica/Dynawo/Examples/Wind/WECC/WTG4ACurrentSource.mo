within Dynawo.Examples.Wind.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WTG4ACurrentSource "WECC Wind Type 4A Model (including the plant controller) - WTG4A - on infinite bus"
  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.6, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 600.5, tOmegaEvtStart = 600, tUEvtEnd = 200, tUEvtStart = 100) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Wind.WECC.WTG4ACurrentSource WTG4A(DDn = 20, DPMaxPu = 2, DPMinPu = -2, DUp = 0.001, Dbd1Pu = -0.05, Dbd2Pu = 0.05, DbdPu = 0.01, Dshaft = 1.5, EMaxPu = 0.5, EMinPu = -0.5, FDbd1Pu = 0.004, FDbd2Pu = 1, FEMaxPu = 999, FEMinPu = -999, FreqFlag = true, Hg = 1, Ht = 5, IMaxPu = 1.3, Id0Pu = 0.67611, Iq0Pu = 0.26996, IqFrzPu = 0, Iqh1Pu = 1.1, Iql1Pu = -1.1, IqrMaxPu = 20, IqrMinPu = -20, Kc = 0, Ki = 0.26, KiPLL = 20, Kig = 2.36, Kp = 0.01, KpPLL = 3, Kpg = 0.05, Kqi = 0.7, Kqp = 1, Kqv = 2, Kshaft = 200, Kvi = 0.7, Kvp = 1, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.7, PF0 = 0.92871, PFlag = true, PInj0Pu = 0.7, PMaxPu = 1, PMinPu = 0, PQFlag = false, PfFlag = false, Q0Pu = -0.2, QFlag = true, QInj0Pu = 0.2795, QMaxPu = 0.4, QMinPu = -0.4, RPu = 0, RateFlag = false, RefFlag = true, RrpwrPu = 10, SNom = 100, U0Pu = 1.0, UInj0Pu = 1.03534, UPhaseInj0 = 0.10159, VCompFlag = false, VDLIp11 = 1.1, VDLIp12 = 1.1, VDLIp21 = 1.15, VDLIp22 = 1, VDLIp31 = 1.16, VDLIp32 = 1, VDLIp41 = 1.17, VDLIp42 = 1, VDLIq11 = 1.1, VDLIq12 = 1.1, VDLIq21 = 1.15, VDLIq22 = 1, VDLIq31 = 1.16, VDLIq32 = 1, VDLIq41 = 1.17, VDLIq42 = 1, VDipPu = 0.9, VFlag = true, VFrz = 0, VMaxPu = 1.1, VMinPu = 0.9, VRef0Pu = 0, VRef1Pu = 0, VUpPu = 1.1, XPu = 0.15, i0Pu = Complex(-0.7, 0.2), iInj0Pu = Complex(0.7, -0.2), s0Pu = Complex(-0.7, -0.2), tFilterGC = 0.02, tFilterPC = 0.04, tFt = 1e-10, tFv = 0.1, tG = 0.02, tHoldIpMax = 0.1, tHoldIq = 0, tIq = 0.01, tLag = 0.1, tP = 0.05, tPord = 0.01, tRv = 0.01, u0Pu = Complex(1, 0), uInj0Pu = Complex(1.03, 0.105)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.2) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(WTG4A.PF0)) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step step(height = 0.02, offset = 1, startTime = 2)  annotation(
    Placement(visible = true, transformation(origin = {82, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  WTG4A.injector.switchOffSignal1.value = false;
  WTG4A.injector.switchOffSignal2.value = false;
  WTG4A.injector.switchOffSignal3.value = false;
  connect(line.terminal2, WTG4A.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, WTG4A.omegaRefPu) annotation(
    Line(points = {{69, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, WTG4A.QRefPu) annotation(
    Line(points = {{70, 0}, {44, 0}, {44, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PRefPu.y, WTG4A.PRefPu) annotation(
    Line(points = {{69, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(PFaRef.y, WTG4A.PFaRef) annotation(
    Line(points = {{70, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(step.y, WTG4A.URefPu) annotation(
    Line(points = {{72, 78}, {20, 78}, {20, 22}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one simplified drive train model Wind Turbine park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the behavior of the drive train of a Wind Turbine type 4A park in response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>"),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end WTG4ACurrentSource;
