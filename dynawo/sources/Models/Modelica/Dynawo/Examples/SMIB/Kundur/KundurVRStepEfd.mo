within Dynawo.Examples.SMIB.Kundur;

model KundurVRStepEfd "Synchronous machine infinite bus - Step on Pm"
  /*
    * Copyright (c) 2024, RTE (http://www.rte-france.com)
    * See AUTHORS.txt
    * All rights reserved.
    * This Source Code Form is subject to the terms of the Mozilla Public
    * License, v. 2.0. If a copy of the MPL was not distributed with this
    * file, you can obtain one at http://mozilla.org/MPL/2.0/.
    * SPDX-License-Identifier: MPL-2.0
    *
    * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
    */
  extends Icons.Example;
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 0.995) annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 100 / 2220, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {18, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousKundur6thOrder generatorSynchronous(ASat = 0.031, BSat = 6.93, Ce0Pu = 0.9, Cm0Pu = 0.9, DPu = 0, Efd0Pu = 2.3915, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParametersKundur6thOrder.ExcitationPuType.NoLoad, H = 3.5, IRotor0Pu = 2.3915, IStator0Pu = ComplexMath.'abs'(generatorSynchronous.iStator0Pu), Id0Pu = -0.8289, If0Pu = 1.4494, Iq0Pu = -0.4515, LDPPu = 0.14, LQ1PPu = 0.7063, LQ2PPu = 0.1102, LambdaAD0Pu = 0.8670, LambdaAQ0Pu = -0.6128, LambdaAirGap0Pu = 1.0617, LambdaD0Pu = 0.8670, LambdaQ10Pu = -0.6127, LambdaQ20Pu = -0.6127, Lambdad0Pu = 0.7342, Lambdaf0Pu = 1.0887, Lambdaq0Pu = -0.6850, LdPPu = 0.16, LfPPu = 0.153, LqPPu = 0.16, MdPPu = 1.65, MdSat0PPu = 1.3995, MqPPu = 1.6, MqSat0PPu = 1.3571, MrcPPu = 0, P0Pu = -0.9 * 2220 / 100, PGen0Pu = -generatorSynchronous.P0Pu, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.9, Q0Pu = -0.3 * 2220 / 100, QGen0Pu = -generatorSynchronous.Q0Pu, QStator0Pu = generatorSynchronous.Q0Pu, QStator0PuQNom = 2.2193, RDPPu = 0.0248, RQ1PPu = 0.0061, RQ2PPu = 0.0227, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.0006, SNom = 2220, SnTfo = generatorSynchronous.SNom, Theta0 = 1.3752, ThetaInternal0 = 0.7498, U0Pu = 1.0014, UBaseHV = generatorSynchronous.UNom, UBaseLV = generatorSynchronous.UNom, UNom = 24, UNomHV = generatorSynchronous.UNom, UNomLV = generatorSynchronous.UNom, UPhase0 = 0.6307, UStator0Pu = generatorSynchronous.U0Pu, Ud0Pu = 0.6825, Uf0Pu = 0.0008, Uq0Pu = 0.7328, XTfPu = 0, i0Pu = ComplexMath.conj(generatorSynchronous.s0Pu / generatorSynchronous.u0Pu), iStator0Pu = generatorSynchronous.i0Pu, lambdaT1 = 0.8, s0Pu = Complex(generatorSynchronous.P0Pu, generatorSynchronous.Q0Pu), sStator0Pu = generatorSynchronous.s0Pu, u0Pu = Complex(generatorSynchronous.U0Pu * cos(generatorSynchronous.UPhase0), generatorSynchronous.U0Pu * sin(generatorSynchronous.UPhase0)), uStator0Pu = generatorSynchronous.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {66, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.Step PmPu(Value0 = 0.9, Height = -0.02, tStep = 10);
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint UsRefPu(Value0 = generatorSynchronous.Efd0Pu/voltageRegulator.Ka + generatorSynchronous.UStator0Pu);
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.5 * 100 / 2220) annotation(
    Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.VRKundur voltageRegulator(Efd0Pu = generatorSynchronous.Efd0Pu, EfdMaxPu = 9999, EfdMinPu = -9999, Ka = 10, Us0Pu = generatorSynchronous.UStator0Pu, tR = 0.05)  annotation(
    Placement(visible = true, transformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{38, 0}, {66, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(generatorSynchronous.PmPu, PmPu.step);
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-64, 0}, {-92, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, transformer.terminal1) annotation(
    Line(points = {{-24, 0}, {-2, 0}}, color = {0, 0, 255}));

  voltageRegulator.efdPu = generatorSynchronous.efdPu.value;
  voltageRegulator.UsPu = generatorSynchronous.UStatorPu.value;
  voltageRegulator.UsRefPu = UsRefPu.setPoint.value;
  voltageRegulator.UPssPu = 0;

  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 50, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case represents a 2220 MVA synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a 0.02 pu step variation on the generator mechanical power Pm occurring at t = 1 s.
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
end KundurVRStepEfd;
