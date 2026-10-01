within Dynawo.Examples.Converters.IEC63406;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model FaultCurrentSource "Example for the IEC 63406 standard as a production unit with current source"
  extends Icons.Example;

  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0, XPu = 0.05) annotation(
    Placement(transformation(origin = {60, 1.77636e-15}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1.000315, UEvtPu = 0, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(transformation(origin = {160, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0, offset = 1, startTime = 2) annotation(
    Placement(transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step QRefPu(height = 0, offset = 0, startTime = 4) annotation(
    Placement(transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step URefPu(height = 0, offset = 1, startTime = 4) annotation(
    Placement(transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PPrimPu(height = 0, offset = 1, startTime = 2) annotation(
    Placement(transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Sources.ConverterCurrentSourceIEC63406 converterCurrentSourceIEC63406(
    BesPu = 10e-6,
    ComFlag = 3,
    DUdb1Pu = -0.01,
    DUdb2Pu = 0.01,
    DeltaT = 0.001,
    DerThetaMax = 1,
    DerfMaxPu = 0.02,
    FFRTableName = "FFRTable",
    FFRFlag = false,
    GesPu = 10e-6,
    HVRTinPFlag = false,
    HVRTinQFlag = false,
    IMaxPu = 1.3,
    IpMaxPu = 1.2,
    IpMinPu = -1.2,
    IqMaxPu = 1.2,
    IqMinPu = -1.2,
    InertialTableName = "InertialTable",
    IsIm0Pu(fixed = false),
    IsRe0Pu(fixed = false),
    K1IpHV = 0,
    K1IpLV = 0,
    K1IqHV = -2,
    K1IqLV = -2,
    K2IpHV = 1,
    K2IpLV = 1,
    K2IqHV = 0,
    K2IqLV = 0,
    KDroop = 1,
    KIp = 10,
    KIpll = 20 * 150,
    KIqi = 10,
    KIqu = 10,
    KIui = 10,
    KIuq = 10,
    KPp = 2,
    KPpll = 3 * 150,
    KPqi = 2,
    KPqu = 2,
    KPui = 2,
    KPuq = 2,
    KpHVRT = 1,
    KpLVRT = 1,
    KqHVRT = 1,
    KqLVRT = 1,
    LFlag = 1,
    LVRTinPFlag = false,
    LVRTinQFlag = false,
    P0Pu = -0.5,
    PFFlag = 1,
    PFlag = true,
    PLLFlag = 2,
    PMaxPu = 1,
    PffrMaxPu = 0.05,
    PffrMinPu = -0.05,
    PriorityFlag = true,
    Q0Pu = 0,
    QLimFlag = true,
    QMaxPu = 0.6,
    QMaxtoPTableName = "QMaxtoPTable",
    QMaxtoUTableName = "QMaxtoUTable",
    QMinPu = -0.6,
    QMintoPTableName = "QMintoPTable",
    QMintoUTableName = "QMintoUTable",
    ResPu = 0.01,
    SNom = 50,
    SOCFlag = false,
    SOCInit = 60,
    SOCMax = 100,
    SOCMin = 10,
    StorageFlag = false,
    tDerThetaMax = 0.5,
    tDerfMax = 0.5,
    tHvP1 = 1,
    tHvP2 = 0.5,
    tHvP3 = 0.3,
    tHfP1 = 1,
    tHfP2 = 0.5,
    tHfP3 = 0.25,
    tLvP1 = 1,
    tLvP2 = 0.5,
    tLvP3 = 0.3,
    tLfP1 = 1,
    tLfP2 = 0.5,
    tLfP3 = 0.25,
    TableFileName = "",
    tCom = 0.01,
    tConv = 1,
    tESS = 40,
    tFFilt = 0.01,
    tG = 0.01,
    tIFilt = 0.01,
    tIq = 0.01,
    tLag = 1,
    tLead = 1,
    tPFilt = 0.01,
    tPRef = 0.1,
    tPllFilt = 0.01,
    tQFilt = 0.01,
    tRocof = 0.01,
    tUFilt = 0.01,
    U0Pu = 1,
    UFlag = false,
    UHvP1 = 1.1,
    UHvP2 = 1.15,
    UHvP3 = 1.2,
    ULvP1 = 0.9,
    ULvP2 = 0.85,
    ULvP3 = 0.8,
    UMaxPu = 1.1,
    UMinPu = 0.9,
    UPhase0 = 0.0249947,
    UPllPu = 0.1,
    UsIm0Pu(fixed = false),
    UsRe0Pu(fixed = false),
    WMaxPu = 0.5,
    WMinPu = -0.5,
    XesPu = 0.1,
    f0Pu = 1,
    fHfP1 = 1.004,
    fHfP2 = 1.01,
    fHfP3 = 1.02,
    fLfP1 = 0.996,
    fLfP2 = 0.99,
    fLfP3 = 0.98,
    fThresholdPu = 0.001,
    i0Pu(re(fixed = false), im(fixed = false)),
    iPSetHVPu = 0,
    iPSetLVPu = 0,
    iQSetHVPu = 0,
    iQSetLVPu = 0,
    pSetHVPu = 0,
    pSetLVPu = 0,
    pqFRTFlag = true,
    qSetHVPu = 0,
    qSetLVPu = 0,
    tS = 0.001,
    u0Pu(re(fixed = false), im(fixed = false)),
    uHVRTPu = 1.1,
    uLVRTPu = 0.9,
    controlAndProtection.control.ffr.FFRCombiTable.tableOnFile = false,
    controlAndProtection.control.ffr.FFRCombiTable.table = [-1, -1; 1, 1],
    controlAndProtection.control.ffr.inertialCombiTable.tableOnFile = false,
    controlAndProtection.control.ffr.inertialCombiTable.table = [-1, -1; 1, 1],
    controlAndProtection.control.qLimitation.combiTable1Ds.tableOnFile = false,
    controlAndProtection.control.qLimitation.combiTable1Ds.table = [-1, -1; 1, 1],
    controlAndProtection.control.qLimitation.combiTable1Ds1.tableOnFile = false,
    controlAndProtection.control.qLimitation.combiTable1Ds1.table = [-1, -1; 1, 1],
    controlAndProtection.control.qLimitation.combiTable1Ds2.tableOnFile = false,
    controlAndProtection.control.qLimitation.combiTable1Ds2.table = [-1, -1; 1, 1],
    controlAndProtection.control.qLimitation.combiTable1Ds3.tableOnFile = false,
    controlAndProtection.control.qLimitation.combiTable1Ds3.table = [-1, -1; 1, 1]) annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Sources.ConverterCurrentSourceIEC63406_INIT converterCurrentSourceIEC63406_INIT(
    BesPu = converterCurrentSourceIEC63406.BesPu,
    GesPu = converterCurrentSourceIEC63406.GesPu,
    P0Pu = converterCurrentSourceIEC63406.P0Pu,
    Q0Pu = converterCurrentSourceIEC63406.Q0Pu,
    QLimFlag = converterCurrentSourceIEC63406.QLimFlag,
    QMaxPu = converterCurrentSourceIEC63406.QMaxPu,
    QMaxtoPTableName = "QMaxtoPTable",
    QMaxtoUTableName = "QMaxtoUTable",
    QMinPu = converterCurrentSourceIEC63406.QMinPu,
    QMintoPTableName = "QMintoPTable",
    QMintoUTableName = "QMintoUTable",
    ResPu = converterCurrentSourceIEC63406.ResPu,
    SNom = converterCurrentSourceIEC63406.SNom,
    TableFileName = "",
    U0Pu = converterCurrentSourceIEC63406.U0Pu,
    UPhase0 = converterCurrentSourceIEC63406.UPhase0,
    XesPu = converterCurrentSourceIEC63406.XesPu,
    combiTable1DsInit.tableOnFile = false,
    combiTable1DsInit.table = [-1, -1; 1, 1],
    combiTable1Ds1Init.tableOnFile = false,
    combiTable1Ds1Init.table = [-1, -1; 1, 1],
    combiTable1Ds2Init.tableOnFile = false,
    combiTable1Ds2Init.table = [-1, -1; 1, 1],
    combiTable1Ds3Init.tableOnFile = false,
    combiTable1Ds3Init.table = [-1, -1; 1, 1]) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.001, tBegin = 2, tEnd = 2.15) annotation(
    Placement(transformation(origin = {0, -40}, extent = {{-20, 20}, {20, -20}})));

initial algorithm
  converterCurrentSourceIEC63406.i0Pu.im := converterCurrentSourceIEC63406_INIT.i0Pu.im;
  converterCurrentSourceIEC63406.i0Pu.re := converterCurrentSourceIEC63406_INIT.i0Pu.re;
  converterCurrentSourceIEC63406.IsIm0Pu := converterCurrentSourceIEC63406_INIT.IsIm0Pu;
  converterCurrentSourceIEC63406.IsRe0Pu := converterCurrentSourceIEC63406_INIT.IsRe0Pu;
  converterCurrentSourceIEC63406.u0Pu.im := converterCurrentSourceIEC63406_INIT.u0Pu.im;
  converterCurrentSourceIEC63406.u0Pu.re := converterCurrentSourceIEC63406_INIT.u0Pu.re;
  converterCurrentSourceIEC63406.UsIm0Pu := converterCurrentSourceIEC63406_INIT.UsIm0Pu;
  converterCurrentSourceIEC63406.UsRe0Pu := converterCurrentSourceIEC63406_INIT.UsRe0Pu;

equation
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal1 = false;
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal2 = false;
  converterCurrentSourceIEC63406.injectorCurrentSource.switchOffSignal3 = false;
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;

  connect(infiniteBusWithVariations.terminal, line.terminal2) annotation(
    Line(points = {{160, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(PPrimPu.y, converterCurrentSourceIEC63406.pPrimPu) annotation(
    Line(points = {{-139, 60}, {-100, 60}, {-100, 15}, {-83, 15}}, color = {0, 0, 127}));
  connect(PRefPu.y, converterCurrentSourceIEC63406.pCmdPu) annotation(
    Line(points = {{-139, 20}, {-120, 20}, {-120, 5}, {-83, 5}}, color = {0, 0, 127}));
  connect(QRefPu.y, converterCurrentSourceIEC63406.qCmdPu) annotation(
    Line(points = {{-139, -20}, {-120, -20}, {-120, -5}, {-83, -5}}, color = {0, 0, 127}));
  connect(URefPu.y, converterCurrentSourceIEC63406.uCmdPu) annotation(
    Line(points = {{-139, -60}, {-100, -60}, {-100, -15}, {-83, -15}}, color = {0, 0, 127}));
  connect(line.terminal1, converterCurrentSourceIEC63406.terminal) annotation(
    Line(points = {{40, 0}, {-40, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, converterCurrentSourceIEC63406.terminal) annotation(
    Line(points = {{0, -40}, {0, 0}, {-40, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 5, Tolerance = 0.0001, Interval = 0.001),
    Diagram(graphics = {Text(extent = {{-128, -4}, {-128, -4}}, textString = "text")}, coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body>In this example, we simulate an active power order at t = 2 s, a reactive power order at t = 4 s, 2 faults at t = 6 s and t = 12 s and finally a frequency augmentation at t = 14 s that disconnnects the production unit due to its protections.</body></html>"));
end FaultCurrentSource;
