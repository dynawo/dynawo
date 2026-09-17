within Dynawo.Examples.GridForming;

model DynGFMDroopPlantControl "GFM with VSM control and a generic Plant Controller"
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
  parameter Types.VoltageModulePu UGfm0Pu = 0.993784186833338
"Start value of voltage amplitude at terminal of the GFM in pu (base UNom)";
  parameter Types.Angle UPhaseGfm0 = 0.143988952906081
 "Start value of voltage angle at terminal of the GFM in rad";
  parameter Types.ActivePowerPu PGfm0Pu = -9.4400899
"Start value of active power at terminal of the GFM in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QGfm0Pu = 0.663711
 "Start value of reactive power at terminal of the GFM in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uFilter0Pu = u0Pu - Complex(dynDroopPlantControl.RTransformerPu, dynDroopPlantControl.LTransformerPu*Electrical.SystemBase.omegaRef0Pu + dynDroopPlantControl.XVI)*i0Pu*Electrical.SystemBase.SnRef/SNom;
  final parameter Types.VoltageModulePu UFilter0Pu = sqrt(uFilter0Pu.re^2 + uFilter0Pu.im^2);
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(UGfm0Pu, UPhaseGfm0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(PGfm0Pu, QGfm0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.Angle UPccPhase0 = atan2(uPcc0Pu.im, uPcc0Pu.re);
  final parameter Types.ComplexImpedancePu Ztot = Complex(line.RPu + Transformer.RPu, line.XPu + Transformer.XPu);
  final parameter Types.ComplexVoltagePu uPcc0Pu = u0Pu + Ztot*i0Pu;
  final parameter Types.ActivePowerPu PPcc0Pu = uPcc0Pu.re*i0Pu.re + uPcc0Pu.im*i0Pu.im;
  final parameter Types.ReactivePowerPu QPcc0Pu = uPcc0Pu.im*i0Pu.re - uPcc0Pu.re*i0Pu.im;
  final parameter Types.VoltageModulePu UPcc0Pu = sqrt(uPcc0Pu.re^2 + uPcc0Pu.im^2);
  Modelica.Blocks.Sources.Constant URefPu(k = UPcc0Pu + dynDroopPlantControl.Lambd*QPcc0Pu) annotation(
    Placement(transformation(origin = {-74, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = PPcc0Pu) annotation(
    Placement(transformation(origin = {-70, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-18, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.Line line(RPu = 0.0005, XPu = 0.005, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {34, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio Transformer(XPu = 0.005, GPu = 0, BPu = 0, rTfoPu = 1, RPu = 0.0005) annotation(
    Placement(transformation(origin = {68, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant URefGfmPu(k = UFilter0Pu) annotation(
    Placement(transformation(origin = {-74, -24}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005, XPu = 0.005) annotation(
    Placement(transformation(origin = {98, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.PEIR.BaseControls.Plant.DynDroopPlantControl dynDroopPlantControl(SNom = SNom, U0Pu = UGfm0Pu, UPhase0 = UPhaseGfm0, P0Pu = PGfm0Pu, Q0Pu = QGfm0Pu, UPcc0Pu = UPcc0Pu, UPccPhase0 = UPccPhase0, PPcc0Pu = PPcc0Pu, QPcc0Pu = QPcc0Pu, CFilterPu = 1e-05, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0,  KpVI = 0.1, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.013, RFilterPu = 0.015, RTransformerPu = 0.006,  Wf = 40, Wff = 50, XRratio = 10, XVI = 0.06, tVSC = 0.0004, Mp = 0.013, omegaC = 1000, omegaNPLL = 100, ZetaPLL = 1, Lambd = 0.01, Kdroop = 0.01, tQFilt = 0.1, tPFilt = 1, tUFilt = 0.1, Kpq = 0.1, Kiq = 1.0, Kpp = 0.3, Kip = 0.3, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, QMaxPu = 100, QMinPu = -100, PMaxPu = 12, PMinPu = -12)  annotation(
    Placement(transformation(origin = {-16, 6}, extent = {{-22, -22}, {22, 22}})));
  Dynawo.Electrical.Sources.AcGrid AcGrid(RoCoFValue = 0, SNom = 1000, StartRoCoF = 5, TimeRoCoF = 3, U0pu = 1, UPhase = 0, UPhase0 = 0, Upu = 1) annotation(
    Placement(transformation(origin = {82, 50}, extent = {{-10, -10}, {10, 10}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;
  Transformer.switchOffSignal1 = false;
  Transformer.switchOffSignal2 = false;
  connect(line.terminal2, Transformer.terminal1) annotation(
    Line(points = {{44, 4}, {58, 4}}, color = {0, 0, 255}));
  connect(Transformer.terminal2, line1.terminal1) annotation(
    Line(points = {{78, 4}, {88, 4}}, color = {0, 0, 255}));
  connect(URefGfmPu.y, dynDroopPlantControl.UFilterRefPu) annotation(
    Line(points = {{-62, -24}, {-16, -24}, {-16, -18}}, color = {0, 0, 127}));
  connect(dynDroopPlantControl.terminal, line.terminal1) annotation(
    Line(points = {{6, 6}, {24, 6}, {24, 4}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, dynDroopPlantControl.omegaRefPu) annotation(
    Line(points = {{-18, 72}, {-16, 72}, {-16, 30}}, color = {0, 0, 127}));
  connect(PRefPu.y, dynDroopPlantControl.PRefPu) annotation(
    Line(points = {{-58, 36}, {-52, 36}, {-52, 16}, {-40, 16}}, color = {0, 0, 127}));
  connect(URefPu.y, dynDroopPlantControl.URefPu) annotation(
    Line(points = {{-62, 6}, {-40, 6}, {-40, 2}}, color = {0, 0, 127}));
  connect(Transformer.U2Pu, dynDroopPlantControl.UPccPu) annotation(
    Line(points = {{78, -6}, {78, -36}, {-50, -36}, {-50, -14}, {-40, -14}}, color = {0, 0, 127}));
  connect(Transformer.P2Pu, dynDroopPlantControl.PPccPu) annotation(
    Line(points = {{68, -6}, {68, -44}, {-54, -44}, {-54, -6}, {-40, -6}}, color = {0, 0, 127}));
  connect(Transformer.Q2Pu, dynDroopPlantControl.QPccPu) annotation(
    Line(points = {{58, -6}, {50, -6}, {50, 34}, {-48, 34}, {-48, 24}, {-40, 24}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, AcGrid.OmegaRef) annotation(
    Line(points = {{-18, 72}, {70, 72}, {70, 55}}, color = {0, 0, 127}));
  connect(AcGrid.aCPower, line1.terminal2) annotation(
    Line(points = {{93.5, 57}, {116, 57}, {116, 4}, {108, 4}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram);
    end DynGFMDroopPlantControl;
