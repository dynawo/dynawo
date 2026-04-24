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
    P0_pcc   = -0.599658,
    Q0_pcc   = -0.0171959,
    Omega0Pu = 1.0,

    // ── VSC Pade delay ────────────────────────────────────────
    tVSC = 1e-3,

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
    T_filter = 0.002,

    // ── Inner current loop ────────────────────────────────────
    // omega_cc = 800 rad/s => bandwidth ~127 Hz
    k_p_d_current = 30.0,
    k_i_d_current = 800.0,
    k_p_q_current = 30.0,
    k_i_q_current = 800.0,

    // ── Outer loop (bandwidth 1-8 Hz — inside SSO range) ─────
    k_p_d_outer = 1.0,
    k_i_d_outer = 10.0,
    k_p_q_outer = 1.0,
    k_i_q_outer = 7.0,

    // ── Current limiter — Iq boost disabled for first test ────
    Imax       = 1.1,
    PQFlag     = false,
    UboostHigh = 1.1,
    UboostLow  = 0.9,
    Kqv        = 0.3,
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
    PMaxPu      = 0.6,
    PMinPu      = 0,
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
    Placement(transformation(origin = {12, 0}, extent = {{-28, -28}, {28, 28}})));

  // ── Infinite bus ──────────────────────────────────────────────
  // U_bus consistent with voltage drop at P=0.6, Q=-0.3
  // across two transformers: R_tot=0.01, L_tot=0.4 pu
  // |Delta_U| ~ sqrt((R*I)^2 + (X*I)^2) ~ 0.03 pu => U_bus ~ 0.97 pu
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(
    UPu    = 0.97,
    UPhase = 0.033) annotation(
    Placement(transformation(origin = {12, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  // PRef = 0.6 pu — constant for first test
  Modelica.Blocks.Sources.Constant PRef(k = 0.6) annotation(
    Placement(transformation(origin = {-62, 32}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant URef(k = 0.97) annotation(
    Placement(transformation(origin = {-54, 0}, extent = {{-10, -10}, {10, 10}})));
    
  // Frequency reference = nominal
  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-58, -36}, extent = {{-10, -10}, {10, 10}})));
final parameter Real Ur=infiniteBus.UPu*cos(infiniteBus.UPhase);
final parameter Real Ui=infiniteBus.UPu*sin(infiniteBus.UPhase);
final parameter Real Uphase=infiniteBus.UPhase;
  Real Q_instant;
initial algorithm
  gFLmodelnodyn.TrafoLV.iRe := gFLmodelnodyn.TrafoLV.Ir0Pu;
  gFLmodelnodyn.TrafoLV.iIm := gFLmodelnodyn.TrafoLV.Ii0Pu;
  gFLmodelnodyn.TrafoHV.iRe := gFLmodelnodyn.TrafoHV.Ir0Pu;
  gFLmodelnodyn.TrafoHV.iIm := gFLmodelnodyn.TrafoHV.Ii0Pu;


equation
  Q_instant = -(gFLmodelnodyn.terminalPcc.V.im * gFLmodelnodyn.terminalPcc.i.re 
               - gFLmodelnodyn.terminalPcc.V.re * gFLmodelnodyn.terminalPcc.i.im);
  connect(URef.y, gFLmodelnodyn.UREfPu) annotation(
    Line(points = {{-43, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(omegaRef.y, gFLmodelnodyn.omegaRefPu) annotation(
    Line(points = {{-47, -36}, {-35, -36}, {-35, -17}, {-22, -17}}, color = {0, 0, 127}));

  connect(PRef.y, gFLmodelnodyn.PRefPu) annotation(
    Line(points = {{-50, 32}, {-30, 32}, {-30, 20}, {-21, 20}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.terminalPcc, infiniteBus.terminal) annotation(
    Line(points = {{12, -22}, {10, -22}, {10, -62}, {12, -62}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(
      StartTime = 0,
      StopTime  = 20,
      Tolerance = 1e-6,
      Interval  = 0.0005));
      

end test_dyn;