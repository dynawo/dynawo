within Dynawo.Examples.GridForming.VSM;

model DynGFMVSMSmib "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
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
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(transformation(origin = {56, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1.0) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 5, IMaxVIPu = 20, Kfd = 0.8, Kff = 0.2, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = -9.440980224920811, Q0Pu = -0.6429165775892071, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9541103569380908, UPhase0 = 0.5136779612182762, Omegaf = 31.4159, Omegaff = 60, XRratio = 10, XVIPu = 0.06, kVSM = 150, tVSC = 0.0004, OmegaPLL = 100, KsiPLL = 1, Omegac = 1000, EpsVIUpPu = 0.01, EpsVIDownPu = 0.01) annotation(
    Placement(transformation(origin = {-15, 1}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-112, 54}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = 1000)  annotation(
    Placement(transformation(origin = {28, 2}, extent = {{-10, -10}, {10, 10}})));
 Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(dUPhaseEvt = 0.416, tUPhaseEvt = 35)  annotation(
    Placement(transformation(origin = {90, 2}, extent = {{-10, -10}, {10, 10}})));
 Dynawo.Electrical.Sources.AcGridRoCoF acGridRoCoF(ReturnRoCoF = false, RoCoFValue = -0.04, SNom = 1000, StartRoCoF = 5, StartingFrequency = 0, TimeRoCoF = 0.5, U0pu = 1, UPhase = 0, UPhase0 = 0, Upu = 1) annotation(
    Placement(transformation(origin = {20, 62}, extent = {{-10, -10}, {10, 10}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal1 = false;
  DynGFMVSM.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal3 = false;
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-50, 20}, {-50, 10}, {-40, 10}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-60, -20}, {-60, -8}, {-40, -8}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMVSM.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-56, -60}, {-56, -17}, {-40, -17}}, color = {0, 0, 127}));
  connect(PRefPu.y, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{-101, 54}, {-101, 19}, {-40, 19}}, color = {0, 0, 127}));
  connect(DynGFMVSM.terminal, measurements.terminal1) annotation(
    Line(points = {{10, 1}, {14, 1}, {14, 2}, {18, 2}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line.terminal1) annotation(
    Line(points = {{38, 2}, {46, 2}}, color = {0, 0, 255}));
 connect(omegaRefPu.y, acGridRoCoF.OmegaRef) annotation(
    Line(points = {{-100, 20}, {-60, 20}, {-60, 68}, {8, 68}}, color = {0, 0, 127}));
 connect(acGridRoCoF.aCPower, line.terminal2) annotation(
    Line(points = {{32, 68}, {66, 68}, {66, 2}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    Documentation(info = "<html><head></head><body><div>This test case is part of a larger framework aiming at comparing different GFM control architectures with a standard Angle Phase jump at an Infinite Bus. The chosen test case belongs to the I18 Grid code under the name S_VoltageAngleStep7_OC4 corresponding to :&nbsp;</div><div>- An operating condition of P=0.95 p.u. and Q=0 p.u.</div><div>- An angle step at the voltage bus of 0.416 rad ~ 26.47°</div><div>- A &nbsp;minimal Short Circuit Ratio (SCR) representing a \"weak grid\".</div><div><br></div><div>Tested architectures feature :&nbsp;</div><div>- A dynamic Virtual Synchronous Machine control which is taken as referenc (DynGFMVSM) with Virtual Impedance as current limitation.</div><div>- A dynamic Virtual Synchronous Machine control but with the frequency in the converter being the one measured by the PLL (DynGFMConvPLL). The \"physics\" meaning of this model is yet to be understood and we are wondering of its added value given it produces almors identical results with the former DynGFMVSM model.&nbsp;</div><div>- An hybrid current controlled VSM (DynGFMCCVSM) with Virtual Impedance limitation and Current Saturation.&nbsp;</div><div>- A dynamic Droop control (DynGFMDroop)</div><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t=10s, a phase jump is simulated with a value of +0.416 radians, corresponding to the&nbsp;</span>S_VolAngStep7_0C4 scenario depicted in the I18 documentation.&nbsp;</div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of PPu : the active power in p.u measured at the Point of Common Coupling (PCC)&nbsp;</span><span style=\"font-size: 12px;\">in base SNom</span><span style=\"font-size: 12px;\">, with the generator convention.</span></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Fig 1 : Active power in p.u measured at the PCC.</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/S_VoltAngleStep7_OC4.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"),
    Diagram);
end DynGFMVSMSmib;
