within Dynawo.Examples.GridForming.Tests.VoltageMagnitudeJump;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model Droop "Droop grid-forming converter (DynGFMDroop) connected to an infinite bus through a line: step of the infinite bus voltage magnitude"
  extends Modelica.Icons.Example;

  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {-92, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {-90, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop DynGFMDroop(CFilterPu = 1e-05,IMaxVIPu = 1.2,Kfd = 1,Kff = 0, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.013, P0Pu = -9.44303759416221, Q0Pu = -0.9381894853914545, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9739263489847085, UPhase0 = 0.5006269558583454, Omegaf = 40, Omegaff = 50, XRratio = 10, XVIPu = 0.06, tVSC = 0.0004, Mp = 0.3, Omegac = 1000, OmegaPLL = 100, OmegaMaxPLLPu = 10, OmegaMinPLLPu = -10, KsiPLL = 1, EpsVIUpPu = 0.01, EpsVIDownPu = 0.01) annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.Utilities.Measurements measurements(SNom = 1000) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 1, omega0Pu = 1, omegaEvtPu = 1, UPhase = 0, tUEvtStart = 0, tUEvtEnd = 0, tOmegaEvtStart = 0, tOmegaEvtEnd = 0) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal1 = false;
  DynGFMDroop.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal3 = false;

  connect(PRefPu.y, DynGFMDroop.PFilterRefPu) annotation(
    Line(points = {{-79, 60}, {-79, 61}, {-50, 61}, {-50, 15.5}, {-42, 15.5}, {-42, 16}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMDroop.omegaRefPu) annotation(
    Line(points = {{-79, 20}, {-62, 20}, {-62, 8}, {-42, 8}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMDroop.QFilterRefPu) annotation(
    Line(points = {{-81, -20}, {-66, -20}, {-66, -8}, {-42, -8}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMDroop.UFilterRefPu) annotation(
    Line(points = {{-79, -60}, {-79, -59.5}, {-51, -59.5}, {-51, -15}, {-42, -15}, {-42, -16}}, color = {0, 0, 127}));
  connect(DynGFMDroop.terminal, measurements.terminal1) annotation(
    Line(points = {{2, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line.terminal1) annotation(
    Line(points = {{40, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{80, 0}, {100, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    Documentation);
end Droop;
