within Dynawo.Examples.GridForming;

model DynGFMVSMSmib2 "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
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
  parameter Types.Time tOmegaEvtStart = 10;
  parameter Types.Time tOmegaEvtEnd = 10.0001;
  parameter Types.Time tMagnitudeEvtstart = 20;
  parameter Types.Time tMagnitudeEvtEnd = 20 + 3;
  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = 1, UEvtPu = 1.04, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1.88, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005) annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.25, offset = 0.75, startTime = 7) annotation(
    Placement(visible = true, transformation(origin = {-112, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM2 dynGFMVSM2(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = 0, Q0Pu = 0, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 1, UPhase0 = 0, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0, kVSM = 155.955, OmegaSetPu = 1, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {-16, 2}, extent = {{-20, -20}, {20, 20}})));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  connect(line.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{54, 0}, {82, 0}}, color = {0, 0, 255}));
  connect(dynGFMVSM2.terminal, line.terminal1) annotation(
    Line(points = {{6, 2}, {19, 2}, {19, 0}, {34, 0}}, color = {0, 0, 255}));
  connect(PRefPu.y, dynGFMVSM2.PFilterRefPu) annotation(
    Line(points = {{-100, 60}, {-100, 62}, {-38, 62}, {-38, 18}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, dynGFMVSM2.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-60, 20}, {-60, 10}, {-38, 10}}, color = {0, 0, 127}));
  connect(QRefPu.y, dynGFMVSM2.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-60, -20}, {-60, -6}, {-38, -6}}, color = {0, 0, 127}));
  connect(URefPu.y, dynGFMVSM2.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-54, -60}, {-54, -14}, {-38, -14}}, color = {0, 0, 127}));
  annotation(
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
    experiment(StartTime = 0, StopTime = 0.1, Tolerance = 1e-06, Interval = 9.6432e-05),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This test case consists of a current-controlled grid-forming converter based on a Virtual Synschronous Machine Control (VSM) and current saturation enforced through a Quasi-Static Electrical Model with Virtual Impedance.</span><span style=\"font-size: 12px;\">&nbsp;</span><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations</div><div><span style=\"font-size: 12px;\">At t = 7 s the reference active power PRefPu increases from 0.75 to 1.00 pu with a step.</span></div><div><span style=\"font-size: 12px;\">At t = 10 s, a sudden increase in frequency at the bus is simulated (88% increase in p.u. over 0.0001 s)</span></div><div><span style=\"font-size: 12px;\">At t = 20 s, an increase of 4% at the bus voltage happens. Return to the original value is made after 3 seconds.</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of PFilterRefPu (reference active power in p.u. for the GFM) and PFilterPu : the active power in p.u.&nbsp;</span></div><div><div style=\"font-size: 12px;\"><b>Reference active power in p.u.</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/DynGFMVSM.png\"></div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"));
end DynGFMVSMSmib2;
