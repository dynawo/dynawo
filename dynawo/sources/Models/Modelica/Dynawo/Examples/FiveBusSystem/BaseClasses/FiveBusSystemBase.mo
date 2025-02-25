within Dynawo.Examples.FiveBusSystem.BaseClasses;

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

partial model FiveBusSystemBase "Five-bus system base class"

  // Base Calculation
  final parameter Modelica.SIunits.Impedance ZBASE225 = 225.0 ^ 2 / Dynawo.Electrical.SystemBase.SnRef;

  // Generator transformer parameters
  parameter Types.ApparentPowerModule SNomTfo = 500 "Generator transformer nominal apparent power in MVA";
  parameter Types.VoltageModule U1BaseTfo = 225 "Generator transfomer base voltage at bus 1 in kV";
  parameter Types.VoltageModule U1NomTfo = 231.75 "Generator transfomer nominal voltage at bus 1 in kV";
  parameter Types.VoltageModule U2BaseTfo = 15 "Generator transfomer base voltage at bus 2 in kV";
  parameter Types.VoltageModule U2NomTfo = 15 "Generator transfomer nominal voltage at bus 2 in kV";
  parameter Types.PerUnit XPuTfo = 0.15 "Reactance of the generator transformer in pu (base U2Nom, SNomTfo)";

  // Load parameters
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

  // Grid
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.02, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {-196, 60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Buses
  Dynawo.Electrical.Buses.Bus bus_1(UNom = 225) annotation(
    Placement(visible = true, transformation(origin = {-140, 60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_2(UNom = 20) annotation(
    Placement(visible = true, transformation(origin = {-40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_3(UNom = 225) annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_4(UNom = 225) annotation(
    Placement(visible = true, transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_5(UNom = 15) annotation(
    Placement(visible = true, transformation(origin = {80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Lines
  Dynawo.Electrical.Lines.Line line1_3(BPu = 0.000195 * ZBASE225, GPu = 0. * ZBASE225, RPu = 4.16 / ZBASE225, XPu = 41.6 / ZBASE225) annotation(
    Placement(visible = true, transformation(origin = {-90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1_3b(BPu = 0.000195 * ZBASE225, GPu = 0. * ZBASE225, RPu = 4.16 / ZBASE225, XPu = 41.6 / ZBASE225) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3_4(BPu = 3e-05 * ZBASE225, GPu = 0. * ZBASE225, RPu = 0.64 / ZBASE225, XPu = 6.4 / ZBASE225) annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3_4b(BPu = 3e-05 * ZBASE225, GPu = 0 * ZBASE225, RPu = 0.64 / ZBASE225, XPu = 6.4 / ZBASE225) annotation(
    Placement(visible = true, transformation(origin = {10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Tap Changer Transformer
  Dynawo.Electrical.Transformers.TransformerVariableTap tfo(B = 0, G = 0, NbTap = 33, P10Pu(fixed = false), Q10Pu(fixed = false), R = 0, SNom = 250, Tap0 = 14, U10Pu(fixed = false), U20Pu(fixed = false), X = 0.15 * 100, i10Pu(re(fixed = false), im(fixed = false)), i20Pu(re(fixed = false), im(fixed = false)), rTfo0Pu = 1.01, rTfoMaxPu = 1.2, rTfoMinPu = 0.88, u10Pu(re(fixed = false), im(fixed = false)), u20Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Transformers.TapChanger tap_changer(regulating0 = true, t1st = 25., tNext = 10., tapMax = 32, tapMin = 0, UDeadBand = 0.01, UTarget = 1.0038, U0 = 1.0038, tap0 = 14, state0 = Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.State.Standard, increaseTapToIncreaseValue = true);

  // Load
  Dynawo.Electrical.Loads.LoadAlphaBetaTwoMotorSimplified load(ActiveMotorShare = ActiveMotorShare, Alpha = Alpha, Beta = Beta, H = H, PLoad0Pu(fixed = false), QLoad0Pu(fixed = false), RrPu = RrPu, RsPu = RsPu, XmPu = XmPu, XrPu = XrPu, XsPu = XsPu, ce0Pu(each fixed = false), i0Pu(re(fixed = false), im(fixed = false)), im0Pu(each re(fixed = false), each im(fixed = false)), ir0Pu(each re(fixed = false), each im(fixed = false)), is0Pu(each re(fixed = false), each im(fixed = false)), motori0Pu(each re(fixed = false), each im(fixed = false)), motors0Pu(each re(fixed = false), each im(fixed = false)), omegaR0Pu(each fixed = false), s0(each fixed = false), s0Pu(re(fixed = false), im(fixed = false)), torqueExponent = torqueExponent, u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Generator transformer
  Dynawo.Electrical.Transformers.TransformerFixedRatio generatorTransformer(BPu = 0, GPu = 0, RPu = 0, XPu = XPuTfo * SystemBase.SnRef / SNomTfo, rTfoPu = U2NomTfo / U2BaseTfo / (U1NomTfo / U1BaseTfo)) annotation(
    Placement(visible = true, transformation(origin = {80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // Generator
  Dynawo.Examples.BaseClasses.InitializedGeneratorSynchronousFourWindings gen(DPu = 0, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad, H = 4, PNomAlt = 460, PNomTurb = 460, RTfPu = 0, RaPu = 0, SNom = 500, SnTfo = 500, Tpd0 = 7, Tppd0 = 0.05, Tppq0 = 0.05, Tpq0 = 1.5, UBaseHV = 225, UBaseLV = 15, UNom = 15, UNomHV = 231.75, UNomLV = 15, XTfPu = 0, XdPu = 2.2, XlPu = 0.15, XpdPu = 0.3, XppdPu = 0.2, XppqPu = 0.2, XpqPu = 0.4, XqPu = 2, md = 0.1, mq = 0.1, nd = 6.0257, nq = 6.0257) annotation(
    Placement(visible = true, transformation(origin = {80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // SetPoints
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Modelica.Blocks.Sources.Constant PRef(k = gen.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {170, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant omegaRef0Pu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {170, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  // Governor
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.GovSteam govSteam(FHp = 0.4, FMp = 0.3, Ivo = 1, PNomTurb = 460, Pm0Pu = gen.Pm0Pu, Sigma = 0.04, ZMaxPu = 1, ZMinPu = 0, dZMaxPu = 0.05, dZMinPu = -0.05, tHp = 0.3, tLp = 0.3, tMeas = 0.1, tR = 5, tSm = 0.4) annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  // Voltage Regulator
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VoltageRegulatorPssOel voltageRegulatorPssOel(VPssMaxPu = 0.06, Efd0Pu = gen.Efd0Pu, EfdMaxPu = 5, EfdMinPu = 0, G = 70, If0Pu = gen.IRotor0Pu, KOel = 2, KPss = 50, VOel1MinPu = -1.1, VOel1MaxPu = 0.1, VOel2MaxPu = 0.2, Us0Pu = gen.UStator0Pu, ifLim1Pu = 2.9, ifLim2Pu = 1, t1 = 0.323, t2 = 0.0138, t3 = 0.323, t4 = 0.0138, tA = 1, tB = 1, tE = 0.4, tOel = 8, tOmega = 5) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Plot
  /*Dynawo.Types.VoltageModulePu uBus1;
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
      Dynawo.Types.ReactivePower QBusGen;*/

equation
  // Tap Changer Automaton
  connect(tap_changer.UMonitored, load.UPu);

  // Tap Changer Transformer
  when tap_changer.tap.value <> pre(tap_changer.tap.value) then
    tfo.tap.value = tap_changer.tap.value;
  end when;

  // Plot
/*uBus1 = bus_1.UPu;
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
  QBusLoad = load.QPu * Dynawo.Electrical.SystemBase.SnRef;*/

  connect(load.terminal, bus_2.terminal) annotation(
    Line(points = {{-40, -70}, {-40, -40}}, color = {0, 0, 255}));
  connect(generatorTransformer.terminal2, bus_5.terminal) annotation(
    Line(points = {{80, 40}, {80, 20}}, color = {0, 0, 255}));
  connect(generatorTransformer.terminal1, bus_4.terminal) annotation(
    Line(points = {{80, 60}, {60, 60}}, color = {0, 0, 255}));
  connect(gen.terminal, bus_5.terminal) annotation(
    Line(points = {{80, -20}, {80, 20}}, color = {0, 0, 255}));
  connect(voltageRegulatorPssOel.EfdPu, gen.efdPu_in) annotation(
    Line(points = {{61, -50}, {73, -50}, {73, -28}}, color = {0, 0, 127}));
  connect(PRef.y, govSteam.PRefPu) annotation(
    Line(points = {{159, -70}, {139.5, -70}, {139.5, -56}, {122, -56}}, color = {0, 0, 127}));
  connect(omegaRef0Pu.y, govSteam.omegaRefPu) annotation(
    Line(points = {{159, -30}, {140.5, -30}, {140.5, -50}, {122, -50}}, color = {0, 0, 127}));
  connect(govSteam.PmPu, gen.PmPu_in) annotation(
    Line(points = {{99, -50}, {86, -50}, {86, -28}}, color = {0, 0, 127}));
  connect(gen.UsPu_out, voltageRegulatorPssOel.UsPu) annotation(
    Line(points = {{89, -11}, {21, -11}, {21, -49}, {37, -49}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gen.IRotorPu_out, voltageRegulatorPssOel.ifPu) annotation(
    Line(points = {{84, -11}, {84, -9}, {14, -9}, {14, -57}, {38, -57}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gen.omegaPu_out, voltageRegulatorPssOel.omegaPu) annotation(
    Line(points = {{89, -23}, {27, -23}, {27, -45}, {37, -45}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gen.omegaPu_out, govSteam.omegaPu) annotation(
    Line(points = {{89, -23}, {133, -23}, {133, -45}, {121, -45}}, color = {0, 0, 127}));
  connect(line3_4.terminal2, bus_4.terminal) annotation(
    Line(points = {{20, 80}, {40, 80}, {40, 60}, {60, 60}}, color = {0, 0, 255}));
  connect(line3_4b.terminal2, bus_4.terminal) annotation(
    Line(points = {{20, 40}, {40, 40}, {40, 60}, {60, 60}}, color = {0, 0, 255}));
  connect(line1_3.terminal2, bus_3.terminal) annotation(
    Line(points = {{-80, 80}, {-60, 80}, {-60, 60}, {-40, 60}}, color = {0, 0, 255}));
  connect(line1_3b.terminal2, bus_3.terminal) annotation(
    Line(points = {{-80, 40}, {-60, 40}, {-60, 60}, {-40, 60}}, color = {0, 0, 255}));
  connect(bus_3.terminal, tfo.terminal1) annotation(
    Line(points = {{-40, 60}, {-40, 20}}, color = {0, 0, 255}));
  connect(line3_4.terminal1, bus_3.terminal) annotation(
    Line(points = {{0, 80}, {-20, 80}, {-20, 60}, {-40, 60}}, color = {0, 0, 255}));
  connect(line3_4b.terminal1, bus_3.terminal) annotation(
    Line(points = {{0, 40}, {-20, 40}, {-20, 60}, {-40, 60}}, color = {0, 0, 255}));
  connect(line1_3.terminal1, bus_1.terminal) annotation(
    Line(points = {{-100, 80}, {-120, 80}, {-120, 60}, {-140, 60}}, color = {0, 0, 255}));
  connect(line1_3b.terminal1, bus_1.terminal) annotation(
    Line(points = {{-100, 40}, {-120, 40}, {-120, 60}, {-140, 60}}, color = {0, 0, 255}));
  connect(tfo.terminal2, bus_2.terminal) annotation(
    Line(points = {{-40, 0}, {-40, -40}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, bus_1.terminal) annotation(
    Line(points = {{-196, 60}, {-140, 60}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 120, Tolerance = 1e-06),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_NLS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    Documentation(info = "<html><head></head><body><br></body></html>"));
end FiveBusSystemBase;
