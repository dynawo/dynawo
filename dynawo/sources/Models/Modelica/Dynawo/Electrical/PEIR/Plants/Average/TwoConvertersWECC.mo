within Dynawo.Electrical.PEIR.Plants.Average;

model TwoConvertersWECC
  /*
   * Author: Gaia Bergamaschi
   * Two WECC PVVoltageSource4 converters connected back-to-back through a weak grid.
   *
   * Topology:
   *   PV1 ──line──► BUS ◄──line1── PV2
   *                   │
   *                 line2
   *                   │
   *               InfiniteBus (slack: U=1.0 pu, θ=0 rad)
   *
   * Operating point:
   *   PV1: P = +0.5 pu (inietta), Q = +0.021 pu
   *   PV2: P = -0.5 pu (assorbe), Q = +0.021 pu
   *
   * SCR ≈ 2.0  (griglia debole, Xg = 0.5 pu)
   *
   * Parametri controllo: valori ufficiali RTE dall'esempio PVVoltageSource4
   * con PMinPu=-1.0 per PV2 per permettere assorbimento
   */

  // ════════════════════════════════════════════════════════════════
  // PV1 — generatore (P=+0.5 pu, inietta)
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4 PV1(
    // ── Operating point ──────────────────────────────────────────
    P0Pu          = -0.5,
    Q0Pu          = -0.021,
    U0Pu          = 1.00791,
    SNom          = 100,
    // ── Source impedance ─────────────────────────────────────────
    RSourcePu     = 0.0,
    XSourcePu     = 0.1,
    // ── Transformer MV/HV ────────────────────────────────────────
    XMvHvPu       = 0.15,
    RLvTrPu       = 0.0,
    XLvTrPu       = 0.0,
    // ── PLL — valori ufficiali RTE ────────────────────────────────
    KpPLL         = 0.32,
    KiPLL         = 8,
    OmegaMaxPu    = 1.5,
    OmegaMinPu    = 0.5,
    // ── Measurement filters ──────────────────────────────────────
    tFilterPC     = 0.04,
    tFilterGC     = 0.02,
    tP            = 0.04,
    // ── Plant controller REPC-A — valori ufficiali RTE ───────────
    PPCLocal      = true,
    RefFlag       = true,
    FreqFlag      = true,
    VCompFlag     = false,
    VFrz          = 0.0,
    Kp            = 0.1,
    Ki            = 1.5,
    Kpg           = 0.05,
    Kig           = 2.36,
    Kc            = 0.0,
    tLag          = 0.1,
    tFt           = 1e-10,
    tFv           = 0.1,
    DDn           = 20.0,
    DUp           = 0.001,
    DbdPu         = 0.01,
    EMaxPu        = 999.0,
    EMinPu        = -999.0,
    FDbd1Pu       = 0.004,
    FDbd2Pu       = 1.0,
    FEMaxPu       = 999.0,
    FEMinPu       = -999.0,
    PMaxPu        = 1.0,
    PMinPu        = 0.0,
    QMaxPu        = 0.4,
    QMinPu        = -0.4,
    // ── Electrical controller REEC-B — valori ufficiali RTE ──────
    PfFlag        = false,
    QFlag         = true,
    VFlag         = true,
    PQFlag        = false,
    Kqp           = 1.0,
    Kqi           = 0.5,
    Kvp           = 1.0,
    Kvi           = 1.0,
    Kqv           = 2.0,
    IMaxPu        = 1.05,
    Iqh1Pu        = 2.0,
    Iql1Pu        = -2.0,
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
    tIq           = 0.02,
    tPord         = 0.02,
    tRv           = 0.02,
    RrpwrPu       = 10.0,
    // ── Converter REGC-C — valori ufficiali RTE ──────────────────
    tE            = 0.005,
    IqrMaxPu      = 20.0,
    IqrMinPu      = -20.0,
    Kip           = 3.0,
    Kii           = 20.0,
    RateFlag      = false,
    ConverterLVControl = true,
    // ── Initial values ───────────────────────────────────────────
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
  // PV2 — carico attivo (P=-0.5 pu, assorbe)
  // Identico a PV1 tranne: P0Pu=+0.5, U0Pu, PMinPu=-1.0
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource4 PV2(
    // ── Operating point ──────────────────────────────────────────
    P0Pu          = 0.5,        // positivo = assorbe in conv. generatore
    Q0Pu          = -0.021,
    U0Pu          = 1.00555,
    SNom          = 100,
    // ── Source impedance ─────────────────────────────────────────
    RSourcePu     = 0.0,
    XSourcePu     = 0.1,
    // ── Transformer MV/HV ────────────────────────────────────────
    XMvHvPu       = 0.15,
    RLvTrPu       = 0.0,
    XLvTrPu       = 0.0,
    // ── PLL ──────────────────────────────────────────────────────
    KpPLL         = 0.32,
    KiPLL         = 8.0,
    OmegaMaxPu    = 1.5,
    OmegaMinPu    = 0.5,
    // ── Measurement filters ──────────────────────────────────────
    tFilterPC     = 0.04,
    tFilterGC     = 0.02,
    tP            = 0.04,
    // ── Plant controller REPC-A ──────────────────────────────────
    PPCLocal      = true,
    RefFlag       = true,
    FreqFlag      = true,
    VCompFlag     = false,
    VFrz          = 0.0,
    Kp            = 0.1,
    Ki            = 1.5,
    Kpg           = 0.05,
    Kig           = 2.36,
    Kc            = 0.0,
    tLag          = 0.1,
    tFt           = 1e-10,
    tFv           = 0.1,
    DDn           = 20.0,
    DUp           = 0.001,
    DbdPu         = 0.01,
    EMaxPu        = 999.0,
    EMinPu        = -999.0,
    FDbd1Pu       = 0.004,
    FDbd2Pu       = 1.0,
    FEMaxPu       = 999.0,
    FEMinPu       = -999.0,
    PMaxPu        = 1.0,
    PMinPu        = -1.0,      // permette assorbimento
    QMaxPu        = 0.4,
    QMinPu        = -0.4,
    // ── Electrical controller REEC-B ─────────────────────────────
    PfFlag        = false,
    QFlag         = true,
    VFlag         = true,
    PQFlag        = false,
    Kqp           = 1.0,
    Kqi           = 0.5,
    Kvp           = 1.0,
    Kvi           = 1.0,
    Kqv           = 2.0,
    IMaxPu        = 1.05,
    Iqh1Pu        = 2.0,
    Iql1Pu        = -2.0,
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
    tIq           = 0.02,
    tPord         = 0.02,
    tRv           = 0.02,
    RrpwrPu       = 10.0,
    // ── Converter REGC-C ─────────────────────────────────────────
    tE            = 0.005,
    IqrMaxPu      = 20.0,
    IqrMinPu      = -20.0,
    Kip           = 3.0,
    Kii           = 20.0,
    RateFlag      = false,
    ConverterLVControl = true,
    // ── Initial values ───────────────────────────────────────────
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
  // Linee
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Lines.Line line(
    RPu = 0.002375,
    XPu = 0.03375,
    BPu = 0,
    GPu = 0
  ) annotation(Placement(transformation(origin = {-28, 0}, extent = {{-10,-10},{10,10}})));

  Dynawo.Electrical.Lines.Line line1(
    RPu = 0.002375,
    XPu = 0.03375,
    BPu = 0,
    GPu = 0
  ) annotation(Placement(transformation(origin = {30, 0}, extent = {{-10,-10},{10,10}})));

  Dynawo.Electrical.Lines.Line line2(
    RPu = 0.05,
    XPu = 0.5,
    BPu = 0,
    GPu = 0
  ) annotation(Placement(transformation(origin = {0, -30}, extent = {{-10,-10},{10,10}}, rotation = -90)));

  Dynawo.Electrical.Buses.Bus bus annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-10,-10},{10,10}})));

  // ════════════════════════════════════════════════════════════════
  // InfiniteBus
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(
    U0Pu           = 1.0,
    UPhase         = 0.0,
    omega0Pu       = 1.0,
    UEvtPu         = 0.7,
    tUEvtStart     = 1e6,
    tUEvtEnd       = 1e6,
    omegaEvtPu     = 1.0,
    tOmegaEvtStart = 1e6,
    tOmegaEvtEnd   = 1e6
  ) annotation(Placement(transformation(origin = {0, -94}, extent = {{-10,-10},{10,10}})));

  // ════════════════════════════════════════════════════════════════
  // Setpoint PV1 — step su P a t=5s
  // Con PPCLocal=true e FreqFlag=true, PRefPu è il riferimento P
  // del loop di frequenza del REPC-A
  // ════════════════════════════════════════════════════════════════
  Modelica.Blocks.Sources.Step PRefPu1(
    offset    = PV1.PControl0Pu,
    height    = 0.2,           // riduce iniezione di 0.2 pu
    startTime = 5.0
  ) annotation(Placement(transformation(origin = {-120, 30}, extent = {{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Constant QRefPu1(k = PV1.QControl0Pu) annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Constant URefPu1(k = PV1.wecc_repc.URef0Pu) annotation(
    Placement(transformation(origin = {-70, -48}, extent = {{-10,-10},{10,10}}, rotation = 90)));

  Modelica.Blocks.Sources.Constant PFaRef1(k = acos(PV1.PF0)) annotation(
    Placement(transformation(origin = {-70, 46}, extent = {{-10,-10},{10,10}}, rotation = -90)));

  Modelica.Blocks.Sources.Constant omegaRefPu1(k = 1.0) annotation(
    Placement(transformation(origin = {-120, -32}, extent = {{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Constant PPcc1(k = 0) annotation(
    Placement(transformation(origin = {-14, 18}, extent = {{-10,-10},{10,10}}, rotation = 180)));
  Modelica.ComplexBlocks.Sources.ComplexConstant uPcc1(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {-38, 42}, extent = {{-10,-10},{10,10}}, rotation = -90)));

  // ════════════════════════════════════════════════════════════════
  // Setpoint PV2 — costante
  // ════════════════════════════════════════════════════════════════
  Modelica.Blocks.Sources.Constant PRefPu2(k = PV2.PControl0Pu) annotation(
    Placement(transformation(origin = {118, -40}, extent = {{10,-10},{-10,10}})));

  Modelica.Blocks.Sources.Constant QRefPu2(k = PV2.QControl0Pu) annotation(
    Placement(transformation(origin = {118, 0}, extent = {{10,-10},{-10,10}})));

  Modelica.Blocks.Sources.Constant URefPu2(k = PV2.wecc_repc.URef0Pu) annotation(
    Placement(transformation(origin = {70, 50}, extent = {{10,-10},{-10,10}}, rotation = 90)));

  Modelica.Blocks.Sources.Constant PFaRef2(k = acos(PV2.PF0)) annotation(
    Placement(transformation(origin = {70, -56}, extent = {{10,-10},{-10,10}}, rotation = -90)));

  Modelica.Blocks.Sources.Constant omegaRefPu2(k = 1.0) annotation(
    Placement(transformation(origin = {116, 40}, extent = {{10,-10},{-10,10}})));

  Modelica.Blocks.Sources.Constant PPcc2(k = 0) annotation(
    Placement(transformation(origin = {18, -18}, extent = {{10,-10},{-10,10}}, rotation = 180)));
  Modelica.ComplexBlocks.Sources.ComplexConstant uPcc2(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {30, -50}, extent = {{10,-10},{-10,10}}, rotation = -90)));

  // ════════════════════════════════════════════════════════════════
  // Inizializzazione PV1
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource_INIT pvInit1(
    ConverterLVControl = PV1.ConverterLVControl,
    P0Pu        = PV1.P0Pu,
    PPCLocal    = PV1.PPCLocal,
    Q0Pu        = PV1.Q0Pu,
    RSourcePu   = PV1.RSourcePu,
    SNom        = PV1.SNom,
    U0Pu        = PV1.U0Pu,
    UPhase0     = 0.01512,
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

  // ════════════════════════════════════════════════════════════════
  // Inizializzazione PV2
  // ════════════════════════════════════════════════════════════════
  Dynawo.Electrical.Photovoltaics.WECC.PVVoltageSource_INIT pvInit2(
    ConverterLVControl = PV2.ConverterLVControl,
    P0Pu        = PV2.P0Pu,
    PPCLocal    = PV2.PPCLocal,
    Q0Pu        = PV2.Q0Pu,
    RSourcePu   = PV2.RSourcePu,
    SNom        = PV2.SNom,
    U0Pu        = PV2.U0Pu,
    UPhase0     = -0.01819,
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

initial algorithm
  // ── PV1 init ──────────────────────────────────────────────────
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

  // ── PV2 init ──────────────────────────────────────────────────
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
  // ── Switch-off disabilitati ────────────────────────────────────
  line.switchOffSignal1.value  = false;
  line.switchOffSignal2.value  = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  PV1.injector.switchOffSignal1.value = false;
  PV1.injector.switchOffSignal2.value = false;
  PV1.injector.switchOffSignal3.value = false;
  PV2.injector.switchOffSignal1.value = false;
  PV2.injector.switchOffSignal2.value = false;
  PV2.injector.switchOffSignal3.value = false;

  // ── Connessioni elettriche ─────────────────────────────────────
  connect(infiniteBusWithVariations.terminal, line2.terminal2)
    annotation(Line(points = {{0,-94},{0,-40}}, color = {0,0,255}));
  connect(PV1.terminal, line.terminal1)
    annotation(Line(points = {{-48,0},{-38,0}}, color = {0,0,255}));
  connect(line.terminal2, bus.terminal)
    annotation(Line(points = {{-18,0},{0,0}}, color = {0,0,255}));
  connect(line2.terminal1, bus.terminal)
    annotation(Line(points = {{0,-20},{0,0}}, color = {0,0,255}));
  connect(line1.terminal1, bus.terminal)
    annotation(Line(points = {{20,0},{0,0}}, color = {0,0,255}));
  connect(line1.terminal2, PV2.terminal)
    annotation(Line(points = {{40,0},{48,0}}, color = {0,0,255}));

  // ── Segnali PV1 ───────────────────────────────────────────────
  connect(PV1.PRefPu,     PRefPu1.y)
    annotation(Line(points = {{-92,12},{-108,12},{-108,30}}, color = {0,0,127}));
  connect(PV1.QRefPu,     QRefPu1.y)
    annotation(Line(points = {{-92,0},{-108,0}}, color = {0,0,127}));
  connect(omegaRefPu1.y,  PV1.omegaRefPu)
    annotation(Line(points = {{-108,-32},{-92,-32},{-92,-12}}, color = {0,0,127}));
  connect(PFaRef1.y,      PV1.PFaRef)
    annotation(Line(points = {{-70,35},{-70,22}}, color = {0,0,127}));
  connect(URefPu1.y,      PV1.URefPu)
    annotation(Line(points = {{-70,-36},{-70,-22}}, color = {0,0,127}));
  connect(PV1.uPccPu,     uPcc1.y)
    annotation(Line(points = {{-48,14},{-38,14},{-38,31}}, color = {85,170,255}));
  connect(PV1.QPccPu,     PPcc1.y)
    annotation(Line(points = {{-48,10},{-24,10},{-24,18}}, color = {0,0,127}));
  connect(PV1.PPccPu,     PPcc1.y)
    annotation(Line(points = {{-48,6},{-24,6},{-24,18}}, color = {0,0,127}));

  // ── Segnali PV2 ───────────────────────────────────────────────
  connect(PV2.URefPu,     URefPu2.y)
    annotation(Line(points = {{70,22},{70,40}}, color = {0,0,127}));
  connect(PPcc2.y,        PV2.PPccPu)
    annotation(Line(points = {{30,-18},{34,-18},{34,-8},{48,-8},{48,-6}}, color = {0,0,127}));
  connect(PPcc2.y,        PV2.QPccPu)
    annotation(Line(points = {{30,-18},{34,-18},{34,-10},{48,-10}}, color = {0,0,127}));
  connect(PV2.uPccPu,     uPcc2.y)
    annotation(Line(points = {{48,-14},{39,-14},{39,-38},{30,-38}}, color = {85,170,255}));
  connect(PFaRef2.y,      PV2.PFaRef)
    annotation(Line(points = {{70,-45},{70,-22}}, color = {0,0,127}));
  connect(PRefPu2.y,      PV2.PRefPu)
    annotation(Line(points = {{108,-40},{92,-40},{92,-12}}, color = {0,0,127}));
  connect(PV2.omegaRefPu, omegaRefPu2.y)
    annotation(Line(points = {{92,12},{105,12},{105,40}}, color = {0,0,127}));
  connect(PV2.QRefPu,     QRefPu2.y)
    annotation(Line(points = {{92,0},{108,0}}, color = {0,0,127}));

  annotation(
    experiment(
      StartTime = 0,
      StopTime  = 10,
      Tolerance = 1e-6,
      Interval  = 0.0005),
    preferredView = "diagram",
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", nls = "kinsol", noHomotopyOnFirstTry = "()", initialStepSize = "0.00001", maxStepSize = "0.001"),
    Documentation(info = "<html><body>
      <h3>TwoConvertersWECC</h3>
      <p>Parametri controllo: valori ufficiali RTE (esempio PVVoltageSource4).</p>
      <p>PV1 inietta P=+0.5 pu, step a t=5s. PV2 assorbe P=-0.5 pu.</p>
      <p>Differenze rispetto alla versione precedente:</p>
      <ul>
        <li>KpPLL=3, KiPLL=20 (valori RTE)</li>
        <li>FreqFlag=true, PPCLocal=true (loop P attivo)</li>
        <li>Kpg=0.05, Kig=2.36, Ki=1.5 (valori RTE)</li>
        <li>PRefPu2 = PV2.PControl0Pu (non hardcoded)</li>
      </ul>
    </body></html>"));

end TwoConvertersWECC;