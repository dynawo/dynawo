within Dynawo.Examples.GridForming.Tests.Test_NodeFault;

model Droop_NodeFault "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
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
  extends Modelica.Icons.Example;
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.001, XPu = 0.01) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop DynGFMDroop(CFilterPu = 1e-05, IMaxVIPu = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = -9.44303759416221, Q0Pu = -0.9381894853914545, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9739263489847085, UPhase0 = 0.5006269558583454, Omegaf = 20, Omegaff = 60, XRratio = 10, XVIPu = 0.06, tVSC = 0.0004, Mp = 0.005, Omegac = 1000, OmegaPLL = 100, KsiPLL = 1, EpsVIUpPu = 0.01, EpsVIDownPu = 0.01) annotation(
    Placement(transformation(origin = {-27, 3}, extent = {{-23, -23}, {23, 23}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = 1000) annotation(
    Placement(transformation(origin = {18, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 1e-6, XPu = 1e-5, tBegin = 5, tEnd = 5.150) annotation(
    Placement(transformation(origin = {68, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations annotation(
    Placement(transformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  nodeFault.switchOffSignal1 = false;
  nodeFault.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal1 = false;
  DynGFMDroop.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal3 = false;
  connect(PRefPu.y, DynGFMDroop.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-102, 57}, {-52, 57}, {-52, 21}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMDroop.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-62, 20}, {-62, 12}, {-52, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMDroop.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-66, -20}, {-66, -6}, {-52, -6}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMDroop.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-100, -57}, {-52, -57}, {-52, -15}}, color = {0, 0, 127}));
  connect(DynGFMDroop.terminal, measurements.terminal1) annotation(
    Line(points = {{-2, 4}, {8, 4}, {8, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line.terminal1) annotation(
    Line(points = {{28, 0}, {70, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{90, 0}, {98, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, nodeFault.terminal) annotation(
    Line(points = {{70, 0}, {68, 0}, {68, -34}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    Documentation);
end Droop_NodeFault;
