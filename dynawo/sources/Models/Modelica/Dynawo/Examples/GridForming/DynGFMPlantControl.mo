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
  parameter Types.VoltageModulePu UGfm0Pu = 1.04765613156226
"Start value of voltage amplitude at terminal of the GFM in pu (base UNom)";
  parameter Types.Angle UPhaseGfm0 = 0.0932956217402832
"Start value of voltage angle at terminal of the GFM in rad";
  parameter Types.ActivePowerPu PGfm0Pu = -9.9309403
 "Start value of active power at terminal of the GFM in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QGfm0Pu = -5.1170948
"Start value of reactive power at terminal of the GFM in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(UGfm0Pu, UPhaseGfm0) "Start value of the complex voltage at terminalof the GFM in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(PGfm0Pu, QGfm0Pu)/u0Pu) "Start value of the complex current at terminalof the GFM in pu (base UNom, SnRef) (receptor convention)";

  final parameter Types.ComplexImpedancePu Ztot = Complex(2*0.000166667, 2*0.005);
  final parameter Types.ComplexVoltagePu uPcc0Pu = u0Pu + Ztot*i0Pu;
  final parameter Types.ActivePowerPu PPcc0Pu = uPcc0Pu.re*i0Pu.re + uPcc0Pu.im*i0Pu.im;
  final parameter Types.ReactivePowerPu QPcc0Pu = uPcc0Pu.im*i0Pu.re - uPcc0Pu.re*i0Pu.im;
  final parameter Types.VoltageModulePu UPcc0Pu = sqrt(uPcc0Pu.re^2 + uPcc0Pu.im^2);

  Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 5, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaSetPu = 1, P0Pu = PGfm0Pu, Q0Pu = QGfm0Pu, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = UGfm0Pu, UPhase0 = UPhaseGfm0, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0, kVSM = 155.955, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {-25, 5}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Blocks.Sources.Constant URefPu(k = UPcc0Pu + plantControl.Lambd*QPcc0Pu) annotation(
    Placement(transformation(origin = {-114, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = PPcc0Pu) annotation(
    Placement(transformation(origin = {-108, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-8, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.Line line(RPu = 0.000166667, XPu = 0.005, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {38, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio Transformer(XPu = 0.005, GPu = 0, BPu = 0, rTfoPu = 1, RPu = 0.000166667) annotation(
    Placement(transformation(origin = {68, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurementsPCC annotation(
    Placement(transformation(origin = {96, 4}, extent = {{-12, -12}, {12, 12}}, rotation = 180)));
  Electrical.Sources.AcGrid acGrid(SNom = 1000, U0pu = 1, UPhase0 = 0, Upu = 1, UPhase = 0, RoCoFValue = 0) annotation(
    Placement(transformation(origin = {124, -2}, extent = {{8, -8}, {-8, 8}})));
  Electrical.Controls.PEIR.BaseControls.Plant.PlantControl plantControl(Lambd = 0.1, Kdroop = 1, tQFilt = 0.1, tPFilt = 0.1, tUFilt = 0.1, Kpq = 0.1, Kiq = 1.0, Kpp = 0.1, Kip = 1.0, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, Omega0Pu = 1, PPcc0Pu = PPcc0Pu, QPcc0Pu = QPcc0Pu, UPcc0Pu = UPcc0Pu, SNom = 1000, QMaxPu = 12, QMinPu = -12, PMaxPu = 12, PMinPu = -12)  annotation(
    Placement(transformation(origin = {-80, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu12(k = UGfm0Pu) annotation(
    Placement(transformation(origin = {-74, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = -PGfm0Pu*SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {-68, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = -QGfm0Pu*SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {-78, 28}, extent = {{-10, -10}, {10, 10}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal1 = false;
  DynGFMVSM.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal3 = false;
  Transformer.switchOffSignal1 = false;
  Transformer.switchOffSignal2 = false;
  connect(DynGFMVSM.terminal, line.terminal1) annotation(
    Line(points = {{0, 5}, {0, 4}, {28, 4}}, color = {0, 0, 255}));
  connect(line.terminal2, Transformer.terminal1) annotation(
    Line(points = {{48, 4}, {58, 4}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, acGrid.OmegaRef) annotation(
    Line(points = {{-8, 71}, {-8, 69}, {134, 69}, {134, 2}}, color = {0, 0, 255}, pattern = LinePattern.Dot));
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{-8, 72}, {-60, 72}, {-60, 14}, {-50, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(URefPu.y, plantControl.URefPu) annotation(
    Line(points = {{-102, 2}, {-92, 2}}, color = {0, 0, 127}));
  connect(measurementsPCC.UPu, plantControl.UPccPu) annotation(
    Line(points = {{108, -9}, {-96, -9}, {-96, -4}, {-92, -4}}, color = {0, 0, 127}));
  connect(measurementsPCC.QPu, plantControl.QPccPu) annotation(
    Line(points = {{91, -9}, {-94, -9}, {-94, -2}, {-92, -2}}, color = {0, 0, 127}));
  connect(measurementsPCC.PPu, plantControl.PPccPu) annotation(
    Line(points = {{94, -9}, {-100, -9}, {-100, 12}, {-92, 12}}, color = {0, 0, 127}));
  connect(PRefPu.y, plantControl.PRefPu) annotation(
    Line(points = {{-97, 56}, {-96, 56}, {-96, 8}, {-92, 8}}, color = {0, 0, 127}));
  connect(PRefPu12.y, DynGFMVSM.UFilterRefPu) annotation(
    Line(points = {{-63, -24}, {-63, -13}, {-50, -13}}, color = {0, 0, 127}));
  connect(plantControl.QInjRefPu, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{-68, -2}, {-50, -2}, {-50, -4}}, color = {0, 0, 127}));
  connect(DynGFMVSM.omegaVSMPu, plantControl.omegaPu) annotation(
    Line(points = {{-12, 30}, {-98, 30}, {-98, 6}, {-92, 6}}, color = {0, 0, 127}));
  connect(Transformer.terminal2, measurementsPCC.terminal2) annotation(
    Line(points = {{78, 4}, {84, 4}}, color = {0, 0, 255}));
  connect(measurementsPCC.terminal1, acGrid.aCPower) annotation(
    Line(points = {{108, 4}, {114, 4}}, color = {0, 0, 255}));
  connect(plantControl.PInjRefPu, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{-68, 10}, {-58, 10}, {-58, 24}, {-50, 24}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram);
    end DynGFMPlantControl;
