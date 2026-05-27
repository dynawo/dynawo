within Dynawo.Examples.GridCodeSimulations;

model BaseUnitModel
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
  extends BaseParameters;
   Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4 Unit(
    ConverterLVControl = true,
    DDn = 20,
    DPMaxPu = 999,
    DPMinPu = -999,
    DUp = 0.001,
    Dbd1Pu = -0.1,
    Dbd2Pu = 0.1,
    DbdPu = 0.01,
    EMaxPu = 999,
    EMinPu = -999,
    FDbd1Pu = 0.004,
    FDbd2Pu = 1,
    FEMaxPu = 999,
    FEMinPu = -999,
    FreqFlag = true,
    IMaxPu = 1.05,
    Iqh1Pu = 2,
    Iql1Pu = -2,
    IqrMaxPu = 20,
    IqrMinPu = -20,
    Kc = 0,
    Ki = 1.5,
    KiPLL = 20,
    Kig = 2.36,
    Kii = 20,
    Kip = 3,
    Kp = 0.1,
    KpPLL = 3,
    Kpg = 0.05,
    Kqi = 0.5,
    Kqp = 1,
    Kqv = 2,
    Kvi = 1,
    Kvp = 1,
    OmegaMaxPu = 1.5,
    OmegaMinPu = 0.5,
    P0Pu = P0Pu,
    PMaxPu = 1,
    PMinPu = 0,
    PPCLocal = true,
    PQFlag = false,
    PfFlag = false,
    Q0Pu = Q0Pu,
    QFlag = true,
    QMaxPu = 0.4,
    QMinPu = -0.4,
    RSourcePu = 0,
    RateFlag = false,
    RefFlag = true,
    RrpwrPu = 10,
    U0Pu = U0Pu,
    VCompFlag = false,
    VDipPu = 0.9,
    VFlag = true,
    VFrz = 0,
    VMaxPu = 1.1,
    VMinPu = 0.9,
    VRef0Pu = 1,
    VRef1Pu = 0,
    VUpPu = 1.1,
    XSourcePu = 0.1,
    tE = 0.005,
    tFilterGC = 0.02,
    tFilterPC = 0.04,
    tFt = 1e-10,
    tFv = 0.1,
    tIq = 0.02,
    tLag = 0.1,
    tP = 0.04,
    tPord = 0.02,
    tRv = 0.02,
    i0Pu(im(fixed = false), re(fixed = false)),
    u0Pu(im(fixed = false), re(fixed = false)),
    s0Pu(im(fixed = false), re(fixed = false)),
    uConv0Pu(im(fixed = false), re(fixed = false)),
    iSource0Pu(im(fixed = false), re(fixed = false)),
    iConv0Pu(im(fixed = false), re(fixed = false)),
    iInj0Pu(im(fixed = false), re(fixed = false)),
    uInj0Pu(im(fixed = false), re(fixed = false)),
    uSource0Pu(im(fixed = false), re(fixed = false)),
    Id0Pu(fixed = false),
    Iq0Pu(fixed = false),
    PConv0Pu(fixed = false),
    PF0(fixed = false),
    PInj0Pu(fixed = false),
    QConv0Pu(fixed = false),
    QInj0Pu(fixed = false),
    UInj0Pu(fixed = false),
    UConv0Pu(fixed = false),
    UdInj0Pu(fixed = false),
    UqInj0Pu(fixed = false),
    uPcc0Pu(im(fixed = false), re(fixed = false)),
    UPhaseConv0(fixed = false),
    RLvTrPu = 0,
    XLvTrPu = 0,
    XMvHvPu = 0.15, SNom = SNom) annotation(
    Placement(transformation(origin = {22, -4}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  Modelica.Blocks.Sources.Constant PRefPu(k = -Unit.P0Pu*Electrical.SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant QRefPu(k = -Unit.Q0Pu*Electrical.SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {90, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PFaRef(k = acos(Unit.PF0)) annotation(
    Placement(transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step URefPu(offset = Unit.wecc_repc.URef0Pu, height = 0, startTime = 2) annotation(
    Placement(transformation(origin = {90, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = -Unit.P0Pu*Electrical.SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {-30, 80}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}})));
  // Initialization
  // Initialization
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource_INIT pvVoltageSource_INIT(ConverterLVControl = Unit.ConverterLVControl, P0Pu = Unit.P0Pu, PPCLocal = Unit.PPCLocal, Q0Pu = Unit.Q0Pu, RSourcePu = Unit.RSourcePu, SNom = Unit.SNom, U0Pu = Unit.U0Pu, UPhase0 = UPhase0, XSourcePu = Unit.XSourcePu, BMvHvPu = Unit.BMvHvPu, GMvHvPu = Unit.GMvHvPu, RMvHvPu = Unit.RMvHvPu, XMvHvPu = Unit.XMvHvPu, RLvTrPu = Unit.RLvTrPu, XLvTrPu = Unit.XLvTrPu, PPcc0Pu = Unit.PPcc0Pu, QPcc0Pu = Unit.QPcc0Pu, UPcc0Pu = Unit.UPcc0Pu) annotation(
    Placement(transformation(origin = {-66, 30}, extent = {{-10, -10}, {10, 10}})));
initial algorithm
  Unit.uPcc0Pu.re := pvVoltageSource_INIT.uPcc0Pu.re;
  Unit.uPcc0Pu.im := pvVoltageSource_INIT.uPcc0Pu.im;
  Unit.i0Pu.re := pvVoltageSource_INIT.i0Pu.re;
  Unit.i0Pu.im := pvVoltageSource_INIT.i0Pu.im;
  Unit.u0Pu.re := pvVoltageSource_INIT.u0Pu.re;
  Unit.u0Pu.im := pvVoltageSource_INIT.u0Pu.im;
  Unit.PF0 := pvVoltageSource_INIT.PF0;
  Unit.PInj0Pu := pvVoltageSource_INIT.PInj0Pu;
  Unit.QInj0Pu := pvVoltageSource_INIT.QInj0Pu;
  Unit.UInj0Pu := pvVoltageSource_INIT.UInj0Pu;
  Unit.UdInj0Pu := pvVoltageSource_INIT.UdInj0Pu;
  Unit.UqInj0Pu := pvVoltageSource_INIT.UqInj0Pu;
  Unit.uInj0Pu.re := pvVoltageSource_INIT.uInj0Pu.re;
  Unit.uInj0Pu.im := pvVoltageSource_INIT.uInj0Pu.im;
  Unit.iInj0Pu.re := pvVoltageSource_INIT.iInj0Pu.re;
  Unit.iInj0Pu.im := pvVoltageSource_INIT.iInj0Pu.im;
  Unit.PConv0Pu := pvVoltageSource_INIT.PConv0Pu;
  Unit.QConv0Pu := pvVoltageSource_INIT.QConv0Pu;
  Unit.UPhaseConv0 := pvVoltageSource_INIT.UPhaseConv0;
  Unit.UConv0Pu := pvVoltageSource_INIT.UConv0Pu;
  Unit.uConv0Pu.re := pvVoltageSource_INIT.uConv0Pu.re;
  Unit.uConv0Pu.im := pvVoltageSource_INIT.uConv0Pu.im;
  Unit.iConv0Pu.re := pvVoltageSource_INIT.iConv0Pu.re;
  Unit.iConv0Pu.im := pvVoltageSource_INIT.iConv0Pu.im;
  Unit.Id0Pu := pvVoltageSource_INIT.Id0Pu;
  Unit.Iq0Pu := pvVoltageSource_INIT.Iq0Pu;
  Unit.uSource0Pu.re := pvVoltageSource_INIT.uSource0Pu.re;
  Unit.uSource0Pu.im := pvVoltageSource_INIT.uSource0Pu.im;
equation
  Unit.injector.switchOffSignal1.value = false;
  Unit.injector.switchOffSignal2.value = false;
  Unit.injector.switchOffSignal3.value = false;
  connect(QRefPu.y, Unit.QRefPu) annotation(
    Line(points = {{79, 40}, {60, 40}, {60, -4}, {44, -4}}, color = {0, 0, 127}));
  connect(PRefPu.y, Unit.PRefPu) annotation(
    Line(points = {{79, 0}, {60.5, 0}, {60.5, -16}, {44, -16}}, color = {0, 0, 127}));
  connect(URefPu.y, Unit.URefPu) annotation(
    Line(points = {{79, 80}, {32, 80}, {32, 18}, {22, 18}}, color = {0, 0, 127}));
  connect(PFaRef.y, Unit.PFaRef) annotation(
    Line(points = {{79, -80}, {22, -80}, {22, -26}}, color = {0, 0, 127}));
  connect(const.y, Unit.PPccPu) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -10}, {0, -10}}, color = {0, 0, 127}));
  connect(const.y, Unit.QPccPu) annotation(
    Line(points = {{-38, -40}, {-20, -40}, {-20, -14}, {0, -14}}, color = {0, 0, 127}));
  connect(complexConst.y, Unit.uPccPu) annotation(
    Line(points = {{-38, -80}, {-10, -80}, {-10, -18}, {0, -18}}, color = {85, 170, 255}));
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

</html>"),
  Diagram(graphics = {Rectangle(origin = {25, 5}, extent = {{-1, 5}, {1, -5}})}));
end BaseUnitModel;