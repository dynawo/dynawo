within Dynawo.Examples.TwoAreas;

model Kundur1 "Kundur two-area system with buses, lines and transformers"
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
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousKundur6thOrder G1(ASat = 0.015, BSat = 9.6, Ce0Pu = 0.779, Cm0Pu = 0.779, DPu = 0, Efd0Pu = 2.0145, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParametersKundur6thOrder.ExcitationPuType.NoLoad, H = 6.5, IRotor0Pu = 2.0145, IStator0Pu = ComplexMath.'abs'(G1.iStator0Pu), Id0Pu = -0.8289, If0Pu = 1.259, Iq0Pu = -0.431, LDPPu = 0.1, LQ1PPu = 0.4565, LQ2PPu = 0.058, LambdaAD0Pu = 0.901, LambdaAQ0Pu = -0.599, LambdaAirGap0Pu = 1.0823, LambdaD0Pu = 0.90, LambdaQ10Pu = -0.599, LambdaQ20Pu = -0.599, Lambdad0Pu = 0.770, Lambdaf0Pu = 1.035, Lambdaq0Pu = -0.686, LdPPu = 0.2, LfPPu = 0.107, LqPPu = 0.2, MdPPu = 1.6, MdPPuEfd = 0, MdPPuEfdNom = 0.634, MdSat0PPu = 1.481, MqPPu = 1.5, MqSat0PPu = 1.389, MrcPPu = 0, P0Pu = -7, PGen0Pu = -G1.P0Pu, PNomAlt = 800, PNomTurb = 900, Pm0Pu = 0.779, Q0Pu = -1.85, QGen0Pu = -G1.Q0Pu, QStator0Pu = G1.Q0Pu, RDPPu = 0.0177, RQ1PPu = 0.01297, RQ2PPu = 0.02167, RTfPu = 0, RaPPu = 0.0025, RfPPu = 0.00056, SNom = 900, SnTfo = G1.SNom, Theta0 = 1.0793, ThetaInternal0 = 0.7268, U0Pu = 1.03, UBaseHV = G1.UNom, UBaseLV = G1.UNom, UNom = 20, UNomHV = G1.UNom, UNomLV = G1.UNom, UPhase0 = 20.2 / 180 * Modelica.Constants.pi, UStator0Pu = G1.U0Pu, Ud0Pu = 0.684, Uf0Pu = 0.0007, Uq0Pu = 0.769, XTfPu = 0, i0Pu = ComplexMath.conj(G1.s0Pu / G1.u0Pu), iStator0Pu = G1.i0Pu, lambdaT1 = 0.9, s0Pu = Complex(G1.P0Pu, G1.Q0Pu), sStator0Pu = G1.s0Pu, u0Pu = Complex(G1.U0Pu * cos(G1.UPhase0), G1.U0Pu * sin(G1.UPhase0)), uStator0Pu = G1.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-273, 69}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousKundur6thOrder G2(ASat = 0.015, BSat = 9.6, Ce0Pu = 0.779, Cm0Pu = 0.779, DPu = 0, Efd0Pu = 2.0906, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParametersKundur6thOrder.ExcitationPuType.NoLoad, H = 6.5, IRotor0Pu = 2.0906, IStator0Pu = ComplexMath.'abs'(G2.iStator0Pu), Id0Pu = -0.698, If0Pu = 1.306, Iq0Pu = -0.414, LDPPu = 0.1, LQ1PPu = 0.4565, LQ2PPu = 0.058, LambdaAD0Pu = 0.906, LambdaAQ0Pu = -0.578, LambdaAirGap0Pu = 1.0745, LambdaD0Pu = 0.90, LambdaQ10Pu = -0.578, LambdaQ20Pu = -0.578, Lambdad0Pu = 0.765, Lambdaf0Pu = 1.045, Lambdaq0Pu = -0.661, LdPPu = 0.2, LfPPu = 0.107, LqPPu = 0.2, MdPPu = 1.6, MdPPuEfd = 0, MdPPuEfdNom = 0.634, MdSat0PPu = 1.489, MqPPu = 1.5, MqSat0PPu = 1.395, MrcPPu = 0, P0Pu = -7, PGen0Pu = -G2.P0Pu, PNomAlt = 800, PNomTurb = 900, Pm0Pu = 0.779, Q0Pu = -2.35, QGen0Pu = -G2.Q0Pu, QStator0Pu = G2.Q0Pu, RDPPu = 0.0177, RQ1PPu = 0.01297, RQ2PPu = 0.02167, RTfPu = 0, RaPPu = 0.0025, RfPPu = 0.00056, SNom = 900, SnTfo = G2.SNom, Theta0 = 0.8938, ThetaInternal0 = 0.7117, U0Pu = 1.01, UBaseHV = G2.UNom, UBaseLV = G2.UNom, UNom = 20, UNomHV = G2.UNom, UNomLV = G2.UNom, UPhase0 = 0.182, UStator0Pu = G2.U0Pu, Ud0Pu = 0.659, Uf0Pu = 0.0007, Uq0Pu = 0.764, XTfPu = 0, i0Pu = ComplexMath.conj(G2.s0Pu / G2.u0Pu), iStator0Pu = G2.i0Pu, lambdaT1 = 0.9, s0Pu = Complex(G2.P0Pu, G2.Q0Pu), sStator0Pu = G2.s0Pu, u0Pu = Complex(G2.U0Pu * cos(G2.UPhase0), G2.U0Pu * sin(G2.UPhase0)), uStator0Pu = G2.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-129, -39}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousKundur6thOrder G4(ASat = 0.015, BSat = 9.6, Ce0Pu = 0.779, Cm0Pu = 0.779, DPu = 0, Efd0Pu = 2.038, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParametersKundur6thOrder.ExcitationPuType.NoLoad, H = 6.175, IRotor0Pu = 2.038, IStator0Pu = ComplexMath.'abs'(G4.iStator0Pu), Id0Pu = -0.680, If0Pu = 1.274, Iq0Pu = -0.423, LDPPu = 0.1, LQ1PPu = 0.4565, LQ2PPu = 0.058, LambdaAD0Pu = 0.887, LambdaAQ0Pu = -0.593, LambdaAirGap0Pu = 1.067, LambdaD0Pu = 0.887, LambdaQ10Pu = -0.593, LambdaQ20Pu = -0.593, Lambdad0Pu = 0.751, Lambdaf0Pu = 1.023, Lambdaq0Pu = -0.677, LdPPu = 0.2, LfPPu = 0.107, LqPPu = 0.2, MdPPu = 1.6, MdPPuEfd = 0, MdPPuEfdNom = 0.634, MdSat0PPu = 1.495, MqPPu = 1.5, MqSat0PPu = 1.401, MrcPPu = 0, P0Pu = -7, PGen0Pu = -G4.P0Pu, PNomAlt = 800, PNomTurb = 900, Pm0Pu = 0.779, Q0Pu = -2.02, QGen0Pu = -G4.Q0Pu, QStator0Pu = G4.Q0Pu, RDPPu = 0.0177, RQ1PPu = 0.01297, RQ2PPu = 0.02167, RTfPu = 0, RaPPu = 0.0025, RfPPu = 0.00056, SNom = 900, SnTfo = G4.SNom, Theta0 = 0.435, ThetaInternal0 = 0.733, U0Pu = 1.01, UBaseHV = G4.UNom, UBaseLV = G4.UNom, UNom = 20, UNomHV = G4.UNom, UNomLV = G4.UNom, UPhase0 = -0.298, UStator0Pu = G4.U0Pu, Ud0Pu = 0.676, Uf0Pu = 0.0007, Uq0Pu = 0.750, XTfPu = 0, i0Pu = ComplexMath.conj(G4.s0Pu / G4.u0Pu), iStator0Pu = G4.i0Pu, lambdaT1 = 0.9, s0Pu = Complex(G4.P0Pu, G4.Q0Pu), sStator0Pu = G4.s0Pu, u0Pu = Complex(G4.U0Pu * cos(G4.UPhase0), G4.U0Pu * sin(G4.UPhase0)), uStator0Pu = G4.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {129, -39}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousKundur6thOrder G3(ASat = 0.015, BSat = 9.6, Ce0Pu = 0.8, Cm0Pu = 0.8, DPu = 0, Efd0Pu = 2.026, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParametersKundur6thOrder.ExcitationPuType.NoLoad, H = 6.175, IRotor0Pu = 2.026, IStator0Pu = ComplexMath.'abs'(G3.iStator0Pu), Id0Pu = -0.666, If0Pu = 1.266, Iq0Pu = -0.440, LDPPu = 0.1, LQ1PPu = 0.4565, LQ2PPu = 0.058, LambdaAD0Pu = 0.890, LambdaAQ0Pu = -0.612, LambdaAirGap0Pu = 1.081, LambdaD0Pu = 0.890, LambdaQ10Pu = -0.612, LambdaQ20Pu = -0.612, Lambdad0Pu = 0.757, Lambdaf0Pu = 1.025, Lambdaq0Pu = -0.700, LdPPu = 0.2, LfPPu = 0.107, LqPPu = 0.2, MdPPu = 1.6, MdPPuEfd = 0, MdPPuEfdNom = 0.634, MdSat0PPu = 1.483, MqPPu = 1.5, MqSat0PPu = 1.390, MrcPPu = 0, P0Pu = -7.19, PGen0Pu = -G3.P0Pu, PNomAlt = 800, PNomTurb = 900, Pm0Pu = 0.8, Q0Pu = -1.76, QGen0Pu = -G3.Q0Pu, QStator0Pu = G3.Q0Pu, RDPPu = 0.0177, RQ1PPu = 0.01297, RQ2PPu = 0.02167, RTfPu = 0, RaPPu = 0.0025, RfPPu = 0.00056, SNom = 900, SnTfo = G3.SNom, Theta0 = 0.626, ThetaInternal0 = 0.746, U0Pu = 1.03, UBaseHV = G3.UNom, UBaseLV = G3.UNom, UNom = 20, UNomHV = G3.UNom, UNomLV = G3.UNom, UPhase0 = -0.120, UStator0Pu = G3.U0Pu, Ud0Pu = 0.699, Uf0Pu = 0.0007, Uq0Pu = 0.756, XTfPu = 0, i0Pu = ComplexMath.conj(G3.s0Pu / G3.u0Pu), iStator0Pu = G3.i0Pu, lambdaT1 = 0.9, s0Pu = Complex(G3.P0Pu, G3.Q0Pu), sStator0Pu = G3.s0Pu, u0Pu = Complex(G3.U0Pu * cos(G3.UPhase0), G3.U0Pu * sin(G3.UPhase0)), uStator0Pu = G3.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {261, 69}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  // Center of inertia's speed
  Types.AngularVelocityPu omegacoiPu;

  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional gover(KGover=200, PMax = G1.PNomTurb, PMin = 0, PNom = G1.PNomTurb, Pm0Pu = G1.Pm0Pu);
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional gover2(KGover=200, PMax = G2.PNomTurb, PMin = 0, PNom = G2.PNomTurb, Pm0Pu = G2.Pm0Pu);
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional gover3(KGover=200, PMax = G3.PNomTurb, PMin = 0, PNom = G3.PNomTurb, Pm0Pu = G3.Pm0Pu);
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional gover4(KGover=200, PMax = G4.PNomTurb, PMin = 0, PNom = G4.PNomTurb, Pm0Pu = G4.Pm0Pu);
equation
  G1.switchOffSignal1.value = false;
  G1.switchOffSignal2.value = false;
  G1.switchOffSignal3.value = false;
  G2.switchOffSignal1.value = false;
  G2.switchOffSignal2.value = false;
  G2.switchOffSignal3.value = false;
  G3.switchOffSignal1.value = false;
  G3.switchOffSignal2.value = false;
  G3.switchOffSignal3.value = false;
  G4.switchOffSignal1.value = false;
  G4.switchOffSignal2.value = false;
  G4.switchOffSignal3.value = false;
  G1.efdPu.value = 2.0145;
  gover.PmPu = G1.PmPu.value;
  gover.omegaPu = G1.omegaPu.value;
  gover.PmRefPu = 0.779;
  gover.deltaPmRefPu = 0;
  G1.omegaRefPu.value = omegacoiPu;
  G2.efdPu.value = 2.0906;
  gover2.PmPu = G2.PmPu.value;
  gover2.omegaPu = G2.omegaPu.value;
  gover2.PmRefPu = 0.779;
  gover2.deltaPmRefPu = 0;
  G2.omegaRefPu.value = omegacoiPu;
  G3.efdPu.value = 2.026;
  gover3.PmPu = G3.PmPu.value;
  gover3.omegaPu = G3.omegaPu.value;
  gover3.PmRefPu = 0.8;
  gover3.deltaPmRefPu = 0;
  G3.omegaRefPu.value = omegacoiPu;
  G4.efdPu.value = 2.038;
  gover4.PmPu = G4.PmPu.value;
  gover4.omegaPu = G4.omegaPu.value;
  gover4.PmRefPu = 0.779;
  gover4.deltaPmRefPu = 0;
  G4.omegaRefPu.value = omegacoiPu;
  omegacoiPu = (G1.omegaPu.value * G1.H * G1.SNom + G2.omegaPu.value * G2.H * G2.SNom + G3.omegaPu.value * G3.H * G3.SNom + G4.omegaPu.value * G4.H * G4.SNom) / (G1.H * G1.SNom + G2.H * G2.SNom + G3.H * G3.SNom + G4.H * G4.SNom);
  connect(G1.terminal, bus01.terminal) annotation(
    Line(points = {{-272, 70}, {-240, 70}}, color = {0, 0, 255}));
  connect(G2.terminal, bus02.terminal) annotation(
    Line(points = {{-128, -38}, {-130, -38}, {-130, -20}}, color = {0, 0, 255}));
  connect(bus04.terminal, G4.terminal) annotation(
    Line(points = {{130, -20}, {130, -29}, {129, -29}, {129, -39}}, color = {0, 0, 255}));
  connect(G3.terminal, bus03.terminal) annotation(
    Line(points = {{262, 70}, {240, 70}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -100}, {300, 100}})),
    Icon(coordinateSystem(extent = {{-300, -100}, {300, 100}})));
end Kundur1;
