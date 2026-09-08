within Dynawo.Examples.GridForming;

model DynGFMPlantControl "GFM with VSM control and a generic Plant Controller"
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
  parameter Types.ApparentPowerModule SNom=1000 "Nominal apparent power module for the converter";
  parameter Types.VoltageModulePu UGfm0Pu = 1.053980620785106
    "Start value of voltage amplitude at terminal of the GFM in pu (base UNom)";
  parameter Types.Angle UPhaseGfm0 = 0.09020617241887803
    "Start value of voltage angle at terminal of the GFM in rad";
  parameter Types.ActivePowerPu PGfm0Pu = -10.006748123525433
    "Start value of active power at terminal of the GFM in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QGfm0Pu = -5.1170948
    "Start value of reactive power at terminal of the GFM in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uFilter0Pu =
      u0Pu - Complex(dynVSMPlantControl.RTransformerPu, dynVSMPlantControl.LTransformerPu*SystemBase.omegaRef0Pu + dynVSMPlantControl.XVI)*i0Pu*SystemBase.SnRef/SNom;
  final parameter Types.VoltageModulePu UFilter0Pu = sqrt(uFilter0Pu.re^2 + uFilter0Pu.im^2);

  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(UGfm0Pu, UPhaseGfm0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(PGfm0Pu, QGfm0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.Angle UPccPhase0 = atan2(uPcc0Pu.im, uPcc0Pu.re);
  final parameter Types.ComplexImpedancePu Ztot = Complex(line.RPu+Transformer.RPu, line.XPu+Transformer.XPu);
  final parameter Types.ComplexVoltagePu uPcc0Pu = u0Pu + Ztot*i0Pu;
  final parameter Types.ActivePowerPu PPcc0Pu = uPcc0Pu.re*i0Pu.re + uPcc0Pu.im*i0Pu.im;
  final parameter Types.ReactivePowerPu QPcc0Pu = uPcc0Pu.im*i0Pu.re - uPcc0Pu.re*i0Pu.im;
  final parameter Types.VoltageModulePu UPcc0Pu = sqrt(uPcc0Pu.re^2 + uPcc0Pu.im^2);
  Modelica.Blocks.Sources.Constant URefPu(k = UPcc0Pu + dynVSMPlantControl.Lambd*QPcc0Pu) annotation(
    Placement(transformation(origin = {-74, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = PPcc0Pu) annotation(
    Placement(transformation(origin = {-70, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-8, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.Line line(RPu = 0.0005, XPu = 0.005, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {34, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio Transformer(XPu = 0.005, GPu = 0, BPu = 0, rTfoPu = 1, RPu = 0.0005) annotation(
    Placement(transformation(origin = {68, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant URefGfmPu(k = UFilter0Pu) annotation(
    Placement(transformation(origin = {-74, -24}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.PEIR.BaseControls.Plant.DynVSMPlantControl dynVSMPlantControl(SNom = SNom, U0Pu = UGfm0Pu, UPhase0 = UPhaseGfm0, P0Pu = PGfm0Pu, Q0Pu = QGfm0Pu, UPcc0Pu = UPcc0Pu, UPccPhase0 = UPccPhase0, PPcc0Pu = PPcc0Pu, QPcc0Pu = QPcc0Pu, Lambd = 0.01, Kdroop = 0, tQFilt = 0.1, tPFilt = 1, tUFilt = 0.1, Kpq = 0.1, Kiq = 1.0, Kpp = 0.3, Kip = 0.3, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, QMaxPu = 100, QMinPu = -100, PMaxPu = 100, PMinPu = -100, CFilterPu = 1e-5, H = 5, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2,RFilterPu = 0.015, RTransformerPu = 0.006, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0.06, kVSM = 650, tVSC = 0.0002, omegaC = 1000, omegaNPLL = 100, ZetaPLL = 1)  annotation(
    Placement(transformation(origin = {-8, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations_PhaseJump infiniteBusWithVariations_PhaseJump(U0Pu = 1, UEvtPu = 0, omega0Pu = 1, omegaEvtPu = 1, UPhase = 0, tUEvtStart = 0, tUEvtEnd = 0, tOmegaEvtStart = 0, tOmegaEvtEnd = 0, dUPhaseEvt = 0.110, tUPhaseEvt = 10)  annotation(
    Placement(transformation(origin = {128, 4}, extent = {{-10, -10}, {10, 10}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  Transformer.switchOffSignal1 = false;
  Transformer.switchOffSignal2 = false;
  connect(line.terminal2, Transformer.terminal1) annotation(
    Line(points = {{44, 4}, {58, 4}}, color = {0, 0, 255}));
  connect(dynVSMPlantControl.terminal, line.terminal1) annotation(
    Line(points = {{2, 4}, {24, 4}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, dynVSMPlantControl.omegaRefPu) annotation(
    Line(points = {{-8, 72}, {-8, 16}}, color = {0, 0, 127}));
  connect(PRefPu.y, dynVSMPlantControl.PRefPu) annotation(
    Line(points = {{-59, 36}, {-26, 36}, {-26, 8}, {-20, 8}}, color = {0, 0, 127}));
  connect(URefGfmPu.y, dynVSMPlantControl.UFilterRefPu) annotation(
    Line(points = {{-62, -24}, {-8, -24}, {-8, -8}}, color = {0, 0, 127}));
  connect(URefPu.y, dynVSMPlantControl.URefPu) annotation(
    Line(points = {{-62, 6}, {-20, 6}, {-20, 2}}, color = {0, 0, 127}));
  connect(Transformer.U2Pu, dynVSMPlantControl.UPccPu) annotation(
    Line(points = {{78, -6}, {78, -40}, {-32, -40}, {-32, -4}, {-20, -4}}, color = {0, 0, 127}));
  connect(Transformer.P2Pu, dynVSMPlantControl.PPccPu) annotation(
    Line(points = {{68, -6}, {68, -50}, {-42, -50}, {-42, 12}, {-20, 12}}, color = {0, 0, 127}));
  connect(Transformer.Q2Pu, dynVSMPlantControl.QPccPu) annotation(
    Line(points = {{58, -6}, {54, -6}, {54, -44}, {-36, -44}, {-36, -2}, {-20, -2}}, color = {0, 0, 127}));
  connect(Transformer.terminal2, infiniteBusWithVariations_PhaseJump.terminal) annotation(
    Line(points = {{78, 4}, {128, 4}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram);
    end DynGFMPlantControl;
