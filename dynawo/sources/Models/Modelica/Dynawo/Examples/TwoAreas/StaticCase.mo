within Dynawo.Examples.TwoAreas;

model StaticCase "Kundur two-area system with buses, lines and transformers"
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

  Dynawo.Electrical.Machines.Simplified.GeneratorFictitious G2(Alpha = 0, Beta = 0, PGen0Pu = P0PuG2, QGen0Pu = Q0PuG2, U0Pu = 1.01, i0Pu = ComplexMath.conj(Complex(P0PuG2, Q0PuG2) / G2.u0Pu), u0Pu = Complex(1.01, 0))  annotation(
    Placement(visible = true, transformation(origin = {-130, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorFictitious G4(Alpha = 0, Beta = 0, PGen0Pu = P0PuG4, QGen0Pu = Q0PuG4, U0Pu = 1.01, i0Pu = ComplexMath.conj(Complex(P0PuG4, Q0PuG4) / G4.u0Pu), u0Pu = Complex(1.01, 0)) annotation(
    Placement(visible = true, transformation(origin = {130, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorFictitious G3(Alpha = 0, Beta = 0, PGen0Pu = P0PuG3, QGen0Pu = Q0PuG3, U0Pu = 1.03, i0Pu = ComplexMath.conj(Complex(P0PuG3, Q0PuG3) / G3.u0Pu), u0Pu = Complex(1.03, 0)) annotation(
    Placement(visible = true, transformation(origin = {264, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus slackBus(UPhase = 20.2 / 180 * Modelica.Constants.pi, UPu = 1.03)  annotation(
    Placement(visible = true, transformation(origin = {-264, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(G2.terminal, bus02.terminal) annotation(
    Line(points = {{-130, -42}, {-130, -20}}, color = {0, 0, 255}));
  connect(G4.terminal, bus04.terminal) annotation(
    Line(points = {{130, -44}, {130, -20}}, color = {0, 0, 255}));
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
  connect(slackBus.terminal, bus01.terminal) annotation(
    Line(points = {{-264, 70}, {-240, 70}}, color = {0, 0, 255}));
end StaticCase;
