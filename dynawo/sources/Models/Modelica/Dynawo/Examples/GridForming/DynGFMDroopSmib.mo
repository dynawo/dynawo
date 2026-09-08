within Dynawo.Examples.GridForming;

model DynGFMDroopSmib "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
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
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.0005, XPu = 0.005) annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations_PhaseJump infiniteBusWithVariations_PhaseJump(U0Pu = 1, UEvtPu = 1, omega0Pu = 1, omegaEvtPu = 1, UPhase = 0, tUEvtStart = 0, tUEvtEnd = 0, tOmegaEvtStart = 0, tOmegaEvtEnd = 0, dUPhaseEvt = 0.110, tUPhaseEvt = 10) annotation(
    Placement(transformation(origin = {72, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop DynGFMDroop(CFilterPu = 1e-05, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0,  KpVI = 0.1, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.013, P0Pu = -9.445729820158455, Q0Pu = 0.990250383382483, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.998628737778962, UPhase0 = 0.047807515026634, Wf = 40, Wff = 50, XRratio = 10, XVI = 0.06, tVSC = 0.0004, Mp = 0.013, omegaC = 1000, omegaNPLL = 100, ZetaPLL = 1)  annotation(
    Placement(transformation(origin = {-14, -2}, extent = {{-28, -28}, {28, 28}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal1 = false;
  DynGFMDroop.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal3 = false;
  connect(DynGFMDroop.terminal, line.terminal1) annotation(
    Line(points = {{17, -2}, {26.5, -2}, {26.5, 0}, {34, 0}}, color = {0, 0, 255}));
  connect(PRefPu.y, DynGFMDroop.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-102, 20}, {-45, 20}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMDroop.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-50, -20}, {-50, -13}, {-45, -13}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMDroop.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-100, -24}, {-45, -24}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMDroop.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-45, 20}, {-45, 9}}, color = {0, 0, 127}));
  connect(line.terminal2, infiniteBusWithVariations_PhaseJump.terminal) annotation(
    Line(points = {{54, 0}, {72, 0}, {72, -44}}, color = {0, 0, 255}));
  annotation(
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Documentation(info = "<html><head></head><body><div>This test case is part of a larger framework aiming at comparing different GFM control architectures with a standard Angle Phase jump at an Infinite Bus.&nbsp;</div><div><br></div><div>Tested architectures feature :&nbsp;</div><div>- A dynamic Virtual Synchronous Machine control which is taken as referenc (DynGFMVSM)</div><div>- A dynamic Virtual Synchronous Machine control but with the frequency in the converter being the one measured by the PLL (DynGFMConvPLL). The \"physics\" mzeaning of this model is yet to be understood and we are wondering of its added value given it produces almors identical results with the former DynGFMVSM model.&nbsp;</div><div>- A dynamic Droop control (DynGFMDroop)</div><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t=10s, a phase jump is simulated with a value of +0.110 radians, corresponding to the&nbsp;</span>S_VolAngStep1_0C4 scenario depicted in the I18 documentation.&nbsp;</div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of PFilterPu : the active power in p.u measured at the RLC filter of the Converter block for all three models. Note that the DynGFMVSM and DynGFmVsmConvPLL produce very similar results.&nbsp;</span></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Fig 1 : Active power in p.u measured at the RLC Filter.</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/DynGFMComparison.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"));
end DynGFMDroopSmib;
