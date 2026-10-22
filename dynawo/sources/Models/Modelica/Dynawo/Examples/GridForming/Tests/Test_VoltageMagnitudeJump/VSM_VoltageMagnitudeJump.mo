within Dynawo.Examples.GridForming.Tests.Test_VoltageMagnitudeJump;

model VSM_VoltageMagnitudeJump "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
 /*
 * Copyright (c) 2026, RTE (http://www.rte-france.com)
 * See AUTHORS.txt
 * All rights reserved
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at http://mozilla.org/MPL/2.0/.
 * SPDX-License-Identifier: MPL-2.0
 *
 * This file is part of Dynawo, a hybrid C++/Modelica open source suite
 * of simulation tools for power systems.
 */
  extends Modelica.Icons.Example;
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(transformation(origin = {56, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 5, IMaxVIPu = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = -4.98488710832432, Q0Pu = 0.0110946151405571, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.992493005247463, UPhase0 = 0.253902907445225, Omegaf = 31.4159, Omegaff = 60, XRratio = 10, XVIPu = 0.06, kVSM = 650, tVSC = 0.0004, OmegaPLL = 1000, KsiPLL = 1, Omegac = 1000, EpsVIUpPu = 0.01, EpsVIDownPu = 0.01) annotation(
    Placement(transformation(origin = {-15, 1}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.5) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = 1000)  annotation(
    Placement(transformation(origin = {28, 2}, extent = {{-10, -10}, {10, 10}})));
 Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations annotation(
    Placement(transformation(origin = {88, 4}, extent = {{-10, -10}, {10, 10}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal1 = false;
  DynGFMVSM.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal3 = false;
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-50, 20}, {-50, 10}, {-40, 10}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-60, -20}, {-60, -8}, {-40, -8}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMVSM.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-56, -60}, {-56, -17}, {-40, -17}}, color = {0, 0, 127}));
  connect(PRefPu.y, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-102, 19}, {-40, 19}}, color = {0, 0, 127}));
  connect(DynGFMVSM.terminal, measurements.terminal1) annotation(
    Line(points = {{10, 2}, {18, 2}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line.terminal1) annotation(
    Line(points = {{38, 2}, {46, 2}}, color = {0, 0, 255}));
 connect(line.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{66, 2}, {88, 2}, {88, 4}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    Documentation,
    Diagram);
end VSM_VoltageMagnitudeJump;
