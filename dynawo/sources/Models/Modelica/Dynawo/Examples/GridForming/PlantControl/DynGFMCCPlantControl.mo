within Dynawo.Examples.GridForming.PlantControl;

model DynGFMCCPlantControl "GFM with VSM control and a generic Plant Controller"
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
  //Operating Point
  parameter Types.ApparentPowerModule SNom = 1000 "Nominal apparent power module for the converter";
  parameter Types.VoltageModulePu UGfm0Pu = 1.076457118987823 "Start value of voltage amplitude at terminal of the GFM in pu (base UNom)";
  parameter Types.Angle UPhaseGfm0 = 0.132698675427976 "Start value of voltage angle at terminal of the GFM in rad";
  parameter Types.ActivePowerPu PGfm0Pu = -10.006748123525433 "Start value of active power at terminal of the GFM in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QGfm0Pu = -5.1170948 "Start value of reactive power at terminal of the GFM in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(UGfm0Pu, UPhaseGfm0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(PGfm0Pu, QGfm0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.Angle UPccPhase0 = atan2(uPcc0Pu.im, uPcc0Pu.re);
  final parameter Types.ComplexImpedancePu Ztot = Complex(line.RPu + Transformer.RPu, line.XPu + Transformer.XPu);
  final parameter Types.ComplexVoltagePu uPcc0Pu = u0Pu + Ztot*i0Pu;
  final parameter Types.ActivePowerPu PPcc0Pu = uPcc0Pu.re*i0Pu.re + uPcc0Pu.im*i0Pu.im;
  final parameter Types.ReactivePowerPu QPcc0Pu = uPcc0Pu.im*i0Pu.re - uPcc0Pu.re*i0Pu.im;
  final parameter Types.VoltageModulePu UPcc0Pu = sqrt(uPcc0Pu.re^2 + uPcc0Pu.im^2);
  Modelica.Blocks.Sources.Constant URefPu(k = UPcc0Pu + DynCCVSMPlantControl.Lambd*QPcc0Pu) annotation(
    Placement(transformation(origin = {-74, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = PPcc0Pu) annotation(
    Placement(transformation(origin = {-70, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-8, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.Line line(RPu = 0.0005, XPu = 0.005, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {40, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio Transformer(XPu = 0.005, GPu = 0, BPu = 0, rTfoPu = 1, RPu = 0.0005) annotation(
    Placement(transformation(origin = {68, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant URefGfmPu(k = DynCCVSMPlantControl.DynGFMCCVSM.ControlCC.URef0Pu) annotation(
    Placement(transformation(origin = {-74, -24}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Sources.AcGrid acGrid(SNom = 1000, U0pu = 1, UPhase0 = 0, Upu = 1, UPhase = 0, StartRoCoF = 5, TimeRoCoF = 3, RoCoFValue = 0.01) annotation(
    Placement(transformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.PEIR.BaseControls.Plant.DynCCVSMPlantControl DynCCVSMPlantControl(SNom = SNom, U0Pu = UGfm0Pu, UPhase0 = UPhaseGfm0, P0Pu = PGfm0Pu, Q0Pu = QGfm0Pu, UPcc0Pu = UPcc0Pu, UPccPhase0 = UPccPhase0, PPcc0Pu = PPcc0Pu, QPcc0Pu = QPcc0Pu, Lambd = 0.01, Kdroop = 0, tQFilt = 0.1, tPFilt = 1, tUFilt = 0.1, Kpq = 0.1, Kiq = 1.0, Kpp = 0.3, Kip = 0.3, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, QMaxPu = 100, QMinPu = -100, PMaxPu = 100, PMinPu = -100, CFilterPu = 1e-5, H = 5, IMaxVIPu = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2,RFilterPu = 0.015, RTransformerPu = 0.006, Omegaf = 31.4159, Omegaff = 60, XRratio = 10, XVIPu = 0.06, kVSM = 650, tVSC = 0.0002, Omegac = 1000, OmegaPLL = 100, KsiPLL = 1, KDampingAngle = 0.00318, ImaxPu = 1.2, IminPu = 0, DeltaIConvMaxPu = 0.1) annotation(
    Placement(transformation(origin = {-9, 5}, extent = {{-15, -15}, {15, 15}})));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005, XPu = 0.005) annotation(
    Placement(transformation(origin = {80, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Controls.Utilities.Measurements measurements(SNom = SNom)  annotation(
    Placement(transformation(origin = {79, 19}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;
  Transformer.switchOffSignal1 = false;
  Transformer.switchOffSignal2 = false;
  connect(line.terminal2, Transformer.terminal1) annotation(
    Line(points = {{50, 4}, {58, 4}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, acGrid.OmegaRef) annotation(
    Line(points = {{-8, 72}, {38, 72}, {38, 76}}, color = {0, 0, 127}));
  connect(DynCCVSMPlantControl.terminal, line.terminal1) annotation(
    Line(points = {{5, 5}, {24, 5}, {24, 4}, {30, 4}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, DynCCVSMPlantControl.omegaRefPu) annotation(
    Line(points = {{-8, 72}, {-10, 72}, {-10, 22}, {-8, 22}}, color = {0, 0, 127}));
  connect(URefPu.y, DynCCVSMPlantControl.URefPu) annotation(
    Line(points = {{-62, 6}, {-26, 6}, {-26, 2}}, color = {0, 0, 127}));
  connect(URefGfmPu.y, DynCCVSMPlantControl.UFilterRefPu) annotation(
    Line(points = {{-62, -24}, {-8, -24}, {-8, -12}}, color = {0, 0, 127}));
  connect(PRefPu.y, DynCCVSMPlantControl.PRefPu) annotation(
    Line(points = {{-58, 36}, {-32, 36}, {-32, 12}, {-26, 12}}, color = {0, 0, 127}));
  connect(Transformer.Q2Pu, DynCCVSMPlantControl.QPccPu) annotation(
    Line(points = {{58, -6}, {58, -38}, {-36, -38}, {-36, -2}, {-26, -2}}, color = {0, 0, 127}));
  connect(Transformer.U2Pu, DynCCVSMPlantControl.UPccPu) annotation(
    Line(points = {{78, -6}, {78, -44}, {-32, -44}, {-32, -8}, {-26, -8}}, color = {0, 0, 127}));
  connect(DynCCVSMPlantControl.PPccPu, Transformer.P2Pu) annotation(
    Line(points = {{-26, 16}, {-26, 28}, {68, 28}, {68, -6}}, color = {0, 0, 127}));
  connect(acGrid.aCPower, line1.terminal1) annotation(
    Line(points = {{62, 76}, {80, 76}, {80, 56}}, color = {0, 0, 255}));
  connect(Transformer.terminal2, measurements.terminal2) annotation(
    Line(points = {{78, 4}, {78, 9}, {80, 9}, {80, 14}}, color = {0, 0, 255}));
  connect(line1.terminal2, measurements.terminal1) annotation(
    Line(points = {{80, 36}, {80, 24}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram);
    end DynGFMCCPlantControl;
