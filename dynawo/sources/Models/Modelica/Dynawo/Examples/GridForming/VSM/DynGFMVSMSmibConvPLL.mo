within Dynawo.Examples.GridForming.VSM;

model DynGFMVSMSmibConvPLL "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer -- omegaPLL passed to the converter"
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

  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(transformation(origin = {46, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSMConvPLL DynGFMVSMConvPLL(CFilterPu = 1e-05, H = 5, IMaxVIPu = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = -9.440979955569425, Q0Pu = -0.642916511452948, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.954110360567147, UPhase0 = 0.513677943263305, Omegaf = 31.4159, Omegaff = 60, XRratio = 10, XVIPu = 0.06, kVSM = 150, tVSC = 0.0004, OmegaPLL = 100, KsiPLL = 1, Omegac = 1000, EpsVIUpPu = 0.01, EpsVIDownPu = 0.01) annotation(
    Placement(transformation(origin = {-17, -3}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(dUPhaseEvt = 0.416, tUPhaseEvt = 10)  annotation(
    Placement(transformation(origin = {80, -2}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = 1000)  annotation(
    Placement(transformation(origin = {23, -3}, extent = {{-7, -7}, {7, 7}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMVSMConvPLL.switchOffSignal1 = false;
  DynGFMVSMConvPLL.switchOffSignal2 = false;
  DynGFMVSMConvPLL.switchOffSignal3 = false;
  connect(omegaRefPu.y, DynGFMVSMConvPLL.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-50, 20}, {-50, 6}, {-42, 6}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSMConvPLL.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-60, -20}, {-60, -12}, {-42, -12}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMVSMConvPLL.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-56, -60}, {-56, -21}, {-42, -21}}, color = {0, 0, 127}));
  connect(PRefPu.y, DynGFMVSMConvPLL.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-102, 53}, {-42, 53}, {-42, 15}}, color = {0, 0, 127}));
  connect(line.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{56, -2}, {80, -2}}, color = {0, 0, 255}));
  connect(DynGFMVSMConvPLL.terminal, measurements.terminal1) annotation(
    Line(points = {{8, -2}, {16, -2}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line.terminal1) annotation(
    Line(points = {{30, -2}, {36, -2}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Documentation(info = "<html><head></head><body><div><div>This test case is part of a larger framework aiming at comparing different GFM control architectures with a standard Angle Phase jump at an Infinite Bus. The chosen test case belongs to the I18 Grid code under the name S_VoltageAngleStep7_OC4 corresponding to :&nbsp;</div><div>- An operating condition of P=0.95 p.u. and Q=0 p.u.</div><div>- An angle step at the voltage bus of 0.416 rad ~ 26.47°</div><div>- A &nbsp;minimal Short Circuit Ratio (SCR) representing a \"weak grid\".</div><div><br></div><div>Tested architectures feature :&nbsp;</div><div>- A dynamic Virtual Synchronous Machine control which is taken as referenc (DynGFMVSM) with Virtual Impedance as current limitation.</div><div>- A dynamic Virtual Synchronous Machine control but with the frequency in the converter being the one measured by the PLL (DynGFMConvPLL). The \"physics\" meaning of this model is yet to be understood and we are wondering of its added value given it produces almors identical results with the former DynGFMVSM model.&nbsp;</div><div>- An hybrid current controlled VSM (DynGFMCCVSM) with Virtual Impedance limitation and Current Saturation.&nbsp;</div><div>- A dynamic Droop control (DynGFMDroop)</div><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t=10s, a phase jump is simulated with a value of +0.416 radians, corresponding to the&nbsp;</span>S_VolAngStep7_0C4 scenario depicted in the I18 documentation.&nbsp;</div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of PPu : the active power in p.u measured at the Point of Common Coupling (PCC)&nbsp;</span><span style=\"font-size: 12px;\">in base SNom</span><span style=\"font-size: 12px;\">, with the generator convention.</span></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Fig 1 : Active power in p.u measured at the PCC.</b></div></div></div></div><div><b><br></b></div><div><div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/S_VoltAngleStep7_OC4.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"));
end DynGFMVSMSmibConvPLL;
