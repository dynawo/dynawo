within Dynawo.Examples.BESS.WECC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model BESSca "WECC BESS Model with REECc and REGCa on infinite bus"
  extends Modelica.Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.6, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 600.5, tOmegaEvtStart = 600, tUEvtEnd = 150, tUEvtStart = 100) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.BESS.WECC.BESSca BESS(Brkpt = 0.1, DDnPu = 126, DPMaxPu = 99, DPMinPu = -99, DUpPu = 126, Dbd1Pu = -0.05, Dbd2Pu = 0.05, DbdPu = 0, EMaxPu = 0.1, EMinPu = -0.1, FDbd1Pu = -0.00083, FDbd2Pu = 0.00083, FEMaxPu = 99, FEMinPu = -99, FreqFlag = true, IMaxPu = 1.11, Ip0Pu = 0.4986, Iq0Pu = 0.037395, Iqh1Pu = 0.75, Iql1Pu = -0.75, IqrMaxPu = 99, IqrMinPu = -99, Kc = 0, Ki = 0.0001, KiPLL = 20, Kig = 0.0001, Kp = 0.0001, KpPLL = 3, Kpg = 1, Kqi = 1, Kqp = 0.0001, Kqv = 15, Kvi = 0.7, Kvp = 1, Lvpl1 = 1.22, LvplSw = false, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.5, PF0 = 0.9972, PInj0Pu = 0.5, PMaxPu = 1, PMinPu = -0.667, PQFlag = false, PfFlag = false, Q0Pu = 0, QFlag = false, QInj0Pu = 0.0375, QMaxPu = 0.75, QMinPu = -0.75, RPu = 0, RateFlag = false, RefFlag = 1, RrpwrPu = 10, SNom = 100, SOC0 = 0.5, SOCMaxPu = 0.8, SOCMinPu = 0.2, U0Pu = 1.0, UCompFlag = true, UDipPu = 0.9, UFlag = true, UFrzPu = 0, UInj0Pu = 1.00281, UMaxPu = 1.1, UMinPu = 0.9, UPhaseInj0 = 0.0748598, UUpPu = 1.1, VDLIp11 = 1.1, VDLIp12 = 1.1, VDLIp21 = 1.15, VDLIp22 = 1, VDLIq11 = 1.1, VDLIq12 = 1.1, VDLIq21 = 1.15, VDLIq22 = 1, VRef0Pu = 1, XPu = 0.15, Zerox = 0.05, i0Pu = Complex(-0.5, 0), s0Pu = Complex(-0.5, 0), tBattery = 999, tFilterGC = 0.02, tFilterPC = 0.02, tFt = 1e-10, tFv = 0.05, tG = 0.017, tIq = 0.017, tLag = 0.1, tP = 0.05, tPOrd = 0.01, tRv = 0.01, u0Pu = Complex(1, 0), uInj0Pu = Complex(1, 0.075)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = BESS.URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = 0.07485) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PAuxPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {50, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.TimeTable PRefPu(table = [0, 0; 1, 0; 1, 0.5; 10, 0.5; 10, -0.5; 20, -0.5; 20, 1]) annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  BESS.regc.injectorIDQ.switchOffSignal1.value = false;
  BESS.regc.injectorIDQ.switchOffSignal2.value = false;
  BESS.regc.injectorIDQ.switchOffSignal3.value = false;

  connect(line.terminal2, BESS.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, BESS.omegaRefPu) annotation(
    Line(points = {{69, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, BESS.QRefPu) annotation(
    Line(points = {{70, 0}, {44, 0}, {44, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(URefPu.y, BESS.URefPu) annotation(
    Line(points = {{70, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(PFaRef.y, BESS.PFaRef) annotation(
    Line(points = {{70, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(PAuxPu.y, BESS.PAuxPu) annotation(
    Line(points = {{40, -60}, {32, -60}, {32, -22}}, color = {0, 0, 127}));
  connect(PRefPu.y, BESS.PRefPu) annotation(
    Line(points = {{70, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 50, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one BESS model connected to an infinite bus which reference active power is changing. This is a way to observe the behavior of the state of charge of a battery commposed of REEC type C et REGC type A.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
 "),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end BESSca;
