within Dynawo.Examples.PEIR.Plant.Simplified;

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

model GridFollowingPlantPropInt
  extends Modelica.Icons.Example;
  extends Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan;

  // Inputs
  Modelica.Blocks.Sources.Constant deltaPmRef(k = 0) annotation(
    Placement(transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}})));

  // Faults
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.09, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0.4, tBegin = 12, tEnd = 12.15) annotation(
    Placement(transformation(origin = {-90, -40}, extent = {{-10, 10}, {10, -10}})));

  Dynawo.Electrical.PEIR.Plant.Simplified.GridFollowingPlantPropInt gridFollowingPlantPropInt(SNom = 15, Ki = 10, Kp = 5, LambdaPuSNom = 0.21, PMax = 20, PNom = 15, QMaxPu = 99, QMaxRegPu = 0.6667, QMinPu = -99, QMinRegPu = -0.6667, P0Pu = -0.2, Q0Pu = 0.0439939, U0Pu = 1.06437, UPhase0 = 0.00808331, QReg0Pu = 0.0458447, UReg0Pu = 1.06648, VRegFlag = true) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  gridFollowingPlantPropInt.injector.switchOffSignal1.value = false;
  gridFollowingPlantPropInt.injector.switchOffSignal2.value = false;
  gridFollowingPlantPropInt.injector.switchOffSignal3.value = false;
  der(gridFollowingPlantPropInt.URefPu) = 0;
  gridFollowingPlantPropInt.URegPu = transformer1.U2Pu;
  gridFollowingPlantPropInt.QRegPu = transformer1.Q2Pu;

  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(gridFollowingPlantPropInt.terminal, transformer1.terminal1) annotation(
    Line(points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(gridFollowingPlantPropInt.terminal, nodeFault1.terminal) annotation(
    Line(points = {{-100, 0}, {-90, 0}, {-90, -40}}, color = {0, 0, 255}));
  connect(gridFollowingPlantPropInt.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{-121, -8}, {-126, -8}, {-126, -60}, {-139, -60}}, color = {0, 0, 127}));
  connect(deltaPmRef.y, gridFollowingPlantPropInt.deltaPmRefPu) annotation(
    Line(points = {{-139, -20}, {-131, -20}, {-131, -4}, {-121, -4}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {160, 60}})),
  experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001));
end GridFollowingPlantPropInt;
