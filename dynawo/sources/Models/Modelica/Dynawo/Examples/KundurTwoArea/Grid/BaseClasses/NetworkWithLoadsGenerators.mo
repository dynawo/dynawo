within Dynawo.Examples.KundurTwoArea.Grid.BaseClasses;

model NetworkWithLoadsGenerators "Kundur two-area system with buses, lines and transformers, loads, shunts and generators."
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
  extends Dynawo.Examples.KundurTwoArea.Grid.BaseClasses.Network;
  Dynawo.Electrical.Loads.LoadPQ load07(s0Pu = s0PuLoad07, u0Pu = Complex(1, 0), i0Pu = s0PuLoad07) annotation(
    Placement(visible = true, transformation(origin = {-72, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ load09(s0Pu = s0PuLoad09, u0Pu = Complex(1, 0), i0Pu = s0PuLoad09) annotation(
    Placement(visible = true, transformation(origin = {72, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  // loads
  parameter Types.ActivePower P0MwLoad07;
  parameter Types.ReactivePower Q0MwLoad07;
  final parameter Types.ComplexApparentPowerPu s0PuLoad07 = Complex(P0MwLoad07, P0MwLoad07)/Electrical.SystemBase.SnRef;

  parameter Types.ActivePower P0MwLoad09;
  parameter Types.ReactivePower Q0MwLoad09;
  final parameter Types.ComplexApparentPowerPu s0PuLoad09 = Complex(P0MwLoad09, P0MwLoad09)/Electrical.SystemBase.SnRef;
  
  
equation
  connect(load07.terminal, bus07.terminal) annotation(
    Line(points = {{-72, 36}, {-72, 64}, {-60, 64}, {-60, 70}}, color = {0, 0, 255}));
  connect(load09.terminal, bus09.terminal) annotation(
    Line(points = {{72, 36}, {72, 64}, {60, 64}, {60, 70}}, color = {0, 0, 255}));  end NetworkWithLoadsGenerators;
