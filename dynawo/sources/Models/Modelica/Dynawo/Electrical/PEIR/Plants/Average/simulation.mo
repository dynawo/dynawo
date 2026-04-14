within Dynawo.Electrical.PEIR.Plants.Average;

model simulation


  GFLModel gFLModel(
    // ── Condizioni iniziali al PCC ───────────────────────────
    // Tensione iniziale leggermente sopra 1 pu, non 1.18
    UrPcc0Pu = 1.04,
    UiPcc0Pu = 0.0,
    // Potenza attiva vicina al nominale, fattore di potenza quasi unitario
    P0_pcc   = -0.8,
    Q0_pcc   = -0.1,
    Omega0Pu = 1.0,

    // ── Ritardo VSC (Pade) ───────────────────────────────────
    // 3 ms ~ tempo di un paio di periodi di switching "equivalenti"
    tVSC     = 0.003,

    // ── Filtro L-C ───────────────────────────────────────────
    RfPu     = 0.01,
    LfPu     = 0.15,
    CfPu     = 0.02,
    omegaNom = 2*Modelica.Constants.pi*50,

    // ── Trasformatore + rete (weak grid) ─────────────────────
    RPu      = 0.05,
    LPu      = 0.20,

    // ── Filtro di misura ─────────────────────────────────────
    // Finestra di circa 10 ms invece che 20 ms
    k_filter = 1.0,
    T_filter = 0.01,

    // ── Inner current loop (più realistico) ──────────────────
    // Inner loop ancora "forte", ma meno estremo
    k_p_d_current = 2.0,
    k_i_d_current = 150.0,
    k_p_q_current = 2.0,
    k_i_q_current = 150.0,

    // ── Outer P/Q loop (più lento dell’anello di corrente) ──
    // Banda qualche Hz, ben più lenta dell’anello di corrente
    k_p_d_outer = 0.20,
    k_i_d_outer = 5.0,
    k_p_q_outer = 0.18,
    k_i_q_outer = 4.0,
    // ── Current limiter / reactive boost ─────────────────────
    Imax        = 1.1,
    PQFlag      = false,
    UboostHigh  = 1.1,
    UboostLow   = 0.9,
    // Boost meno aggressivo
    Kqv         = 5,
    IqBoostMax  = 0.3,
    IqBoostMin  = -0.3,

    // ── Plant controller (moderato) ──────────────────────────
    K_p_q_plant = 0.05,
    K_i_q_plant = 0.5,
    K_p_p_plant = 0.05,
    K_i_p_plant = 0.5,
    Lambda      = 1.0,
    Kdroop      = 0.03,
    QMaxPu      = 0.4,
    QMinPu      = -0.4,
    PMaxPu      = 1.1,
    PMinPu      = 0.0,
    FEMaxPu     = 0.03,
    FEMinPu     = -0.03,
    FDbd1Pu     = 0.005,
    FDbd2Pu     = 0.01,
    DbdPu       = 0.005,

    // ── PLL (meno “duro”) ────────────────────────────────────
    // PLL più lento (qualche Hz di banda) per una rete debole
    K_p_pll    = 15.0,
    K_i_pll    = 300.0,
    OmegaMaxPu = 1.05,
    OmegaMinPu = 0.95,
    Theta0     = 0.0,

    // ── Slew-rate & ramp limiter anello esterno ──────────────
    DyMax_pi_d       = 5.0,
    DyMax_pi_q       = 5.0,
    DuMax_idref      = 5.0,
    DuMin_idref      = -5.0,
    tS_idref         = 1e-4,
    k_delay_plant    = 1,
    T_delay_plant    = 5e-4); annotation(
    Placement(transformation(origin = {-18, -16}, extent = {{-30, -30}, {30, 30}})));
  Buses.InfiniteBus infiniteBus(UPu = 1, UPhase = 0)  annotation(
    Placement(transformation(origin = {44, 12}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k = 1)  annotation(
    Placement(transformation(origin = {-72, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = 1)  annotation(
    Placement(transformation(origin = {-78, -12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = 0.8)  annotation(
    Placement(transformation(origin = {-84, -56}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(gFLModel.terminal, infiniteBus.terminal) annotation(
    Line(points = {{14, -12}, {29, -12}, {29, 12}, {44, 12}}, color = {0, 0, 255}));
  connect(gFLModel.U_ref_pcc_pu, const.y) annotation(
    Line(points = {{-50, 2}, {-55, 2}, {-55, 26}, {-60, 26}}, color = {0, 0, 127}));
  connect(gFLModel.omegaRefPu, const1.y) annotation(
    Line(points = {{-50, -12}, {-67, -12}}, color = {0, 0, 127}));
  connect(gFLModel.PRefPu, const2.y) annotation(
    Line(points = {{-50, -28}, {-72, -28}, {-72, -56}}, color = {0, 0, 127}));
end simulation;