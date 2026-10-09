within Dynawo.Examples.GridForming.Tests.Test_NodeFault;

model CCVSM_NodeFault "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
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
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.001, XPu = 0.01) annotation(
    Placement(transformation(origin = {76, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.5) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = 1000)  annotation(
    Placement(transformation(origin = {28, 2}, extent = {{-10, -10}, {10, 10}})));
 Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations annotation(
    Placement(transformation(origin = {98, 2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Electrical.Events.NodeFault nodeFault(RPu = 1e-6, XPu = 1e-5, tBegin = 5, tEnd = 5.150)  annotation(
    Placement(transformation(origin = {66, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
 Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMCCVSM DynGFMCCVSM(CFilterPu = 1e-05, DeltaIConvMaxPu = 0.15, H = 5, IMaxVIPu = 1.1, ImaxPu = 1.2, IminPu = 0, KDampingAngle = 0.00318, Kfd = 1, Kff = 0.01, Kfq = 0.8, KpVI = 0.6, KsiPLL = 1, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, OmegaPLL = 100, OmegaSetPu = 1, Omegac = 1000, Omegaf = 31.4159, Omegaff = 60, P0Pu = -9.440193302496278, Q0Pu = -0.5430730020626036, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.947115101091565, UPhase0 = 0.5184088727446441, XRratio = 10, XVIPu = 0.06, kVSM = 600, tUFilt = 0.02, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {-26, 2}, extent = {{-20, -20}, {20, 20}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMCCVSM.switchOffSignal1 = false;
  DynGFMCCVSM.switchOffSignal2 = false;
  DynGFMCCVSM.switchOffSignal3 = false;
  connect(measurements.terminal2, line.terminal1) annotation(
    Line(points = {{38, 2}, {66, 2}}, color = {0, 0, 255}));
  connect(line.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{86, 2}, {98, 2}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal1) annotation(
    Line(points = {{66, -34}, {66, 2}}, color = {0, 0, 255}));
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
    Documentation(info = "<html><head></head><body><div>This test case is part of a larger framework aiming at comparing different GFM control architectures with a standard Angle Phase jump at an Infinite Bus.&nbsp;</div><div><br></div><div>Tested architectures feature :&nbsp;</div><div>- A dynamic Virtual Synchronous Machine control which is taken as referenc (DynGFMCCVSM)</div><div>- A dynamic Virtual Synchronous Machine control but with the frequency in the converter being the one measured by the PLL (DynGFMConvPLL). The \"physics\" mzeaning of this model is yet to be understood and we are wondering of its added value given it produces almors identical results with the former DynGFMCCVSM model.&nbsp;</div><div>- A dynamic Droop control (DynGFMDroop)</div><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t=10s, a phase jump is simulated with a value of +0.110 radians, corresponding to the&nbsp;</span>S_VolAngStep1_0C4 scenario depicted in the I18 documentation.&nbsp;</div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of PFilterPu : the active power in p.u measured at the RLC filter of the Converter block for all three models. Note that the DynGFMCCVSM and DynGFMCCVSMConvPLL produce very similar results.&nbsp;</span></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Fig 1 : Active power in p.u measured at the RLC Filter.</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/DynGFMComparison.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"),
    Diagram);
end CCVSM_NodeFault;
