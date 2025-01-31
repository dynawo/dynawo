within Dynawo.Examples.FiveBus;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model FiveBusSystemOperatingPoint1
  // Base calculation
  final parameter Modelica.SIunits.Impedance ZBASE225 = 225.0 ^ 2 / Dynawo.Electrical.SystemBase.SnRef;

  // Grid
  //Initial parameters
  parameter Dynawo.Types.PerUnit RPu = 0.;
  parameter Dynawo.Types.PerUnit XPu = 1 / (6000 / 100);
  //Dynawo.Electrical.Buses.InfiniteBusWithImpedance_INIT grid_INIT(RPu = RPu, XPu = XPu, P0Pu = -2.95, Q0Pu = 0.39, U0Pu = 1.02, UPhase0 = 0.);
  //Dynawo.Electrical.Buses.InfiniteBusWithImpedance grid(RPu = RPu, XPu = XPu, UPhaseBus0(fixed = false), UBus0Pu(fixed = false), iTerminal0Pu(re(fixed = false), im(fixed = false)), uTerminal0Pu(re(fixed = false), im(fixed = false))) annotation(
  //Placement(transformation(origin = {-102, 44}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
  Dynawo.Electrical.Buses.InfiniteBus grid(UPu = 1.02, UPhase = 0, UNom = 225) annotation(
    Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));

  // Buses
  Dynawo.Electrical.Buses.Bus bus_1(UNom = 225) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_4(UNom = 225) annotation(
    Placement(visible = true, transformation(origin = {96, 40}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_3(UNom = 225) annotation(
    Placement(visible = true, transformation(origin = {4, 40}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_2(UNom = 20) annotation(
    Placement(visible = true, transformation(origin = {4, -44}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_5(UNom = 15) annotation(
    Placement(visible = true, transformation(origin = {120, 4}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

  // Lines
  Dynawo.Electrical.Lines.Line line1_3(BPu = 0.000195 * ZBASE225, GPu = 0. * ZBASE225, RPu = 4.16 / ZBASE225, XPu = 41.6 / ZBASE225) annotation(
    Placement(visible = true, transformation(origin = {-30, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1_3b(BPu = 0.000195 * ZBASE225, GPu = 0. * ZBASE225, RPu = 4.16 / ZBASE225, XPu = 41.6 / ZBASE225) annotation(
    Placement(visible = true, transformation(origin = {-30, 20}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3_4(BPu = 3e-05 * ZBASE225, GPu = 0. * ZBASE225, RPu = 0.64 / ZBASE225, XPu = 6.4 / ZBASE225) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3_4b(BPu = 3e-05 * ZBASE225, GPu = 0 * ZBASE225, RPu = 0.64 / ZBASE225, XPu = 6.4 / ZBASE225) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

  // Tap Changer Transformer
  Dynawo.Electrical.Transformers.TransformerVariableTap tfo(B = 0, G = 0, NbTap = 33, P10Pu = 1.52, Q10Pu = 0.5, R = 0, SNom = 250, Tap0 = 15, U10Pu = 1.0154, U20Pu = 1.0038, X = 15, i10Pu(re(fixed = false), im(fixed = false)), i20Pu(re(fixed = false), im(fixed = false)), rTfo0Pu = 1.01, rTfoMaxPu = 1.2, rTfoMinPu = 0.88, u10Pu(re(fixed = false), im(fixed = false)), u20Pu(re(fixed = false), im(fixed = false)))  annotation(
  Placement(visible = true, transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTapPQ_INIT tfo_INIT(R = 0, X = 15,G = 0, B = 0, P10Pu = 1.52, Q10Pu = 0.5, U10Pu = 1.0154, U1Phase0 = 0.12042771838, NbTap = 33, SNom = 250, Uc20Pu = 1.0038, rTfoMaxPu = 1.2, rTfoMinPu = 0.88);

  Dynawo.Electrical.Controls.Transformers.TapChanger tap_changer(regulating0 = true, t1st = 25., tNext = 10., tapMax = 32, tapMin = 0, UDeadBand = 0.017, UTarget = 1.0038, U0 = 1.0038, tap0 = 15, state0 = Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.State.Standard, increaseTapToIncreaseValue = true);

  // Load
  // init values:
  parameter Dynawo.Types.ActivePowerPu P0PuLoad1 = 1.5;
  parameter Dynawo.Types.ReactivePowerPu Q0PuLoad1 = 0.3;
  parameter Dynawo.Types.VoltageModulePu U0PuLoad1 = 1.0038;
  parameter Dynawo.Types.Angle UPhase0Load1 = 0.03141592653;
  final parameter Dynawo.Types.ComplexApparentPowerPu s0PuLoad1 = Complex(P0PuLoad1, Q0PuLoad1);
  parameter Real ActiveMotorShare[2] = {0.2, 0.2};
  parameter Dynawo.Types.PerUnit RsPu[2] = {0.031, 0.013};
  parameter Dynawo.Types.PerUnit RrPu[2] = {0.018, 0.009};
  parameter Dynawo.Types.PerUnit XsPu[2] = {0.1, 0.067};
  parameter Dynawo.Types.PerUnit XrPu[2] = {0.18, 0.17};
  parameter Dynawo.Types.PerUnit XmPu[2] = {3.2, 3.8};
  parameter Real H[2] = {0.7, 1.5};
  parameter Real torqueExponent[2] = {2., 2.};
  parameter Real Alpha = 2;
  parameter Real Beta = 2;

  Dynawo.Electrical.Loads.LoadAlphaBetaTwoMotorSimplified_INIT load_INIT(ActiveMotorShare = ActiveMotorShare, RsPu = RsPu, RrPu = RrPu, XsPu = XsPu, XrPu = XrPu, XmPu = XmPu, P0Pu = P0PuLoad1, Q0Pu = Q0PuLoad1, U0Pu = U0PuLoad1, UPhase0 = UPhase0Load1);
  Dynawo.Electrical.Loads.LoadAlphaBetaTwoMotorSimplified load(Alpha = Alpha, Beta = Beta, H = H, torqueExponent = torqueExponent, ActiveMotorShare = ActiveMotorShare, RsPu = RsPu, RrPu = RrPu, XsPu = XsPu, XrPu = XrPu, XmPu = XmPu, is0Pu(each re(fixed = false), each im(fixed = false)), im0Pu(each re(fixed = false), each im(fixed = false)), s0(each fixed = false), ir0Pu(each re(fixed = false), each im(fixed = false)), PLoad0Pu(fixed = false), QLoad0Pu(fixed = false), ce0Pu(each fixed = false), omegaR0Pu(each fixed = false), motori0Pu(each re(fixed = false), each im(fixed = false)), motors0Pu(each re(fixed = false), each im(fixed = false)), u0Pu(re(fixed = false), im(fixed = false)), s0Pu(re(fixed = false), im(fixed = false)), i0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {4, -74}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));

  // Generator transformer
  Dynawo.Electrical.Transformers.TransformerFixedRatio generatorTransformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 100 / 500, rTfoPu = 1 /1.03) annotation(
    Placement(visible = true, transformation(origin = {120, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Generator
  Dynawo.Examples.BaseClasses.InitializedGeneratorSynchronousFourWindings gen(DPu = 0, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad, H = 4, P0Pu = -4.5, PNomAlt = 460, PNomTurb = 460, Q0Pu = -0.68, RTfPu = 0, RaPu = 0, SNom = 500, SnTfo = 500, Tpd0 = 7, Tppd0 = 0.05, Tppq0 = 0.05, Tpq0 = 1.5, U0Pu = 1, UBaseHV = 225, UBaseLV = 15, UNom = 15, UNomHV = 231.75, UNomLV = 15, UPhase0 = 0.28448866807, XTfPu = 0, XdPu = 2.2, XlPu = 0.15, XpdPu = 0.3, XppdPu = 0.2, XppqPu = 0.2, XpqPu = 0.4, XqPu = 2, md = 0.1, mq = 0.1, nd = 6.0257, nq = 6.0257)  annotation(
    Placement(visible = true, transformation(origin = {120, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // OmegaRef
Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);

  // Governor
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.GovSteam govSteam(FHp = 0.4, FMp = 0.3, PNom = 460, Pm0Pu = gen.Pm0Pu, Sigma = 0.04, ZMaxPu = 1, ZMinPu = 0, dZMaxPu = 0.05, dZMinPu = -0.05, ivo = 1, tHp = 0.3, tLp = 0.3, tMeas = 0.1, tR = 5, tSm = 0.4)  annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-22, -16}, {22, 16}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant PRef(k = gen.Pm0Pu)  annotation(
    Placement(visible = true, transformation(origin = {46, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Voltage Regulator
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VoltageRegulatorPssOel voltageRegulatorPssOel(C = 0.06, Efd0Pu = gen.Efd0Pu, EfdMaxPu = 5, EfdMinPu = 0, G = 70, If0Pu = gen.If0Pu, KOel = 2, KPss = 50, L1 = -1.1, L2 = 0.1, L3 = 0.2, Us0Pu = gen.UStator0Pu, ifLim1 = 2.9, ifLim2 = 1, t1 = 0.323, t2 = 0.0138, t3 = 0.323, t4 = 0.0138, tA = 1, tB = 1, tE = 0.4, tOel = 8, tOmega = 5)  annotation(
    Placement(visible = true, transformation(origin = {104, -73}, extent = {{-26, -13}, {26, 13}}, rotation = 0)));

  // Plot
  Dynawo.Types.VoltageModulePu uBus1;
  Dynawo.Types.VoltageModulePu uBus2;
  Dynawo.Types.VoltageModulePu uBus3;
  Dynawo.Types.VoltageModulePu uBus4;
  Dynawo.Types.VoltageModulePu uBus5;
  Real phaseBus1;
  Real phaseBus2;
  Real phaseBus3;
  Real phaseBus4;
  Real phaseBus5;
  Dynawo.Types.ActivePower PBus13;
  Dynawo.Types.ActivePower PBus31;
  Dynawo.Types.ActivePower PBus43;
  Dynawo.Types.ActivePower PBusLoad;
  Dynawo.Types.ActivePower PBusGen;
  Dynawo.Types.ReactivePower QBus13;
  Dynawo.Types.ReactivePower QBus31;
  Dynawo.Types.ReactivePower QBus43;
  Dynawo.Types.ReactivePower QBusLoad;
  Dynawo.Types.ReactivePower QBusGen;
  Modelica.Blocks.Sources.Constant UsRefPu(k = voltageRegulatorPssOel.UsRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {36, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial algorithm
//grid.iTerminal0Pu.re := grid_INIT.iTerminal0Pu.re;
//grid.iTerminal0Pu.im := grid_INIT.iTerminal0Pu.im;
//grid.uTerminal0Pu.re := grid_INIT.uTerminal0Pu.re;
//grid.uTerminal0Pu.im := grid_INIT.uTerminal0Pu.im;
//grid.UBus0Pu := grid_INIT.UBus0Pu;
//grid.UPhaseBus0 := grid_INIT.UPhaseBus0;
  load.ir0Pu[1].re := load_INIT.ir0Pu[1].re;
  load.ir0Pu[2].re := load_INIT.ir0Pu[2].re;
  load.ir0Pu[1].im := load_INIT.ir0Pu[1].im;
  load.ir0Pu[2].im := load_INIT.ir0Pu[2].im;
  load.is0Pu[1].re := load_INIT.is0Pu[1].re;
  load.is0Pu[2].re := load_INIT.is0Pu[2].re;
  load.is0Pu[1].im := load_INIT.is0Pu[1].im;
  load.is0Pu[2].im := load_INIT.is0Pu[2].im;
  load.im0Pu[1].re := load_INIT.im0Pu[1].re;
  load.im0Pu[2].re := load_INIT.im0Pu[2].re;
  load.im0Pu[1].im := load_INIT.im0Pu[1].im;
  load.im0Pu[2].im := load_INIT.im0Pu[2].im;
  load.s0 := load_INIT.s0;
  load.ce0Pu := load_INIT.ce0Pu;
  load.QLoad0Pu := load_INIT.QLoad0Pu;
  load.PLoad0Pu := load_INIT.PLoad0Pu;
  load.omegaR0Pu := load_INIT.omegaR0Pu;
  load.motori0Pu[1].re := load_INIT.motori0Pu[1].re;
  load.motori0Pu[1].im := load_INIT.motori0Pu[1].im;
  load.motori0Pu[2].re := load_INIT.motori0Pu[2].re;
  load.motori0Pu[2].im := load_INIT.motori0Pu[2].im;
  load.motors0Pu[1].re := load_INIT.motors0Pu[1].re;
  load.motors0Pu[1].im := load_INIT.motors0Pu[1].im;
  load.motors0Pu[2].re := load_INIT.motors0Pu[2].re;
  load.motors0Pu[2].im := load_INIT.motors0Pu[2].im;
  load.i0Pu.re := load_INIT.i0Pu.re;
  load.i0Pu.im := load_INIT.i0Pu.im;
  load.u0Pu.re := load_INIT.u0Pu.re;
  load.u0Pu.im := load_INIT.u0Pu.im;
  load.s0Pu.re := load_INIT.s0Pu.re;
  load.s0Pu.im := load_INIT.s0Pu.im;
  tfo.i10Pu.re := tfo_INIT.i10Pu.re;
  tfo.i10Pu.im := tfo_INIT.i10Pu.im;
  tfo.i20Pu.re := tfo_INIT.i20Pu.re;
  tfo.i20Pu.im := tfo_INIT.i20Pu.im;
  tfo.u10Pu.re := tfo_INIT.u10Pu.re;
  tfo.u10Pu.im := tfo_INIT.u10Pu.im;
  tfo.u20Pu.re := tfo_INIT.u20Pu.re;
  tfo.u20Pu.im := tfo_INIT.u20Pu.im;

equation
  // Line
  line1_3.switchOffSignal1.value = false;
  line1_3.switchOffSignal2.value = false;
  line1_3b.switchOffSignal1.value = false;
  line1_3b.switchOffSignal2.value = false;
  line3_4.switchOffSignal1.value = false;
  line3_4.switchOffSignal2.value = false;
  line3_4b.switchOffSignal1.value = false;
  line3_4b.switchOffSignal2.value = false;

  // Tap Changer Automaton
  tap_changer.switchOffSignal1.value = false;
  tap_changer.switchOffSignal2.value = false;
  connect(tap_changer.UMonitored, load.UPu);

  // Tap Changer Transformer
  tfo.switchOffSignal1.value = false;
  tfo.switchOffSignal2.value = false;
  tap_changer.locked = if time < 1e-6 then true else false;
  when tap_changer.tap.value <> pre(tap_changer.tap.value) then
    tfo.tap.value = tap_changer.tap.value;
  end when;

  // Load
  load.switchOffSignal1.value = false;
  load.switchOffSignal2.value = false;
  load.PRefPu = 1.5;
  load.QRefPu = 0.3;
  load.deltaP = 0;
  load.deltaQ = 0;
  load.omegaRefPu = Omega0Pu.setPoint;

  // Generator and regulations
  gen.switchOffSignal1.value = false;
  gen.switchOffSignal2.value = false;
  gen.switchOffSignal3.value = false;
  gen.omegaRefPu = Omega0Pu.setPoint;
  gen.PmPu.value = govSteam.PmPu;
  gen.omegaPu.value = govSteam.omegaPu;
  gen.efdPu.value = voltageRegulatorPssOel.EfdPu;
  gen.omegaPu.value = voltageRegulatorPssOel.omegaPu;
  gen.ifPu = voltageRegulatorPssOel.ifPu;
  gen.UStatorPu.value = voltageRegulatorPssOel.UsPu;

  // Generator Transformer
  generatorTransformer.switchOffSignal1.value = false;
  generatorTransformer.switchOffSignal2.value = false;

  // Plot
  uBus1 = bus_1.UPu;
  uBus2 = bus_2.UPu;
  uBus3 = bus_3.UPu;
  uBus4 = bus_4.UPu;
  uBus5 = gen.UStatorPu.value;

  phaseBus1 = bus_1.UPhase * 360 / (2 * Modelica.Constants.pi);
  phaseBus2 = bus_2.UPhase * 360 / (2 * Modelica.Constants.pi);
  phaseBus3 = bus_3.UPhase * 360 / (2 * Modelica.Constants.pi);
  phaseBus4 = bus_4.UPhase * 360 / (2 * Modelica.Constants.pi);
  phaseBus5 = Modelica.ComplexMath.arg(gen.uStatorPu) * 360 / (2 * Modelica.Constants.pi);

  PBus13 = (line1_3.P1Pu + line1_3b.P1Pu) * Dynawo.Electrical.SystemBase.SnRef;
  PBus31 = line1_3.P2Pu * Dynawo.Electrical.SystemBase.SnRef;
  PBus43 = line3_4.P2Pu * Dynawo.Electrical.SystemBase.SnRef;
  PBusGen = gen.sStatorPu.re * Dynawo.Electrical.SystemBase.SnRef;
  PBusLoad = load.PPu * Dynawo.Electrical.SystemBase.SnRef;
  QBus13 = (line1_3.Q1Pu + line1_3b.Q1Pu) * Dynawo.Electrical.SystemBase.SnRef;
  QBus31 = line1_3.Q2Pu * Dynawo.Electrical.SystemBase.SnRef;
  QBus43 = line3_4.Q2Pu * Dynawo.Electrical.SystemBase.SnRef;
  QBusGen = gen.sStatorPu.im * Dynawo.Electrical.SystemBase.SnRef;
  QBusLoad = load.QPu * Dynawo.Electrical.SystemBase.SnRef;

  connect(grid.terminal, bus_1.terminal) annotation(
    Line(points = {{-100, 40}, {-80, 40}}, color = {0, 0, 255}));
  connect(line1_3.terminal1, bus_1.terminal) annotation(
    Line(points = {{-46, 60}, {-60, 60}, {-60, 40}, {-80, 40}}, color = {0, 0, 255}));
  connect(line1_3b.terminal1, bus_1.terminal) annotation(
    Line(points = {{-46, 20}, {-60, 20}, {-60, 40}, {-80, 40}}, color = {0, 0, 255}));
  connect(line1_3.terminal2, bus_3.terminal) annotation(
    Line(points = {{-14, 60}, {-5, 60}, {-5, 40}, {4, 40}}, color = {0, 0, 255}));
  connect(line1_3b.terminal2, bus_3.terminal) annotation(
    Line(points = {{-14, 20}, {-4, 20}, {-4, 40}, {4, 40}}, color = {0, 0, 255}));
  connect(line3_4.terminal1, bus_3.terminal) annotation(
    Line(points = {{34, 60}, {12, 60}, {12, 40}, {4, 40}}, color = {0, 0, 255}));
  connect(line3_4b.terminal1, bus_3.terminal) annotation(
    Line(points = {{34, 20}, {12.25, 20}, {12.25, 40}, {4, 40}}, color = {0, 0, 255}));
  connect(line3_4.terminal2, bus_4.terminal) annotation(
    Line(points = {{66, 60}, {83, 60}, {83, 40}, {96, 40}}, color = {0, 0, 255}));
  connect(line3_4b.terminal2, bus_4.terminal) annotation(
    Line(points = {{66, 20}, {83, 20}, {83, 40}, {96, 40}}, color = {0, 0, 255}));
  connect(tfo.terminal2, bus_2.terminal) annotation(
    Line(points = {{4, -10}, {4.5, -10}, {4.5, -44}, {4, -44}}, color = {0, 0, 255}));
  connect(load.terminal, bus_2.terminal) annotation(
    Line(points = {{4, -74}, {4, -44}}, color = {0, 0, 255}));
  connect(tfo.terminal1, bus_3.terminal) annotation(
    Line(points = {{4, 10}, {4, 40}}, color = {0, 0, 255}));
  connect(generatorTransformer.terminal2, bus_5.terminal) annotation(
    Line(points = {{120, 20}, {120, 4}}, color = {0, 0, 255}));
  connect(generatorTransformer.terminal1, bus_4.terminal) annotation(
    Line(points = {{120, 40}, {96, 40}}, color = {0, 0, 255}));
  connect(gen.terminal, bus_5.terminal) annotation(
    Line(points = {{120, -40}, {120, 4}}, color = {0, 0, 255}));
  connect(PRef.y, govSteam.PRefPu) annotation(
    Line(points = {{57, -20}, {66, -20}}, color = {0, 0, 127}));
  connect(voltageRegulatorPssOel.UsRefPu, UsRefPu.y) annotation(
    Line(points = {{72, -76}, {47, -76}}, color = {0, 0, 127}));

annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 120, Tolerance = 1e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_NLS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>toto</body></html>"));
end FiveBusSystemOperatingPoint1;
