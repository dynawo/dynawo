within Dynawo.Examples.GridForming;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model EpriSmib
  extends Icons.Example;
  
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.5, UPhase = 0, omega0Pu = 1, omegaEvtPu = 0.999, tOmegaEvtEnd = 20, tOmegaEvtStart = 10, tUEvtEnd = 10.2, tUEvtStart = 10) annotation(
    Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.00995, XPu = 0.284504, state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {-2, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.EpriGFM epriGfm(BPu = 0, CFilter = 0, DeltaVVId0 = 0, DeltaVVIq0 = 0, GPu = 0, IMaxPu = 1.2, IdConv0Pu = 0, IdPcc0Pu = 0, IqConv0Pu = 0, IqPcc0Pu = 0, Ki = 700, Kii = 20, Kip = 20, Kiv = 150 - 140, Kp = 20, Kpi = 0.5, Kpp = 0.5, Kpv = 0.5 + 2.5, LFilter = 0.1, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, PFilter0Pu = 0, PQflag = false, PRef0Pu = 0, Pref0Pu = 0.5, QDroop = 0.045, QFilter0Pu = 0, QRef0Pu = 0, RFilter = 0.00015, RPu = 0.00015 * 1, SNom = 100, Theta0 = 0, UFilterRef0Pu = 0, UdConv0Pu = 1, UdFilter0Pu = 1, UqConv0Pu = 0, UqFilter0Pu = 0, VDipPu = 0.8, XPu = 0.1, dd = 0.11, deltawmax = 75 / 314.15, deltawmin = -75 / 314.15, i0Pu = Complex(0, 0), k1 = 0.033, k2 = 0.045, k2dvoc = 1e-9, kd = 0.033 * 0.11 * 0, mf = 0.15, tE = 0.01, tf = 0.15 * 0.033 * 1e-9, tr = 0.005, tv = 1e-9, u0Pu = Complex(1.0, 0), wDroop = 0.033, wflag = 1) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-82, 0}, {-22, 0}}, color = {0, 0, 255}));
  connect(epriGfm.terminal, line.terminal2) annotation(
    Line(points = {{60, 0}, {18, 0}}, color = {0, 0, 255}));

annotation(uses(Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-6, Interval = 0.02));
end EpriSmib;
