within Dynawo.Examples.TwoAreas;

model KundurA "Kundur two-area system with buses, lines and transformers"
  /*
      * Copyright (c) 2022, RTE (http://www.rte-france.com)
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
  extends Dynawo.Examples.TwoAreas.Network;

  parameter Types.ReactivePowerPu P0PuG2 = 7;
  parameter Types.ReactivePowerPu Q0PuG2 = 2.35;
  parameter Types.ReactivePowerPu P0PuG3 = 7.19;
  parameter Types.ReactivePowerPu Q0PuG3 = 1.76;
  parameter Types.ReactivePowerPu P0PuG4 = 7;
  parameter Types.ReactivePowerPu Q0PuG4 = 2.02;

Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousKundur6thOrder G2(ASat = 0.015, BSat = 9.6, Ce0Pu = 0.779, Cm0Pu = 0.779, DPu = 0, Efd0Pu = 2.0906, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParametersKundur6thOrder.ExcitationPuType.NoLoad, H = 6.5, IRotor0Pu = 2.0906, IStator0Pu = ComplexMath.'abs'(G2.iStator0Pu), Id0Pu = -0.698, If0Pu = 1.306, Iq0Pu = -0.414, LDPPu = 0.1, LQ1PPu = 0.4565, LQ2PPu = 0.058, LambdaAD0Pu = 0.906, LambdaAQ0Pu = -0.578, LambdaAirGap0Pu = 1.0745, LambdaD0Pu = 0.90, LambdaQ10Pu = -0.578, LambdaQ20Pu = -0.578, Lambdad0Pu = 0.765, Lambdaf0Pu = 1.045, Lambdaq0Pu = -0.661, LdPPu = 0.2, LfPPu = 0.107, LqPPu = 0.2, MdPPu = 1.6, MdPPuEfd = 0, MdPPuEfdNom = 0.634, MdSat0PPu = 1.489, MqPPu = 1.5, MqSat0PPu = 1.395, MrcPPu = 0, P0Pu = -7, PGen0Pu = -G2.P0Pu, PNomAlt = 800, PNomTurb = 900, Pm0Pu = 0.779, Q0Pu = -2.35, QGen0Pu = -G2.Q0Pu, QStator0Pu = -G2.Q0Pu, QStator0PuQNom = -G2.Q0Pu, RDPPu = 0.0177, RQ1PPu = 0.01297, RQ2PPu = 0.02167, RTfPu = 0, RaPPu = 0.0025, RfPPu = 0.00056, SNom = 900, SnTfo = G2.SNom, Theta0 = 0.8938, ThetaInternal0 = 0.7117, U0Pu = 1.01, UBaseHV = G2.UNom, UBaseLV = G2.UNom, UNom = 20, UNomHV = G2.UNom, UNomLV = G2.UNom, UPhase0 = 0.182, UStator0Pu = G2.U0Pu, Ud0Pu = 0.659, Uf0Pu = 0.0007, Uq0Pu = 0.764, XTfPu = 0, i0Pu = ComplexMath.conj(G2.s0Pu / G2.u0Pu), iStator0Pu = G2.i0Pu, lambdaT1 = 0.9, s0Pu = Complex(G2.P0Pu, G2.Q0Pu), sStator0Pu = G2.s0Pu, u0Pu = Complex(G2.U0Pu * cos(G2.UPhase0), G2.U0Pu * sin(G2.UPhase0)), uStator0Pu = G2.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-129, -39}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorFictitious G3(Alpha = 0, Beta = 0, PGen0Pu = P0PuG3, QGen0Pu = Q0PuG3, U0Pu = 1.03, i0Pu = ComplexMath.conj(Complex(P0PuG3, Q0PuG3) / G3.u0Pu), u0Pu = Complex(1.03, 0)) annotation(
    Placement(visible = true, transformation(origin = {264, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus slackBus(UPhase = 20.2 / 180 * Modelica.Constants.pi, UPu = 1.03)  annotation(
    Placement(visible = true, transformation(origin = {-264, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Machines.Simplified.GeneratorFictitious G4(Alpha = 0, Beta = 0, PGen0Pu = P0PuG4, QGen0Pu = Q0PuG4, U0Pu = 1.01, i0Pu = ComplexMath.conj(Complex(P0PuG4, Q0PuG4) / G4.u0Pu), u0Pu = Complex(1.01, 0)) annotation(
    Placement(visible = true, transformation(origin = {130, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(G2.terminal, bus02.terminal) annotation(
    Line(points = {{-130, -42}, {-130, -20}}, color = {0, 0, 255}));
  connect(G3.terminal, bus03.terminal) annotation(
    Line(points = {{264, 70}, {240, 70}}, color = {0, 0, 255}));
  G2.switchOffSignal1.value = false;
  G2.switchOffSignal2.value = false;
  G2.switchOffSignal3.value = false;
  G3.switchOffSignal1.value = false;
  G3.switchOffSignal2.value = false;
  G3.switchOffSignal3.value = false;
  G4.switchOffSignal1.value = false;
  G4.switchOffSignal2.value = false;
  G4.switchOffSignal3.value = false;
  der(G2.efdPu.value) = 0;
  der(G2.PmPu.value) = 0;
  G2.omegaRefPu.value = 1;

  connect(slackBus.terminal, bus01.terminal) annotation(
    Line(points = {{-264, 70}, {-240, 70}}, color = {0, 0, 255}));
  connect(G4.terminal, bus04.terminal) annotation(
    Line(points = {{130, -44}, {130, -20}}, color = {0, 0, 255}));
end KundurA;
