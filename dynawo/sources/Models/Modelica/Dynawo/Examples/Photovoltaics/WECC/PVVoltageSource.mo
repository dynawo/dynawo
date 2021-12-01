within Dynawo.Examples.Photovoltaics.WECC;

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

model PVVoltageSource "WECC PV Vsource Model on infinite bus"
  import Modelica;
  import Dynawo;

  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.5, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 2, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource PV(Ddn = 20, Dup = 0.001, FreqFlag = true, Id0Pu = 0.67611, IMax = 1.05, Iq0Pu = 0.26996, Iqh1 = 2, Iql1 = -2, Iqrmax = 20, Iqrmin = -20, Kc = 0, Ki = 1.5, KiPLL = 20, Kig = 2.36, Kp = 0.1, KpPLL = 3, Kpg = 0.05, Kqi = 0.5, Kqp = 1, Kqv = 2, Kvi = 1, Kvp = 1, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.7, PF0 = 0.92871, PInj0Pu = 0.7, PMax = 1, PMin = 0, PPriority = false, PfFlag = false, Pmax = 1, Pmin = 0, Q0Pu = -0.2, QFlag = true, QInj0Pu = 0.2795, QMax = 0.4, QMin = -0.4, Qmax = 0.4, Qmin = -0.4, RPu = 0, RateFlag = false, RefFlag = true, SNom = 100, TFltr = 0.04, Tfltr = 0.02, Tft = 1e-10, Tfv = 0.1, Tg = 0.02, Tiq = 0.02, Tlag = 0.1, Tp = 0.04, Tpord = 0.02, Trv = 0.02, U0Pu = 1.0, UInj0Pu = 1.03534, UMaxPu = 1.1, UMinPu = 0.9, UPhase0 = 0.00000144621, UPhaseInj0 = 0.10159, VFlag = true, VcompFlag = false, Vfrz = 0, Vmax = 1.1, Vmin = 0.9, Vref0 = 1, XPu = 0.15, dPmax = 999, dPmin = -999, dbd = 0.01, dbd1 = -0.1, dbd2 = 0.1, eMax = 999, eMin = -999, fdbd1 = 0.004, fdbd2 = 1, feMax = 999, feMin = -999, i0Pu = Complex(-0.7, 0.2), iInj0Pu = Complex(0.7, -0.2), rrpwr = 10, s0Pu = Complex(-0.7, -0.2), sInj0Pu = Complex(0.7, 0.2795), u0Pu = Complex(1, 0), uInj0Pu = Complex(1.03, 0.105)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.2) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  connect(line.terminal2, PV.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(OmegaRefPu.y, PV.OmegaRefPu) annotation(
    Line(points = {{69, 40}, {54, 40}, {54, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, PV.QRefPu) annotation(
    Line(points = {{70, 0}, {44, 0}, {44, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(PRefPu.y, PV.PRefPu) annotation(
    Line(points = {{69, -40}, {54, -40}, {54, -12}, {42, -12}}, color = {0, 0, 127}));
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case consists in one PV park connected to an infinite bus which voltage is reduced to 0.5pu from t=1s to t=2s, and which frequency is increased to 1.01pu from t=6s to t=6.5s. This is a way to observe the PV park's response to a voltage and frequency variation at its terminal.    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
    "),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10"));
end PVVoltageSource;
