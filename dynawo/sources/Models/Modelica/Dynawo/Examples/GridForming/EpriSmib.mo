within Dynawo.Examples.GridForming;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

model EpriSmib "Single machine infinite bus test case for EPRI Grid Forming model"
  extends Icons.Example;

  Modelica.Blocks.Sources.Step deltaOmega(height = 0, offset = 0, startTime = 1e9) annotation(
    Placement(visible = true, transformation(origin = {120, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.EPRI.EpriGFM epriGfm(DD = 0.11, DeltaOmegaMaxPu = 75 / SystemBase.omegaNom, DeltaOmegaMinPu = -75 / SystemBase.omegaNom, IMaxPu = 1.05, IdConv0Pu(fixed = false), IqConv0Pu(fixed = false), K1 = 0.05, K2 = 0.2, K2Dvoc = 1e-9, KD = 0, KIPll = 700, KIi = 5, KIp = 10, KIv = 10, KPPll = 20, KPi = 0.5, KPp = 2, KPv = 2, MF = 0.15, OmegaDroopPu = 0.05, OmegaFlag = 1, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, P0Pu = -0.657, PQFlag = true, Q0Pu = -0.0228928, QDroopPu = 0.2, RSourcePu = 0.00015, SNom = 100, Theta0 = 0.188732, U0Pu = 0.995421, UDipPu = 0.8, UdConv0Pu(fixed = false), UdFilter0Pu(fixed = false), UqConv0Pu(fixed = false), UqFilter0Pu(fixed = false), XSourcePu = 0.15, i0Pu(im(fixed = false), re(fixed = false)), tE = 0.01, tF = 1e-9, tR = 0.005, tV = 1e-9, u0Pu(im(fixed = false), re(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 0.5, UPhase = 0, omega0Pu = 1, omegaEvtPu = 0.999, tOmegaEvtEnd = 4, tOmegaEvtStart = 0.5, tUEvtEnd = 100, tUEvtStart = 90) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000199, XPu = 0.18699, state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.009751 + 1e-4, XPu = 0.097514 + 1e-4, state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.0014056, tBegin = 6, tEnd = 6.2) annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step PAux(height = 0, offset = 0, startTime = 1e9) annotation(
    Placement(visible = true, transformation(origin = {120, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef(height = 0, offset = -epriGfm.P0Pu * SystemBase.SnRef / epriGfm.SNom, startTime = 1e9) annotation(
    Placement(visible = true, transformation(origin = {120, 14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QAux(height = 0, offset = 0, startTime = 1e9) annotation(
    Placement(visible = true, transformation(origin = {120, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef(height = 0, offset = -epriGfm.Q0Pu * SystemBase.SnRef / epriGfm.SNom, startTime = 1e9) annotation(
    Placement(visible = true, transformation(origin = {120, -18}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdFilterRef(height = 0, offset = epriGfm.U0Pu, startTime = 1e9) annotation(
    Placement(visible = true, transformation(origin = {120, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.EPRI.EpriGFM_INIT epriGFM_INIT(OmegaFlag = 1,P0Pu = -0.657, Q0Pu = -0.0228928, RSourcePu = 0.00015, SNom = 100, Theta0 = 0.188732, U0Pu = 0.995421, XSourcePu = 0.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  epriGfm.IdConv0Pu := epriGFM_INIT.IdConv0Pu;
  epriGfm.IqConv0Pu := epriGFM_INIT.IqConv0Pu;
  epriGfm.UdConv0Pu := epriGFM_INIT.UdConv0Pu;
  epriGfm.UqConv0Pu := epriGFM_INIT.UqConv0Pu;
  epriGfm.UdFilter0Pu := epriGFM_INIT.UdFilter0Pu;
  epriGfm.i0Pu.re := epriGFM_INIT.i0Pu.re;
  epriGfm.i0Pu.im := epriGFM_INIT.i0Pu.im;
  epriGfm.u0Pu.re := epriGFM_INIT.u0Pu.re;
  epriGfm.u0Pu.im := epriGFM_INIT.u0Pu.im;

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  epriGfm.injectorURI.switchOffSignal1.value = false;
  epriGfm.injectorURI.switchOffSignal2.value = false;
  epriGfm.injectorURI.switchOffSignal3.value = false;

  connect(epriGfm.terminal, line.terminal2) annotation(
    Line(points = {{60, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, line.terminal1) annotation(
    Line(points = {{-40, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-80, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, nodeFault.terminal) annotation(
    Line(points = {{-40, 0}, {-20, 0}, {-20, -40}}, color = {0, 0, 255}));
  connect(UdFilterRef.y, epriGfm.URefPu) annotation(
    Line(points = {{110, -80}, {62, -80}, {62, -12}}, color = {0, 0, 127}));
  connect(epriGfm.deltaOmegaPu, deltaOmega.y) annotation(
    Line(points = {{68, -12}, {68, -50}, {110, -50}}, color = {0, 0, 127}));
  connect(epriGfm.QRefPu, QRef.y) annotation(
    Line(points = {{74, -12}, {74, -34}, {102, -34}, {102, -18}, {110, -18}}, color = {0, 0, 127}));
  connect(epriGfm.PRefPu, PRef.y) annotation(
    Line(points = {{78, -12}, {78, -22}, {98, -22}, {98, 14}, {110, 14}}, color = {0, 0, 127}));
  connect(QAux.y, epriGfm.QAuxPu) annotation(
    Line(points = {{109, 50}, {66, 50}, {66, 12}}, color = {0, 0, 127}));
  connect(epriGfm.PAuxPu, PAux.y) annotation(
    Line(points = {{62, 12}, {62, 80}, {110, 80}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-6, Interval = 0.02),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This test case consists of a grid-forming converter based on the EPRI model. It has 4 modes (1-3 are grid-forming):</span><div><span style=\"font-size: 12px;\">0 - PLL based current control</span></div><div><span style=\"font-size: 12px;\">1 - Droop control</span></div><div><span style=\"font-size: 12px;\">2 - Virtual synchronous machine</span></div><div>3 - V<span style=\"font-size: 12px;\">irtual oscillator control</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">For this test case droop control is used.</span></div><div><span style=\"font-size: 12px;\">At t = 0.5 s the grid frequency is decreased by 0.005 pu and brought back to normal at 4s. At t = 6 s, a short-circuit occurs between the lines. It is cleared after 150ms. The grid-forming converters controls come from the EPRI</span>&nbsp;website:&nbsp;https://www.epri.com/research/products/000000003002021403.</div><div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">The two following figures show the evolution of active and reactive power and frequency for the converter during simulation.</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Active and reactive power</b></div><div style=\"font-size: 12px;\"><img width=\"450\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/epri_pq.png\"></div><div style=\"font-size: 12px;\"><div style=\"font-size: 12px;\"><div><b><br></b></div><div><b>Frequency</b></div><div><img width=\"450\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/epri_omega.png\"></div></div>One can remark that the results meet the expectations of the use of a grid-forming converter.</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">One can also remark that during the fault, the currents of the converter is limited at a value lower than 1.1 pu thanks to the current limitation. More details can be found in the EPRI documentation.</div></div></body></html>"),
    Diagram(coordinateSystem(extent = {{-100, -100}, {130, 100}})));
end EpriSmib;
