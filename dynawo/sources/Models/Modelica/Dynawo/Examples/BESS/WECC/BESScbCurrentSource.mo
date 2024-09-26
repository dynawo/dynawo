within Dynawo.Examples.BESS.WECC;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BESScbCurrentSource "WECC BESS with REEC-C and REGC-B with a plant controller REPC-A on infinite bus"
  extends Icons.Example;

  Dynawo.Electrical.BESS.WECC.BESScbCurrentSource BESScb(DDn = 126,DPMaxPu = 999, DPMinPu = -999, DUp = 126, Dbd1Pu = -0.05, Dbd2Pu = 0.05,DbdPu = 0, EMaxPu = 0.1, EMinPu = -0.1, FDbd1Pu = 0.00083, FDbd2Pu = 0.00083, FEMaxPu = 999, FEMinPu = -999, FreqFlag = true, IMaxPu = 1.11, Id0Pu = 0.5, Iq0Pu = 1.5e-12, Iqh1Pu = 0.75, Iql1Pu = -0.75, IqrMaxPu = 999, IqrMinPu = -999, Kc = 0, Ki = 1e-6, KiPLL = 20, Kig = 1e-6, Kp = 1e-6, KpPLL = 3, Kpg = 1, Kqi = 1, Kqp = 1e-6, Kqv = 15, Kvi = 0.1, Kvp = 1e-6, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.03, PF0 = 1, PInj0Pu = 0.5, PMaxPu = 1, PMinPu = -0.667, PQFlag = false, PfFlag = false, Q0Pu = 0, QFlag = false, QInj0Pu = 1.5e-12, QMaxPu = 0.75, QMinPu = -0.75, RPu = 0, RateFlag = false, RefFlag = false, RrpwrPu = 10, SNom = 6, SOC0Pu = 0.5, SOCMaxPu = 0.8, SOCMinPu = 0.2, U0Pu = 1, UInj0Pu = 1, UPhaseInj0 = 0.00000144621, VCompFlag = true, VDLIp11 = 0.2, VDLIp12 = 1.11, VDLIp21 = 0.5, VDLIp22 = 1.11, VDLIp31 = 0.75, VDLIp32 = 1.11, VDLIp41 = 1, VDLIp42 = 1.11, VDLIq11 = 0, VDLIq12 = 0.75, VDLIq21 = 0.2, VDLIq22 = 0.75, VDLIq31 = 0.5, VDLIq32 = 0.75, VDLIq41 = 1, VDLIq42 = 0.75, VDipPu = -99, VFlag = true, VFrz = 0, VMaxPu = 1.1, VMinPu = 0.9, VRef0Pu = 1, VUpPu = 99, XPu = 1e-10, i0Pu = Complex(-0.03, -4.33863e-8), iInj0Pu = Complex(0.5, 7.23105e-7), s0Pu = Complex(-0.03, 0), tBattery = 999, tFilterGC = 0.02, tFilterPC = 0.02, tFt = 1e-10, tFv = 0.05, tG = 0.017, tIq = 0.017, tLag = 0.1, tP = 0.05, tPord = 0.017, tRv = 0.01, u0Pu = Complex(1, 0.00000144621), uInj0Pu = Complex(1, 0.00000144621)) annotation(
    Placement(visible = true, transformation(origin = {20, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.5) annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(BESScb.PF0)) annotation(
    Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0000020661) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.55, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 1.5, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant PAuxPu(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  BESScb.injector.switchOffSignal1.value = false;
  BESScb.injector.switchOffSignal2.value = false;
  BESScb.injector.switchOffSignal3.value = false;

  connect(URefPu.y, BESScb.URefPu) annotation(
    Line(points = {{70, 80}, {20, 80}, {20, 22}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, BESScb.omegaRefPu) annotation(
    Line(points = {{70, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, BESScb.QRefPu) annotation(
    Line(points = {{70, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PRefPu.y, BESScb.PRefPu) annotation(
    Line(points = {{70, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));
  connect(PFaRef.y, BESScb.PFaRef) annotation(
    Line(points = {{70, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(line.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-60, 0}, {-82, 0}}, color = {0, 0, 255}));
  connect(PAuxPu.y, BESScb.PAuxPu) annotation(
    Line(points = {{-38, -80}, {12, -80}, {12, -22}}, color = {0, 0, 127}));
  connect(line.terminal2, BESScb.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-05, Interval = 0.001),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"),
  Documentation(info = "<html><head></head><body>
  <figure>This example and the data are inspired by the article [P. <span style=\"text-decoration: underline;\">Pourbeik</span> and J. K. <span style=\"text-decoration: underline;\">Petter</span>, <span style=\"text-decoration: underline;\">“Modeling</span> and validation <span style=\"text-decoration: underline;\">of</span> <span style=\"text-decoration: underline;\">battery</span> <span style=\"text-decoration: underline;\">energy</span> <span style=\"text-decoration: underline;\">storage</span> <span style=\"text-decoration: underline;\">systems&nbsp;</span><span style=\"text-decoration: underline;\">using</span> simple <span style=\"text-decoration: underline;\">generic</span> <span style=\"text-decoration: underline;\">models</span> for <span style=\"text-decoration: underline;\">power</span> system <span style=\"text-decoration: underline;\">stability</span> <span style=\"text-decoration: underline;\">studies”</span>, <span style=\"text-decoration: underline;\">CIGRE</span> Science and Engineering, <span style=\"text-decoration: underline;\">October</span> 2017, pp. 63-72.]</figure><figure>At initial time, the active power demanded by the battery is 0.5 pu (base SNom = 6MVA) and the reactive power is 0 pu (base SNom = 6MVA).</figure><figure>The BESS is able to discharge since the initial state of charge SOC0Pu = 0.5 is between the accepted range [SOCMinPu = 0.2 , SOCMaxPu = 0.8]. Since the simulation is only for 3 s, and the discharge time is considered much longer, the state of charge SOCPu is considered constant all along the simulation time.</figure><figure>At t = 1 s, a fault at the infinite bus is simulated and it can be seen that the BESS starts injecting reactive power until the fault is cleared at t = 1.5 s.</figure><figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/PInjPuSn.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/QInjPuSn.png\">
  </figure>
  <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/BESS/WECC/Resources/UPu.png\">
  </figure>
</body></html>"));
end BESScbCurrentSource;
