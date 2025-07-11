within Dynawo.Examples.GridForming;

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

model GridForming "Grid Forming converters test case"
  extends Icons.Example;

  parameter Types.ActivePowerPu PRefLoadPu = 11.25 "Active power request for the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";

  Dynawo.Electrical.Controls.Converters.GridFormingControlDroopControl Droop(
    CFilter = 0.066,
    DeltaIConvSquare0Pu(fixed = false),
    DeltaVVId0(fixed = false),
    DeltaVVIq0(fixed = false),
    IMaxVI = 1,
    IConvSquare0Pu(fixed = false),
    IdConv0Pu(fixed = false),
    IdPcc0Pu(fixed = false),
    IdcSource0Pu(fixed = false),
    IdcSourceRef0Pu = IdcSourceRef250Pu.offset,
    IqConv0Pu(fixed = false),
    IqPcc0Pu(fixed = false),
    Kff = 0.01,
    Kic = 1.19,
    Kiv = 1.161022,
    KpVI = 0.67,
    Kpc = 0.7388,
    Kpdc = 50,
    Kpv = 0.52,
    LFilter = 0.15,
    Mp = 0.02,
    Mq = 0,
    PFilter0Pu(fixed = false),
    PRef0Pu = PRef250Pu.offset,
    QFilter0Pu(fixed = false),
    QRef0Pu = QRef250Pu.offset,
    RFilter = 0.005,
    RVI0(fixed = false),
    Theta0 = -0.0502912,
    UFilterRef0Pu = 1,
    UdConv0Pu(fixed = false),
    UdFilter0Pu(fixed = false),
    UdcSource0Pu = Conv250.UdcSource0Pu,
    UdcSourceRef0Pu = UdcSourceRef250Pu.offset,
    UqConv0Pu(fixed = false),
    UqFilter0Pu(fixed = false),
    Wf = 60,
    Wff = 16.66,
    XRratio = 5,
    XVI0(fixed = false)) "Droop controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {-107, 75}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv250(
    Cdc = 0.01,
    CFilter = 0.066,
    IConv0Pu(fixed = false),
    IdConv0Pu(fixed = false),
    IdPcc0Pu(fixed = false),
    IdcSource0Pu(fixed = false),
    IqConv0Pu(fixed = false),
    IqPcc0Pu(fixed = false),
    LFilter = 0.15,
    LTransformer = 0.2,
    PFilter0Pu(fixed = false),
    PGen0Pu = 1.55872,
    QFilter0Pu(fixed = false),
    QGen0Pu = 0.0586969,
    RFilter = 0.005,
    RTransformer = 0.01,
    SNom = 250,
    Theta0 = -0.0502912,
    U0Pu = 0.988625,
    UPhase0 = -0.174549,
    UdConv0Pu(fixed = false),
    UdFilter0Pu(fixed = false),
    UdPcc0Pu(fixed = false),
    UdcSource0Pu = 1.01369,
    UqConv0Pu(fixed = false),
    UqFilter0Pu(fixed = false),
    UqPcc0Pu(fixed = false),
    i0Pu(re(fixed = false), im(fixed = false)),
    u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-62, 75}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef250Pu(height = 0, offset = 0.6238, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 109}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef250Pu(height = 0, offset = 0.0769, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 92}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef250Pu(height = 0, offset = 1.0138, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 75}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef250Pu(height = 0, offset = 0.6153, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 58}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef250Pu(height = 0, offset = 1.0138, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.GridFormingControlDispatchableVirtualOscillatorControl dVOC(
    Alpha = 5000,
    CFilter = 0.066,
    DeltaIConvSquare0Pu(fixed = false),
    DeltaVVId0(fixed = false),
    DeltaVVIq0(fixed = false),
    Eta = 1,
    IMaxVI = 1,
    IConvSquare0Pu(fixed = false),
    IdConv0Pu(fixed = false),
    IdPcc0Pu(fixed = false),
    IdcSource0Pu(fixed = false),
    IdcSourceRef0Pu = IdcSourceRef500Pu.offset,
    IqConv0Pu(fixed = false),
    IqPcc0Pu(fixed = false),
    KDvoc = 1.570796325,
    Kic = 1.19,
    Kiv = 1.161022,
    KpVI = 0.67,
    Kpc = 0.7388,
    Kpdc = 50,
    Kpv = 0.52,
    LFilter = 0.15,
    PFilter0Pu(fixed = false),
    PRef0Pu = PRef500Pu.offset,
    QFilter0Pu(fixed = false),
    QRef0Pu = QRef500Pu.offset,
    RFilter = 0.005,
    RVI0(fixed = false),
    Theta0 = -0.00153083,
    UFilterRef0Pu = 1.0131,
    UdConv0Pu(fixed = false),
    UdFilter0Pu(fixed = false),
    UdcSource0Pu = Conv500.UdcSource0Pu,
    UdcSourceRef0Pu = UdcSourceRef500Pu.offset,
    UqConv0Pu(fixed = false),
    UqFilter0Pu(fixed = false),
    XRratio = 5,
    XVI0(fixed = false)) "dVOC controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {107, 75}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv500(
    Cdc = 0.01,
    CFilter = 0.066,
    IConv0Pu(fixed = false),
    IdConv0Pu(fixed = false),
    IdPcc0Pu(fixed = false),
    IdcSource0Pu(fixed = false),
    IqConv0Pu(fixed = false),
    IqPcc0Pu(fixed = false),
    LFilter = 0.15,
    LTransformer = 0.2,
    PFilter0Pu(fixed = false),
    PGen0Pu = 3.11662,
    QFilter0Pu(fixed = false),
    QGen0Pu = 0.122684,
    RFilter = 0.005,
    RTransformer = 0.01,
    SNom = 500,
    Theta0 = -0.00153083,
    U0Pu = 0.99413,
    UPhase0 = -0.126905,
    UdConv0Pu(fixed = false),
    UdFilter0Pu(fixed = false),
    UdPcc0Pu(fixed = false),
    UdcSource0Pu = 1.01259,
    UqConv0Pu(fixed = false),
    UqFilter0Pu(fixed = false),
    UqPcc0Pu(fixed = false),
    i0Pu(re(fixed = false), im(fixed = false)),
    u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {63, 75}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef500Pu(height = 0, offset = 0.6036, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 109}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef500Pu(height = 0, offset = 0.072, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 92}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef500Pu(height = 0, offset = 1.0131, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 75}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef500Pu(height = 0, offset = 0.5958, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 58}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef500Pu(height = 0, offset = 1.0131, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 41}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.GridFormingControlMatchingControl Matching(
    CFilter = 0.066,
    DeltaIConvSquare0Pu(fixed = false),
    DeltaVVId0(fixed = false),
    DeltaVVIq0(fixed = false),
    IMaxVI = 1,
    IConvSquare0Pu(fixed = false),
    IdConv0Pu(fixed = false),
    IdPcc0Pu(fixed = false),
    IdcSource0Pu(fixed = false),
    IdcSourceRef0Pu = IdcSourceRef1000Pu.offset,
    IqConv0Pu(fixed = false),
    IqPcc0Pu(fixed = false),
    KMatching = 1,
    Kic = 1.19,
    Kiv = 1.161022,
    KpVI = 0.67,
    Kpc = 0.7388,
    Kpdc = 50,
    Kpv = 0.52,
    LFilter = 0.15,
    PFilter0Pu(fixed = false),
    PRef0Pu = Conv1000.PGen0Pu,
    QFilter0Pu(fixed = false),
    QRef0Pu = Conv1000.QGen0Pu,
    RFilter = 0.005,
    RVI0(fixed = false),
    Theta0 = 0,
    UFilterRef0Pu = 1,
    UdConv0Pu(fixed = false),
    UdFilter0Pu(fixed = false),
    UdcSource0Pu = Conv1000.UdcSource0Pu,
    UdcSourceRef0Pu = UdcSourceRef1000Pu.offset,
    UqConv0Pu(fixed = false),
    UqFilter0Pu(fixed = false),
    XRratio = 5,
    XVI0(fixed = false)) "Matching control controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {-107, -60}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv1000(
    Cdc = 0.01,
    CFilter = 0.066,
    IConv0Pu(fixed = false),
    IdConv0Pu(fixed = false),
    IdPcc0Pu(fixed = false),
    IdcSource0Pu(fixed = false),
    IqConv0Pu(fixed = false),
    IqPcc0Pu(fixed = false),
    LFilter = 0.15,
    LTransformer = 0.2,
    PFilter0Pu(fixed = false),
    PGen0Pu = 6.36575,
    QFilter0Pu(fixed = false),
    QGen0Pu = 0.27403,
    RFilter = 0.005,
    RTransformer = 0.01,
    SNom = 1000,
    Theta0 = 0,
    U0Pu = 0.994308,
    UPhase0 = -0.126293,
    UdConv0Pu(fixed = false),
    UdFilter0Pu(fixed = false),
    UdPcc0Pu(fixed = false),
    UdcSource0Pu = 1.0143,
    UqConv0Pu(fixed = false),
    UqFilter0Pu(fixed = false),
    UqPcc0Pu(fixed = false),
    i0Pu(re(fixed = false), im(fixed = false)),
    u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-62, -60}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef1000Pu(height = 0, offset = 1.0143, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, -77}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef1000Pu(height = 0, offset = 0.63, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, -60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef1000Pu(height = 0, offset = 1.0143, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, -43}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line Line12(BPu = 0.0000075, GPu = 0, RPu = 0.00075, XPu = 0.0075) annotation(
    Placement(visible = true, transformation(origin = {-62, -15}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line Line13(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375) annotation(
    Placement(visible = true, transformation(origin = {63, -15}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line Line23(BPu = 0.00003, GPu = 0, RPu = 0.003, XPu = 0.03) annotation(
    Placement(visible = true, transformation(origin = {0, 47}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line Line23Bis1(BPu = 0.000015, GPu = 0, RPu = 0.0015, XPu = 0.015) annotation(
    Placement(visible = true, transformation(origin = {-35, 14}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line Line23Bis2(BPu = 0.000015, GPu = 0, RPu = 0.0015, XPu = 0.015) annotation(
    Placement(visible = true, transformation(origin = {35, 14}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta Load(
    alpha = 2,
    beta = 0,
    i0Pu(re(fixed = false), im(fixed = false)),
    s0Pu(re(fixed = false), im(fixed = false)),
    u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-15, 40}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault Fault(RPu = 0.0001, XPu = 0.001, tBegin = 1.5, tEnd = 1.65) annotation(
    Placement(visible = true, transformation(origin = {0, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanStep Disconnection(startValue = false, startTime = 0.5);

  // Initialization
  Dynawo.Electrical.Controls.Converters.GridFormingControl_INIT gridFormingControl250_INIT(
    IMaxVI = Droop.IMaxVI,
    KpVI = Droop.KpVI,
    XRratio = Droop.XRratio) annotation(
    Placement(visible = true, transformation(origin = {-110, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter_INIT converter250_INIT(
    CFilter = Conv250.CFilter,
    LFilter = Conv250.LFilter,
    LTransformer = Conv250.LTransformer,
    P0Pu = -Conv250.PGen0Pu,
    Q0Pu = -Conv250.QGen0Pu,
    RFilter = Conv250.RFilter,
    RTransformer = Conv250.RTransformer,
    SNom = Conv250.SNom,
    U0Pu = Conv250.U0Pu,
    UPhase0 = Conv250.UPhase0) annotation(
    Placement(visible = true, transformation(origin = {-50, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.GridFormingControl_INIT gridFormingControl500_INIT(
    IMaxVI = dVOC.IMaxVI,
    KpVI = dVOC.KpVI,
    XRratio = dVOC.XRratio) annotation(
    Placement(visible = true, transformation(origin = {110, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter_INIT converter500_INIT(
    CFilter = Conv500.CFilter,
    LFilter = Conv500.LFilter,
    LTransformer = Conv500.LTransformer,
    P0Pu = -Conv500.PGen0Pu,
    Q0Pu = -Conv500.QGen0Pu,
    RFilter = Conv500.RFilter,
    RTransformer = Conv500.RTransformer,
    SNom = Conv500.SNom,
    U0Pu = Conv500.U0Pu,
    UPhase0 = Conv500.UPhase0) annotation(
    Placement(visible = true, transformation(origin = {50, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.GridFormingControl_INIT gridFormingControl1000_INIT(
    IMaxVI = Matching.IMaxVI,
    KpVI = Matching.KpVI,
    XRratio = Matching.XRratio) annotation(
    Placement(visible = true, transformation(origin = {-110, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter_INIT converter1000_INIT(
    CFilter = Conv1000.CFilter,
    LFilter = Conv1000.LFilter,
    LTransformer = Conv1000.LTransformer,
    P0Pu = -Conv1000.PGen0Pu,
    Q0Pu = -Conv1000.QGen0Pu,
    RFilter = Conv1000.RFilter,
    RTransformer = Conv1000.RTransformer,
    SNom = Conv1000.SNom,
    U0Pu = Conv1000.U0Pu,
    UPhase0 = Conv1000.UPhase0) annotation(
    Placement(visible = true, transformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.Load_INIT load_INIT(
    P0Pu = PRefLoadPu,
    Q0Pu = QRefLoadPu,
    U0Pu = 0.988625,
    UPhase0 = -0.174548388) annotation(
    Placement(visible = true, transformation(origin = {-10, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  Droop.DeltaIConvSquare0Pu := gridFormingControl250_INIT.DeltaIConvSquare0Pu;
  Droop.DeltaVVId0 := gridFormingControl250_INIT.DeltaVVId0;
  Droop.DeltaVVIq0 := gridFormingControl250_INIT.DeltaVVIq0;
  Droop.IConvSquare0Pu := gridFormingControl250_INIT.IConvSquare0Pu;
  Droop.IdConv0Pu := converter250_INIT.IdConv0Pu;
  Droop.IdPcc0Pu := converter250_INIT.IdPcc0Pu;
  Droop.IdcSource0Pu := converter250_INIT.IdcSource0Pu;
  Droop.IqConv0Pu := converter250_INIT.IqConv0Pu;
  Droop.IqPcc0Pu := converter250_INIT.IqPcc0Pu;
  Droop.PFilter0Pu := converter250_INIT.PFilter0Pu;
  Droop.QFilter0Pu := converter250_INIT.QFilter0Pu;
  Droop.RVI0 := gridFormingControl250_INIT.RVI0;
  Droop.UdConv0Pu := converter250_INIT.UdConv0Pu;
  Droop.UdFilter0Pu := converter250_INIT.UdFilter0Pu;
  Droop.UqConv0Pu := converter250_INIT.UqConv0Pu;
  Droop.UqFilter0Pu := converter250_INIT.UqFilter0Pu;
  Droop.XVI0 := gridFormingControl250_INIT.XVI0;
  Conv250.IdConv0Pu := converter250_INIT.IdConv0Pu;
  Conv250.IdPcc0Pu := converter250_INIT.IdPcc0Pu;
  Conv250.IdcSource0Pu := converter250_INIT.IdcSource0Pu;
  Conv250.IqConv0Pu := converter250_INIT.IqConv0Pu;
  Conv250.IqPcc0Pu := converter250_INIT.IqPcc0Pu;
  Conv250.PFilter0Pu := converter250_INIT.PFilter0Pu;
  Conv250.QFilter0Pu := converter250_INIT.QFilter0Pu;
  Conv250.UdConv0Pu := converter250_INIT.UdConv0Pu;
  Conv250.UdFilter0Pu := converter250_INIT.UdFilter0Pu;
  Conv250.UdPcc0Pu := converter250_INIT.UdPcc0Pu;
  Conv250.UqConv0Pu := converter250_INIT.UqConv0Pu;
  Conv250.UqFilter0Pu := converter250_INIT.UqFilter0Pu;
  Conv250.UqPcc0Pu := converter250_INIT.UqPcc0Pu;
  Conv250.i0Pu.re := converter250_INIT.i0Pu.re;
  Conv250.i0Pu.im := converter250_INIT.i0Pu.im;
  Conv250.u0Pu.re := converter250_INIT.u0Pu.re;
  Conv250.u0Pu.im := converter250_INIT.u0Pu.im;
  dVOC.DeltaIConvSquare0Pu := gridFormingControl500_INIT.DeltaIConvSquare0Pu;
  dVOC.DeltaVVId0 := gridFormingControl500_INIT.DeltaVVId0;
  dVOC.DeltaVVIq0 := gridFormingControl500_INIT.DeltaVVIq0;
  dVOC.IConvSquare0Pu := gridFormingControl500_INIT.IConvSquare0Pu;
  dVOC.IdConv0Pu := converter500_INIT.IdConv0Pu;
  dVOC.IdPcc0Pu := converter500_INIT.IdPcc0Pu;
  dVOC.IdcSource0Pu := converter500_INIT.IdcSource0Pu;
  dVOC.IqConv0Pu := converter500_INIT.IqConv0Pu;
  dVOC.IqPcc0Pu := converter500_INIT.IqPcc0Pu;
  dVOC.PFilter0Pu := converter500_INIT.PFilter0Pu;
  dVOC.QFilter0Pu := converter500_INIT.QFilter0Pu;
  dVOC.RVI0 := gridFormingControl500_INIT.RVI0;
  dVOC.UdConv0Pu := converter500_INIT.UdConv0Pu;
  dVOC.UdFilter0Pu := converter500_INIT.UdFilter0Pu;
  dVOC.UqConv0Pu := converter500_INIT.UqConv0Pu;
  dVOC.UqFilter0Pu := converter500_INIT.UqFilter0Pu;
  dVOC.XVI0 := gridFormingControl500_INIT.XVI0;
  Conv500.IdConv0Pu := converter500_INIT.IdConv0Pu;
  Conv500.IdPcc0Pu := converter500_INIT.IdPcc0Pu;
  Conv500.IdcSource0Pu := converter500_INIT.IdcSource0Pu;
  Conv500.IqConv0Pu := converter500_INIT.IqConv0Pu;
  Conv500.IqPcc0Pu := converter500_INIT.IqPcc0Pu;
  Conv500.PFilter0Pu := converter500_INIT.PFilter0Pu;
  Conv500.QFilter0Pu := converter500_INIT.QFilter0Pu;
  Conv500.UdConv0Pu := converter500_INIT.UdConv0Pu;
  Conv500.UdFilter0Pu := converter500_INIT.UdFilter0Pu;
  Conv500.UdPcc0Pu := converter500_INIT.UdPcc0Pu;
  Conv500.UqConv0Pu := converter500_INIT.UqConv0Pu;
  Conv500.UqFilter0Pu := converter500_INIT.UqFilter0Pu;
  Conv500.UqPcc0Pu := converter500_INIT.UqPcc0Pu;
  Conv500.i0Pu.re := converter500_INIT.i0Pu.re;
  Conv500.i0Pu.im := converter500_INIT.i0Pu.im;
  Conv500.u0Pu.re := converter500_INIT.u0Pu.re;
  Conv500.u0Pu.im := converter500_INIT.u0Pu.im;
  Matching.DeltaIConvSquare0Pu := gridFormingControl1000_INIT.DeltaIConvSquare0Pu;
  Matching.DeltaVVId0 := gridFormingControl1000_INIT.DeltaVVId0;
  Matching.DeltaVVIq0 := gridFormingControl1000_INIT.DeltaVVIq0;
  Matching.IConvSquare0Pu := gridFormingControl1000_INIT.IConvSquare0Pu;
  Matching.IdConv0Pu := converter1000_INIT.IdConv0Pu;
  Matching.IdPcc0Pu := converter1000_INIT.IdPcc0Pu;
  Matching.IdcSource0Pu := converter1000_INIT.IdcSource0Pu;
  Matching.IqConv0Pu := converter1000_INIT.IqConv0Pu;
  Matching.IqPcc0Pu := converter1000_INIT.IqPcc0Pu;
  Matching.PFilter0Pu := converter1000_INIT.PFilter0Pu;
  Matching.QFilter0Pu := converter1000_INIT.PFilter0Pu;
  Matching.RVI0 := gridFormingControl1000_INIT.RVI0;
  Matching.UdConv0Pu := converter1000_INIT.UdConv0Pu;
  Matching.UdFilter0Pu := converter1000_INIT.UdFilter0Pu;
  Matching.UqConv0Pu := converter1000_INIT.UqConv0Pu;
  Matching.UqFilter0Pu := converter1000_INIT.UqFilter0Pu;
  Matching.XVI0 := gridFormingControl1000_INIT.XVI0;
  Conv1000.IdConv0Pu := converter1000_INIT.IdConv0Pu;
  Conv1000.IdPcc0Pu := converter1000_INIT.IdPcc0Pu;
  Conv1000.IdcSource0Pu := converter1000_INIT.IdcSource0Pu;
  Conv1000.IqConv0Pu := converter1000_INIT.IqConv0Pu;
  Conv1000.IqPcc0Pu := converter1000_INIT.IqPcc0Pu;
  Conv1000.PFilter0Pu := converter1000_INIT.PFilter0Pu;
  Conv1000.QFilter0Pu := converter1000_INIT.QFilter0Pu;
  Conv1000.UdConv0Pu := converter1000_INIT.UdConv0Pu;
  Conv1000.UdFilter0Pu := converter1000_INIT.UdFilter0Pu;
  Conv1000.UdPcc0Pu := converter1000_INIT.UdPcc0Pu;
  Conv1000.UqConv0Pu := converter1000_INIT.UqConv0Pu;
  Conv1000.UqFilter0Pu := converter1000_INIT.UqFilter0Pu;
  Conv1000.UqPcc0Pu := converter1000_INIT.UqPcc0Pu;
  Conv1000.i0Pu.re := converter1000_INIT.i0Pu.re;
  Conv1000.i0Pu.im := converter1000_INIT.i0Pu.im;
  Conv1000.u0Pu.re := converter1000_INIT.u0Pu.re;
  Conv1000.u0Pu.im := converter1000_INIT.u0Pu.im;
  Load.i0Pu.re := load_INIT.i0Pu.re;
  Load.i0Pu.im := load_INIT.i0Pu.im;
  Load.s0Pu.re := load_INIT.s0Pu.re;
  Load.s0Pu.im := load_INIT.s0Pu.im;
  Load.u0Pu.re := load_INIT.u0Pu.re;
  Load.u0Pu.im := load_INIT.u0Pu.im;

equation
  converter250_INIT.Theta0 = Conv250.Theta0;
  converter250_INIT.UdcSource0Pu = Conv250.UdcSource0Pu;
  gridFormingControl250_INIT.IdConv0Pu = Conv250.IdConv0Pu;
  gridFormingControl250_INIT.IdPcc0Pu = Conv250.IdPcc0Pu;
  gridFormingControl250_INIT.IdcSource0Pu = Conv250.IdcSource0Pu;
  gridFormingControl250_INIT.IqConv0Pu = Conv250.IqConv0Pu;
  gridFormingControl250_INIT.IqPcc0Pu = Conv250.IqPcc0Pu;
  gridFormingControl250_INIT.PFilter0Pu = Conv250.PFilter0Pu;
  gridFormingControl250_INIT.QFilter0Pu = Conv250.QFilter0Pu;
  gridFormingControl250_INIT.Theta0 = Conv250.Theta0;
  gridFormingControl250_INIT.UdFilter0Pu = UFilterRef250Pu.offset;
  gridFormingControl250_INIT.UdConv0Pu = Conv250.UdConv0Pu;
  gridFormingControl250_INIT.UqConv0Pu = Conv250.UqConv0Pu;
  converter500_INIT.Theta0 = Conv500.Theta0;
  converter500_INIT.UdcSource0Pu = Conv500.UdcSource0Pu;
  gridFormingControl500_INIT.IdConv0Pu = Conv500.IdConv0Pu;
  gridFormingControl500_INIT.IdPcc0Pu = Conv500.IdPcc0Pu;
  gridFormingControl500_INIT.IdcSource0Pu = Conv500.IdcSource0Pu;
  gridFormingControl500_INIT.IqConv0Pu = Conv500.IqConv0Pu;
  gridFormingControl500_INIT.IqPcc0Pu = Conv500.IqPcc0Pu;
  gridFormingControl500_INIT.PFilter0Pu = Conv500.PFilter0Pu;
  gridFormingControl500_INIT.QFilter0Pu = Conv500.QFilter0Pu;
  gridFormingControl500_INIT.Theta0 = Conv500.Theta0;
  gridFormingControl500_INIT.UdFilter0Pu = UFilterRef500Pu.offset;
  gridFormingControl500_INIT.UdConv0Pu = Conv500.UdConv0Pu;
  gridFormingControl500_INIT.UqConv0Pu = Conv500.UqConv0Pu;
  converter1000_INIT.Theta0 = Conv1000.Theta0;
  converter1000_INIT.UdcSource0Pu = Conv1000.UdcSource0Pu;
  gridFormingControl1000_INIT.IdConv0Pu = Conv1000.IdConv0Pu;
  gridFormingControl1000_INIT.IdPcc0Pu = Conv1000.IdPcc0Pu;
  gridFormingControl1000_INIT.IdcSource0Pu = Conv1000.IdcSource0Pu;
  gridFormingControl1000_INIT.IqConv0Pu = Conv1000.IqConv0Pu;
  gridFormingControl1000_INIT.IqPcc0Pu = Conv1000.IqPcc0Pu;
  gridFormingControl1000_INIT.PFilter0Pu = Conv1000.PFilter0Pu;
  gridFormingControl1000_INIT.QFilter0Pu = Conv1000.QFilter0Pu;
  gridFormingControl1000_INIT.Theta0 = Conv1000.Theta0;
  gridFormingControl1000_INIT.UdFilter0Pu = UFilterRef1000Pu.offset;
  gridFormingControl1000_INIT.UdConv0Pu = Conv1000.UdConv0Pu;
  gridFormingControl1000_INIT.UqConv0Pu = Conv1000.UqConv0Pu;

  Line12.switchOffSignal2.value = Disconnection.y;
  Line12.switchOffSignal1.value = false;
  Line13.switchOffSignal1.value = false;
  Line13.switchOffSignal2.value = false;
  Line23.switchOffSignal1.value = false;
  Line23.switchOffSignal2.value = false;
  Line23Bis1.switchOffSignal1.value = false;
  Line23Bis1.switchOffSignal2.value = false;
  Line23Bis2.switchOffSignal1.value = false;
  Line23Bis2.switchOffSignal2.value = false;
  Load.switchOffSignal1.value = false;
  Load.switchOffSignal2.value = false;
  Conv250.switchOffSignal1.value = false;
  Conv250.switchOffSignal2.value = false;
  Conv250.switchOffSignal3.value = false;
  Conv500.switchOffSignal1.value = false;
  Conv500.switchOffSignal2.value = false;
  Conv500.switchOffSignal3.value = false;
  Conv1000.switchOffSignal1.value = false;
  Conv1000.switchOffSignal2.value = false;
  Conv1000.switchOffSignal3.value = false;
  Load.PRefPu = PRefLoadPu;
  Load.QRefPu = QRefLoadPu;
  Load.deltaP = 0;
  Load.deltaQ = 0;

  connect(Droop.theta, Conv250.theta) annotation(
    Line(points = {{-91.25, 88.5}, {-78.25, 88.5}}, color = {0, 0, 127}));
  connect(Droop.udConvRefPu, Conv250.udConvRefPu) annotation(
    Line(points = {{-91.25, 81}, {-78.25, 81}}, color = {0, 0, 127}));
  connect(Droop.IdcSourcePu, Conv250.IdcSourcePu) annotation(
    Line(points = {{-91.25, 75}, {-78.25, 75}}, color = {0, 0, 127}));
  connect(Droop.uqConvRefPu, Conv250.uqConvRefPu) annotation(
    Line(points = {{-91.25, 69}, {-78.25, 69}}, color = {0, 0, 127}));
  connect(Droop.omegaPu, Conv250.omegaPu) annotation(
    Line(points = {{-91.25, 61.5}, {-78.25, 61.5}}, color = {0, 0, 127}));
  connect(dVOC.theta, Conv500.theta) annotation(
    Line(points = {{91.25, 88.5}, {79.25, 88.5}}, color = {0, 0, 127}));
  connect(dVOC.udConvRefPu, Conv500.udConvRefPu) annotation(
    Line(points = {{91.25, 81}, {79.25, 81}}, color = {0, 0, 127}));
  connect(dVOC.IdcSourcePu, Conv500.IdcSourcePu) annotation(
    Line(points = {{91.25, 75}, {79.25, 75}}, color = {0, 0, 127}));
  connect(dVOC.uqConvRefPu, Conv500.uqConvRefPu) annotation(
    Line(points = {{91.25, 69}, {79.25, 69}}, color = {0, 0, 127}));
  connect(dVOC.omegaPu, Conv500.omegaPu) annotation(
    Line(points = {{91.25, 61.5}, {79.25, 61.5}}, color = {0, 0, 127}));
  connect(Matching.omegaPu, Conv1000.omegaPu) annotation(
    Line(points = {{-91.25, -46.5}, {-78.25, -46.5}}, color = {0, 0, 127}));
  connect(Matching.uqConvRefPu, Conv1000.uqConvRefPu) annotation(
    Line(points = {{-91.25, -54}, {-78.25, -54}}, color = {0, 0, 127}));
  connect(Matching.IdcSourcePu, Conv1000.IdcSourcePu) annotation(
    Line(points = {{-91.25, -60}, {-78.25, -60}}, color = {0, 0, 127}));
  connect(Matching.udConvRefPu, Conv1000.udConvRefPu) annotation(
    Line(points = {{-91.25, -66}, {-78.25, -66}}, color = {0, 0, 127}));
  connect(Matching.theta, Conv1000.theta) annotation(
    Line(points = {{-91.25, -73.5}, {-78.25, -73.5}}, color = {0, 0, 127}));
  connect(Conv250.terminal, Line12.terminal2) annotation(
    Line(points = {{-62, 59.25}, {-62, 0.25}}, color = {0, 0, 255}));
  connect(Line12.terminal1, Conv1000.terminal) annotation(
    Line(points = {{-62, -30}, {-62, -44}}, color = {0, 0, 255}));
  connect(Conv250.terminal, Line23.terminal1) annotation(
    Line(points = {{-62, 59.25}, {-62, 47.25}, {-15, 47.25}}, color = {0, 0, 255}));
  connect(Line23.terminal2, Conv500.terminal) annotation(
    Line(points = {{15, 47}, {63, 47}, {63, 59}}, color = {0, 0, 255}));
  connect(Conv250.terminal, Line23Bis1.terminal1) annotation(
    Line(points = {{-62, 59.25}, {-62, 14.25}, {-50, 14.25}}, color = {0, 0, 255}));
  connect(Line23Bis2.terminal2, Conv500.terminal) annotation(
    Line(points = {{50, 14}, {63, 14}, {63, 59}}, color = {0, 0, 255}));
  connect(Conv500.terminal, Line13.terminal2) annotation(
    Line(points = {{63, 59.25}, {63, 0.25}}, color = {0, 0, 255}));
  connect(Line13.terminal1, Conv1000.terminal) annotation(
    Line(points = {{63, -30}, {63, -44}, {-62, -44}}, color = {0, 0, 255}));
  connect(Line23Bis1.terminal2, Line23Bis2.terminal1) annotation(
    Line(points = {{-20, 14}, {20, 14}}, color = {0, 0, 255}));
  connect(Matching.omegaPu, dVOC.omegaRefPu) annotation(
    Line(points = {{-80, -46.5}, {-80, 56}, {93.25, 56}, {93.25, 59}}, color = {0, 0, 127}));
  connect(Load.terminal, Line23.terminal1) annotation(
    Line(points = {{-15, 40}, {-15, 47}}, color = {0, 0, 255}));
  connect(Matching.omegaPu, Matching.omegaRefPu) annotation(
    Line(points = {{-80, -46.5}, {-80, -40}, {-93.5, -40}, {-93.5, -44}}, color = {0, 0, 127}));
  connect(Droop.UdcSourceRefOutPu, Conv250.UdcSourceRefPu) annotation(
    Line(points = {{-91.25, 64.5}, {-78.25, 64.5}}, color = {0, 0, 127}));
  connect(dVOC.UdcSourceRefOutPu, Conv500.UdcSourceRefPu) annotation(
    Line(points = {{91.25, 64.5}, {79.25, 64.5}}, color = {0, 0, 127}));
  connect(Matching.UdcSourceRefOutPu, Conv1000.UdcSourceRefPu) annotation(
    Line(points = {{-91.25, -49.5}, {-78.25, -49.5}}, color = {0, 0, 127}));
  connect(Matching.omegaPu, Droop.omegaRefPu) annotation(
    Line(points = {{-80, -46.5}, {-80, 56}, {-93.75, 56}, {-93.75, 59}}, color = {0, 0, 127}));
  connect(UFilterRef250Pu.y, Droop.UFilterRefPu) annotation(
    Line(points = {{-139.5, 75}, {-123.5, 75}}, color = {0, 0, 127}));
  connect(IdcSourceRef250Pu.y, Droop.IdcSourceRefPu) annotation(
    Line(points = {{-139.5, 58}, {-130, 58}, {-130, 66}, {-123, 66}}, color = {0, 0, 127}));
  connect(QRef250Pu.y, Droop.QRefPu) annotation(
    Line(points = {{-139.5, 92}, {-130, 92}, {-130, 84}, {-123, 84}}, color = {0, 0, 127}));
  connect(IdcSourceRef1000Pu.y, Matching.IdcSourceRefPu) annotation(
    Line(points = {{-139.5, -60}, {-131.25, -60}, {-131.25, -51}, {-123, -51}}, color = {0, 0, 127}));
  connect(UdcSourceRef1000Pu.y, Matching.UdcSourceRefPu) annotation(
    Line(points = {{-139.5, -43}, {-128.75, -43}, {-128.75, -45}, {-123, -45}}, color = {0, 0, 127}));
  connect(UFilterRef1000Pu.y, Matching.UFilterRefPu) annotation(
    Line(points = {{-139.5, -77}, {-128.75, -77}, {-128.75, -60}, {-123, -60}}, color = {0, 0, 127}));
  connect(UFilterRef500Pu.y, dVOC.UFilterRefPu) annotation(
    Line(points = {{139.5, 75}, {122.5, 75}}, color = {0, 0, 127}));
  connect(QRef500Pu.y, dVOC.QRefPu) annotation(
    Line(points = {{139.5, 92}, {130, 92}, {130, 84}, {123, 84}}, color = {0, 0, 127}));
  connect(IdcSourceRef500Pu.y, dVOC.IdcSourceRefPu) annotation(
    Line(points = {{139.5, 58}, {130, 58}, {130, 66}, {123, 66}}, color = {0, 0, 127}));
  connect(Line23Bis1.terminal2, Fault.terminal) annotation(
    Line(points = {{-20, 14}, {0, 14}, {0, -16}}, color = {0, 0, 255}));
  connect(PRef250Pu.y, Droop.PRefPu) annotation(
    Line(points = {{-139.5, 109}, {-129.5, 109}, {-129.5, 90}, {-123.5, 90}}, color = {0, 0, 127}));
  connect(UdcSourceRef250Pu.y, Droop.UdcSourceRefPu) annotation(
    Line(points = {{-139.5, 41}, {-129.5, 41}, {-129.5, 60}, {-123.5, 60}}, color = {0, 0, 127}));
  connect(UdcSourceRef500Pu.y, dVOC.UdcSourceRefPu) annotation(
    Line(points = {{139.5, 41}, {128.5, 41}, {128.5, 60}, {122.5, 60}}, color = {0, 0, 127}));
  connect(PRef500Pu.y, dVOC.PRefPu) annotation(
    Line(points = {{139.5, 109}, {128.5, 109}, {128.5, 90}, {122.5, 90}}, color = {0, 0, 127}));
  connect(Conv250.udFilterPu, Droop.udFilterPu) annotation(
    Line(points = {{-46.25, 88.5}, {-35.25, 88.5}, {-35.25, 91}, {-94.25, 91}}, color = {0, 0, 127}));
  connect(Conv250.idPccPu, Droop.idPccPu) annotation(
    Line(points = {{-46.25, 84}, {-34.25, 84}, {-34.25, 93}, {-98.25, 93}, {-98.25, 91}}, color = {0, 0, 127}));
  connect(Conv250.idConvPu, Droop.idConvPu) annotation(
    Line(points = {{-46.25, 79.5}, {-33.25, 79.5}, {-33.25, 94}, {-103.25, 94}, {-103.25, 91}, {-102.75, 91}}, color = {0, 0, 127}));
  connect(Conv250.UdcSourcePu, Droop.UdcSourcePu) annotation(
    Line(points = {{-46.25, 75}, {-32.25, 75}, {-32.25, 95}, {-107.25, 95}, {-107.25, 91}}, color = {0, 0, 127}));
  connect(Conv250.iqConvPu, Droop.iqConvPu) annotation(
    Line(points = {{-46.25, 70.5}, {-31.25, 70.5}, {-31.25, 96}, {-112.25, 96}, {-112.25, 91}}, color = {0, 0, 127}));
  connect(Conv250.iqPccPu, Droop.iqPccPu) annotation(
    Line(points = {{-46.25, 66}, {-30.25, 66}, {-30.25, 97}, {-116.25, 97}, {-116.25, 91}}, color = {0, 0, 127}));
  connect(Conv250.uqFilterPu, Droop.uqFilterPu) annotation(
    Line(points = {{-46.25, 61.5}, {-29.25, 61.5}, {-29.25, 98}, {-121.25, 98}, {-121.25, 91}}, color = {0, 0, 127}));
  connect(Conv500.udFilterPu, dVOC.udFilterPu) annotation(
    Line(points = {{47.25, 88.5}, {35.25, 88.5}, {35.25, 92}, {94.25, 92}, {94.25, 91}}, color = {0, 0, 127}));
  connect(Conv500.idPccPu, dVOC.idPccPu) annotation(
    Line(points = {{47.25, 84}, {34.25, 84}, {34.25, 93}, {98.25, 93}, {98.25, 91}}, color = {0, 0, 127}));
  connect(Conv500.idConvPu, dVOC.idConvPu) annotation(
    Line(points = {{47.25, 79.5}, {33.25, 79.5}, {33.25, 94}, {102.25, 94}, {102.25, 91}}, color = {0, 0, 127}));
  connect(Conv500.UdcSourcePu, dVOC.UdcSourcePu) annotation(
    Line(points = {{47.25, 75}, {32.25, 75}, {32.25, 95}, {107.25, 95}, {107.25, 91}}, color = {0, 0, 127}));
  connect(Conv500.iqConvPu, dVOC.iqConvPu) annotation(
    Line(points = {{47.25, 70.5}, {31.25, 70.5}, {31.25, 96}, {111.25, 96}, {111.25, 91}}, color = {0, 0, 127}));
  connect(Conv500.iqPccPu, dVOC.iqPccPu) annotation(
    Line(points = {{47.25, 66}, {30.25, 66}, {30.25, 97}, {116.25, 97}, {116.25, 91}}, color = {0, 0, 127}));
  connect(Conv500.uqFilterPu, dVOC.uqFilterPu) annotation(
    Line(points = {{47.25, 61.5}, {29.25, 61.5}, {29.25, 98}, {121.25, 98}, {121.25, 91}}, color = {0, 0, 127}));
  connect(Conv1000.udFilterPu, Matching.udFilterPu) annotation(
    Line(points = {{-46.25, -73.5}, {-35.25, -73.5}, {-35.25, -77}, {-94.25, -77}, {-94.25, -76}}, color = {0, 0, 127}));
  connect(Conv1000.idPccPu, Matching.idPccPu) annotation(
    Line(points = {{-46.25, -69}, {-34.25, -69}, {-34.25, -78}, {-98.25, -78}, {-98.25, -76}}, color = {0, 0, 127}));
  connect(Conv1000.idConvPu, Matching.idConvPu) annotation(
    Line(points = {{-46.25, -64.5}, {-33.25, -64.5}, {-33.25, -79}, {-102.75, -79}, {-102.75, -76}}, color = {0, 0, 127}));
  connect(Conv1000.UdcSourcePu, Matching.UdcSourcePu) annotation(
    Line(points = {{-46.25, -60}, {-32.25, -60}, {-32.25, -80}, {-107.25, -80}, {-107.25, -76}}, color = {0, 0, 127}));
  connect(Conv1000.iqConvPu, Matching.iqConvPu) annotation(
    Line(points = {{-46.25, -55.5}, {-31.25, -55.5}, {-31.25, -81}, {-112.25, -81}, {-112.25, -76}}, color = {0, 0, 127}));
  connect(Conv1000.iqPccPu, Matching.iqPccPu) annotation(
    Line(points = {{-46.25, -51}, {-30.25, -51}, {-30.25, -82}, {-116.25, -82}, {-116.25, -76}}, color = {0, 0, 127}));
  connect(Conv1000.uqFilterPu, Matching.uqFilterPu) annotation(
    Line(points = {{-46.25, -46.5}, {-29.25, -46.5}, {-29.25, -83}, {-121.25, -83}, {-121.25, -76}}, color = {0, 0, 127}));
  connect(Conv250.PFilterPu, Droop.PFilterPu) annotation(
    Line(points = {{-72.5, 59.25}, {-72.5, 54.25}, {-96.5, 54.25}, {-96.5, 59.25}}, color = {0, 0, 127}));
  connect(Conv250.QFilterPu, Droop.QFilterPu) annotation(
    Line(points = {{-51.5, 59.25}, {-51.5, 50.25}, {-118.5, 50.25}, {-118.5, 59.25}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-6, Interval = 0.006),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in three different grid-forming converters (one with a droop control, one with a dispatchable virtual oscillator control and one with a matching control) connected to a load. At t = 0.5 s the line connecting the 250 MVA (droop) and the 1000 MVA (matching) converters is opened. At t = 1.5 s, a short-circuit occurs in the middle of one of the lines connecting the 250 MVA (droop) and the 500 MVA (dVOC) converters. It is cleared after 150 ms. This test case and the grid-forming converters controls come from the Horizon 2020 European project MIGRATE, and more precisely from its Deliverables 3.2 and 3.3 that can be found on the project website : https://www.h2020-migrate.eu/downloads.html.
    </div><div><br></div><div>The two following figures show the expected evolution of the frequency and the current for each converter during the simulation.
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/frequency.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/current.png\">
    </figure>
    One can remark that after the events, the frequencies of the three converters are equal and close to their value before the events, thanks to the power-sharing allowed by the outer loop controls (droop, matching and dVOC).</div><div><br></div><div> One can also remark that during the fault, the currents of the three converters are limited at a value lower than 1.2 pu thanks to the virtual impedance. More details can be found in the MIGRATE project deliverables.</div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>"),
    Diagram(coordinateSystem(extent = {{-160, -140}, {160, 140}})));
end GridForming;
