within Dynawo.Examples.GridCodeSimulations.BaseSheetSimulations;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseSheetI10
  extends BaseParameters;

  Electrical.Buses.Bus bus annotation(
    Placement(transformation(origin = {-80, 0},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Electrical.Loads.LoadAlphaBeta loadAlphaBeta(u0Pu = Complex(1, 0), s0Pu = Complex(0.8*SNom/Electrical.SystemBase.SnRef, 0), i0Pu = Modelica.ComplexMath.conj(loadAlphaBeta.s0Pu/loadAlphaBeta.u0Pu), alpha = 0, beta = 0) annotation(
    Placement(transformation(origin = {-80, -60}, extent = {{-20, -20}, {20, 20}})));
  Electrical.Sources.InertialGrid.InertialGrid inertialGrid1(DPu = 0, Fh = 1, H = 1, Km = 1, P0Pu = 0, Q0Pu = 0, R = 999999, SNom = SNom, Tr = 0.1, U0Pu = 1, UPhase0 = 0) annotation(
    Placement(transformation(origin = {-180, 0}, extent = {{-20, -20}, {20, 20}})));
  Electrical.Lines.Line line(RPu = 0, GPu = 0, BPu = 0, XPu = XbPu) annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

equation
  // No variations in PspPu for the inertial grid
  der(inertialGrid1.reducedOrderSFR.PspPu) = 0;

  // Step orders for the load
  loadAlphaBeta.PRefPu = if time < 2 then 0.8 * SNom / Electrical.SystemBase.SnRef else 0.9 * SNom / Electrical.SystemBase.SnRef;
  loadAlphaBeta.QRefPu = if time < 2 then 0 else 0.04  * SNom / Electrical.SystemBase.SnRef;
  der(loadAlphaBeta.deltaQ) = 0;
  der(loadAlphaBeta.deltaP) = 0;

  // Switches
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  inertialGrid1.injectorURI.switchOffSignal1 = false;
  inertialGrid1.injectorURI.switchOffSignal2 = false;
  inertialGrid1.injectorURI.switchOffSignal3 = false;
  loadAlphaBeta.switchOffSignal1 = false;
  loadAlphaBeta.switchOffSignal2 = false;

  connect(loadAlphaBeta.terminal, bus.terminal) annotation(
    Line(points = {{-80, -60}, {-80, 0}}, color = {0, 0, 255}));
  connect(inertialGrid1.omegaPu, inertialGrid1.omegaRefPu) annotation(
    Line(points = {{-160, 16}, {-140, 16}, {-140, 40}, {-180, 40}, {-180, 24}}, color = {0, 0, 127}));
  connect(inertialGrid1.terminal, line.terminal2) annotation(
    Line(points = {{-180.857, 0}, {-139.857, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, bus.terminal) annotation(
    Line(points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram");
end BaseSheetI10;
