within Dynawo.Examples.IECWT4ANeplan;

model IECWT4A "GWind Turbine Type 4A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  /*
  * Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.1, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-1, 0}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer2(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-83, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0.005, GPu = 0, RPu = 0.015, XPu = 0.025) annotation(
    Placement(visible = true, transformation(origin = {-41, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0.01, GPu = 0, RPu = 0.01, XPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {59, 20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {41, -20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {77, -20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {56, -40}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));

  Dynawo.Examples.IECWT4ANeplan.BaseModel.IECWT4A iecwt4a(Bes = 0, DipMax = 1, DiqMax = 100, DiqMin = -100, DpMaxp4A = 1, DpRefMax4A = 100, DpRefMin4A = -100, Ges = 0, IGsIm0Pu = 0.423168, IGsRe0Pu = 0.930069, IMax = 1.3, IMaxDip = 1.3, IMaxHookPu = 0, IdfHook = 0, IpMax0Pu = 1.2, IpfHook = 0, IqH1 = 1.05, IqMax = 1.05, IqMax0Pu = 0.4, IqMaxHook = 0, IqMin = -1.05, IqMin0Pu = -0.4, IqPost = 0, Kiq = 2.25, Kiu = 10, Kpq = 1.1, Kpqu = 20, Kpu = 2, Kpufrt = 2, Kqv = -2, Mdfslim = false, MpUScale = false, MqG = 1, Mqfrt = 1, Mqpri = true, OmegastepHPu = 0, P0Pu = -1, PstepHPu = -0.5, Q0Pu = 0.21, QMax = 0.8, QMax0Pu = 0.8, QMin = -0.8, QMin0Pu = -0.8, QlConst = true, RWTDrop = 0, Res = 0, SNom = 100, Td = 0, Tffilt = 0.01, Tg = 0.01, TpOrdp4A = 0.1, TpWTRef4A = 0.01, Tpfilt = 0.01, Tpll = 0.01, TqOrd = 0.05, Tqfilt = 0.01, Ts = 0.001, Tufilt = 0.01, Tuss = 1, U0Pu = 1, UGsIm0Pu = 0.21823, UGsRe0Pu = 0.975897, UMax = 1.1, UMin = 0.9, UPhase0 = 0.22, UdbOne = -0.1, UdbTwo = 0.1, UpDip = 0, Upll1 = 999, Upll2 = 0.13, UpquMax = 1.1, UqDip = 0.9, UqRise = 1.1, XWT0Pu = -0.21, XWTDrop = 0, Xes = 0, XstepHPu = 0.21, dfMax = 1, dfMin = -1, fOver = 1.1, fUnder = 0.9, i0Pu = Complex(-0.930069, -0.423168), t_Omegastep = 0, t_Pstep = 2, t_Xstep = 4, u0Pu = Complex(0.975897, 0.2183), uOver = 1.1, uUnder = 0.9)  annotation(
  Placement(visible = true, transformation(origin = {-124, 0}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line line4(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0457) annotation(
    Placement(visible = true, transformation(origin = {107, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0, tBegin = 120, tEnd = 120.15) annotation(
    Placement(visible = true, transformation(origin = {-98, -40}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.0678, UEvtPu = 0, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = 0.99, tOmegaEvtEnd = 21, tOmegaEvtStart = 20, tUEvtEnd = 0, tUEvtStart = 0)  annotation(
    Placement(visible = true, transformation(origin = {138, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  line4.switchOffSignal1.value = false;
  line4.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  transformer2.switchOffSignal1.value = false;
  transformer2.switchOffSignal2.value = false;
  connect(transformer2.terminal2, line.terminal1) annotation(
    Line(points = {{-68, 0}, {-56, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, transformer.terminal2) annotation(
    Line(points = {{-26, 0}, {-16, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal1, line2.terminal1) annotation(
    Line(points = {{14, 0}, {20, 0}, {20, -20}, {26, -20}}, color = {0, 0, 255}));
  connect(line2.terminal2, line3.terminal1) annotation(
    Line(points = {{56, -20}, {62, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal1, line1.terminal1) annotation(
    Line(points = {{14, 0}, {20, 0}, {20, 20}, {44, 20}}, color = {0, 0, 255}));
  connect(iecwt4a.aCPower, transformer2.terminal1) annotation(
    Line(points = {{-107.5, 0}, {-98, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line2.terminal2) annotation(
    Line(points = {{56, -40}, {56, -20}}, color = {0, 0, 255}));
  connect(line1.terminal2, line4.terminal1) annotation(
    Line(points = {{74, 20}, {92, 20}, {92, 0}}, color = {0, 0, 255}));
  connect(line3.terminal2, line4.terminal1) annotation(
    Line(points = {{92, -20}, {92, 0}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, transformer2.terminal1) annotation(
    Line(points = {{-98, -40}, {-98, 0}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, line4.terminal2) annotation(
    Line(points = {{138, 0}, {120, 0}, {120, 0}, {122, 0}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 4, Tolerance = 1e-06, Interval = 0.004),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case represents a 2220 MWA synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a 0.02 pu step variation on the generator mechanical power Pm occurring at t=1s.
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
    Diagram(coordinateSystem(extent = {{-140, -80}, {140, 80}}, initialScale = 0.1)));
end IECWT4A;
