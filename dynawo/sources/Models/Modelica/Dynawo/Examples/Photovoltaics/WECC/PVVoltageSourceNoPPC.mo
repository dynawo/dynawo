within Dynawo.Examples.Photovoltaics.WECC;

model PVVoltageSourceNoPPC "WECC Wind Type 4B Model on infinite bus"
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
  extends Modelica.Icons.Example;
  Electrical.Lines.Line line(RPu = 0, XPu = 0.0000020661, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.5, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 6.5, tOmegaEvtStart = 6, tUEvtEnd = 2, tUEvtStart = 1) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(PV.PF0)) annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  // Initialization
  Modelica.Blocks.Sources.Step QRef(height = 0.1, offset = PV.QConv0Pu, startTime = 13) annotation(
    Placement(transformation(origin = {90, -20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Step PRef(height = 0.1, offset = PV.PConv0Pu, startTime = 17) annotation(
    Placement(transformation(origin = {90, 40}, extent = {{10, -10}, {-10, 10}})));
  Electrical.Photovoltaics.WECC.PVVoltageSource1NoPlantControl PV(DPMaxPu = 999, DPMinPu = -999, Dbd1Pu = -0.1, Dbd2Pu = 0.1, IMaxPu = 1.05, Iqh1Pu = 2, Iql1Pu = -2, IqrMaxPu = 20, IqrMinPu = -20, KiPLL = 20, KpPLL = 3, Kqi = 0.5, Kqp = 1, Kqv = 2, Kvi = 1, Kvp = 1, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, PMaxPu = 1, PMinPu = 0, PQFlag = false, PfFlag = false, QFlag = true, QMaxPu = 0.4, QMinPu = -0.4, RSourcePu = 0, RateFlag = false, RrpwrPu = 10, SNom = 100, VDipPu = 0.9, VFlag = true, VMaxPu = 1.1, VMinPu = 0.9, VRef0Pu = 1, VRef1Pu = 0, VUpPu = 1.1, XSourcePu = 0.1, tE = 0.005, tFilterGC = 0.02, tG = 0.2, tIq = 0.02, tP = 0.04, tPord = 0.02, tRv = 0.02, i0Pu(im(fixed = false), re(fixed = false)), uConv0Pu(im(fixed = false), re(fixed = false)), iSource0Pu(im(fixed = false), re(fixed = false)), iConv0Pu(im(fixed = false), re(fixed = false)), uInj0Pu(im(fixed = false), re(fixed = false)), uSource0Pu(im(fixed = false), re(fixed = false)), Id0Pu(fixed = false), Iq0Pu(fixed = false), PConv0Pu(fixed = false), UPhaseConv0(fixed = false), PF0(fixed = false), PInj0Pu(fixed = false), QConv0Pu(fixed = false), QInj0Pu(fixed = false), UInj0Pu(fixed = false), UConv0Pu(fixed = false), UdInj0Pu(fixed = false), UqInj0Pu(fixed = false), UPhase0 = 0, RLvTrPu = 0.015, XLvTrPu = 0.06,
  VDLIp11 = 1.1,
  VDLIp12 = 1.1,
  VDLIp21 = 1.15,
  VDLIp22 = 1,
  VDLIp31 = 1.16,
  VDLIp32 = 1,
  VDLIp41 = 1.17,
  VDLIp42 = 1,
  VDLIq11 = 1.1,
  VDLIq12 = 1.1,
  VDLIq21 = 1.15,
  VDLIq22 = 1,
  VDLIq31 = 1.16,
  VDLIq32 = 1,
  VDLIq41 = 1.17,
  VDLIq42 = 1,
  s0Pu = Complex(-0.7, -0.2),
  u0Pu = Complex(1, 0), tHoldIpMax = 0, tHoldIq = 0, IqFrzPu = 0, PFlag = true) annotation(
    Placement(transformation(origin = {40, -1}, extent = {{24, -12}, {-24, 12}})));
  Electrical.Photovoltaics.WECC.PVVoltageSourceNoPlantControl_INIT pVVoltageSourceNoPlantControl_INIT(ConverterLVControl = PV.ConverterLVControl, P0Pu = PV.s0Pu.re, Q0Pu = PV.s0Pu.im, RLvTrPu = PV.RLvTrPu, SNom = PV.SNom, U0Pu = Modelica.ComplexMath.'abs'(PV.u0Pu), UPhase0 = PV.UPhase0, XLvTrPu = PV.XLvTrPu, RSourcePu = PV.RSourcePu, XSourcePu = PV.XSourcePu) annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}})));
initial algorithm
  PV.i0Pu.re := pVVoltageSourceNoPlantControl_INIT.i0Pu.re;
  PV.i0Pu.im := pVVoltageSourceNoPlantControl_INIT.i0Pu.im;
  PV.PF0 := pVVoltageSourceNoPlantControl_INIT.PF0;
  PV.PInj0Pu := pVVoltageSourceNoPlantControl_INIT.PInj0Pu;
  PV.QInj0Pu := pVVoltageSourceNoPlantControl_INIT.QInj0Pu;
  PV.UInj0Pu := pVVoltageSourceNoPlantControl_INIT.UInj0Pu;
  PV.UdInj0Pu := pVVoltageSourceNoPlantControl_INIT.UdInj0Pu;
  PV.UqInj0Pu := pVVoltageSourceNoPlantControl_INIT.UqInj0Pu;
  PV.uInj0Pu.re := pVVoltageSourceNoPlantControl_INIT.uInj0Pu.re;
  PV.uInj0Pu.im := pVVoltageSourceNoPlantControl_INIT.uInj0Pu.im;
  PV.PConv0Pu := pVVoltageSourceNoPlantControl_INIT.PConv0Pu;
  PV.QConv0Pu := pVVoltageSourceNoPlantControl_INIT.QConv0Pu;
  PV.UPhaseConv0 := pVVoltageSourceNoPlantControl_INIT.UPhaseConv0;
  PV.UConv0Pu := pVVoltageSourceNoPlantControl_INIT.UConv0Pu;
  PV.uConv0Pu.re := pVVoltageSourceNoPlantControl_INIT.uConv0Pu.re;
  PV.uConv0Pu.im := pVVoltageSourceNoPlantControl_INIT.uConv0Pu.im;
  PV.iConv0Pu.re := pVVoltageSourceNoPlantControl_INIT.iConv0Pu.re;
  PV.iConv0Pu.im := pVVoltageSourceNoPlantControl_INIT.iConv0Pu.im;
  PV.Id0Pu := pVVoltageSourceNoPlantControl_INIT.Id0Pu;
  PV.Iq0Pu := pVVoltageSourceNoPlantControl_INIT.Iq0Pu;
  PV.uSource0Pu.re := pVVoltageSourceNoPlantControl_INIT.uSource0Pu.re;
  PV.uSource0Pu.im := pVVoltageSourceNoPlantControl_INIT.uSource0Pu.im;
  PV.iSource0Pu.re := pVVoltageSourceNoPlantControl_INIT.iSource0Pu.re;
  PV.iSource0Pu.im := pVVoltageSourceNoPlantControl_INIT.iSource0Pu.im;
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  PV.injector.switchOffSignal1.value = false;
  PV.injector.switchOffSignal2.value = false;
  PV.injector.switchOffSignal3.value = false;
  connect(line.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-60, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(PRef.y, PV.PConvRefPu) annotation(
    Line(points = {{79, 40}, {69.5, 40}, {69.5, 11}, {62, 11}}, color = {0, 0, 127}));
  connect(QRef.y, PV.QConvRefPu) annotation(
    Line(points = {{80, -20}, {70, -20}, {70, -1}, {62, -1}}, color = {0, 0, 127}));
  connect(PFaRef.y, PV.PFaRef) annotation(
    Line(points = {{80, 80}, {40, 80}, {40, 21}}, color = {0, 0, 127}));
  connect(PV.terminal, line.terminal2) annotation(
    Line(points = {{18, -1}, {-1, -1}, {-1, 0}, {-20, 0}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-05, Interval = 0.001),
    Documentation(info = "<html><head></head><body></body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", maxIntegrationOrder = "2", nls = "kinsol", noHomotopyOnFirstTry = "()", noRestart = "()", noRootFinding = "()", initialStepSize = "0.00001", maxStepSize = "10", variableFilter = ".*"));
end PVVoltageSourceNoPPC;
