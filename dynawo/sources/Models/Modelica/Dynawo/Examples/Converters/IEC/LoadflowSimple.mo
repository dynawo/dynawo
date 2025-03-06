within Dynawo.Examples.Converters.IEC;

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

model LoadflowSimple "Load flow model for the IEC63406 examples"

  Dynawo.Electrical.Machines.Simplified.GeneratorPVFixed Gen1(PGen0Pu = -0.5, QGen0Pu = 0, U0Pu = 1, i0Pu = Complex(-0.930285, -0.422694), u0Pu = Complex(0.976009, 0.217732))  annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line3(BPu = 0.01, GPu = 0, RPu = 0.01, XPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line4(BPu = 0.005, GPu = 0, RPu = 0.015, XPu = 0.025) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.1, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line2(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.2) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.0678, UEvtPu = 0, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 14, tOmegaEvtStart = 13, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation
  Gen1.switchOffSignal1.value = false;
  Gen1.switchOffSignal2.value = false;
  Gen1.switchOffSignal3.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  line4.switchOffSignal1.value = false;
  line4.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  transformer1.switchOffSignal1.value = false;
  transformer1.switchOffSignal2.value = false;

  connect(transformer1.terminal2, line4.terminal1) annotation(
    Line(points = {{-50, 0}, {-30, 0}}, color = {0, 0, 255}));
  connect(line4.terminal2, transformer.terminal1) annotation(
    Line(points = {{-10, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line.terminal1) annotation(
    Line(points = {{20, 0}, {40, 0}, {40, -20}}, color = {0, 0, 255}));
  connect(line.terminal2, line2.terminal1) annotation(
    Line(points = {{60, -20}, {80, -20}}, color = {0, 0, 255}));
  connect(line3.terminal2, line1.terminal1) annotation(
    Line(points = {{80, 20}, {100, 20}, {100, 0}, {120, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line3.terminal1) annotation(
    Line(points = {{20, 0}, {40, 0}, {40, 20}, {60, 20}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, line1.terminal2) annotation(
    Line(points = {{160, 0}, {140, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, line2.terminal2) annotation(
    Line(points = {{120, 0}, {100, 0}, {100, -20}}, color = {0, 0, 255}));
  connect(Gen1.terminal, transformer1.terminal1) annotation(
    Line(points = {{-100, 0}, {-70, 0}}, color = {0, 0, 255}));

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end LoadflowSimple;
