within Dynawo.Examples.GridForming;

model DynGFMVSMSmib "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer"
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
  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.000166667, XPu = 0.005) annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(CFilterPu = 1e-05, H = 3, IMaxVI = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, Kic = 15, KpVI = 0.6, Kpc = 0.477465, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = -9.94, Q0Pu = 0.65, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.997, UPhase0 = 0.05, Wf = 31.4159, Wff = 60, XRratio = 10, XVI = 0, kVSM = 155.955, OmegaSetPu = 1, tVSC = 0.0004) annotation(
    Placement(transformation(origin = {-21, -1}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = 1)  annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.AcGrid AcGrid(RoCoFValue = 0, SNom = 1000, U0pu = 1, UPhase = 0, UPhase0 = 0, Upu = 1) annotation(
    Placement(transformation(origin = {44, 64}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations_PhaseJump infiniteBusWithVariations_PhaseJump(U0Pu = 1, UEvtPu = 1, omega0Pu = 1, omegaEvtPu = 1, UPhase = 0, tUEvtStart = 0, tUEvtEnd = 0, tOmegaEvtStart = 0, tOmegaEvtEnd = 0, dUPhaseEvt = 0.46, tUPhaseEvt = 10)  annotation(
    Placement(transformation(origin = {72, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal1 = false;
  DynGFMVSM.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal3 = false;
  connect(DynGFMVSM.terminal, line.terminal1) annotation(
    Line(points = {{4, -1}, {19, -1}, {19, 0}, {34, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-50, 20}, {-50, 8}, {-46, 8}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-60, -20}, {-60, -10}, {-46, -10}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMVSM.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-56, -60}, {-56, -19}, {-46, -19}}, color = {0, 0, 127}));
  connect(PRefPu.y, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-102, 17}, {-46, 17}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, AcGrid.OmegaRef) annotation(
    Line(points = {{-100, 20}, {-56, 20}, {-56, 70}, {32, 70}}, color = {0, 0, 127}));
  connect(AcGrid.aCPower, line.terminal2) annotation(
    Line(points = {{56, 70}, {54, 70}, {54, 0}}, color = {0, 0, 255}));
  annotation(
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Documentation(info = "<html><head></head><body>This test case consists of a current-controlled grid-forming converter based on a Virtual Synchronous Machine Control (VSM), with current limitation enforced through a proportional virtual impedance (activated above IMaxVI) combined with a Quasi-Static Electrical Model to translate the resulting voltage reference into a current reference.<br><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t = 7 s the reference active power PRefPu increases from 0.75 to 1.00 pu with a step.</span></div><div><span style=\"font-size: 12px;\">- At t = 10 s, a sudden increase in frequency at the bus is simulated (88% increase in p.u. over 0.0001 s)</span></div><div><span style=\"font-size: 12px;\">- At t = 20 s, an increase of 4% at the bus voltage happens. Return to the original value is made after 3 seconds.</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of PFilterRefPu (reference active power in p.u. for the GFM) and PFilterPu : the active power in p.u measured at the RLC filter of the Converter block.&nbsp;</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">As a note, the whole converter block is computed in the Real-Imaginary frame i.e. same as the grid's. A previous version of this model existed with the Converter block in the GFM rotating frame (DQ) and produced identical results.&nbsp;</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Fig 1 : Reference active power in p.u measured at the RLC Filter.</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/DynGFMVSM.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\" <=\"\" div=\"\"></div></div></div></body></html>"));
end DynGFMVSMSmib;
