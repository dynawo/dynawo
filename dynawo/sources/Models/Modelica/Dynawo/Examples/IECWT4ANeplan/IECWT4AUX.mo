within Dynawo.Examples.IECWT4ANeplan;

model IECWT4AUX "GWind Turbine Type 4A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
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
    Placement(visible = true, transformation(origin = {-11, 0}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer2(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-85, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0.005, GPu = 0, RPu = 0.015, XPu = 0.025) annotation(
    Placement(visible = true, transformation(origin = {-49, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0.01, GPu = 0, RPu = 0.01, XPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {51, 20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {31, -20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {73, -20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line4(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0457) annotation(
    Placement(visible = true, transformation(origin = {111, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {46, -40}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));

  Dynawo.Examples.IECWT4ANeplan.BaseModel.IECWP4AAUX iecwp4aaux(Bes = 0, DipMax = 1, DiqMax = 100, DiqMin = -100, DpMaxp4A = 1, DpRefMax4A = 100, DpRefMin4A = -100, Ges = 0, IGsIm0Pu = 0.4231, IGsRe0Pu = 0.93, IMax = 1.3, IMaxDip = 1.3, IMaxHookPu = 0, IdfHook = 0, IpMax0Pu = 1.2, IpfHook = 0, IqH1 = 1.05, IqMax = 1.05, IqMax0Pu = 0.4, IqMaxHook = 0, IqMin = -1.05, IqMin0Pu = -0.4, IqPost = 0, Kiq = 0, Kiu = 0, Kiwpp = 5, Kiwpx = 5, Kpq = 1.1, Kpqu = 20, Kpu = 2, Kpufrt = 2, Kpwpp = 0.5, Kpwpx = 0.5, Kqv = -2, Kwppref = 0, Kwpqref = 0, Kwpqu = 0, Mdfslim = false, MpUScale = false, MqG = 2, Mqfrt = 1, Mqpri = true, Mwpqmode = 0, OmegastepHPu = 0, P0Pu = -1, PstepHPu = -0.5, Q0Pu = 0.21, QMax = 0.8, QMax0Pu = 0.8, QMin = -0.8, QMin0Pu = -0.8, QlConst = true, QstepHPu = 0.21, RDrop = 0, Res = 0, SNom = 100, TanPhi = 0.3, Td = 0, Tffilt = 0.01, Tg = 0.01, Tlag = 0.01, Tlead = 0.01, TpOrdp4A = 0.1, TpWTRef4A = 0.01, Tpfilt = 0.01, Tpll = 0.01, TqOrd = 0.05, Tqfilt = 0.01, Ts = 0.001, Tufilt = 0.01, Tuqfilt = 0.01, Tuss = 1, U0Pu = 1, UGsIm0Pu = 0.2182, UGsRe0Pu = 0.9758, UMax = 1.1, UMin = 0.9, UPhase0 = 0.22, UdbOne = -0.1, UdbTwo = 0.1, UpDip = 0, Upll1 = 999, Upll2 = 0.13, UpquMax = 1.1, UqDip = 0.9, UqRise = 1.1, XDrop = 0, Xes = 0, dpRefMax = 100, dpRefMin = -100, dpWPRefMax = 100, dpWPRefMin = -100, dxRefMax = 100, dxRefMin = -100, i0Pu = Complex(-0.93, -0.4231), pErrMax = 1, pErrMin = -1, pKIWPpMax = 2, pKIWPpMin = 0, pRefMax = 2, pRefMin = 0, pWPHookPu = 0, t_Omegastep = 0, t_Pstep = 2, t_Qstep = 4, u0Pu = Complex(0.9758, 0.2182), uWPqdip = 0.9, uWPqrise = 1.1, xKIWPxMax = 10, xKIWPxMin = -10, xRefMax = 0.33, xRefMin = -0.33, xerrmax = 1, xerrmin = -1)  annotation(
  Placement(visible = true, transformation(origin = {-126, 0}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));

  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.0678, UEvtPu = 0.5, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = 0.995, tOmegaEvtEnd = 18.15, tOmegaEvtStart = 18, tUEvtEnd = 15.25, tUEvtStart = 15)  annotation(
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
    Line(points = {{-70, 0}, {-64, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, transformer.terminal2) annotation(
    Line(points = {{-34, 0}, {-26, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal1, line2.terminal1) annotation(
    Line(points = {{4, 0}, {10, 0}, {10, -20}, {16, -20}}, color = {0, 0, 255}));
  connect(line2.terminal2, line3.terminal1) annotation(
    Line(points = {{46, -20}, {58, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal1, line1.terminal1) annotation(
    Line(points = {{4, 0}, {10, 0}, {10, 20}, {36, 20}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line2.terminal2) annotation(
    Line(points = {{46, -40}, {46, -20}}, color = {0, 0, 255}));
  connect(line3.terminal2, line4.terminal1) annotation(
    Line(points = {{88, -20}, {96, -20}, {96, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, line4.terminal1) annotation(
    Line(points = {{66, 20}, {96, 20}, {96, 0}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, transformer2.terminal1) annotation(
    Line(points = {{-100, -40}, {-100, -40}, {-100, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(line4.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{126, 0}, {138, 0}}, color = {0, 0, 255}));
  connect(iecwp4aaux.aCPower, transformer2.terminal1) annotation(
    Line(points = {{-109, 0}, {-100, 0}}, color = {0, 0, 255}));
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

end IECWT4AUX;
