within Dynawo.Examples.PEIR.Plants.Simplified;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GFLPlantPropInt
  extends Modelica.Icons.Example;
  extends Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan(infiniteBusWithVariations(UEvtPu = 1, tUEvtStart = 2, tUEvtEnd = 4, tOmegaEvtStart = 30, tOmegaEvtEnd = 31));

  // Inputs
  Modelica.Blocks.Sources.Constant deltaPmRef(k = 0) annotation(
    Placement(transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step URefStep(offset = gflPlantPropInt.URef0Pu, height = 0.05, startTime = 10) annotation(
    Placement(transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.PEIR.Plants.Simplified.GFLPlantPropInt gflPlantPropInt(SNom = 15, Ki = 10, Kp = 5, LambdaPuSNom = 0.21, PMax = 20, PNom = 15, QMaxPu = 99, QMaxRegPu = 99, QMinPu = -99, QMinRegPu = -99, P0Pu = -0.2, Q0Pu = 0.0439939, U0Pu = 1.06437, UPhase0 = 0.00808331, QReg0Pu = 0.0458447, UReg0Pu = 1.06648, VRegFlag = true, DbdPu = 0.05) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  gflPlantPropInt.injector.switchOffSignal1 = false;
  gflPlantPropInt.injector.switchOffSignal2 = false;
  gflPlantPropInt.injector.switchOffSignal3 = false;
  connect(gflPlantPropInt.URegPu, transformer.U2Pu);
  connect(gflPlantPropInt.QRegPu, transformer.Q2Pu);

  connect(gflPlantPropInt.terminal, transformer.terminal1) annotation(
    Line(points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(gflPlantPropInt.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{-121, -8}, {-126, -8}, {-126, -60}, {-139, -60}}, color = {0, 0, 127}));
  connect(deltaPmRef.y, gflPlantPropInt.deltaPmRefPu) annotation(
    Line(points = {{-139, -20}, {-131, -20}, {-131, -4}, {-121, -4}}, color = {0, 0, 127}));
  connect(gflPlantPropInt.URefPu, URefStep.y) annotation(
    Line(points = {{-120, 0}, {-130, 0}, {-130, 20}, {-138, 20}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {160, 60}})),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001));
end GFLPlantPropInt;
