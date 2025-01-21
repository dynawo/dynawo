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
model FiveBus

// Base calculation
  final parameter Modelica.SIunits.Impedance ZBASE225 = 225.0 ^ 2 / Dynawo.Electrical.SystemBase.SnRef;
  final parameter Modelica.SIunits.Impedance ZBASE20 = 20.0 ^ 2 / Dynawo.Electrical.SystemBase.SnRef;
  final parameter Modelica.SIunits.Impedance ZBASE15 = 15.0 ^ 2 / Dynawo.Electrical.SystemBase.SnRef;

  // grid
  //Initial parameters
  parameter Dynawo.Types.PerUnit RPu = 0.;
  parameter Dynawo.Types.PerUnit XPu = 1/6000./ZBASE225;
  Dynawo.Electrical.Buses.InfiniteBusWithImpedance_INIT grid_INIT(RPu = RPu, XPu = XPu, P0Pu = -2.95, Q0Pu = 0.39, U0Pu = 1.02, UPhase0 = 0.);
  Dynawo.Electrical.Buses.InfiniteBusWithImpedance grid(RPu = RPu, XPu = XPu, UPhaseBus0(fixed = false), UBus0Pu(fixed = false), iTerminal0Pu(re(fixed = false), im(fixed = false)), uTerminal0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(transformation(origin = {-102, 44}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));

  // busses
  Dynawo.Electrical.Buses.Bus bus_1 annotation(
    Placement(transformation(origin = {-74, 44}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_2 annotation(
    Placement(transformation(origin = {18, -44}, extent = {{-16, -16}, {16, 16}})));
  Dynawo.Electrical.Buses.Bus bus_4 annotation(
    Placement(transformation(origin = {86, 44}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_3 annotation(
    Placement(transformation(origin = {0, 44}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_5 annotation(
    Placement(transformation(origin = {120, -10}, extent = {{-16, -16}, {16, 16}})));

  // lines
  Dynawo.Electrical.Lines.Line line1_3(BPu = 0.000195 * ZBASE225, GPu = 0. * ZBASE225, RPu = 4.16 / ZBASE225, XPu = 41.6 / ZBASE225)annotation(
    Placement(transformation(origin = {-38, 52}, extent = {{-16, -16}, {16, 16}})));
  Dynawo.Electrical.Lines.Line line1_3b(BPu = 0.000195 * ZBASE225, GPu = 0. * ZBASE225, RPu = 4.16 / ZBASE225, XPu = 41.6 / ZBASE225)annotation(
    Placement(transformation(origin = {-38, 32}, extent = {{-16, -16}, {16, 16}})));
  Dynawo.Electrical.Lines.Line line3_4(BPu = 3e-05 * ZBASE225, GPu = 0. * ZBASE225, RPu = 0.64 / ZBASE225, XPu = 6.4 / ZBASE225)annotation(
    Placement(transformation(origin = {44, 52}, extent = {{-16, -16}, {16, 16}})));
  Dynawo.Electrical.Lines.Line line3_4b(BPu = 3e-05 * ZBASE225, GPu = 0 * ZBASE225, RPu = 0.64 / ZBASE225, XPu = 6.4 / ZBASE225)annotation(
    Placement(transformation(origin = {44, 32}, extent = {{-16, -16}, {16, 16}})));

  // Generator
  Dynawo.Examples.BaseClasses.InitializedGeneratorSynchronousThreeWindings gen(ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.Kundur, md = 0.1, mq = 0.1, nd = 6.0257, nq = 6.257,  DPu = 0., H = 4., RaPu = 0.,  XlPu = 0.15, XdPu = 2.2, XpdPu = 0.3, XppdPu = 0.2, Tpd0 = 7., Tppd0 = 0.05, XqPu = 2.0, XpqPu = 0.4, Tpq0 = 1.5, Tppq0 = 0.05, UNom = 20., SNom = 500., PNomTurb = 460., PNomAlt = 460., SnTfo = 500., UNomHV = 225., UNomLV = 20., UBaseHV = 225., UBaseLV = 20., RTfPu = 0., XTfPu = 0.15, P0Pu = -4.5, Q0Pu = -0.06, U0Pu = 1., UPhase0 = 0.1466076571675237) annotation(
    Placement(transformation(origin = {120, -48}, extent = {{-16, -16}, {16, 16}})));

  // PSS
  Modelica.Blocks.Sources.Constant PmRefPu(k = 450./460.);
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional gov(Pm0Pu(fixed = false), KGover = 5., PMax=500., PMin= 0., PNom=460.);


  // AVR
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportional avr(LagEfdMax = 0., LagEfdMin = 0., EfdMinPu = -5., EfdMaxPu = 5., UsRefMinPu= 0.8, UsRefMaxPu = 1.2, Gain = 20., Efd0PuLF(fixed = false), Us0Pu(fixed = false), Efd0Pu(fixed = false), UsRef0Pu=1.0);

  // load
  // init values:
  parameter Dynawo.Types.ActivePowerPu P0PuLoad1 = 1.5;
  parameter Dynawo.Types.ReactivePowerPu Q0PuLoad1 = 0.3;
  parameter Dynawo.Types.VoltageModulePu U0PuLoad1 = 1.2;
  parameter Dynawo.Types.Angle UPhase0Load1 = 0.31;
  final parameter Dynawo.Types.ComplexApparentPowerPu s0PuLoad1 = Complex(P0PuLoad1, Q0PuLoad1);
  parameter Real ActiveMotorShare[2] = {0.2, 0.2};

  parameter Dynawo.Types.AngularVelocity OmegaRefMot = 2*Modelica.Constants.pi*50;
  parameter Dynawo.Types.ApparentPowerModule SNomMot = 30;
  parameter Modelica.SIunits.Impedance ZBASEMot = 20.0 ^ 2 / SNomMot;

  parameter Dynawo.Types.PerUnit RsPu[2] = {0.031, 0.013};
  parameter Dynawo.Types.PerUnit RrPu[2] = {0.018, 0.009};
  parameter Dynawo.Types.PerUnit XsPu[2] = {0.1, 0.067};
  parameter Dynawo.Types.PerUnit XrPu[2] = {0.18, 0.17};
  parameter Dynawo.Types.PerUnit XmPu[2] = {3.2, 3.8};
  parameter Real H[2] =  {0.7, 1.5};
  parameter Real torqueExponent[2] =  {2., 2.};
  parameter Real Alpha = 0;
  parameter Real Beta = 0;

  Dynawo.Electrical.Loads.LoadAlphaBetaTwoMotorSimplified_INIT load_INIT(ActiveMotorShare = ActiveMotorShare, RsPu = RsPu, RrPu = RrPu, XsPu = XsPu, XrPu = XrPu, XmPu = XmPu, P0Pu = P0PuLoad1, Q0Pu = Q0PuLoad1, U0Pu = U0PuLoad1, UPhase0 = UPhase0Load1);

  Dynawo.Electrical.Loads.LoadAlphaBetaTwoMotorSimplified load(Alpha = Alpha, Beta = Beta, H = H, torqueExponent = torqueExponent, ActiveMotorShare = ActiveMotorShare, RsPu = RsPu, RrPu = RrPu, XsPu = XsPu, XrPu = XrPu, XmPu = XmPu, is0Pu(each re(fixed = false), each im(fixed = false)), im0Pu(each re(fixed = false), each im(fixed = false)), s0(each fixed=false), ir0Pu(each re(fixed = false), each im(fixed = false)), PLoad0Pu(fixed = false), QLoad0Pu(fixed = false), ce0Pu(each fixed = false), omegaR0Pu(each fixed = false), motori0Pu(each re(fixed = false), each im(fixed = false)), motors0Pu(each re(fixed = false), each im(fixed = false)), u0Pu(re(fixed = false), im(fixed = false)), s0Pu(re(fixed = false), im(fixed = false)), i0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(transformation(origin = {18, -70}, extent = {{-14, -14}, {14, 14}})));

  // step-down transformer
  Dynawo.Electrical.Transformers.TransformerRatioTapChanger tfo(NbTap = 33, RatioTfoMinPu = 0.88, RatioTfoMaxPu = 1.2, RPu = 0.,  XPu = 0.15, GPu = 0., BPu = 0., Tap0 = 15) annotation(
    Placement(transformation(origin = {18, -12}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
  Dynawo.Electrical.Controls.Transformers.TapChanger tap_changer(regulating0 = true, t1st = 25., tNext = 10., tapMax = 32, tapMin = 0, UDeadBand = 0.02, UTarget = 1., U0 = 1., tap0 = 15, state0 = Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.State.Standard, increaseTapToIncreaseValue = true);


  // plot
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

initial algorithm
  grid.iTerminal0Pu.re := grid_INIT.iTerminal0Pu.re;
  grid.iTerminal0Pu.im := grid_INIT.iTerminal0Pu.im;
  grid.uTerminal0Pu.re := grid_INIT.uTerminal0Pu.re;
  grid.uTerminal0Pu.im := grid_INIT.uTerminal0Pu.im;
  grid.UBus0Pu := grid_INIT.UBus0Pu;
  grid.UPhaseBus0 := grid_INIT.UPhaseBus0;
  avr.Efd0Pu := gen.Efd0Pu;
  avr.Efd0PuLF := gen.Efd0Pu;
  avr.Us0Pu := gen.UStator0Pu;
  gov.Pm0Pu := gen.Pm0Pu;

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

equation
  gen.switchOffSignal1.value = false; // gen
  gen.switchOffSignal2.value = false; // gen
  gen.switchOffSignal3.value = false; // gen

  tap_changer.switchOffSignal1.value = false; // tap_changer
  tap_changer.switchOffSignal2.value = false; // tap_changer
  connect(tap_changer.UMonitored, load.UPu); // tap_changer
  tfo.switchOffSignal1.value = false; // tfo
  tfo.switchOffSignal2.value = false; // tfo
  tap_changer.locked = if time < 1e-6 then true else false; // tap_changer
  when tap_changer.tap.value <> pre(tap_changer.tap.value) then
    tfo.tap.value = tap_changer.tap.value; // tap_changer
  end when;

  load.switchOffSignal1.value = false; // load
  load.switchOffSignal2.value = false; // load
  load.PRefPu = 1.5; // load
  load.QRefPu = 0.3; // load
  load.deltaP = 0; // load
  load.deltaQ = 0; // load
  load.omegaRefPu.value = Dynawo.Electrical.SystemBase.omegaRef0Pu; // gen

  line1_3.switchOffSignal1.value = false; // line
  line1_3.switchOffSignal2.value = false; // line
  line1_3b.switchOffSignal1.value = false; // line
  line1_3b.switchOffSignal2.value = false; // line

  line3_4.switchOffSignal1.value = false; // line
  line3_4.switchOffSignal2.value = false; // line
  line3_4b.switchOffSignal1.value = false; // line
  line3_4b.switchOffSignal2.value = false; // line

  connect(grid.terminal, bus_1.terminal) annotation(
    Line(points = {{-102, 44}, {-74, 44}}, color = {0, 0, 255}));
  connect(line1_3.terminal1, bus_1.terminal) annotation(
    Line(points = {{-54, 52}, {-74, 52}, {-74, 44}}, color = {0, 0, 255}));
  connect(line1_3b.terminal1, bus_1.terminal) annotation(
    Line(points = {{-54, 32}, {-74, 32}, {-74, 44}}, color = {0, 0, 255}));
  connect(line1_3.terminal2, bus_3.terminal) annotation(
    Line(points = {{-22, 52}, {0, 52}, {0, 44}}, color = {0, 0, 255}));
  connect(line1_3b.terminal2, bus_3.terminal) annotation(
    Line(points = {{-22, 32}, {0, 32}, {0, 44}}, color = {0, 0, 255}));
  connect(line3_4.terminal1, bus_3.terminal) annotation(
    Line(points = {{28, 52}, {0, 52}, {0, 44}}, color = {0, 0, 255}));
  connect(line3_4b.terminal1, bus_3.terminal) annotation(
    Line(points = {{28, 32}, {0, 32}, {0, 44}}, color = {0, 0, 255}));
  connect(line3_4.terminal2, bus_4.terminal) annotation(
    Line(points = {{60, 52}, {86, 52}, {86, 44}}, color = {0, 0, 255}));
  connect(line3_4b.terminal2, bus_4.terminal) annotation(
    Line(points = {{60, 32}, {86, 32}, {86, 44}}, color = {0, 0, 255}));
  connect(gen.terminal, bus_5.terminal) annotation(
    Line(points = {{120, -48}, {120, -10}}, color = {0, 0, 255}));
  connect(bus_5.terminal, bus_4.terminal) annotation(
    Line(points = {{120, -10}, {86, -10}, {86, 44}}, color = {0, 0, 255}));
  connect(bus_3.terminal, tfo.terminal1) annotation(
    Line(points = {{0, 44}, {18, 44}, {18, 2}}, color = {0, 0, 255}));
  connect(tfo.terminal2, bus_2.terminal) annotation(
    Line(points = {{18, -26}, {18, -44}}, color = {0, 0, 255}));
  connect(bus_2.terminal, load.terminal) annotation(
    Line(points = {{18, -44}, {18, -70}}, color = {0, 0, 255}));

  connect(PmRefPu.y, gov.PmRefPu); // gov
  gov.omegaPu = gen.omegaPu.value; // gov
  gov.deltaPmRefPu = 0.; // gov

  gen.omegaRefPu.value = Dynawo.Electrical.SystemBase.omegaRef0Pu; // gen
  gov.PmPu = gen.PmPu.value; // gen
  avr.EfdPu = gen.efdPu.value; // gen

  avr.UsPu = gen.UStatorPu.value; // avr
  avr.deltaUsRefPu = 0.; // avr
  avr.UsRefPu = 1.0; // avr

  // plot
  uBus1 = bus_1.UPu;
  uBus2 = bus_2.UPu;
  uBus3 = bus_3.UPu;
  uBus4 = bus_4.UPu;
  uBus5 = gen.UStatorPu.value;

  phaseBus1 = bus_1.UPhase * 360 / (2 * Modelica.Constants.pi);
  phaseBus2 = bus_2.UPhase * 360 / (2 * Modelica.Constants.pi);
  phaseBus3 = bus_3.UPhase * 360 / (2 * Modelica.Constants.pi);
  phaseBus4 = bus_4.UPhase * 360 / (2 * Modelica.Constants.pi);
  phaseBus5 = Modelica.ComplexMath.arg(gen.uStatorPu)  * 360 / (2 * Modelica.Constants.pi);

  PBus13 = (line1_3.P1Pu+line1_3b.P1Pu) * Dynawo.Electrical.SystemBase.SnRef;
  PBus31 = line1_3.P2Pu * Dynawo.Electrical.SystemBase.SnRef;
  PBus43 = line3_4.P2Pu * Dynawo.Electrical.SystemBase.SnRef;
  PBusGen = gen.sStatorPu.re * Dynawo.Electrical.SystemBase.SnRef;
  PBusLoad = load.PPu * Dynawo.Electrical.SystemBase.SnRef;

  QBus13 = (line1_3.Q1Pu+line1_3b.Q1Pu) * Dynawo.Electrical.SystemBase.SnRef;
  QBus31 = line1_3.Q2Pu * Dynawo.Electrical.SystemBase.SnRef;
  QBus43 = line3_4.Q2Pu * Dynawo.Electrical.SystemBase.SnRef;
  QBusGen = gen.sStatorPu.im * Dynawo.Electrical.SystemBase.SnRef;
  QBusLoad = load.QPu * Dynawo.Electrical.SystemBase.SnRef;

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_NLS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>toto</body></html>"));
end FiveBus;
