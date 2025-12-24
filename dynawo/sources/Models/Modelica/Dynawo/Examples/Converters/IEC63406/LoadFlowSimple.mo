within Dynawo.Examples.Converters.IEC63406;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model LoadFlowSimple "Load flow model for the IEC63406 examples"

  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed Gen1(PGen0Pu = 0.5, QGen0Pu = 0, U0Pu = 1, i0Pu = Complex(-0.930285, -0.422694), u0Pu = Complex(0.976009, 0.217732))  annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.000315, UEvtPu = 0, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 14, tOmegaEvtStart = 13, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  Gen1.switchOffSignal1.value = false;
  Gen1.switchOffSignal2.value = false;
  Gen1.switchOffSignal3.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(infiniteBusWithVariations.terminal, line.terminal2) annotation(
    Line(points = {{100, 0}, {10, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, Gen1.terminal) annotation(
    Line(points = {{-10, 0}, {-100, 0}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end LoadFlowSimple;
