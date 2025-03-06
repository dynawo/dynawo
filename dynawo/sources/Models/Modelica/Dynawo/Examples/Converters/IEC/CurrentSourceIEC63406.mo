within Dynawo.Examples.Converters.IEC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model CurrentSourceIEC63406 "Example for the IEC 63406 standard as a production unit with current source"
  extends Icons.Example;

  Dynawo.Electrical.Lines.Line line2B(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0.4, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0.005, GPu = 0, RPu = 0.015, XPu = 0.025) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2A(BPu = 0.005, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0, GPu = 0, RPu = 0, XPu = 0.0457) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0.01, GPu = 0, RPu = 0.01, XPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.1, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.0678, UEvtPu = 0, UPhase = -0.04, omega0Pu = 1, omegaEvtPu = 1.01, tOmegaEvtEnd = 14, tOmegaEvtStart = 13, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Step PRefPu(height = -0.5, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-210, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefPu(height = -0.1, offset = -0.21, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-210, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URefPu(height = -0.05, offset = 1, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-190, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PPrimPu(height = 0, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-190, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.01, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Dynawo.Electrical.Sources.ConverterCurrentSourceIEC63406 converterCurrentSourceIEC63406(BesPu = 0,ComFlag = 3, DUdb1Pu = -0.01, DUdb2Pu = 0.01, DeltaT = 0.001, DerThetaMax = 1, DerfMaxPu = 0.02, FFRTableName = "FFRTable", FFRflag = false, GesPu = 0, HVRTinPFlag = false, HVRTinQFlag = false, IMaxPu = 1.3, IPMax0Pu = 1.2, IPMaxPu = 1.2, IPMin0Pu = -1.2, IPMinPu = -1.2, IQMax0Pu = 0.4, IQMaxPu = 1.2, IQMin0Pu = -0.4, IQMinPu = -1.2, InertialTableName = "InertialTable", IsIm0Pu = 0.422694, IsRe0Pu = 0.930285, K1IpHV = 0, K1IpLV = 0, K1IqHV = -2, K1IqLV = -2, K2IpHV = 1, K2IpLV = 1, K2IqHV = 0, K2IqLV = 0, KDroop = 1, KIp = 10, KIpll = 20 * 150, KIqi = 10, KIqu = 10, KIui = 10, KIuq = 10, KPp = 2, KPpll = 3 * 150, KPqi = 2, KPqu = 2, KPui = 2, KPuq = 2, KpHVRT = 1, KpLVRT = 1, KqHVRT = 1, KqLVRT = 1, LFlag = 1, LVRTinPFlag = false, LVRTinQFlag = false, P0Pu = -1, PAvailIn0Pu = -1, PFFlag = 1, PFlag = true, PLLFlag = 2, PMaxPu = 1, PffrMaxPu = 0.05, PffrMinPu = -0.05, PriorityFlag = true, Q0Pu = 0.21, QLimFlag = true, QMax0Pu = 0.8, QMaxPu = 0.8, QMaxtoPTableName = "QMaxtoPTable", QMaxtoUTableName = "QMaxtoUTable", QMin0Pu = -0.8, QMinPu = -0.8, QMintoPTableName = "QMintoPTable", QMintoUTableName = "QMintoUTable", ResPu = 0, SNom = 100, SOCFlag = false, SOCInit = 50, SOCMax = 100, SOCMin = 10, StorageFlag = false, TDerThetaMax = 0.5, TDerfMax = 0.5, THVP1 = 1, THVP2 = 0.5, THVP3 = 0.3, THfP1 = 1, THfP2 = 0.5, THfP3 = 0.25, TLVP1 = 1, TLVP2 = 0.5, TLVP3 = 0.3, TLfP1 = 1, TLfP2 = 0.5, TLfP3 = 0.25, TableFileName = "../dynawo/examples/DynaSwing/IEC/Converter/IEC63406CurrentSourceUCPO/TableFile.txt", Tcom = 0.01, Tconv = 1, Tess = 40, TfFilt = 0.01, Tg = 0.01, TiFilt = 0.01, Tiq = 0.01, Tlag = 1, Tlead = 1, TpFilt = 0.01, TpRef = 0.1, TpllFilt = 0.01, TqFilt = 0.01, Trocof = 0.01, TuFilt = 0.01, U0Pu = 1, UFlag = false, UHVP1 = 1.1, UHVP2 = 1.15, UHVP3 = 1.2, ULVP1 = 0.9, ULVP2 = 0.85, ULVP3 = 0.8, UMaxPu = 1.1, UMinPu = 0.9, UPhase0 = 0.21949, UpllPu = 0.1, UsIm0Pu = 0.217732, UsRe0Pu = 0.976009, WMaxPu = 0.5, WMinPu = -0.5, XesPu = 0, f0Pu = 1, fHfP1 = 1.004, fHfP2 = 1.01, fHfP3 = 1.02, fLfP1 = 0.996, fLfP2 = 0.99, fLfP3 = 0.98, fThresholdPu = 0.001, i0Pu = Complex(-0.930285, -0.422694), iPSetHVPu = 0, iPSetLVPu = 0, iQSetHVPu = 0, iQSetLVPu = 0, pSetHVPu = 0, pSetLVPu = 0, pqFRTFlag = true, qSetHVPu = 0, qSetLVPu = 0, tS = 0.001, u0Pu = Complex(0.976009, 0.217732), uHVRTPu = 1.1, uLVRTPu = 0.9)  annotation(
    Placement(visible = true, transformation(origin = {-120, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal1.value = false;
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal2.value = false;
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal3.value = false;
  line2A.switchOffSignal1.value = false;
  line2A.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  line2B.switchOffSignal1.value = false;
  line2B.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  transformer1.switchOffSignal1.value = false;
  transformer1.switchOffSignal2.value = false;

  connect(transformer1.terminal2, line.terminal1) annotation(
    Line(points = {{-60, 0}, {-40, 0}}, color = {0, 0, 255}));
  connect(line2A.terminal2, line2B.terminal1) annotation(
    Line(points = {{60, -20}, {80, -20}}, color = {0, 0, 255}));
  connect(infiniteBusWithVariations.terminal, line3.terminal2) annotation(
    Line(points = {{160, 0}, {140, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line2A.terminal1) annotation(
    Line(points = {{20, 0}, {40, 0}, {40, -20}}, color = {0, 0, 255}));
  connect(line3.terminal1, line2B.terminal2) annotation(
    Line(points = {{120, 0}, {100, 0}, {100, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line1.terminal1) annotation(
    Line(points = {{20, 0}, {40, 0}, {40, 20}, {60, 20}}, color = {0, 0, 255}));
  connect(line1.terminal2, line3.terminal1) annotation(
    Line(points = {{80, 20}, {100, 20}, {100, 0}, {120, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, transformer.terminal1) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(PPrimPu.y, converterCurrentSourceIEC63406.pPrimPu) annotation(
    Line(points = {{-178, 70}, {-160, 70}, {-160, 15}, {-142, 15}}, color = {0, 0, 127}));
  connect(PRefPu.y, converterCurrentSourceIEC63406.pCmdPu) annotation(
    Line(points = {{-198, 30}, {-180, 30}, {-180, 5}, {-142, 5}}, color = {0, 0, 127}));
  connect(QRefPu.y, converterCurrentSourceIEC63406.qCmdPu) annotation(
    Line(points = {{-198, -30}, {-180, -30}, {-180, -5}, {-142, -5}}, color = {0, 0, 127}));
  connect(URefPu.y, converterCurrentSourceIEC63406.uCmdPu) annotation(
    Line(points = {{-178, -70}, {-160, -70}, {-160, -15}, {-142, -15}}, color = {0, 0, 127}));
  connect(converterCurrentSourceIEC63406.terminal, transformer1.terminal1) annotation(
    Line(points = {{-99, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(converterCurrentSourceIEC63406.terminal, nodeFault1.terminal) annotation(
    Line(points = {{-99, 0}, {-90, 0}, {-90, -40}}, color = {0, 0, 255}));
  connect(line2A.terminal2, nodeFault.terminal) annotation(
    Line(points = {{60, -20}, {70, -20}, {70, -40}}, color = {0, 0, 255}));
protected

  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.001),
  Diagram(graphics = {Text(extent = {{-128, -4}, {-128, -4}}, textString = "text")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
  Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
  Documentation(info = "<html><head></head><body>In this example, we simulate an active power order at t = 2s, a reactive power order at t = 4s, 2 faults at t = 6s and t = 12s and finally a frequency augmentation at t = 14s that disconnnects the production unit due to its protections.</body></html>"));
end CurrentSourceIEC63406;
