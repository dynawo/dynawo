within Dynawo.Examples.GridForming;

model DynGFMVSMSmibConvPLL "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
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
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSMConvPLL DynGFMVSMConvPLL(CFilterPu = 1e-05, H = 5, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = -9.440979955569425, Q0Pu = -0.642916511452948, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.954110360567147, UPhase0 = 0.513677943263305, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0.06, kVSM = 650, OmegaSetPu = 1, tVSC = 0.0004, omegaNPLL = 100, ZetaPLL = 1, omegaC = 1000) annotation(
    Placement(transformation(origin = {-17, -3}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations_PhaseJump infiniteBusWithVariations_PhaseJump1(U0Pu = 1, UEvtPu = 1, UPhase = 0, dUPhaseEvt = 0.462, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0, tUPhaseEvt = 10) annotation(
    Placement(transformation(origin = {80, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMVSMConvPLL.switchOffSignal1 = false;
  DynGFMVSMConvPLL.switchOffSignal2 = false;
  DynGFMVSMConvPLL.switchOffSignal3 = false;
  connect(DynGFMVSMConvPLL.terminal, line.terminal1) annotation(
    Line(points = {{8, -3}, {19, -3}, {19, -2}, {36, -2}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, DynGFMVSMConvPLL.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-50, 20}, {-50, 6}, {-42, 6}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSMConvPLL.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-60, -20}, {-60, -12}, {-42, -12}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMVSMConvPLL.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-56, -60}, {-56, -21}, {-42, -21}}, color = {0, 0, 127}));
  connect(PRefPu.y, DynGFMVSMConvPLL.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-102, 53}, {-42, 53}, {-42, 15}}, color = {0, 0, 127}));
  connect(line.terminal2, infiniteBusWithVariations_PhaseJump1.terminal) annotation(
    Line(points = {{56, -2}, {80, -2}, {80, -46}}, color = {0, 0, 255}));
  annotation(
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Documentation(info = "<html><head></head><body><div>This test case is part of a larger framework aiming at comparing different GFM control architectures with a standard Angle Phase jump at an Infinite Bus.&nbsp;</div><div><br></div><div>Tested architectures feature :&nbsp;</div><div>- A dynamic Virtual Synchronous Machine control which is taken as referenc (DynGFMVSM)</div><div>- A dynamic Virtual Synchronous Machine control but with the frequency in the converter being the one measured by the PLL (DynGFMConvPLL). The \"physics\" mzeaning of this model is yet to be understood and we are wondering of its added value given it produces almors identical results with the former DynGFMVSM model.&nbsp;</div><div>- A dynamic Droop control (DynGFMDroop)</div><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t=10s, a phase jump is simulated with a value of +0.110 radians, corresponding to the&nbsp;</span>S_VolAngStep1_0C4 scenario depicted in the I18 documentation.&nbsp;</div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of PFilterPu : the active power in p.u measured at the RLC filter of the Converter block for all three models. Note that the DynGFMVSM and DynGFmVsmConvPLL produce very similar results.&nbsp;</span></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Fig 1 : Active power in p.u measured at the RLC Filter.</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/DynGFMComparison.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"));
end DynGFMVSMSmibConvPLL;
