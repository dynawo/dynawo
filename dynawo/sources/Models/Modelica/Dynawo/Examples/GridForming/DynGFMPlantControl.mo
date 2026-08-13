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
  parameter Types.VoltageModulePu UPcc0Pu = 0.997 "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhasePcc0 = 0.05"Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu PPcc0Pu = -9.94 "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QPcc0Pu = 0.65"Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(UPcc0Pu, UPhasePcc0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(PPcc0Pu, QPcc0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ActivePowerPu PInj0Pu = PPcc0Pu * SystemBase.SnRef/SNom;  // convention générateur, base SNom
final parameter Types.ReactivePowerPu QInj0Pu = QPcc0Pu * SystemBase.SnRef/SNom;
  Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaSetPu = 1, P0Pu = PPcc0Pu, Q0Pu = QPcc0Pu, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = UPcc0Pu, UPhase0 = UPhasePcc0, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0, kVSM = 155.955, tVSC = 0.0004, PFilterRef0Pu = PInj0Pu, QFilterRef0Pu = QInj0Pu) annotation(
    Placement(transformation(origin = {-21, 5}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {-114, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-8, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 1) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line line(RPu = 0.000166667, XPu = 0.005, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {38, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio Transformer(XPu = 0.005, GPu = 0, BPu = 0, rTfoPu = 1, RPu = 0.000166667) annotation(
    Placement(transformation(origin = {68, 4}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurementsPCC annotation(
    Placement(transformation(origin = {-78, -68}, extent = {{-12, -12}, {12, 12}}, rotation = 90)));
  Electrical.Sources.AcGrid acGrid(SNom = 1000, U0pu = 1, UPhase0 = 0, Upu = 1, UPhase = 0, RoCoFValue = 0.01) annotation(
    Placement(transformation(origin = {124, -2}, extent = {{8, -8}, {-8, 8}})));
  Electrical.Controls.PEIR.BaseControls.Plant.PlantControl plantControl(Lambd = 0.417, Kdroop = 15, tQFilt = 0.1, tPFilt = 0.1, tUFilt = 0.1, Kpq = 0.1, Kiq = 1.0, Kpp = 0.8, Kip = 5.0, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, Omega0Pu = 1, PPcc0Pu = PPcc0Pu, QPcc0Pu = QPcc0Pu, UPcc0Pu = UPcc0Pu, SNom = 1000, QinjRef0Pu = QPcc0Pu*SystemBase.SnRef/SNom, PInjRef0Pu = PPcc0Pu*SystemBase.SnRef/SNom)  annotation(
    Placement(transformation(origin = {-80, 4}, extent = {{-10, -10}, {10, 10}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal1 = false;
  DynGFMVSM.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal3 = false;
  Transformer.switchOffSignal1 = false;
  Transformer.switchOffSignal2 = false;
  connect(DynGFMVSM.terminal, line.terminal1) annotation(
    Line(points = {{4, 5}, {4, 4}, {28, 4}}, color = {0, 0, 255}));
  connect(line.terminal2, Transformer.terminal1) annotation(
    Line(points = {{48, 4}, {58, 4}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, acGrid.OmegaRef) annotation(
    Line(points = {{-8, 71}, {-8, 69}, {134, 69}, {134, 2}}, color = {0, 0, 255}, pattern = LinePattern.Dot));
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{-8, 72}, {-60, 72}, {-60, 14}, {-46, 14}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Transformer.terminal2, acGrid.aCPower) annotation(
    Line(points = {{78, 4}, {115, 4}}, color = {0, 0, 255}));
  connect(acGrid.aCPower, measurementsPCC.terminal2) annotation(
    Line(points = {{115, 4}, {86, 4}, {86, -56}, {-78, -56}}, color = {0, 0, 255}));
  connect(PRefPu.y, plantControl.PRefPu) annotation(
    Line(points = {{-102, 56}, {-96, 56}, {-96, 8}, {-92, 8}}, color = {0, 0, 127}));
  connect(acGrid.omegaPu, plantControl.omegaPu) annotation(
    Line(points = {{114, -6}, {16, -6}, {16, -38}, {-98, -38}, {-98, 6}, {-92, 6}}, color = {0, 0, 127}));
  connect(URefPu.y, plantControl.URefPu) annotation(
    Line(points = {{-102, 2}, {-92, 2}}, color = {0, 0, 127}));
  connect(measurementsPCC.UPu, plantControl.UPccPu) annotation(
    Line(points = {{-92, -80}, {-96, -80}, {-96, -4}, {-92, -4}}, color = {0, 0, 127}));
  connect(measurementsPCC.QPu, plantControl.QPccPu) annotation(
    Line(points = {{-92, -64}, {-94, -64}, {-94, -2}, {-92, -2}}, color = {0, 0, 127}));
  connect(measurementsPCC.PPu, plantControl.PPccPu) annotation(
    Line(points = {{-92, -66}, {-100, -66}, {-100, 12}, {-92, 12}}, color = {0, 0, 127}));
  connect(plantControl.QInjRefPu, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{-68, -2}, {-48, -2}, {-48, -4}, {-46, -4}}, color = {0, 0, 127}));
  connect(plantControl.PInjRefPu, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{-68, 10}, {-66, 10}, {-66, 23}, {-46, 23}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMVSM.UFilterRefPu) annotation(
    Line(points = {{-102, 2}, {-102, -13}, {-46, -13}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram);
end DynGFMPlantControl;
