within Dynawo.Electrical.PEIR.Plants.Average;

model test_dyn

  /*
   * SMIB test — GFL converter
   * Operating point: P = 0.6 pu, Q = -0.3 pu (capacitive), U_pcc = 1.0 pu
   * Two transformers: LV (Lf+LPuLV = 0.3 pu) + HV (LPuHV = 0.2 pu)
   * Total inductance seen from converter: 0.3 + 0.2 = 0.5 pu
   * Bus infinite: ~0.97 pu (consistent with voltage drop at P=0.6, Q=-0.3)
   * URefPu = U0Pu + Lambda*Q0Pu = 1.0 + 0.2*(-0.3) = 0.94
   */

  GFLmodel gFLmodelnodyn(
    // ── Initial conditions — PCC node ────────────────────────
    UrPcc0Pu = Ur,
    UiPcc0Pu = Ui,
    // Generator convention: positive = injected into grid
    P0_pcc   = -0.6,
    Q0_pcc   = -0.016854,
    Omega0Pu = 1.0,

    // ── VSC Pade delay ────────────────────────────────────────
    tVSC = 1e-30,

    // ── LC filter ─────────────────────────────────────────────
    RfPu     = 0.00001,
    LfPu     = 0.001,
    CfPu     = 1e-6,
    omegaNom = 2 * Modelica.Constants.pi * 50,

    // ── LV transformer (filter → LV node) ────────────────────
    RPuLV = 0.005,
    LPuLV = 0.008,

    // ── HV transformer (LV node → PCC) ───────────────────────
    RPuHV = 0.001,
    LPuHV = 0.005,

    // ── Measurement filter ────────────────────────────────────
    k_filter = 1,
    T_filter =1e-6,

    // ── Inner current loop ────────────────────────────────────
    // omega_cc = 800 rad/s => bandwidth ~127 Hz
    k_p_d_current = 30.0,
    k_i_d_current = 80.0,
    k_p_q_current = 30.0,
    k_i_q_current = 80.0,

    // ── Outer loop (bandwidth 1-8 Hz — inside SSO range) ─────
    k_p_d_outer = 1.0,
    k_i_d_outer = 10.0,
    k_p_q_outer = 1.0,
    k_i_q_outer = 7.0,

    // ── Current limiter — Iq boost disabled for first test ────
    UboostHigh = 1.1,
    UboostLow  = 0.9,
    Kqv        = 0.3,
    Imax       = 8,
    PQFlag     = false,
    IqBoostMax = 0.5,
    IqBoostMin = -0.5,

    // ── Plant controller ──────────────────────────────────────
    K_p_q_plant = 0.1,
    K_i_q_plant = 5,
    K_p_p_plant = 0.1,
    K_i_p_plant = 5,

    // URefPu constant below must equal this value
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

    // ── PLL (bandwidth ~49 Hz from table) ─────────────────────
    K_p_pll    = 3.0,
    K_i_pll    = 12.0,
    OmegaMaxPu = 1.05,
    OmegaMinPu = 0.95,
    Theta0     = Uphase,

    // ── Rate limiters and delays ──────────────────────────────
    DyMax_pi_d       = 10000.0,
    DyMax_pi_q       = 100000.0,
    DuMax_idref      = 10.0,
    DuMin_idref      = -10.0,
    tS_idref         = 1e-4,
    delay_time_plant = 1e-6,

    // ── Voltage feedforward flag ──────────────────────────────
    voltagefeedforwardflag = 1) annotation(
    Placement(transformation(origin = {42, 8}, extent = {{-28, -28}, {28, 28}})));

// ── Infinite bus ──────────────────────────────────────────────
  // U_bus consistent with voltage drop at P=0.6, Q=-0.3
  // across two transformers: R_tot=0.01, L_tot=0.4 pu
  // |Delta_U| ~ sqrt((R*I)^2 + (X*I)^2) ~ 0.03 pu => U_bus ~ 0.97 pu
  // PRef = 0.6 pu — constant for first test
  Modelica.Blocks.Sources.Constant URef(k = 1.0047) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}})));
    
  // Frequency reference = nominal
  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-58, -36}, extent = {{-10, -10}, {10, 10}})));
final parameter Real Ur=1.0047*cos(0.033);
final parameter Real Ui=1.0047*sin(0.033);
final parameter Real Uphase=0.033;

  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.6, startTime = 10)  annotation(
    Placement(transformation(origin = {-48, 36}, extent = {{-10, -10}, {10, 10}})));
    Buses.InfiniteBus infiniteBus(UPu = 1.0047, UPhase = 0.033)  annotation(
    Placement(transformation(origin = {41, -63}, extent = {{-19, -19}, {19, 19}})));
equation
  connect(URef.y, gFLmodelnodyn.UREfPu) annotation(
    Line(points = {{-69, 0}, {-24.5, 0}, {-24.5, 8}, {8, 8}}, color = {0, 0, 127}));
  connect(omegaRef.y, gFLmodelnodyn.omegaRefPu) annotation(
    Line(points = {{-47, -36}, {-35, -36}, {-35, -9}, {8, -9}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.PRefPu, step.y) annotation(
    Line(points = {{9, 28}, {9, 26}, {-37, 26}, {-37, 36}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.terminalPcc, infiniteBus.terminal) annotation(
    Line(points = {{42, -14}, {42, -62}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(
      StartTime = 0,
      StopTime  = 20,
      Tolerance = 1e-6,
      Interval  = 0.0005));
      

end test_dyn;