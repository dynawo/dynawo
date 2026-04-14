within Dynawo.Electrical.PEIR.Plants.Average;

model test
  /*
   * SMIB test — GFL converter
   * Operating point: P = 0.6 pu, Q = -0.3 pu (capacitive), U_pcc = 1.0 pu
   * Two transformers: LV (Lf+LPuLV = 0.3 pu) + HV (LPuHV = 0.2 pu)
   * Total inductance seen from converter: 0.3 + 0.2 = 0.5 pu
   * Bus infinite: ~0.97 pu (consistent with voltage drop at P=0.6, Q=-0.3)
   * URefPu = U0Pu + Lambda*Q0Pu = 1.0 + 0.2*(-0.3) = 0.94
   */

  GFLmodelnodyn gFLmodelnodyn(
    // ── Initial conditions — PCC node ────────────────────────
    UrPcc0Pu = 1.0,
    UiPcc0Pu = 0.0,
    // Generator convention: positive = injected into grid
    P0_pcc   = -0.6,
    Q0_pcc   = -0.3,
    Omega0Pu = 1.0,

    // ── VSC Pade delay ────────────────────────────────────────
    tVSC = 0.0,

    // ── LC filter ─────────────────────────────────────────────
    RfPu     = 0.001,
    LfPu     = 0.1,
    CfPu     = 0.02,
    omegaNom = 2 * Modelica.Constants.pi * 50,

    // ── LV transformer (filter → LV node) ────────────────────
    RPuLV = 0.005,
    LPuLV = 0.2,

    // ── HV transformer (LV node → PCC) ───────────────────────
    RPuHV = 0.005,
    LPuHV = 0.2,

    // ── Measurement filter ────────────────────────────────────
    k_filter = 1.0,
    T_filter = 0.02,

    // ── Inner current loop ────────────────────────────────────
    // omega_cc = 800 rad/s => bandwidth ~127 Hz
    k_p_d_current = 3.0,
    k_i_d_current = 80.0,
    k_p_q_current = 3.0,
    k_i_q_current = 80.0,

    // ── Outer loop (bandwidth 1-8 Hz — inside SSO range) ─────
    k_p_d_outer = 0.35,
    k_i_d_outer = 10.0,
    k_p_q_outer = 0.30,
    k_i_q_outer = 7.0,

    // ── Current limiter — Iq boost disabled for first test ────
    Imax       = 1.1,
    PQFlag     = true,
    UboostHigh = 1.1,
    UboostLow  = 0.9,
    Kqv        = 0.0,
    IqBoostMax = 0.0,
    IqBoostMin = 0.0,

    // ── Plant controller ──────────────────────────────────────
    K_p_q_plant = 0.1,
    K_i_q_plant = 1.0,
    K_p_p_plant = 0.1,
    K_i_p_plant = 1.0,
    // Lambda = 0.2: URef = U0 + Lambda*Q0 = 1.0 + 0.2*(-0.3) = 0.94
    // URefPu constant below must equal this value
    Lambda      = 0.2,
    Kdroop      = 0.03,
    QMaxPu      = 0.5,
    QMinPu      = -0.5,
    PMaxPu      = 1.2,
    PMinPu      = 0.0,
    FEMaxPu     = 0.05,
    FEMinPu     = -0.05,
    FDbd1Pu     = 0.005,
    FDbd2Pu     = 0.01,
    DbdPu       = 0.005,

    // ── PLL (bandwidth ~49 Hz from table) ─────────────────────
    K_p_pll    = 30.0,
    K_i_pll    = 120.0,
    OmegaMaxPu = 1.05,
    OmegaMinPu = 0.95,
    Theta0     = 0.0,

    // ── Rate limiters and delays ──────────────────────────────
    DyMax_pi_d       = 10.0,
    DyMax_pi_q       = 10.0,
    DuMax_idref      = 10.0,
    DuMin_idref      = -10.0,
    tS_idref         = 1e-4,
    delay_time_plant = 1e-3,

    // ── Voltage feedforward flag ──────────────────────────────
    voltagefeedforwardflag = 1) annotation(
    Placement(transformation(origin = {10, -2}, extent = {{-28, -28}, {28, 28}})));

  // ── Infinite bus ──────────────────────────────────────────────
  // U_bus consistent with voltage drop at P=0.6, Q=-0.3
  // across two transformers: R_tot=0.01, L_tot=0.4 pu
  // |Delta_U| ~ sqrt((R*I)^2 + (X*I)^2) ~ 0.03 pu => U_bus ~ 0.97 pu
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(
    UPu    = 0.97,
    UPhase = 0) annotation(
    Placement(transformation(origin = {74, 2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // PRef = 0.6 pu — constant for first test
  Modelica.Blocks.Sources.Constant PRef(k = 0.6) annotation(
    Placement(transformation(origin = {-62, 32}, extent = {{-10, -10}, {10, 10}})));

  // URef = U0 + Lambda*Q0 = 1.0 + 0.2*(-0.3) = 0.94 pu
  // This MUST equal URef0Pu computed inside the model otherwise PI starts with error
  Modelica.Blocks.Sources.Constant URef(k = 0.94) annotation(
    Placement(transformation(origin = {-64, -2}, extent = {{-10, -10}, {10, 10}})));

  // Frequency reference = nominal
  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-58, -36}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(gFLmodelnodyn.terminalPCC, infiniteBus.terminal) annotation(
    Line(points = {{44, 0}, {59, 0}, {59, 2}, {74, 2}}, color = {0, 0, 255}));
  connect(PRef.y, gFLmodelnodyn.PRefPu) annotation(
    Line(points = {{-51, 32}, {-38.5, 32}, {-38.5, 18}, {-24, 18}}, color = {0, 0, 127}));
  connect(URef.y, gFLmodelnodyn.UREfPu) annotation(
    Line(points = {{-53, -2}, {-24, -2}}, color = {0, 0, 127}));
  connect(omegaRef.y, gFLmodelnodyn.omegaRefPu) annotation(
    Line(points = {{-47, -36}, {-35, -36}, {-35, -18}, {-24, -18}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(
      StartTime = 0,
      StopTime  = 20,
      Tolerance = 1e-6,
      Interval  = 0.0005));

end test;