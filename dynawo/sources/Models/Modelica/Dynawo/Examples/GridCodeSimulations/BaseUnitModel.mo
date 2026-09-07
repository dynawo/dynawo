within Dynawo.Examples.GridCodeSimulations;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseUnitModel
  extends BaseParameters;

  Dynawo.Electrical.Wind.WECC.WTG3CurrentSource1 Unit(
    ConverterLVControl = true,
    DDn = 100,
    DPMaxPu = 0.1117,
    DPMinPu = -0.35,
    DUp = 100,
    Dbd1Pu = -0.02,
    Dbd2Pu = 0.02,
    DbdPu = 0,
    Dshaft = 2,
    EMaxPu = 9999,
    EMinPu = -9999,
    FDbd1Pu = 0,
    FDbd2Pu = 0,
    FEMaxPu = 0.0133,
    FEMinPu = -0.0133,
    FreqFlag = true,
    Hg = 0.487,
    Ht = 6.869,
    IMaxPu = 1.1,
    Id0Pu(fixed = false),
    Iq0Pu(fixed = false),
    IqFrzPu = 1e-5,
    Iqh1Pu = 2,
    Iql1Pu = -2,
    IqrMaxPu = 1000,
    IqrMinPu = -1000,
    Ka = 0.01,
    Kc = 0.12222,
    Kcc = 0,
    Ki = 4.09151,
    KiPLL = 20,
    Kic = 0,
    Kig = 1,
    Kip = 2.5,
    Kiw = 0.5,
    Kp = 2.864,
    KpPLL = 3,
    Kpc = 1e-5,
    Kpg = 0.1,
    Kpp = 0.5,
    Kpw = 89,
    Kqi = 0.7,
    Kqp = 1,
    Kqv = 2,
    Kshaft = 50,
    Kvi = 4,
    Kvp = 1,
    Lvplsw = true,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    P0Pu = P0Pu,
    P1 = 1e-5,
    P2 = 0.6,
    P3 = 1,
    P4 = 1.3,
    PConv0Pu(fixed = false),
    PF0(fixed = false),
    PFlag = false,
    PInj0Pu(fixed = false),
    PMaxREECPu = 1.05,
    PMaxREPCPu = 1.05,
    PMinREECPu = 0,
    PMinREPCPu = 0,
    PPCLocal = true,
    PQFlag = false,
    PfFlag = false,
    Pm0Pu(fixed = false),
    Q0Pu = Q0Pu,
    QConv0Pu(fixed = false),
    QFlag = false,
    QInj0Pu(fixed = false),
    QMaxREECPu = 0.63583815,
    QMaxREPCPu = 0.63583815,
    QMinREECPu = -0.63583815,
    QMinREPCPu = -0.63583815,
    RLvTrPu = 0,
    RMvHvPu = 0,
    RefFlag = true,
    RrpwrPu = 10,
    SNom = SNom,
    Spd1 = 0.6,
    Spd2 = 0.97,
    Spd3 = 1,
    Spd4 = 0.62,
    TFlag = true,
    TeMaxPu = 1.28,
    TeMinPu = 1e-5,
    Theta0 = 0,
    ThetaMax = 90,
    ThetaMin = 1e-5,
    ThetaRMax = 8,
    ThetaRMin = -8,
    U0Pu = U0Pu,
    UConv0Pu(fixed = false),
    UInj0Pu(fixed = false),
    UPhase0 = UPhase0,
    UPhaseConv0(fixed = false),
    VCompFlag = false,
    VDipPu = 0.9,
    VFlag = true,
    VFrz = 0.8,
    VMaxPu = 1.14,
    VMinPu = 0.88,
    VRef0Pu = 0,
    VRef1Pu = 0,
    VUpPu = 1.15,
    XLvTrPu = 0,
    XMvHvPu = 0.1,
    brkpt = 0.01,
    i0Pu(im(fixed = false), re(fixed = false)),
    iConv0Pu(im(fixed = false), re(fixed = false)),
    lvpl1 = 1.1,
    omegaRefWTGQPu0(fixed = false),
    s0Pu(im(fixed = false), re(fixed = false)),
    tFilterGC = 0.02,
    tFilterPC = 0.005,
    tFt = 1e-5,
    tFv = 0.09,
    tG = 0.01,
    tHoldIpMax = 0,
    tHoldIq = -1,
    tIq = 1.05,
    tLag = 0.15,
    tOmegaRef = 10,
    tpWTGQa = 0.05,
    tpREEC = 0.05,
    tpREPC = 0.05,
    tPord = 0.01,
    tRv = 0.02,
    tTheta = 0.18,
    u0Pu(im(fixed = false), re(fixed = false)),
    uConv0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu(im(fixed = false), re(fixed = false)),
    uPcc0Pu(im(fixed = false), re(fixed = false)),
    zerox = 0,
    VDLIp11 = 0,
    VDLIp12 = 1.1,
    VDLIp21 = 1,
    VDLIp22 = 1.1,
    VDLIp31 = 2,
    VDLIp32 = 1.1,
    VDLIp41 = 3,
    VDLIp42 = 1.1,
    VDLIq11 = 0,
    VDLIq12 = 1.1,
    VDLIq21 = 1,
    VDLIq22 = 1.1,
    VDLIq31 = 2,
    VDLIq32 = 1.1,
    VDLIq41 = 3,
    VDLIq42 = 1.1) annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PRefPu(k = -Unit.P0Pu*Electrical.SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = -Unit.Q0Pu*Electrical.SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(Unit.PF0)) annotation(
    Placement(transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step URefPu(
    offset = Unit.wecc_repc.URef0Pu,
    height = 0,
    startTime = 2) annotation(
    Placement(transformation(origin = {90, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = -Unit.P0Pu*Electrical.SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {-30, 80}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}})));

  // Initialization
  Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCPlantCurrentSource_INIT wTG4CurrentSource_INIT(
    BMvHvPu = Unit.BMvHvPu,
    ConverterLVControl = Unit.ConverterLVControl,
    GMvHvPu = Unit.GMvHvPu,
    P0Pu = Unit.P0Pu,
    PPCLocal = Unit.PPCLocal,
    PPcc0Pu = Unit.PPcc0Pu,
    Q0Pu = Unit.Q0Pu,
    QPcc0Pu = Unit.QPcc0Pu,
    RLvTrPu = Unit.RLvTrPu,
    RMvHvPu = Unit.RMvHvPu,
    SNom = Unit.SNom,
    U0Pu = Unit.U0Pu,
    UPcc0Pu = Unit.UPcc0Pu,
    UPhase0 = Unit.UPhase0,
    XLvTrPu = Unit.XLvTrPu,
    XMvHvPu = Unit.XMvHvPu,
    rTfoPu = Unit.rTfoPu,
    P1 = Unit.P1,
    Spd1 = Unit.Spd1,
    P2 = Unit.P2,
    Spd2 = Unit.Spd2,
    P3 = Unit.P3,
    Spd3 = Unit.Spd3,
    P4 = Unit.P4,
    Spd4 = Unit.Spd4) annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial algorithm
  Unit.Id0Pu := wTG4CurrentSource_INIT.Id0Pu;
  Unit.Iq0Pu := wTG4CurrentSource_INIT.Iq0Pu;
  Unit.PF0 := wTG4CurrentSource_INIT.PF0;
  Unit.PInj0Pu := wTG4CurrentSource_INIT.PInj0Pu;
  Unit.QInj0Pu := wTG4CurrentSource_INIT.QInj0Pu;
  Unit.UInj0Pu := wTG4CurrentSource_INIT.UInj0Pu;
  Unit.i0Pu.re := wTG4CurrentSource_INIT.i0Pu.re;
  Unit.i0Pu.im := wTG4CurrentSource_INIT.i0Pu.im;
  Unit.iConv0Pu.re := wTG4CurrentSource_INIT.iConv0Pu.re;
  Unit.iConv0Pu.im := wTG4CurrentSource_INIT.iConv0Pu.im;
  Unit.s0Pu.re := wTG4CurrentSource_INIT.s0Pu.re;
  Unit.s0Pu.im := wTG4CurrentSource_INIT.s0Pu.im;
  Unit.u0Pu.re := wTG4CurrentSource_INIT.u0Pu.re;
  Unit.u0Pu.im := wTG4CurrentSource_INIT.u0Pu.im;
  Unit.uInj0Pu.re := wTG4CurrentSource_INIT.uInj0Pu.re;
  Unit.uInj0Pu.im := wTG4CurrentSource_INIT.uInj0Pu.im;
  Unit.UConv0Pu := wTG4CurrentSource_INIT.UConv0Pu;
  Unit.uConv0Pu.re := wTG4CurrentSource_INIT.uConv0Pu.re;
  Unit.uConv0Pu.im := wTG4CurrentSource_INIT.uConv0Pu.im;
  Unit.uPcc0Pu.re := wTG4CurrentSource_INIT.uPcc0Pu.re;
  Unit.uPcc0Pu.im := wTG4CurrentSource_INIT.uPcc0Pu.im;
  Unit.PConv0Pu := wTG4CurrentSource_INIT.PConv0Pu;
  Unit.QConv0Pu := wTG4CurrentSource_INIT.QConv0Pu;
  Unit.UPhaseConv0 := wTG4CurrentSource_INIT.UPhaseConv0;
  Unit.omegaRefWTGQPu0 := wTG4CurrentSource_INIT.omegaRefWTGQPu0;

equation
  Unit.injector.switchOffSignal1 = false;
  Unit.injector.switchOffSignal2 = false;
  Unit.injector.switchOffSignal3 = false;

  connect(QRefPu.y, Unit.QRefPu) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, 12}, {42, 12}}, color = {0, 0, 127}));
  connect(PRefPu.y, Unit.PRefPu) annotation(
    Line(points = {{79, 0}, {42, 0}}, color = {0, 0, 127}));
  connect(URefPu.y, Unit.URefPu) annotation(
    Line(points = {{79, 80}, {32, 80}, {32, 22}}, color = {0, 0, 127}));
  connect(PFaRef.y, Unit.PFaRef) annotation(
    Line(points = {{79, -80}, {20, -80}, {20, -22}}, color = {0, 0, 127}));
  connect(PmRefPu.y, Unit.PmRefPu) annotation(
    Line(points = {{-19, 80}, {8, 80}, {8, 22}}, color = {0, 0, 127}));
  connect(const.y, Unit.PPccPu) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -6}, {-2, -6}}, color = {0, 0, 127}));
  connect(const.y, Unit.QPccPu) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(complexConst.y, Unit.uPccPu) annotation(
    Line(points = {{-38, -80}, {-10, -80}, {-10, -14}, {-2, -14}}, color = {85, 170, 255}));

  annotation(
  Icon,
  Documentation(info = "<html>
<p><b>Rules to follow in order to prevent bug :</b></p>

<ul>
  <li>Before adding your plant model, you should delete the one available here.</li>
  <br/>

  <li>You should name your model \"Unit\" in the attributes (the connections in the test cases depend on this name).</li>
  <br/>

  <li>You should define the base apparent power of your plant model as \"SNom\", parameter that you will define in the \"BaseParameter\" file.</li>
  <br/>

  <li>You should define the 4 initialization parameters U0Pu, P0Pu, Q0Pu, UPhase0 with those exact names in your model. Those parameters are defined across the test cases model to respect the operating points required in the grid code simulations.</li>
  <br/>

  <li>You should define here the complete tuning of your model. This is where you define the tuning used across all simulations in this GridCodeSimulations package.</li>
  <br/>

  <li>You should make sure your model is initializing properly.</li>
  <br/>

  <li>The voltage order entry of your model should remain a step model with offset = Unit.URef0Pu, height = 0.</li>
</ul>

<p><b>If the entries of your model are in base SNom and in receptor convention :</b></p>

<ul>
  <li>The active power order entry of your model should be a constant = -Unit.P0Pu*Electrical.SystemBase.SnRef/SNom.</li>
  <br/>

  <li>The reactive power order entry of your model should be a constant = -Unit.Q0Pu*Electrical.SystemBase.SnRef/SNom.</li>
</ul>

</html>"));
end BaseUnitModel;
