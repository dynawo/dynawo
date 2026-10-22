within Dynawo.Examples.GridForming.PlantControl;

model DynGFMPlantControl "GFM with VSM control and a generic Plant Controller (compact plant model)"
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

  // Operating point at the PCC (plant terminal), consistent with acGrid at 1 /_ 0 behind line1
  parameter Types.ApparentPowerModule SNom = 1000 "Nominal apparent power module for the converter";
  parameter Types.VoltageModulePu UPcc0Pu = 1.02343286532015 "Start value of voltage amplitude at the PCC in pu (base UNom)";
  parameter Types.Angle UPccPhase0 = 0.0464048380960457 "Start value of voltage angle at the PCC in rad";
  parameter Types.ActivePowerPu PPcc0Pu = -9.89773532110073 "Start value of active power at the PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QPcc0Pu = -4.02696677575302 "Start value of reactive power at the PCC in pu (base SnRef) (receptor convention)";

  Modelica.Blocks.Sources.Constant URefPu(k = UPcc0Pu + dynVSMPlantControlFull.Lambd*QPcc0Pu) annotation(
    Placement(transformation(origin = {-74, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = PPcc0Pu) annotation(
    Placement(transformation(origin = {-70, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {4, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant URefGfmPu(k = dynVSMPlantControlFull.dynVSMPlantControl.DynGFMVSM.Control.URef0Pu) annotation(
    Placement(transformation(origin = {-74, -24}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005, XPu = 0.005) annotation(
    Placement(transformation(origin = {80, 44}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Controls.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(transformation(origin = {79, 21}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Controls.PEIR.BaseControls.Plant.DynVSMPlantControlFull dynVSMPlantControlFull(EpsVIUpPu = 0.01, EpsVIDownPu = 0.01, Omega0Pu = 0.99, OmegaRef0Pu = 1, SNom = SNom, UPcc0Pu = UPcc0Pu, UPccPhase0 = UPccPhase0, PPcc0Pu = PPcc0Pu, QPcc0Pu = QPcc0Pu, kVSM = 650, H = 5, KpVI = 0.6, XRratio = 10, IMaxVIPu = 1.2, Mq = 0.2, Kff = 0, Omegaf = 31.4159, Omegaff = 60, XVIPu = 0.06, Omegac = 1000, Kfd = 0.8, Kfq = 0, tVSC = 0.0002, Lambd = 0.01, Kdroop = 0, tQFilt = 0.1, tPFilt = 1, tUFilt = 0.1, Kpq = 0.1, Kiq = 1.0, Kpp = 0.3, Kip = 0.3, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, QMaxPu = 100, QMinPu = -100, PMaxPu = 100, PMinPu = -100, RFilterPu = 0.015, LFilterPu = 0.15, CFilterPu = 1e-5, RTransformerPu = 0.006, LTransformerPu = 0.06, OmegaPLL = 100, KsiPLL = 1, RPu = 0.0005, XPu = 0.005, GPu = 0, BPu = 0, RTfoPu = 0.0005, XTfoPu = 0.005, GTfoPu = 0, BTfoPu = 0, rTfoPu = 1) annotation(
    Placement(transformation(origin = {7, 3}, extent = {{-23, -23}, {23, 23}})));
  Dynawo.Electrical.Sources.AcGridRoCoF acGridRoCoF(RoCoFValue = 0.01, SNom = 1000, StartRoCoF = 10, StartingFrequency = -0.01, TimeRoCoF = 3, U0pu = 1, UPhase = 0, UPhase0 = 0, Upu = 1) annotation(
    Placement(transformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}})));
equation
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;
  connect(measurements.terminal1, line1.terminal2) annotation(
    Line(points = {{80, 26}, {80, 34}}, color = {0, 0, 255}));
  connect(dynVSMPlantControlFull.terminal, measurements.terminal2) annotation(
    Line(points = {{30, 4}, {80, 4}, {80, 16}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, dynVSMPlantControlFull.omegaRefPu) annotation(
    Line(points = {{4, 79}, {4, 28}, {8, 28}}, color = {0, 0, 127}));
  connect(PRefPu.y, dynVSMPlantControlFull.PRefPu) annotation(
    Line(points = {{-58, 36}, {-18, 36}, {-18, 18}}, color = {0, 0, 127}));
  connect(URefPu.y, dynVSMPlantControlFull.URefPu) annotation(
    Line(points = {{-62, 6}, {-18, 6}, {-18, -12}}, color = {0, 0, 127}));
  connect(URefGfmPu.y, dynVSMPlantControlFull.UFilterRefPu) annotation(
    Line(points = {{-62, -24}, {-28, -24}, {-28, -22}, {8, -22}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, acGridRoCoF.OmegaRef) annotation(
    Line(points = {{4, 80}, {38, 80}, {38, 76}}, color = {0, 0, 127}));
  connect(acGridRoCoF.aCPower, line1.terminal1) annotation(
    Line(points = {{62, 76}, {80, 76}, {80, 54}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram);
end DynGFMPlantControl;
