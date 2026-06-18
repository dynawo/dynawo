within Dynawo.Electrical.PEIR.Plants.Average;

model test_dyn

  /*
   * SMIB test — GFL converter
   * Operating point: P = 0.6 pu, Q ~ 0 pu, U_pcc = 1.0047 pu
   *
   * Tuning strategy (bandwidth separation):
   *   - Inner current loop : omega_cc  = 300 rad/s  (~48 Hz)
   *       k_p = omega_cc * L_g = 300 * 0.009 = 2.7
   *       k_i = (omega_cc/10) * k_p = 30 * 2.7 = 81
   *   - Outer loop         : omega_out =  30 rad/s  (~5 Hz)
   *       k_p = 0.3,  k_i = 1.0
   *   - PLL                : omega_pll =  10 rad/s  (~1.6 Hz)
   *       k_p = 10,   k_i = 25
   *   - Plant controller   : omega_plt ~  2 rad/s
   *       k_p = 0.05, k_i = 0.5
   */

  GFLmodel gFLmodelnodyn(
    // ── Initial conditions — PCC node ────────────────────────
    SNom=100,
    U0Pu = 1.0047,
    Uphase= Uphase,
    P0_pcc   = -0.6,
    Q0_pcc   = -0.0016854,
    Omega0Pu = 1.0,

    // ── VSC Pade delay ────────────────────────────────────────
    tVSC = 1e-100,

    // ── LC filter ─────────────────────────────────────────────
    RfPu     = 0.00001,
    LfPu     = 0.001,
    CfPu     = 1e-4,
    omegaNom = 2 * Modelica.Constants.pi * 50,

    // ── LV transformer (filter → LV node) ────────────────────
    RPuLV = 0.00005,
    LPuLV = 0.00008,

    // ── HV transformer (LV node → PCC) ───────────────────────
    RPuHV = 0.00001,
    LPuHV = 0.00005,

    // ── Measurement filter ────────────────────────────────────
    k_filter = 1,
    T_filter = 1e-4,

    // ── Inner current loop ────────────────────────────────────
    // L_g = LfPu + LPuLV = 0.009 pu
    // omega_cc = 300 rad/s
    // k_p = omega_cc * L_g = 2.7
    // k_i = (omega_cc/10) * k_p = 81
    k_p_d_current = 2.7,
    k_i_d_current = 81.0,
    k_p_q_current = 2.7,
    k_i_q_current = 81.0,

    // ── Outer loop ────────────────────────────────────────────
    // omega_out = 30 rad/s (10x below current loop)
    k_p_d_outer = 0.3,
    k_i_d_outer = 1.0,
    k_p_q_outer = 0.3,
    k_i_q_outer = 1.0,

    // ── Current limiter ───────────────────────────────────────
    UboostHigh = 1.1,
    UboostLow  = 0.9,
    Kqv        = 0.3,
    Imax       = 8,
    PQFlag     = false,
    IqBoostMax = 0.5,
    IqBoostMin = -0.5,

    // ── Plant controller ──────────────────────────────────────
    // omega_plt ~ 2 rad/s (very slow, well below outer loop)
    K_p_q_plant = 0.05,
    K_i_q_plant = 0.5,
    K_p_p_plant = 0.05,
    K_i_p_plant = 0.5,

    Lambda      = 0.28,
    Kdroop      = 0.03,
    QMaxPu      = 0.5,
    QMinPu      = -0.5,
    PMaxPu      = 23,
    PMinPu      = 0,
    FEMaxPu     = 0.05,
    FEMinPu     = -0.05,
    FDbd1Pu     = 0.005,
    FDbd2Pu     = 0.01,
    DbdPu       = 0.005,

    // ── PLL ───────────────────────────────────────────────────
    // omega_pll = 10 rad/s (3x below outer loop)
    K_p_pll    = 10.0,
    K_i_pll    = 25.0,
    OmegaMaxPu = 1.05,
    OmegaMinPu = 0.95,
  

    // ── Rate limiters and delays ──────────────────────────────
    DyMax_pi_d       = 10000.0,
    DyMax_pi_q       = 100000.0,
    DuMax_idref      = 10.0,
    DuMin_idref      = -10.0,
    tS_idref         = 1e-4,
    delay_time_plant = 1e-3,

    // ── Voltage feedforward ───────────────────────────────────
    voltagefeedforwardflag_d = 1, voltagefeedforwardflag_q = 1) annotation(
    Placement(transformation(origin = {42, 8}, extent = {{-28, -28}, {28, 28}})));

  Modelica.Blocks.Sources.Constant URef(k = 1.0047) annotation(
    Placement(transformation(origin = {-56, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-58, -36}, extent = {{-10, -10}, {10, 10}})));

  final parameter Real Ur     = 1.0047 * cos(0.033);
  final parameter Real Ui     = 1.0047 * sin(0.033);
  final parameter Real Uphase = 0.033;

  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.6, startTime = 1000) annotation(
    Placement(transformation(origin = {-66, 42}, extent = {{-10, -10}, {10, 10}})));

  Buses.InfiniteBus infiniteBus(UPu = 1.0047, UPhase = 0.033) annotation(
    Placement(transformation(origin = {41, -63}, extent = {{-19, -19}, {19, 19}})));

equation
gFLmodelnodyn.switchOffSignal1.value=false;
gFLmodelnodyn.switchOffSignal2.value=false;
gFLmodelnodyn.switchOffSignal3.value=false;
  connect(omegaRef.y,  gFLmodelnodyn.omegaRefPu) annotation(Line(points = {{-47, -36},{-35, -36},{-35, -9}, {8, -9}},  color = {0, 0, 127}));
  connect(gFLmodelnodyn.terminalPcc, infiniteBus.terminal) annotation(Line(points = {{42, -14}, {42, -62}}, color = {0, 0, 255}));
  connect(gFLmodelnodyn.PRefPu, step.y) annotation(
    Line(points = {{8, 28}, {-54, 28}, {-54, 42}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.UREfPu, URef.y) annotation(
    Line(points = {{8, 8}, {-44, 8}, {-44, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    experiment(
      StartTime = 0,
      StopTime  = 20,
      Tolerance = 1e-6,
      Interval  = 0.0005),
  Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}));

end test_dyn;