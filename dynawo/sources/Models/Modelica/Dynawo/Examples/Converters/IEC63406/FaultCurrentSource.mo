within Dynawo.Examples.Converters.IEC63406;

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

model FaultCurrentSource "Example for the IEC 63406 standard as a production unit with current source"

  extends Icons.Example;
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.000315, UEvtPu = 0, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(visible = true, transformation(origin = {100, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-210, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefPu(height = 0, offset = 0, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-210, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URefPu(height = 0, offset = 1, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-190, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PPrimPu(height = 0, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-190, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.ConverterCurrentSourceIEC63406 converterCurrentSourceIEC63406(BesPu(fixed = false), ComFlag = 3, DUdb1Pu = -0.01, DUdb2Pu = 0.01, DeltaT = 0.001, DerThetaMax = 1, DerfMaxPu = 0.02, FFRTableName = "FFRTable", FFRflag = false, GesPu(fixed = false), HVRTinPFlag = false, HVRTinQFlag = false, IMaxPu = 1.3, IPMaxPu = 1.2, IPMinPu = -1.2, IQMaxPu = 1.2, IQMinPu = -1.2, InertialTableName = "InertialTable", IsIm0Pu(fixed = false), IsRe0Pu(fixed = false), K1IpHV = 0, K1IpLV = 0, K1IqHV = -2, K1IqLV = -2, K2IpHV = 1, K2IpLV = 1, K2IqHV = 0, K2IqLV = 0, KDroop = 1, KIp = 10, KIpll = 20 * 150, KIqi = 10, KIqu = 10, KIui = 10, KIuq = 10, KPp = 2, KPpll = 3 * 150, KPqi = 2, KPqu = 2, KPui = 2, KPuq = 2, KpHVRT = 1, KpLVRT = 1, KqHVRT = 1, KqLVRT = 1, LFlag = 1, LVRTinPFlag = false, LVRTinQFlag = false, P0Pu(fixed = false), PFFlag = 1, PFlag = true, PLLFlag = 2, PMaxPu = 1, PffrMaxPu = 0.05, PffrMinPu = -0.05, PriorityFlag = true, Q0Pu(fixed = false), QLimFlag = true, QMaxPu=0.6, QMaxtoPTableName = "QMaxtoPTable", QMaxtoUTableName = "QMaxtoUTable", QMinPu = -0.6, QMintoPTableName = "QMintoPTable", QMintoUTableName = "QMintoUTable", ResPu(fixed = false), SNom(fixed = false), SOCFlag = false, SOCInit = 60, SOCMax = 100, SOCMin = 10, StorageFlag = false, TDerThetaMax = 0.5, TDerfMax = 0.5, THVP1 = 1, THVP2 = 0.5, THVP3 = 0.3, THfP1 = 1, THfP2 = 0.5, THfP3 = 0.25, TLVP1 = 1, TLVP2 = 0.5, TLVP3 = 0.3, TLfP1 = 1, TLfP2 = 0.5, TLfP3 = 0.25, TableFileName = "/home/philinux/dynawo/dynawo/examples/DynaSwing/IEC/Converter/IEC63406CurrentSourceUCPO/TableFile.txt", Tcom = 0.01, Tconv = 1, Tess = 40, TfFilt = 0.01, Tg = 0.01, TiFilt = 0.01, Tiq = 0.01, Tlag = 1, Tlead = 1, TpFilt = 0.01, TpRef = 0.1, TpllFilt = 0.01, TqFilt = 0.01, Trocof = 0.01, TuFilt = 0.01, U0Pu(fixed = false), UFlag = false, UHVP1 = 1.1, UHVP2 = 1.15, UHVP3 = 1.2, ULVP1 = 0.9, ULVP2 = 0.85, ULVP3 = 0.8, UMaxPu = 1.1, UMinPu = 0.9, UPhase0(fixed = false), UpllPu = 0.1, UsIm0Pu(fixed = false), UsRe0Pu(fixed = false), WMaxPu = 0.5, WMinPu = -0.5, XesPu(fixed = false), f0Pu = 1, fHfP1 = 1.004, fHfP2 = 1.01, fHfP3 = 1.02, fLfP1 = 0.996, fLfP2 = 0.99, fLfP3 = 0.98, fThresholdPu = 0.001, i0Pu(re(fixed = false), im(fixed = false)), iPSetHVPu = 0, iPSetLVPu = 0, iQSetHVPu = 0, iQSetLVPu = 0, pSetHVPu = 0, pSetLVPu = 0, pqFRTFlag = true, qSetHVPu = 0, qSetLVPu = 0, tS = 0.001, u0Pu(re(fixed = false), im(fixed = false)), uHVRTPu = 1.1, uLVRTPu = 0.9) annotation(
    Placement(visible = true, transformation(origin = {-120, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Sources.ConverterCurrentSourceIEC63406_INIT converterCurrentSourceIEC63406_INIT(BesPu = 10e-6, GesPu = 10e-6, P0Pu = -0.5, Q0Pu = 0, QLimFlag = true, QMaxPu = 0.6, QMaxtoPTableName = "QMaxtoPTable", QMaxtoUTableName = "QMaxtoUTable", QMinPu = -0.6, QMintoPTableName = "QMintoPTable", QMintoUTableName = "QMintoUTable", ResPu = 0.01, SNom = 50, TableFileName = "/home/philinux/dynawo/dynawo/examples/DynaSwing/IEC/Converter/IEC63406CurrentSourceUCPO/TableFile.txt", U0Pu = 1, UPhase0 = 0.0249947, XesPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.001, tBegin = 2, tEnd = 2.15) annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
initial algorithm
  converterCurrentSourceIEC63406.SNom := converterCurrentSourceIEC63406_INIT.SNom;
  converterCurrentSourceIEC63406.ResPu := converterCurrentSourceIEC63406_INIT.ResPu;
  converterCurrentSourceIEC63406.XesPu := converterCurrentSourceIEC63406_INIT.XesPu;
  converterCurrentSourceIEC63406.BesPu := converterCurrentSourceIEC63406_INIT.BesPu;
  converterCurrentSourceIEC63406.GesPu := converterCurrentSourceIEC63406_INIT.GesPu;
  converterCurrentSourceIEC63406.i0Pu.im := converterCurrentSourceIEC63406_INIT.i0Pu.im;
  converterCurrentSourceIEC63406.i0Pu.re := converterCurrentSourceIEC63406_INIT.i0Pu.re;
  converterCurrentSourceIEC63406.IsIm0Pu := converterCurrentSourceIEC63406_INIT.IsIm0Pu;
  converterCurrentSourceIEC63406.IsRe0Pu := converterCurrentSourceIEC63406_INIT.IsRe0Pu;
  converterCurrentSourceIEC63406.P0Pu := converterCurrentSourceIEC63406_INIT.P0Pu;
  converterCurrentSourceIEC63406.Q0Pu := converterCurrentSourceIEC63406_INIT.Q0Pu;
  converterCurrentSourceIEC63406.u0Pu.im := converterCurrentSourceIEC63406_INIT.u0Pu.im;
  converterCurrentSourceIEC63406.u0Pu.re := converterCurrentSourceIEC63406_INIT.u0Pu.re;
  converterCurrentSourceIEC63406.U0Pu := converterCurrentSourceIEC63406_INIT.U0Pu;
  converterCurrentSourceIEC63406.UPhase0 := converterCurrentSourceIEC63406_INIT.UPhase0;
  converterCurrentSourceIEC63406.UsIm0Pu := converterCurrentSourceIEC63406_INIT.UsIm0Pu;
  converterCurrentSourceIEC63406.UsRe0Pu := converterCurrentSourceIEC63406_INIT.UsRe0Pu;
//  converterCurrentSourceIEC63406.QMax0Pu := converterCurrentSourceIEC63406_INIT.QMax0Pu;
//  converterCurrentSourceIEC63406.QMin0Pu := converterCurrentSourceIEC63406_INIT.QMin0Pu;
equation
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal1.value = false;
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal2.value = false;
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal3.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(infiniteBusWithVariations.terminal, line.terminal2) annotation(
    Line(points = {{100, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(PPrimPu.y, converterCurrentSourceIEC63406.pPrimPu) annotation(
    Line(points = {{-178, 70}, {-160, 70}, {-160, 15}, {-142, 15}}, color = {0, 0, 127}));
  connect(PRefPu.y, converterCurrentSourceIEC63406.pCmdPu) annotation(
    Line(points = {{-198, 30}, {-180, 30}, {-180, 5}, {-142, 5}}, color = {0, 0, 127}));
  connect(QRefPu.y, converterCurrentSourceIEC63406.qCmdPu) annotation(
    Line(points = {{-198, -30}, {-180, -30}, {-180, -5}, {-142, -5}}, color = {0, 0, 127}));
  connect(URefPu.y, converterCurrentSourceIEC63406.uCmdPu) annotation(
    Line(points = {{-178, -70}, {-160, -70}, {-160, -15}, {-142, -15}}, color = {0, 0, 127}));
  connect(line.terminal1, converterCurrentSourceIEC63406.terminal) annotation(
    Line(points = {{-20, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, converterCurrentSourceIEC63406.terminal) annotation(
    Line(points = {{-60, -40}, {-60, 0}, {-100, 0}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 5, Tolerance = 0.0001, Interval = 0.001),
    Diagram(graphics = {Text(extent = {{-128, -4}, {-128, -4}}, textString = "text")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body>In this example, we simulate an active power order at t = 2s, a reactive power order at t = 4s, 2 faults at t = 6s and t = 12s and finally a frequency augmentation at t = 14s that disconnnects the production unit due to its protections.</body></html>"));
end FaultCurrentSource;
