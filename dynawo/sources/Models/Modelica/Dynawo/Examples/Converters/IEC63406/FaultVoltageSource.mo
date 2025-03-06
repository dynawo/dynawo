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

model FaultVoltageSource "Example for the IEC 63406 standard as a production unit with Voltage source"

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
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.001, tBegin = 2, tEnd = 2.15) annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
  Dynawo.Electrical.Sources.ConverterVoltageSourceIEC63406 converterVoltageSourceIEC63406(ComFlag = 3, DUdb1Pu = -0.01, DUdb2Pu = 0.01, DeltaT = 0.001, DerThetaMax = 1, DerfMaxPu = 0.02, FFRTableName = "FFRTable", FFRflag = false, HVRTinPFlag = false, HVRTinQFlag = false, IMaxPu = 1.3, IPMaxPu = 1.2, IPMinPu = -1.2, IQMaxPu = 1.2, IQMinPu = -1.2, InertialTableName = "InertialTable", IsIm0Pu(fixed = false), IsRe0Pu(fixed = false), K1IpHV = 0, K1IpLV = 0, K1IqHV = -2, K1IqLV = -2, K2IpHV = 1, K2IpLV = 1, K2IqHV = 0, K2IqLV = 0, KDroop = 1, KIp = 10, KIpll = 20 * 150, KIqi = 10, KIqu = 10, KIui = 10, KIuq = 10, KPp = 2, KPpll = 3 * 150, KPqi = 2, KPqu = 2, KPui = 2, KPuq = 2, KpHVRT = 1, KpLVRT = 1, KqHVRT = 1, KqLVRT = 1, LFlag = 1, LVRTinPFlag = false, LVRTinQFlag = false, P0Pu(fixed = false), PFFlag = 1, PFlag = true, PLLFlag = 2, PMaxPu = 1, PffrMaxPu = 0.05, PffrMinPu = -0.05, PriorityFlag = true, Q0Pu(fixed = false), QLimFlag = true, QMaxPu=0.6, QMaxtoPTableName = "QMaxtoPTable", QMaxtoUTableName = "QMaxtoUTable", QMinPu = -0.6, QMintoPTableName = "QMintoPTable", QMintoUTableName = "QMintoUTable", ResPu(fixed = false), SNom(fixed = false), SOCFlag = false, SOCInit = 60, SOCMax = 100, SOCMin = 10, StorageFlag = false, TDerThetaMax = 0.5, TDerfMax = 0.5, THVP1 = 1, THVP2 = 0.5, THVP3 = 0.3, THfP1 = 1, THfP2 = 0.5, THfP3 = 0.25, TLVP1 = 1, TLVP2 = 0.5, TLVP3 = 0.3, TLfP1 = 1, TLfP2 = 0.5, TLfP3 = 0.25, TableFileName = "/home/philinux/dynawo/dynawo/examples/DynaSwing/IEC/Converter/IEC63406CurrentSourceUCPO/TableFile.txt", Tcom = 0.01, Tconv = 1, Te = 0.005, Tess = 40, TfFilt = 0.01, Tg = 0.01, TiFilt = 0.01, Tiq = 0.01, Tlag = 1, Tlead = 1, TpFilt = 0.01, TpRef = 0.1, TpllFilt = 0.01, TqFilt = 0.01, Trocof = 0.01, TuFilt = 0.01, U0Pu(fixed = false), UFlag = false, UHVP1 = 1.1, UHVP2 = 1.15, UHVP3 = 1.2, ULVP1 = 0.9, ULVP2 = 0.85, ULVP3 = 0.8, UMaxPu = 1.1, UMinPu = 0.9, UPhase0(fixed = false), UeIm0Pu(fixed = false), UeRe0Pu(fixed = false), Ued0Pu(fixed = false), Ueq0Pu(fixed = false), UpllPu = 0.1, WMaxPu = 0.5, WMinPu = -0.5, XesPu(fixed = false), f0Pu = 1, fHfP1 = 1.004, fHfP2 = 1.01, fHfP3 = 1.02, fLfP1 = 0.996, fLfP2 = 0.99, fLfP3 = 0.98, fThresholdPu = 0.001, i0Pu(re(fixed = false), im(fixed = false)), iPSetHVPu = 0, iPSetLVPu = 0, iQSetHVPu = 0, iQSetLVPu = 0, pSetHVPu = 0, pSetLVPu = 0, pqFRTFlag = true, qSetHVPu = 0, qSetLVPu = 0, tS = 0.001, u0Pu(re(fixed = false), im(fixed = false)), uHVRTPu = 1.1, uLVRTPu = 0.9) annotation(
    Placement(visible = true, transformation(origin = {-120, 1.9984e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Sources.ConverterVoltageSourceIEC63406_INIT converterVoltageSourceIEC63406_INIT(P0Pu = -0.5, Q0Pu = 0, QLimFlag = true, QMaxPu = 0.6, QMaxtoPTableName = "QMaxtoPTable", QMaxtoUTableName = "QMaxtoUTable", QMinPu = -0.6, QMintoPTableName = "QMintoPTable", QMintoUTableName = "QMintoUTable", ResPu = 0.01, SNom = 50, TableFileName = "/home/philinux/dynawo/dynawo/examples/DynaSwing/IEC/Converter/IEC63406CurrentSourceUCPO/TableFile.txt", U0Pu = 1, UPhase0 = 0.0249947, XesPu = 0.1) annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

initial algorithm
  converterVoltageSourceIEC63406.SNom := converterVoltageSourceIEC63406_INIT.SNom;
  converterVoltageSourceIEC63406.ResPu := converterVoltageSourceIEC63406_INIT.ResPu;
  converterVoltageSourceIEC63406.XesPu := converterVoltageSourceIEC63406_INIT.XesPu;
  converterVoltageSourceIEC63406.i0Pu.im := converterVoltageSourceIEC63406_INIT.i0Pu.im;
  converterVoltageSourceIEC63406.i0Pu.re := converterVoltageSourceIEC63406_INIT.i0Pu.re;
  converterVoltageSourceIEC63406.IsIm0Pu := converterVoltageSourceIEC63406_INIT.IsIm0Pu;
  converterVoltageSourceIEC63406.IsRe0Pu := converterVoltageSourceIEC63406_INIT.IsRe0Pu;
  converterVoltageSourceIEC63406.P0Pu := converterVoltageSourceIEC63406_INIT.P0Pu;
  converterVoltageSourceIEC63406.Q0Pu := converterVoltageSourceIEC63406_INIT.Q0Pu;
  converterVoltageSourceIEC63406.u0Pu.im := converterVoltageSourceIEC63406_INIT.u0Pu.im;
  converterVoltageSourceIEC63406.u0Pu.re := converterVoltageSourceIEC63406_INIT.u0Pu.re;
  converterVoltageSourceIEC63406.U0Pu := converterVoltageSourceIEC63406_INIT.U0Pu;
  converterVoltageSourceIEC63406.UPhase0 := converterVoltageSourceIEC63406_INIT.UPhase0;
  converterVoltageSourceIEC63406.Ued0Pu := converterVoltageSourceIEC63406_INIT.Ued0Pu;
  converterVoltageSourceIEC63406.Ueq0Pu := converterVoltageSourceIEC63406_INIT.Ueq0Pu;
  converterVoltageSourceIEC63406.UeIm0Pu := converterVoltageSourceIEC63406_INIT.UeIm0Pu;
  converterVoltageSourceIEC63406.UeRe0Pu := converterVoltageSourceIEC63406_INIT.UeRe0Pu;

equation
  converterVoltageSourceIEC63406.injectorVoltageSource.switchOffSignal1.value = false;
  converterVoltageSourceIEC63406.injectorVoltageSource.switchOffSignal2.value = false;
  converterVoltageSourceIEC63406.injectorVoltageSource.switchOffSignal3.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(infiniteBusWithVariations.terminal, line.terminal2) annotation(
    Line(points = {{100, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(PPrimPu.y, converterVoltageSourceIEC63406.pPrimPu) annotation(
    Line(points = {{-178, 70}, {-142, 70}, {-142, 15}}, color = {0, 0, 127}));
  connect(PRefPu.y, converterVoltageSourceIEC63406.pCmdPu) annotation(
    Line(points = {{-198, 30}, {-160, 30}, {-160, 5}, {-142, 5}}, color = {0, 0, 127}));
  connect(QRefPu.y, converterVoltageSourceIEC63406.qCmdPu) annotation(
    Line(points = {{-198, -30}, {-160, -30}, {-160, -5}, {-142, -5}}, color = {0, 0, 127}));
  connect(URefPu.y, converterVoltageSourceIEC63406.uCmdPu) annotation(
    Line(points = {{-178, -70}, {-142, -70}, {-142, -15}}, color = {0, 0, 127}));
  connect(converterVoltageSourceIEC63406.terminal, line.terminal1) annotation(
    Line(points = {{-99, 0}, {-20, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, converterVoltageSourceIEC63406.terminal) annotation(
    Line(points = {{-60, -40}, {-60, 0}, {-99, 0}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 5, Tolerance = 0.0001, Interval = 0.001),
    Diagram(graphics = {Text(extent = {{-128, -4}, {-128, -4}}, textString = "text")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body>In this example, we simulate an active power order at t = 2s, a reactive power order at t = 4s, 2 faults at t = 6s and t = 12s and finally a frequency augmentation at t = 14s that disconnnects the production unit due to its protections.</body></html>"));
end FaultVoltageSource;
