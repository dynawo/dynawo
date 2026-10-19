within Dynawo.Examples.GridForming.PlantControl;

model DynGFMDroopPlantControl "GFM with Droop control and a generic Plant Controller (compact plant model)"
  /*
  * Copyright (c) 2026, RTE (http://www.rte-france.com)
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
  extends Modelica.Icons.Example;

  // Operating point at the PCC (plant terminal), consistent with AcGrid at 1 /_ 0 behind line1
  parameter Types.ApparentPowerModule SNom = 1000 "Nominal apparent power module for the converter";
  parameter Types.VoltageModulePu UPcc0Pu = 0.995667946619379 "Start value of voltage amplitude at the PCC in pu (base UNom)";
  parameter Types.Angle UPccPhase0 = 0.0477619859090303 "Start value of voltage angle at the PCC in rad";
  parameter Types.ActivePowerPu PPcc0Pu = -9.35033980050001 "Start value of active power at the PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QPcc0Pu = 1.570601995 "Start value of reactive power at the PCC in pu (base SnRef) (receptor convention)";

  Modelica.Blocks.Sources.Constant URefPu(k = UPcc0Pu + dynDroopPlantControlFull.Lambd*QPcc0Pu) annotation(
    Placement(transformation(origin = {-74, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = PPcc0Pu) annotation(
    Placement(transformation(origin = {-70, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-16, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant URefGfmPu(k = dynDroopPlantControlFull.dynDroopPlantControl.dynGFMDroop.ControlDroop.URef0Pu) annotation(
    Placement(transformation(origin = {-74, -24}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.PEIR.BaseControls.Plant.DynDroopPlantControlFull dynDroopPlantControlFull(EpsVIUpPu = 0.01, EpsVIDownPu = 0.01, Omega0Pu = 0.99, OmegaRef0Pu = 1, SNom = SNom, UPcc0Pu = UPcc0Pu, UPccPhase0 = UPccPhase0, PPcc0Pu = PPcc0Pu, QPcc0Pu = QPcc0Pu, CFilterPu = 1e-05, IMaxVIPu = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, KpVI = 0.1, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.013, RFilterPu = 0.015, RTransformerPu = 0.006, Omegaf = 40, Omegaff = 50, XRratio = 10, XVIPu = 0.06, tVSC = 0.0004, Mp = 0.013, Omegac = 1000, OmegaPLL = 100, KsiPLL = 1, Lambd = 0.01, Kdroop = 0.01, tQFilt = 0.1, tPFilt = 0.1, tUFilt = 0.1, Kpq = 0.1, Kiq = 1.0, Kpp = 0.3, Kip = 0.3, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, QMaxPu = 100, QMinPu = -100, PMaxPu = 12, PMinPu = -12, RPu = 0.0005, XPu = 0.005, GPu = 0, BPu = 0, RTfoPu = 0.0005, XTfoPu = 0.005, GTfoPu = 0, BTfoPu = 0, rTfoPu = 1) annotation(
    Placement(transformation(origin = {-16, 6}, extent = {{-22, -22}, {22, 22}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(transformation(origin = {49, 5}, extent = {{-5, -5}, {5, 5}})));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005, XPu = 0.005) annotation(
    Placement(transformation(origin = {76, 4}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.AcGridRoCoF acGridRoCoF(RoCoFValue = 0.01, SNom = 1000, StartRoCoF = 10, StartingFrequency = -0.01, TimeRoCoF = 3, U0pu = 1, UPhase = 0, UPhase0 = 0, Upu = 1) annotation(
    Placement(transformation(origin = {56, 60}, extent = {{-10, -10}, {10, 10}})));
equation
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;
  connect(URefGfmPu.y, dynDroopPlantControlFull.UFilterRefPu) annotation(
    Line(points = {{-62, -24}, {-16, -24}, {-16, -18}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, dynDroopPlantControlFull.omegaRefPu) annotation(
    Line(points = {{-16, 72}, {-16, 30}}, color = {0, 0, 127}));
  connect(PRefPu.y, dynDroopPlantControlFull.PRefPu) annotation(
    Line(points = {{-58, 36}, {-52, 36}, {-52, 19}, {-40, 19}}, color = {0, 0, 127}));
  connect(URefPu.y, dynDroopPlantControlFull.URefPu) annotation(
    Line(points = {{-62, 6}, {-50, 6}, {-50, -7}, {-40, -7}}, color = {0, 0, 127}));
  connect(dynDroopPlantControlFull.terminal, measurements.terminal1) annotation(
    Line(points = {{5, 6}, {44, 6}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line1.terminal1) annotation(
    Line(points = {{54, 6}, {66, 6}, {66, 4}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, acGridRoCoF.OmegaRef) annotation(
    Line(points = {{-16, 72}, {44, 72}, {44, 66}}, color = {0, 0, 127}));
  connect(acGridRoCoF.aCPower, line1.terminal2) annotation(
    Line(points = {{68, 66}, {86, 66}, {86, 4}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram);
end DynGFMDroopPlantControl;
