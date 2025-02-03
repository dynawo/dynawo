within Dynawo.Examples.SMIB;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model SMIBStepPm "Synchronous machine infinite bus - Step on Pm"
  extends Icons.Example;

  // Generator
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(
    DPu = 0,
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = 3.5,
    LDPPu = 0.16634,
    LQ1PPu = 0.92815,
    LQ2PPu = 0.12046,
    LdPPu = 0.15,
    LfPPu = 0.1699,
    LqPPu = 0.15,
    MdPPu = 1.66,
    MdPPuEfd = 1,
    MqPPu = 1.61,
    MrcPPu = 0,
    MsalPu = 0.05,
    P0Pu = -19.98,
    PNomAlt = 2200,
    PNomTurb = 2220,
    Q0Pu = -9.68,
    RDPPu = 0.03339,
    RQ1PPu = 0.00924,
    RQ2PPu = 0.02821,
    RTfPu = 0,
    RaPPu = 0.003,
    RfPPu = 0.00074,
    SNom = 2220,
    SnTfo = 2220,
    U0Pu = 1,
    UBaseHV = 24,
    UBaseLV = 24,
    UNom = 24,
    UNomHV = 24,
    UNomLV = 24,
    UPhase0 = 0.494442,
    XTfPu = 0,
    md = 0.031,
    mq = 0.031,
    nd = 6.93,
    nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);

  // Generator speed control
  Modelica.Blocks.Sources.Step PmPu(height = 0.02, offset = 0.903, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Generator voltage control
  Modelica.Blocks.Sources.Constant EfdPu(k = 2.4659) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Grid with impedances
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 0.90081) annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.022522) annotation(
    Placement(visible = true, transformation(origin = {-32, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0, XPu = 0.04189) annotation(
    Placement(visible = true, transformation(origin = {-32, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Transformer
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

initial equation
  der(generatorSynchronous.lambdafPu) = 0;
  der(generatorSynchronous.lambdaDPu) = 0;
  der(generatorSynchronous.lambdaQ1Pu) = 0;
  der(generatorSynchronous.lambdaQ2Pu) = 0;
  der(generatorSynchronous.theta) = 0;
  der(generatorSynchronous.omegaPu.value) = 0;

equation
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{56, 0}, {82, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, transformer.terminal1) annotation(
    Line(points = {{-12, -20}, {0, -20}, {0, 0}, {16, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, transformer.terminal1) annotation(
    Line(points = {{-12, 20}, {0, 20}, {0, 0}, {16, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-52, 20}, {-60, 20}, {-60, 0}, {-92, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-52, -20}, {-60, -20}, {-60, 0}, {-92, 0}}, color = {0, 0, 255}));
  connect(EfdPu.y, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{62, -40}, {70, -40}, {70, -16}}, color = {0, 0, 127}));
  connect(PmPu.y, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{82, -70}, {94, -70}, {94, -16}}, color = {0, 0, 127}));

  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 0.000001),
    //__OpenModelica_commandLineOptions = "--daeMode",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls="kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case represents a 2220 MVA synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a 0.02 pu step variation on the generator mechanical power Pm occurring at t = 1 s.
    </div><div><br></div><div>The two following figures show the expected evolution of the generator voltage and active power during the simulation.
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/PGen.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/UStatorPu.png\">
    </figure>
    We observe that the active power is increased by 44.05 MW. The voltage drop between the infinite bus and the machine terminal is consequently increased, resulting in a decrease of the machine terminal voltage.
    </div><div><br></div><div>Initial equation are provided on the generator differential variables to ensure a steady state initialisation by the Modelica tool. It had to be written here and not directly in Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous because the Dynawo simulator applies a different initialisation strategy that does not involve the initial equation section.
    </div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
"));
end SMIBStepPm;
