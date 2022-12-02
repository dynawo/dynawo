within Dynawo.Examples.Wind.IEC.IECWT4ANeplan;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4ACurrentSource "Wind Turbine Type 4A model from IEC 61400-27-1 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  import Modelica;
  import Dynawo;

  extends Icons.Example;

  Dynawo.Electrical.Wind.IEC.WT4ACurrentSource wT4ACurrentSource(BesPu = 0, DPMaxP4APu = 1, DPRefMax4APu = 100, DPRefMin4APu = -100, DUdb1Pu = -0.1, DUdb2Pu = 0.1, DfMaxPu = 1, DipMaxPu = 1, DiqMaxPu = 100, DiqMinPu = -100, GesPu = 0, IGsIm0Pu = 0.423168, IGsRe0Pu = 0.930069, IMaxDipPu = 1.3, IMaxPu = 1.3, IpMax0Pu = 1.2, IqH1Pu = 1.05, IqMax0Pu = 0.4, IqMaxPu = 1.05, IqMin0Pu = -0.4, IqMinPu = -1.05, IqPostPu = 0, Kipaw = 100, Kiq = 2.25, Kiqaw = 100, Kiu = 10, Kpaw = 1000, Kpq = 1.1, Kpqu = 20, Kpu = 2, Kpufrt = 2, Kqv = 2, MdfsLim = false, MpUScale = false, MqG = 1, Mqfrt = 1, Mqpri = true, P0Pu = -1, PaG0Pu = 1, Q0Pu = 0.21, QMax0Pu = 0.8, QMaxPu = 0.8, QMin0Pu = -0.8, QMinPu = -0.8, QlConst = true, RDropPu = 0, ResPu = 0, SNom = 100, U0Pu = 1, UGsIm0Pu = 0.21823, UGsRe0Pu = 0.975897, UMaxPu = 1.1, UMinPu = 0.9, UOverPu = 1.1, UPhase0 = 0.21949, UPll1Pu = 999, UPll2Pu = 0.13, URef0Pu = 0, UUnderPu = 0.9, UpDipPu = 0, UpquMaxPu = 1.1, UqDipPu = 0.9, UqRisePu = 1.1, XDropPu = 0, XWT0Pu = -0.21, XesPu = 0, fOverPu = 1.1, fUnderPu = 0.9, i0Pu = Complex(-0.930069, -0.423168), tG = 0.01, tIFilt = 0.01, tPFilt = 0.01, tPOrdP4A = 0.1, tPWTRef4A = 0.01, tPll = 0.01, tPost = 0, tQFilt = 0.01, tQord = 0.05, tS = 0.001, tUFilt = 0.01, tUss = 1, tfFilt = 0.01, u0Pu = Complex(0.975897, 0.2183))  annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0, tBegin = 12, tEnd = 12.15)  annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05, rTfoPu = 1)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.1, rTfoPu = 1)  annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line4(BPu = 0.005, GPu = 0, RPu = 0.015, XPu = 0.025)  annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0.005,GPu = 0, RPu = 0.005, XPu = 0.05)  annotation(
    Placement(visible = true, transformation(origin = {30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05)  annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0.01, GPu = 0, RPu = 0.01, XPu = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0457)  annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.0678, UEvtPu = 0, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = 0.99, tOmegaEvtEnd = 21, tOmegaEvtStart = 20, tUEvtEnd = 0, tUEvtStart = 0)  annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0, tBegin = 6, tEnd = 6.4)  annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = -0.21, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step xRefPu(height = 0.41, offset = -0.21, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step omegaRefPu(height = 0, offset = 1, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = -0.5, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  transformer1.switchOffSignal1.value = false;
  transformer1.switchOffSignal2.value = false;

  connect(wT4ACurrentSource.terminal, transformer1.terminal1) annotation(
    Line(points = {{-119, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(transformer1.terminal2, line4.terminal1) annotation(
    Line(points = {{-80, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(line4.terminal2, transformer.terminal1) annotation(
    Line(points = {{-40, 0}, {-20, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line.terminal1) annotation(
    Line(points = {{0, 0}, {20, 0}, {20, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line3.terminal1) annotation(
    Line(points = {{0, 0}, {20, 0}, {20, 20}, {40, 20}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, line1.terminal2) annotation(
    Line(points = {{140, 0}, {120, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, line2.terminal2) annotation(
    Line(points = {{100, 0}, {80, 0}, {80, -20}}, color = {0, 0, 255}));
  connect(line.terminal2, line2.terminal1) annotation(
    Line(points = {{40, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(line3.terminal2, line1.terminal1) annotation(
    Line(points = {{60, 20}, {80, 20}, {80, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{50, -40}, {50, -20}, {40, -20}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, wT4ACurrentSource.terminal) annotation(
    Line(points = {{-110, -40}, {-110, 0}, {-119, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, wT4ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-158, -60}, {-146, -60}, {-146, -6}, {-140, -6}}, color = {0, 0, 127}));
  connect(xRefPu.y, wT4ACurrentSource.xWTRefPu) annotation(
    Line(points = {{-158, -20}, {-150, -20}, {-150, -2}, {-140, -2}}, color = {0, 0, 127}));
  connect(PRefPu.y, wT4ACurrentSource.PWTRefPu) annotation(
    Line(points = {{-158, 20}, {-150, 20}, {-150, 2}, {-140, 2}}, color = {0, 0, 127}));
  connect(tanPhi.y, wT4ACurrentSource.tanPhi) annotation(
    Line(points = {{-158, 60}, {-146, 60}, {-146, 6}, {-140, 6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 15, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-140, -70}, {140, 70}})));
end WT4ACurrentSource;
