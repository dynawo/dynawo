within Dynawo.Examples.PEIR.Plants.Simplified;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/
model GFLPlantPropIntWECC
  extends Modelica.Icons.Example;
  extends Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan(infiniteBusWithVariations(UEvtPu = 1, tUEvtStart = 2, tUEvtEnd = 4, tOmegaEvtStart = 30, tOmegaEvtEnd = 31));
  // Inputs
  Modelica.Blocks.Sources.Constant PRefPu(k = PV.PControl0Pu) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step URefStep(offset = PV.wecc_repc.URef0Pu, height = 0.05, startTime = 10) annotation(
    Placement(transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(PV.PF0)) annotation(
    Placement(transformation(origin = {-138, 72}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = PV.QControl0Pu) annotation(
    Placement(transformation(origin = {-150, 0}, extent = {{-10, 10}, {10, -10}})));

  Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSource PV(ConverterLVControl = false, DDn = 20, DPMaxPu = 999, DPMinPu = -999, DUp = 0.001, Dbd1Pu = -0, Dbd2Pu = 0, DbdPu = 0.05, EMaxPu = 999, EMinPu = -999, FDbd1Pu = 0.004, FDbd2Pu = 1, FEMaxPu = 999, FEMinPu = -999, FreqFlag = false, IMaxPu = 2, Iqh1Pu = 2, Iql1Pu = -2, IqrMaxPu = 20, IqrMinPu = -20, Kc = 0.21, Ki = 10, KiPLL = 20, Kig = 2.36, Kp = 5, KpPLL = 3, Kpg = 0.05, Kqi = 0.5, Kqp = 1, Kqv = 0, Kvi = 1, Kvp = 1, Lvplsw = false, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, PMaxREECPu = 99, PMaxREPCPu = 1, PMinREECPu = 0, PMinREPCPu = 0, PPCLocal = false, PQFlag = false, PfFlag = false, QFlag = false, QMaxREECPu = 99, QMaxREPCPu = 99, QMinREECPu = -99, QMinREPCPu = -99, RefFlag = true, RrpwrPu = 10, SNom = 15, VCompFlag = false, VDipPu = 0.5, VFlag = true, VFrz = 0, VMaxPu = 1.5, VMinPu = 0.5, VRef0Pu = 1, VRef1Pu = 0, VUpPu = 1.5, brkpt = 0.1, lvpl1 = 1.22, tFilterGC = 1e-6, tFilterPC = 1e-10, tFt = 1e-10, tFv = 1e-10, tG = 1e-4, tIq = 1e-6, tLag = 0.1, tpREEC = 0.04, tpREPC = 0.04, tPord = 1e-4, tRv = 0.0001, zerox = 0.05, Id0Pu(fixed = false), Iq0Pu(fixed = false), PConv0Pu(fixed = false), UPhaseConv0(fixed = false), UControl0Pu(fixed = false), PF0(fixed = false), PInj0Pu(fixed = false), QConv0Pu(fixed = false), QInj0Pu(fixed = false), UInj0Pu(fixed = false), i0Pu(im(fixed = false), re(fixed = false)), iConv0Pu(im(fixed = false), re(fixed = false)), s0Pu(im(fixed = false), re(fixed = false)), u0Pu(im(fixed = false), re(fixed = false)), UConv0Pu(fixed = false), uConv0Pu(im(fixed = false), re(fixed = false)), uInj0Pu(im(fixed = false), re(fixed = false)), uPcc0Pu(im(fixed = false), re(fixed = false)), RLvTrPu = 0, XLvTrPu = 0, PPcc0Pu = -0.2, QPcc0Pu = 0.04458447,  //U0Pu = 1.06624,
 //P0Pu = -0.15,
 //Q0Pu = 0.035,
 //UPcc0Pu = 1.0679)
  P0Pu = -0.2, Q0Pu = 0.0439939, U0Pu = 1.06437, UPcc0Pu = 1.06648) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  // Initialization
  Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCPlantCurrentSource_INIT wTG4CurrentSource_INIT(ConverterLVControl = PV.ConverterLVControl, P0Pu = PV.P0Pu, PPCLocal = false, PPcc0Pu = PV.PPcc0Pu, Q0Pu = PV.Q0Pu, QPcc0Pu = PV.QPcc0Pu, RLvTrPu = 0, SNom = PV.SNom, U0Pu = PV.U0Pu, UPcc0Pu = PV.UPcc0Pu, UPhase0 = 0.00808331, XLvTrPu = 0, UPhasePcc0 = -0.00072649, BMvHvPu = 0, GMvHvPu = 0, RMvHvPu = 0, XMvHvPu = 0) annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  PV.Id0Pu := wTG4CurrentSource_INIT.Id0Pu;
  PV.Iq0Pu := wTG4CurrentSource_INIT.Iq0Pu;
  PV.PF0 := wTG4CurrentSource_INIT.PF0;
  PV.PInj0Pu := wTG4CurrentSource_INIT.PInj0Pu;
  PV.QInj0Pu := wTG4CurrentSource_INIT.QInj0Pu;
  PV.UInj0Pu := wTG4CurrentSource_INIT.UInj0Pu;
  PV.UControl0Pu := wTG4CurrentSource_INIT.UControl0Pu;
  PV.i0Pu.re := wTG4CurrentSource_INIT.i0Pu.re;
  PV.i0Pu.im := wTG4CurrentSource_INIT.i0Pu.im;
  PV.iConv0Pu.re := wTG4CurrentSource_INIT.iConv0Pu.re;
  PV.iConv0Pu.im := wTG4CurrentSource_INIT.iConv0Pu.im;
  PV.s0Pu.re := wTG4CurrentSource_INIT.s0Pu.re;
  PV.s0Pu.im := wTG4CurrentSource_INIT.s0Pu.im;
  PV.u0Pu.re := wTG4CurrentSource_INIT.u0Pu.re;
  PV.u0Pu.im := wTG4CurrentSource_INIT.u0Pu.im;
  PV.uInj0Pu.re := wTG4CurrentSource_INIT.uInj0Pu.re;
  PV.uInj0Pu.im := wTG4CurrentSource_INIT.uInj0Pu.im;
  PV.UConv0Pu := wTG4CurrentSource_INIT.UConv0Pu;
  PV.uConv0Pu.re := wTG4CurrentSource_INIT.uConv0Pu.re;
  PV.uConv0Pu.im := wTG4CurrentSource_INIT.uConv0Pu.im;
  PV.uPcc0Pu.re := wTG4CurrentSource_INIT.uPcc0Pu.re;
  PV.uPcc0Pu.im := wTG4CurrentSource_INIT.uPcc0Pu.im;
  PV.PConv0Pu := wTG4CurrentSource_INIT.PConv0Pu;
  PV.QConv0Pu := wTG4CurrentSource_INIT.QConv0Pu;
  PV.UPhaseConv0 := wTG4CurrentSource_INIT.UPhaseConv0;

equation
  PV.injector.switchOffSignal1 = false;
  PV.injector.switchOffSignal2 = false;
  PV.injector.switchOffSignal3 = false;

  connect(PV.uPccPu, transformer.uPu);
  connect(PV.QPccPu, transformer.Q2Pu);
  connect(PV.PPccPu, transformer.P2Pu);
  connect(PRefPu.y, PV.PRefPu) annotation(
    Line(points = {{-139, 40}, {-126, 40}, {-126, 6}, {-120, 6}}, color = {0, 0, 127}));
  connect(PV.omegaRefPu, omegaRefPu.y) annotation(
    Line(points = {{-120, -6}, {-130, -6}, {-130, -40}, {-138, -40}}, color = {0, 0, 127}));
  connect(PFaRef.y, PV.PFaRef) annotation(
    Line(points = {{-126, 72}, {-110, 72}, {-110, 12}}, color = {0, 0, 127}));
  connect(QRefPu.y, PV.QRefPu) annotation(
    Line(points = {{-138, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(PV.terminal, transformer.terminal1) annotation(
    Line(points = {{-98, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(URefStep.y, PV.URefPu) annotation(
    Line(points = {{-138, -80}, {-110, -80}, {-110, -10}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {160, 60}})),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001));
end GFLPlantPropIntWECC;
