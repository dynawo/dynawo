within Dynawo.Examples.SMIB.Kundur;

model KundurStaticCase "Synchronous machine infinite bus - Step on Pm"
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
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.5 * 100 / 2220) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.15 * 100 / 2220, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Electrical.Machines.Simplified.GeneratorFictitious generatorPQ(Alpha = 0, Beta = 0, PGen0Pu = 0.9 * 2220 / 100, QGen0Pu = 0.3 * 2220 / 100, U0Pu = 0.9998, i0Pu = ComplexMath.conj(-Complex(generatorPQ.PGen0Pu, generatorPQ.QGen0Pu) / generatorPQ.u0Pu), u0Pu = Complex(generatorPQ.U0Pu, 0))  annotation(
    Placement(visible = true, transformation(origin = {84, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Real UPhase;

equation
  connect(line1.terminal2, transformer.terminal1) annotation(
    Line(points = {{-12, 0}, {16, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-52, 0}, {-92, 0}}, color = {0, 0, 255}));
  connect(generatorPQ.terminal, transformer.terminal2) annotation(
    Line(points = {{84, 0}, {56, 0}}, color = {0, 0, 255}));

  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  generatorPQ.switchOffSignal1.value = false;
  generatorPQ.switchOffSignal2.value = false;
  generatorPQ.switchOffSignal3.value = false;

  UPhase = ComplexMath.arg(generatorPQ.terminal.V);

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 0.000001),
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
end KundurStaticCase;
