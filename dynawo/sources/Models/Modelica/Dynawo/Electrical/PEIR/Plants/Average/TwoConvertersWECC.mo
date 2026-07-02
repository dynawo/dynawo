within Dynawo.Electrical.PEIR.Plants.Average;

model TwoConvertersWECC
  /*
   * Author: Gaia Bergamaschi
   *
   * Two‑converter test — WECC PVVoltageSource4 models
   *
   * Purpose:
   *   Recreate the TwoConvertersStaticLine scenario, but replacing
   *   the internal average GFL models (GFLmodel / GFLmodel1) with
   *   WECC‑type PVVoltageSource4 blocks (PV1 / PV2).
   *
   * Topology (identical to TwoConvertersStaticLine):
   *   PV1 ── line ──► BUS ◄── line1 ── PV2
   *                     │
   *                   line2 ‖ line3  (line3 opens at t = 51.5 s)
   *                     │
   *                 InfiniteBus (voltage dip at t = 15.1 s)
   */

  // ════════════════════════════════════════════════════════════════
  // PV1 — generator (P0Pu = −5.010676 pu, injecting power)
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4 PV1(
    P0Pu          = -5.010676,
    Q0Pu          = -0.21,
    U0Pu          = 1.091230,
    SNom          = 1000,
    // Impedance = LC filter + LV transformer of GFLmodel (RfPu+RPuLV, LfPu+LPuLV)
    RSourcePu     = 0.003,
    XSourcePu     = 0.1,
    XMvHvPu       = 0.0025,
    RLvTrPu       = 2e-4,
    XLvTrPu       = 0.0025,

    // PLL — original RTE values
    KpPLL         = 0.6366197723675814,
    KiPLL         = 31.830988618379067,
    OmegaMaxPu    = 1.1,
    OmegaMinPu    = 0.9,

    // Measurement filters — original RTE values
    tFilterPC     = 1/300,
    tFilterGC     = 1/300,
    tpREPC        = 1/300,
    tpREEC        = 1/300,

    // Plant controller REPC‑A — original RTE values
    PPCLocal      = true,
    RefFlag       = true,
    FreqFlag      = true,
    VCompFlag     = false,
    VFrz          = 0.0,
    Kp            = 0.2,
    Ki            = 2,
    Kpg           = 0.2,
    Kig           = 2,
    Kc            = 0.417,
    tLag          = 1e-9,
    tFt           = 1e-10,
    tFv           = 1e-9,
    DDn           = 15.0,
    DUp           = 0,
    DbdPu         = 0.0001,
    EMaxPu        = 999.0,
    EMinPu        = -999.0,
    FDbd1Pu       = 0.005,
    FDbd2Pu       = 0.1,
    FEMaxPu       = 999.0,
    FEMinPu       = -999.0,
    PMaxREPCPu    = 2.0,
    PMaxREECPu    = 2.0,
    PMinREPCPu    = 0.0,
    PMinREECPu    = 0.0,
    QMaxREPCPu    = 0.3,
    QMaxREECPu    = 0.3,
    QMinREPCPu    = -0.3,
    QMinREECPu    = -0.3,

    // Electrical controller REEC‑B — original RTE values
    PfFlag        = false,
    QFlag         = true,
    VFlag         = false,
    PQFlag        = false,
    Kqp           = 1/30,
    Kqi           = 10,
    Kvp           = 1e-4,
    Kvi           = 1e-4,
    Kqv           = 0.0,
    IMaxPu        = 2,
    Iqh1Pu        = 1.2,
    Iql1Pu        = -1.2,
    DPMaxPu       = 999.0,
    DPMinPu       = -999.0,
    Dbd1Pu        = -0.1,
    Dbd2Pu        = 0.1,
    VDipPu        = 0.9,
    VUpPu         = 1.1,
    VMaxPu        = 1.1,
    VMinPu        = 0.9,
    VRef0Pu       = 1.0,
    VRef1Pu       = 0.0,
    tIq           = 1/300,
    tPord         = 1/300,
    tRv           = 1/300,

    // Converter REGC‑C — original RTE values
    RrpwrPu       = 10.0,
    tE            = 1/300,
    IqrMaxPu      = 20.0,
    IqrMinPu      = -20.0,
    Kip           = 0.48,
    Kii           = 4.8,
    RateFlag      = false,
    ConverterLVControl = true,

    // Initial values (to be filled by PVVoltageSource_INIT)
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
    UPhaseConv0(fixed = false),
    PF0(fixed = false),
    PInj0Pu(fixed = false),
    QConv0Pu(fixed = false),
    QInj0Pu(fixed = false),
    UInj0Pu(fixed = false),
    UConv0Pu(fixed = false),
    UdInj0Pu(fixed = false),
    UqInj0Pu(fixed = false),
    uPcc0Pu(im(fixed = false), re(fixed = false))
  ) annotation(Placement(transformation(origin = {-70, 0}, extent = {{-20,-20},{20,20}})));

  // ════════════════════════════════════════════════════════════════
  // PV2 — active load (P0Pu = +4.989324 pu, consuming power)
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4 PV2(
    P0Pu          = 4.989324,
    Q0Pu          = -0.21,
    U0Pu          = 1.086638,
    SNom          = 1000,
    // Impedance = LC filter + LV transformer of GFLmodel (RfPu+RPuLV, LfPu+LPuLV)
    RSourcePu     = 0.003,
    XSourcePu     = 0.1,
    XMvHvPu       = 0.0025,
    RLvTrPu       = 2e-4,
    XLvTrPu       = 0.0025,

    // PLL — original RTE values
    KpPLL         = 0.6366197723675814,
    KiPLL         = 31.830988618379067,
    OmegaMaxPu    = 1.1,
    OmegaMinPu    = 0.9,

    // Measurement filters — original RTE values
    tFilterPC     = 1/300,
    tFilterGC     = 1/300,
    tpREPC        = 1/300,
    tpREEC        = 1/300,

    // Plant controller REPC‑A — original RTE values
    PPCLocal      = true,
    RefFlag       = true,
    FreqFlag      = true,
    VCompFlag     = false,
    VFrz          = 0.0,
    Kp            = 0.2,
    Ki            = 2,
    Kpg           = 0.2,
    Kig           = 2,
    Kc            = 0.417,
    tLag          = 1e-9,
    tFt           = 1e-10,
    tFv           = 1e-9,
    DDn           = 15.0,
    DUp           = 0,
    DbdPu         = 0.0001,
    EMaxPu        = 999.0,
    EMinPu        = -999.0,
    FDbd1Pu       = 0.005,
    FDbd2Pu       = 0.1,
    FEMaxPu       = 999.0,
    FEMinPu       = -999.0,
    PMaxREPCPu    = 0.0,
    PMaxREECPu    = 0.0,
    PMinREPCPu    = -2.0,
    PMinREECPu    = -2.0,
    QMaxREPCPu    = 0.3,
    QMaxREECPu    = 0.3,
    QMinREPCPu    = -0.3,
    QMinREECPu    = -0.3,

    // Electrical controller REEC‑B — original RTE values
    PfFlag        = false,
    QFlag         = true,
    VFlag         = false,
    PQFlag        = false,
    Kqp           = 1/30,
    Kqi           = 10,
    Kvp           = 1e-4,
    Kvi           = 1e-4,
    Kqv           = 0.0,
    IMaxPu        = 2,
    Iqh1Pu        = 1.2,
    Iql1Pu        = -1.2,
    DPMaxPu       = 999.0,
    DPMinPu       = -999.0,
    Dbd1Pu        = -0.1,
    Dbd2Pu        = 0.1,
    VDipPu        = 0.9,
    VUpPu         = 1.1,
    VMaxPu        = 1.1,
    VMinPu        = 0.9,
    VRef0Pu       = 1.0,
    VRef1Pu       = 0.0,
    tIq           = 1/300,
    tPord         = 1/300,
    tRv           = 1/300,

    // Converter REGC‑C — original RTE values
    RrpwrPu       = 10.0,
    tE            = 1/300,
    IqrMaxPu      = 20.0,
    IqrMinPu      = -20.0,
    Kip           = 0.48,
    Kii           = 4.8,
    RateFlag      = false,
    ConverterLVControl = true,

    // Initial values (to be filled by PVVoltageSource_INIT)
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
    UPhaseConv0(fixed = false),
    PF0(fixed = false),
    PInj0Pu(fixed = false),
    QConv0Pu(fixed = false),
    QInj0Pu(fixed = false),
    UInj0Pu(fixed = false),
    UConv0Pu(fixed = false),
    UdInj0Pu(fixed = false),
    UqInj0Pu(fixed = false),
    uPcc0Pu(im(fixed = false), re(fixed = false))
  ) annotation(Placement(transformation(origin = {70, 0}, extent = {{-20,-20},{20,20}}, rotation = 180)));

  // ════════════════════════════════════════════════════════════════
  // Network — identical to TwoConvertersStaticLine
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Lines.Line line(
    RPu = 0.00144, XPu = 0.0144, BPu = 0, GPu = 0
  ) annotation(Placement(transformation(origin = {-28, 0}, extent = {{-10,-10},{10,10}})));

  Dynawo.Electrical.Lines.Line line1(
    RPu = 0.00144, XPu = 0.0144, BPu = 0, GPu = 0
  ) annotation(Placement(transformation(origin = {30, 0}, extent = {{-10,-10},{10,10}})));

  Dynawo.Electrical.Lines.Line line2(
    RPu = 0.01, XPu = 0.1, BPu = 0, GPu = 1e-4
  ) annotation(Placement(transformation(origin = {0, -30}, extent = {{-10,-10},{10,10}}, rotation = -90)));

  Dynawo.Electrical.Lines.Line line3(
    RPu = 0.0077775, XPu = 0.077775, BPu = 0, GPu = 0
  ) annotation(Placement(transformation(origin = {-36, -30}, extent = {{-10,-10},{10,10}}, rotation = -90)));

  Dynawo.Electrical.Buses.Bus bus annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-10,-10},{10,10}})));

  // ════════════════════════════════════════════════════════════════
  // InfiniteBus — aligned with TwoConvertersStaticLine
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(
    U0Pu           = 1.1,
    UPhase         = -0.001082,
    omega0Pu       = 1.0,
    UEvtPu         = 0.5,
    tUEvtStart     = 15.1,
    tUEvtEnd       = 15.1,
    omegaEvtPu     = 1.0,
    tOmegaEvtStart = 1e6,
    tOmegaEvtEnd   = 1e6
  ) annotation(Placement(transformation(origin = {0, -94}, extent = {{-10,-10},{10,10}})));

  // ════════════════════════════════════════════════════════════════
  // Setpoints for PV1
  // ════════════════════════════════════════════════════════════════
  // Active power reference: step from 0.5 pu to 0.6 pu at t = 50 s
  Modelica.Blocks.Sources.Step PRefPu1(
    offset    = 0.5,
    height    = 0.1,
    startTime = 50.0
  ) annotation(Placement(transformation(origin = {-120, 30}, extent = {{-10,-10},{10,10}})));

  // Reactive power reference: constant initial Q control value
  Modelica.Blocks.Sources.Constant QRefPu1(k = PV1.QControl0Pu) annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-10,-10},{10,10}})));

  // Voltage reference: initial URef from REPC‑A
  Modelica.Blocks.Sources.Constant URefPu1(k = PV1.wecc_repc.URef0Pu) annotation(
    Placement(transformation(origin = {-70, -48}, extent = {{-10,-10},{10,10}}, rotation = 90)));

  // Power factor angle reference: from initial PF0
  Modelica.Blocks.Sources.Constant PFaRef1(k = acos(PV1.PF0)) annotation(
    Placement(transformation(origin = {-70, 46}, extent = {{-10,-10},{10,10}}, rotation = -90)));

  // Frequency reference (per unit)
  Modelica.Blocks.Sources.Constant omegaRefPu1(k = 1.0) annotation(
    Placement(transformation(origin = {-120, -32}, extent = {{-10,-10},{10,10}})));

  // P/Q at PCC used for REPC‑A feedback (here zeroed)
  Modelica.Blocks.Sources.Constant PPcc1(k = 0) annotation(
    Placement(transformation(origin = {0, 20}, extent = {{-10,-10},{10,10}}, rotation = 180)));

  // PCC voltage (complex) for REPC‑A — here set to 1∠0
  Modelica.ComplexBlocks.Sources.ComplexConstant uPcc1(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {-38, 42}, extent = {{-10,-10},{10,10}}, rotation = -90)));

  // ════════════════════════════════════════════════════════════════
  // Setpoints for PV2
  // ════════════════════════════════════════════════════════════════
  // Active power reference: step from −0.5 pu to −0.4 pu at t = 50 s
  Modelica.Blocks.Sources.Step PRefPu2(
    offset    = -0.5,
    height    = 0.1,
    startTime = 50.0
  ) annotation(Placement(transformation(origin = {118, -40}, extent = {{10,-10},{-10,10}})));

  // Reactive power reference: constant initial Q control value
  Modelica.Blocks.Sources.Constant QRefPu2(k = PV2.QControl0Pu) annotation(
    Placement(transformation(origin = {118, 0}, extent = {{10,-10},{-10,10}})));

  // Voltage reference: initial URef from REPC‑A
  Modelica.Blocks.Sources.Constant URefPu2(k = PV2.wecc_repc.URef0Pu) annotation(
    Placement(transformation(origin = {70, 50}, extent = {{10,-10},{-10,10}}, rotation = 90)));

  // Power factor angle reference: from initial PF0
  Modelica.Blocks.Sources.Constant PFaRef2(k = acos(PV2.PF0)) annotation(
    Placement(transformation(origin = {70, -56}, extent = {{10,-10},{-10,10}}, rotation = -90)));

  // Frequency reference (per unit)
  Modelica.Blocks.Sources.Constant omegaRefPu2(k = 1.0) annotation(
    Placement(transformation(origin = {116, 40}, extent = {{10,-10},{-10,10}})));

  // P/Q at PCC used for REPC‑A feedback (here zeroed)
  Modelica.Blocks.Sources.Constant PPcc2(k = 0) annotation(
    Placement(transformation(origin = {18, -18}, extent = {{10,-10},{-10,10}}, rotation = 180)));

  // PCC voltage (complex) for REPC‑A — here set to 1∠0
  Modelica.ComplexBlocks.Sources.ComplexConstant uPcc2(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {30, -50}, extent = {{10,-10},{-10,10}}, rotation = -90)));

  // ════════════════════════════════════════════════════════════════
  // Initialization blocks for PV1 and PV2 (steady‑state matching)
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource_INIT pvInit1(
    ConverterLVControl = PV1.ConverterLVControl,
    P0Pu        = PV1.P0Pu,
    PPCLocal    = PV1.PPCLocal,
    Q0Pu        = PV1.Q0Pu,
    RSourcePu   = PV1.RSourcePu,
    SNom        = PV1.SNom,
    U0Pu        = PV1.U0Pu,
    UPhase0     = 0.063246,
    XSourcePu   = PV1.XSourcePu,
    BMvHvPu     = PV1.BMvHvPu,
    GMvHvPu     = PV1.GMvHvPu,
    RMvHvPu     = PV1.RMvHvPu,
    XMvHvPu     = PV1.XMvHvPu,
    RLvTrPu     = PV1.RLvTrPu,
    XLvTrPu     = PV1.XLvTrPu,
    PPcc0Pu     = PV1.PPcc0Pu,
    QPcc0Pu     = PV1.QPcc0Pu,
    UPcc0Pu     = PV1.UPcc0Pu
  ) annotation(Placement(transformation(origin = {-60, 80}, extent = {{-10,-10},{10,10}})));

  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource_INIT pvInit2(
    ConverterLVControl = PV2.ConverterLVControl,
    P0Pu        = PV2.P0Pu,
    PPCLocal    = PV2.PPCLocal,
    Q0Pu        = PV2.Q0Pu,
    RSourcePu   = PV2.RSourcePu,
    SNom        = PV2.SNom,
    U0Pu        = PV2.U0Pu,
    UPhase0     = -0.063421,
    XSourcePu   = PV2.XSourcePu,
    BMvHvPu     = PV2.BMvHvPu,
    GMvHvPu     = PV2.GMvHvPu,
    RMvHvPu     = PV2.RMvHvPu,
    XMvHvPu     = PV2.XMvHvPu,
    RLvTrPu     = PV2.RLvTrPu,
    XLvTrPu     = PV2.XLvTrPu,
    PPcc0Pu     = PV2.PPcc0Pu,
    QPcc0Pu     = PV2.QPcc0Pu,
    UPcc0Pu     = PV2.UPcc0Pu
  ) annotation(Placement(transformation(origin = {60, 80}, extent = {{-10,-10},{10,10}})));

  // Boolean table for line3 switching (connected through IdealSwitch)
  // true from t = 0, then toggles at t = 51.5 s
  Modelica.Blocks.Sources.BooleanTable booleanTable(table = {0, 51.5}, startValue = true) annotation(
    Placement(transformation(origin = {-48, -92}, extent = {{-10, -10}, {10, 10}})));

  // Ideal switch used to open/close line3 w.r.t. line2
  IdealSwitch idealSwitch annotation(
    Placement(transformation(origin = {-18, -20}, extent = {{-10, -10}, {10, 10}})));

initial algorithm
  // ── PV1 initialization: copy results from pvInit1 into PV1 ──────
  PV1.uPcc0Pu.re    := pvInit1.uPcc0Pu.re;
  PV1.uPcc0Pu.im    := pvInit1.uPcc0Pu.im;
  PV1.i0Pu.re       := pvInit1.i0Pu.re;
  PV1.i0Pu.im       := pvInit1.i0Pu.im;
  PV1.u0Pu.re       := pvInit1.u0Pu.re;
  PV1.u0Pu.im       := pvInit1.u0Pu.im;
  PV1.PF0           := pvInit1.PF0;
  PV1.PInj0Pu       := pvInit1.PInj0Pu;
  PV1.QInj0Pu       := pvInit1.QInj0Pu;
  PV1.UInj0Pu       := pvInit1.UInj0Pu;
  PV1.UdInj0Pu      := pvInit1.UdInj0Pu;
  PV1.UqInj0Pu      := pvInit1.UqInj0Pu;
  PV1.uInj0Pu.re    := pvInit1.uInj0Pu.re;
  PV1.uInj0Pu.im    := pvInit1.uInj0Pu.im;
  PV1.iInj0Pu.re    := pvInit1.iInj0Pu.re;
  PV1.iInj0Pu.im    := pvInit1.iInj0Pu.im;
  PV1.PConv0Pu      := pvInit1.PConv0Pu;
  PV1.QConv0Pu      := pvInit1.QConv0Pu;
  PV1.UPhaseConv0   := pvInit1.UPhaseConv0;
  PV1.UConv0Pu      := pvInit1.UConv0Pu;
  PV1.uConv0Pu.re   := pvInit1.uConv0Pu.re;
  PV1.uConv0Pu.im   := pvInit1.uConv0Pu.im;
  PV1.iConv0Pu.re   := pvInit1.iConv0Pu.re;
  PV1.iConv0Pu.im   := pvInit1.iConv0Pu.im;
  PV1.Id0Pu         := pvInit1.Id0Pu;
  PV1.Iq0Pu         := pvInit1.Iq0Pu;
  PV1.uSource0Pu.re := pvInit1.uSource0Pu.re;
  PV1.uSource0Pu.im := pvInit1.uSource0Pu.im;
  PV1.s0Pu.re       := pvInit1.s0Pu.re;
  PV1.s0Pu.im       := pvInit1.s0Pu.im;
  PV1.iSource0Pu.re := pvInit1.iSource0Pu.re;
  PV1.iSource0Pu.im := pvInit1.iSource0Pu.im;
  PV1.iConv0Pu.re   := pvInit1.iConv0Pu.re;
  PV1.iConv0Pu.im   := pvInit1.iConv0Pu.im;

  // ── PV2 initialization: copy results from pvInit2 into PV2 ──────
  PV2.uPcc0Pu.re    := pvInit2.uPcc0Pu.re;
  PV2.uPcc0Pu.im    := pvInit2.uPcc0Pu.im;
  PV2.i0Pu.re       := pvInit2.i0Pu.re;
  PV2.i0Pu.im       := pvInit2.i0Pu.im;
  PV2.u0Pu.re       := pvInit2.u0Pu.re;
  PV2.u0Pu.im       := pvInit2.u0Pu.im;
  PV2.PF0           := pvInit2.PF0;
  PV2.PInj0Pu       := pvInit2.PInj0Pu;
  PV2.QInj0Pu       := pvInit2.QInj0Pu;
  PV2.UInj0Pu       := pvInit2.UInj0Pu;
  PV2.UdInj0Pu      := pvInit2.UdInj0Pu;
  PV2.UqInj0Pu      := pvInit2.UqInj0Pu;
  PV2.uInj0Pu.re    := pvInit2.uInj0Pu.re;
  PV2.uInj0Pu.im    := pvInit2.uInj0Pu.im;
  PV2.iInj0Pu.re    := pvInit2.iInj0Pu.re;
  PV2.iInj0Pu.im    := pvInit2.iInj0Pu.im;
  PV2.PConv0Pu      := pvInit2.PConv0Pu;
  PV2.QConv0Pu      := pvInit2.QConv0Pu;
  PV2.UPhaseConv0   := pvInit2.UPhaseConv0;
  PV2.UConv0Pu      := pvInit2.UConv0Pu;
  PV2.uConv0Pu.re   := pvInit2.uConv0Pu.re;
  PV2.uConv0Pu.im   := pvInit2.uConv0Pu.im;
  PV2.iConv0Pu.re   := pvInit2.iConv0Pu.re;
  PV2.iConv0Pu.im   := pvInit2.iConv0Pu.im;
  PV2.Id0Pu         := pvInit2.Id0Pu;
  PV2.Iq0Pu         := pvInit2.Iq0Pu;
  PV2.uSource0Pu.re := pvInit2.uSource0Pu.re;
  PV2.uSource0Pu.im := pvInit2.uSource0Pu.im;
  PV2.s0Pu.re       := pvInit2.s0Pu.re;
  PV2.s0Pu.im       := pvInit2.s0Pu.im;
  PV2.iSource0Pu.re := pvInit2.iSource0Pu.re;
  PV2.iSource0Pu.im := pvInit2.iSource0Pu.im;
  PV2.iConv0Pu.re   := pvInit2.iConv0Pu.re;
  PV2.iConv0Pu.im   := pvInit2.iConv0Pu.im;

equation
  // Lines and converters kept in service (switches forced closed),
  // except line3, which is controlled via IdealSwitch below
  line.switchOffSignal1  = false;
  line.switchOffSignal2  = false;
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;
  line2.switchOffSignal1 = false;
  line2.switchOffSignal2 = false;
  line3.switchOffSignal1 = false;
  line3.switchOffSignal2 = false;
  PV1.injector.switchOffSignal1 = false;
  PV1.injector.switchOffSignal2 = false;
  PV1.injector.switchOffSignal3 = false;
  PV2.injector.switchOffSignal1 = false;
  PV2.injector.switchOffSignal2 = false;
  PV2.injector.switchOffSignal3 = false;

  // Network connections
  connect(infiniteBusWithVariations.terminal, line2.terminal2) annotation(
    Line(points = {{0, -94}, {0, -40}}, color = {0, 0, 255}));
  connect(PV1.terminal, line.terminal1) annotation(
    Line(points = {{-48, 0}, {-38, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, bus.terminal) annotation(
    Line(points = {{-18, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, bus.terminal) annotation(
    Line(points = {{0, -20}, {0, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, bus.terminal) annotation(
    Line(points = {{20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, PV2.terminal) annotation(
    Line(points = {{40, 0}, {48, 0}}, color = {0, 0, 255}));
  connect(line3.terminal2, line2.terminal2) annotation(
    Line(points = {{-36, -40}, {0, -40}}, color = {0, 0, 255}));

  // Setpoint connections for PV1
  connect(PV1.PRefPu, PRefPu1.y) annotation(
    Line(points = {{-92, 12}, {-108, 12}, {-108, 30}}, color = {0, 0, 127}));
  connect(PV1.QRefPu, QRefPu1.y) annotation(
    Line(points = {{-92, 0}, {-108, 0}}, color = {0, 0, 127}));
  connect(omegaRefPu1.y, PV1.omegaRefPu) annotation(
    Line(points = {{-108, -32}, {-92, -32}, {-92, -12}}, color = {0, 0, 127}));
  connect(PFaRef1.y, PV1.PFaRef) annotation(
    Line(points = {{-70, 35}, {-70, 22}}, color = {0, 0, 127}));
  connect(URefPu1.y, PV1.URefPu) annotation(
    Line(points = {{-70, -36}, {-70, -22}}, color = {0, 0, 127}));
  connect(PV1.uPccPu, uPcc1.y) annotation(
    Line(points = {{-48, 14}, {-38, 14}, {-38, 31}}, color = {85, 170, 255}));
  connect(PV1.QPccPu, PPcc1.y) annotation(
    Line(points = {{-48, 10}, {-29.5, 10}, {-29.5, 20}, {-11, 20}}, color = {0, 0, 127}));
  connect(PV1.PPccPu, PPcc1.y) annotation(
    Line(points = {{-48, 6}, {-30.5, 6}, {-30.5, 20}, {-11, 20}}, color = {0, 0, 127}));

  // Setpoint connections for PV2
  connect(PV2.URefPu, URefPu2.y) annotation(
    Line(points = {{70, 22}, {70, 40}}, color = {0, 0, 127}));
  connect(PPcc2.y, PV2.PPccPu) annotation(
    Line(points = {{30, -18}, {34, -18}, {34, -8}, {48, -8}, {48, -6}}, color = {0, 0, 127}));
  connect(PPcc2.y, PV2.QPccPu) annotation(
    Line(points = {{30, -18}, {34, -18}, {34, -10}, {48, -10}}, color = {0, 0, 127}));
  connect(PV2.uPccPu, uPcc2.y) annotation(
    Line(points = {{48, -14}, {39, -14}, {39, -38}, {30, -38}}, color = {85, 170, 255}));
  connect(PFaRef2.y, PV2.PFaRef) annotation(
    Line(points = {{70, -45}, {70, -22}}, color = {0, 0, 127}));
  connect(PRefPu2.y, PV2.PRefPu) annotation(
    Line(points = {{108, -40}, {92, -40}, {92, -12}}, color = {0, 0, 127}));
  connect(PV2.omegaRefPu, omegaRefPu2.y) annotation(
    Line(points = {{92, 12}, {105, 12}, {105, 40}}, color = {0, 0, 127}));
  connect(PV2.QRefPu, QRefPu2.y) annotation(
    Line(points = {{92, 0}, {108, 0}}, color = {0, 0, 127}));

  // Line3 switching via IdealSwitch controlled by BooleanTable
  connect(idealSwitch.terminal1, line3.terminal1) annotation(
    Line(points = {{-28, -16}, {-36, -16}, {-36, -20}}, color = {0, 0, 255}));
  connect(line2.terminal1, idealSwitch.terminal2) annotation(
    Line(points = {{0, -20}, {-6, -20}, {-6, -16}, {-8, -16}}, color = {0, 0, 255}));
  connect(booleanTable.y, idealSwitch.control) annotation(
    Line(points = {{-36, -92}, {-20, -92}, {-20, -8}, {-18, -8}}, color = {255, 0, 255}));

  annotation(
    experiment(
      StartTime = 0,
      StopTime  = 70,
      Tolerance = 1e-5,
      Interval  = 0.005),
    preferredView = "diagram",
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica --allowNonStandardModelica=",
    __OpenModelica_simulationFlags(
      lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS,LOG_LS",
      s  = "ida",
      nls = "kinsol",
      noHomotopyOnFirstTry = "()",
      initialStepSize      = "0.00001",
      maxStepSize          = "0.0001"),
    Documentation(info = "<html><body>
      <h3>TwoConvertersWECC — hybrid configuration</h3>
      <p>Physical impedance mapped from GFLmodel (RSourcePu=0.004, XSourcePu=0.125).</p>
      <p>Control parameters: original RTE values (WECC structure != GFLmodel).</p>
      <ul>
        <li>KpPLL=0.32, KiPLL=8.0 (RTE)</li>
        <li>Kip=3.0, Kii=20.0 (RTE)</li>
        <li>Kqp=1.0, Kqi=0.5, Kvp=1.0, Kvi=1.0 (RTE)</li>
        <li>Kpg=0.05, Kig=2.36 (RTE)</li>
        <li>tE=0.005, tFilterPC=0.04, tFilterGC=0.02, tP=0.04 (RTE)</li>
        <li>IMaxPu=1.3, Iqh1/Iql1=±1.2 (physically meaningful)</li>
        <li>line2 XPu=0.1, InfiniteBus U0=1.1 / UPhase=-0.001082 aligned</li>
        <li>line3: opening on both sides at t=51.5 s (fix singular Jacobian)</li>
        <li>Tolerance=1e-5, maxStepSize=0.0005</li>
      </ul>
    </body></html>"),
  Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}));

end TwoConvertersWECC;
