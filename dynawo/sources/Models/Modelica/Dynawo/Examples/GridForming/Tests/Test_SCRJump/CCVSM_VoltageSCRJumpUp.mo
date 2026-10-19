within Dynawo.Examples.GridForming.Tests.Test_SCRJump;

model CCVSM_VoltageSCRJumpUp "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
 /*
   * Copyright (c) 2026, RTE (http://www.rte-france.com)
   * See AUTHORS.txt
   * All rights reserved
   * This Source Code Form is subject to the terms of the Mozilla Public
   * License, v. 2.0. If a copy of the MPL was not distributed with this
   * file, you can obtain one at http://mozilla.org/MPL/2.0/.
   * SPDX-License-Identifier: MPL-2.0
   *
   * This file is part of Dynawo, a hybrid C++/Modelica open source suite
   * of simulation tools for power systems.
   */
  extends Modelica.Icons.Example;
  // Parameters for the SCRJump (base converter SNom, see fiche I18) -----
  parameter Real SCRini = 2 "SCR before the jump";
  parameter Real SCRfinal = 20 "SCR after the jump";
  parameter Types.Time tEvt = 10 "Time of the event (s)";
  parameter Types.ApparentPowerModule SNom = 1000 "Nominal apparent power module for the converter";
  final parameter Real SCRweak = min(SCRini, SCRfinal);
  final parameter Real SCRstrong = max(SCRini, SCRfinal);
  final parameter Real SCRaux = SCRstrong - SCRweak;
  // ----- Reactances, base convertisseur SNom -----
  final parameter Real Xperm_SNom = 1/SCRweak "Ligne permanente, toujours connectee";
  final parameter Real Xaux_SNom = 1/SCRaux "Ligne auxiliaire, basculee a tEvt";
  final parameter Real XPu_perm = Xperm_SNom*Electrical.SystemBase.SnRef/SNom;
  final parameter Real RPu_perm = XPu_perm/10;
  // convention r_grid = x_grid/10 (fiche I18)
  final parameter Real XPu_aux = Xaux_SNom*Electrical.SystemBase.SnRef/SNom;
  final parameter Real RPu_aux = XPu_aux/10;
  Electrical.Lines.Line Z1_Line(BPu = 0, GPu = 0, RPu = RPu_perm, XPu = XPu_perm) annotation(
    Placement(transformation(origin = {72, 2}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line Z2_Line(BPu = 0, GPu = 0, RPu = RPu_aux, XPu = XPu_aux, SwitchOffSignal10 = true) annotation(
    Placement(transformation(origin = {72, -16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.5) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
 Electrical.Controls.Utilities.Measurements measurements(SNom = 1000) annotation(
    Placement(transformation(origin = {28, 2}, extent = {{-10, -10}, {10, 10}})));
 Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations annotation(
    Placement(transformation(origin = {102, -16}, extent = {{-10, -10}, {10, 10}})));
 Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMCCVSM DynGFMCCVSM(CFilterPu = 1e-05, DeltaIConvMaxPu = 0.15, H = 5, IMaxVIPu = 1.1, ImaxPu = 1.2, IminPu = 0, KDampingAngle = 0.00318, Kfd = 1, Kff = 0.01, Kfq = 0.8, KpVI = 0.6, KsiPLL = 1, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaPLL = 100, Omegac = 1000, Omegaf = 31.4159, Omegaff = 60, P0Pu = -9.440193302496278, Q0Pu = -0.5430730020626036, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.947115101091565, UPhase0 = 0.5184088727446441, XRratio = 10, XVIPu = 0.06, kVSM = 600, tUFilt = 0.02, tVSC = 0.0004, EpsVIUpPu = 0.01, EpsVIDownPu = 0.01) annotation(
    Placement(transformation(origin = {-26, 2}, extent = {{-20, -20}, {20, 20}})));
equation
  Z1_Line.switchOffSignal1 = false;
  Z1_Line.switchOffSignal2 = false;
  Z2_Line.switchOffSignal1 = if SCRini < SCRfinal then time < tEvt else time >= tEvt;
  Z2_Line.switchOffSignal2 = Z2_Line.switchOffSignal1;
  DynGFMCCVSM.switchOffSignal1 = false;
  DynGFMCCVSM.switchOffSignal2 = false;
  DynGFMCCVSM.switchOffSignal3 = false;
  connect(measurements.terminal2, Z1_Line.terminal1) annotation(
    Line(points = {{38, 2}, {62, 2}}, color = {0, 0, 255}));
  connect(Z1_Line.terminal1, Z2_Line.terminal1) annotation(
    Line(points = {{62, 2}, {62, -16}}, color = {0, 0, 255}));
  connect(Z1_Line.terminal2, Z2_Line.terminal2) annotation(
    Line(points = {{82, 2}, {82, -16}}, color = {0, 0, 255}));
  connect(Z2_Line.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{82, -16}, {102, -16}}, color = {0, 0, 255}));
 connect(DynGFMCCVSM.terminal, measurements.terminal1) annotation(
    Line(points = {{-4, 2}, {18, 2}}, color = {0, 0, 255}));
 connect(PRefPu.y, DynGFMCCVSM.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-48, 56}, {-48, 18}}, color = {0, 0, 127}));
 connect(omegaRefPu.y, DynGFMCCVSM.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-60, 20}, {-60, 10}, {-48, 10}}, color = {0, 0, 127}));
 connect(QRefPu.y, DynGFMCCVSM.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-60, -20}, {-60, -6}, {-48, -6}}, color = {0, 0, 127}));
 connect(URefPu.y, DynGFMCCVSM.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-48, -60}, {-48, -14}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    Documentation(info = "<html><head></head><body><div><br></div><div><div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"),
    Diagram);
end CCVSM_VoltageSCRJumpUp;
