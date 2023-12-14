within Dynawo.Examples.Photovoltaics.WECC;

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

model PVCurrentSourceREECd "WECC PV Model on infinite bus"
  extends Modelica.Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.5, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 2, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSourceREECd PV(Brkpt = 0.9, DDnPu = 20, DPMaxPu = 999, DPMinPu = -999, DUpPu = 0.001, Dbd1Pu = -0.1, Dbd2Pu = 0.1, DbdPu = 0.01, EMaxPu = 999, EMinPu = -999, FDbd1Pu = -0.004, FDbd2Pu = 1, FEMaxPu = 999, FEMinPu = -999, FreqFlag = true, IMaxPu = 1.05, Ip0Pu = 0.67611, Iq0Pu = 0.26996, IqFrzPu = 0, Iqh1Pu = 2, Iql1Pu = -2, IqrMaxPu = 20, IqrMinPu = -20, Kc = 0, Ke = 0, Ki = 1.5, KiPLL = 20, Kig = 2.36, Kp = 0.1, KpPLL = 3, Kpg = 0.05, Kqi = 0.5, Kqp = 1, Kqv = 2, Kvi = 1, Kvp = 1, Lvpl1 = 1.22, LvplSw = false, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.7, PF0 = 0.92871, PFlag = true, PInj0Pu = 0.7, PMaxPu = 1, PMinPu = 0, PQFlag = false, PfFlag = false, Q0Pu = -0.2, QFlag = true, QInj0Pu = 0.2795, QMaxPu = 0.4, QMinPu = -0.4, QUMaxPu = 0.4, QUMinPu = -0.4, RPu = 0, RateFlag = false, RcPu = 0, RefFlag = 1, RrpwrPu = 10, SNom = 100, U0Pu = 1.0, UBlkHPu = 1.5, UBlkLPu = 0.1, UCmpFlag = false, UCompFlag = false, UDipPu = 0.9, UFlag = true, UFrzPu = 0, UInj0Pu = 1.03534, UMaxPu = 1.1, UMinPu = 0.9, UPhaseInj0 = 0.10159, UUpPu = 1.1, VDLIp101 = 2, VDLIp102 = 0.5, VDLIp11 = 0, VDLIp12 = 1.05, VDLIp21 = 0.4, VDLIp22 = 1.05, VDLIp31 = 0.8, VDLIp32 = 1.05, VDLIp41 = 0.9, VDLIp42 = 1.05, VDLIp51 = 1, VDLIp52 = 1.05, VDLIp61 = 1.1, VDLIp62 = 1.05, VDLIp71 = 1.2, VDLIp72 = 1.05, VDLIp81 = 1.3, VDLIp82 = 1.05, VDLIp91 = 1.6, VDLIp92 = 0.5, VDLIq101 = 2, VDLIq102 = 0.5, VDLIq11 = 0, VDLIq12 = 1.05, VDLIq21 = 0.4, VDLIq22 = 1.05, VDLIq31 = 0.8, VDLIq32 = 1.05, VDLIq41 = 0.9, VDLIq42 = 1.05, VDLIq51 = 1, VDLIq52 = 1.05, VDLIq61 = 1.1, VDLIq62 = 1.05, VDLIq71 = 1.2, VDLIq72 = 1.05, VDLIq81 = 1.3, VDLIq82 = 1.05, VDLIq91 = 1.6, VDLIq92 = 0.5, VRef0Pu = 1, VRef1Pu = 0, XPu = 0.15, XcPu = 0.15, Zerox = 0.4, i0Pu = Complex(-0.7, 0.2), s0Pu = Complex(-0.7, -0.2), tBlkDelay = 0.04, tFilterGC = 0.02, tFilterPC = 0.04, tFt = 1e-10, tFv = 0.1, tG = 0.02, tHld = 0, tHld2 = 0, tIq = 0.02, tLag = 0.1, tP = 0.04, tPOrd = 0.02, tR1 = 0.02, tRv = 0.02, u0Pu = Complex(1, 0), uInj0Pu = Complex(1.03, 0.105)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.2) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = PV.URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = 0.37988) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PAuxPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {50, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  PV.regc.injectorIDQ.switchOffSignal1.value = false;
  PV.regc.injectorIDQ.switchOffSignal2.value = false;
  PV.regc.injectorIDQ.switchOffSignal3.value = false;

  connect(line.terminal2, PV.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, PV.omegaRefPu) annotation(
    Line(points = {{69, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, PV.QRefPu) annotation(
    Line(points = {{70, 0}, {44, 0}, {44, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PRefPu.y, PV.PRefPu) annotation(
    Line(points = {{69, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(URefPu.y, PV.URefPu) annotation(
    Line(points = {{70, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(PFaRef.y, PV.PFaRef) annotation(
    Line(points = {{70, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(PAuxPu.y, PV.PAuxPu) annotation(
    Line(points = {{40, -60}, {32, -60}, {32, -22}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one PV park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 1 s to t = 2 s, and which frequency is increased to 1.01 pu from t = 6 s to t = 6.5 s. This is a way to observe the PV park's response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
 "),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end PVCurrentSourceREECd;
