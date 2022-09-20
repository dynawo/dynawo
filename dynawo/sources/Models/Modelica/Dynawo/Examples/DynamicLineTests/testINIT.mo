within Dynawo.Examples.DynamicLineTests;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model testINIT "Initialization of dynamic lines for the test model"

  import Modelica;
  import Dynawo;
  import Dynawo.Electrical.SystemBase;

  extends Icons.Example;

  parameter Types.PerUnit CPu = 0.0375;
  parameter Types.PerUnit RPu = 0.00375;
  parameter Types.PerUnit LPu = 3.75e-05;
  parameter Types.PerUnit GPu = 0.000375;

  Dynawo.Electrical.Buses.InfiniteBus infiniteBus2(UPhase = 0, UPu = 1.01779) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = CPu/2, GPu = GPu/2 , XPu = LPu/2 , RPu = RPu/2) annotation(
    Placement(visible = true, transformation(origin = {-30, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = CPu/2, GPu = GPu/2, XPu = LPu/2 , RPu = RPu/2) annotation(
    Placement(visible = true, transformation(origin = {10, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus3(UPhase = 0.1, UPu = 1.01645) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line2(BPu = CPu, GPu = GPu, RPu = RPu, XPu = LPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  connect(line1.terminal2, infiniteBus3.terminal) annotation(
    Line(points = {{20, 12}, {30, 12}, {30, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, infiniteBus2.terminal) annotation(
    Line(points = {{-40, 12}, {-50, 12}, {-50, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, line1.terminal1) annotation(
    Line(points = {{-20, 12}, {0, 12}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus2.terminal) annotation(
    Line(points = {{-20, -12}, {-50, -12}, {-50, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBus3.terminal) annotation(
    Line(points = {{0, -12}, {30, -12}, {30, 0}, {40, 0}}, color = {0, 0, 255}));


  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
    This model is an initialization of the dynamic lines parameters for the test.mo model, for a given line confguration, it calculates the line initial currents values.
</body></html>"));
end testINIT;
