within Dynawo.Examples.IECWT4AIB;

model IECWT4A "GWind Turbine Type 4A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"

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

  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.022522) annotation(
    Placement(visible = true, transformation(origin = {-39, 25}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0, XPu = 0.04189) annotation(
    Placement(visible = true, transformation(origin = {-39, -23}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {32, 6.66134e-16}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.001, tBegin = 2, tEnd = 2.2) annotation(
    Placement(visible = true, transformation(origin = {41, -49}, extent = {{-19, 19}, {19, -19}}, rotation = 0)));
  BaseModel.IECWT4A iecwt4a(Bes = 0.0001, Dipmax = 1, Diqmax = 100, Diqmin = -100, Ges = 0.0001, IpMax0Pu = 1.2, IqMax0Pu = 0.4, IqMin0Pu = -0.4, Kiq = 0, Kiu = 0, Kpq = 1.1, Kpqu = 20, Kpu = 2, Kpufrt = 0, Kqv = 2, Les = 0.15, Mdfslim = 0, MpUscale = 0, MqG = 1, Mqfrt = 0, Mqpri = 1, P0Pu = -1.8, PstepHPu = -0.4, Q0Pu = 0, QMax0Pu = 0.33, QMin0Pu = -0.33, QstepHPu = 0.3, Rdrop = 0, Res = 0.05, SNom = 200, TanPhi = 0.3, Td = 0, Tg = 0.01, Theta0 = 0.04, TpWTref4A = 0.001, Tpll = 0.01, Tpordp4A = 0.1, Tqord = 0.001, Ts = 0, Tuss = 0.01, Upll1 = 999, Upll2 = 0.13, Xdrop = 0, dpmaxp4A = 1, dprefmax4A = 100, dprefmin4A = -100, i0Pu = Complex(-1.8, 0), iMax = 1.3, iMaxDip = 1.3, iMaxHookPu = 0, idfHook = 0, ipfHook = 0, iqMax = 1.05, iqMaxHook = 0, iqMin = -1.05, iqPost = 0, iqh1 = 1.05, t_Pstep = 0.1, t_Qstep = 1, u0Pu = Complex(1, 0), uMax = 1.1, uMin = 0.9, udbOne = -0.1, udbTwo = 0.1, upDip = 0, upquMax = 1.1, uqDip = 0.9, uqRise = 1.1)  annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-64, 25}, {-64, 0}, {-98, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-64, -23}, {-64, 0}, {-98, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, transformer.terminal1) annotation(
    Line(points = {{-14, 25}, {0, 25}, {0, 0}, {8, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, transformer.terminal1) annotation(
    Line(points = {{-14, -23}, {0, -23}, {0, 0}, {8, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line2.terminal2) annotation(
    Line(points = {{42, -48}, {-14, -48}, {-14, -23}}, color = {0, 0, 255}));
  connect(transformer.terminal2, iecwt4a.aCPower) annotation(
    Line(points = {{56, 0}, {78, 0}, {78, 0}, {78, 0}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.004),
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
    "),
    Diagram(graphics = {Rectangle(extent = {{88, 12}, {88, 12}})}, coordinateSystem(initialScale = 0.1)));

end IECWT4A;
