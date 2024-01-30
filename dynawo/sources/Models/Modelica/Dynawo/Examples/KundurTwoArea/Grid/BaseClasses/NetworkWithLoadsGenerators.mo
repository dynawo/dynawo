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
  extends Dynawo.Examples.KundurTwoArea.Grid.BaseClasses.NetworkWithLoads;
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen01 annotation(
    Placement(visible = true, transformation(origin = {-270, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen04 annotation(
    Placement(visible = true, transformation(origin = {270, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen03 annotation(
    Placement(visible = true, transformation(origin = {130, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed gen02 annotation(
    Placement(visible = true, transformation(origin = {-130, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(gen01.terminal, bus01.terminal) annotation(
    Line(points = {{-270, 70}, {-240, 70}}, color = {0, 0, 255}));
  connect(gen02.terminal, bus02.terminal) annotation(
    Line(points = {{-130, -48}, {-130, -20}}, color = {0, 0, 255}));
  connect(gen03.terminal, bus04.terminal) annotation(
    Line(points = {{130, -46}, {130, -20}}, color = {0, 0, 255}));
  connect(bus03.terminal, gen04.terminal) annotation(
    Line(points = {{240, 70}, {270, 70}}, color = {0, 0, 255}));
annotation(
    Diagram,
    Icon);
end NetworkWithLoadsGenerators;
