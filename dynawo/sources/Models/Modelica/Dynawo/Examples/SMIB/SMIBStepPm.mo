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
  import Dynawo;

  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 0.90081) annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.022522) annotation(
    Placement(visible = true, transformation(origin = {-32, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0, XPu = 0.04189) annotation(
    Placement(visible = true, transformation(origin = {-32, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous generatorSynchronous(
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = 3.5, DPu = 0,
    PNomAlt = 2200, PNomTurb = 2220, SNom = 2220,
    SnTfo = 2220, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, XTfPu = 0, RTfPu = 0,
    P0Pu = -19.98, Q0Pu= -9.68, U0Pu = 1, UPhase0 = 0.494442,
    RaPPu = 0.003,
    LdPPu = 0.15,
    MdPPu = 1.66,
    LDPPu = 0.16634,
    RDPPu = 0.03339,
    MrcPPu = 0,
    LfPPu = 0.16990,
    RfPPu = 0.00074,
    LqPPu = 0.15,
    MqPPu = 1.61,
    LQ1PPu = 0.92815,
    RQ1PPu = 0.00924,
    LQ2PPu = 0.12046,
    RQ2PPu = 0.02821,
    PGen0Pu = 19.98,
    QGen0Pu = 9.6789,
    UStator0Pu = 1,
    QStator0Pu = 9.6789,
    Theta0 = 1.2107,
    ThetaInternal0 = 0.71622,
    IRotor0Pu = 2.4659,
    IStator0Pu = 22.2009,
    Efd0Pu = 2.4659,
    Cm0Pu = 0.903, Ce0Pu = 0.903, Pm0Pu = 0.903,
    Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262,
    LambdaD0Pu = 0.89243, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458,
    LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdaq0Pu = -0.65934,
    Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434,
    MdSat0PPu = 1.5792, MqSat0PPu = 1.5292, LambdaAQ0Pu = -0.60044, LambdaAD0Pu = 0.89347, Mi0Pu = 1.5637, LambdaAirGap0Pu = 1.0764,
    Sin2Eta0 = 0.31111, Cos2Eta0 = 0.68888, Mds0Pu = 1.5785, Mqs0Pu = 1.5309,
    md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93, MsalPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {82, 1.9984e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.Step PmPu(Value0 = 0.903, Height = 0.02, tStep = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint EfdPu(Value0 = 2.4659);

initial equation
  der(generatorSynchronous.lambdafPu) = 0;
  der(generatorSynchronous.lambdaDPu) = 0;
  der(generatorSynchronous.lambdaQ1Pu) = 0;
  der(generatorSynchronous.lambdaQ2Pu) = 0;
  der(generatorSynchronous.theta) = 0;
  der(generatorSynchronous.omegaPu.value) = 0;

equation
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{56, 0}, {82, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, transformer.terminal1) annotation(
    Line(points = {{-12, -20}, {0, -20}, {0, 0}, {16, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, transformer.terminal1) annotation(
    Line(points = {{-12, 20}, {1.42109e-14, 20}, {1.42109e-14, -4.26324e-14}, {16, -4.26324e-14}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-52, 20}, {-62, 20}, {-62, -4.26324e-14}, {-92, -4.26324e-14}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-52, -20}, {-62, -20}, {-62, 0}, {-92, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(generatorSynchronous.PmPu, PmPu.step);
  connect(generatorSynchronous.efdPu, EfdPu.setPoint);

  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 0.000001),
    //__OpenModelica_commandLineOptions = "--daeMode",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls="kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case represents a 2220 MWA synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a 0.02 pu step variation on the generator mechanical power Pm occurring at t = 1 s.
    </div><div><br></div><div>The two following figures show the expected evolution of the generator's voltage and active power during the simulation.
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/PGen.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/UStatorPu.png\">
    </figure>
    We observe that the active power is increased by 44.05 MW. The voltage drop between the infinite bus and the machine terminal is consequently increased, resulting in a decrease of the machine terminal voltage.
    </div><div><br></div><div>Initial equation are provided on the generator's differential variables to ensure a steady state initialisation by the Modelica tool. It had to be written here and not directly in Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous because the Dynawo simulator applies a different initialisation strategy that does not involve the initial equation section.
    </div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
"));
end SMIBStepPm;
