within Dynawo.Examples.GridForming.Tests.Test_SCRJump;

model Droop_SCRJumpDown "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
  /*
  * Copyright (c) 2026, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
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
  parameter Real SCRini = 20    "SCR before the jump";
  parameter Real SCRfinal = 2 "SCR after the jump";
  parameter Types.Time tEvt = 10 "Time of the event (s)";
  parameter Types.ApparentPowerModule SNom = 1000 "Nominal apparent power module for the converter";

  final parameter Real SCRweak   = min(SCRini, SCRfinal);
  final parameter Real SCRstrong = max(SCRini, SCRfinal);
  final parameter Real SCRaux    = SCRstrong - SCRweak;

  // ----- Reactances, base convertisseur SNom -----
  final parameter Real Xperm_SNom = 1/SCRweak "Ligne permanente, toujours connectee";
  final parameter Real Xaux_SNom  = 1/SCRaux  "Ligne auxiliaire, basculee a tEvt";

  final parameter Real XPu_perm = Xperm_SNom * SystemBase.SnRef/SNom;
  final parameter Real RPu_perm = XPu_perm/10;   // convention r_grid = x_grid/10 (fiche I18)
  final parameter Real XPu_aux  = Xaux_SNom  * SystemBase.SnRef/SNom;
  final parameter Real RPu_aux  = XPu_aux/10;

  Electrical.Lines.Line Z1_Line(BPu = 0, GPu = 0, RPu = RPu_perm, XPu = XPu_perm) annotation(
    Placement(transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Lines.Line Z2_Line(BPu = 0, GPu = 0, RPu = RPu_aux, XPu = XPu_aux) annotation(
    Placement(transformation(origin = {60, -16}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop DynGFMDroop(CFilterPu = 1e-05,IMaxVI = 1.2,Kfd = 1,Kff = 0, Kfq = 0, KpVI = 0.1, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.013, P0Pu = -9.44303759416221, Q0Pu = -0.9381894853914545, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9739263489847085, UPhase0 = 0.5006269558583454, Wf = 40, Wff = 50, XRratio = 10, XVI = 0.06, tVSC = 0.0004, Mp = 0.013, omegaC = 1000, omegaNPLL = 100, ZetaPLL = 1) annotation(
    Placement(transformation(origin = {-27, 3}, extent = {{-23, -23}, {23, 23}})));
  Electrical.Buses.InfiniteBusWithVariationsPhaseJump infiniteBusWithVariationsPhaseJump(U0Pu = 1, UEvtPu = 1, omega0Pu = 1, omegaEvtPu = 1, UPhase = 0, tUEvtStart = 0, tUEvtEnd = 0, tOmegaEvtStart = 0, tOmegaEvtEnd = 0, dUPhaseEvt = 0, tUPhaseEvt = 0)  annotation(
    Placement(transformation(origin = {84, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.Utilities.Measurements measurements(SNom = 1000) annotation(
    Placement(transformation(origin = {28, 2}, extent = {{-10, -10}, {10, 10}})));
equation
  Z1_Line.switchOffSignal1 = false;
  Z1_Line.switchOffSignal2 = false;
  Z2_Line.switchOffSignal1 = if SCRini < SCRfinal then time < tEvt else time >= tEvt;
  Z2_Line.switchOffSignal2 = Z2_Line.switchOffSignal1;

  DynGFMDroop.switchOffSignal1 = false;
  DynGFMDroop.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal3 = false;
  connect(PRefPu.y, DynGFMDroop.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-102, 57}, {-52, 57}, {-52, 21}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMDroop.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-62, 20}, {-62, 12}, {-52, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMDroop.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-66, -20}, {-66, -6}, {-52, -6}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMDroop.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-100, -57}, {-52, -57}, {-52, -15}}, color = {0, 0, 127}));
  connect(DynGFMDroop.terminal, measurements.terminal1) annotation(
    Line(points = {{-2, 4}, {18, 4}, {18, 2}}, color = {0, 0, 255}));
  connect(measurements.terminal2, Z1_Line.terminal1) annotation(
    Line(points = {{38, 2}, {50, 2}, {50, 0}}, color = {0, 0, 255}));
  connect(Z1_Line.terminal2, infiniteBusWithVariationsPhaseJump.terminal) annotation(
    Line(points = {{70, 0}, {84, 0}}, color = {0, 0, 255}));
  connect(Z1_Line.terminal1, Z2_Line.terminal1) annotation(
    Line(points = {{50, 0}, {50, -16}}, color = {0, 0, 255}));
  connect(Z1_Line.terminal2, Z2_Line.terminal2) annotation(
    Line(points = {{70, 0}, {70, -16}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    Documentation(info = "<html><head></head><body><div>This test case is part of a larger framework aiming at comparing different GFM control architectures with a standard Angle Phase jump at an Infinite Bus.&nbsp;</div><div><br></div><div>Tested architectures feature :&nbsp;</div><div>- A dynamic Virtual Synchronous Machine control which is taken as referenc (DynGFMVSM)</div><div>- A dynamic Virtual Synchronous Machine control but with the frequency in the converter being the one measured by the PLL (DynGFMConvPLL). The \"physics\" mzeaning of this model is yet to be understood and we are wondering of its added value given it produces almors identical results with the former DynGFMVSM model.&nbsp;</div><div>- A dynamic Droop control (DynGFMDroop)</div><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t=10s, a phase jump is simulated with a value of +0.110 radians, corresponding to the&nbsp;</span>S_VolAngStep1_0C4 scenario depicted in the I18 documentation.&nbsp;</div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of PFilterPu : the active power in p.u measured at the RLC filter of the Converter block for all three models. Note that the DynGFMVSM and DynGFmVsmConvPLL produce very similar results.&nbsp;</span></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Fig 1 : Active power in p.u measured at the RLC Filter.</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/DynGFMComparison.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"));
end Droop_SCRJumpDown;
