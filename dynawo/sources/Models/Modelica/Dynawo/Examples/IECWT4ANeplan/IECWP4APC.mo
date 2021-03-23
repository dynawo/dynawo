within Dynawo.Examples.IECWT4ANeplan;

model IECWP4APC "GWind Turbine Type 4A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
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
  import Modelica;
  import Dynawo;

  extends Icons.Example;
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.1, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-23, 0}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0.005, GPu = 0, RPu = 0.015, XPu = 0.025) annotation(
    Placement(visible = true, transformation(origin = {-73, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0.01, GPu = 0, RPu = 0.01, XPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {51, 20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {31, -20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {77, -20}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line4(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0457) annotation(
    Placement(visible = true, transformation(origin = {111, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {46, -40}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));

  Dynawo.Examples.IECWT4ANeplan.BaseModel.IECWP4APC iecwp4aPC(Bes = 0, DipMax = 1, DiqMax = 100, DiqMin = -100, DpMaxp4A = 1, DpRefMax4A = 100, DpRefMin4A = -100, Ges = 0, IGsIm0Pu = 0.4231, IGsRe0Pu = 0.93, IMax = 1.3, IMaxDip = 1.3, IMaxHookPu = 0, IdfHook = 0, IpMax0Pu = 1.2, IpfHook = 0, IqH1 = 1.05, IqMax = 1.05, IqMax0Pu = 0.4, IqMaxHook = 0, IqMin = -1.05, IqMin0Pu = -0.4, IqPost = 0, Kiq = 0, Kiu = 0, Kiwpp = 5, Kiwpx = 10, Kpq = 1.1, Kpqu = 20, Kpu = 2, Kpufrt = 2, Kpwpp = 2.25, Kpwpx = 0.5, Kqv = -2, Kwppref = 0, Kwpqref = 0, Kwpqu = 0, Mdfslim = true, MpUScale = false, MqG = 2, Mqfrt = 1, Mqpri = true, Mwpqmode = 0, OmegastepHPu = 0, P0Pu = -1, PstepHPu = -0.5, Q0Pu = 0.21, QMax = 0.8, QMax0Pu = 0.8, QMin = -0.8, QMin0Pu = -0.8, QlConst = true, RWPDrop = 0, RWTDrop = 0, Res = 0, Rpc = 0, SNom = 100, TanPhi = -0.21, Td = 0, Tffilt = 0.01, Tg = 0.01, Tlag = 0.01, Tlead = 0.01, TpOrdp4A = 0.1, TpWTRef4A = 0.01, Tpfilt = 0.01, Tpll = 0.01, TqOrd = 0.05, Tqfilt = 0.01, Ts = 0.001, Tufilt = 0.01, Tuqfilt = 0.01, Tuss = 1, U0Pu = 1, UGsIm0Pu = 0.2182, UGsRe0Pu = 0.9758, UMax = 1.1, UMin = 0.9, UPhase0 = 0.22, UdbOne = -0.1, UdbTwo = 0.1, UpDip = 0, Upll1 = 999, Upll2 = 0.13, UpquMax = 1.1, UqDip = 0.9, UqRise = 1.1, X0Pu = -0.21, XWPDrop = 0, XWT0Pu = -0.21, XWTDrop = 0, Xes = 0, Xpc = 0.05, XstepHPu = 0.21, dfMax = 1, dfMin = -1, dpRefMax = 1, dpRefMin = -1, dpWPRefMax = 1, dpWPRefMin = -1, dxRefMax = 10, dxRefMin = -10, fOver = 1.1, fUnder = 0.9, i0Pu = Complex(-0.93, -0.4231), pErrMax = 1, pErrMin = -1, pKIWPpMax = 1, pKIWPpMin = -1, pRefMax = 1, pRefMin = 0, pWPHookPu = 0, t_Omegastep = 0, t_Pstep = 2, t_Xstep = 4, u0Pu = Complex(0.9758, 0.2182), uOver = 1.1, uUnder = 0.9, uWPqdip = 0.8, uWPqrise = 1.2, xKIWPxMax = 1, xKIWPxMin = -1, xRefMax = 1, xRefMin = -1, xerrmax = 1, xerrmin = -1)  annotation(
  Placement(visible = true, transformation(origin = {-120, 0}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));

  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-88, -40}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));

  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.0678, UEvtPu = 0, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = 0.99, tOmegaEvtEnd = 16.5, tOmegaEvtStart = 16, tUEvtEnd = 0, tUEvtStart = 0)  annotation(
    Placement(visible = true, transformation(origin = {138, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  Modelica.Blocks.Sources.RealExpression realExpression(y = infiniteBusWithVariations.omegaPu)  annotation(
    Placement(visible = true, transformation(origin = {130, 64}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
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
  connect(line.terminal2, transformer.terminal2) annotation(
    Line(points = {{-58, 0}, {-38, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal1, line2.terminal1) annotation(
    Line(points = {{-8, 0}, {10, 0}, {10, -20}, {16, -20}}, color = {0, 0, 255}));
  connect(line2.terminal2, line3.terminal1) annotation(
    Line(points = {{46, -20}, {62, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal1, line1.terminal1) annotation(
    Line(points = {{-8, 0}, {10, 0}, {10, 20}, {36, 20}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line2.terminal2) annotation(
    Line(points = {{46, -40}, {46, -20}}, color = {0, 0, 255}));
  connect(line3.terminal2, line4.terminal1) annotation(
    Line(points = {{92, -20}, {96, -20}, {96, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, line4.terminal1) annotation(
    Line(points = {{66, 20}, {96, 20}, {96, 0}}, color = {0, 0, 255}));
  connect(line4.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{126, 0}, {138, 0}}, color = {0, 0, 255}));
  connect(realExpression.y, iecwp4aPC.omegaPu) annotation(
    Line);
  connect(iecwp4aPC.aCPower, line.terminal1) annotation(
    Line(points = {{-103.5, 0}, {-88, 0}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, line.terminal1) annotation(
    Line(points = {{-88, -40}, {-88, 0}}, color = {0, 0, 255}));

annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end IECWP4APC;
