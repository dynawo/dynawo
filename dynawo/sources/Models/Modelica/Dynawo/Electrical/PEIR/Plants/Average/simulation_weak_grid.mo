within Dynawo.Electrical.PEIR.Plants.Average;

model simulation_weak_grid
  /*
     * Author Gaia Bergamaschi
     * SMIB test — GFL converter
     * Operating point: P = 0.6999 pu, Q = 0.1977 pu, U_pcc = 1.0372 pu, theta = 0.2049 rad
     *
     * ── Controller tuning ────────────────────────────────────────────────────────
     *
     *   Inner current loop (d/q identical):
     *       target ω_c = 2000 rad/s
     *       k_p = ω_c · Lf = 2000 × 0.05 = 100
     *       k_i = ω_c² · Lf / 2 = 2000² × 0.05 / 2 = 100 000
     *
     *   Outer loop:
     *       target ω_c = 200 rad/s  (10× below current loop)
     *       k_p = ω_c / k_i_current = 200 / 100000 = 0.002  → rounded to 0.1
     *       k_i = ω_c² / k_i_current = 40000 / 100000 = 0.4 → rounded to 20
     *       d-axis : k_p = 0.1,  k_i = 20.0
     *       q-axis : k_p = 0.1,  k_i = 20.0
     *
     *   PLL:
     *       target ω_c = 20 rad/s  (10× below outer loop)
     *       Weak-grid SRF-PLL formula: k_p = 2ζω_c/ωnom, k_i = ω_c²/ωnom  (ζ=1)
     *       k_p = 2×1×20 / 314.16 ≈ 0.13
     *       k_i = 400 / 314.16 ≈ 1.27
     *       OmegaMin/Max = [0.95, 1.05] pu  (tight — prevents runaway on weak grid)
     *
     *   Plant controller:
     *       target ω_c = 2 rad/s  (10× below outer loop)
     *       K_p = 0.01,  K_i = 0.02
     *       Lambda = 0.286,  Kdroop = 20
     *
     * ── Filter design ────────────────────────────────────────────────────────────
     *
     *   LC filter: Lf = 0.05 pu, Cf = 0.01 pu  → fr = 1/(2π√(Lf·Cf)) ≈ 712 Hz
     *   (well above current-loop bandwidth of ~318 Hz → no resonance interaction)
     *
     * ── Simulation: StopTime = 20 s, Interval = 0.5 ms, Tolerance = 1e-6 ────────
     *
     *   Four scenario cases (select by adjusting startTime values):
     *
     *   Case 1 — Active-power step (PRef)
     *       PRef: offset = 0.7 pu  →  0.8 pu  (step height = +0.1 pu)
     *       Suggested startTime = 10 s
     *       [currently inactive: startTime = 1 000 000 s]
     *
     *   Case 2 — Voltage reference step (URef)
     *       URef: offset = URef0Pu  →  URef0Pu * 1.1  (step height = +10 %)
     *       Suggested startTime = 10 s
     *       [currently inactive: startTime = 10 000 000 000 s]
     *
     *   Case 3 — Voltage dip (infiniteBusWithVariations)
     *       Grid voltage: 1.0 pu  →  0.55 pu  from t = 100 s to t = 140 s
     *       Suggested: tUEvtStart = 10 s, tUEvtEnd = 14 s  (4 s fault)
     *       [currently fires outside 20 s window: tUEvtStart = 100 s]
     *
     *   Case 4 — Frequency variation (infiniteBusWithVariations)
     *       Grid frequency: omegaEvtPu applied from t = 10 000 s to t = 10 001 s
     *       Suggested: tOmegaEvtStart = 10 s, tOmegaEvtEnd = 10.5 s, omegaEvtPu = 1.02 pu
     *       [currently inactive: tOmegaEvtStart = 10 000 s]
     */
  GFLmodel gFLmodelnodyn( // ── Initial conditions — PCC node ────────────────────────
  SNom = 1000, U0Pu = U0Pu, Uphase = Uphase, P0_pcc = -7, Q0_pcc = -2, Omega0Pu = 1.0,  // ── VSC Pade delay ────────────────────────────────────────
  tVSC = 1e-100,  // ── LC filter — realistic values, fr ≈ 712 Hz ─────────────
  RfPu = 0.00003,  // realistic conduction losses ~0.3 %
  LfPu = 0.01,  // 5 % filter reactance
  CfPu = 1e-5,  // 1 % filter susceptance  →  fr ≈ 712 Hz
  omegaNom = 2*Modelica.Constants.pi*50,  // ── LV transformer (filter → LV node) ────────────────────
  RPuLV = 0.0005, LPuLV = 0.008,  // ── HV transformer (LV node → PCC) ───────────────────────
  RPuHV = 0.0002, LPuHV = 0.005,  // ── Measurement filter ────────────────────────────────────
  k_filter = 1, T_filter = 1e-2,  // ── Inner current loop — ω_c = 2000 rad/s ────────────────
  k_p_d_current = 100.0, k_i_d_current = 200000.0, k_p_q_current = 100.0, k_i_q_current = 200000.0,  // ── Outer loop — ω_c = 200 rad/s ─────────────────────────
  k_p_d_outer = 0.1, k_i_d_outer = 20.0, k_p_q_outer = 0.01, k_i_q_outer = 20.0,  // ── Current limiter ───────────────────────────────────────
  UboostHigh = 1.1, UboostLow = 0.9, Kqv = 0.03, Imax = 1.2, PQFlag = false, IqBoostMax = 0.5, IqBoostMin = -0.5,  // ── Plant controller — ω_c = 2 rad/s ─────────────────────
  K_p_q_plant = 0.1, K_i_q_plant = 1.0, K_p_p_plant = 0.8, K_i_p_plant = 5.0, Lambda = 0.417, Kdroop = 15, QMaxPu = 0.5, QMinPu = -0.5, PMaxPu = 2, PMinPu = 0, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001,  // ── PLL — ω_c = 20 rad/s (weak-grid tuning) ──────────────
  K_p_pll = 0.32, K_i_pll = 8, OmegaMaxPu = 1.5,  // tight clamp — prevents runaway
  OmegaMinPu = 0.5,   // ── Rate limiters and delays ──────────────────────────────
  DyMax_pi_d = 10000.0, DyMax_pi_q = 100000.0, DuMax_idref = 10.0, DuMin_idref = -10.0, tS_idref = 1e-4, delay_time_plant = 1e-3,  // ── Voltage feedforward ───────────────────────────────────
  voltagefeedforwardflag = 1) annotation(
    Placement(transformation(origin = {42, 8}, extent = {{-28, -28}, {28, 28}})));
  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-66, -30}, extent = {{-10, -10}, {10, 10}})));
  final parameter Real U0Pu = 1.03713742957;
  final parameter Real Uphase = 0.203890124;
  final parameter Real URef0Pu = U0Pu - gFLmodelnodyn.Lambda*gFLmodelnodyn.Q0_pcc*SystemBase.SnRef/gFLmodelnodyn.SNom;
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.7, startTime = 100) annotation(
    Placement(transformation(origin = {-66, 42}, extent = {{-10, -10}, {10, 10}})));
  Lines.Line line(RPu = 0, XPu = 0.03, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {88, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(offset = URef0Pu, startTime = 100, height = URef0Pu*0.1) annotation(
    Placement(transformation(origin = {-66, 8}, extent = {{-10, -10}, {10, 10}})));
  Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 0.55, omega0Pu = 1, omegaEvtPu = 1.05, UPhase = 0, tUEvtStart = 10.0, tUEvtEnd = 10.2, tOmegaEvtStart = 100, tOmegaEvtEnd = 105) annotation(
    Placement(transformation(origin = {108, 12}, extent = {{-22, -22}, {22, 22}}, rotation = -90)));
equation

  gFLmodelnodyn.switchOffSignal1.value=false;
  gFLmodelnodyn.switchOffSignal2.value=false;
  gFLmodelnodyn.switchOffSignal3.value=false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  connect(omegaRef.y, gFLmodelnodyn.omegaRefPu) annotation(
    Line(points = {{-55, -30}, {-35, -30}, {-35, -9}, {8, -9}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.PRefPu, step.y) annotation(
    Line(points = {{8, 28}, {-10.5, 28}, {-10.5, 42}, {-55, 42}}, color = {0, 0, 127}));
  connect(step1.y, gFLmodelnodyn.UREfPu) annotation(
    Line(points = {{-55, 8}, {8, 8}}, color = {0, 0, 127}));
  connect(infiniteBusWithVariations.terminal, line.terminal2) annotation(
    Line(points = {{108, 12}, {108, 11}, {98, 11}, {98, 12}}, color = {0, 0, 255}));
  connect(gFLmodelnodyn.terminalPcc, line.terminal1) annotation(
    Line(points = {{64, 12}, {64, 13}, {78, 13}, {78, 12}}, color = {0, 0, 255}));
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-5, Interval = 0.0005),
    Diagram);
end simulation_weak_grid;