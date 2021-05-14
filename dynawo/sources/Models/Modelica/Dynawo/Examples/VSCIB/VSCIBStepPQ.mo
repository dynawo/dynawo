within Dynawo.Examples.VSCIB;

model VSCIBStepPQ "Grid following Voltage Source Converter with infinite bus - Active and reactive power reference tracking test"
  /*
  * Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
  */
  import Dynawo;
  extends Icons.Example;

  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 0.90081) annotation(
    Placement(visible = true, transformation(origin = {-68, -4}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.022522) annotation(
    Placement(visible = true, transformation(origin = {-34, 14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0, XPu = 0.04189) annotation(
    Placement(visible = true, transformation(origin = {-34, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {24, -4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Electrical.Sources.GfolConverter gfolConverter(Cdc = 0.01, Cfilter = 0.066, ConvFixLossPu = 0, ConvVarLossPu = 0, DroopFP = 0, DroopUQ = 0, IdConv0Pu = 0.5, IdPcc0Pu = 0.5, IdcSource0Pu = 0.45, ImaxPu = 1.1, IqConv0Pu = 0, IqPcc0Pu = 0, KiPll = 100, Kic = 10, KpPll = 0.3, Kpc = 1, Kpdc = 50, Lfilter = 0.15, Ltransformer = 0.2, P0Pu = 0.45, PRef0Pu = 0.45, PmaxPu = 0.9, PstepHPu = 0.3, Q0Pu = 0, QRef0Pu = 0, QmaxPu = 0.3, QstepHPu = 0.3, RPmaxPu = 0, Rfilter = 0.005, Rtransformer = 0.01, SNom = 100, Theta0 = 0, URef0Pu = 0.9, UdConv0Pu = 0.9, UdFilter0Pu = 0.9, UdcSource0Pu = 1, UqConv0Pu = 0, UstepHPu = 0, i0Pu = Complex(-0.5, 0), t_Pstep = 0.6, t_Qstep = 1.2, t_Ustep = 0, tauIdRef = 0.04, tauIqRef = 0.04, u0Pu = Complex(0.9, 0)) annotation(
    Placement(visible = true, transformation(origin = {70, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.05, tBegin = 2, tEnd = 2.1) annotation(
    Placement(visible = true, transformation(origin = {6, -34}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

equation
  connect(line2.terminal2, transformer.terminal1) annotation(
    Line(points = {{-14, -20}, {-2, -20}, {-2, -4}, {4, -4}}, color = {0, 0, 255}));
  connect(line1.terminal2, transformer.terminal1) annotation(
    Line(points = {{-14, 14}, {-1, 14}, {-1, -4}, {4, -4}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-54, 14}, {-54, -4}, {-68, -4}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-54, -20}, {-54, -4}, {-68, -4}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, transformer.terminal1) annotation(
    Line(points = {{6, -34}, {-2, -34}, {-2, -15}, {4, -15}, {4, -4}}, color = {0, 0, 255}));
  connect(transformer.terminal2, gfolConverter.aCPower) annotation(
    Line(points = {{44, -4}, {59, -4}}, color = {0, 0, 255}));
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
//__OpenModelica_commandLineOptions = "--daeMode",

protected
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 0.000001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case represents a 2220 MWA synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a 0.02 p.u. step variation on the generator mechanical power Pm occurring at t=1s.
    </div><div><br></div><div>The two following figures show the expected evolution of the generator's voltage and active power during the simulation.
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/PGen.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/UStatorPu.png\">
    </figure>
    We observe that the active power is increased by 44.05 MW. The voltage drop between the infinite bus and the machine terminal is consequently increased, resulting in a decrease of the machine terminal voltage.
    </div><div><br></div><div>Initial equation are provided on the generator's differential variables to ensure a steady state initialisation by the Modelica tool. It had to be written here and not directly in Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous because the Dynawo simulator applies a different initialisation strategy that does not involve the initial equation section.
    </div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
    "));
end VSCIBStepPQ;
