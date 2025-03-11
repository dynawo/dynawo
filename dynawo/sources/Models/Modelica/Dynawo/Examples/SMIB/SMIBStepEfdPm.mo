within Dynawo.Examples.SMIB;

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

model SMIBStepEfdPm "Synchronous machine infinite bus with steps on Efd and Pm"
  extends Icons.Example;

  // Generator
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(
    DPu = 0,
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = 4,
    LDPPu = 0.2,
    LQ1PPu = 0.444231,
    LQ2PPu = 0.2625,
    LdPPu = 0.15,
    LfPPu = 0.224242,
    LqPPu = 0.15,
    MdPPu = 1.85,
    MdPPuEfd = 1,
    MqPPu = 1.65,
    MrcPPu = 0,
    MsalPu = 0.2,
    P0Pu = -4.75,
    PNomAlt = 500,
    PNomTurb = 501,
    Q0Pu = -1.56,
    RDPPu = 0.0303152,
    RQ1PPu = 0.00308618,
    RQ2PPu = 0.0234897,
    RTfPu = 0,
    RaPPu = 0,
    RfPPu = 0.00128379,
    SNom = 501,
    SnTfo = 500,
    U0Pu = 0.992,
    UBaseHV = 400,
    UBaseLV = 21,
    UNom = 21,
    UNomHV = 400,
    UNomLV = 21,
    UPhase0 = 0.161146,
    XTfPu = 0,
    md = 0,
    mq = 0,
    nd = 0,
    nq = 0) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);

  // Generator speed control
  Modelica.Blocks.Sources.Step PmPu(height = 0.1, offset = 0.948104, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Generator voltage control
  Modelica.Blocks.Sources.Step EfdPu(height = 0.2, offset = 2.50416, startTime = 15) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Grid with impedance
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0.000242, UPu = 0.952859) annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line gridImpedance(BPu = 0, GPu = 0, RPu = 0.0036, XPu = 0.036) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Transformer
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0.0003, XPu = 0.032, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Load
  Dynawo.Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, i0Pu(re(fixed = false), im(fixed = false)), s0Pu(re(fixed = false), im(fixed = false)), u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 4.75) annotation(
    Placement(visible = true, transformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.76) annotation(
    Placement(visible = true, transformation(origin = {30, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  // Initialization
  Dynawo.Electrical.Loads.Load_INIT load_INIT(P0Pu = PRefPu.k, Q0Pu = QRefPu.k, U0Pu = 0.952267, UPhase0 = 0) annotation(
    Placement(transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}})));

initial algorithm
  load.i0Pu.re := load_INIT.i0Pu.re;
  load.i0Pu.im := load_INIT.i0Pu.im;
  load.s0Pu.re := load_INIT.s0Pu.re;
  load.s0Pu.im := load_INIT.s0Pu.im;
  load.u0Pu.re := load_INIT.u0Pu.re;
  load.u0Pu.im := load_INIT.u0Pu.im;

initial equation
  der(generatorSynchronous.lambdafPu) = 0;
  der(generatorSynchronous.lambdaDPu) = 0;
  der(generatorSynchronous.lambdaQ1Pu) = 0;
  der(generatorSynchronous.lambdaQ2Pu) = 0;
  der(generatorSynchronous.theta) = 0;
  der(generatorSynchronous.omegaPu.value) = 0;

equation
  gridImpedance.switchOffSignal1.value = false;
  gridImpedance.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  load.switchOffSignal1.value = false;
  load.switchOffSignal2.value = false;
  load.deltaP = 0;
  load.deltaQ = 0;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;

  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{56, 0}, {82, 0}}, color = {0, 0, 255}));
  connect(gridImpedance.terminal2, transformer.terminal1) annotation(
    Line(points = {{-12, 0}, {0, 0}, {0, 0}, {16, 0}}, color = {0, 0, 255}));
  connect(gridImpedance.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-52, 0}, {-62, 0}, {-62, 0}, {-92, 0}}, color = {0, 0, 255}));
  connect(load.terminal, gridImpedance.terminal2) annotation(
    Line(points = {{0, -40}, {0, 0}, {-12, 0}}, color = {0, 0, 255}));
  connect(PRefPu.y, load.PRefPu) annotation(
    Line(points = {{-18, -70}, {-6, -70}, {-6, -48}}, color = {0, 0, 127}));
  connect(QRefPu.y, load.QRefPu) annotation(
    Line(points = {{20, -70}, {6, -70}, {6, -48}}, color = {0, 0, 127}));
  connect(EfdPu.y, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{62, -40}, {70, -40}, {70, -16}}, color = {0, 0, 127}));
  connect(PmPu.y, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{82, -70}, {94, -70}, {94, -16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 50, Tolerance = 0.000001),
    __OpenModelica_commandLineOptions = "--daeMode",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls="kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">This test case represents a 501 MVA synchronous machine connected to an infinite bus through a transformer and a line, with&nbsp;</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">an active and reactive load between the transformer and the line.</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br><br>A step on PmPu is applied at t = 5 s, followed by a step on EfdPu at t = 15 s.&nbsp;</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The two figures below show the expected evolution of the generator voltage and active power during the simulation.</span><div><font face=\"DejaVu Sans Mono\"><br></font></div><div><font face=\"DejaVu Sans Mono\">
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/PGenPu.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/UPu.png\">
    </figure>
    The step on PmPu causes an increase in the active power and a decrease in the stator voltage, as a bigger current implies a bigger voltage drop between the infinite bus and the generator. The step on EfdPu entails a rise in the stator voltage.</font></div><div><font face=\"DejaVu Sans Mono\"><br></font></div><div><font face=\"DejaVu Sans Mono\">The variations of the stator voltage are reflected in the active and reactive power consumed by the alpha-beta load, which are proportional to the voltage at the load terminal.<br></font><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></span></div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Initial equations are provided on the generator differential variables to ensure a steady state initialization by OpenModelica. It had to be written here and not directly in Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous because the Dynawo simulator applies a different initialization strategy that does not involve the initial equation section.</span></div></div></body></html>"));
end SMIBStepEfdPm;
