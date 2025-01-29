within Dynawo.Examples.Photovoltaics.WECC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model PVVoltageSource5 "WECC PV Model on infinite bus"
  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.5, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 16.5, tOmegaEvtStart = 16, tUEvtEnd = 8, tUEvtStart = 4) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSourceAREPCc PV(DDn = 20, DPMaxPu = 999, DPMinPu = -999, DUp = 0.001, Dbd1Pu = -0.1, Dbd2Pu = 0.1, DbdPu = 0.01, EMaxPu = 999, EMinPu = -999, FDbd1Pu = 0.004, FDbd2Pu = 1, FEMaxPu = 999, FEMinPu = -999, FreqFlag = true, IMaxPu = 1.05, Id0Pu(fixed = false), Iq0Pu(fixed = false), Iqh1Pu = 2, Iql1Pu = -2, IqrMaxPu = 20, IqrMinPu = -20, Kc = 0, Ki = 1.5, KiPLL = 20, Kig = 2.36, Kp = 0.1, KpPLL = 3, Kpg = 0.05, Kqi = 0.5, Kqp = 1, Kqv = 2, Kvi = 1, Kvp = 1, Lvplsw = false, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.7, PF0(fixed = false), PInj0Pu(fixed = false), PMaxPu = 1, PMinPu = 0, PQFlag = false, PfFlag = false, Q0Pu = -0.2, QFlag = true, QInj0Pu(fixed = false), QMaxPu = 0.4, QMinPu = -0.4, RPu = 0, RefFlag = 1, RrpwrPu = 10, SNom = 100, U0Pu = 1, UInj0Pu(fixed = false), UPhase0 = 1.44621e-6, UPhaseInj0(fixed = false), VCompFlag = false, VDipPu = 0.9, VFlag = true, VFrz = 0.2, VMaxPu = 1.1, VMinPu = 0.9, VRef0Pu = 1, VRef1Pu = 0, VUpPu = 1.1, XPu = 0.15, brkpt = 0.1, i0Pu(im(fixed = false), re(fixed = false)), iInj0Pu(im(fixed = false), re(fixed = false)), lvpl1 = 1.22, s0Pu(im(fixed = false), re(fixed = false)), tFilterGC = 0.02, tFilterPC = 0.04, tFt = 1e-10, tFv = 0.1, tG = 0.02, tIq = 0.02, tLag = 0.1, tP = 0.04, tPord = 0.02, tRv = 0.02, u0Pu(im(fixed = false), re(fixed = false)), uInj0Pu(im(fixed = false), re(fixed = false)), zerox = 0.05, DfMaxPu = 999, DfMinPu = -999, DPrMax = 999, DPrMin = -999, DQRefMax = 999, DQRefMin = -999, FfwrdFlag = false, PefdFlag = true, PfMax = 0.95, PfMin = -0.95, PiMaxPu = 0.1, PiMinPu = -0.1, PrMaxPu = 999, PrMinPu = -999, QRefMaxPu = 999, QRefMinPu = -999, QVFlag = true, QvrMax = 999, QvrMin = -999, tC = 0.02, tFrq = 0.1, tFrz = 0, UFreqPu = 0.8, URefMaxPu = 1.1, URefMinPu = 0.9, tE = 0.005, RSourcePu = 0, XSourcePu = 0.1, VDLIp11 = 1.1, VDLIp12 = 1.1, VDLIp21 = 1.15, VDLIp22 = 1, VDLIp31 = 1.16, VDLIp32 = 1, VDLIp41 = 1.17, VDLIp42 = 1, VDLIq11 = 1.1, VDLIq12 = 1.1, VDLIq21 = 1.15, VDLIq22 = 1, VDLIq31 = 1.16, VDLIq32 = 1, VDLIq41 = 1.17, VDLIq42 = 1,IqFrzPu = 0, PFlag = true, tHoldIpMax = 0.1, tHoldIq = 0) annotation(
    Placement(transformation(origin = {20, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.2) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = PV.URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(PV.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

  // Initialization
  Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSource_INIT pvCurrentSource_INIT(P0Pu = PV.P0Pu, Q0Pu = PV.Q0Pu, RPu = PV.RPu, SNom = PV.SNom, U0Pu = PV.U0Pu, UPhase0 = PV.UPhase0, XPu = PV.XPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(transformation(origin = {-38, 84}, extent = {{-10, -10}, {10, 10}})));

initial algorithm
  PV.Id0Pu := pvCurrentSource_INIT.Id0Pu;
  PV.Iq0Pu := pvCurrentSource_INIT.Iq0Pu;
  PV.PF0 := pvCurrentSource_INIT.PF0;
  PV.PInj0Pu := pvCurrentSource_INIT.PInj0Pu;
  PV.QInj0Pu := pvCurrentSource_INIT.QInj0Pu;
  PV.UInj0Pu := pvCurrentSource_INIT.UInj0Pu;
  PV.UPhaseInj0 := pvCurrentSource_INIT.UPhaseInj0;
  PV.i0Pu.re := pvCurrentSource_INIT.i0Pu.re;
  PV.i0Pu.im := pvCurrentSource_INIT.i0Pu.im;
  PV.iInj0Pu.re := pvCurrentSource_INIT.iInj0Pu.re;
  PV.iInj0Pu.im := pvCurrentSource_INIT.iInj0Pu.im;
  PV.s0Pu.re := pvCurrentSource_INIT.s0Pu.re;
  PV.s0Pu.im := pvCurrentSource_INIT.s0Pu.im;
  PV.u0Pu.re := pvCurrentSource_INIT.u0Pu.re;
  PV.u0Pu.im := pvCurrentSource_INIT.u0Pu.im;
  PV.uInj0Pu.re := pvCurrentSource_INIT.uInj0Pu.re;
  PV.uInj0Pu.im := pvCurrentSource_INIT.uInj0Pu.im;

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  PV.injector.switchOffSignal1.value = false;
  PV.injector.switchOffSignal2.value = false;
  PV.injector.switchOffSignal3.value = false;
  connect(line.terminal2, PV.terminal) annotation(
    Line(points = {{-20, 0}, {-10, 0}, {-10, 2}, {0, 2}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, PV.omegaRefPu) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, 14}, {42, 14}}, color = {0, 0, 127}));
  connect(QRefPu.y, PV.QRefPu) annotation(
    Line(points = {{79, 0}, {60.5, 0}, {60.5, 2}, {42, 2}}, color = {0, 0, 127}));
  connect(PRefPu.y, PV.PRefPu) annotation(
    Line(points = {{79, -40}, {60, -40}, {60, -10}, {42, -10}}, color = {0, 0, 127}));
  connect(URefPu.y, PV.URefPu) annotation(
    Line(points = {{79, 80}, {79, 81}, {20, 81}, {20, 24}}, color = {0, 0, 127}));
  connect(PFaRef.y, PV.PFaRef) annotation(
    Line(points = {{79, -80}, {79, -79}, {20, -79}, {20, -20}}, color = {0, 0, 127}));
  connect(const.y, PV.PAuxPu) annotation(
    Line(points = {{-26, 84}, {10, 84}, {10, 24}}, color = {0, 0, 127}));
  connect(const.y, PV.UAuxPu) annotation(
    Line(points = {{-26, 84}, {34, 84}, {34, 24}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info ="<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one PV park connected to an infinite bus which voltage is reduced to 0.5 pu from t = 4 s to t = 8 s, and which frequency is increased to 1.01 pu from t = 16 s to t = 16.5 s. This is a way to observe the PV park's response to a voltage and frequency variation at its terminal.
     <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/PPuSnRef_PVVoltageSource5.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/QPuSnRef_PVVoltageSource5.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/Photovoltaics/WECC/Resources/UPu_PVVoltageSource5.png\">
  </figure>
        </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
 "),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end PVVoltageSource5;
